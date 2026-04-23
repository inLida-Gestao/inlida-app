// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// (none)
// Imports custom functions
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '/backend/sqlite/sqlite_manager.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Auditoria persistente de erros de sincronização.
///
/// Quando um PUT/INSERT/UPDATE no Supabase falha, registra em SQLite
/// (tabela `sync_error_log`) com módulo, registro local, campo
/// problemático inferido e mensagem amigável em PT-BR.
///
/// O usuário pode então visualizar (Perfil → Erros de sincronização),
/// corrigir o registro, descartar ou pedir nova tentativa.
///
/// Quando um registro volta a sincronizar com sucesso, os erros
/// pendentes dele são auto-resolvidos.
class SyncErrorLog {
  SyncErrorLog._();

  static const int _maxRows = 1000;
  static const Duration _purgeAfter = Duration(days: 30);

  /// Registra um novo erro (ou incrementa tentativas se já existe um
  /// erro ativo idêntico para mesmo módulo+registro_id).
  static Future<void> registrar({
    required String modulo,
    required String operacao,
    String? registroId,
    String? registroDescricao,
    required Object erro,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final db = SQLiteManager.instance.database;
      final mensagemBruta = _extractRawMessage(erro);
      final campo = _inferirCampo(mensagemBruta);
      final amigavel = _mensagemAmigavel(mensagemBruta, campo);
      final agora = DateTime.now().toIso8601String();

      // Verifica se há um erro ativo idêntico (mesma operação + mesmo registro)
      final List<Map<String, Object?>> existentes = await db.query(
        'sync_error_log',
        where:
            'modulo = ? AND operacao = ? AND registro_id IS ? AND resolvido = 0',
        whereArgs: [modulo, operacao, registroId],
        limit: 1,
      );

      if (existentes.isNotEmpty) {
        final id = existentes.first['id'] as int;
        await db.update(
          'sync_error_log',
          {
            'mensagem_erro': mensagemBruta,
            'mensagem_amigavel': amigavel,
            'campo_problema': campo,
            'ultima_ocorrencia': agora,
            'tentativas':
                (existentes.first['tentativas'] as int? ?? 1) + 1,
            if (payload != null) 'payload_json': jsonEncode(payload),
            if (registroDescricao != null)
              'registro_descricao': registroDescricao,
          },
          where: 'id = ?',
          whereArgs: [id],
        );
      } else {
        await db.insert('sync_error_log', {
          'modulo': modulo,
          'operacao': operacao,
          'registro_id': registroId,
          'registro_descricao': registroDescricao,
          'campo_problema': campo,
          'mensagem_erro': mensagemBruta,
          'mensagem_amigavel': amigavel,
          'payload_json': payload != null ? jsonEncode(payload) : null,
          'primeira_ocorrencia': agora,
          'ultima_ocorrencia': agora,
          'tentativas': 1,
          'resolvido': 0,
        });
      }
    } catch (e, s) {
      debugPrint('[SyncErrorLog] Falha ao registrar erro: $e\n$s');
    }
  }

  /// Marca como resolvidos todos os erros ATIVOS de um registro específico.
  /// Chamado após um sync bem-sucedido daquele registro.
  static Future<int> autoResolverPorRegistro(
      String modulo, String? registroId) async {
    if (registroId == null || registroId.isEmpty) return 0;
    try {
      final db = SQLiteManager.instance.database;
      final agora = DateTime.now().toIso8601String();
      return await db.update(
        'sync_error_log',
        {'resolvido': 1, 'resolvido_em': agora},
        where: 'modulo = ? AND registro_id = ? AND resolvido = 0',
        whereArgs: [modulo, registroId],
      );
    } catch (e) {
      debugPrint('[SyncErrorLog] Falha ao auto-resolver: $e');
      return 0;
    }
  }

  /// Marca um erro como descartado pelo usuário.
  /// Não remove da fila local automaticamente — o caller decide.
  static Future<void> descartar(int id) async {
    try {
      final db = SQLiteManager.instance.database;
      await db.update(
        'sync_error_log',
        {
          'resolvido': 2,
          'resolvido_em': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('[SyncErrorLog] Falha ao descartar: $e');
    }
  }

  /// Lista erros ativos, opcionalmente filtrando por módulo.
  static Future<List<SyncErrorEntry>> listarAtivos({String? modulo}) async {
    try {
      final db = SQLiteManager.instance.database;
      final rows = await db.query(
        'sync_error_log',
        where: modulo == null ? 'resolvido = 0' : 'resolvido = 0 AND modulo = ?',
        whereArgs: modulo == null ? null : [modulo],
        orderBy: 'ultima_ocorrencia DESC',
        limit: 500,
      );
      return rows.map(SyncErrorEntry.fromRow).toList();
    } catch (e) {
      debugPrint('[SyncErrorLog] Falha ao listar: $e');
      return const [];
    }
  }

  /// Conta erros ativos (para badge no menu).
  static Future<int> countAtivos() async {
    try {
      final db = SQLiteManager.instance.database;
      final r = await db.rawQuery(
          'SELECT COUNT(*) AS c FROM sync_error_log WHERE resolvido = 0');
      return (r.first['c'] as int?) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Limpa erros resolvidos com mais de 30 dias e mantém limite de 1000.
  static Future<void> purgar() async {
    try {
      final db = SQLiteManager.instance.database;
      final corte =
          DateTime.now().subtract(_purgeAfter).toIso8601String();
      await db.delete(
        'sync_error_log',
        where: 'resolvido != 0 AND resolvido_em < ?',
        whereArgs: [corte],
      );
      // Mantém apenas os _maxRows mais recentes (qualquer status).
      await db.execute('''
        DELETE FROM sync_error_log
        WHERE id NOT IN (
          SELECT id FROM sync_error_log
          ORDER BY ultima_ocorrencia DESC LIMIT $_maxRows
        )
      ''');
    } catch (e) {
      debugPrint('[SyncErrorLog] Falha ao purgar: $e');
    }
  }

  // ============================================================
  // Inferência de campo + mensagens amigáveis
  // ============================================================

  static String _extractRawMessage(Object erro) {
    final s = erro.toString();
    // PostgrestException.toString() já inclui mensagem útil.
    // Trunca pra evitar payload absurdo.
    return s.length > 1000 ? s.substring(0, 1000) : s;
  }

  static final List<RegExp> _campoPatterns = [
    RegExp(r'null value in column "([^"]+)"'),
    RegExp(r'column "([^"]+)" .* not-null'),
    RegExp(r'Key \(([a-zA-Z0-9_]+)\)='),
    RegExp(r'column "([^"]+)" of relation'),
    RegExp(r'value too long for type .* in column "([^"]+)"'),
    RegExp(r'invalid input .* column "([^"]+)"'),
    RegExp(r'duplicate key value .* \(([a-zA-Z0-9_]+)\)='),
  ];

  static String? _inferirCampo(String mensagem) {
    for (final p in _campoPatterns) {
      final m = p.firstMatch(mensagem);
      if (m != null) return m.group(1);
    }
    return null;
  }

  /// Dicionário PT-BR de nomes técnicos → rótulos amigáveis.
  static final Map<String, String> _campoLabels = {
    'id_lote': 'Lote',
    'id_propriedade': 'Propriedade',
    'id_rebanho': 'Animal',
    'idRebanho': 'Animal',
    'idPropriedade': 'Propriedade',
    'id_reproducao': 'Identificador da reprodução',
    'id_sanidade': 'Identificador da sanidade',
    'id_pai': 'Pai',
    'id_mae': 'Mãe',
    'data_inseminacao': 'Data da inseminação',
    'data_parto': 'Data do parto',
    'data_morte': 'Data de morte',
    'data_evento': 'Data do evento',
    'dataPesagem': 'Data da pesagem',
    'data_aplicacao': 'Data de aplicação',
    'numero_animal': 'Número do animal',
    'numeroAnimal': 'Número do animal',
    'nome': 'Nome',
    'peso': 'Peso',
    'sexo': 'Sexo',
    'categoria': 'Categoria',
    'raca': 'Raça',
    'tipo': 'Tipo',
    'movimentacao_saida': 'Data de saída',
    'tipo_inseminacao': 'Tipo de inseminação',
    'protocolo': 'Protocolo',
  };

  static String labelCampo(String? raw) {
    if (raw == null) return '—';
    return _campoLabels[raw] ?? raw;
  }

  /// Traduz uma mensagem técnica do Postgres para algo legível ao usuário.
  static String _mensagemAmigavel(String bruta, String? campo) {
    final label = labelCampo(campo);

    if (RegExp(r'null value in column').hasMatch(bruta) ||
        RegExp(r'not-null').hasMatch(bruta)) {
      return campo == null
          ? 'Um campo obrigatório está em branco.'
          : 'O campo "$label" está em branco e é obrigatório.';
    }
    if (RegExp(r'foreign key constraint').hasMatch(bruta)) {
      return campo == null
          ? 'Há uma referência inválida (item vinculado não existe).'
          : 'O "$label" informado não existe ou foi removido.';
    }
    if (RegExp(r'duplicate key value').hasMatch(bruta)) {
      return campo == null
          ? 'Registro duplicado.'
          : 'Já existe um registro com este "$label".';
    }
    if (RegExp(r'value too long').hasMatch(bruta)) {
      return campo == null
          ? 'Valor muito longo para o campo.'
          : 'O valor do campo "$label" é muito longo.';
    }
    if (RegExp(r'invalid input syntax').hasMatch(bruta)) {
      return campo == null
          ? 'Formato inválido.'
          : 'O campo "$label" está em formato inválido.';
    }
    if (RegExp(r'check constraint').hasMatch(bruta)) {
      return 'Valor não atende a uma regra do servidor.';
    }
    if (RegExp(r'permission denied|RLS|row-level security')
        .hasMatch(bruta)) {
      return 'Sem permissão para gravar este registro.';
    }
    if (RegExp(r'TimeoutException|deadline').hasMatch(bruta)) {
      return 'O servidor demorou demais para responder.';
    }
    if (RegExp(r'SocketException|Network|Failed host lookup')
        .hasMatch(bruta)) {
      return 'Falha de conexão durante o envio.';
    }
    return 'Erro ao enviar para o servidor.';
  }
}

class SyncErrorEntry {
  final int id;
  final String modulo;
  final String operacao;
  final String? registroId;
  final String? registroDescricao;
  final String? campoProblema;
  final String mensagemErro;
  final String? mensagemAmigavel;
  final String? payloadJson;
  final DateTime primeiraOcorrencia;
  final DateTime ultimaOcorrencia;
  final int tentativas;
  final int resolvido;

  const SyncErrorEntry({
    required this.id,
    required this.modulo,
    required this.operacao,
    required this.registroId,
    required this.registroDescricao,
    required this.campoProblema,
    required this.mensagemErro,
    required this.mensagemAmigavel,
    required this.payloadJson,
    required this.primeiraOcorrencia,
    required this.ultimaOcorrencia,
    required this.tentativas,
    required this.resolvido,
  });

  factory SyncErrorEntry.fromRow(Map<String, Object?> r) => SyncErrorEntry(
        id: r['id'] as int,
        modulo: (r['modulo'] as String?) ?? '',
        operacao: (r['operacao'] as String?) ?? '',
        registroId: r['registro_id'] as String?,
        registroDescricao: r['registro_descricao'] as String?,
        campoProblema: r['campo_problema'] as String?,
        mensagemErro: (r['mensagem_erro'] as String?) ?? '',
        mensagemAmigavel: r['mensagem_amigavel'] as String?,
        payloadJson: r['payload_json'] as String?,
        primeiraOcorrencia: DateTime.tryParse(
                (r['primeira_ocorrencia'] as String?) ?? '') ??
            DateTime.now(),
        ultimaOcorrencia:
            DateTime.tryParse((r['ultima_ocorrencia'] as String?) ?? '') ??
                DateTime.now(),
        tentativas: (r['tentativas'] as int?) ?? 1,
        resolvido: (r['resolvido'] as int?) ?? 0,
      );

  String get campoLabel => SyncErrorLog.labelCampo(campoProblema);
}
