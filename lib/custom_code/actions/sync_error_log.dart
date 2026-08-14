// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// (none)
// Imports custom functions
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart' show PostgrestException;
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
      final classificacao = classificarErro(erro, mensagemBruta);
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
            'mensagem_amigavel': classificacao.titulo,
            'campo_problema': classificacao.campoProblema,
            'codigo': classificacao.codigo,
            'causa_provavel': classificacao.causaProvavel,
            'acao_sugerida': classificacao.acaoSugerida,
            'ultima_ocorrencia': agora,
            'tentativas': (existentes.first['tentativas'] as int? ?? 1) + 1,
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
          'campo_problema': classificacao.campoProblema,
          'mensagem_erro': mensagemBruta,
          'mensagem_amigavel': classificacao.titulo,
          'codigo': classificacao.codigo,
          'causa_provavel': classificacao.causaProvavel,
          'acao_sugerida': classificacao.acaoSugerida,
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

  /// Marca como resolvidos todos os erros ativos de um módulo.
  ///
  /// Usado quando o sync do módulo conclui sem pendências/falhas, para remover
  /// erros históricos que ficaram na tela depois de uma correção de sync.
  static Future<int> autoResolverModulo(String modulo) async {
    if (modulo.trim().isEmpty) return 0;
    try {
      final db = SQLiteManager.instance.database;
      final agora = DateTime.now().toIso8601String();
      return await db.update(
        'sync_error_log',
        {'resolvido': 1, 'resolvido_em': agora},
        where: 'modulo = ? AND resolvido = 0',
        whereArgs: [modulo],
      );
    } catch (e) {
      debugPrint('[SyncErrorLog] Falha ao auto-resolver módulo: $e');
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
        where:
            modulo == null ? 'resolvido = 0' : 'resolvido = 0 AND modulo = ?',
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
      final corte = DateTime.now().subtract(_purgeAfter).toIso8601String();
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
  // Classificação de erros: código + causa provável + ação sugerida
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

  /// Classifica um erro de sincronização em um código estável +
  /// explicação em PT-BR para o usuário leigo + ação sugerida.
  ///
  /// Prioriza o `code` do `PostgrestException` (estável, não depende de
  /// texto que pode mudar entre versões do Postgres); cai para regex na
  /// mensagem bruta quando o erro não é um PostgrestException (timeouts,
  /// erros de rede, exceções internas do sync engine como stale conflict).
  static SyncErrorClassification classificarErro(Object erro, String bruta) {
    final campo = _inferirCampo(bruta);
    final label = labelCampo(campo);

    // Exceções internas do sync engine (tipos privados de lib/actions/actions.dart,
    // não visíveis aqui — identificadas pelo texto estável do toString()).
    if (bruta.contains('stale recusado') ||
        bruta.contains('STALE_REBANHO_UPDATE')) {
      return const SyncErrorClassification(
        codigo: 'STALE_CONFLICT',
        titulo: 'Conflito com uma edição mais recente',
        causaProvavel:
            'Este registro foi alterado em outro dispositivo (ou pelo servidor) depois da sua última edição local.',
        acaoSugerida:
            'Abra o registro, confira os dados atuais e edite novamente para reenviar.',
      );
    }
    if (bruta.contains('não afetou nenhuma linha')) {
      return SyncErrorClassification(
        codigo: 'RLS_DENIED',
        titulo: 'Sem permissão para gravar este registro',
        causaProvavel:
            'Sua conta pode não ter mais acesso a esta propriedade, ou o registro foi removido por outro usuário.',
        acaoSugerida:
            'Verifique se você ainda tem acesso à propriedade. Se deveria ter acesso, contate o suporte.',
        campoProblema: campo,
      );
    }

    final code = erro is PostgrestException ? erro.code : null;
    switch (code) {
      case '23502': // not_null_violation
        return SyncErrorClassification(
          codigo: 'CAMPO_OBRIGATORIO',
          titulo: 'Campo obrigatório em branco',
          causaProvavel: campo == null
              ? 'Um campo obrigatório deste registro não foi preenchido.'
              : 'O campo "$label" está em branco e é obrigatório.',
          acaoSugerida: 'Edite o registro, preencha "$label" e salve novamente.',
          campoProblema: campo,
        );
      case '23503': // foreign_key_violation
        return SyncErrorClassification(
          codigo: 'FK_MISSING',
          titulo: 'Referência a um item que não existe',
          causaProvavel: campo == null
              ? 'Este registro referencia outro item (ex.: lote, animal) que não existe mais no servidor.'
              : 'O "$label" informado não existe (ou foi removido) no servidor.',
          acaoSugerida:
              'Edite o registro e selecione novamente o "$label" antes de sincronizar.',
          campoProblema: campo,
        );
      case '23505': // unique_violation
        return SyncErrorClassification(
          codigo: 'DUPLICADO',
          titulo: 'Registro duplicado',
          causaProvavel: campo == null
              ? 'Já existe um registro igual a este no servidor.'
              : 'Já existe um registro com o mesmo "$label".',
          acaoSugerida:
              'Verifique se este registro já foi cadastrado em outro dispositivo antes de reenviar.',
          campoProblema: campo,
        );
      case '23514': // check_violation
        return const SyncErrorClassification(
          codigo: 'REGRA_SERVIDOR',
          titulo: 'Valor não permitido pelo servidor',
          causaProvavel:
              'Um valor deste registro não passa em uma validação do servidor (ex.: data ou status incompatível).',
          acaoSugerida:
              'Revise as datas e o status do registro e salve novamente.',
        );
      case '22007':
      case '22008':
      case '22P02':
        return SyncErrorClassification(
          codigo: 'FORMATO_INVALIDO',
          titulo: 'Formato de dado inválido',
          causaProvavel: campo == null
              ? 'Um valor deste registro está em um formato que o servidor não aceita.'
              : 'O campo "$label" está em um formato que o servidor não aceita.',
          acaoSugerida: 'Edite o registro e corrija o valor de "$label".',
          campoProblema: campo,
        );
      case '42501':
        return const SyncErrorClassification(
          codigo: 'RLS_DENIED',
          titulo: 'Sem permissão para gravar este registro',
          causaProvavel:
              'Sua conta não tem permissão para alterar este registro nesta propriedade.',
          acaoSugerida:
              'Verifique seu vínculo com a propriedade. Se deveria ter acesso, contate o suporte.',
        );
      case '55006':
        return const SyncErrorClassification(
          codigo: 'STALE_CONFLICT',
          titulo: 'Conflito com uma edição mais recente',
          causaProvavel:
              'Este registro foi alterado em outro dispositivo (ou pelo servidor) depois da sua última edição local.',
          acaoSugerida:
              'Abra o registro, confira os dados atuais e edite novamente para reenviar.',
        );
      case 'PGRST301':
        return const SyncErrorClassification(
          codigo: 'SESSAO_EXPIRADA',
          titulo: 'Sessão expirada',
          causaProvavel: 'Seu login expirou e o servidor recusou a operação.',
          acaoSugerida:
              'Saia e entre novamente no aplicativo, depois sincronize outra vez.',
        );
    }

    if (RegExp(r'permission denied|row-level security|\bRLS\b').hasMatch(bruta)) {
      return const SyncErrorClassification(
        codigo: 'RLS_DENIED',
        titulo: 'Sem permissão para gravar este registro',
        causaProvavel:
            'Sua conta não tem permissão para alterar este registro nesta propriedade.',
        acaoSugerida:
            'Verifique seu vínculo com a propriedade. Se deveria ter acesso, contate o suporte.',
      );
    }
    if (RegExp(r'TimeoutException|deadline|timed out|Read timed out')
        .hasMatch(bruta)) {
      return const SyncErrorClassification(
        codigo: 'TIMEOUT',
        titulo: 'O servidor demorou para responder',
        causaProvavel:
            'A conexão ficou lenta ou o servidor demorou demais para concluir a operação.',
        acaoSugerida:
            'Tente sincronizar novamente com uma conexão melhor. Se persistir, contate o suporte.',
      );
    }
    if (RegExp(
            r'SocketException|Network|Failed host lookup|HandshakeException|TLS handshake|ClientException|Connection closed|Connection reset|Connection refused|Broken pipe|HttpException|os error|errno = (?:50|51|52|53|54|60|61|65|101)')
        .hasMatch(bruta)) {
      return const SyncErrorClassification(
        codigo: 'SEM_CONEXAO',
        titulo: 'Falha de conexão durante o envio',
        causaProvavel: 'O dispositivo perdeu a conexão com a internet durante o envio.',
        acaoSugerida: 'Verifique sua internet/Wi-Fi e sincronize novamente.',
      );
    }

    // Fallback por regex na mensagem bruta (erros sem PostgrestException,
    // ex.: repassados como String simples).
    if (RegExp(r'null value in column').hasMatch(bruta) ||
        RegExp(r'not-null').hasMatch(bruta)) {
      return SyncErrorClassification(
        codigo: 'CAMPO_OBRIGATORIO',
        titulo: 'Campo obrigatório em branco',
        causaProvavel: campo == null
            ? 'Um campo obrigatório deste registro não foi preenchido.'
            : 'O campo "$label" está em branco e é obrigatório.',
        acaoSugerida: 'Edite o registro, preencha "$label" e salve novamente.',
        campoProblema: campo,
      );
    }
    if (RegExp(r'foreign key constraint').hasMatch(bruta)) {
      return SyncErrorClassification(
        codigo: 'FK_MISSING',
        titulo: 'Referência a um item que não existe',
        causaProvavel: campo == null
            ? 'Este registro referencia outro item que não existe mais no servidor.'
            : 'O "$label" informado não existe (ou foi removido) no servidor.',
        acaoSugerida:
            'Edite o registro e selecione novamente o "$label" antes de sincronizar.',
        campoProblema: campo,
      );
    }
    if (RegExp(r'duplicate key value').hasMatch(bruta)) {
      return SyncErrorClassification(
        codigo: 'DUPLICADO',
        titulo: 'Registro duplicado',
        causaProvavel: campo == null
            ? 'Já existe um registro igual a este no servidor.'
            : 'Já existe um registro com o mesmo "$label".',
        acaoSugerida:
            'Verifique se este registro já foi cadastrado em outro dispositivo antes de reenviar.',
        campoProblema: campo,
      );
    }
    if (RegExp(r'value too long|invalid input syntax').hasMatch(bruta)) {
      return SyncErrorClassification(
        codigo: 'FORMATO_INVALIDO',
        titulo: 'Formato de dado inválido',
        causaProvavel: campo == null
            ? 'Um valor deste registro está em um formato que o servidor não aceita.'
            : 'O campo "$label" está em um formato que o servidor não aceita.',
        acaoSugerida: 'Edite o registro e corrija o valor de "$label".',
        campoProblema: campo,
      );
    }
    if (RegExp(r'check constraint').hasMatch(bruta)) {
      return const SyncErrorClassification(
        codigo: 'REGRA_SERVIDOR',
        titulo: 'Valor não permitido pelo servidor',
        causaProvavel:
            'Um valor deste registro não passa em uma validação do servidor.',
        acaoSugerida: 'Revise os campos do registro e salve novamente.',
      );
    }

    return SyncErrorClassification(
      codigo: 'DESCONHECIDO',
      titulo: 'Erro ao enviar para o servidor',
      causaProvavel:
          'Não foi possível identificar automaticamente a causa deste erro.',
      acaoSugerida:
          'Tente sincronizar novamente. Se persistir, abra os detalhes técnicos e envie ao suporte.',
      campoProblema: campo,
    );
  }
}

/// Resultado da classificação de um erro de sync: código estável +
/// explicação/ação em PT-BR para o usuário leigo.
class SyncErrorClassification {
  const SyncErrorClassification({
    required this.codigo,
    required this.titulo,
    required this.causaProvavel,
    required this.acaoSugerida,
    this.campoProblema,
  });

  final String codigo;
  final String titulo;
  final String causaProvavel;
  final String acaoSugerida;
  final String? campoProblema;
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
  final String? codigo;
  final String? causaProvavel;
  final String? acaoSugerida;

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
    this.codigo,
    this.causaProvavel,
    this.acaoSugerida,
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
        primeiraOcorrencia:
            DateTime.tryParse((r['primeira_ocorrencia'] as String?) ?? '') ??
                DateTime.now(),
        ultimaOcorrencia:
            DateTime.tryParse((r['ultima_ocorrencia'] as String?) ?? '') ??
                DateTime.now(),
        tentativas: (r['tentativas'] as int?) ?? 1,
        resolvido: (r['resolvido'] as int?) ?? 0,
        codigo: r['codigo'] as String?,
        causaProvavel: r['causa_provavel'] as String?,
        acaoSugerida: r['acao_sugerida'] as String?,
      );

  String get campoLabel => SyncErrorLog.labelCampo(campoProblema);

  /// Título curto para exibição — usa a classificação nova quando disponível
  /// e cai para a mensagem amigável legada (registros antigos, pré-migração).
  String get tituloExibicao =>
      mensagemAmigavel ?? 'Erro ao enviar para o servidor.';
}

