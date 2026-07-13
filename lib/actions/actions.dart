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
import 'package:shared_preferences/shared_preferences.dart';

void _syncLog(String flow, String message) {
  // Atualiza heartbeat a cada log — permite watchdogs externos detectarem
  // stall (nenhum progresso por N segundos).
  FFAppState().lastSyncHeartbeat = DateTime.now();
  SyncTelemetry.log(flow: flow, message: message);
  debugPrint('[SYNC][$flow] $message');
}

const String _accountBlockedMessage =
    'Sincronização interrompida: sua conta encontra-se bloqueada devido ao término do período de teste e/ou pagamentos pendentes.\n\n'
    'Para restabelecer o serviço e continuar utilizando a plataforma, regularize sua assinatura.\n\n'
    'Em caso de dúvidas, entre em contato pelo WhatsApp 📱 (19) 98423-1009 ou pelo e-mail ✉️ comercial@inlida.com.br';

bool isAccountAccessCanceled(String? acesso) =>
    acesso?.trim().toLowerCase() == 'cancelado';

Future<String?> refreshCurrentUserAccess() async {
  if (currentUserUid.trim().isEmpty) return FFAppState().userLogado.acesso;

  final userRows = await UsersTable().queryRows(
    queryFn: (q) => q.eqOrNull(
      'userID',
      currentUserUid,
    ),
  );
  final user = userRows.firstOrNull;
  if (user == null) return FFAppState().userLogado.acesso;

  FFAppState().updateUserLogadoStruct(
    (e) => e
      ..nome = user.nome
      ..email = user.email
      ..foto = user.foto
      ..id = currentUserUid
      ..telefone = user.telefone
      ..permissao = user.permissao
      ..acesso = user.acesso,
  );
  return user.acesso;
}

Future<void> showAccountBlockedInformationDialog(BuildContext context) async {
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (alertDialogContext) {
      return AlertDialog(
        title: const Text('Informação'),
        content: const Text(_accountBlockedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<bool> blockIfAccountCanceled(
  BuildContext context, {
  bool refreshFromServer = false,
  bool showDialog = true,
}) async {
  String? acesso = FFAppState().userLogado.acesso;
  if (refreshFromServer) {
    try {
      acesso = await refreshCurrentUserAccess();
    } catch (e) {
      debugPrint('[ACESSO] Erro ao consultar acesso do usuário: $e');
    }
  }

  if (!isAccountAccessCanceled(acesso)) return false;

  FFAppState().update(() {
    FFAppState().navegacaoDashboard = 'painel';
    FFAppState().syncCancelRequested = true;
    FFAppState().syncProgressPercent = -1;
    FFAppState().syncProgressLabel = '';
    FFAppState().isSyncing = false;
  });

  if (showDialog) {
    await showAccountBlockedInformationDialog(context);
  }
  return true;
}

String? _descreverRebanhoBy(String? numero) {
  if (numero == null || numero.isEmpty) return null;
  return 'Animal nº $numero';
}

String? _descreverLoteBy(String? nome) {
  final normalized = nome?.trim();
  if (normalized == null || normalized.isEmpty) return null;
  return normalized;
}

String? _descreverReproducaoBy(String? data) {
  if (data == null || data.isEmpty) return null;
  return 'Inseminação em $data';
}

int _loteRowRecencyScore(Map<String, dynamic> data) {
  for (final key in const ['sync_updated_at', 'updated_at', 'created_at']) {
    final raw = data[key]?.toString().trim();
    if (raw == null || raw.isEmpty || raw.toLowerCase() == 'null') {
      continue;
    }
    final parsed = DateTime.tryParse(
      raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'),
    );
    if (parsed != null) return parsed.millisecondsSinceEpoch;
  }

  final id = data['id'];
  if (id is int) return id;
  return int.tryParse(id?.toString() ?? '') ?? 0;
}

List<BuscarLotePUTRow> _dedupLotePutRows(List<BuscarLotePUTRow> rows) {
  final byId = <String, BuscarLotePUTRow>{};
  final withoutId = <BuscarLotePUTRow>[];
  for (final row in rows) {
    final id = row.idLote?.trim();
    if (id == null || id.isEmpty) {
      withoutId.add(row);
      continue;
    }
    final previous = byId[id];
    if (previous == null ||
        _loteRowRecencyScore(row.data) >= _loteRowRecencyScore(previous.data)) {
      byId[id] = row;
    }
  }
  return [...withoutId, ...byId.values];
}

List<BuscarLoteUPDTRow> _dedupLoteUpdateRows(List<BuscarLoteUPDTRow> rows) {
  final byId = <String, BuscarLoteUPDTRow>{};
  final withoutId = <BuscarLoteUPDTRow>[];
  for (final row in rows) {
    final id = row.idLote?.trim();
    if (id == null || id.isEmpty) {
      withoutId.add(row);
      continue;
    }
    final previous = byId[id];
    if (previous == null ||
        _loteRowRecencyScore(row.data) >= _loteRowRecencyScore(previous.data)) {
      byId[id] = row;
    }
  }
  return [...withoutId, ...byId.values];
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
  _syncLog(flow, 'ERRO $operacao $modulo id=${registroId ?? "?"}: $erro');
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
      () =>
          SupaFlow.client.from(tableName).upsert(chunk, onConflict: onConflict),
      label: '$label.upsert(chunk=${chunk.length}, onConflict=$onConflict)',
      timeout: kSyncPageTimeout,
    );
    _syncLog(label,
        'Upsert ok: ${chunk.length} registro(s) (offset=$start/${rows.length}).');
  }
}

/// UPDATE explícito de rebanho por idRebanho.
///
/// Usado para edição de animal existente: não deve tentar INSERT. Retorna
/// `true` quando o Supabase atualizou ao menos uma linha e `false` quando o
/// idRebanho não foi encontrado no servidor.
Future<bool> _updateRebanhoSupabaseById(
  Map<String, dynamic> payload, {
  required String label,
}) async {
  final idRebanho = payload['idRebanho']?.toString();
  if (idRebanho == null || idRebanho.isEmpty) {
    throw ArgumentError('Payload de rebanho sem idRebanho para UPDATE.');
  }

  final updatePayload = Map<String, dynamic>.from(payload)
    ..remove('idRebanho')
    ..remove('created_at');

  final localUpdatedAt = _parseSyncDate(updatePayload['updated_at']);
  if (localUpdatedAt != null) {
    final current = await _withTimeout(
      () => SupaFlow.client
          .from('rebanho')
          .select('idRebanho,updated_at')
          .eq('idRebanho', idRebanho)
          .limit(1),
      label: '$label.precheck(idRebanho=$idRebanho)',
      timeout: kSyncPageTimeout,
    );
    final remoteUpdatedAt = current.isEmpty
        ? null
        : _parseSyncDate((current.first as Map)['updated_at']);
    if (remoteUpdatedAt != null &&
        remoteUpdatedAt.toUtc().isAfter(localUpdatedAt.toUtc())) {
      _syncLog(
        label,
        'UPDATE rebanho ignorado: idRebanho=$idRebanho tem updated_at remoto mais recente ($remoteUpdatedAt > $localUpdatedAt).',
      );
      return true;
    }
  }

  final updated = await _withTimeout(
    () => SupaFlow.client
        .from('rebanho')
        .update(updatePayload)
        .eq('idRebanho', idRebanho)
        .select('idRebanho'),
    label: '$label.update(idRebanho=$idRebanho)',
    timeout: kSyncPageTimeout,
  );
  return updated.isNotEmpty;
}

DateTime? _parseSyncDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final raw = value.toString().trim();
  if (raw.isEmpty || raw == 'null') return null;
  return DateTime.tryParse(raw);
}

Future<Set<String>> _buscarRebanhoIdsRemotos(
  Iterable<String?> ids, {
  required String label,
}) async {
  final validIds = ids
      .whereType<String>()
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  if (validIds.isEmpty) return <String>{};

  final found = <String>{};
  const chunkSize = 200;
  for (var start = 0; start < validIds.length; start += chunkSize) {
    _throwIfCancelled(label);
    final end = (start + chunkSize < validIds.length)
        ? start + chunkSize
        : validIds.length;
    final chunk = validIds.sublist(start, end);
    final rows = await _withTimeout(
      () => SupaFlow.client
          .from('rebanho')
          .select('idRebanho')
          .inFilter('idRebanho', chunk),
      label: '$label.select(chunk=${chunk.length})',
      timeout: kSyncPageTimeout,
    );
    for (final row in rows as List) {
      final id = (row as Map)['idRebanho']?.toString().trim();
      if (id != null && id.isNotEmpty) found.add(id);
    }
  }
  return found;
}

/// UPDATE explícito de reprodução por id_reproducao.
///
/// Edição/deleção não deve virar INSERT silencioso. Retorna `true` quando
/// alguma linha remota foi atualizada e `false` quando o id não existe mais.
Future<bool> _updateReproducaoSupabaseById(
  Map<String, dynamic> payload, {
  required String label,
}) async {
  final idReproducao = payload['id_reproducao']?.toString();
  if (idReproducao == null || idReproducao.isEmpty) {
    throw ArgumentError('Payload de reprodução sem id_reproducao para UPDATE.');
  }

  final updatePayload = Map<String, dynamic>.from(payload)
    ..remove('id_reproducao');
  final updated = await _withTimeout(
    () => SupaFlow.client
        .from('reproducao')
        .update(updatePayload)
        .eq('id_reproducao', idReproducao)
        .select('id_reproducao'),
    label: '$label.update(id_reproducao=$idReproducao)',
    timeout: kSyncPageTimeout,
  );
  return updated.isNotEmpty;
}

/// UPDATE explícito de sanidade por id_sanidade.
Future<bool> _updateSanidadeSupabaseById(
  Map<String, dynamic> payload, {
  required String label,
}) async {
  final idSanidade = payload['id_sanidade']?.toString();
  if (idSanidade == null || idSanidade.isEmpty) {
    throw ArgumentError('Payload de sanidade sem id_sanidade para UPDATE.');
  }

  final updatePayload = Map<String, dynamic>.from(payload)
    ..remove('id_sanidade');
  final updated = await _withTimeout(
    () => SupaFlow.client
        .from('sanidade')
        .update(updatePayload)
        .eq('id_sanidade', idSanidade)
        .select('id_sanidade'),
    label: '$label.update(id_sanidade=$idSanidade)',
    timeout: kSyncPageTimeout,
  );
  return updated.isNotEmpty;
}

/// UPDATE explícito de lote por id_lote.
///
/// Edição/deleção não deve virar INSERT silencioso: quando o registro remoto
/// não existe, retornamos `false` para manter a pendência e exibir erro.
Future<bool> _updateLoteSupabaseById(
  Map<String, dynamic> payload, {
  required String label,
}) async {
  final idLote = payload['id_lote']?.toString();
  if (idLote == null || idLote.isEmpty) {
    throw ArgumentError('Payload de lote sem id_lote para UPDATE.');
  }

  final updatePayload = Map<String, dynamic>.from(payload)
    ..remove('id_lote')
    ..remove('created_at');
  final updated = await _withTimeout(
    () => SupaFlow.client
        .from('lotes')
        .update(updatePayload)
        .eq('id_lote', idLote)
        .select('id_lote'),
    label: '$label.update(id_lote=$idLote)',
    timeout: kSyncPageTimeout,
  );
  return updated.isNotEmpty;
}

/// INSERT em lote (sem onConflict). Use para tabelas onde a PK é gerada pelo
/// servidor (ex: `historico_pesagens.id` auto-increment) e o registro local
/// não tem identificador para upsert idempotente.
Future<void> _batchInsertSupabase({
  required String tableName,
  required List<Map<String, dynamic>> rows,
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
      () => SupaFlow.client.from(tableName).insert(chunk),
      label: '$label.insert(chunk=${chunk.length})',
      timeout: kSyncPageTimeout,
    );
    _syncLog(label,
        'Insert ok: ${chunk.length} registro(s) (offset=$start/${rows.length}).');
  }
}

Future<void> _batchUpdatePesagemDeletesByIdPesagem({
  required List<String> ids,
  int chunkSize = 200,
  required String label,
}) async {
  if (ids.isEmpty) return;
  for (var start = 0; start < ids.length; start += chunkSize) {
    _throwIfCancelled(label);
    final end =
        (start + chunkSize < ids.length) ? start + chunkSize : ids.length;
    final chunk = ids.sublist(start, end);
    await _withTimeout(
      () => SupaFlow.client
          .from('historico_pesagens')
          .update({'deletado': 'SIM'}).inFilter('id_pesagem', chunk),
      label: '$label.updateDelete(chunk=${chunk.length})',
      timeout: kSyncPageTimeout,
    );
    _syncLog(label,
        'Delete remoto ok: ${chunk.length} id_pesagem(s) (offset=$start/${ids.length}).');
  }
}

Future<void> _clearLocalPesagemSyncDirtyByIds(
  Iterable<String?> ids, {
  required String label,
}) async {
  final validIds = ids
      .whereType<String>()
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  if (validIds.isEmpty) return;

  final db = SQLiteManager.instance.database;
  const chunkSize = 500;
  for (var start = 0; start < validIds.length; start += chunkSize) {
    final end = (start + chunkSize < validIds.length)
        ? start + chunkSize
        : validIds.length;
    final chunk = validIds.sublist(start, end);
    final placeholders = List.filled(chunk.length, '?').join(',');
    final now = DateTime.now()
        .toIso8601String()
        .substring(0, 19)
        .replaceFirst('T', ' ');
    await db.rawUpdate(
      '''
      UPDATE local_historico_pesagens
      SET sync_dirty = 0,
          sync_op = NULL,
          sync_updated_at = ?
      WHERE id_pesagem IN ($placeholders)
      ''',
      [now, ...chunk],
    );
  }
  _syncLog(label,
      'Marcador local de sync limpo para ${validIds.length} pesagem(ns).');
}

Future<void> _clearLocalPesagemSyncDirtyByPayloads(
  Iterable<Map<String, dynamic>> payloads, {
  required String label,
}) async {
  String? normDate(dynamic value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty || raw == 'null') return null;
    return raw.length >= 10 ? raw.substring(0, 10) : raw;
  }

  String? normPeso(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toStringAsFixed(3);
    final parsed = double.tryParse(value.toString().replaceAll(',', '.'));
    return parsed?.toStringAsFixed(3);
  }

  final identities = <String, List<String>>{};
  for (final payload in payloads) {
    final idRebanho = payload['idRebanho']?.toString().trim();
    final dataPesagem = normDate(payload['dataPesagem']);
    final tipo = payload['tipo']?.toString().trim();
    final peso = normPeso(payload['peso']);
    if (idRebanho == null ||
        idRebanho.isEmpty ||
        dataPesagem == null ||
        dataPesagem.isEmpty ||
        tipo == null ||
        tipo.isEmpty ||
        peso == null ||
        peso.isEmpty) {
      continue;
    }
    identities['$idRebanho|$dataPesagem|$tipo|$peso'] = [
      idRebanho,
      dataPesagem,
      tipo,
      peso,
    ];
  }

  if (identities.isEmpty) return;

  final db = SQLiteManager.instance.database;
  final now =
      DateTime.now().toIso8601String().substring(0, 19).replaceFirst('T', ' ');
  var updated = 0;
  for (final identity in identities.values) {
    updated += await db.rawUpdate(
      '''
      UPDATE local_historico_pesagens
      SET sync_dirty = 0,
          sync_op = NULL,
          sync_updated_at = ?
      WHERE idRebanho = ?
        AND substr(COALESCE(dataPesagem, ''), 1, 10) = ?
        AND tipo = ?
        AND printf('%.3f', CAST(peso AS REAL)) = ?
        AND COALESCE(sync_op, '') != 'delete'
      ''',
      [now, ...identity],
    );
  }

  if (updated > 0) {
    _syncLog(label,
        'Marcador local de sync limpo por identidade para $updated pesagem(ns).');
  }
}

Future<void> _clearLocalRebanhoSyncDirtyByIds(
  Iterable<String?> ids, {
  required String label,
}) async {
  final validIds = ids
      .whereType<String>()
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  if (validIds.isEmpty) return;

  final db = SQLiteManager.instance.database;
  const chunkSize = 500;
  for (var start = 0; start < validIds.length; start += chunkSize) {
    final end = (start + chunkSize < validIds.length)
        ? start + chunkSize
        : validIds.length;
    final chunk = validIds.sublist(start, end);
    final placeholders = List.filled(chunk.length, '?').join(',');
    final now = DateTime.now()
        .toIso8601String()
        .substring(0, 19)
        .replaceFirst('T', ' ');
    await db.rawUpdate(
      '''
      UPDATE local_rebanho
      SET sync_dirty = 0,
          sync_op = NULL,
          sync_updated_at = ?
      WHERE idRebanho IN ($placeholders)
      ''',
      [now, ...chunk],
    );
  }
  _syncLog(label,
      'Marcador local de sync limpo para ${validIds.length} rebanho(s).');
}

Future<void> _clearLocalLoteSyncDirtyByIds(
  Iterable<String?> ids, {
  required String label,
}) async {
  final validIds = ids
      .whereType<String>()
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  if (validIds.isEmpty) return;

  final db = SQLiteManager.instance.database;
  const chunkSize = 500;
  for (var start = 0; start < validIds.length; start += chunkSize) {
    final end = (start + chunkSize < validIds.length)
        ? start + chunkSize
        : validIds.length;
    final chunk = validIds.sublist(start, end);
    final placeholders = List.filled(chunk.length, '?').join(',');
    final now = DateTime.now()
        .toIso8601String()
        .substring(0, 19)
        .replaceFirst('T', ' ');
    await db.rawUpdate(
      '''
      UPDATE local_lotes
      SET sync_dirty = 0,
          sync_op = NULL,
          sync_updated_at = ?
      WHERE id_lote IN ($placeholders)
      ''',
      [now, ...chunk],
    );
  }
  _syncLog(
      label, 'Marcador local de sync limpo para ${validIds.length} lote(s).');
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

const String _reproLotSnapshotRepairPrefsKey = 'repro_lot_snapshot_repair_v1';

Future<void>? _refreshPesagensInFlight;

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
  static const int _maxEvents = 500;
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
      throw TimeoutException('Timeout em "$label" após ${timeout.inSeconds}s');
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
      _syncLog('latency', '$label ok em ${stopwatch.elapsedMilliseconds}ms');
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
  Error.throwWithStackTrace(lastError ?? StateError('retry falhou em $label'),
      lastStack ?? StackTrace.current);
}

bool _isDuplicateKeyError(Object error) {
  final msg = error.toString().toLowerCase();
  return msg.contains('23505') ||
      msg.contains('duplicate key') ||
      msg.contains('unique constraint');
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
    final result =
        await db.rawQuery('SELECT COUNT(*) as cnt FROM $tableName LIMIT 1');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count <= 5;
  } catch (e) {
    _syncLog('helper', 'Erro ao verificar tabela $tableName: $e');
    return true;
  }
}

Future<int> _countLocalRowsForProperties(
  String tableName,
  String propertyColumn,
  List<String> propertyIds, {
  String? extraWhere,
}) async {
  if (propertyIds.isEmpty) return 0;
  try {
    final db = SQLiteManager.instance.database;
    var total = 0;
    const chunkSize = 500;
    for (var start = 0; start < propertyIds.length; start += chunkSize) {
      final end = (start + chunkSize < propertyIds.length)
          ? start + chunkSize
          : propertyIds.length;
      final chunk = propertyIds.sublist(start, end);
      final placeholders = List.filled(chunk.length, '?').join(',');
      final rows = await db.rawQuery(
        '''
        SELECT COUNT(*) AS cnt
        FROM $tableName
        WHERE $propertyColumn IN ($placeholders)
        ${extraWhere ?? ''}
        ''',
        chunk,
      );
      total += Sqflite.firstIntValue(rows) ?? 0;
    }
    return total;
  } catch (e) {
    _syncLog('helper',
        'Erro ao contar $tableName por propriedades (${propertyIds.length}): $e');
    return 0;
  }
}

bool _localDataLooksIncomplete({
  required int localCount,
  required int remoteTotal,
}) {
  if (remoteTotal <= 0) return false;
  if (localCount <= 5) return true;
  final toleratedGap = remoteTotal < 100 ? 10 : (remoteTotal * 0.05).ceil();
  return remoteTotal > localCount + toleratedGap;
}

Future<DateTime?> _localPesagensMaxCreatedAt() async {
  try {
    final db = SQLiteManager.instance.database;
    final rows = await db.rawQuery('''
      SELECT MAX(created_at) AS max_created_at
      FROM local_historico_pesagens
      WHERE COALESCE(idRebanho, '') != ''
        AND COALESCE(dataPesagem, '') != ''
        AND COALESCE(tipo, '') != ''
    ''');
    final raw =
        rows.isNotEmpty ? rows.first['max_created_at']?.toString() : null;
    if (raw == null || raw.isEmpty || raw == 'null') return null;
    return DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  } catch (e) {
    _syncLog('pesagens',
        'Não foi possível recuperar max(created_at) local de pesagens: $e');
    return null;
  }
}

/// Verifica se o localLastChange indica que nunca houve sync real.
bool _isFirstSync(DateTime? localLastChange) {
  if (localLastChange == null) return true;
  return localLastChange.isBefore(DateTime(2025, 1, 1));
}

bool _isTimeoutLikeError(Object? error) {
  final message = error?.toString().toLowerCase() ?? '';
  return message.contains('timeout') ||
      message.contains('statement timeout') ||
      message.contains('57014') ||
      message.contains('canceling statement due to statement timeout');
}

Future<ApiCallResponse> _buscarPesagensDireto({
  required List<String> propertyIds,
  required int limit,
  required int offset,
  bool includeCount = false,
  String? updatedAfter,
  Duration timeout = const Duration(seconds: 25),
}) {
  final headers = <String, dynamic>{
    ...SupabaseFunctionsGroup.headers,
    // count=planned é estimativa via planner do Postgres — barato.
    // count=exact roda COUNT(*) completo e era gargalo principal do 85%.
    if (includeCount) 'Prefer': 'count=planned',
  };

  return ApiManager.instance
      .makeApiCall(
        callName: 'Buscar Pesagens Direto',
        apiUrl:
            '${SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '')}/historico_pesagens',
        callType: ApiCallType.GET,
        headers: headers,
        params: {
          'select':
              'id,id_pesagem,idRebanho,dataPesagem,tipo,peso,deletado,created_at,updated_at,id_propriedade',
          'id_propriedade': 'in.${_buildSupabaseInFilter(propertyIds)}',
          'idRebanho': 'not.is.null',
          'dataPesagem': 'not.is.null',
          'peso': 'not.is.null',
          'deletado': 'not.eq.SIM',
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
      )
      .timeout(timeout);
}

/// Busca pesagens onde id_propriedade é NULL, filtrando por idRebanho do
/// usuário para evitar trazer registros de outros usuários.
Future<ApiCallResponse> _buscarPesagensSemPropriedade({
  required List<String> rebanhoIds,
  required int limit,
  required int offset,
  String? updatedAfter,
  Duration timeout = const Duration(seconds: 25),
}) {
  return ApiManager.instance
      .makeApiCall(
        callName: 'Buscar Pesagens sem Propriedade',
        apiUrl:
            '${SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '')}/historico_pesagens',
        callType: ApiCallType.GET,
        headers: SupabaseFunctionsGroup.headers,
        params: {
          'select':
              'id,id_pesagem,idRebanho,dataPesagem,tipo,peso,deletado,created_at,updated_at,id_propriedade',
          'id_propriedade': 'is.null',
          'idRebanho': 'in.${_buildSupabaseInFilter(rebanhoIds)}',
          'deletado': 'not.eq.SIM',
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
      )
      .timeout(timeout);
}

Future<ApiCallResponse> _buscarPesagensTipoVazioDireto({
  required List<String> propertyIds,
  required int limit,
  required int offset,
  String? updatedAfter,
  Duration timeout = const Duration(seconds: 25),
}) {
  return ApiManager.instance
      .makeApiCall(
        callName: 'Buscar Pesagens Tipo Vazio',
        apiUrl:
            '${SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '')}/historico_pesagens',
        callType: ApiCallType.GET,
        headers: SupabaseFunctionsGroup.headers,
        params: {
          'select':
              'id,id_pesagem,idRebanho,dataPesagem,tipo,peso,deletado,created_at,updated_at,id_propriedade',
          'id_propriedade': 'in.${_buildSupabaseInFilter(propertyIds)}',
          'idRebanho': 'not.is.null',
          'dataPesagem': 'not.is.null',
          'peso': 'not.is.null',
          'or': '(tipo.is.null,tipo.eq.)',
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
      )
      .timeout(timeout);
}

Future<ApiCallResponse> _buscarPesagensTipoVazioSemPropriedade({
  required List<String> rebanhoIds,
  required int limit,
  required int offset,
  Duration timeout = const Duration(seconds: 25),
}) {
  return ApiManager.instance
      .makeApiCall(
        callName: 'Buscar Pesagens Tipo Vazio sem Propriedade',
        apiUrl:
            '${SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '')}/historico_pesagens',
        callType: ApiCallType.GET,
        headers: SupabaseFunctionsGroup.headers,
        params: {
          'select':
              'id,id_pesagem,idRebanho,dataPesagem,tipo,peso,deletado,created_at,updated_at,id_propriedade',
          'id_propriedade': 'is.null',
          'idRebanho': 'in.${_buildSupabaseInFilter(rebanhoIds)}',
          'dataPesagem': 'not.is.null',
          'peso': 'not.is.null',
          'or': '(tipo.is.null,tipo.eq.)',
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
      )
      .timeout(timeout);
}

Future<ApiCallResponse> _buscarPesagensRebanhoDireto({
  required String idRebanho,
  String? idPropriedade,
  Duration timeout = const Duration(seconds: 12),
}) {
  final propertyId = idPropriedade?.trim();
  return ApiManager.instance
      .makeApiCall(
        callName: 'Buscar Pesagens Rebanho Direto',
        apiUrl:
            '${SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '')}/historico_pesagens',
        callType: ApiCallType.GET,
        headers: SupabaseFunctionsGroup.headers,
        params: {
          'select':
              'id,id_pesagem,idRebanho,dataPesagem,tipo,peso,deletado,created_at,updated_at,id_propriedade',
          'idRebanho': 'eq.$idRebanho',
          if (propertyId != null && propertyId.isNotEmpty)
            'id_propriedade': 'eq.$propertyId',
          'dataPesagem': 'not.is.null',
          'peso': 'not.is.null',
          'deletado': 'not.eq.SIM',
          'order': 'dataPesagem.asc,created_at.asc,id.asc',
          'limit': 100,
        },
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      )
      .timeout(timeout);
}

Future<String?> _resolvePesagemPropertyId({
  required String idRebanho,
  String? idPropriedade,
}) async {
  final explicit = idPropriedade?.trim();
  if (explicit != null && explicit.isNotEmpty) {
    return explicit;
  }

  final selectedRebanhoProperty =
      FFAppState().rebanhoSelecionado.idPropriedade.trim();
  if (selectedRebanhoProperty.isNotEmpty &&
      FFAppState().rebanhoSelecionado.idRebanho == idRebanho) {
    return selectedRebanhoProperty;
  }

  try {
    final localRows = await SQLiteManager.instance.buscarRebanho(
      idRebanho: idRebanho,
    );
    final localProperty = localRows.firstOrNull?.idPropriedade?.trim();
    if (localProperty != null && localProperty.isNotEmpty) {
      return localProperty;
    }
  } catch (e) {
    _syncLog('pesagens',
        'Não foi possível resolver propriedade local para $idRebanho: $e');
  }

  final selectedProperty =
      FFAppState().propriedadeSelecionada.idPropriedade.trim();
  return selectedProperty.isEmpty ? null : selectedProperty;
}

Future<int> repararPesagensRebanhoLocal({
  String? idRebanho,
  String? idPropriedade,
}) async {
  final normalizedIdRebanho = idRebanho?.trim();
  if (normalizedIdRebanho == null || normalizedIdRebanho.isEmpty) {
    return 0;
  }

  try {
    final resolvedPropertyId = await _resolvePesagemPropertyId(
      idRebanho: normalizedIdRebanho,
      idPropriedade: idPropriedade,
    );
    final response = await _buscarPesagensRebanhoDireto(
      idRebanho: normalizedIdRebanho,
      idPropriedade: resolvedPropertyId,
    );
    final records = _safeRecordsFromApi(response.jsonBody);
    if (records.isEmpty) {
      return 0;
    }

    final result = await actions.batchInsertLocalPesagens(records);
    final errors = result['errors'] as List<Map<String, String>>? ?? [];
    if (errors.isNotEmpty) {
      _syncLog('pesagens',
          'Reparo por animal encontrou ${errors.length} erro(s) para $normalizedIdRebanho.');
    }

    await SQLiteManager.instance.syncUltimaPesagemNoRebanho(
      idRebanho: normalizedIdRebanho,
    );

    return result['inserted'] as int? ?? 0;
  } catch (e, s) {
    _syncLog('pesagens',
        'Reparo por animal falhou para $normalizedIdRebanho: $e\n$s');
    return 0;
  }
}

class _PesagensSyncPageResult {
  const _PesagensSyncPageResult({
    required this.inserted,
    required this.errors,
  });

  final int inserted;
  final List<Map<String, String>> errors;
}

Future<List<dynamic>> _buscarPesagensKeyset({
  required List<String> propertyIds,
  required int limit,
  String? updatedAfter,
  String? cursorUpdatedAt,
  int? cursorId,
}) async {
  final params = <String, dynamic>{
    'p_property_ids': propertyIds,
    'p_limit': limit,
    if (updatedAfter != null) 'p_updated_after': updatedAfter,
    if (cursorUpdatedAt != null) 'p_cursor_updated_at': cursorUpdatedAt,
    if (cursorId != null) 'p_cursor_id': cursorId,
  };
  final result = await _withTimeout(
    () => SupaFlow.client.rpc(
      'historico_pesagens_mobile_keyset',
      params: params,
    ),
    label:
        'pesagens.keyset(limit=$limit,cursorUpdatedAt=$cursorUpdatedAt,cursorId=$cursorId)',
    timeout: kSyncPageTimeout,
  );
  return _safeRecordsFromApi(result);
}

String? _pesagemCursorUpdatedAt(dynamic record) {
  if (record is! Map) return null;
  return (record['updated_at'] ?? record['updatedAt'] ?? record['created_at'])
      ?.toString();
}

int? _pesagemCursorId(dynamic record) {
  if (record is! Map) return null;
  final value = record['id'];
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

Future<_PesagensSyncPageResult> _syncPesagensKeysetPages({
  required List<String> propertyIds,
  required String? updatedAfter,
}) async {
  final errors = <Map<String, String>>[];
  var totalInserted = 0;
  var totalFetched = 0;
  var page = 0;
  String? cursorUpdatedAt;
  int? cursorId;
  final limit = await _adaptivePageSize();

  while (true) {
    _throwIfCancelled('refreshPesagens');
    final stopwatch = Stopwatch()..start();
    final records = await _buscarPesagensKeyset(
      propertyIds: propertyIds,
      limit: limit,
      updatedAfter: updatedAfter,
      cursorUpdatedAt: cursorUpdatedAt,
      cursorId: cursorId,
    );
    stopwatch.stop();
    _syncLog('pesagens',
        'Keyset página $page: ${records.length} registro(s) em ${stopwatch.elapsedMilliseconds}ms.');

    if (records.isEmpty) break;

    final insertStopwatch = Stopwatch()..start();
    final result = await actions.batchInsertLocalPesagens(records);
    insertStopwatch.stop();
    final pageErrors = result['errors'] as List<Map<String, String>>? ?? [];
    if (pageErrors.isNotEmpty) errors.addAll(pageErrors);
    final inserted = result['inserted'] as int? ?? 0;
    totalInserted += inserted;
    totalFetched += records.length;
    FFAppState().indexPesagens = totalFetched;
    FFAppState().totalPesagens = totalFetched;
    _syncLog('pesagens',
        'Keyset página $page gravada: $inserted upsert(s) locais em ${insertStopwatch.elapsedMilliseconds}ms.');

    final last = records.last;
    final nextUpdatedAt = _pesagemCursorUpdatedAt(last);
    final nextId = _pesagemCursorId(last);
    if (nextUpdatedAt == null || nextId == null) {
      _syncLog('pesagens',
          'Keyset sem cursor válido na última linha. Encerrando para evitar loop.');
      break;
    }
    cursorUpdatedAt = nextUpdatedAt;
    cursorId = nextId;
    page++;

    if (records.length < limit) break;
  }

  return _PesagensSyncPageResult(inserted: totalInserted, errors: errors);
}

Future<_PesagensSyncPageResult> _syncPesagensTipoVazioRestPages({
  required List<String> propertyIds,
  required String? updatedAfter,
}) async {
  final errors = <Map<String, String>>[];
  var totalInserted = 0;
  var fetchedCount = 0;
  var totalFetched = 0;
  const pageSize = 999;

  while (true) {
    _throwIfCancelled('refreshPesagens.tipoVazio');
    final resp = await _buscarPesagensTipoVazioDireto(
      propertyIds: propertyIds,
      limit: pageSize,
      offset: fetchedCount,
      updatedAfter: updatedAfter,
    );
    final records = _safeRecordsFromApi(resp.jsonBody);
    _syncLog('pesagens',
        'Backfill tipo vazio: offset=$fetchedCount, ${records.length} registro(s).');
    if (records.isEmpty) break;

    final result = await actions.batchInsertLocalPesagens(records);
    totalInserted += result['inserted'] as int? ?? 0;
    totalFetched += records.length;
    final pageErrors = result['errors'] as List<Map<String, String>>? ?? [];
    if (pageErrors.isNotEmpty) errors.addAll(pageErrors);

    fetchedCount += records.length;
    if (records.length < pageSize) break;
  }

  _syncLog('pesagens',
      'Backfill tipo vazio por propriedade finalizado: $totalFetched encontrado(s), $totalInserted upsert(s).');
  return _PesagensSyncPageResult(inserted: totalInserted, errors: errors);
}

Future<_PesagensSyncPageResult> _syncPesagensTipoVazioSemPropriedadePages({
  required List<String> rebanhoIds,
}) async {
  final errors = <Map<String, String>>[];
  var totalInserted = 0;
  var totalFetched = 0;
  const pageSize = 999;
  const batchSize = 50;

  for (var i = 0; i < rebanhoIds.length; i += batchSize) {
    _throwIfCancelled('refreshPesagens.tipoVazioSemPropriedade');
    final batch = rebanhoIds.sublist(
      i,
      i + batchSize > rebanhoIds.length ? rebanhoIds.length : i + batchSize,
    );
    var offset = 0;

    while (true) {
      _throwIfCancelled('refreshPesagens.tipoVazioSemPropriedade');
      final resp = await _buscarPesagensTipoVazioSemPropriedade(
        rebanhoIds: batch,
        limit: pageSize,
        offset: offset,
      );
      final records = _safeRecordsFromApi(resp.jsonBody);
      _syncLog('pesagens',
          'Backfill tipo vazio sem propriedade: batch=${i ~/ batchSize}, offset=$offset, ${records.length} registro(s).');
      if (records.isEmpty) break;

      final result = await actions.batchInsertLocalPesagens(records);
      totalInserted += result['inserted'] as int? ?? 0;
      totalFetched += records.length;
      final pageErrors = result['errors'] as List<Map<String, String>>? ?? [];
      if (pageErrors.isNotEmpty) errors.addAll(pageErrors);

      offset += records.length;
      if (records.length < pageSize) break;
    }
  }

  _syncLog('pesagens',
      'Backfill tipo vazio sem propriedade finalizado: $totalFetched encontrado(s), $totalInserted upsert(s).');
  return _PesagensSyncPageResult(inserted: totalInserted, errors: errors);
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
        final insertErrors =
            result['errors'] as List<Map<String, String>>? ?? [];
        if (insertedCount == 0 && records.isNotEmpty) {
          _syncLog('propriedades',
              'Batch insert falhou completamente (${insertErrors.length} erros). Mantendo dados locais.');
          return;
        }
        // Só deleta se o insert teve sucesso (pelo menos parcial)
        // O UPSERT (ConflictAlgorithm.replace) já garante que dados novos sobrescrevem antigos
        _syncLog('propriedades',
            'Primeiro sync: $insertedCount registros inseridos via UPSERT.');
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
  final dataPendente = FFAppState().dataDadosNaoSyncProp;
  if (dataPendente == null) return true;

  List<BuscaPropriedadesPUTRow> localPut = const [];
  List<BuscaPropriedadesUPDATEDRow> localUpd = const [];

  try {
    _throwIfCancelled('putUpdtPropriedades');
    final dateFilter = dateTimeFormat(
      "yyyy-MM-dd HH:mm:ss",
      dataPendente,
      locale: FFLocalizations.of(context).languageCode,
    );

    localPut =
        await SQLiteManager.instance.buscaPropriedadesPUT(datePUT: dateFilter);
    localUpd = await SQLiteManager.instance
        .buscaPropriedadesUPDATED(dateUPT: dateFilter);

    // Dedupe PUT/UPDT — registros recém-inseridos não precisam de UPDATE separado.
    if (localPut.isNotEmpty) {
      final insertedIds =
          localPut.map((r) => r.idPropriedade).whereType<String>().toSet();
      if (insertedIds.isNotEmpty) {
        final before = localUpd.length;
        localUpd = localUpd
            .where((r) => !insertedIds.contains(r.idPropriedade))
            .toList();
        final removed = before - localUpd.length;
        if (removed > 0) {
          _syncLog('putUpdtPropriedades',
              'Dedupe PUT/UPDT: $removed registro(s) removidos.');
        }
      }
    }

    final payloads = <Map<String, dynamic>>[];
    for (final row in localPut) {
      _throwIfCancelled('putUpdtPropriedades');
      payloads.add(_buildPropriedadePayload(row.data, isInsert: true));
    }
    for (final row in localUpd) {
      _throwIfCancelled('putUpdtPropriedades');
      payloads.add(_buildPropriedadePayload(row.data, isInsert: false));
    }

    if (payloads.isEmpty) {
      _syncLog('putUpdtPropriedades', 'Nada para enviar.');
      return true;
    }

    _syncLog('putUpdtPropriedades',
        'Upsert propriedade: ${payloads.length} registro(s) (INSERT=${localPut.length}, UPDATE=${localUpd.length}).');

    await _retry(
      () => _batchUpsertSupabase(
        tableName: 'propriedades',
        rows: payloads,
        onConflict: 'idPropriedade',
        chunkSize: 200,
        label: 'putUpdtPropriedades',
      ),
      label: 'putUpdtPropriedades.batchUpsert',
      maxAttempts: 3,
    );

    for (final row in localPut) {
      _markSyncOk('propriedade', row.idPropriedade);
      // ignore: discarded_futures
      actions.SyncErrorLog.autoResolverPorRegistro(
          'propriedade', row.idPropriedade);
    }
    for (final row in localUpd) {
      _markSyncOk('propriedade', row.idPropriedade);
      // ignore: discarded_futures
      actions.SyncErrorLog.autoResolverPorRegistro(
          'propriedade', row.idPropriedade);
    }
    _syncLog('putUpdtPropriedades', 'Upload concluído com sucesso.');
  } on SyncCancelledException catch (e) {
    allSuccess = false;
    _syncLog('putUpdtPropriedades', 'CANCELADO: $e');
  } on TimeoutException catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtPropriedades', 'TIMEOUT no upload: $e\n$s');
    _registrarErrosPropriedade(localPut, localUpd, e);
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtPropriedades', 'ERRO no upload: $e\n$s');
    _registrarErrosPropriedade(localPut, localUpd, e);
  }
  return allSuccess;
}

void _registrarErrosPropriedade(
  List<BuscaPropriedadesPUTRow> puts,
  List<BuscaPropriedadesUPDATEDRow> upds,
  Object e,
) {
  for (final r in puts) {
    _recordSyncError(
      flow: 'putUpdtPropriedades',
      modulo: 'propriedade',
      operacao: 'insert',
      erro: e,
      registroId: r.idPropriedade,
      registroDescricao: r.nome,
    );
  }
  for (final r in upds) {
    _recordSyncError(
      flow: 'putUpdtPropriedades',
      modulo: 'propriedade',
      operacao: 'update',
      erro: e,
      registroId: r.idPropriedade,
      registroDescricao: r.nome,
    );
  }
}

Map<String, dynamic> _buildPropriedadePayload(
  Map<String, dynamic> raw, {
  required bool isInsert,
}) {
  final payload = <String, dynamic>{
    'idPropriedade': raw['idPropriedade'],
    'nome': raw['nome'],
    'anotacoes': raw['anotacoes'],
    'areaAgricultura': raw['areaAgricultura'],
    'areaBenfeitoria': raw['areaBenfeitoria'],
    'areaPastagem': raw['areaPastagem'],
    'areaReserva': raw['areaReserva'],
    'areaTotal': raw['areaTotal'],
    'cidade': raw['cidade'],
    'estado': raw['estado'],
    'icone': raw['icone'],
    'usersID': raw['usersID'],
    'atividades': raw['atividades'],
  };
  if (isInsert) {
    payload['userID'] = raw['userID'];
    payload['rebanhosID'] = raw['rebanhosID'];
  }
  payload.removeWhere((_, v) => v == null);
  return payload;
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
  final aplicarFiltros = _hasFiltrosRebanhoCardsAtivos();

  qtdAnimais = await SQLiteManager.instance.qTDAnimaisTotalPropriedade(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    sexo: aplicarFiltros ? FFAppState().filtroSexoRebanho : '',
    categoria: aplicarFiltros ? FFAppState().filtroCategoriasRebanho : '',
    raca: aplicarFiltros ? FFAppState().filtroRaca : '',
    origem: aplicarFiltros ? FFAppState().filtroOrigemRebanho : '',
    loteId: aplicarFiltros ? FFAppState().filtroLoteRebanho : '',
    statusReb: aplicarFiltros ? _statusRebanhoFiltroCards() : '',
    dataNascInicio:
        aplicarFiltros ? _dataNascimentoFiltroCards(inicio: true) : '',
    dataNascFim:
        aplicarFiltros ? _dataNascimentoFiltroCards(inicio: false) : '',
  );
  FFAppState().animaisRegistrados = valueOrDefault<int>(
    qtdAnimais.firstOrNull?.total,
    0,
  );
}

Future animaisPropriedade(BuildContext context) async {
  List<QTDAnimaisPropriedadeRow>? animais;
  final aplicarFiltros = _hasFiltrosRebanhoCardsAtivos();

  animais = await SQLiteManager.instance.qTDAnimaisPropriedade(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    sexo: aplicarFiltros ? FFAppState().filtroSexoRebanho : '',
    categoria: aplicarFiltros ? FFAppState().filtroCategoriasRebanho : '',
    raca: aplicarFiltros ? FFAppState().filtroRaca : '',
    origem: aplicarFiltros ? FFAppState().filtroOrigemRebanho : '',
    loteId: aplicarFiltros ? FFAppState().filtroLoteRebanho : '',
    statusReb: aplicarFiltros ? _statusRebanhoFiltroCards() : '',
    dataNascInicio:
        aplicarFiltros ? _dataNascimentoFiltroCards(inicio: true) : '',
    dataNascFim:
        aplicarFiltros ? _dataNascimentoFiltroCards(inicio: false) : '',
  );
  final qtdAnimaisPropriedade = valueOrDefault<int>(
    animais.firstOrNull?.total,
    0,
  );
  FFAppState().update(() {
    FFAppState().qtdAnimaisPropriedade = qtdAnimaisPropriedade;
  });
}

bool _hasFiltrosRebanhoCardsAtivos() {
  return FFAppState().filtroSexoRebanho != '' ||
      FFAppState().filtroCategoriasRebanho != '' ||
      FFAppState().filtroRaca != '' ||
      FFAppState().filtroOrigemRebanho != '' ||
      FFAppState().filtroLoteRebanho != '' ||
      FFAppState().filtroDataNascimentoInicio != null ||
      FFAppState().filtroDataNascimentoFim != null ||
      _statusRebanhoFiltroCardsEhReal();
}

bool _statusRebanhoFiltroCardsEhReal() {
  const defaultStatus = {'Na propriedade', 'Sêmen'};
  final selected = FFAppState().filtroStatusRebanhoList.isNotEmpty
      ? FFAppState().filtroStatusRebanhoList
      : FFAppState()
          .filtroStatusRebanho
          .split('|')
          .map((status) => status.trim())
          .where((status) => status.isNotEmpty)
          .toList();

  return selected.isNotEmpty &&
      (selected.length != defaultStatus.length ||
          !selected.every(defaultStatus.contains));
}

String _statusRebanhoFiltroCards() {
  if (FFAppState().filtroStatusRebanhoList.isNotEmpty) {
    return FFAppState().filtroStatusRebanhoList.join('|');
  }
  return FFAppState().filtroStatusRebanho;
}

String _dataNascimentoFiltroCards({required bool inicio}) {
  final data = inicio
      ? FFAppState().filtroDataNascimentoInicio
      : FFAppState().filtroDataNascimentoFim;
  if (data == null) return '';
  return dateTimeFormat('yyyy-MM-dd', data);
}

/// Filtra do `chunk` as pesagens que JÁ existem no Supabase, evitando
/// duplicação por retry após sucesso parcial (timeout pós-INSERT).
///
/// Critério de identidade: `(idRebanho, dataPesagem, tipo, peso)` —
/// invariante entre cliente e servidor. Antes usávamos `created_at`, mas
/// como o servidor gera seu próprio `now()` quando o cliente não envia o
/// campo, a comparação NUNCA batia → todos os retries duplicavam.
///
/// Em caso de qualquer falha na pré-checagem (timeout, erro de rede),
/// retorna o chunk inalterado — fail-open: melhor tentar inserir e arriscar
/// uma duplicata isolada do que travar a sync inteira.
Future<List<Map<String, dynamic>>> _filterPesagensJaInseridas(
  List<Map<String, dynamic>> chunk,
) async {
  if (chunk.isEmpty) return chunk;
  try {
    final idRebanhos = <String>{};
    for (final r in chunk) {
      final idR = r['idRebanho']?.toString();
      if (idR != null && idR.isNotEmpty) idRebanhos.add(idR);
    }
    if (idRebanhos.isEmpty) return chunk;

    final query = SupaFlow.client
        .from('historico_pesagens')
        .select('idRebanho,dataPesagem,tipo,peso,deletado')
        .inFilter('idRebanho', idRebanhos.toList());
    final existentes = await _withTimeout(
      () => query,
      label: 'pesagens.preCheck',
      timeout: kSyncPageTimeout,
    );

    final existentesSet = <String>{};
    for (final row in (existentes as List)) {
      final m = row as Map;
      // Pesagens marcadas deletadas NÃO contam como "existentes" — se o
      // cliente está re-enviando, é porque vai re-inserir uma equivalente.
      if ((m['deletado']?.toString() ?? '').toUpperCase() == 'SIM') continue;
      final key = _pesagemPushKey(
        m['idRebanho']?.toString(),
        m['dataPesagem']?.toString(),
        m['tipo']?.toString(),
        m['peso'],
      );
      if (key != null) existentesSet.add(key);
    }
    if (existentesSet.isEmpty) return chunk;

    final filtered = <Map<String, dynamic>>[];
    var skipped = 0;
    for (final r in chunk) {
      final key = _pesagemPushKey(
        r['idRebanho']?.toString(),
        r['dataPesagem']?.toString(),
        r['tipo']?.toString(),
        r['peso'],
      );
      if (key != null && existentesSet.contains(key)) {
        skipped++;
      } else {
        filtered.add(r);
      }
    }
    if (skipped > 0) {
      _syncLog('pesagens.preCheck',
          '$skipped pesagem(ns) já existem no servidor — puladas para evitar duplicata.');
    }
    return filtered;
  } catch (e) {
    _syncLog('pesagens.preCheck',
        'Pré-checagem falhou ($e). Seguindo com insert normal (fail-open).');
    return chunk;
  }
}

/// Chave de identidade lógica de uma pesagem, estável entre cliente e
/// servidor: `(idRebanho|dataPesagem(YYYY-MM-DD)|tipo|peso)`.
/// Peso é normalizado para 3 casas decimais para tolerar diferenças de
/// representação numérica entre Postgres e Dart.
String? _pesagemPushKey(
    String? idRebanho, String? dataPesagem, String? tipo, dynamic peso) {
  if (idRebanho == null || idRebanho.isEmpty) return null;
  String normDate(String? s) {
    if (s == null || s.isEmpty) return '';
    return s.length >= 10 ? s.substring(0, 10) : s;
  }

  String normPeso(dynamic v) {
    if (v == null) return '';
    if (v is num) return v.toStringAsFixed(3);
    final s = v.toString().replaceAll(',', '.').trim();
    final n = double.tryParse(s);
    return n == null ? s : n.toStringAsFixed(3);
  }

  return '$idRebanho|${normDate(dataPesagem)}|${tipo ?? ''}|${normPeso(peso)}';
}

List<Map<String, dynamic>> _dedupPesagemPayloads(
    List<Map<String, dynamic>> payloads) {
  final byKey = <String, Map<String, dynamic>>{};
  var index = 0;
  for (final payload in payloads) {
    final idPesagem = payload['id_pesagem']?.toString();
    final logicalKey = _pesagemPushKey(
      payload['idRebanho']?.toString(),
      payload['dataPesagem']?.toString(),
      payload['tipo']?.toString(),
      payload['peso'],
    );
    final key = logicalKey ??
        ((idPesagem != null && idPesagem.isNotEmpty)
            ? 'id:$idPesagem'
            : 'row:${index++}');
    byKey[key] = payload;
  }
  return byKey.values.toList();
}

bool _isPesagemIdSchemaError(Object error) {
  final message = error.toString().toLowerCase();
  return message.contains('id_pesagem') ||
      message.contains('42p10') ||
      message.contains('unique or exclusion constraint');
}

List<Map<String, dynamic>> _withoutPesagemId(
        List<Map<String, dynamic>> payloads) =>
    payloads
        .map((p) => Map<String, dynamic>.from(p)..remove('id_pesagem'))
        .toList();

Future<bool> putUpdtRebanhos(BuildContext context) async {
  var allSuccess = true;
  final dataPendente = FFAppState().dataDadosNaoSyncRebanho;
  final hasDirtyRebanho =
      await SQLiteManager.instance.hasRebanhoDirtyLocalForUser(
    userID: currentUserUid,
  );
  if (dataPendente == null && !hasDirtyRebanho) return true;
  final totalStopwatch = Stopwatch()..start();

  List<BuscarRebanhoPUTRow> localPut = const [];
  List<BuscarRebanhoUPDATEDRow> localUpd = const [];
  List<BuscaHistPesagensPUTRow> pesPut = const [];
  List<BuscaHistPesagensUPDTRow> pesUpd = const [];

  try {
    _throwIfCancelled('putUpdtRebanhos');
    final dateFilter = dateTimeFormat(
      "yyyy-MM-dd HH:mm:ss",
      dataPendente ?? DateTime(9999, 1, 1),
      locale: FFLocalizations.of(context).languageCode,
    );
    _syncLog('putUpdtRebanhos',
        '15% início. marker=$dateFilter, dirty_rebanho=$hasDirtyRebanho, user=$currentUserUid, online=${FFAppState().isOnline}');

    // ───── REBANHO: INSERT e UPDATE separados ─────
    final rebanhoQueryStopwatch = Stopwatch()..start();
    _syncLog('putUpdtRebanhos', 'Consultando SQLite rebanho PUT...');
    final rebanhoPutStopwatch = Stopwatch()..start();
    final rawLocalPut = await SQLiteManager.instance.buscarRebanhoPUT(
      data: dateFilter,
      userID: currentUserUid,
    );
    rebanhoPutStopwatch.stop();
    _syncLog('putUpdtRebanhos',
        'SQLite rebanho PUT retornou ${rawLocalPut.length} em ${rebanhoPutStopwatch.elapsedMilliseconds}ms.');
    _syncLog('putUpdtRebanhos', 'Consultando SQLite rebanho UPDATED...');
    final rebanhoUpdStopwatch = Stopwatch()..start();
    localUpd = await SQLiteManager.instance.buscarRebanhoUPDATED(
      data: dateFilter,
      userID: currentUserUid,
    );
    rebanhoUpdStopwatch.stop();
    _syncLog('putUpdtRebanhos',
        'SQLite rebanho UPDATED retornou ${localUpd.length} em ${rebanhoUpdStopwatch.elapsedMilliseconds}ms.');
    rebanhoQueryStopwatch.stop();
    _syncLog('putUpdtRebanhos',
        'Consulta local rebanho: PUT=${rawLocalPut.length}, UPDT=${localUpd.length} em ${rebanhoQueryStopwatch.elapsedMilliseconds}ms.');
    SyncTelemetry.log(
      flow: 'putUpdtRebanhos',
      message:
          'SQLite rebanho PUT=${rawLocalPut.length}, UPDT=${localUpd.length}',
      elapsedMs: rebanhoQueryStopwatch.elapsedMilliseconds,
    );

    final ignoredDeletedPut =
        rawLocalPut.where((r) => r.deletado == 'SIM').toList();
    localPut = rawLocalPut.where((r) => r.deletado != 'SIM').toList();
    if (ignoredDeletedPut.isNotEmpty) {
      _syncLog('putUpdtRebanhos',
          'PUT ignorou ${ignoredDeletedPut.length} rebanho(s) deletado(s); deleções seguem por UPDATE.');
    }
    _syncLog('putUpdtRebanhos',
        'Após filtro: PUT ativo=${localPut.length}, UPDT candidato=${localUpd.length}.');

    // Se o mesmo registro está em PUT ativo e UPDATE, o PUT carrega o payload
    // completo e idempotente. Deixa no UPDATE apenas edições/deleções reais.
    final putIds = localPut.map((r) => r.idRebanho).whereType<String>().toSet();
    if (putIds.isNotEmpty) {
      final before = localUpd.length;
      localUpd = localUpd.where((r) => !putIds.contains(r.idRebanho)).toList();
      final removed = before - localUpd.length;
      if (removed > 0) {
        _syncLog('putUpdtRebanhos',
            'Dedupe PUT/UPDT: $removed update(s) removidos porque já estavam no PUT ativo.');
      }
    }

    // INSERT/UPSERT somente para novos ativos.
    final rebanhoInserts = <Map<String, dynamic>>[];
    for (final row in localPut) {
      _throwIfCancelled('putUpdtRebanhos.insert');
      rebanhoInserts.add(_buildRebanhoPayload(row.data, isInsert: true));
    }
    _syncLog('putUpdtRebanhos',
        'Payloads INSERT rebanho montados: ${rebanhoInserts.length}.');
    if (rebanhoInserts.length > 1) {
      final seen = <String, int>{};
      final dedupOrder = <Map<String, dynamic>>[];
      for (final p in rebanhoInserts) {
        final id = p['idRebanho']?.toString();
        if (id == null || id.isEmpty) {
          dedupOrder.add(p);
          continue;
        }
        if (seen.containsKey(id)) {
          dedupOrder[seen[id]!] = p;
        } else {
          seen[id] = dedupOrder.length;
          dedupOrder.add(p);
        }
      }
      final removed = rebanhoInserts.length - dedupOrder.length;
      if (removed > 0) {
        _syncLog('putUpdtRebanhos',
            'Dedup interno INSERT: $removed duplicata(s) por idRebanho removidas.');
      }
      rebanhoInserts
        ..clear()
        ..addAll(dedupOrder);
    }
    if (rebanhoInserts.isNotEmpty) {
      _syncLog('putUpdtRebanhos',
          'INSERT/UPSERT rebanho: ${rebanhoInserts.length} novo(s) ativo(s).');
      final localPutById = <String, BuscarRebanhoPUTRow>{
        for (final row in localPut)
          if ((row.idRebanho ?? '').trim().isNotEmpty)
            row.idRebanho!.trim(): row,
      };
      final syncedInsertIds = <String>{};

      void markPayloadOk(Map<String, dynamic> payload) {
        final id = payload['idRebanho']?.toString().trim();
        if (id == null || id.isEmpty) return;
        syncedInsertIds.add(id);
        _markSyncOk('rebanho', id);
      }

      void recordPayloadError(
        Object erro,
        Map<String, dynamic> payload,
      ) {
        final id = payload['idRebanho']?.toString().trim();
        final row = id == null ? null : localPutById[id];
        _recordSyncError(
          flow: 'putUpdtRebanhos',
          modulo: 'rebanho',
          operacao: 'insert',
          erro: erro,
          registroId: id,
          registroDescricao: _descreverRebanhoBy(row?.numeroAnimal),
          payload: payload,
        );
      }

      final insertStopwatch = Stopwatch()..start();
      Set<String> existingRemoteIds = <String>{};
      try {
        existingRemoteIds = await _buscarRebanhoIdsRemotos(
          rebanhoInserts.map((row) => row['idRebanho']?.toString()),
          label: 'putUpdtRebanhos.rebanho.precheck',
        );
      } catch (e) {
        if (e is SyncCancelledException) rethrow;
        _syncLog('putUpdtRebanhos',
            'Pré-checagem remota de rebanho falhou ($e). Seguindo com upsert idempotente.');
      }

      final payloadsToInsert = <Map<String, dynamic>>[];
      final payloadsToUpdate = <Map<String, dynamic>>[];
      for (final payload in rebanhoInserts) {
        final id = payload['idRebanho']?.toString().trim();
        if (id != null && id.isNotEmpty && existingRemoteIds.contains(id)) {
          payloadsToUpdate.add(payload);
        } else {
          payloadsToInsert.add(payload);
        }
      }

      if (payloadsToUpdate.isNotEmpty) {
        _syncLog('putUpdtRebanhos',
            '${payloadsToUpdate.length} rebanho(s) marcados como INSERT já existem no Supabase; recuperando como UPDATE.');
      }
      for (final payload in payloadsToUpdate) {
        _throwIfCancelled('putUpdtRebanhos.insert.recoveryUpdate');
        try {
          final matched = await _retry(
            () => _updateRebanhoSupabaseById(
              payload,
              label: 'putUpdtRebanhos.rebanho.insertRecovery.update',
            ),
            label:
                'putUpdtRebanhos.rebanho.insertRecovery.update.${payload['idRebanho']}',
            maxAttempts: 3,
          );
          if (matched) {
            markPayloadOk(payload);
          } else {
            _syncLog('putUpdtRebanhos',
                'Pré-checagem encontrou idRebanho=${payload['idRebanho']}, mas UPDATE não retornou linha; reenviando como INSERT.');
            payloadsToInsert.add(payload);
          }
        } catch (e) {
          if (e is SyncCancelledException) rethrow;
          allSuccess = false;
          recordPayloadError(e, payload);
        }
      }

      if (payloadsToInsert.isNotEmpty) {
        try {
          await _retry(
            () => _batchUpsertSupabase(
              tableName: 'rebanho',
              rows: payloadsToInsert,
              onConflict: 'idRebanho',
              chunkSize: 200,
              label: 'putUpdtRebanhos.rebanho.insert',
            ),
            label: 'putUpdtRebanhos.rebanho.insert.batchUpsert',
            maxAttempts: 3,
          );
          for (final payload in payloadsToInsert) {
            markPayloadOk(payload);
          }
        } catch (batchError) {
          if (batchError is SyncCancelledException) rethrow;
          _syncLog('putUpdtRebanhos',
              'Batch INSERT/UPSERT rebanho falhou ($batchError). Tentando recuperação registro a registro.');
          for (final payload in payloadsToInsert) {
            _throwIfCancelled('putUpdtRebanhos.insert.single');
            try {
              await _retry(
                () => _batchUpsertSupabase(
                  tableName: 'rebanho',
                  rows: [payload],
                  onConflict: 'idRebanho',
                  chunkSize: 1,
                  label: 'putUpdtRebanhos.rebanho.insert.single',
                ),
                label:
                    'putUpdtRebanhos.rebanho.insert.single.${payload['idRebanho']}',
                maxAttempts: 3,
              );
              markPayloadOk(payload);
            } catch (singleError) {
              if (singleError is SyncCancelledException) rethrow;
              if (!_isDuplicateKeyError(singleError)) {
                allSuccess = false;
                recordPayloadError(singleError, payload);
                continue;
              }

              try {
                _syncLog('putUpdtRebanhos',
                    'INSERT rebanho idRebanho=${payload['idRebanho']} retornou duplicidade; recuperando com UPDATE explícito.');
                final matched = await _retry(
                  () => _updateRebanhoSupabaseById(
                    payload,
                    label: 'putUpdtRebanhos.rebanho.duplicateRecovery.update',
                  ),
                  label:
                      'putUpdtRebanhos.rebanho.duplicateRecovery.update.${payload['idRebanho']}',
                  maxAttempts: 3,
                );
                if (matched) {
                  markPayloadOk(payload);
                } else {
                  allSuccess = false;
                  recordPayloadError(singleError, payload);
                }
              } catch (recoveryError) {
                if (recoveryError is SyncCancelledException) rethrow;
                allSuccess = false;
                recordPayloadError(recoveryError, payload);
              }
            }
          }
        }
      }

      insertStopwatch.stop();
      _syncLog('putUpdtRebanhos',
          'INSERT/UPSERT rebanho concluído em ${insertStopwatch.elapsedMilliseconds}ms. sincronizados=${syncedInsertIds.length}/${rebanhoInserts.length}.');
      if (syncedInsertIds.isNotEmpty) {
        await _clearLocalRebanhoSyncDirtyByIds(
          syncedInsertIds,
          label: 'putUpdtRebanhos.rebanho.insert',
        );
      }
    } else {
      _syncLog('putUpdtRebanhos', 'Sem INSERT/UPSERT de rebanho pendente.');
    }

    // UPDATE explícito para edições/deleções. Não usa upsert para evitar que
    // edição de animal existente tente INSERT silencioso.
    if (localUpd.length > 1) {
      final byId = <String, BuscarRebanhoUPDATEDRow>{};
      final noId = <BuscarRebanhoUPDATEDRow>[];
      for (final row in localUpd) {
        final id = row.idRebanho;
        if (id == null || id.isEmpty) {
          noId.add(row);
        } else {
          byId[id] = row; // mantém a última ocorrência
        }
      }
      final removed = localUpd.length - byId.length - noId.length;
      if (removed > 0) {
        _syncLog('putUpdtRebanhos',
            'Dedup interno UPDATE: $removed duplicata(s) por idRebanho removidas.');
      }
      localUpd = [...noId, ...byId.values];
    }

    if (localUpd.isNotEmpty) {
      _syncLog('putUpdtRebanhos',
          'UPDATE explícito rebanho: ${localUpd.length} registro(s).');
      final updateStopwatch = Stopwatch()..start();
      final updatedIds = <String>[];
      for (final row in localUpd) {
        _throwIfCancelled('putUpdtRebanhos.update');
        final payload = _buildRebanhoPayload(row.data, isInsert: false);
        final isDelete = payload['deletado'] == 'SIM';
        try {
          final matched = await _retry(
            () => _updateRebanhoSupabaseById(
              payload,
              label: 'putUpdtRebanhos.rebanho.update',
            ),
            label: 'putUpdtRebanhos.rebanho.update.${row.idRebanho}',
            maxAttempts: 3,
          );

          if (!matched && !isDelete) {
            final insertPayload =
                _buildRebanhoPayload(row.data, isInsert: true);
            _syncLog('putUpdtRebanhos',
                'UPDATE rebanho não encontrou idRebanho=${row.idRebanho}; recuperando com UPSERT INSERT idempotente.');
            await _retry(
              () => _batchUpsertSupabase(
                tableName: 'rebanho',
                rows: [insertPayload],
                onConflict: 'idRebanho',
                chunkSize: 1,
                label: 'putUpdtRebanhos.rebanho.recovery.insert',
              ),
              label: 'putUpdtRebanhos.rebanho.recovery.insert.${row.idRebanho}',
              maxAttempts: 3,
            );
            if (row.idRebanho != null && row.idRebanho!.isNotEmpty) {
              updatedIds.add(row.idRebanho!);
            }
            _markSyncOk('rebanho', row.idRebanho);
            continue;
          }

          if (!matched && isDelete) {
            _syncLog('putUpdtRebanhos',
                'DELETE remoto no-op: idRebanho=${row.idRebanho} não existe mais no Supabase.');
          }
          if (row.idRebanho != null && row.idRebanho!.isNotEmpty) {
            updatedIds.add(row.idRebanho!);
          }
          _markSyncOk('rebanho', row.idRebanho);
          // ignore: discarded_futures
          actions.SyncErrorLog.autoResolverPorRegistro(
              'rebanho', row.idRebanho);
        } catch (e) {
          allSuccess = false;
          _recordSyncError(
            flow: 'putUpdtRebanhos',
            modulo: 'rebanho',
            operacao: 'update',
            erro: e,
            registroId: row.idRebanho,
            registroDescricao: _descreverRebanhoBy(row.numeroAnimal),
          );
        }
      }
      updateStopwatch.stop();
      _syncLog('putUpdtRebanhos',
          'UPDATE explícito rebanho concluído em ${updateStopwatch.elapsedMilliseconds}ms.');
      await _clearLocalRebanhoSyncDirtyByIds(
        updatedIds,
        label: 'putUpdtRebanhos.rebanho.update',
      );
    } else {
      _syncLog('putUpdtRebanhos', 'Sem UPDATE de rebanho pendente.');
    }

    // ───── HISTORICO_PESAGENS ─────
    final pesagemQueryStopwatch = Stopwatch()..start();
    _syncLog('putUpdt_pesagens', 'Consultando SQLite pesagens PUT...');
    final pesPutStopwatch = Stopwatch()..start();
    pesPut =
        await SQLiteManager.instance.buscaHistPesagensPUT(data: dateFilter);
    pesPutStopwatch.stop();
    _syncLog('putUpdt_pesagens',
        'SQLite pesagens PUT retornou ${pesPut.length} em ${pesPutStopwatch.elapsedMilliseconds}ms.');
    _syncLog('putUpdt_pesagens', 'Consultando SQLite pesagens DELETE...');
    final pesUpdStopwatch = Stopwatch()..start();
    pesUpd = await SQLiteManager.instance.buscaHistPesagensUPDT(
      data: dateFilter,
    );
    pesUpdStopwatch.stop();
    _syncLog('putUpdt_pesagens',
        'SQLite pesagens DELETE retornou ${pesUpd.length} em ${pesUpdStopwatch.elapsedMilliseconds}ms.');
    pesagemQueryStopwatch.stop();
    _syncLog('putUpdt_pesagens',
        'Consulta local pesagens: PUT=${pesPut.length}, DELETE=${pesUpd.length} em ${pesagemQueryStopwatch.elapsedMilliseconds}ms.');
    SyncTelemetry.log(
      flow: 'putUpdt_pesagens',
      message: 'SQLite pesagens PUT=${pesPut.length}, DELETE=${pesUpd.length}',
      elapsedMs: pesagemQueryStopwatch.elapsedMilliseconds,
    );

    // INSERT/retry idempotente: id_pesagem é estável no SQLite e no Supabase.
    final pesInserts = <Map<String, dynamic>>[];
    for (final row in pesPut) {
      _throwIfCancelled('putUpdt_pesagens');
      pesInserts.add(_buildPesagemPayloadInsert(row.data));
    }
    final pesInsertsDeduped = _dedupPesagemPayloads(pesInserts);
    _syncLog('putUpdt_pesagens',
        'Payloads pesagens PUT montados=${pesInserts.length}, após dedup=${pesInsertsDeduped.length}.');
    if (pesInsertsDeduped.length != pesInserts.length) {
      final removed = pesInserts.length - pesInsertsDeduped.length;
      if (removed > 0) {
        _syncLog('putUpdt_pesagens',
            'Dedup interno do batch: $removed pesagem(ns) duplicadas removidas.');
      }
    }
    if (pesInsertsDeduped.isNotEmpty) {
      _syncLog('putUpdt_pesagens',
          'Upsert em lote por id_pesagem: ${pesInsertsDeduped.length} pesagem(ns).');
      try {
        final upsertStopwatch = Stopwatch()..start();
        await _retry(
          () => _batchUpsertSupabase(
            tableName: 'historico_pesagens',
            rows: pesInsertsDeduped,
            onConflict: 'id_pesagem',
            chunkSize: 200,
            label: 'putUpdt_pesagens.upsert',
          ),
          label: 'putUpdt_pesagens.batchUpsert',
          maxAttempts: 3,
        );
        upsertStopwatch.stop();
        _syncLog('putUpdt_pesagens',
            'Upsert pesagens concluído em ${upsertStopwatch.elapsedMilliseconds}ms.');
        for (final row in pesPut) {
          _markSyncOk('pesagem', row.idPesagem ?? row.idRebanho);
        }
        await _clearLocalPesagemSyncDirtyByIds(
          pesInsertsDeduped.map((row) => row['id_pesagem']?.toString()),
          label: 'putUpdt_pesagens.upsert',
        );
        await _clearLocalPesagemSyncDirtyByPayloads(
          pesInsertsDeduped,
          label: 'putUpdt_pesagens.upsert',
        );
      } catch (e) {
        if (_isPesagemIdSchemaError(e)) {
          try {
            _syncLog('putUpdt_pesagens',
                'id_pesagem ainda não disponível no Supabase. Usando fallback legado com pré-checagem.');
            final legacyRows = await _filterPesagensJaInseridas(
                _withoutPesagemId(pesInsertsDeduped));
            if (legacyRows.isNotEmpty) {
              await _retry(
                () => _batchInsertSupabase(
                  tableName: 'historico_pesagens',
                  rows: legacyRows,
                  chunkSize: 200,
                  label: 'putUpdt_pesagens.insertLegacy',
                ),
                label: 'putUpdt_pesagens.batchInsertLegacy',
                maxAttempts: 3,
              );
            }
            for (final row in pesPut) {
              _markSyncOk('pesagem', row.idPesagem ?? row.idRebanho);
            }
            await _clearLocalPesagemSyncDirtyByIds(
              pesInsertsDeduped.map((row) => row['id_pesagem']?.toString()),
              label: 'putUpdt_pesagens.insertLegacy',
            );
            await _clearLocalPesagemSyncDirtyByPayloads(
              pesInsertsDeduped,
              label: 'putUpdt_pesagens.insertLegacy',
            );
          } catch (legacyError) {
            allSuccess = false;
            for (final r in pesPut) {
              _recordSyncError(
                flow: 'putUpdtRebanhos',
                modulo: 'pesagem',
                operacao: 'upsert_fallback_legacy',
                erro: legacyError,
                registroId: r.idPesagem ?? r.idRebanho,
                registroDescricao: 'Pesagem ${r.peso ?? "?"}kg',
              );
            }
          }
        } else {
          allSuccess = false;
          for (final r in pesPut) {
            _recordSyncError(
              flow: 'putUpdtRebanhos',
              modulo: 'pesagem',
              operacao: 'upsert',
              erro: e,
              registroId: r.idPesagem ?? r.idRebanho,
              registroDescricao: 'Pesagem ${r.peso ?? "?"}kg',
            );
          }
        }
      }
    } else {
      _syncLog('putUpdt_pesagens', 'Sem upsert de pesagens pendente.');
    }

    // DELETE remoto: nunca use UPSERT por `id` local. O `id` do SQLite não é o
    // id remoto; fazer upsert por ele cria linhas vazias no Supabase.
    final pesDeleteIds = <String>[];
    var skippedLegacyDeletes = 0;
    for (final row in pesUpd) {
      _throwIfCancelled('putUpdt_pesagens');
      final idPesagem = row.idPesagem;
      if (idPesagem != null && idPesagem.isNotEmpty) {
        pesDeleteIds.add(idPesagem);
      } else {
        skippedLegacyDeletes++;
      }
    }
    final pesDeleteIdsDeduped = pesDeleteIds.toSet().toList();
    if (skippedLegacyDeletes > 0) {
      _syncLog('putUpdt_pesagens',
          '$skippedLegacyDeletes delete(s) sem id_pesagem ignorado(s) para evitar INSERT vazio no Supabase.');
    }
    if (pesDeleteIdsDeduped.isNotEmpty) {
      _syncLog('putUpdt_pesagens',
          'UPDATE deletado=SIM por id_pesagem: ${pesDeleteIdsDeduped.length} pesagem(ns).');
      try {
        final deleteStopwatch = Stopwatch()..start();
        await _retry(
          () => _batchUpdatePesagemDeletesByIdPesagem(
            ids: pesDeleteIdsDeduped,
            chunkSize: 200,
            label: 'putUpdt_pesagens.delete',
          ),
          label: 'putUpdt_pesagens.batchUpdateDelete',
          maxAttempts: 3,
        );
        deleteStopwatch.stop();
        _syncLog('putUpdt_pesagens',
            'Deletes de pesagens concluídos em ${deleteStopwatch.elapsedMilliseconds}ms.');
        for (final row in pesUpd) {
          _markSyncOk('pesagem', row.idPesagem ?? row.id?.toString());
        }
        await _clearLocalPesagemSyncDirtyByIds(
          pesDeleteIdsDeduped,
          label: 'putUpdt_pesagens.delete',
        );
      } catch (e) {
        allSuccess = false;
        for (final r in pesUpd) {
          _recordSyncError(
            flow: 'putUpdtRebanhos',
            modulo: 'pesagem',
            operacao: 'update',
            erro: e,
            registroId: r.idPesagem ?? r.id?.toString(),
            registroDescricao: 'Pesagem id=${r.idPesagem ?? r.id ?? "?"}',
          );
        }
      }
    } else {
      _syncLog('putUpdt_pesagens', 'Sem delete de pesagens pendente.');
    }
    _syncLog('putUpdtRebanhos',
        '15% concluído em ${totalStopwatch.elapsedMilliseconds}ms. sucesso=$allSuccess');
    if (allSuccess) {
      // ignore: discarded_futures
      actions.SyncErrorLog.autoResolverModulo('rebanho');
    }
  } on SyncCancelledException catch (e) {
    allSuccess = false;
    _syncLog('putUpdtRebanhos', 'CANCELADO: $e');
  } on TimeoutException catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtRebanhos', 'TIMEOUT no upload: $e\n$s');
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtRebanhos', 'ERRO no upload de rebanhos: $e\n$s');
  }
  return allSuccess;
}

Map<String, dynamic> _buildRebanhoPayload(
  Map<String, dynamic> raw, {
  required bool isInsert,
}) {
  String? normalizeNullableText(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null' || s.toLowerCase() == 'n/a') {
      return null;
    }
    return s;
  }

  String? serializeDate(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s == 'null') return null;
    final dt = functions.converterParaData(s);
    if (dt == null) return null;
    return supaSerialize<DateTime>(dt);
  }

  final createdAt = serializeDate(raw['created_at']);
  final updatedAt = serializeDate(raw['updated_at']) ??
      createdAt ??
      supaSerialize<DateTime>(getCurrentTimestamp);
  final payload = <String, dynamic>{
    'idRebanho': raw['idRebanho'],
    'idPropriedade': raw['idPropriedade'],
    'numeroAnimal': raw['numeroAnimal'],
    'chip': raw['chip'],
    'codRegistro': raw['codRegistro'],
    'nome': raw['nome'],
    'sexo': raw['sexo'],
    'categoria': raw['categoria'],
    'dataNascimento': serializeDate(raw['dataNascimento']),
    'pesoNascimento': raw['pesoNascimento'],
    'porte': raw['porte'],
    'raca': raw['raca'],
    'loteID': normalizeNullableText(raw['loteID']),
    'dataEntradaLote': serializeDate(raw['dataEntradaLote']),
    'rebanhoIdMatriz': raw['rebanhoIdMatriz'],
    'rebanhoIdReprodutor': raw['rebanhoIdReprodutor'],
    'dataDesmama': serializeDate(raw['dataDesmama']),
    'pesoDesmama': raw['pesoDesmama'],
    'pesoAtual': raw['pesoAtual'],
    'status': raw['statusRebanho'],
    'origem': raw['origem'],
    'anotacoes': raw['anotacoes'],
    'deletado': raw['deletado'],
    'loteNome': normalizeNullableText(raw['loteNome']),
    'tipo': raw['tipo'],
    'dataAcao': serializeDate(raw['dataAcao']),
    'valorCompra': raw['valorCompra'],
    'dataUltimaPesagem': serializeDate(raw['dataUltimaPesagem']),
    'nomeConcat': raw['nomeConcat'],
    'dataVenda': serializeDate(raw['dataVenda']),
    'valorVenda': raw['valorVenda'],
    'numeroMatriz': raw['numeroMatriz'],
    'nomeMatriz': raw['nomeMatriz'],
    'dataNascMatriz': serializeDate(raw['dataNascMatriz']),
    'racaMatriz': raw['racaMatriz'],
    'numeroReprodutor': raw['numeroReprodutor'],
    'nomeReprodutor': raw['nomeReprodutor'],
    'dataNascReprodutor': serializeDate(raw['dataNascReprodutor']),
    'racaReprodutor': raw['racaReprodutor'],
    'movimentacao_entrada': serializeDate(raw['movimentacao_entrada']),
    'movimentacao_saida': serializeDate(raw['movimentacao_saida']),
    'data_morte': serializeDate(raw['data_morte']),
    'motivo_morte': normalizeNullableText(raw['motivo_morte']),
    'updated_at': updatedAt,
  };
  if (isInsert) {
    payload['created_at'] = createdAt ?? updatedAt;
    // Campo que só faz sentido no INSERT (presente em PUTRow apenas).
    payload['categoria_matriz'] = raw['categoria_matriz'];
  }
  const keepNullOnUpdate = {
    'loteID',
    'loteNome',
    'dataEntradaLote',
  };
  payload.removeWhere(
    (key, v) => v == null && (isInsert || !keepNullOnUpdate.contains(key)),
  );
  return payload;
}

Map<String, dynamic> _buildPesagemPayloadInsert(Map<String, dynamic> raw) {
  String? serializeDate(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s == 'null') return null;
    final dt = functions.converterParaData(s);
    if (dt == null) return null;
    return supaSerialize<DateTime>(dt);
  }

  final payload = <String, dynamic>{
    'id_pesagem': raw['id_pesagem'],
    'idRebanho': raw['idRebanho'],
    'dataPesagem': serializeDate(raw['dataPesagem']),
    'tipo': raw['tipo'],
    'peso': raw['peso'],
    'deletado': raw['deletado'],
    'id_propriedade': raw['id_propriedade'],
    // CRÍTICO: enviar created_at do cliente para que o servidor não gere um
    // now() próprio. Sem isso, qualquer pré-checagem por created_at falha.
    'created_at': serializeDate(raw['created_at']),
  };
  payload.removeWhere((_, v) => v == null);
  return payload;
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
    const includeDeletedPrefsKey = 'sync_lotes_include_deleted_v1';
    final prefs = await SharedPreferences.getInstance();
    final includeDeletedSynced = prefs.getBool(includeDeletedPrefsKey) ?? false;

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
        remoteLastChange.isAfter(localLastChange) ||
        !includeDeletedSynced;
    _syncLog('lotes',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange  includeDeletedSynced=$includeDeletedSynced');
    if (shouldSync) {
      propriedades =
          await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
        pUserId: currentUserUid,
      );

      final lotesJsonBody = propriedades.jsonBody;
      final lotesRawList = lotesJsonBody is List ? lotesJsonBody : <dynamic>[];
      lotes = await LotesTable().queryRows(
        queryFn: (q) => q.inFilterOrNull(
          'id_propriedade',
          (lotesRawList
                  .map<PropriedadesStruct?>(PropriedadesStruct.maybeFromMap)
                  .toList() as Iterable<PropriedadesStruct?>)
              .withoutNulls
              .map((e) => e.idPropriedade)
              .toList(),
        ),
      );

      // Converter para lista de maps para batch insert
      final records = <Map<String, dynamic>>[];
      for (final lote in lotes) {
        records.add({
          'id_propriedade': lote.idPropriedade,
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
      final lotesErrors =
          loteResult['errors'] as List<Map<String, String>>? ?? [];
      if (lotesInserted == 0 && records.isNotEmpty) {
        _syncLog('lotes',
            'Batch insert falhou completamente (${lotesErrors.length} erros). Mantendo dados locais.');
      } else {
        _syncLog('lotes', '$lotesInserted lotes inseridos via UPSERT.');
        if (lotesInserted == records.length && lotesErrors.isEmpty) {
          await prefs.setBool(includeDeletedPrefsKey, true);
        }
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
  final dataPendente = FFAppState().dataDadosNaoSyncLotes;
  final hasDirtyLotes = await SQLiteManager.instance.hasLoteDirtyLocalForUser(
    userID: currentUserUid,
  );
  final hasRecentLocalLotes =
      await SQLiteManager.instance.hasLoteChangedAfterForUser(
    userID: currentUserUid,
    changedAfter: FFAppState().lotesChangeDateTime,
  );
  if (dataPendente == null && !hasDirtyLotes) {
    // Se não há lote pendente, erros antigos desse módulo são obsoletos.
    // ignore: discarded_futures
    actions.SyncErrorLog.autoResolverModulo('lote');
    return true;
  }

  List<BuscarLotePUTRow> localPut = const [];
  List<BuscarLoteUPDTRow> localUpd = const [];
  final syncedIds = <String>{};

  try {
    _throwIfCancelled('putUpdtLotes');
    final dateFilter = dateTimeFormat(
      "yyyy-MM-dd HH:mm:ss",
      dataPendente ?? DateTime(9999, 1, 1),
      locale: FFLocalizations.of(context).languageCode,
    );
    _syncLog('putUpdtLotes',
        '20% início. marker=$dateFilter, dirty_lotes=$hasDirtyLotes, recent_lotes=$hasRecentLocalLotes, user=$currentUserUid, online=${FFAppState().isOnline}');

    localPut = await SQLiteManager.instance.buscarLotePUT(
      datePUT: dateFilter,
      userID: currentUserUid,
    );
    localUpd = await SQLiteManager.instance.buscarLoteUPDT(
      dateUPDT: dateFilter,
      userID: currentUserUid,
    );

    final putBeforeDedup = localPut.length;
    localPut = _dedupLotePutRows(localPut);
    final putDedupRemoved = putBeforeDedup - localPut.length;
    if (putDedupRemoved > 0) {
      _syncLog('putUpdtLotes',
          'Dedup interno INSERT: $putDedupRemoved duplicata(s) por id_lote removidas.');
    }

    final updBeforeDedup = localUpd.length;
    localUpd = _dedupLoteUpdateRows(localUpd);
    final updDedupRemoved = updBeforeDedup - localUpd.length;
    if (updDedupRemoved > 0) {
      _syncLog('putUpdtLotes',
          'Dedup interno UPDATE: $updDedupRemoved duplicata(s) por id_lote removidas.');
    }

    if (localPut.isNotEmpty) {
      final insertedIds =
          localPut.map((r) => r.idLote?.trim()).whereType<String>().toSet();
      if (insertedIds.isNotEmpty) {
        final before = localUpd.length;
        localUpd = localUpd
            .where((r) => !insertedIds.contains(r.idLote?.trim()))
            .toList();
        final removed = before - localUpd.length;
        if (removed > 0) {
          _syncLog('putUpdtLotes',
              'Dedupe PUT/UPDT: $removed registro(s) removidos.');
        }
      }
    }

    final insertItems =
        <({BuscarLotePUTRow row, Map<String, dynamic> payload})>[];
    for (final row in localPut) {
      _throwIfCancelled('putUpdtLotes');
      insertItems.add(
          (row: row, payload: _buildLotePayload(row.data, isInsert: true)));
    }

    if (insertItems.isEmpty && localUpd.isEmpty) {
      _syncLog('putUpdtLotes', 'Nada para enviar.');
      return true;
    }

    if (insertItems.isNotEmpty) {
      final insertPayloads =
          insertItems.map((item) => item.payload).toList(growable: false);
      _syncLog('putUpdtLotes',
          'UPSERT lote INSERT: ${insertPayloads.length} registro(s).');
      try {
        await _retry(
          () => _batchUpsertSupabase(
            tableName: 'lotes',
            rows: insertPayloads,
            onConflict: 'id_lote',
            chunkSize: 200,
            label: 'putUpdtLotes.insert',
          ),
          label: 'putUpdtLotes.insert.batchUpsert',
          maxAttempts: 3,
        );
        for (final item in insertItems) {
          final id = item.row.idLote;
          if (id != null && id.isNotEmpty) {
            syncedIds.add(id);
          }
          _markSyncOk('lote', id);
        }
      } catch (e, s) {
        _syncLog('putUpdtLotes',
            'ERRO no UPSERT em lote INSERT; tentando individual: $e\n$s');
        for (final item in insertItems) {
          _throwIfCancelled('putUpdtLotes.insert.individual');
          try {
            await _retry(
              () => _batchUpsertSupabase(
                tableName: 'lotes',
                rows: [item.payload],
                onConflict: 'id_lote',
                chunkSize: 1,
                label: 'putUpdtLotes.insert.individual',
              ),
              label: 'putUpdtLotes.insert.${item.row.idLote}',
              maxAttempts: 3,
            );
            final id = item.row.idLote;
            if (id != null && id.isNotEmpty) {
              syncedIds.add(id);
            }
            _markSyncOk('lote', id);
          } catch (rowError) {
            allSuccess = false;
            _recordSyncError(
              flow: 'putUpdtLotes',
              modulo: 'lote',
              operacao: 'insert',
              erro: rowError,
              registroId: item.row.idLote,
              registroDescricao: _descreverLoteBy(item.row.nome),
              payload: item.payload,
            );
          }
        }
      }
    }

    if (localUpd.isNotEmpty) {
      _syncLog('putUpdtLotes',
          'UPDATE explícito lote: ${localUpd.length} registro(s).');
    }
    for (final row in localUpd) {
      _throwIfCancelled('putUpdtLotes.update');
      final payload = _buildLotePayload(row.data, isInsert: false);
      final isDelete = payload['deletado'] == 'SIM';
      try {
        final matched = await _retry(
          () => _updateLoteSupabaseById(
            payload,
            label: 'putUpdtLotes.lote.update',
          ),
          label: 'putUpdtLotes.lote.update.${row.idLote}',
          maxAttempts: 3,
        );

        if (!matched && !isDelete) {
          final insertPayload = _buildLotePayload(row.data, isInsert: true);
          _syncLog('putUpdtLotes',
              'UPDATE lote não encontrou id_lote=${row.idLote}; recuperando com UPSERT INSERT idempotente.');
          await _retry(
            () => _batchUpsertSupabase(
              tableName: 'lotes',
              rows: [insertPayload],
              onConflict: 'id_lote',
              chunkSize: 1,
              label: 'putUpdtLotes.recovery.insert',
            ),
            label: 'putUpdtLotes.recovery.insert.${row.idLote}',
            maxAttempts: 3,
          );
          if (row.idLote != null && row.idLote!.isNotEmpty) {
            syncedIds.add(row.idLote!);
          }
          _markSyncOk('lote', row.idLote);
          continue;
        }

        if (!matched && isDelete) {
          _syncLog('putUpdtLotes',
              'DELETE remoto no-op: id_lote=${row.idLote} não existe mais no Supabase.');
        }
        if (row.idLote != null && row.idLote!.isNotEmpty) {
          syncedIds.add(row.idLote!);
        }
        _markSyncOk('lote', row.idLote);
      } catch (e) {
        allSuccess = false;
        _recordSyncError(
          flow: 'putUpdtLotes',
          modulo: 'lote',
          operacao: 'update',
          erro: e,
          registroId: row.idLote,
          registroDescricao: _descreverLoteBy(row.nome),
          payload: payload,
        );
      }
    }

    if (syncedIds.isNotEmpty) {
      await _clearLocalLoteSyncDirtyByIds(
        syncedIds,
        label: 'putUpdtLotes',
      );
    }
    _syncLog('putUpdtLotes',
        'Upload concluído. sucesso=$allSuccess enviados=${syncedIds.length}.');
    if (allSuccess) {
      // ignore: discarded_futures
      actions.SyncErrorLog.autoResolverModulo('lote');
    }
  } on SyncCancelledException catch (e) {
    allSuccess = false;
    _syncLog('putUpdtLotes', 'CANCELADO: $e');
  } on TimeoutException catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtLotes', 'TIMEOUT no upload: $e\n$s');
    _registrarErrosLote(localPut, localUpd, e);
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtLotes', 'ERRO no upload de lotes: $e\n$s');
    _registrarErrosLote(localPut, localUpd, e);
  }
  return allSuccess;
}

void _registrarErrosLote(
  List<BuscarLotePUTRow> puts,
  List<BuscarLoteUPDTRow> upds,
  Object e,
) {
  for (final r in puts) {
    _recordSyncError(
      flow: 'putUpdtLotes',
      modulo: 'lote',
      operacao: 'insert',
      erro: e,
      registroId: r.idLote,
      registroDescricao: r.nome,
    );
  }
  for (final r in upds) {
    _recordSyncError(
      flow: 'putUpdtLotes',
      modulo: 'lote',
      operacao: 'update',
      erro: e,
      registroId: r.idLote,
      registroDescricao: r.nome,
    );
  }
}

Map<String, dynamic> _buildLotePayload(
  Map<String, dynamic> raw, {
  required bool isInsert,
}) {
  dynamic value(List<String> keys) {
    for (final key in keys) {
      final v = raw[key];
      if (v != null) return v;
    }
    return null;
  }

  String? serializeDate(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s == 'null') return null;
    final dt = functions.converterParaData(s);
    if (dt == null) return null;
    return supaSerialize<DateTime>(dt);
  }

  final createdAt = serializeDate(value(['created_at', 'createdAt']));
  final updatedAt = serializeDate(value(['updated_at', 'updatedAt'])) ??
      createdAt ??
      supaSerialize<DateTime>(getCurrentTimestamp);

  final payload = <String, dynamic>{
    'id_lote': value(['id_lote', 'idLote']),
    'id_propriedade': value(['id_propriedade', 'idPropriedade']),
    'nome': value(['nome']),
    'anotacoes': value(['anotacoes']),
    'ativo': value(['ativo']),
    'motivo': value(['motivo']),
    'data_motivo': serializeDate(value(['data_motivo', 'dataMotivo'])),
    'deletado': value(['deletado']),
    'data_entrada_piquete':
        serializeDate(value(['data_entrada_piquete', 'dataEntradaPiquete'])),
    'data_saida_piquete':
        serializeDate(value(['data_saida_piquete', 'dataSaidaPiquete'])),
    'valorVenda': value(['valorVenda', 'valor_venda']),
    'updated_at': updatedAt,
  };
  if (isInsert) {
    payload['created_at'] = createdAt ?? updatedAt;
  }
  payload.removeWhere((_, v) => v == null);
  return payload;
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

    final putDeletados =
        localReproducao.where((r) => r.deletado == 'SIM').toList();
    localReproducao =
        localReproducao.where((r) => r.deletado != 'SIM').toList();
    if (putDeletados.isNotEmpty) {
      _syncLog('putUpdtReproducao',
          'PUT ignorou ${putDeletados.length} reprodução(ões) deletada(s); deletes seguem por UPDATE.');
    }

    if (localReproducao.length > 1) {
      final byId = <String, BuscarReproducaoPUTRow>{};
      final noId = <BuscarReproducaoPUTRow>[];
      for (final row in localReproducao) {
        final id = row.idReproducao;
        if (id == null || id.isEmpty) {
          noId.add(row);
        } else {
          byId[id] = row; // mantém a última ocorrência
        }
      }
      final removed = localReproducao.length - byId.length - noId.length;
      if (removed > 0) {
        _syncLog('putUpdtReproducao',
            'Dedup interno PUT: $removed duplicata(s) por id_reproducao removidas.');
      }
      localReproducao = [...noId, ...byId.values];
    }

    final putIds =
        localReproducao.map((r) => r.idReproducao).whereType<String>().toSet();
    if (putIds.isNotEmpty) {
      final before = localReproducaoUPDT.length;
      localReproducaoUPDT = localReproducaoUPDT
          .where((r) => !putIds.contains(r.idReproducao))
          .toList();
      final removed = before - localReproducaoUPDT.length;
      if (removed > 0) {
        _syncLog('putUpdtReproducao',
            'Dedupe PUT/UPDT: $removed update(s) removidos porque já estavam no PUT ativo.');
      }
    }

    if (localReproducaoUPDT.length > 1) {
      final byId = <String, BuscarReproducaoUPDTRow>{};
      final noId = <BuscarReproducaoUPDTRow>[];
      for (final row in localReproducaoUPDT) {
        final id = row.idReproducao;
        if (id == null || id.isEmpty) {
          noId.add(row);
        } else {
          byId[id] = row; // mantém a última ocorrência
        }
      }
      final removed = localReproducaoUPDT.length - byId.length - noId.length;
      if (removed > 0) {
        _syncLog('putUpdtReproducao',
            'Dedup interno UPDATE: $removed duplicata(s) por id_reproducao removidas.');
      }
      localReproducaoUPDT = [...noId, ...byId.values];
    }

    final inserts = <Map<String, dynamic>>[];
    for (final row in localReproducao) {
      _throwIfCancelled('putUpdtReproducao.insert');
      inserts.add(_buildReproducaoPayload(row.data, isInsert: true));
    }
    if (inserts.isEmpty && localReproducaoUPDT.isEmpty) {
      _syncLog('putUpdtReproducao', 'Nada para enviar.');
      return true;
    }

    if (inserts.isNotEmpty) {
      _syncLog('putUpdtReproducao',
          'INSERT/UPSERT reprodução: ${inserts.length} novo(s) ativo(s).');
      try {
        await _retry(
          () => _batchUpsertSupabase(
            tableName: 'reproducao',
            rows: inserts,
            onConflict: 'id_reproducao',
            chunkSize: 200,
            label: 'putUpdtReproducao.reproducao.insert',
          ),
          label: 'putUpdtReproducao.reproducao.insert.batchUpsert',
          maxAttempts: 3,
        );
        for (final row in localReproducao) {
          _markSyncOk('reproducao', row.idReproducao);
          // ignore: discarded_futures
          actions.SyncErrorLog.autoResolverPorRegistro(
              'reproducao', row.idReproducao);
        }
      } catch (e) {
        allSuccess = false;
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
      }
    }

    if (localReproducaoUPDT.isNotEmpty) {
      _syncLog('putUpdtReproducao',
          'UPDATE explícito reprodução: ${localReproducaoUPDT.length} registro(s).');
      for (final row in localReproducaoUPDT) {
        _throwIfCancelled('putUpdtReproducao.update');
        final payload = _buildReproducaoPayload(row.data, isInsert: false);
        final isDelete = payload['deletado'] == 'SIM';
        try {
          final matched = await _retry(
            () => _updateReproducaoSupabaseById(
              payload,
              label: 'putUpdtReproducao.reproducao.update',
            ),
            label: 'putUpdtReproducao.reproducao.update.${row.idReproducao}',
            maxAttempts: 3,
          );

          if (!matched && !isDelete) {
            allSuccess = false;
            final error = StateError(
                'UPDATE reprodução não encontrou id_reproducao=${row.idReproducao} no Supabase; INSERT não executado para evitar duplicidade.');
            _recordSyncError(
              flow: 'putUpdtReproducao',
              modulo: 'reproducao',
              operacao: 'update',
              erro: error,
              registroId: row.idReproducao,
              registroDescricao: _descreverReproducaoBy(row.dataInseminacao),
            );
            _syncLog('putUpdtReproducao', error.message);
            continue;
          }

          if (!matched && isDelete) {
            _syncLog('putUpdtReproducao',
                'DELETE remoto no-op: id_reproducao=${row.idReproducao} não existe mais no Supabase.');
          }
          _markSyncOk('reproducao', row.idReproducao);
          // ignore: discarded_futures
          actions.SyncErrorLog.autoResolverPorRegistro(
              'reproducao', row.idReproducao);
        } catch (e) {
          allSuccess = false;
          _recordSyncError(
            flow: 'putUpdtReproducao',
            modulo: 'reproducao',
            operacao: 'update',
            erro: e,
            registroId: row.idReproducao,
            registroDescricao: _descreverReproducaoBy(row.dataInseminacao),
          );
        }
      }
    }

    _syncLog(
      'putUpdtReproducao',
      allSuccess
          ? 'Upload concluído com sucesso.'
          : 'Upload finalizado com falhas registradas.',
    );
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
  final statusReproducao = nullableStr(raw['status_reproducao']);
  final previsaoPartoPermitida =
      functions.permitePrevisaoParto(statusReproducao);
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
    'previsao_parto':
        previsaoPartoPermitida ? parseDate(raw['previsao_parto']) : null,
    'data_inicial': parseDate(raw['data_inicial']),
    'data_final': parseDate(raw['data_final']),
    'status_reproducao': statusReproducao,
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
  // id_lote/loteNome enviados tanto em insert quanto em update, para permitir
  // alterar o lote vinculado à reprodução (chaves nulas são removidas abaixo).
  payload['id_lote'] = nullableStr(raw['id_lote']);
  payload['loteNome'] = nullableStr(raw['loteNome']);

  // Remove chaves null para não sobrescrever valores remotos com null
  // em campos que não foram alterados off-line (comportamento conservador
  // em upsert).
  payload.removeWhere((key, value) =>
      value == null &&
      key != 'id_rebanho_matriz' &&
      key != 'id_rebanho_reprodutor' &&
      !(key == 'previsao_parto' && !previsaoPartoPermitida));
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
  final dataPendente = FFAppState().dataDadosNaoSyncSanidade;
  if (dataPendente == null) return true;

  List<BuscarSanidadePUTRow> localPut = const [];
  List<BuscarSanidadeUPDTRow> localUpd = const [];

  try {
    _throwIfCancelled('putUpdtSanidades');
    final dateFilter = dateTimeFormat(
      "yyyy-MM-dd HH:mm:ss",
      dataPendente,
      locale: FFLocalizations.of(context).languageCode,
    );

    localPut =
        await SQLiteManager.instance.buscarSanidadePUT(datePUT: dateFilter);
    localUpd =
        await SQLiteManager.instance.buscarSanidadeUPDT(dateUPDT: dateFilter);

    final putDeletados = localPut.where((r) => r.deletado == 'SIM').toList();
    localPut = localPut.where((r) => r.deletado != 'SIM').toList();
    if (putDeletados.isNotEmpty) {
      _syncLog('putUpdtSanidades',
          'PUT ignorou ${putDeletados.length} sanidade(s) deletada(s); deletes seguem por UPDATE.');
    }

    if (localPut.length > 1) {
      final byId = <String, BuscarSanidadePUTRow>{};
      final noId = <BuscarSanidadePUTRow>[];
      for (final row in localPut) {
        final id = row.idSanidade;
        if (id == null || id.isEmpty) {
          noId.add(row);
        } else {
          byId[id] = row;
        }
      }
      final removed = localPut.length - byId.length - noId.length;
      if (removed > 0) {
        _syncLog('putUpdtSanidades',
            'Dedup interno PUT: $removed duplicata(s) por id_sanidade removidas.');
      }
      localPut = [...noId, ...byId.values];
    }

    final insertedIds =
        localPut.map((r) => r.idSanidade).whereType<String>().toSet();
    if (insertedIds.isNotEmpty) {
      final before = localUpd.length;
      localUpd =
          localUpd.where((r) => !insertedIds.contains(r.idSanidade)).toList();
      final removed = before - localUpd.length;
      if (removed > 0) {
        _syncLog('putUpdtSanidades',
            'Dedupe PUT/UPDT: $removed update(s) removidos porque já estavam no PUT ativo.');
      }
    }

    if (localUpd.length > 1) {
      final byId = <String, BuscarSanidadeUPDTRow>{};
      final noId = <BuscarSanidadeUPDTRow>[];
      for (final row in localUpd) {
        final id = row.idSanidade;
        if (id == null || id.isEmpty) {
          noId.add(row);
        } else {
          byId[id] = row;
        }
      }
      final removed = localUpd.length - byId.length - noId.length;
      if (removed > 0) {
        _syncLog('putUpdtSanidades',
            'Dedup interno UPDATE: $removed duplicata(s) por id_sanidade removidas.');
      }
      localUpd = [...noId, ...byId.values];
    }

    final inserts = <Map<String, dynamic>>[];
    for (final row in localPut) {
      _throwIfCancelled('putUpdtSanidades.insert');
      inserts.add(_buildSanidadePayload(row.data, isInsert: true));
    }
    if (inserts.isEmpty && localUpd.isEmpty) {
      _syncLog('putUpdtSanidades', 'Nada para enviar.');
      return true;
    }

    if (inserts.isNotEmpty) {
      _syncLog('putUpdtSanidades',
          'INSERT/UPSERT sanidade: ${inserts.length} novo(s) ativo(s).');
      try {
        await _retry(
          () => _batchUpsertSupabase(
            tableName: 'sanidade',
            rows: inserts,
            onConflict: 'id_sanidade',
            chunkSize: 200,
            label: 'putUpdtSanidades.sanidade.insert',
          ),
          label: 'putUpdtSanidades.sanidade.insert.batchUpsert',
          maxAttempts: 3,
        );
        for (final row in localPut) {
          _markSyncOk('sanidade', row.idSanidade);
          // ignore: discarded_futures
          actions.SyncErrorLog.autoResolverPorRegistro(
              'sanidade', row.idSanidade);
        }
      } catch (e) {
        allSuccess = false;
        for (final row in localPut) {
          _recordSyncError(
            flow: 'putUpdtSanidades',
            modulo: 'sanidade',
            operacao: 'insert',
            erro: e,
            registroId: row.idSanidade,
            registroDescricao: 'Sanidade ${row.dataSanidade ?? ""}',
          );
        }
      }
    }

    if (localUpd.isNotEmpty) {
      _syncLog('putUpdtSanidades',
          'UPDATE explícito sanidade: ${localUpd.length} registro(s).');
      for (final row in localUpd) {
        _throwIfCancelled('putUpdtSanidades.update');
        final payload = _buildSanidadePayload(row.data, isInsert: false);
        final isDelete = payload['deletado'] == 'SIM';
        try {
          final matched = await _retry(
            () => _updateSanidadeSupabaseById(
              payload,
              label: 'putUpdtSanidades.sanidade.update',
            ),
            label: 'putUpdtSanidades.sanidade.update.${row.idSanidade}',
            maxAttempts: 3,
          );

          if (!matched && !isDelete) {
            allSuccess = false;
            final error = StateError(
                'UPDATE sanidade não encontrou id_sanidade=${row.idSanidade} no Supabase; INSERT não executado para evitar duplicidade.');
            _recordSyncError(
              flow: 'putUpdtSanidades',
              modulo: 'sanidade',
              operacao: 'update',
              erro: error,
              registroId: row.idSanidade,
              registroDescricao: 'Sanidade ${row.dataSanidade ?? ""}',
            );
            _syncLog('putUpdtSanidades', error.message);
            continue;
          }

          if (!matched && isDelete) {
            _syncLog('putUpdtSanidades',
                'DELETE remoto no-op: id_sanidade=${row.idSanidade} não existe mais no Supabase.');
          }
          _markSyncOk('sanidade', row.idSanidade);
          // ignore: discarded_futures
          actions.SyncErrorLog.autoResolverPorRegistro(
              'sanidade', row.idSanidade);
        } catch (e) {
          allSuccess = false;
          _recordSyncError(
            flow: 'putUpdtSanidades',
            modulo: 'sanidade',
            operacao: 'update',
            erro: e,
            registroId: row.idSanidade,
            registroDescricao: 'Sanidade ${row.dataSanidade ?? ""}',
          );
        }
      }
    }
    _syncLog(
      'putUpdtSanidades',
      allSuccess
          ? 'Upload concluído.'
          : 'Upload finalizado com falhas registradas.',
    );
  } on SyncCancelledException catch (e) {
    allSuccess = false;
    _syncLog('putUpdtSanidades', 'CANCELADO: $e');
  } on TimeoutException catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtSanidades', 'TIMEOUT no upload: $e\n$s');
    _registrarErrosSanidade(localPut, localUpd, e);
  } catch (e, s) {
    allSuccess = false;
    _syncLog('putUpdtSanidades', 'ERRO no upload de sanidades: $e\n$s');
    _registrarErrosSanidade(localPut, localUpd, e);
  }
  return allSuccess;
}

void _registrarErrosSanidade(
  List<BuscarSanidadePUTRow> puts,
  List<BuscarSanidadeUPDTRow> upds,
  Object e,
) {
  for (final r in puts) {
    _recordSyncError(
      flow: 'putUpdtSanidades',
      modulo: 'sanidade',
      operacao: 'insert',
      erro: e,
      registroId: r.idSanidade,
      registroDescricao: 'Sanidade ${r.dataSanidade ?? ""}',
    );
  }
  for (final r in upds) {
    _recordSyncError(
      flow: 'putUpdtSanidades',
      modulo: 'sanidade',
      operacao: 'update',
      erro: e,
      registroId: r.idSanidade,
      registroDescricao: 'Sanidade ${r.dataSanidade ?? ""}',
    );
  }
}

Map<String, dynamic> _buildSanidadePayload(
  Map<String, dynamic> raw, {
  required bool isInsert,
}) {
  dynamic value(String snakeCaseKey, String camelCaseKey) {
    return raw[snakeCaseKey] ?? raw[camelCaseKey];
  }

  String? serializeDate(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s == 'null') return null;
    final dt = functions.converterParaData(s);
    if (dt == null) return null;
    return supaSerialize<DateTime>(dt);
  }

  final payload = <String, dynamic>{
    'id_sanidade': value('id_sanidade', 'idSanidade'),
    'id_propriedade': value('id_propriedade', 'idPropriedade'),
    'deletado': value('deletado', 'deletado'),
    'updated_at': serializeDate(value('updated_at', 'updatedAt')),
    'id_rebanho': value('id_rebanho', 'idRebanho'),
    'data_sanidade': serializeDate(value('data_sanidade', 'dataSanidade')),
    'id_lote': value('id_lote', 'idLote'),
    'porcentagem_lote': value('porcentagem_lote', 'porcentagemLote'),
    'vacinacao': value('vacinacao', 'vacinacao'),
    'vacinacao_outros': value('vacinacao_outros', 'vacinacaoOutros'),
    'vacinacao_obs': value('vacinacao_obs', 'vacinacaoObs'),
    'antiparasitario': value('antiparasitario', 'antiparasitario'),
    'antiparasitario_outros':
        value('antiparasitario_outros', 'antiparasitarioOutros'),
    'antiparasitario_obs': value('antiparasitario_obs', 'antiparasitarioObs'),
    'tratamento': value('tratamento', 'tratamento'),
    'tratamento_outros': value('tratamento_outros', 'tratamentoOutros'),
    'tratamento_obs': value('tratamento_obs', 'tratamentoObs'),
    'protocolo_reprodutivo':
        value('protocolo_reprodutivo', 'protocoloReprodutivo'),
    'protocolo_reprodutivo_outros':
        value('protocolo_reprodutivo_outros', 'protocoloReprodutivoOutros'),
    'protocolo_reprodutivo_obs':
        value('protocolo_reprodutivo_obs', 'protocoloReprodutivoObs'),
    'protocolo_d0': value('protocolo_d0', 'protocoloD0'),
    'protocolo_retirada': value('protocolo_retirada', 'protocoloRetirada'),
    'protocolo_iatf': value('protocolo_iatf', 'protocoloIatf'),
  };
  if (isInsert) {
    payload['created_at'] = serializeDate(value('created_at', 'createdAt'));
  }
  payload.removeWhere((_, v) => v == null);
  return payload;
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
    var shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('rebanho',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    List<String>? preflightPropertyIds;
    var forceCompleteBecauseIncomplete = false;
    if (!shouldSync) {
      try {
        final propriedades =
            await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
          pUserId: currentUserUid,
        );
        preflightPropertyIds = _safePropertyIds(propriedades.jsonBody);
        if (preflightPropertyIds.isNotEmpty) {
          final fullCountResponse =
              await SupabaseFunctionsGroup.qTDRebanhosCall.call(
            pIdsPropriedadesList: preflightPropertyIds,
          );
          final fullRemoteCount = _safeTotalFromApi(fullCountResponse.jsonBody);
          final localCount = await _countLocalRowsForProperties(
            'local_rebanho',
            'idPropriedade',
            preflightPropertyIds,
            extraWhere: "AND COALESCE(deletado, 'NAO') != 'SIM'",
          );
          _syncLog('rebanho',
              'Conferência de completude: local=$localCount remoto_completo=$fullRemoteCount.');
          if (_localDataLooksIncomplete(
            localCount: localCount,
            remoteTotal: fullRemoteCount,
          )) {
            shouldSync = true;
            forceCompleteBecauseIncomplete = true;
            _syncLog('rebanho',
                'Base local incompleta para as propriedades do usuário. Forçando sincronização COMPLETA de rebanho.');
          }
        }
      } catch (e, s) {
        _syncLog('rebanho',
            'Falha ao conferir completude local; mantendo decisão original: $e\n$s');
      }
    }

    if (shouldSync) {
      var isFirst = forceCompleteBecauseIncomplete ||
          _isFirstSync(localLastChange) ||
          await _isLocalTableEmpty('local_rebanho');
      _syncLog('rebanho',
          'Iniciando sincronização ${isFirst ? "COMPLETA (primeiro sync)" : "INCREMENTAL"}.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      var paginationComplete = true;
      FFAppState().indexRebPaginacao = 0;
      FFAppState().visibleProgressBar = true;
      FFAppState().update(() {});

      String? updatedAfter = (!isFirst && localLastChange != null)
          ? localLastChange.toUtc().toIso8601String()
          : null;

      try {
        final propertyIds = preflightPropertyIds ??
            _safePropertyIds(
              (await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
                pUserId: currentUserUid,
              ))
                  .jsonBody,
            );
        _syncLog('rebanho', 'Propriedades encontradas: ${propertyIds.length}.');

        if (propertyIds.isEmpty) {
          _syncLog(
              'rebanho', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        final fullCountResponse = await SupabaseFunctionsGroup.qTDRebanhosCall
            .call(pIdsPropriedadesList: propertyIds);
        final fullRemoteCount = _safeTotalFromApi(fullCountResponse.jsonBody);
        final localCount = await _countLocalRowsForProperties(
          'local_rebanho',
          'idPropriedade',
          propertyIds,
          extraWhere: "AND COALESCE(deletado, 'NAO') != 'SIM'",
        );
        _syncLog('rebanho',
            'Conferência de completude: local=$localCount remoto_completo=$fullRemoteCount.');
        if (!isFirst &&
            _localDataLooksIncomplete(
              localCount: localCount,
              remoteTotal: fullRemoteCount,
            )) {
          isFirst = true;
          updatedAfter = null;
          _syncLog('rebanho',
              'Base local incompleta detectada durante sync. Trocando incremental por COMPLETA.');
        }

        if (updatedAfter != null) {
          qtdRebanhosO = await SupabaseFunctionsGroup.qTDRebanhosIncCall.call(
            pIdsPropriedadesList: propertyIds,
            pUpdatedAfter: updatedAfter,
          );
        } else {
          qtdRebanhosO = fullCountResponse;
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
              paginationComplete = false;
              syncErrors.add({
                'id': 'página offset=$offsetAtual',
                'error': 'Página vazia antes de baixar o total esperado',
              });
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
            if (pageRecords.length < pageSize) {
              _syncLog('rebanho',
                  'Última página detectada (tamanho < pageSize=$pageSize). Encerrando paginação.');
              break;
            }
          } catch (e, s) {
            _syncLog('rebanho',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            paginationComplete = false;
            break;
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
        if (syncErrors.isEmpty && paginationComplete) {
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

Future refreshReproducaoOtimizada(
  BuildContext context, {
  bool allowLotSnapshotRepair = false,
}) async {
  try {
    _syncLog('reproducao', 'Iniciando verificação do change tracker...');
    List<ReproducaoChangeTrackerRow>? lastChangeResultO;
    ApiCallResponse? propriedades;
    ApiCallResponse? qtdReproducoes;
    ApiCallResponse? reproducaoAPI;
    final prefs = await SharedPreferences.getInstance();
    final forceLotSnapshotRepair = allowLotSnapshotRepair &&
        !(prefs.getBool(_reproLotSnapshotRepairPrefsKey) ?? false);

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
    var shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    if (forceLotSnapshotRepair) {
      shouldSync = true;
      _syncLog('reproducao',
          'Forçando pull completo único para reparar snapshot de lote da reprodução.');
    }
    _syncLog('reproducao',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    List<String>? preflightPropertyIds;
    var forceCompleteBecauseIncomplete = false;
    if (!shouldSync) {
      try {
        final propriedades = await _withTimeout(
          () => SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
            pUserId: currentUserUid,
          ),
          label: 'reproducao.preflight.buscarPropriedadesUser',
          timeout: kSyncPageTimeout,
        );
        preflightPropertyIds = _safePropertyIds(propriedades.jsonBody);
        if (preflightPropertyIds.isNotEmpty) {
          final fullCountResponse = await _withTimeout(
            () => SupabaseFunctionsGroup.qTDReproducoesCall.call(
              pIdsPropriedadesList: preflightPropertyIds,
            ),
            label: 'reproducao.preflight.qTDReproducoes',
            timeout: kSyncPageTimeout,
          );
          final fullRemoteCount = _safeTotalFromApi(fullCountResponse.jsonBody);
          final localCount = await _countLocalRowsForProperties(
            'local_reproducao',
            'id_propriedade',
            preflightPropertyIds,
            extraWhere: "AND COALESCE(deletado, 'NAO') != 'SIM'",
          );
          _syncLog('reproducao',
              'Conferência de completude: local=$localCount remoto_completo=$fullRemoteCount.');
          if (_localDataLooksIncomplete(
            localCount: localCount,
            remoteTotal: fullRemoteCount,
          )) {
            shouldSync = true;
            forceCompleteBecauseIncomplete = true;
            _syncLog('reproducao',
                'Base local incompleta para as propriedades do usuário. Forçando sincronização COMPLETA de reprodução.');
          }
        }
      } catch (e, s) {
        _syncLog('reproducao',
            'Falha ao conferir completude local; mantendo decisão original: $e\n$s');
      }
    }

    if (shouldSync) {
      var isFirst = forceLotSnapshotRepair ||
          forceCompleteBecauseIncomplete ||
          _isFirstSync(localLastChange) ||
          await _isLocalTableEmpty('local_reproducao');
      _syncLog('reproducao',
          'Iniciando sincronização ${isFirst ? "COMPLETA (primeiro sync)" : "INCREMENTAL"}.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      var paginationComplete = true;
      FFAppState().indexReproPaginacao = 0;
      FFAppState().visibilidadeProgressBarRepro = true;
      FFAppState().update(() {});

      String? updatedAfter = (!isFirst && localLastChange != null)
          ? localLastChange.toUtc().toIso8601String()
          : null;

      try {
        List<String> propertyIds;
        if (preflightPropertyIds != null) {
          propertyIds = preflightPropertyIds;
        } else {
          propriedades = await _withTimeout(
            () => SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
              pUserId: currentUserUid,
            ),
            label: 'reproducao.buscarPropriedadesUser',
            timeout: kSyncPageTimeout,
          );
          propertyIds = _safePropertyIds(propriedades?.jsonBody);
        }
        _syncLog(
            'reproducao', 'Propriedades encontradas: ${propertyIds.length}.');

        if (propertyIds.isEmpty) {
          _syncLog(
              'reproducao', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        if (!isFirst) {
          final fullCountResponse = await _withTimeout(
            () => SupabaseFunctionsGroup.qTDReproducoesCall.call(
              pIdsPropriedadesList: propertyIds,
            ),
            label: 'reproducao.qTDReproducoes.fullCheck',
            timeout: kSyncPageTimeout,
          );
          final fullRemoteCount = _safeTotalFromApi(fullCountResponse.jsonBody);
          final localCount = await _countLocalRowsForProperties(
            'local_reproducao',
            'id_propriedade',
            propertyIds,
            extraWhere: "AND COALESCE(deletado, 'NAO') != 'SIM'",
          );
          _syncLog('reproducao',
              'Conferência de completude: local=$localCount remoto_completo=$fullRemoteCount.');
          if (_localDataLooksIncomplete(
            localCount: localCount,
            remoteTotal: fullRemoteCount,
          )) {
            isFirst = true;
            updatedAfter = null;
            _syncLog('reproducao',
                'Base local incompleta detectada durante sync. Trocando incremental por COMPLETA.');
          }
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
          _syncLog(
              'reproducao', 'Primeiro sync. Iniciando paginação (UPSERT)...');
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
              paginationComplete = false;
              syncErrors.add({
                'id': 'página offset=$offsetAtual',
                'error': 'Página vazia antes de baixar o total esperado',
              });
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
            if (pageRecords.length < pageSize) {
              _syncLog('reproducao',
                  'Última página detectada (tamanho < pageSize=$pageSize). Encerrando paginação.');
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
            paginationComplete = false;
            break;
          } catch (e, s) {
            _syncLog('reproducao',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            // A8: quebra em vez de incrementar 999 e mascarar erro.
            paginationComplete = false;
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
        if (syncErrors.isEmpty && paginationComplete) {
          FFAppState().reproducaoChangeDateTime =
              remoteLastChange ?? DateTime.now();
          if (forceLotSnapshotRepair) {
            await prefs.setBool(_reproLotSnapshotRepairPrefsKey, true);
            _syncLog('reproducao',
                'Reparo único de snapshot de lote marcado como concluído.');
            _syncLog('reproducao',
                'Registros cujo lote já estava incorreto no Supabase não foram inferidos automaticamente.');
          }
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

Future refreshPesagens(BuildContext context) {
  final active = _refreshPesagensInFlight;
  if (active != null) {
    _syncLog('pesagens',
        'Sincronização de pesagens já em andamento; aguardando execução atual.');
    return active;
  }

  late final Future<void> future;
  future = _refreshPesagensInternal(context).whenComplete(() {
    if (identical(_refreshPesagensInFlight, future)) {
      _refreshPesagensInFlight = null;
    }
  });
  _refreshPesagensInFlight = future;
  return future;
}

Future<void> _refreshPesagensInternal(BuildContext context) async {
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
      _syncLog('pesagens',
          'Sem alterações incrementais; verificando backfill de pesagens com tipo vazio.');
    }

    final localPesagensEmpty =
        await _isLocalTableEmpty('local_historico_pesagens');
    var effectiveLocalLastChange = localLastChange;
    if (!localPesagensEmpty && _isFirstSync(effectiveLocalLastChange)) {
      effectiveLocalLastChange = await _localPesagensMaxCreatedAt();
      _syncLog('pesagens',
          'Marcador local ausente/antigo; usando max(created_at) local como recuperação: $effectiveLocalLastChange.');
    }
    final isFirst = localPesagensEmpty;
    final String? updatedAfter = (!isFirst && effectiveLocalLastChange != null)
        ? effectiveLocalLastChange.toUtc().toIso8601String()
        : null;

    _syncLog(
        'pesagens',
        shouldSync
            ? 'Iniciando sincronização ${isFirst ? "COMPLETA (primeiro sync)" : "INCREMENTAL desde $updatedAfter"}.'
            : 'Sincronização incremental pulada; backfill de tipo vazio será completo.');
    var syncOk = true;
    final List<Map<String, String>> syncErrors = [];
    int totalInserted = 0;

    try {
      propriedadessO =
          await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
        pUserId: currentUserUid,
      );

      final propertyIds = _safePropertyIds(propriedadessO.jsonBody);
      _syncLog('pesagens', 'Propriedades encontradas: ${propertyIds.length}.');

      if (propertyIds.isEmpty) {
        _syncLog('pesagens', 'Nenhuma propriedade encontrada. Abortando sync.');
        return;
      }

      var keysetCompleted = false;
      Object? keysetError;
      if (shouldSync) {
        try {
          _syncLog('pesagens', 'Usando paginação keyset por RPC.');
          final keysetResult = await _syncPesagensKeysetPages(
            propertyIds: propertyIds,
            updatedAfter: updatedAfter,
          );
          totalInserted += keysetResult.inserted;
          syncErrors.addAll(keysetResult.errors);
          keysetCompleted = true;
        } catch (e, s) {
          keysetError = e;
          _syncLog('pesagens',
              'RPC keyset indisponível/falhou. Fallback REST com OFFSET: $e\n$s');
        }
      }

      if (shouldSync && !keysetCompleted) {
        // Fallback legado direto da tabela REST para instalações onde a migration
        // da RPC ainda não foi aplicada.
        pesagensAPI = await _buscarPesagensDireto(
          propertyIds: propertyIds,
          limit: 999,
          offset: 0,
          includeCount: true,
          updatedAfter: updatedAfter,
        );

        final firstPageRecords = _safeRecordsFromApi(pesagensAPI.jsonBody);
        final totalPesagens =
            _safeTotalFromContentRange(pesagensAPI.headers) > 0
                ? _safeTotalFromContentRange(pesagensAPI.headers)
                : firstPageRecords.length;
        FFAppState().totalPesagens = totalPesagens;
        var fetchedCount = 0;
        FFAppState().indexPesagens = fetchedCount;
        _syncLog('pesagens', 'Total remoto informado: $totalPesagens.');
        _syncLog('pesagens',
            'Primeira página parseada: ${firstPageRecords.length} registros.');

        if (firstPageRecords.isEmpty) {
          if (updatedAfter != null) {
            _syncLog('pesagens',
                'Nenhuma alteração remota desde último sync. Atualizando timestamp.');
            FFAppState().pesagensChangeDateTime =
                remoteLastChange ?? DateTime.now();
          } else {
            _syncLog('pesagens',
                'Primeira página vazia apesar de total=$totalPesagens. Não apagando dados locais.');
          }
        }

        if (isFirst) {
          // Primeiro sync: UPSERT sem deletar para segurança
          _syncLog('pesagens',
              'Primeiro sync. Inserindo primeira página (UPSERT)...');
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

        fetchedCount = firstPageRecords.length;
        FFAppState().indexPesagens = fetchedCount;

        // Continuar com as páginas restantes
        if (firstPageRecords.length >= 999) {
          while (true) {
            _throwIfCancelled('refreshPesagens');
            final offsetAtual = fetchedCount;
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

              final result =
                  await actions.batchInsertLocalPesagens(pageRecords);
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

              fetchedCount += pageRecords.length;
              FFAppState().indexPesagens = fetchedCount;
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
              fetchedCount += 999;
              FFAppState().indexPesagens = fetchedCount;
            }
          }
        }
      }

      final tipoVazioResult = await _syncPesagensTipoVazioRestPages(
        propertyIds: propertyIds,
        updatedAfter: null,
      );
      totalInserted += tipoVazioResult.inserted;
      syncErrors.addAll(tipoVazioResult.errors);

      try {
        final localRebIds = await _getLocalRebanhoIds();
        if (localRebIds.isNotEmpty) {
          _syncLog('pesagens',
              'Backfill tipo vazio: verificando id_propriedade NULL para ${localRebIds.length} animais locais.');
          final tipoVazioSemPropriedadeResult =
              await _syncPesagensTipoVazioSemPropriedadePages(
            rebanhoIds: localRebIds,
          );
          totalInserted += tipoVazioSemPropriedadeResult.inserted;
          syncErrors.addAll(tipoVazioSemPropriedadeResult.errors);
        }
      } catch (e, s) {
        _syncLog('pesagens',
            'Erro no backfill de tipo vazio sem propriedade: $e\n$s');
      }

      // ── Catch-up: buscar pesagens com id_propriedade NULL ──────────
      // Registros criados pela web podem não ter id_propriedade preenchido,
      // o que faz com que o filtro principal (in.props) os ignore.
      // Aqui buscamos esses registros usando os idRebanho locais do usuário.
      //
      // OTIMIZAÇÃO: a varredura por idRebanho é um fallback legado caro.
      // Se a RPC existe e só falhou por timeout, o fallback principal por
      // propriedade já cobre os dados esperados e evita varrer todo o rebanho.
      final lastCatchup = FFAppState().lastCatchupPesagens;
      final skipCatchupAfterKeysetTimeout =
          !keysetCompleted && _isTimeoutLikeError(keysetError);
      final shouldRunCatchup = shouldSync &&
          !keysetCompleted &&
          !skipCatchupAfterKeysetTimeout &&
          (isFirst ||
              lastCatchup == null ||
              DateTime.now().difference(lastCatchup) >
                  const Duration(hours: 6));
      if (!shouldRunCatchup) {
        final message = keysetCompleted
            ? 'Catch-up legado pulado: RPC keyset/backfill cobre id_propriedade.'
            : skipCatchupAfterKeysetTimeout
                ? 'Catch-up legado pulado: RPC keyset falhou por timeout; fallback principal já cobre id_propriedade e evita varredura pesada.'
                : 'Catch-up pulado (último em $lastCatchup, < 6h atrás).';
        _syncLog('pesagens', message);
      }
      try {
        if (shouldRunCatchup) {
          final localRebIds = await _getLocalRebanhoIds();
          if (localRebIds.isNotEmpty) {
            _syncLog('pesagens',
                'Catch-up: verificando pesagens com id_propriedade NULL para ${localRebIds.length} animais.');
            // Reduzido de 200 → 50: URLs menores (~1.8KB vs ~7.2KB), queries
            // Postgres mais leves, e cancelamento mais granular.
            const batchSize = 50;
            for (var i = 0; i < localRebIds.length; i += batchSize) {
              _throwIfCancelled('refreshPesagens');
              final batch = localRebIds.sublist(
                  i,
                  i + batchSize > localRebIds.length
                      ? localRebIds.length
                      : i + batchSize);
              var catchupOffset = 0;
              while (true) {
                _throwIfCancelled('refreshPesagens');
                final resp = await _buscarPesagensSemPropriedade(
                  rebanhoIds: batch,
                  limit: 999,
                  offset: catchupOffset,
                  updatedAfter: updatedAfter,
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
            FFAppState().lastCatchupPesagens = DateTime.now();
          }
        }
      } catch (e, s) {
        _syncLog(
            'pesagens', 'Erro no catch-up de pesagens sem propriedade: $e\n$s');
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
      lastChangeResult = await _withTimeout(
        () => SanidadeChangeTrackerTable().queryRows(queryFn: (q) => q),
        label: 'sanidade.changeTracker.queryRows',
        timeout: kSyncLightTimeout,
      );
    } on TimeoutException catch (e, s) {
      _syncLog('sanidade', 'TIMEOUT ao consultar change tracker: $e\n$s');
      lastChangeResult = [];
    } catch (e, s) {
      _syncLog('sanidade', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResult = [];
    }
    final remoteLastChange = lastChangeResult?.firstOrNull?.lastChange;
    final localLastChange = FFAppState().sanidadeChangeDateTime;
    var shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('sanidade',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    List<String>? preflightPropertyIds;
    var forceCompleteBecauseIncomplete = false;
    if (!shouldSync) {
      try {
        final propriedades = await _withTimeout(
          () => SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
            pUserId: currentUserUid,
          ),
          label: 'sanidade.preflight.buscarPropriedadesUser',
          timeout: kSyncPageTimeout,
        );
        preflightPropertyIds = _safePropertyIds(propriedades.jsonBody);
        if (preflightPropertyIds.isNotEmpty) {
          final fullCountResponse = await _withTimeout(
            () => SupabaseFunctionsGroup.qTDSanidadeCall.call(
              pIdsPropriedadesList: preflightPropertyIds,
            ),
            label: 'sanidade.preflight.qTDSanidade',
            timeout: kSyncPageTimeout,
          );
          final fullRemoteCount = _safeTotalFromApi(fullCountResponse.jsonBody);
          final localCount = await _countLocalRowsForProperties(
            'local_sanidade',
            'id_propriedade',
            preflightPropertyIds,
            extraWhere: "AND COALESCE(deletado, 'NAO') != 'SIM'",
          );
          _syncLog('sanidade',
              'Conferência de completude: local=$localCount remoto_completo=$fullRemoteCount.');
          if (_localDataLooksIncomplete(
            localCount: localCount,
            remoteTotal: fullRemoteCount,
          )) {
            shouldSync = true;
            forceCompleteBecauseIncomplete = true;
            _syncLog('sanidade',
                'Base local incompleta para as propriedades do usuário. Forçando sincronização COMPLETA de sanidade.');
          }
        }
      } catch (e, s) {
        _syncLog('sanidade',
            'Falha ao conferir completude local; mantendo decisão original: $e\n$s');
      }
    }

    if (shouldSync) {
      var isFirst = forceCompleteBecauseIncomplete ||
          _isFirstSync(localLastChange) ||
          await _isLocalTableEmpty('local_sanidade');
      _syncLog('sanidade',
          'Iniciando sincronização ${isFirst ? "COMPLETA (primeiro sync)" : "INCREMENTAL"}.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      var paginationComplete = true;
      FFAppState().sanidadeIndex = 0;
      FFAppState().indexSanidadePaginacao = 0;
      FFAppState().visbilidadeProgressBarSan = true;
      FFAppState().update(() {});

      String? updatedAfter = (!isFirst && localLastChange != null)
          ? localLastChange.toUtc().toIso8601String()
          : null;

      try {
        List<String> propertyIds;
        if (preflightPropertyIds != null) {
          propertyIds = preflightPropertyIds;
        } else {
          propriedades = await _withTimeout(
            () => SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
              pUserId: currentUserUid,
            ),
            label: 'sanidade.buscarPropriedadesUser',
            timeout: kSyncPageTimeout,
          );
          propertyIds = _safePropertyIds(propriedades?.jsonBody);
        }
        _syncLog(
            'sanidade', 'Propriedades encontradas: ${propertyIds.length}.');

        if (propertyIds.isEmpty) {
          _syncLog(
              'sanidade', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        if (!isFirst) {
          final fullCountResponse = await _withTimeout(
            () => SupabaseFunctionsGroup.qTDSanidadeCall.call(
              pIdsPropriedadesList: propertyIds,
            ),
            label: 'sanidade.qTDSanidade.fullCheck',
            timeout: kSyncPageTimeout,
          );
          final fullRemoteCount = _safeTotalFromApi(fullCountResponse.jsonBody);
          final localCount = await _countLocalRowsForProperties(
            'local_sanidade',
            'id_propriedade',
            propertyIds,
            extraWhere: "AND COALESCE(deletado, 'NAO') != 'SIM'",
          );
          _syncLog('sanidade',
              'Conferência de completude: local=$localCount remoto_completo=$fullRemoteCount.');
          if (_localDataLooksIncomplete(
            localCount: localCount,
            remoteTotal: fullRemoteCount,
          )) {
            isFirst = true;
            updatedAfter = null;
            _syncLog('sanidade',
                'Base local incompleta detectada durante sync. Trocando incremental por COMPLETA.');
          }
        }

        if (updatedAfter != null) {
          qtdSanidades = await _withTimeout(
            () => SupabaseFunctionsGroup.qTDSanidadeIncCall.call(
              pIdsPropriedadesList: propertyIds,
              pUpdatedAfter: updatedAfter,
            ),
            label: 'sanidade.qTDSanidadeInc',
            timeout: kSyncPageTimeout,
          );
        } else {
          qtdSanidades = await _withTimeout(
            () => SupabaseFunctionsGroup.qTDSanidadeCall.call(
              pIdsPropriedadesList: propertyIds,
            ),
            label: 'sanidade.qTDSanidade',
            timeout: kSyncPageTimeout,
          );
        }
        _syncLog(
            'sanidade', 'Resposta qtdSanidades raw: ${qtdSanidades?.jsonBody}');

        final totalSanidades = _safeTotalFromApi(qtdSanidades?.jsonBody);
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
          _syncLog(
              'sanidade', 'Primeiro sync. Iniciando paginação (UPSERT)...');
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
              sanidadesAPI = await _withTimeout(
                () => SupabaseFunctionsGroup.buscarSanidadesIncCall.call(
                  pIdPropriedadeList: propertyIds,
                  pLimite: pageSize,
                  pOffset: offsetAtual,
                  pUpdatedAfter: updatedAfter,
                ),
                label: 'sanidade.buscarSanidadesInc(offset=$offsetAtual)',
                timeout: kSyncPageTimeout,
              );
            } else {
              sanidadesAPI = await _withTimeout(
                () => SupabaseFunctionsGroup.buscarSanidadesCall.call(
                  pIdPropriedadeList: propertyIds,
                  pLimite: pageSize,
                  pOffset: offsetAtual,
                ),
                label: 'sanidade.buscarSanidades(offset=$offsetAtual)',
                timeout: kSyncPageTimeout,
              );
            }

            final pageRecords = _safeRecordsFromApi(sanidadesAPI?.jsonBody);
            _syncLog('sanidade',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('sanidade',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              paginationComplete = false;
              syncErrors.add({
                'id': 'página offset=$offsetAtual',
                'error': 'Página vazia antes de baixar o total esperado',
              });
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
            if (pageRecords.length < pageSize) {
              _syncLog('sanidade',
                  'Última página detectada (tamanho < pageSize=$pageSize). Encerrando paginação.');
              break;
            }
          } on TimeoutException catch (e) {
            _syncLog('sanidade',
                'TIMEOUT em página offset=$offsetAtual: $e. Abortando paginação.');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Timeout na requisição',
            });
            paginationComplete = false;
            break;
          } catch (e, s) {
            _syncLog('sanidade',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            paginationComplete = false;
            break;
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
        if (syncErrors.isEmpty && paginationComplete) {
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
