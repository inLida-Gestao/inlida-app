import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void _syncLog(String flow, String message) {
  // Atualiza heartbeat a cada log — permite watchdogs externos detectarem
  // stall (nenhum progresso por N segundos).
  FFAppState().lastSyncHeartbeat = DateTime.now();
  debugPrint('[SYNC][$flow] $message');
}

String? _descreverRebanhoBy(String? numero) {
  if (numero == null || numero.isEmpty) return null;
  return 'Animal nº $numero';
}

String? _descreverReproducaoBy(String? data) {
  if (data == null || data.isEmpty) return null;
  return 'Inseminação em $data';
}

/// Marca como resolvidos os erros pendentes de um registro específico
/// quando seu PUT/UPDATE volta a funcionar.
void _markSyncOk(String modulo, String? registroId) {
  if (registroId == null) return;
  // ignore: discarded_futures
  actions.SyncErrorLog.autoResolverPorRegistro(modulo, registroId);
}

/// Registra erro tanto no log textual (debugPrint) quanto na auditoria
/// persistente (SyncErrorLog) para que o usuário veja na UI.
/// Use em qualquer catch de PUT/UPDATE/INSERT remoto.
void _recordSyncError({
  required String flow,
  required String modulo,
  required String operacao,
  required Object erro,
  String? registroId,
  String? registroDescricao,
  Map<String, dynamic>? payload,
}) {
  _syncLog(flow,
      'ERRO ${operacao} ${modulo} id=${registroId ?? "?"}: $erro');
  // Fire-and-forget — não awaita pra não atrasar o loop principal.
  // ignore: discarded_futures
  actions.SyncErrorLog.registrar(
    modulo: modulo,
    operacao: operacao,
    registroId: registroId,
    registroDescricao: registroDescricao,
    erro: erro,
    payload: payload,
  );
}

/// Lança SyncCancelledException se o usuário pediu cancelamento.
/// Chamar antes de cada round-trip em loops longos.
class SyncCancelledException implements Exception {
  final String reason;
  SyncCancelledException([this.reason = 'cancelado pelo usuário']);
  @override
  String toString() => 'SyncCancelledException: $reason';
}

void _throwIfCancelled(String flow) {
  if (FFAppState().syncCancelRequested) {
    _syncLog(flow, 'Cancelamento solicitado — interrompendo loop.');
    throw SyncCancelledException();
  }
}

/// Faz upsert em lote via PostgREST (1 request para N registros).
/// Usa onConflict para idempotência — retries após falha parcial não
/// duplicam registros.
Future<void> _batchUpsertSupabase({
  required String tableName,
  required List<Map<String, dynamic>> rows,
  required String onConflict,
  int chunkSize = 200,
  required String label,
}) async {
  if (rows.isEmpty) return;
  for (var start = 0; start < rows.length; start += chunkSize) {
    _throwIfCancelled(label);
    final end =
        (start + chunkSize < rows.length) ? start + chunkSize : rows.length;
    final chunk = rows.sublist(start, end);
    await _withTimeout(
      () => SupaFlow.client
          .from(tableName)
          .upsert(chunk, onConflict: onConflict),
      label: '$label.upsert(chunk=${chunk.length}, onConflict=$onConflict)',
      timeout: kSyncPageTimeout,
    );
    _syncLog(label,
        'Upsert ok: ${chunk.length} registro(s) (offset=$start/${rows.length}).');
  }
}

// ============================================================================
// Timeouts e retry para chamadas de rede do sync.
//
// Motivação: antes destes wrappers, qualquer request ao Supabase que travasse
// (TCP stale após reconexão, token expirado, servidor lento) pendurava o loop
// de sync indefinidamente — o usuário via o spinner rodar por 20+ minutos.
// ============================================================================

/// Timeout padrão para chamadas unitárias (1 registro, 1 query leve).
const Duration kSyncUnitTimeout = Duration(seconds: 20);

/// Timeout para chamadas de página / bulk (podem trazer muitos registros).
const Duration kSyncPageTimeout = Duration(seconds: 45);

/// Timeout para consultas ao change tracker / ping de conectividade.
const Duration kSyncLightTimeout = Duration(seconds: 10);

/// Tempo total máximo de uma sessão de sync (watchdog global).
const Duration kSyncTotalBudget = Duration(minutes: 3);

/// B5 — Page size adaptativo por tipo de conexão.
///
/// Em rede WiFi/cabeada usamos 999 (mantém comportamento atual e
/// minimiza round-trips). Em rede móvel reduzimos para 250: requests
/// menores têm muito menos chance de timeout em 3G/4G instável.
///
/// Faz uma checagem síncrona via [Connectivity] (cacheada por 30s) e
/// nunca lança — em qualquer dúvida retorna 999 (comportamento original).
int _cachedPageSize = 999;
DateTime? _cachedPageSizeAt;

Future<int> _adaptivePageSize() async {
  final now = DateTime.now();
  if (_cachedPageSizeAt != null &&
      now.difference(_cachedPageSizeAt!) < const Duration(seconds: 30)) {
    return _cachedPageSize;
  }
  try {
    final conn = await Connectivity().checkConnectivity();
    final isMobile = (conn is List)
        ? (conn as List).contains(ConnectivityResult.mobile)
        : conn == ConnectivityResult.mobile;
    _cachedPageSize = isMobile ? 250 : 999;
    _cachedPageSizeAt = now;
  } catch (_) {
    _cachedPageSize = 999;
    _cachedPageSizeAt = now;
  }
  return _cachedPageSize;
}

/// B6 — Telemetria leve em memória (acessível via tela de diagnóstico).
///
/// Mantém um buffer circular de eventos recentes para diagnóstico ao vivo.
/// Não usa SQLite para evitar I/O extra durante o próprio sync.
class SyncTelemetry {
  static const int _maxEvents = 200;
  static final List<SyncTelemetryEvent> _events = [];

  static void log({
    required String flow,
    required String message,
    int? elapsedMs,
    bool isError = false,
  }) {
    if (_events.length >= _maxEvents) {
      _events.removeAt(0);
    }
    _events.add(SyncTelemetryEvent(
      timestamp: DateTime.now(),
      flow: flow,
      message: message,
      elapsedMs: elapsedMs,
      isError: isError,
    ));
  }

  static List<SyncTelemetryEvent> snapshot() => List.unmodifiable(_events);
  static void clear() => _events.clear();
}

class SyncTelemetryEvent {
  final DateTime timestamp;
  final String flow;
  final String message;
  final int? elapsedMs;
  final bool isError;

  SyncTelemetryEvent({
    required this.timestamp,
    required this.flow,
    required this.message,
    this.elapsedMs,
    this.isError = false,
  });
}

/// Envolve um Future em um timeout, registrando tempo decorrido e erro/label.
/// Em caso de timeout, lança TimeoutException com uma mensagem informativa.
Future<T> _withTimeout<T>(
  Future<T> Function() action, {
  required String label,
  Duration timeout = kSyncUnitTimeout,
}) {
  final stopwatch = Stopwatch()..start();
  return action().timeout(
    timeout,
    onTimeout: () {
      stopwatch.stop();
      _syncLog('timeout',
          '$label estourou após ${stopwatch.elapsedMilliseconds}ms (limite ${timeout.inSeconds}s)');
      SyncTelemetry.log(
        flow: 'timeout',
        message: '$label estourou (limite ${timeout.inSeconds}s)',
        elapsedMs: stopwatch.elapsedMilliseconds,
        isError: true,
      );
      throw TimeoutException(
          'Timeout em "$label" após ${timeout.inSeconds}s');
    },
  ).then((value) {
    stopwatch.stop();
    // B6: registra cada operação na telemetria para a tela de diagnóstico.
    SyncTelemetry.log(
      flow: 'op',
      message: label,
      elapsedMs: stopwatch.elapsedMilliseconds,
    );
    // Apenas loga latências altas para não poluir logs normais.
    if (stopwatch.elapsedMilliseconds > 3000) {
      _syncLog('latency',
          '$label ok em ${stopwatch.elapsedMilliseconds}ms');
    }
    return value;
  });
}

/// Executa [action] com retry exponencial em erros transitórios.
/// Não tenta novamente em TimeoutException quando [retryOnTimeout] é false
/// (default true — timeouts no sync geralmente valem uma retry).
Future<T> _retry<T>(
  Future<T> Function() action, {
  required String label,
  int maxAttempts = 3,
  Duration baseDelay = const Duration(seconds: 2),
  bool retryOnTimeout = true,
}) async {
  var attempt = 0;
  Object? lastError;
  StackTrace? lastStack;
  while (attempt < maxAttempts) {
    attempt++;
    try {
      return await action();
    } on TimeoutException catch (e, s) {
      lastError = e;
      lastStack = s;
      if (!retryOnTimeout || attempt >= maxAttempts) break;
    } catch (e, s) {
      lastError = e;
      lastStack = s;
      // Heurística simples: 4xx ou erros de payload não devem ser retriados.
      final msg = e.toString().toLowerCase();
      final isClientError = msg.contains('status 4') ||
          msg.contains('bad request') ||
          msg.contains('foreign key') ||
          msg.contains('unique constraint');
      if (isClientError || attempt >= maxAttempts) break;
    }
    final delayMs =
        baseDelay.inMilliseconds * (1 << (attempt - 1)); // 2s, 4s, 8s...
    _syncLog('retry',
        '$label tentativa $attempt falhou, aguardando ${delayMs}ms antes de nova tentativa.');
    await Future.delayed(Duration(milliseconds: delayMs));
  }
  _syncLog('retry', '$label desistiu após $attempt tentativa(s): $lastError');
  if (lastError is Error) {
    throw lastError;
  }
  // Preserva stack se possível.
  Error.throwWithStackTrace(
      lastError ?? StateError('retry falhou em $label'),
      lastStack ?? StackTrace.current);
}

int _safeTotalFromApi(dynamic body) {
  if (body == null) return 0;
  if (body is num) return body.toInt();
  if (body is String) return int.tryParse(body.trim()) ?? 0;

  if (body is List && body.isNotEmpty) {
    return _safeTotalFromApi(body.first);
  }

  if (body is Map) {
    for (final key in const ['total', 'count', 'qtd', 'qtde', 'value']) {
      if (body.containsKey(key)) {
        return _safeTotalFromApi(body[key]);
      }
    }
  }

  return 0;
}

List<dynamic> _safeRecordsFromApi(dynamic body) {
  if (body is List) return List<dynamic>.from(body);
  if (body is Map && body['data'] is List) {
    return List<dynamic>.from(body['data'] as List);
  }
  return <dynamic>[];
}

List<String> _safePropertyIds(dynamic body) {
  if (body is! List) return <String>[];

  return body
      .map<PropriedadesStruct?>(PropriedadesStruct.maybeFromMap)
      .whereType<PropriedadesStruct>()
      .map((e) => e.idPropriedade)
      .whereType<String>()
      .where((e) => e.isNotEmpty)
      .toList();
}

String _buildSupabaseInFilter(List<String> values) {
  final sanitized = values.where((e) => e.isNotEmpty).toList();
  return '(${sanitized.join(',')})';
}

int _safeTotalFromContentRange(Map<String, String> headers) {
  final contentRange = headers['content-range'] ?? headers['Content-Range'];
  if (contentRange == null || contentRange.isEmpty) return 0;

  final parts = contentRange.split('/');
  if (parts.length < 2) return 0;

  return int.tryParse(parts.last.trim()) ?? 0;
}

/// Verifica se uma tabela local está vazia ou quase vazia.
Future<bool> _isLocalTableEmpty(String tableName) async {
  try {
    final db = SQLiteManager.instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as cnt FROM $tableName LIMIT 1');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count <= 5;
  } catch (e) {
    _syncLog('helper', 'Erro ao verificar tabela $tableName: $e');
    return true;
  }
}

/// Verifica se o localLastChange indica que nunca houve sync real.
bool _isFirstSync(DateTime? localLastChange) {
  if (localLastChange == null) return true;
  return localLastChange.isBefore(DateTime(2025, 1, 1));
}

Future<ApiCallResponse> _buscarPesagensDireto({
  required List<String> propertyIds,
  required int limit,
  required int offset,
  bool includeCount = false,
  String? updatedAfter,
}) {
  final headers = <String, dynamic>{
    ...SupabaseFunctionsGroup.headers,
    if (includeCount) 'Prefer': 'count=exact',
  };

  return ApiManager.instance.makeApiCall(
    callName: 'Buscar Pesagens Direto',
    apiUrl:
        '${SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '')}/historico_pesagens',
    callType: ApiCallType.GET,
    headers: headers,
    params: {
      'select': '*',
      'id_propriedade': 'in.${_buildSupabaseInFilter(propertyIds)}',
      if (updatedAfter != null) 'updated_at': 'gt.$updatedAfter',
      'order': 'id.asc',
      'limit': limit,
      'offset': offset,
    },
    returnBody: true,
    encodeBodyUtf8: false,
    decodeUtf8: false,
    cache: false,
    isStreamingApi: false,
    alwaysAllowBody: false,
  );
}

/// Busca pesagens onde id_propriedade é NULL, filtrando por idRebanho do
/// usuário para evitar trazer registros de outros usuários.
Future<ApiCallResponse> _buscarPesagensSemPropriedade({
  required List<String> rebanhoIds,
  required int limit,
  required int offset,
}) {
  return ApiManager.instance.makeApiCall(
    callName: 'Buscar Pesagens sem Propriedade',
    apiUrl:
        '${SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '')}/historico_pesagens',
    callType: ApiCallType.GET,
    headers: SupabaseFunctionsGroup.headers,
    params: {
      'select': '*',
      'id_propriedade': 'is.null',
      'idRebanho': 'in.${_buildSupabaseInFilter(rebanhoIds)}',
      'order': 'id.asc',
      'limit': limit,
      'offset': offset,
    },
    returnBody: true,
    encodeBodyUtf8: false,
    decodeUtf8: false,
    cache: false,
    isStreamingApi: false,
    alwaysAllowBody: false,
  );
}

/// Retorna os idRebanho de todos os animais locais não deletados.
Future<List<String>> _getLocalRebanhoIds() async {
  try {
    final db = SQLiteManager.instance.database;
    final rows = await db.rawQuery(
      "SELECT idRebanho FROM local_rebanho WHERE deletado = 'NAO' OR deletado IS NULL OR deletado = ''",
    );
    return rows
        .map((r) => r['idRebanho']?.toString())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toList();
  } catch (e) {
    _syncLog('pesagens', 'Erro ao buscar rebanho IDs locais: $e');
    return <String>[];
  }
}

/// Exibe um popup com a lista de registros que falharam durante a sincronização.
Future<void> _showSyncErrorsDialog(
  BuildContext context,
  String flowName,
  List<Map<String, String>> errors,
) async {
  if (errors.isEmpty) return;
  if (!context.mounted) return;

  try {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Erros na sincronização - $flowName',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${errors.length} registro(s) com erro:',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: errors.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final err = errors[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${err['id'] ?? '-'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            err['error'] ?? 'Erro desconhecido',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
    debugPrint('[SYNC] Não foi possível exibir popup de erros: $e');
  }
}

Future refreshPropriedades(BuildContext context) async {
  try {
    List<PropriedadesChangeTrackerRow>? lastChangeResult;
    ApiCallResponse? propriedade;

    try {
      lastChangeResult = await PropriedadesChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e) {
      _syncLog('propriedades', 'ERRO ao consultar change tracker: $e');
      lastChangeResult = [];
    }
    final remoteLastChange = lastChangeResult.firstOrNull?.lastChange;
    final localLastChange = FFAppState().propriedadesChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('propriedades',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');
    if (shouldSync) {
      // Sync incremental: se já sincronizou antes, busca apenas atualizados
      final localEmpty = await _isLocalTableEmpty('local_propriedades');
      final firstSync = _isFirstSync(localLastChange);
      if (localLastChange != null && !localEmpty && !firstSync) {
        final updatedAfter = localLastChange.toUtc().toIso8601String();
        propriedade =
            await SupabaseFunctionsGroup.buscarPropriedadesUserIncCall.call(
          pUserId: currentUserUid,
          pUpdatedAfter: updatedAfter,
        );
      } else {
        propriedade =
            await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
          pUserId: currentUserUid,
        );
      }

      final jsonBody = propriedade.jsonBody;
      final rawList = jsonBody is List ? jsonBody : <dynamic>[];
      final propriedadesList = (rawList
              .map<PropriedadesStruct?>(PropriedadesStruct.maybeFromMap)
              .toList() as Iterable<PropriedadesStruct?>)
          .withoutNulls;

      if (propriedadesList.isEmpty) {
        _syncLog(
            'propriedades', 'Download retornou vazio. Mantendo dados locais.');
        FFAppState().propriedadesChangeDateTime =
            remoteLastChange ?? DateTime.now();
        return;
      }

      // Converter para lista de maps para batch insert
      final records = <Map<String, dynamic>>[];
      for (final prop in propriedadesList) {
        records.add({
          'userID': prop.userID,
          'anotacoes': prop.anotacoes,
          'areaAgricultura': prop.areaAgricultura,
          'areaBenfeitoria': prop.areaBenfeitoria,
          'areaPastagem': prop.areaPastagem,
          'areaReserva': prop.areaReserva,
          'areaTotal': prop.areaTotal,
          'cidade': prop.cidade,
          'estado': prop.estado,
          'icone': prop.icone,
          'idPropriedade': prop.idPropriedade,
          'atividades': prop.atividades,
          'nome': prop.nome,
          'updated_at': dateTimeFormat(
            "yyyy-MM-dd HH:mm:ss",
            functions.remover3hs(functions.converterTimestamp(prop.updatedAt)),
            locale: FFLocalizations.of(context).languageCode,
          ),
          'created_at': dateTimeFormat(
            "yyyy-MM-dd  HH:mm:ss",
            functions.remover3hs(functions.converterTimestamp(prop.createdAt)),
            locale: FFLocalizations.of(context).languageCode,
          ),
          'usersID': prop.usersID,
          'rebanhosID': prop.rebanhosID,
          'deletado': prop.deletado,
        });
      }

      // Na primeira sync, deleta ANTES para limpar dados locais obsoletos
      // No incremental, mantém dados locais e faz UPSERT
      if (firstSync || localEmpty) {
        // Tenta inserir primeiro em tabela temporária mental — se batch falhar,
        // não perdemos os dados existentes
        final result = await actions.batchInsertLocalPropriedades(records);
        final insertedCount = result['inserted'] as int? ?? 0;
        final insertErrors = result['errors'] as List<Map<String, String>>? ?? [];
        if (insertedCount == 0 && records.isNotEmpty) {
          _syncLog('propriedades',
              'Batch insert falhou completamente (${insertErrors.length} erros). Mantendo dados locais.');
          return;
        }
        // Só deleta se o insert teve sucesso (pelo menos parcial)
        // O UPSERT (ConflictAlgorithm.replace) já garante que dados novos sobrescrevem antigos
        _syncLog('propriedades', 'Primeiro sync: $insertedCount registros inseridos via UPSERT.');
      } else {
        _syncLog('propriedades',
            'Sync incremental — mantendo dados locais (UPSERT).');
        await actions.batchInsertLocalPropriedades(records);
      }

      FFAppState().propriedadesChangeDateTime =
          remoteLastChange ?? DateTime.now();
      FFAppState().propriedadesIndex = 0;
      _syncLog('propriedades', 'Sincronização de propriedades concluída.');
    } else {
      _syncLog('propriedades', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog(
        'propriedades', 'ERRO FATAL na sincronização de propriedades: $e\n$s');
  }
}

Future<bool> putUpdtPropriedades(BuildContext context) async {
  var allSuccess = true;
  try {
    List<BuscaPropriedadesPUTRow>? localPropriedades;
    List<BuscaPropriedadesUPDATEDRow>? localPropriedadesUPT;

    if (FFAppState().dataDadosNaoSyncProp != null) {
      localPropriedades = await SQLiteManager.instance.buscaPropriedadesPUT(
        datePUT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncProp,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localPropriedades.isNotEmpty) {
        while (FFAppState().propriedadesIndex < localPropriedades.length) {
          _throwIfCancelled('putUpdt_propriedades');
          try {
            await PropriedadesTable().insert({
              'userID': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.userID,
              'anotacoes': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.anotacoes,
              'areaAgricultura': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaAgricultura,
              'areaBenfeitoria': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaBenfeitoria,
              'areaPastagem': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaPastagem,
              'areaReserva': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaReserva,
              'areaTotal': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaTotal,
              'cidade': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.cidade,
              'estado': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.estado,
              'icone': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.icone,
              'idPropriedade': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.idPropriedade,
              'nome': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.nome,
              'usersID': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.usersID,
              'rebanhosID': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.rebanhosID,
              'atividades': localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.atividades,
            });
            _markSyncOk(
                'propriedade',
                localPropriedades
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.idPropriedade);
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtPropriedades',
              modulo: 'propriedade',
              operacao: 'insert',
              erro: e,
              registroId: localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.idPropriedade,
              registroDescricao: localPropriedades
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.nome,
            );
          }
          FFAppState().propriedadesIndex = FFAppState().propriedadesIndex + 1;
        }
      }
      FFAppState().propriedadesIndex = 0;
      localPropriedadesUPT =
          await SQLiteManager.instance.buscaPropriedadesUPDATED(
        dateUPT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncProp,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      // A4 dedupe PUT/UPDT: remove registros recém-inseridos.
      if (localPropriedades.isNotEmpty) {
        final insertedIds = localPropriedades
            .map((r) => r.idPropriedade)
            .toSet();
        if (insertedIds.isNotEmpty) {
          final before = localPropriedadesUPT.length;
          localPropriedadesUPT = localPropriedadesUPT
              .where((r) => !insertedIds.contains(r.idPropriedade))
              .toList();
          final removed = before - localPropriedadesUPT.length;
          if (removed > 0) {
            _syncLog('putUpdtPropriedades',
                'Dedupe PUT/UPDT: $removed registro(s) removidos do UPDATE.');
          }
        }
      }
      if (localPropriedadesUPT.isNotEmpty) {
        while (FFAppState().propriedadesIndex < localPropriedadesUPT.length) {
          _throwIfCancelled('putUpdt_propriedades');
          try {
            await PropriedadesTable().update(
              data: {
                'anotacoes': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.anotacoes,
                'areaAgricultura': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.areaAgricultura,
                'areaBenfeitoria': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.areaBenfeitoria,
                'areaPastagem': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.areaPastagem,
                'areaReserva': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.areaReserva,
                'areaTotal': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.areaTotal,
                'cidade': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.cidade,
                'estado': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.estado,
                'icone': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.icone,
                'atividades': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.atividades,
                'nome': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.nome,
                'usersID': localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.usersID,
              },
              matchingRows: (rows) => rows.eqOrNull(
                'idPropriedade',
                localPropriedadesUPT
                    ?.elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.idPropriedade,
              ),
            );
            _markSyncOk(
                'propriedade',
                localPropriedadesUPT
                    .elementAtOrNull(FFAppState().propriedadesIndex)
                    ?.idPropriedade);
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtPropriedades',
              modulo: 'propriedade',
              operacao: 'update',
              erro: e,
              registroId: localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.idPropriedade,
              registroDescricao: localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.nome,
            );
          }
          FFAppState().propriedadesIndex = FFAppState().propriedadesIndex + 1;
        }
      }
      FFAppState().propriedadesIndex = 0;
    }
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtPropriedades', 'ERRO no upload de propriedades: $e\n$s');
  }
  return allSuccess;
}

Future buscaPropriedade(
  BuildContext context, {
  String? idPropriedade,
}) async {
  List<BuscaPropriedadeRow>? actBuscaPropriedade;
  bool? temNet;
  List<UsersPropriedadesRow>? usersProp;

  actBuscaPropriedade = await SQLiteManager.instance.buscaPropriedade(
    idPropriedade: idPropriedade,
  );
  FFAppState().updatePropriedadeBuscadaStruct(
    (e) => e
      ..nome = actBuscaPropriedade?.firstOrNull?.nome
      ..idPropriedade = idPropriedade
      ..usersID = actBuscaPropriedade?.firstOrNull?.usersID
      ..anotacoes = actBuscaPropriedade?.firstOrNull?.anotacoes
      ..areaAgricultura = actBuscaPropriedade?.firstOrNull?.areaAgricultura
      ..areaBenfeitoria = actBuscaPropriedade?.firstOrNull?.areaBenfeitoria
      ..areaPastagem = actBuscaPropriedade?.firstOrNull?.areaPastagem
      ..areaReserva = actBuscaPropriedade?.firstOrNull?.areaReserva
      ..areaTotal = actBuscaPropriedade?.firstOrNull?.areaTotal
      ..cidade = actBuscaPropriedade?.firstOrNull?.cidade
      ..estado = actBuscaPropriedade?.firstOrNull?.estado
      ..icone = actBuscaPropriedade?.firstOrNull?.icone
      ..atividades = actBuscaPropriedade?.firstOrNull?.atividades
      ..userID = actBuscaPropriedade?.firstOrNull?.userID,
  );
  temNet = await actions.checkInternetConnection();
  if (temNet == true) {
    FFAppState().usersPropriedade = [];
    usersProp = await UsersPropriedadesTable().queryRows(
      queryFn: (q) => q
          .eqOrNull(
            'idPropriedade',
            idPropriedade,
          )
          .eqOrNull(
            'deletado',
            'NAO',
          ),
    );
    while (FFAppState().usersPropIndex < usersProp.length) {
      FFAppState().addToUsersPropriedade(UsersPropriedadeStruct(
        userId: usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.userId,
        nome: usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.nome,
        email: usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.email,
        foto: usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.foto,
        permissao:
            usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.permissao,
        idPropriedade: usersProp
            .elementAtOrNull(FFAppState().usersPropIndex)
            ?.idPropriedade,
        deletado:
            usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.deletado,
      ));
      FFAppState().usersPropIndex = FFAppState().usersPropIndex + 1;
    }
    FFAppState().usersPropIndex = 0;
  }
}

Future animaisRegistrados(BuildContext context) async {
  List<QTDAnimaisTotalPropriedadeRow>? qtdAnimais;

  qtdAnimais = await SQLiteManager.instance.qTDAnimaisTotalPropriedade(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );
  FFAppState().animaisRegistrados = valueOrDefault<int>(
    qtdAnimais.length,
    0,
  );
}

Future animaisPropriedade(BuildContext context) async {
  List<QTDAnimaisPropriedadeRow>? animais;

  animais = await SQLiteManager.instance.qTDAnimaisPropriedade(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );
  FFAppState().qtdAnimaisPropriedade = valueOrDefault<int>(
    animais.length,
    0,
  );
}

Future<bool> putUpdtRebanhos(BuildContext context) async {
  var allSuccess = true;
  try {
    List<BuscarRebanhoPUTRow>? localRebanhos;
    List<RebanhoRow>? animalExiste;
    List<BuscarRebanhoUPDATEDRow>? localRebanhosUPDT;
    List<BuscaHistPesagensPUTRow>? localHistPesPUT;
    List<BuscaHistPesagensUPDTRow>? localPesagensUPDT;

    if (FFAppState().dataDadosNaoSyncRebanho != null) {
      localRebanhos = await SQLiteManager.instance.buscarRebanhoPUT(
        data: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncRebanho,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localRebanhos.isNotEmpty) {
        FFAppState().rebanhosIndex = 0;
        while (FFAppState().rebanhosIndex < localRebanhos.length) {
          animalExiste = await RebanhoTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'idRebanho',
              localRebanhos
                  ?.elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.idRebanho,
            ),
          );
          if (!((animalExiste).isNotEmpty)) {
            try {
              await RebanhoTable().insert({
                'idPropriedade': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.idPropriedade,
                'numeroAnimal': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.numeroAnimal,
                'chip': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.chip,
                'codRegistro': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.codRegistro,
                'nome': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.nome,
                'sexo': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.sexo,
                'categoria': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.categoria,
                'dataNascimento': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataNascimento)),
                'pesoNascimento': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.pesoNascimento,
                'porte': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.porte,
                'raca': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.raca,
                'loteID': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.loteID,
                'dataEntradaLote': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataEntradaLote)),
                'rebanhoIdMatriz': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.rebanhoIdMatriz,
                'rebanhoIdReprodutor': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.rebanhoIdReprodutor,
                'dataDesmama': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataDesmama)),
                'pesoDesmama': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.pesoDesmama,
                'pesoAtual': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.pesoAtual,
                'status': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.statusRebanho,
                'origem': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.origem,
                'anotacoes': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.anotacoes,
                'idRebanho': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.idRebanho,
                'deletado': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.deletado,
                'loteNome': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.loteNome,
                'tipo': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.tipo,
                'dataAcao': supaSerialize<DateTime>(functions.converterParaData(
                    localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataAcao)),
                'valorCompra': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.valorCompra,
                'dataUltimaPesagem': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataUltimaPesagem)),
                'nomeConcat': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.nomeConcat,
                'dataVenda': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataVenda)),
                'valorVenda': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.valorVenda,
                'numeroMatriz': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.numeroMatriz,
                'nomeMatriz': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.nomeMatriz,
                'dataNascMatriz': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataNascMatriz)),
                'racaMatriz': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.racaMatriz,
                'numeroReprodutor': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.numeroReprodutor,
                'nomeReprodutor': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.nomeReprodutor,
                'dataNascReprodutor': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataNascReprodutor)),
                'racaReprodutor': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.racaReprodutor,
                'movimentacao_entrada': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.movimentacaoEntrada)),
                'movimentacao_saida': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.movimentacaoSaida)),
                'data_morte': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhos
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataMorte)),
                'motivo_morte': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.motivoMorte,
                'categoria_matriz': localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.categoriaMatriz,
              });
              _markSyncOk(
                  'rebanho',
                  localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.idRebanho);
            } catch (e) {
              allSuccess = false;
              _recordSyncError(
                flow: 'putUpdtRebanhos',
                modulo: 'rebanho',
                operacao: 'insert',
                erro: e,
                registroId: localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.idRebanho,
                registroDescricao: _descreverRebanhoBy(localRebanhos
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.numeroAnimal),
              );
            }
          }
          FFAppState().rebanhosIndex = FFAppState().rebanhosIndex + 1;
        }
      }
      FFAppState().rebanhosIndex = 0;
      localRebanhosUPDT = await SQLiteManager.instance.buscarRebanhoUPDATED(
        data: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncRebanho,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      // A4 dedupe PUT/UPDT: remove registros recém-inseridos (created_at ≈ updated_at)
      if (localRebanhos.isNotEmpty) {
        final insertedIds = localRebanhos.map((r) => r.idRebanho).whereType<String>().toSet();
        if (insertedIds.isNotEmpty) {
          final before = localRebanhosUPDT.length;
          localRebanhosUPDT = localRebanhosUPDT.where((r) => !insertedIds.contains(r.idRebanho)).toList();
          final removed = before - localRebanhosUPDT.length;
          if (removed > 0) _syncLog('putUpdtRebanhos', 'Dedupe PUT/UPDT: $removed registro(s) removidos do UPDATE.');
        }
      }
      if (localRebanhosUPDT.isNotEmpty) {
        while (FFAppState().rebanhosIndex < localRebanhosUPDT.length) {
          _throwIfCancelled('putUpdt_rebanhos');
          try {
            await RebanhoTable().update(
              data: {
                'numeroAnimal': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.numeroAnimal,
                'chip': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.chip,
                'codRegistro': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.codRegistro,
                'nome': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.nome,
                'sexo': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.sexo,
                'categoria': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.categoria,
                'dataNascimento': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataNascimento)),
                'pesoNascimento': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.pesoNascimento,
                'porte': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.porte,
                'raca': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.raca,
                'loteID': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.loteID,
                'dataEntradaLote': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataEntradaLote)),
                'rebanhoIdMatriz': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.rebanhoIdMatriz,
                'rebanhoIdReprodutor': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.rebanhoIdReprodutor,
                'dataDesmama': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataDesmama)),
                'pesoDesmama': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.pesoDesmama,
                'pesoAtual': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.pesoAtual,
                'status': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.statusRebanho,
                'origem': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.origem,
                'anotacoes': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.anotacoes,
                'deletado': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.deletado,
                'loteNome': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.loteNome,
                'tipo': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.tipo,
                'dataAcao': supaSerialize<DateTime>(functions.converterParaData(
                    localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataAcao)),
                'valorCompra': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.valorCompra,
                'dataUltimaPesagem': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataUltimaPesagem)),
                'nomeConcat': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.nomeConcat,
                'dataVenda': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataVenda)),
                'valorVenda': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.valorVenda,
                'numeroMatriz': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.numeroMatriz,
                'nomeMatriz': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.nomeMatriz,
                'dataNascMatriz': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataNascMatriz)),
                'racaMatriz': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.racaMatriz,
                'numeroReprodutor': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.numeroReprodutor,
                'nomeReprodutor': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.nomeReprodutor,
                'dataNascReprodutor': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataNascReprodutor)),
                'racaReprodutor': localRebanhosUPDT
                    .elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.racaReprodutor,
                'movimentacao_entrada': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.movimentacaoEntrada)),
                'movimentacao_saida': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.movimentacaoSaida)),
                'data_morte': supaSerialize<DateTime>(
                    functions.converterParaData(localRebanhosUPDT
                        .elementAtOrNull(FFAppState().rebanhosIndex)
                        ?.dataMorte)),
              },
              matchingRows: (rows) => rows.eqOrNull(
                'idRebanho',
                localRebanhosUPDT
                    ?.elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.idRebanho,
              ),
            );
            _markSyncOk(
                'rebanho',
                localRebanhosUPDT
                    ?.elementAtOrNull(FFAppState().rebanhosIndex)
                    ?.idRebanho);
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtRebanhos',
              modulo: 'rebanho',
              operacao: 'update',
              erro: e,
              registroId: localRebanhosUPDT
                  ?.elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.idRebanho,
              registroDescricao: _descreverRebanhoBy(localRebanhosUPDT
                  ?.elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.numeroAnimal),
            );
          }
          FFAppState().rebanhosIndex = FFAppState().rebanhosIndex + 1;
        }
      }
      FFAppState().rebanhosIndex = 0;
      localHistPesPUT = await SQLiteManager.instance.buscaHistPesagensPUT(
        data: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncRebanho,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      FFAppState().pesagensIndex = 0;
      if (localHistPesPUT.isNotEmpty) {
        while (FFAppState().pesagensIndex < localHistPesPUT.length) {
          _throwIfCancelled('putUpdt_pesagens');
          try {
            await HistoricoPesagensTable().insert({
              'idRebanho': localHistPesPUT
                  .elementAtOrNull(FFAppState().pesagensIndex)
                  ?.idRebanho,
              'dataPesagem': supaSerialize<DateTime>(
                  functions.converterParaData(localHistPesPUT
                      .elementAtOrNull(FFAppState().pesagensIndex)
                      ?.dataPesagem)),
              'tipo': localHistPesPUT
                  .elementAtOrNull(FFAppState().pesagensIndex)
                  ?.tipo,
              'peso': localHistPesPUT
                  .elementAtOrNull(FFAppState().pesagensIndex)
                  ?.peso,
              'deletado': localHistPesPUT
                  .elementAtOrNull(FFAppState().pesagensIndex)
                  ?.deletado,
              'id_propriedade': localHistPesPUT
                  .elementAtOrNull(FFAppState().pesagensIndex)
                  ?.idPropriedade,
            });
            _markSyncOk(
                'pesagem',
                localHistPesPUT
                    .elementAtOrNull(FFAppState().pesagensIndex)
                    ?.idRebanho);
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtRebanhos',
              modulo: 'pesagem',
              operacao: 'insert',
              erro: e,
              registroId: localHistPesPUT
                  .elementAtOrNull(FFAppState().pesagensIndex)
                  ?.idRebanho,
              registroDescricao: 'Pesagem ${localHistPesPUT.elementAtOrNull(FFAppState().pesagensIndex)?.peso ?? "?"}kg',
            );
          }
          FFAppState().pesagensIndex = FFAppState().pesagensIndex + 1;
        }
      }
      FFAppState().pesagensIndex = 0;
      localPesagensUPDT = await SQLiteManager.instance.buscaHistPesagensUPDT();
      if (localPesagensUPDT.isNotEmpty) {
        while (FFAppState().pesagensIndex < localPesagensUPDT.length) {
          _throwIfCancelled('putUpdt_pesagens');
          try {
            await HistoricoPesagensTable().update(
              data: {
                'deletado': localPesagensUPDT
                    .elementAtOrNull(FFAppState().pesagensIndex)
                    ?.deletado,
              },
              matchingRows: (rows) => rows.eqOrNull(
                'id',
                localPesagensUPDT
                    ?.elementAtOrNull(FFAppState().pesagensIndex)
                    ?.id,
              ),
            );
            _markSyncOk(
                'pesagem',
                localPesagensUPDT
                    .elementAtOrNull(FFAppState().pesagensIndex)
                    ?.id
                    ?.toString());
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtRebanhos',
              modulo: 'pesagem',
              operacao: 'update',
              erro: e,
              registroId: localPesagensUPDT
                  .elementAtOrNull(FFAppState().pesagensIndex)
                  ?.id
                  ?.toString(),
              registroDescricao: 'Pesagem id=${localPesagensUPDT.elementAtOrNull(FFAppState().pesagensIndex)?.id ?? "?"}',
            );
          }
          FFAppState().pesagensIndex = FFAppState().pesagensIndex + 1;
        }
      }
      FFAppState().pesagensIndex = 0;
    }
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtRebanhos', 'ERRO no upload de rebanhos: $e\n$s');
  }
  return allSuccess;
}

Future countLotesAtivoInativo(BuildContext context) async {
  List<LotesAtivoRow>? qtdAtivos;
  List<LotesInativosRow>? qtdInativos;
  List<AnimaisNoLoteRow>? qtdAnimaisLote;

  await Future.wait([
    Future(() async {
      qtdAtivos = await SQLiteManager.instance.lotesAtivo(
        idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
      );
      FFAppState().qtdLotesAtivos = valueOrDefault<int>(
        qtdAtivos?.length,
        0,
      );
    }),
    Future(() async {
      qtdInativos = await SQLiteManager.instance.lotesInativos(
        idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
      );
      FFAppState().qtdLotesInativos = valueOrDefault<int>(
        qtdInativos?.length,
        0,
      );
    }),
    Future(() async {
      qtdAnimaisLote = await SQLiteManager.instance.animaisNoLote(
        idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
      );
      FFAppState().qtdAnimaisLote = valueOrDefault<int>(
        qtdAnimaisLote?.length,
        0,
      );
    }),
  ]);
}

Future buscaRebanhosLote(
  BuildContext context, {
  String? idLote,
}) async {
  List<BuscarRebanhoLoteRow>? rebanhosLote;

  FFAppState().rebanhosLote = [];
  rebanhosLote = await SQLiteManager.instance.buscarRebanhoLote(
    idLote: idLote,
  );
  FFAppState().rebanhosIndex = 0;
  while (FFAppState().rebanhosIndex < rebanhosLote.length) {
    FFAppState().addToRebanhosLote(RebanhoStruct(
      idPropriedade: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.idPropriedade,
      numeroAnimal: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.numeroAnimal,
      chip: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.chip,
      codRegistro:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.codRegistro,
      nome: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.nome,
      sexo: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.sexo,
      categoria:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.categoria,
      dataNascimento: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.dataNascimento,
      pesoNascimento: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.pesoNascimento,
      porte: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.porte,
      raca: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.raca,
      loteId: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.loteID,
      dataEntradaLote: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.dataEntradaLote,
      rebanhoIdMatriz: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.rebanhoIdMatriz,
      rebanhoIdReprodutor: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.rebanhoIdReprodutor,
      dataDesmama:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.dataDesmama,
      pesoDesmama:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.pesoDesmama,
      pesoAtual:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.pesoAtual,
      status: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.statusRebanho,
      origem: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.origem,
      anotacoes:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.anotacoes,
      idRebanho:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.idRebanho,
      tipo: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.tipo,
      dataAcao:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.dataAcao,
      valorCompra:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.valorCompra,
      dataUltimaPesagem: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.dataUltimaPesagem,
      nomeConcat:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.nomeConcat,
      loteNome:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.loteNome,
    ));
    FFAppState().rebanhosIndex = FFAppState().rebanhosIndex + 1;
  }
}

Future refreshLotes(BuildContext context) async {
  try {
    List<LotesChangeTrackerRow>? lastChangeResult;
    ApiCallResponse? propriedades;
    List<LotesRow>? lotes;

    try {
      lastChangeResult = await LotesChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e) {
      _syncLog('lotes', 'ERRO ao consultar change tracker: $e');
      lastChangeResult = [];
    }
    final remoteLastChange = lastChangeResult.firstOrNull?.lastChange;
    final localLastChange = FFAppState().lotesChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('lotes',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');
    if (shouldSync) {
      propriedades =
          await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
        pUserId: currentUserUid,
      );

      final lotesJsonBody = propriedades.jsonBody;
      final lotesRawList = lotesJsonBody is List ? lotesJsonBody : <dynamic>[];
      lotes = await LotesTable().queryRows(
        queryFn: (q) => q
            .inFilterOrNull(
              'id_propriedade',
              (lotesRawList
                      .map<PropriedadesStruct?>(PropriedadesStruct.maybeFromMap)
                      .toList() as Iterable<PropriedadesStruct?>)
                  .withoutNulls
                  .map((e) => e.idPropriedade)
                  .toList(),
            )
            .eqOrNull(
              'deletado',
              'NAO',
            ),
      );

      // Converter para lista de maps para batch insert
      final records = <Map<String, dynamic>>[];
      for (final lote in lotes) {
        records.add({
          'id_propriedade': lote.idPropriedade,
          'id_animais': lote.idAnimais,
          'nome': lote.nome,
          'anotacoes': lote.anotacoes,
          'ativo': lote.ativo,
          'motivo': lote.motivo,
          'data_motivo': lote.dataMotivo?.toString(),
          'id_lote': lote.idLote,
          'deletado': lote.deletado,
          'created_at': dateTimeFormat(
            "yyyy-MM-dd HH:mm:ss",
            functions.remover3hs(lote.createdAt),
            locale: FFLocalizations.of(context).languageCode,
          ),
          'updated_at': lote.updatedAt?.toString(),
          'valorVenda': lote.valorVenda,
        });
      }

      // Inserir via UPSERT — NÃO deleta antes para evitar perda de dados
      // se o batch insert falhar. ConflictAlgorithm.replace já sobrescreve.
      final loteResult = await actions.batchInsertLocalLotes(records);
      final lotesInserted = loteResult['inserted'] as int? ?? 0;
      final lotesErrors = loteResult['errors'] as List<Map<String, String>>? ?? [];
      if (lotesInserted == 0 && records.isNotEmpty) {
        _syncLog('lotes',
            'Batch insert falhou completamente (${lotesErrors.length} erros). Mantendo dados locais.');
      } else {
        _syncLog('lotes', '$lotesInserted lotes inseridos via UPSERT.');
      }

      FFAppState().lotesChangeDateTime = remoteLastChange ?? DateTime.now();
      FFAppState().lotesIndex = 0;
      _syncLog('lotes', 'Sincronização de lotes concluída.');
    } else {
      _syncLog('lotes', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('lotes', 'ERRO FATAL na sincronização de lotes: $e\n$s');
  }
}

Future<bool> putUpdtLotes(BuildContext context) async {
  var allSuccess = true;
  try {
    List<BuscarLotePUTRow>? localLotes;
    List<BuscarLoteUPDTRow>? localLotesUPT;

    if (FFAppState().dataDadosNaoSyncLotes != null) {
      localLotes = await SQLiteManager.instance.buscarLotePUT(
        datePUT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncLotes,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      FFAppState().lotesIndex = 0;
      if (localLotes.isNotEmpty) {
        while (FFAppState().lotesIndex < localLotes.length) {
          _throwIfCancelled('putUpdt_lotes');
          try {
            await LotesTable().insert({
              'id_propriedade': localLotes
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.idPropriedade,
              'id_animais': localLotes
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.idAnimais,
              'nome': localLotes.elementAtOrNull(FFAppState().lotesIndex)?.nome,
              'anotacoes': localLotes
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.anotacoes,
              'ativo':
                  localLotes.elementAtOrNull(FFAppState().lotesIndex)?.ativo,
              'motivo':
                  localLotes.elementAtOrNull(FFAppState().lotesIndex)?.motivo,
              'data_motivo': supaSerialize<DateTime>(
                  functions.converterParaData(localLotes
                      .elementAtOrNull(FFAppState().lotesIndex)
                      ?.dataMotivo)),
              'id_lote':
                  localLotes.elementAtOrNull(FFAppState().lotesIndex)?.idLote,
              'deletado':
                  localLotes.elementAtOrNull(FFAppState().lotesIndex)?.deletado,
              'data_entrada_piquete': supaSerialize<DateTime>(
                  functions.converterParaData(localLotes
                      .elementAtOrNull(FFAppState().lotesIndex)
                      ?.dataEntradaPiquete)),
              'data_saida_piquete': supaSerialize<DateTime>(
                  functions.converterParaData(localLotes
                      .elementAtOrNull(FFAppState().lotesIndex)
                      ?.dataSaidaPiquete)),
              'valorVenda': localLotes
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.valorVenda,
            });
            _markSyncOk('lote',
                localLotes.elementAtOrNull(FFAppState().lotesIndex)?.idLote);
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtLotes',
              modulo: 'lote',
              operacao: 'insert',
              erro: e,
              registroId:
                  localLotes.elementAtOrNull(FFAppState().lotesIndex)?.idLote,
              registroDescricao:
                  localLotes.elementAtOrNull(FFAppState().lotesIndex)?.nome,
            );
          }
          FFAppState().lotesIndex = FFAppState().lotesIndex + 1;
        }
      }
      FFAppState().lotesIndex = 0;
      localLotesUPT = await SQLiteManager.instance.buscarLoteUPDT(
        dateUPDT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncLotes,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localLotes != null && localLotes.isNotEmpty) {
        final insertedIds = localLotes.map((r) => r.idLote).whereType<String>().toSet();
        if (insertedIds.isNotEmpty) {
          final before = localLotesUPT.length;
          localLotesUPT = localLotesUPT.where((r) => !insertedIds.contains(r.idLote)).toList();
          final removed = before - localLotesUPT.length;
          if (removed > 0) _syncLog('putUpdtLotes', 'Dedupe PUT/UPDT: $removed registro(s) removidos do UPDATE.');
        }
      }
      if (localLotesUPT.isNotEmpty) {
        while (FFAppState().lotesIndex < localLotesUPT.length) {
          _throwIfCancelled('putUpdt_lotes');
          try {
            await LotesTable().update(
              data: {
                'id_propriedade': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.idPropriedade,
                'id_animais': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.idAnimais,
                'nome': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.nome,
                'anotacoes': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.anotacoes,
                'ativo': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.ativo,
                'motivo': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.motivo,
                'data_motivo': supaSerialize<DateTime>(
                    functions.converterParaData(localLotesUPT
                        .elementAtOrNull(FFAppState().lotesIndex)
                        ?.dataMotivo)),
                'id_lote': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.idLote,
                'deletado': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.deletado,
                'updated_at': supaSerialize<DateTime>(
                    functions.converterParaData(localLotesUPT
                        .elementAtOrNull(FFAppState().lotesIndex)
                        ?.updatedAt)),
                'data_entrada_piquete': supaSerialize<DateTime>(
                    functions.converterParaData(localLotesUPT
                        .elementAtOrNull(FFAppState().lotesIndex)
                        ?.dataEntradaPiquete)),
                'data_saida_piquete': supaSerialize<DateTime>(
                    functions.converterParaData(localLotesUPT
                        .elementAtOrNull(FFAppState().lotesIndex)
                        ?.dataSaidaPiquete)),
                'valorVenda': localLotesUPT
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.valorVenda,
              },
              matchingRows: (rows) => rows.eqOrNull(
                'id_lote',
                localLotesUPT?.elementAtOrNull(FFAppState().lotesIndex)?.idLote,
              ),
            );
            _markSyncOk('lote',
                localLotesUPT.elementAtOrNull(FFAppState().lotesIndex)?.idLote);
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtLotes',
              modulo: 'lote',
              operacao: 'update',
              erro: e,
              registroId:
                  localLotesUPT.elementAtOrNull(FFAppState().lotesIndex)?.idLote,
              registroDescricao:
                  localLotesUPT.elementAtOrNull(FFAppState().lotesIndex)?.nome,
            );
          }
          FFAppState().lotesIndex = FFAppState().lotesIndex + 1;
        }
      }
      FFAppState().lotesIndex = 0;
    }
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtLotes', 'ERRO no upload de lotes: $e\n$s');
  }
  return allSuccess;
}

Future countLotesCadastrados(BuildContext context) async {
  List<CountLotesCadastradosRow>? qtdLotes;

  qtdLotes = await SQLiteManager.instance.countLotesCadastrados(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );
  FFAppState().lotesCadastrados = valueOrDefault<int>(
    qtdLotes.length,
    0,
  );
}

Future qTDReproducoes(BuildContext context) async {
  final results = await Future.wait([
    SQLiteManager.instance.qTDReproducoes(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    ),
    SQLiteManager.instance.qTDInseminacao(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    ),
    SQLiteManager.instance.qTDMontaNatural(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    ),
  ]);
  FFAppState().countReproducoes = valueOrDefault<int>(
    results[0].length,
    0,
  );
  FFAppState().countInseminacoes = valueOrDefault<int>(
    results[1].length,
    0,
  );
  FFAppState().countMontaNatural = valueOrDefault<int>(
    results[2].length,
    0,
  );
}

Future<bool> putUpdtReproducao(BuildContext context) async {
  var allSuccess = true;
  final dataPendente = FFAppState().dataDadosNaoSyncRepro;
  if (dataPendente == null) return true;

  List<BuscarReproducaoPUTRow> localReproducao = const [];
  List<BuscarReproducaoUPDTRow> localReproducaoUPDT = const [];

  try {
    _throwIfCancelled('putUpdtReproducao');
    final dateFilter = dateTimeFormat(
      "yyyy-MM-dd HH:mm:ss",
      dataPendente,
      locale: FFLocalizations.of(context).languageCode,
    );

    localReproducao =
        await SQLiteManager.instance.buscarReproducaoPUT(datePUT: dateFilter);
    localReproducaoUPDT =
        await SQLiteManager.instance.buscarReproducaoUPDT(datePUT: dateFilter);

    // A4 dedupe PUT/UPDT: registros recém-inseridos (created_at ≈ updated_at)
    // aparecem nas duas listas; evitamos double roundtrip.
    final insertedIds = localReproducao
        .map((r) => r.idReproducao)
        .whereType<String>()
        .toSet();
    if (insertedIds.isNotEmpty) {
      final before = localReproducaoUPDT.length;
      localReproducaoUPDT = localReproducaoUPDT
          .where((r) => !insertedIds.contains(r.idReproducao))
          .toList();
      final removed = before - localReproducaoUPDT.length;
      if (removed > 0) {
        _syncLog('putUpdtReproducao',
            'Dedupe PUT/UPDT: $removed registro(s) recém-inseridos removidos do UPDATE.');
      }
    }

    // B1+B2: constrói payloads para UPSERT em lote (1 request para N registros)
    // com onConflict=id_reproducao — idempotente, retries seguros.
    final payloads = <Map<String, dynamic>>[];
    for (final row in localReproducao) {
      _throwIfCancelled('putUpdtReproducao');
      payloads.add(_buildReproducaoPayload(row.data, isInsert: true));
    }
    for (final row in localReproducaoUPDT) {
      _throwIfCancelled('putUpdtReproducao');
      payloads.add(_buildReproducaoPayload(row.data, isInsert: false));
    }

    if (payloads.isEmpty) {
      _syncLog('putUpdtReproducao', 'Nada para enviar.');
      return true;
    }

    _syncLog('putUpdtReproducao',
        'Upsert em lote: ${payloads.length} registro(s) (INSERT=${localReproducao.length}, UPDATE=${localReproducaoUPDT.length}).');

    await _retry(
      () => _batchUpsertSupabase(
        tableName: 'reproducao',
        rows: payloads,
        onConflict: 'id_reproducao',
        chunkSize: 200,
        label: 'putUpdtReproducao',
      ),
      label: 'putUpdtReproducao.batchUpsert',
      maxAttempts: 3,
    );

    // Auto-resolve erros pendentes dos registros que acabaram de subir.
    for (final row in localReproducao) {
      // ignore: discarded_futures
      actions.SyncErrorLog.autoResolverPorRegistro('reproducao', row.idReproducao);
    }
    for (final row in localReproducaoUPDT) {
      // ignore: discarded_futures
      actions.SyncErrorLog.autoResolverPorRegistro('reproducao', row.idReproducao);
    }

    _syncLog('putUpdtReproducao', 'Upload concluído com sucesso.');
  } on SyncCancelledException catch (e) {
    allSuccess = false;
    _syncLog('putUpdtReproducao', 'CANCELADO: $e');
  } on TimeoutException catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtReproducao', 'TIMEOUT no upload de reprodução: $e\n$s');
    for (final row in localReproducao) {
      _recordSyncError(
        flow: 'putUpdtReproducao',
        modulo: 'reproducao',
        operacao: 'insert',
        erro: e,
        registroId: row.idReproducao,
        registroDescricao: _descreverReproducaoBy(row.dataInseminacao),
      );
    }
    for (final row in localReproducaoUPDT) {
      _recordSyncError(
        flow: 'putUpdtReproducao',
        modulo: 'reproducao',
        operacao: 'update',
        erro: e,
        registroId: row.idReproducao,
        registroDescricao: _descreverReproducaoBy(row.dataInseminacao),
      );
    }
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtReproducao', 'ERRO no upload de reprodução: $e\n$s');
    for (final row in localReproducao) {
      _recordSyncError(
        flow: 'putUpdtReproducao',
        modulo: 'reproducao',
        operacao: 'insert',
        erro: e,
        registroId: row.idReproducao,
        registroDescricao: _descreverReproducaoBy(row.dataInseminacao),
      );
    }
    for (final row in localReproducaoUPDT) {
      _recordSyncError(
        flow: 'putUpdtReproducao',
        modulo: 'reproducao',
        operacao: 'update',
        erro: e,
        registroId: row.idReproducao,
        registroDescricao: _descreverReproducaoBy(row.dataInseminacao),
      );
    }
  } finally {
    FFAppState().reproducaoIndex = 0;
  }
  return allSuccess;
}

/// Monta o payload enviado ao Supabase a partir do Map bruto do SQLite.
///
/// Responsabilidades (B2 idempotência e saneamento):
/// - Converte strings de data para ISO 8601 aceito pelo PostgREST.
/// - Aplica defaults seguros para campos obrigatórios.
/// - NUNCA envia o literal "Não" ou "" em id_rebanho_matriz / id_rebanho_reprodutor —
///   esses são FKs; o valor correto é null quando não há matriz/reprodutor.
///   (Bug no código antigo usava valueOrDefault(..., 'Não') e causava FK error.)
/// - Aplica score_corporal=0.5 como default quando null (comportamento histórico).
Map<String, dynamic> _buildReproducaoPayload(
  Map<String, dynamic> raw, {
  required bool isInsert,
}) {
  String? parseDate(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s == 'null') return null;
    final dt = functions.converterParaData(s);
    if (dt == null) return null;
    return supaSerialize<DateTime>(dt);
  }

  String? nullableFk(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s == 'null' || s == 'Não' || s == 'NAO') return null;
    return s;
  }

  String? nullableStr(dynamic v) {
    if (v == null) return null;
    final s = v.toString();
    if (s == 'null') return null;
    return s;
  }

  final dataInseminacaoStr = parseDate(raw['data_inseminacao']);
  final partidaDefault = FFAppState().dateDefault;
  final dataPartidaSemen = (raw['data_partida_semen'] != null &&
          raw['data_partida_semen'].toString().isNotEmpty)
      ? parseDate(raw['data_partida_semen'])
      : (partidaDefault != null
          ? supaSerialize<DateTime>(partidaDefault)
          : null);

  final payload = <String, dynamic>{
    'id_reproducao': raw['id_reproducao'],
    'id_propriedade': raw['id_propriedade'],
    'tipo_reproducao': nullableStr(raw['tipo_reproducao']),
    'score_corporal': (raw['score_corporal'] as num?)?.toDouble() ?? 0.5,
    'data_inseminacao': dataInseminacaoStr,
    'data_partida_semen': dataPartidaSemen,
    'partida_semen': raw['partida_semen'] ?? 1,
    'previsao_parto': parseDate(raw['previsao_parto']),
    'id_lote': nullableStr(raw['id_lote']),
    'data_inicial': parseDate(raw['data_inicial']),
    'data_final': parseDate(raw['data_final']),
    'status_reproducao': nullableStr(raw['status_reproducao']),
    'inseminador': nullableStr(raw['inseminador']),
    'anotacoes': nullableStr(raw['anotacoes']),
    'deletado': nullableStr(raw['deletado']),
    'updated_at': parseDate(raw['updated_at']),
    'categoria': nullableStr(raw['categoria']),
    'numMatriz': nullableStr(raw['numMatriz']),
    'nomeMatriz': nullableStr(raw['nomeMatriz']),
    'nascimentoMatriz': parseDate(raw['nascimentoMatriz']),
    'numReprodutor': nullableStr(raw['numReprodutor']),
    'nomeReprodutor': nullableStr(raw['nomeReprodutor']),
    'nascimentoReprodutor': parseDate(raw['nascimentoReprodutor']),
    'loteNome': nullableStr(raw['loteNome']),
    'data_status': parseDate(raw['data_status']),
    'chipReprodutor': nullableStr(raw['chipReprodutor']),
    'chipMatriz': nullableStr(raw['chipMatriz']),
    'racaMatriz': nullableStr(raw['racaMatriz']),
    'racaReprodutor': nullableStr(raw['racaReprodutor']),
    'ressinc': nullableStr(raw['ressinc']) ?? 'NAO',
    'parida': nullableStr(raw['parida']) ?? 'NAO',
    'data_parto': parseDate(raw['data_parto']),
    'gnrh': nullableStr(raw['gnrh']) ?? 'Não',
    'cio': nullableStr(raw['cio']) ?? 'Não',
    'id_rebanho_matriz': nullableFk(raw['id_rebanho_matriz']),
    'id_rebanho_reprodutor': nullableFk(raw['id_rebanho_reprodutor']),
  };

  // Remove chaves null para não sobrescrever valores remotos com null
  // em campos que não foram alterados off-line (comportamento conservador
  // em upsert).
  payload.removeWhere((key, value) =>
      value == null && key != 'id_rebanho_matriz' && key != 'id_rebanho_reprodutor');
  return payload;
}

Future countSanidades(BuildContext context) async {
  List<ListarSanidadesRow>? listaSanidades;

  FFAppState().qtdVacinas = 0;
  FFAppState().qtdAntiparasitarios = 0;
  FFAppState().qtdTratamento = 0;
  FFAppState().qtdProtocoloReprodutivo = 0;

  listaSanidades = await SQLiteManager.instance.listarSanidades(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );

  final validRecords = listaSanidades
      .where((e) => e.idRebanho != null && e.idRebanho != '')
      .toList();

  for (final record in validRecords) {
    if (record.vacinacao != null && record.vacinacao != 'null') {
      FFAppState().qtdVacinas += valueOrDefault<int>(
        functions.converterJSONparaLista(record.vacinacao!).length,
        0,
      );
    }
    if (record.antiparasitario != null && record.antiparasitario != 'null') {
      FFAppState().qtdAntiparasitarios += valueOrDefault<int>(
        functions.converterJSONparaLista(record.antiparasitario!).length,
        0,
      );
    }
    if (record.tratamento != null && record.tratamento != 'null') {
      FFAppState().qtdTratamento += valueOrDefault<int>(
        functions.converterJSONparaLista(record.tratamento!).length,
        0,
      );
    }
    if (record.protocoloReprodutivo != null &&
        record.protocoloReprodutivo != 'null' &&
        record.protocoloReprodutivo != '') {
      FFAppState().qtdProtocoloReprodutivo += 1;
    }
  }
}

Future<bool> putUpdtSanidades(BuildContext context) async {
  var allSuccess = true;
  try {
    List<BuscarSanidadePUTRow>? localSanidade;
    List<BuscarSanidadeUPDTRow>? localSanidadeUPDT;

    if (FFAppState().dataDadosNaoSyncSanidade != null) {
      localSanidade = await SQLiteManager.instance.buscarSanidadePUT(
        datePUT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncSanidade,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localSanidade.isNotEmpty) {
        while (FFAppState().sanidadeIndex < localSanidade.length) {
          _throwIfCancelled('putUpdt_sanidade');
          try {
            await SanidadeTable().insert({
              'id_propriedade': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.idPropriedade,
              'deletado': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.deletado,
              'updated_at': supaSerialize<DateTime>(functions.converterParaData(
                  localSanidade
                      .elementAtOrNull(FFAppState().sanidadeIndex)
                      ?.updatedAt)),
              'created_at': supaSerialize<DateTime>(functions.converterParaData(
                  localSanidade
                      .elementAtOrNull(FFAppState().sanidadeIndex)
                      ?.createdAt)),
              'id_rebanho': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.idRebanho,
              'data_sanidade': supaSerialize<DateTime>(
                  functions.converterParaData(localSanidade
                      .elementAtOrNull(FFAppState().sanidadeIndex)
                      ?.dataSanidade)),
              'id_lote': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.idLote,
              'porcentagem_lote': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.porcentagemLote,
              'id_sanidade': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.idSanidade,
              'vacinacao': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.vacinacao,
              'vacinacao_outros': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.vacinacaoOutros,
              'vacinacao_obs': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.vacinacaoObs,
              'antiparasitario': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.antiparasitario,
              'antiparasitario_outros': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.antiparasitarioOutros,
              'antiparasitario_obs': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.antiparasitarioObs,
              'tratamento': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.tratamento,
              'tratamento_outros': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.tratamentoOutros,
              'tratamento_obs': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.tratamentoObs,
              'protocolo_reprodutivo': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloReprodutivo,
              'protocolo_reprodutivo_outros': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloReprodutivoOutros,
              'protocolo_reprodutivo_obs': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloReprodutivoObs,
              'protocolo_d0': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloD0,
              'protocolo_retirada': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloRetirada,
              'protocolo_iatf': localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloIatf,
            });
            _markSyncOk(
                'sanidade',
                localSanidade
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.idSanidade);
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtSanidades',
              modulo: 'sanidade',
              operacao: 'insert',
              erro: e,
              registroId: localSanidade
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.idSanidade,
              registroDescricao: 'Sanidade ' +
                  (localSanidade
                          .elementAtOrNull(FFAppState().sanidadeIndex)
                          ?.dataSanidade ??
                      ''),
            );
          }
          FFAppState().sanidadeIndex = FFAppState().sanidadeIndex + 1;
        }
      }
      FFAppState().sanidadeIndex = 0;
      localSanidadeUPDT = await SQLiteManager.instance.buscarSanidadeUPDT(
        dateUPDT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncSanidade,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localSanidade != null && localSanidade.isNotEmpty) {
        final insertedIds = localSanidade.map((r) => r.idSanidade).whereType<String>().toSet();
        if (insertedIds.isNotEmpty) {
          final before = localSanidadeUPDT.length;
          localSanidadeUPDT = localSanidadeUPDT.where((r) => !insertedIds.contains(r.idSanidade)).toList();
          final removed = before - localSanidadeUPDT.length;
          if (removed > 0) _syncLog('putUpdtSanidades', 'Dedupe PUT/UPDT: $removed registro(s) removidos do UPDATE.');
        }
      }
      if (localSanidadeUPDT.isNotEmpty) {
        while (FFAppState().sanidadeIndex < localSanidadeUPDT.length) {
          _throwIfCancelled('putUpdt_sanidade');
          try {
            await SanidadeTable().update(
              data: {
                'data_sanidade': supaSerialize<DateTime>(
                    functions.converterParaData(localSanidadeUPDT
                        .elementAtOrNull(FFAppState().sanidadeIndex)
                        ?.dataSanidade)),
                'porcentagem_lote': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.porcentagemLote,
                'updated_at': supaSerialize<DateTime>(
                    functions.converterParaData(localSanidadeUPDT
                        .elementAtOrNull(FFAppState().sanidadeIndex)
                        ?.updatedAt)),
                'deletado': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.deletado,
                'vacinacao': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.vacinacao,
                'vacinacao_outros': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.vacinacaoOutros,
                'vacinacao_obs': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.vacinacaoObs,
                'antiparasitario': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.antiparasitario,
                'antiparasitario_outros': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.antiparasitarioOutros,
                'antiparasitario_obs': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.antiparasitarioObs,
                'tratamento': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.tratamento,
                'tratamento_outros': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.tratamentoOutros,
                'tratamento_obs': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.tratamentoObs,
                'protocolo_reprodutivo': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.protocoloReprodutivo,
                'protocolo_reprodutivo_outros': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.protocoloReprodutivoOutros,
                'protocolo_reprodutivo_obs': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.protocoloReprodutivoObs,
                'protocolo_d0': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.protocoloD0,
                'protocolo_retirada': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.protocoloRetirada,
                'protocolo_iatf': localSanidadeUPDT
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.protocoloIatf,
              },
              matchingRows: (rows) => rows.eqOrNull(
                'id_sanidade',
                localSanidadeUPDT
                    ?.elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.idSanidade,
              ),
            );
            _markSyncOk(
                'sanidade',
                localSanidadeUPDT
                    ?.elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.idSanidade);
          } catch (e) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtSanidades',
              modulo: 'sanidade',
              operacao: 'update',
              erro: e,
              registroId: localSanidadeUPDT
                  ?.elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.idSanidade,
              registroDescricao: 'Sanidade ' +
                  (localSanidadeUPDT
                          ?.elementAtOrNull(FFAppState().sanidadeIndex)
                          ?.dataSanidade ??
                      ''),
            );
          }
          FFAppState().sanidadeIndex = FFAppState().sanidadeIndex + 1;
        }
      }
      FFAppState().sanidadeIndex = 0;
    }
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtSanidades', 'ERRO no upload de sanidades: $e\n$s');
  }
  return allSuccess;
}

Future qTDSanidades(BuildContext context) async {
  List<QTDSanidadesRow>? qtdSanidades;

  qtdSanidades = await SQLiteManager.instance.qTDSanidades(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );
  FFAppState().qtdSanidades = valueOrDefault<int>(
    qtdSanidades.length,
    0,
  );
}

Future refreshRebanhoOtimizada(BuildContext context) async {
  try {
    _syncLog('rebanho', 'Iniciando verificação do change tracker...');
    List<RebanhoChangeTrackerRow>? lastChangeResultt;
    ApiCallResponse? propriedadessO;
    ApiCallResponse? qtdRebanhosO;
    ApiCallResponse? rebanhosAPIO;

    try {
      lastChangeResultt = await RebanhoChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e, s) {
      _syncLog('rebanho', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResultt = [];
    }
    final remoteLastChange = lastChangeResultt.firstOrNull?.lastChange;
    final localLastChange = FFAppState().rebanhosChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('rebanho',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    if (shouldSync) {
      final isFirst = _isFirstSync(localLastChange) ||
          await _isLocalTableEmpty('local_rebanho');
      _syncLog('rebanho',
          'Iniciando sincronização ${isFirst ? "COMPLETA (primeiro sync)" : "INCREMENTAL"}.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      FFAppState().indexRebPaginacao = 0;
      FFAppState().visibleProgressBar = true;
      FFAppState().update(() {});

      final String? updatedAfter =
          (!isFirst && localLastChange != null)
              ? localLastChange.toUtc().toIso8601String()
              : null;

      try {
        propriedadessO =
            await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
          pUserId: currentUserUid,
        );

        final propertyIds = _safePropertyIds(propriedadessO.jsonBody);
        _syncLog('rebanho',
            'Propriedades encontradas: ${propertyIds.length}. IDs: $propertyIds');

        if (propertyIds.isEmpty) {
          _syncLog(
              'rebanho', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        if (updatedAfter != null) {
          qtdRebanhosO =
              await SupabaseFunctionsGroup.qTDRebanhosIncCall.call(
            pIdsPropriedadesList: propertyIds,
            pUpdatedAfter: updatedAfter,
          );
        } else {
          qtdRebanhosO = await SupabaseFunctionsGroup.qTDRebanhosCall.call(
            pIdsPropriedadesList: propertyIds,
          );
        }
        _syncLog(
            'rebanho', 'Resposta qtdRebanhos raw: ${qtdRebanhosO.jsonBody}');

        final totalRebanhos = _safeTotalFromApi(qtdRebanhosO.jsonBody);
        FFAppState().totalRebanhos = totalRebanhos;
        _syncLog('rebanho',
            'Total remoto informado: $totalRebanhos (${updatedAfter != null ? "incremental desde $updatedAfter" : "completo"}).');

        if (totalRebanhos == 0 && updatedAfter != null) {
          _syncLog('rebanho',
              'Nenhuma alteração remota desde último sync. Atualizando timestamp.');
          FFAppState().rebanhosChangeDateTime =
              remoteLastChange ?? DateTime.now();
          return;
        }

        if (isFirst) {
          // Primeiro sync: em vez de deletar tudo antes do insert,
          // confiamos no UPSERT (ConflictAlgorithm.replace) para
          // sobrescrever dados antigos. Se o insert falhar, dados locais
          // são preservados.
          _syncLog('rebanho', 'Primeiro sync. Iniciando paginação (UPSERT)...');
        } else {
          _syncLog('rebanho',
              'Sync incremental — mantendo dados locais. Iniciando paginação (UPSERT)...');
        }
        while (FFAppState().indexRebPaginacao < totalRebanhos) {
          final offsetAtual = FFAppState().indexRebPaginacao;
          // B5: page size adaptativo (mobile=250, demais=999)
          final pageSize = await _adaptivePageSize();
          try {
            if (updatedAfter != null) {
              rebanhosAPIO =
                  await SupabaseFunctionsGroup.buscarRebanhosIncCall.call(
                pIdPropriedadeList: propertyIds,
                pLimite: pageSize,
                pOffset: offsetAtual,
                pUpdatedAfter: updatedAfter,
              );
            } else {
              rebanhosAPIO =
                  await SupabaseFunctionsGroup.buscarRebanhosCall.call(
                pIdPropriedadeList: propertyIds,
                pLimite: pageSize,
                pOffset: offsetAtual,
              );
            }

            final pageRecords = _safeRecordsFromApi(rebanhosAPIO.jsonBody);
            _syncLog('rebanho',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('rebanho',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              break;
            }

            final result = await actions.batchInsertLocalRebanho(pageRecords);
            final pageErrors =
                result['errors'] as List<Map<String, String>>? ?? [];
            if (pageErrors.isNotEmpty) {
              _syncLog('rebanho',
                  '${pageErrors.length} erro(s) ao inserir. offset=$offsetAtual.');
              syncErrors.addAll(pageErrors);
            }
            totalInserted += (result['inserted'] as int? ?? 0);
            _syncLog('rebanho',
                '${result['inserted']} registros inseridos nesta página.');

            FFAppState().indexRebPaginacao =
                FFAppState().indexRebPaginacao + pageRecords.length;
            if (pageRecords.length < 999) {
              _syncLog('rebanho',
                  'Última página detectada (tamanho < 999). Encerrando paginação.');
              break;
            }
          } catch (e, s) {
            _syncLog('rebanho',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            FFAppState().indexRebPaginacao =
                FFAppState().indexRebPaginacao + 999;
          }
        }

        try {
          await Future.wait([
            action_blocks.animaisRegistrados(context),
            action_blocks.animaisPropriedade(context),
          ]);
        } catch (e) {
          _syncLog('rebanho', 'Erro ao atualizar contadores: $e');
        }

        FFAppState().rebanhosIndex = 0;
        if (syncErrors.isNotEmpty) {
          syncOk = false;
          _syncLog(
              'rebanho', 'Total de erros acumulados: ${syncErrors.length}.');
        }
        if (totalInserted > 0 || syncErrors.isEmpty) {
          FFAppState().rebanhosChangeDateTime =
              remoteLastChange ?? DateTime.now();
        }
        if (syncOk) {
          _syncLog('rebanho',
              'Sincronização finalizada com sucesso. $totalInserted registros inseridos.');
        } else {
          _syncLog('rebanho',
              'Sincronização finalizada com erros. ${syncErrors.length} registro(s) falharam.');
        }
        await _showSyncErrorsDialog(context, 'Rebanho', syncErrors);
      } catch (e, s) {
        _syncLog('rebanho', 'ERRO FATAL na sincronização: $e\n$s');
      } finally {
        FFAppState().indexRebPaginacao = 0;
        FFAppState().visibleProgressBar = false;
        FFAppState().update(() {});
      }
    } else {
      _syncLog('rebanho', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('rebanho', 'EXCEÇÃO NÃO TRATADA: $e\n$s');
  }
}

Future refreshReproducaoOtimizada(BuildContext context) async {
  try {
    _syncLog('reproducao', 'Iniciando verificação do change tracker...');
    List<ReproducaoChangeTrackerRow>? lastChangeResultO;
    ApiCallResponse? propriedades;
    ApiCallResponse? qtdReproducoes;
    ApiCallResponse? reproducaoAPI;

    try {
      lastChangeResultO = await _withTimeout(
        () => ReproducaoChangeTrackerTable().queryRows(queryFn: (q) => q),
        label: 'reproducao.changeTracker.queryRows',
        timeout: kSyncLightTimeout,
      );
    } on TimeoutException catch (e, s) {
      _syncLog('reproducao', 'TIMEOUT ao consultar change tracker: $e\n$s');
      lastChangeResultO = [];
    } catch (e, s) {
      _syncLog('reproducao', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResultO = [];
    }
    final remoteLastChange = lastChangeResultO?.firstOrNull?.lastChange;
    final localLastChange = FFAppState().reproducaoChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('reproducao',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    if (shouldSync) {
      final isFirst = _isFirstSync(localLastChange) ||
          await _isLocalTableEmpty('local_reproducao');
      _syncLog('reproducao',
          'Iniciando sincronização ${isFirst ? "COMPLETA (primeiro sync)" : "INCREMENTAL"}.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      FFAppState().indexReproPaginacao = 0;
      FFAppState().visibilidadeProgressBarRepro = true;
      FFAppState().update(() {});

      final String? updatedAfter =
          (!isFirst && localLastChange != null)
              ? localLastChange.toUtc().toIso8601String()
              : null;

      try {
        propriedades = await _withTimeout(
          () => SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
            pUserId: currentUserUid,
          ),
          label: 'reproducao.buscarPropriedadesUser',
          timeout: kSyncPageTimeout,
        );

        final propertyIds = _safePropertyIds(propriedades?.jsonBody);
        _syncLog('reproducao',
            'Propriedades encontradas: ${propertyIds.length}. IDs: $propertyIds');

        if (propertyIds.isEmpty) {
          _syncLog(
              'reproducao', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        if (updatedAfter != null) {
          qtdReproducoes = await _withTimeout(
            () => SupabaseFunctionsGroup.qTDReproducoesIncCall.call(
              pIdsPropriedadesList: propertyIds,
              pUpdatedAfter: updatedAfter,
            ),
            label: 'reproducao.qTDReproducoesInc',
            timeout: kSyncPageTimeout,
          );
        } else {
          qtdReproducoes = await _withTimeout(
            () => SupabaseFunctionsGroup.qTDReproducoesCall.call(
              pIdsPropriedadesList: propertyIds,
            ),
            label: 'reproducao.qTDReproducoes',
            timeout: kSyncPageTimeout,
          );
        }
        _syncLog('reproducao',
            'Resposta qtdReproducoes raw: ${qtdReproducoes?.jsonBody}');

        final totalReproducoes = _safeTotalFromApi(qtdReproducoes?.jsonBody);
        FFAppState().totalReproducoes = totalReproducoes;
        _syncLog('reproducao',
            'Total remoto informado: $totalReproducoes (${updatedAfter != null ? "incremental desde $updatedAfter" : "completo"}).');

        if (totalReproducoes == 0 && updatedAfter != null) {
          _syncLog('reproducao',
              'Nenhuma alteração remota desde último sync. Atualizando timestamp.');
          FFAppState().reproducaoChangeDateTime =
              remoteLastChange ?? DateTime.now();
          return;
        }

        if (isFirst) {
          // Primeiro sync: UPSERT sem deletar para segurança
          _syncLog('reproducao', 'Primeiro sync. Iniciando paginação (UPSERT)...');
        } else {
          _syncLog('reproducao',
              'Sync incremental — mantendo dados locais. Iniciando paginação (UPSERT)...');
        }
        while (FFAppState().indexReproPaginacao < totalReproducoes) {
          final offsetAtual = FFAppState().indexReproPaginacao;
          // B5: page size adaptativo
          final pageSize = await _adaptivePageSize();
          try {
            if (updatedAfter != null) {
              reproducaoAPI = await _withTimeout(
                () => SupabaseFunctionsGroup.buscarReproducoesIncCall.call(
                  pIdPropriedadeList: propertyIds,
                  pLimite: pageSize,
                  pOffset: offsetAtual,
                  pUpdatedAfter: updatedAfter,
                ),
                label: 'reproducao.buscarReproducoesInc(offset=$offsetAtual)',
                timeout: kSyncPageTimeout,
              );
            } else {
              reproducaoAPI = await _withTimeout(
                () => SupabaseFunctionsGroup.buscarReproducoesCall.call(
                  pIdPropriedadeList: propertyIds,
                  pLimite: pageSize,
                  pOffset: offsetAtual,
                ),
                label: 'reproducao.buscarReproducoes(offset=$offsetAtual)',
                timeout: kSyncPageTimeout,
              );
            }

            final pageRecords = _safeRecordsFromApi(reproducaoAPI?.jsonBody);
            _syncLog('reproducao',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('reproducao',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              break;
            }

            final result =
                await actions.batchInsertLocalReproducao(pageRecords);
            final pageErrors =
                result['errors'] as List<Map<String, String>>? ?? [];
            if (pageErrors.isNotEmpty) {
              _syncLog('reproducao',
                  '${pageErrors.length} erro(s) ao inserir. offset=$offsetAtual.');
              syncErrors.addAll(pageErrors);
            }
            totalInserted += (result['inserted'] as int? ?? 0);
            _syncLog('reproducao',
                '${result['inserted']} registros inseridos nesta página.');

            FFAppState().indexReproPaginacao =
                FFAppState().indexReproPaginacao + pageRecords.length;
            if (pageRecords.length < 999) {
              _syncLog('reproducao',
                  'Última página detectada (tamanho < 999). Encerrando paginação.');
              break;
            }
          } on TimeoutException catch (e) {
            _syncLog('reproducao',
                'TIMEOUT em página offset=$offsetAtual: $e. Abortando paginação.');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Timeout na requisição',
            });
            // A8: não avançamos offset cegamente; quebra o loop para não
            // pular registros remotos que ainda não chegaram.
            break;
          } catch (e, s) {
            _syncLog('reproducao',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            // A8: quebra em vez de incrementar 999 e mascarar erro.
            break;
          }
        }

        try {
          await action_blocks.qTDReproducoes(context);
        } catch (e) {
          _syncLog('reproducao', 'Erro ao atualizar contadores: $e');
        }
        if (syncErrors.isNotEmpty) {
          syncOk = false;
          _syncLog(
              'reproducao', 'Total de erros acumulados: ${syncErrors.length}.');
        }
        if (totalInserted > 0 || syncErrors.isEmpty) {
          FFAppState().reproducaoChangeDateTime =
              remoteLastChange ?? DateTime.now();
        }
        if (syncOk) {
          _syncLog('reproducao',
              'Sincronização finalizada com sucesso. $totalInserted registros inseridos.');
        } else {
          _syncLog('reproducao',
              'Sincronização finalizada com erros. ${syncErrors.length} registro(s) falharam.');
        }
        await _showSyncErrorsDialog(context, 'Reprodução', syncErrors);
      } catch (e, s) {
        _syncLog('reproducao', 'ERRO FATAL na sincronização: $e\n$s');
      } finally {
        FFAppState().indexReproPaginacao = 0;
        FFAppState().visibilidadeProgressBarRepro = false;
        FFAppState().update(() {});
      }
    } else {
      _syncLog('reproducao', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('reproducao', 'EXCEÇÃO NÃO TRATADA: $e\n$s');
  }
}

Future refreshPesagens(BuildContext context) async {
  try {
    _syncLog('pesagens', 'Iniciando sincronização...');
    ApiCallResponse? propriedadessO;
    ApiCallResponse? pesagensAPI;

    // Verificar change tracker antes de sincronizar (como os outros módulos)
    List<HistoricoPesagensChangeTrackerRow>? lastChangeResult;
    try {
      lastChangeResult = await HistoricoPesagensChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e, s) {
      _syncLog('pesagens', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResult = [];
    }
    final remoteLastChange = lastChangeResult.firstOrNull?.lastChange;
    final localLastChange = FFAppState().pesagensChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        _isFirstSync(localLastChange) ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('pesagens',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    if (!shouldSync) {
      _syncLog('pesagens', 'Sem necessidade de sincronização.');
      return;
    }

    final isFirst = _isFirstSync(localLastChange) ||
        await _isLocalTableEmpty('local_historico_pesagens');
    final String? updatedAfter =
        (!isFirst && localLastChange != null)
            ? localLastChange.toUtc().toIso8601String()
            : null;

    _syncLog('pesagens',
        'Iniciando sincronização ${isFirst ? "COMPLETA (primeiro sync)" : "INCREMENTAL desde $updatedAfter"}.');
    var syncOk = true;
    final List<Map<String, String>> syncErrors = [];
    int totalInserted = 0;

    try {
      propriedadessO =
          await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
        pUserId: currentUserUid,
      );

      final propertyIds = _safePropertyIds(propriedadessO.jsonBody);
      _syncLog('pesagens',
          'Propriedades encontradas: ${propertyIds.length}. IDs: $propertyIds');

      if (propertyIds.isEmpty) {
        _syncLog('pesagens', 'Nenhuma propriedade encontrada. Abortando sync.');
        return;
      }

      // Buscar a primeira página direto da tabela REST, pois a RPC de
      // pesagens está retornando 0/[] apesar de existirem registros.
      pesagensAPI = await _buscarPesagensDireto(
        propertyIds: propertyIds,
        limit: 999,
        offset: 0,
        includeCount: true,
        updatedAfter: updatedAfter,
      );

      final firstPageRecords = _safeRecordsFromApi(pesagensAPI.jsonBody);
      final totalPesagens = _safeTotalFromContentRange(pesagensAPI.headers) > 0
          ? _safeTotalFromContentRange(pesagensAPI.headers)
          : firstPageRecords.length;
      FFAppState().totalPesagens = totalPesagens;
      FFAppState().indexPesagens = 0;
      _syncLog('pesagens', 'Total remoto informado: $totalPesagens.');
      _syncLog('pesagens',
          'Primeira página parseada: ${firstPageRecords.length} registros.');

      if (firstPageRecords.isEmpty) {
        if (updatedAfter != null) {
          _syncLog('pesagens',
              'Nenhuma alteração remota desde último sync. Atualizando timestamp.');
          FFAppState().pesagensChangeDateTime = remoteLastChange ?? DateTime.now();
        } else {
          _syncLog('pesagens',
              'Primeira página vazia apesar de total=$totalPesagens. Não apagando dados locais. Abortando sync.');
        }
        return;
      }

      if (isFirst) {
        // Primeiro sync: UPSERT sem deletar para segurança
        _syncLog('pesagens', 'Primeiro sync. Inserindo primeira página (UPSERT)...');
      } else {
        _syncLog('pesagens',
            'Sync incremental — mantendo dados locais (UPSERT). Inserindo primeira página...');
      }

      // Inserir a primeira página já obtida
      final firstResult =
          await actions.batchInsertLocalPesagens(firstPageRecords);
      final firstPageErrors =
          firstResult['errors'] as List<Map<String, String>>? ?? [];
      if (firstPageErrors.isNotEmpty) {
        syncErrors.addAll(firstPageErrors);
      }
      totalInserted += (firstResult['inserted'] as int? ?? 0);
      _syncLog('pesagens',
          '${firstResult['inserted']} registros inseridos na primeira página.');

      FFAppState().indexPesagens = firstPageRecords.length;

      // Continuar com as páginas restantes
      if (firstPageRecords.length >= 999) {
        while (true) {
          final offsetAtual = FFAppState().indexPesagens;
          try {
            pesagensAPI = await _buscarPesagensDireto(
              propertyIds: propertyIds,
              limit: 999,
              offset: offsetAtual,
              updatedAfter: updatedAfter,
            );

            final pageRecords = _safeRecordsFromApi(pesagensAPI.jsonBody);
            _syncLog('pesagens',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('pesagens',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              break;
            }

            final result = await actions.batchInsertLocalPesagens(pageRecords);
            final pageErrors =
                result['errors'] as List<Map<String, String>>? ?? [];
            if (pageErrors.isNotEmpty) {
              _syncLog('pesagens',
                  '${pageErrors.length} erro(s) ao inserir. offset=$offsetAtual.');
              syncErrors.addAll(pageErrors);
            }
            totalInserted += (result['inserted'] as int? ?? 0);
            _syncLog('pesagens',
                '${result['inserted']} registros inseridos nesta página.');

            FFAppState().indexPesagens =
                FFAppState().indexPesagens + pageRecords.length;
            if (pageRecords.length < 999) {
              _syncLog('pesagens',
                  'Última página detectada (tamanho < 999). Encerrando paginação.');
              break;
            }
          } catch (e, s) {
            _syncLog('pesagens',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            FFAppState().indexPesagens = FFAppState().indexPesagens + 999;
          }
        }
      }

      // ── Catch-up: buscar pesagens com id_propriedade NULL ──────────
      // Registros criados pela web podem não ter id_propriedade preenchido,
      // o que faz com que o filtro principal (in.props) os ignore.
      // Aqui buscamos esses registros usando os idRebanho locais do usuário.
      try {
        final localRebIds = await _getLocalRebanhoIds();
        if (localRebIds.isNotEmpty) {
          _syncLog('pesagens',
              'Catch-up: verificando pesagens com id_propriedade NULL para ${localRebIds.length} animais.');
          const batchSize = 200;
          for (var i = 0; i < localRebIds.length; i += batchSize) {
            final batch = localRebIds.sublist(
                i,
                i + batchSize > localRebIds.length
                    ? localRebIds.length
                    : i + batchSize);
            var catchupOffset = 0;
            while (true) {
              final resp = await _buscarPesagensSemPropriedade(
                rebanhoIds: batch,
                limit: 999,
                offset: catchupOffset,
              );
              final recs = _safeRecordsFromApi(resp.jsonBody);
              if (recs.isEmpty) break;

              final result = await actions.batchInsertLocalPesagens(recs);
              final cnt = result['inserted'] as int? ?? 0;
              totalInserted += cnt;
              final errs =
                  result['errors'] as List<Map<String, String>>? ?? [];
              if (errs.isNotEmpty) syncErrors.addAll(errs);
              _syncLog('pesagens',
                  'Catch-up: $cnt registros inseridos (batch ${i ~/ batchSize}, offset=$catchupOffset).');

              if (recs.length < 999) break;
              catchupOffset += recs.length;
            }
          }
        }
      } catch (e, s) {
        _syncLog('pesagens', 'Erro no catch-up de pesagens sem propriedade: $e\n$s');
      }
      // ── Fim catch-up ──────────────────────────────────────────────

      if (syncErrors.isNotEmpty) {
        syncOk = false;
        _syncLog(
            'pesagens', 'Total de erros acumulados: ${syncErrors.length}.');
      }
      // Sempre atualiza o timestamp para evitar re-sync infinito
      // Usa o remoteLastChange do change tracker para precisão
      FFAppState().pesagensChangeDateTime = remoteLastChange ?? DateTime.now();
      _syncLog('pesagens',
          'Timestamp atualizado para: ${FFAppState().pesagensChangeDateTime}. $totalInserted registros inseridos.');
      if (syncOk) {
        _syncLog('pesagens',
            'Sincronização finalizada com sucesso. $totalInserted registros inseridos.');
      } else {
        _syncLog('pesagens',
            'Sincronização finalizada com erros. ${syncErrors.length} registro(s) falharam.');
      }
      await _showSyncErrorsDialog(context, 'Pesagens', syncErrors);
    } catch (e, s) {
      _syncLog('pesagens', 'ERRO FATAL na sincronização: $e\n$s');
    } finally {
      FFAppState().indexPesagens = 0;
    }
  } catch (e, s) {
    _syncLog('pesagens', 'EXCEÇÃO NÃO TRATADA: $e\n$s');
  }
}

Future refresSanidadeOtimizada(BuildContext context) async {
  try {
    _syncLog('sanidade', 'Iniciando verificação do change tracker...');
    List<SanidadeChangeTrackerRow>? lastChangeResult;
    ApiCallResponse? propriedades;
    ApiCallResponse? qtdSanidades;
    ApiCallResponse? sanidadesAPI;

    try {
      lastChangeResult = await SanidadeChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e, s) {
      _syncLog('sanidade', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResult = [];
    }
    final remoteLastChange = lastChangeResult.firstOrNull?.lastChange;
    final localLastChange = FFAppState().sanidadeChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('sanidade',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    if (shouldSync) {
      final isFirst = _isFirstSync(localLastChange) ||
          await _isLocalTableEmpty('local_sanidade');
      _syncLog('sanidade',
          'Iniciando sincronização ${isFirst ? "COMPLETA (primeiro sync)" : "INCREMENTAL"}.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      FFAppState().sanidadeIndex = 0;
      FFAppState().indexSanidadePaginacao = 0;
      FFAppState().visbilidadeProgressBarSan = true;
      FFAppState().update(() {});

      final String? updatedAfter =
          (!isFirst && localLastChange != null)
              ? localLastChange.toUtc().toIso8601String()
              : null;

      try {
        propriedades =
            await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
          pUserId: currentUserUid,
        );

        final propertyIds = _safePropertyIds(propriedades.jsonBody);
        _syncLog('sanidade',
            'Propriedades encontradas: ${propertyIds.length}. IDs: $propertyIds');

        if (propertyIds.isEmpty) {
          _syncLog(
              'sanidade', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        if (updatedAfter != null) {
          qtdSanidades =
              await SupabaseFunctionsGroup.qTDSanidadeIncCall.call(
            pIdsPropriedadesList: propertyIds,
            pUpdatedAfter: updatedAfter,
          );
        } else {
          qtdSanidades = await SupabaseFunctionsGroup.qTDSanidadeCall.call(
            pIdsPropriedadesList: propertyIds,
          );
        }
        _syncLog(
            'sanidade', 'Resposta qtdSanidades raw: ${qtdSanidades.jsonBody}');

        final totalSanidades = _safeTotalFromApi(qtdSanidades.jsonBody);
        FFAppState().totalSanidades = totalSanidades;
        _syncLog('sanidade',
            'Total remoto informado: $totalSanidades (${updatedAfter != null ? "incremental desde $updatedAfter" : "completo"}).');

        if (totalSanidades == 0 && updatedAfter != null) {
          _syncLog('sanidade',
              'Nenhuma alteração remota desde último sync. Atualizando timestamp.');
          FFAppState().sanidadeChangeDateTime =
              remoteLastChange ?? DateTime.now();
          return;
        }

        if (isFirst) {
          // Primeiro sync: UPSERT sem deletar para segurança
          _syncLog('sanidade', 'Primeiro sync. Iniciando paginação (UPSERT)...');
        } else {
          _syncLog('sanidade',
              'Sync incremental — mantendo dados locais. Iniciando paginação (UPSERT)...');
        }
        while (FFAppState().indexSanidadePaginacao < totalSanidades) {
          final offsetAtual = FFAppState().indexSanidadePaginacao;
          // B5: page size adaptativo
          final pageSize = await _adaptivePageSize();
          try {
            if (updatedAfter != null) {
              sanidadesAPI =
                  await SupabaseFunctionsGroup.buscarSanidadesIncCall.call(
                pIdPropriedadeList: propertyIds,
                pLimite: pageSize,
                pOffset: offsetAtual,
                pUpdatedAfter: updatedAfter,
              );
            } else {
              sanidadesAPI =
                  await SupabaseFunctionsGroup.buscarSanidadesCall.call(
                pIdPropriedadeList: propertyIds,
                pLimite: pageSize,
                pOffset: offsetAtual,
              );
            }

            final pageRecords = _safeRecordsFromApi(sanidadesAPI.jsonBody);
            _syncLog('sanidade',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('sanidade',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              break;
            }

            final result = await actions.batchInsertLocalSanidade(pageRecords);
            final pageErrors =
                result['errors'] as List<Map<String, String>>? ?? [];
            if (pageErrors.isNotEmpty) {
              _syncLog('sanidade',
                  '${pageErrors.length} erro(s) ao inserir. offset=$offsetAtual.');
              syncErrors.addAll(pageErrors);
            }
            totalInserted += (result['inserted'] as int? ?? 0);
            _syncLog('sanidade',
                '${result['inserted']} registros inseridos nesta página.');

            FFAppState().indexSanidadePaginacao =
                FFAppState().indexSanidadePaginacao + pageRecords.length;
            if (pageRecords.length < 999) {
              _syncLog('sanidade',
                  'Última página detectada (tamanho < 999). Encerrando paginação.');
              break;
            }
          } catch (e, s) {
            _syncLog('sanidade',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            FFAppState().indexSanidadePaginacao =
                FFAppState().indexSanidadePaginacao + 999;
          }
        }

        try {
          await action_blocks.qTDSanidades(context);
        } catch (e) {
          _syncLog('sanidade', 'Erro ao atualizar contadores: $e');
        }
        if (syncErrors.isNotEmpty) {
          syncOk = false;
          _syncLog(
              'sanidade', 'Total de erros acumulados: ${syncErrors.length}.');
        }
        if (totalInserted > 0 || syncErrors.isEmpty) {
          FFAppState().sanidadeChangeDateTime =
              remoteLastChange ?? DateTime.now();
        }
        if (syncOk) {
          _syncLog('sanidade',
              'Sincronização finalizada com sucesso. $totalInserted registros inseridos.');
        } else {
          _syncLog('sanidade',
              'Sincronização finalizada com erros. ${syncErrors.length} registro(s) falharam.');
        }
        await _showSyncErrorsDialog(context, 'Sanidade', syncErrors);
      } catch (e, s) {
        _syncLog('sanidade', 'ERRO FATAL na sincronização: $e\n$s');
      } finally {
        FFAppState().indexSanidadePaginacao = 0;
        FFAppState().visbilidadeProgressBarSan = false;
        FFAppState().update(() {});
      }
    } else {
      _syncLog('sanidade', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('sanidade', 'EXCEÇÃO NÃO TRATADA: $e\n$s');
  }
}
