import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

bool _hasPendingLocalSync(SharedPreferences prefs) {
  const pendingSyncKeys = <String>[
    'ff_dataDadosNaoSyncProp',
    'ff_dataDadosNaoSyncRebanho',
    'ff_dataDadosNaoSyncLotes',
    'ff_dataDadosNaoSyncRepro',
    'ff_dataDadosNaoSyncSanidade',
  ];

  for (final key in pendingSyncKeys) {
    if (prefs.containsKey(key)) {
      return true;
    }
  }
  return false;
}

Future<Database> initializeDatabaseFromDbFile(
  String databaseName,
  String databaseAssetFilename,
) async {
  final databasesPath = await getDatabasesPath();
  final path = '$databaseName.db';
  final databasePath = join(databasesPath, path);

  // Extrair versão do nome do asset (ex: "inlida_v48.db" → 48)
  final versionMatch =
      RegExp(r'_v(\d+)\.db$').firstMatch(databaseAssetFilename);
  final int expectedVersion =
      versionMatch != null ? int.parse(versionMatch.group(1)!) : 0;

  final prefs = await SharedPreferences.getInstance();
  final String prefsKey = 'sqlite_db_version_$databaseName';
  final int installedVersion = prefs.getInt(prefsKey) ?? 0;
  final bool hasPendingLocalSync = _hasPendingLocalSync(prefs);

  final exists = await databaseExists(databasePath);

  // Forçar recriação se a versão do asset mudou
  bool needsRecreation =
      !exists || (expectedVersion > 0 && installedVersion != expectedVersion);

  if (exists && needsRecreation && hasPendingLocalSync) {
    debugPrint(
        '[SQLite] Atualização do banco adiada por pendências locais de sync. '
        'versãoInstalada=$installedVersion, versãoEsperada=$expectedVersion');
    needsRecreation = false;
  }

  if (needsRecreation) {
    debugPrint('[SQLite] DB "$databaseName" precisa ser recriado. '
        'existe=$exists, versãoInstalada=$installedVersion, versãoEsperada=$expectedVersion');

    // Fechar qualquer conexão existente e deletar o banco antigo
    if (exists) {
      try {
        await deleteDatabase(databasePath);
        debugPrint('[SQLite] Banco antigo deletado com sucesso.');
      } catch (e) {
        debugPrint('[SQLite] Erro ao deletar banco antigo: $e');
        // Tentar deletar o arquivo diretamente
        try {
          final dbFile = File(databasePath);
          if (await dbFile.exists()) {
            await dbFile.delete();
          }
          // Também deletar arquivos WAL e SHM se existirem
          final walFile = File('$databasePath-wal');
          if (await walFile.exists()) await walFile.delete();
          final shmFile = File('$databasePath-shm');
          if (await shmFile.exists()) await shmFile.delete();
        } catch (e2) {
          debugPrint('[SQLite] Erro ao deletar arquivos do banco: $e2');
        }
      }
    }

    // Garantir que o diretório pai existe
    try {
      await Directory(dirname(databasePath)).create(recursive: true);
    } catch (_) {}

    // Copiar o banco do asset
    final databaseData = await rootBundle
        .load(join('assets', 'sqlite_db_files', databaseAssetFilename));
    final databaseBytes = databaseData.buffer.asUint8List(
      databaseData.offsetInBytes,
      databaseData.lengthInBytes,
    );
    await File(databasePath).writeAsBytes(databaseBytes, flush: true);

    // Salvar a versão instalada
    await prefs.setInt(prefsKey, expectedVersion);
    debugPrint(
        '[SQLite] Banco "$databaseName" v$expectedVersion instalado com sucesso.');
  } else {
    debugPrint(
        '[SQLite] Banco "$databaseName" v$installedVersion já está atualizado.');
  }

  // Abrir o banco de dados
  final database = await openDatabase(databasePath);

  // Validar compatibilidade FTS5 (Android não tem FTS5 no SQLite do sistema)
  await _ensureFts5Compatibility(database);

  // Criar índices para otimizar buscas no rebanho popup
  await _ensureRebanhoIndexes(database);

  // Criar índices UNIQUE para suportar UPSERT incremental
  await _ensureUniqueBusinessKeys(database);

  // Criar tabela de auditoria de erros de sincronização
  await _ensureSyncErrorLogTable(database);

  // Limpar duplicatas históricas de Nascimento/Desmama
  await _dedupePesagensFixas(database, prefs, expectedVersion);

  // Limpar duplicatas de animais (mesmo numeroAnimal/dataNascimento) causadas
  // por duplo-clique no botão Salvar antes do fix v1.8.4+109.
  // É CONSERVADOR: só funde quando todos os campos críticos batem.
  await _dedupRebanhoDuplicados(database, prefs);

  return database;
}

/// Verifica se FTS5 é suportado pelo SQLite do sistema.
/// No Android, o SQLite embutido normalmente NÃO inclui FTS5,
/// o que causa falha nos triggers de INSERT/DELETE/UPDATE da tabela local_rebanho.
/// Se FTS5 não estiver disponível, os triggers são removidos para evitar erros.
Future<void> _ensureFts5Compatibility(Database db) async {
  try {
    // Testar se FTS5 está funcional tentando uma query na tabela virtual
    await db.rawQuery('SELECT * FROM local_rebanho_fts LIMIT 1');
    debugPrint('[SQLite] FTS5 suportado. Triggers mantidos.');
  } catch (e) {
    debugPrint(
        '[SQLite] FTS5 NÃO suportado neste dispositivo ($e). Removendo triggers FTS...');
    // Dropar triggers que dependem de FTS5 para evitar falha nos INSERTs
    final triggers = [
      'rebanho_fts_insert',
      'rebanho_fts_delete',
      'rebanho_fts_update',
    ];
    for (final trigger in triggers) {
      try {
        await db.execute('DROP TRIGGER IF EXISTS $trigger');
        debugPrint('[SQLite] Trigger "$trigger" removido.');
      } catch (e2) {
        debugPrint('[SQLite] Erro ao remover trigger "$trigger": $e2');
      }
    }
    // Tentar dropar a tabela virtual FTS5 (não é crítico se falhar)
    try {
      await db.execute('DROP TABLE IF EXISTS local_rebanho_fts');
      debugPrint('[SQLite] Tabela FTS5 "local_rebanho_fts" removida.');
    } catch (e3) {
      debugPrint('[SQLite] Não foi possível remover tabela FTS5: $e3');
    }
  }
}

/// Cria índices compostos na tabela local_rebanho para acelerar
/// buscas no popup de seleção de animais (LIKE em numeroAnimal, nome, chip).
/// Usa CREATE INDEX IF NOT EXISTS para ser idempotente.
Future<void> _ensureRebanhoIndexes(Database db) async {
  const indexes = <String>[
    // Índice composto principal para a busca do popup
    '''CREATE INDEX IF NOT EXISTS idx_rebanho_prop_deletado
       ON local_rebanho (idPropriedade, deletado)''',
    // Índice para busca por numeroAnimal (LIKE prefix)
    '''CREATE INDEX IF NOT EXISTS idx_rebanho_numero_animal
       ON local_rebanho (idPropriedade, deletado, numeroAnimal)''',
    // Índice para busca por nome (LIKE prefix)
    '''CREATE INDEX IF NOT EXISTS idx_rebanho_nome
       ON local_rebanho (idPropriedade, deletado, nome)''',
    // Índice para busca por chip
    '''CREATE INDEX IF NOT EXISTS idx_rebanho_chip
       ON local_rebanho (idPropriedade, deletado, chip)''',
    // Índice para filtros por sexo e status
    '''CREATE INDEX IF NOT EXISTS idx_rebanho_sexo_status
       ON local_rebanho (idPropriedade, deletado, sexo, statusRebanho, categoria)''',
  ];

  for (final indexSql in indexes) {
    try {
      await db.execute(indexSql);
    } catch (e) {
      debugPrint('[SQLite] Erro ao criar índice: $e');
    }
  }
  debugPrint('[SQLite] Índices de busca do rebanho verificados/criados.');
}

/// Cria índices UNIQUE nas colunas de chave de negócio para que
/// ConflictAlgorithm.replace funcione como UPSERT na sync incremental.
Future<void> _ensureUniqueBusinessKeys(Database db) async {
  const indexes = <String>[
    '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_propriedade
       ON local_propriedades (idPropriedade)''',
    '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_rebanho
       ON local_rebanho (idRebanho)''',
    '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_lote
       ON local_lotes (id_lote)''',
    '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_reproducao
       ON local_reproducao (id_reproducao)''',
    '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_sanidade
       ON local_sanidade (id_sanidade)''',
    '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_pesagem
       ON local_historico_pesagens (idRebanho, dataPesagem, tipo, created_at)''',
  ];

  // Dropar índice antigo de pesagem (sem created_at) se existir,
  // para permitir múltiplas pesagens no mesmo dia.
  try {
    // Verifica se o índice antigo existe e se tem apenas 3 colunas
    final idxInfo = await db.rawQuery("PRAGMA index_info(idx_unique_pesagem)");
    if (idxInfo.isNotEmpty && idxInfo.length <= 3) {
      await db.execute('DROP INDEX IF EXISTS idx_unique_pesagem');
      debugPrint(
          '[SQLite] Índice antigo idx_unique_pesagem (3 cols) removido.');
    }
  } catch (e) {
    debugPrint('[SQLite] Erro ao verificar/dropar índice antigo: $e');
  }

  for (final indexSql in indexes) {
    try {
      await db.execute(indexSql);
    } catch (e) {
      debugPrint('[SQLite] Erro ao criar índice UNIQUE: $e');
    }
  }
  debugPrint('[SQLite] Índices UNIQUE de negócio verificados/criados.');
}

/// Garante a existência da tabela `sync_error_log` que persiste falhas de
/// sincronização (registro + campo problemático + mensagem PG bruta).
/// Idempotente — usa CREATE IF NOT EXISTS.
Future<void> _ensureSyncErrorLogTable(Database db) async {
  const ddl = <String>[
    '''CREATE TABLE IF NOT EXISTS sync_error_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        modulo TEXT NOT NULL,
        operacao TEXT NOT NULL,
        registro_id TEXT,
        registro_descricao TEXT,
        campo_problema TEXT,
        mensagem_erro TEXT NOT NULL,
        mensagem_amigavel TEXT,
        payload_json TEXT,
        primeira_ocorrencia TEXT NOT NULL,
        ultima_ocorrencia TEXT NOT NULL,
        tentativas INTEGER NOT NULL DEFAULT 1,
        resolvido INTEGER NOT NULL DEFAULT 0,
        resolvido_em TEXT
      )''',
    '''CREATE INDEX IF NOT EXISTS idx_sync_error_modulo
       ON sync_error_log (modulo, resolvido)''',
    '''CREATE INDEX IF NOT EXISTS idx_sync_error_registro
       ON sync_error_log (modulo, registro_id, resolvido)''',
    '''CREATE INDEX IF NOT EXISTS idx_sync_error_ativo
       ON sync_error_log (resolvido, ultima_ocorrencia)''',
  ];

  for (final stmt in ddl) {
    try {
      await db.execute(stmt);
    } catch (e) {
      debugPrint('[SQLite] Erro ao criar sync_error_log: $e');
    }
  }
  debugPrint('[SQLite] Tabela sync_error_log verificada/criada.');
}

/// Limpa duplicatas históricas de pesagens "Nascimento" e "Desmama".
///
/// Para cada (idRebanho, tipo) onde existe mais de um registro ativo
/// (deletado='NAO'), mantém apenas o de MAIOR id (mais recente) e marca
/// os demais como deletado='SIM'. Eles entrarão na fila de UPDATE da
/// próxima sync e o Supabase também receberá o soft-delete.
///
/// Idempotente — se não há duplicatas, não faz nada.
Future<void> _dedupePesagensFixas(
  Database db,
  SharedPreferences prefs,
  int databaseVersion,
) async {
  final prefsKey = 'sqlite_dedupe_pesagens_fixas_v1_$databaseVersion';
  if (prefs.getBool(prefsKey) ?? false) {
    return;
  }

  try {
    await db.execute('''CREATE INDEX IF NOT EXISTS idx_pesagens_dedupe_fixas
       ON local_historico_pesagens (deletado, tipo, idRebanho)''');

    const sql = '''
      UPDATE local_historico_pesagens
      SET deletado = 'SIM'
      WHERE deletado = 'NAO'
        AND tipo IN ('Nascimento', 'Desmama')
        AND rowid NOT IN (
          SELECT MAX(rowid)
          FROM local_historico_pesagens
          WHERE deletado = 'NAO'
            AND tipo IN ('Nascimento', 'Desmama')
          GROUP BY idRebanho, tipo
      )
    ''';
    final n = await db.rawUpdate(sql);
    await prefs.setBool(prefsKey, true);
    if (n > 0) {
      debugPrint('[SQLite] $n pesagem(ns) duplicada(s) Nascimento/Desmama '
          'marcada(s) como deletada(s).');
    }
  } catch (e) {
    debugPrint('[SQLite] Erro ao deduplicar pesagens fixas: $e');
  }
}

// ============================================================================
// Deduplicação SEGURA de animais duplicados (causados por duplo-clique
// antes do fix em v1.8.4+109).
//
// PRINCÍPIOS DE SEGURANÇA:
// 1. Só considera duplicatas quando TODOS os campos-chave batem
//    (idPropriedade + numeroAnimal + dataNascimento + sexo).
// 2. Antes de fundir, compara TODOS os campos críticos. Se houver QUALQUER
//    divergência (ambos não vazios e diferentes), o grupo é deixado
//    intocado e logado para revisão manual.
// 3. Os dados do duplicado são MERGED para o canônico (campos vazios
//    no canônico recebem valores não-vazios do duplicado) — garantia de
//    NÃO PERDER nenhuma informação.
// 4. Todas as referências (pesagens, sanidade, reprodução, lotes,
//    auto-refs matriz/reprodutor) são re-vinculadas para o canônico.
// 5. O duplicado é marcado deletado='SIM' (soft delete) e updated_at é
//    atualizado, fazendo com que a próxima sync envie esse delete ao
//    Supabase — evitando que o duplicado fique no servidor.
// 6. Idempotente — controlada por flag em prefs. Roda 1x por instalação.
// ============================================================================
// DEDUPLICAÇÃO SEGURA DE ANIMAIS (rebanho) — v2
// ============================================================================
// Limpa duplicatas geradas pelo bug de duplo-clique anterior a v1.8.4+109.
//
// Garantias de segurança ("FORMA ALGUMA perder dados"):
//
// 1. Detecta candidatos por (idPropriedade, numeroAnimal, dataNascimento, sexo).
// 2. EQUIVALÊNCIA TOTAL: compara TODOS os campos de negócio entre TODAS as
//    linhas do grupo (não só canonical vs cada dup). Se qualquer campo
//    apresenta MAIS DE UM VALOR não-vazio distinto entre as linhas, o grupo
//    é completamente IGNORADO. Sem merge.
// 3. Canônico = mais recente (updated_at/created_at DESC).
// 4. Pesagens são RE-INSERIDAS no canônico (com novo created_at) para que
//    a sync envie o INSERT ao Supabase — depois a antiga é soft-deleted.
//    (A tabela local_historico_pesagens só sincroniza INSERT por created_at
//    e UPDATE quando deletado='SIM'; mudar idRebanho via UPDATE não subiria.)
// 5. Sanidade, reprodução, auto-refs e JSON de lotes são re-vinculados via
//    UPDATE com updated_at = nowIso (essas tabelas têm UPDT por updated_at).
// 6. Markers de sync (ff_dataDadosNaoSync*) são gravados ANTES das mutações,
//    com janela de segurança (now - 5min), garantindo que linhas alteradas
//    fiquem dentro do filtro updated_at >= marker da próxima sync.
// 7. Cada grupo é uma transação ATÔMICA isolada. Falha em um grupo não
//    afeta os outros. Erros por grupo são contados; flag de "concluído" só
//    é gravada se zero erros.
// 8. JSON de id_animais em lotes é manipulado via jsonDecode/encode real.
// 9. Idempotente — controlada por flag prefs. Roda 1x por instalação.
// ============================================================================
Future<void> _dedupRebanhoDuplicados(
  Database db,
  SharedPreferences prefs,
) async {
  const prefsKey = 'sqlite_dedup_rebanho_duplicados_v2';
  if (prefs.getBool(prefsKey) ?? false) return;

  // Campos que IDENTIFICAM o registro / não comparamos.
  const ignoreFields = <String>{
    'id',
    'idRebanho',
    'created_at',
    'updated_at',
    'deletado',
  };

  final report = <String, int>{
    'gruposDetectados': 0,
    'fundidos': 0,
    'conflitos': 0,
    'erros': 0,
    'pesagensReinseridas': 0,
    'pesagensSoftDelete': 0,
    'sanidadeReatribuidos': 0,
    'reproducaoReatribuidos': 0,
    'lotesAtualizados': 0,
    'autoRefsAtualizadas': 0,
  };

  List<Map<String, Object?>> groups;
  try {
    groups = await db.rawQuery('''
      SELECT idPropriedade, numeroAnimal,
             COALESCE(dataNascimento, '') AS dn,
             COALESCE(sexo, '') AS sx,
             COUNT(*) AS qtd
      FROM local_rebanho
      WHERE COALESCE(deletado, 'NAO') != 'SIM'
        AND COALESCE(idPropriedade, '') != ''
        AND COALESCE(numeroAnimal, '') != ''
      GROUP BY idPropriedade, numeroAnimal,
               COALESCE(dataNascimento, ''),
               COALESCE(sexo, '')
      HAVING COUNT(*) > 1
    ''');
  } catch (e, s) {
    debugPrint('[SQLite][dedupRebanho] erro ao detectar grupos: $e\n$s');
    return; // não marca flag
  }

  if (groups.isEmpty) {
    await prefs.setBool(prefsKey, true);
    debugPrint('[SQLite][dedupRebanho] nenhuma duplicata.');
    return;
  }

  report['gruposDetectados'] = groups.length;
  debugPrint('[SQLite][dedupRebanho] ${groups.length} grupo(s) candidato(s).');

  // CRÍTICO: gravar marker de sync ANTES das mutações, com janela de
  // segurança de 5 min, para que TODAS as linhas alteradas com nowIso fiquem
  // dentro do filtro updated_at >= marker no próximo sync.
  final agoraMs = DateTime.now().millisecondsSinceEpoch;
  final markerMs = agoraMs - 5 * 60 * 1000;
  for (final key in const [
    'ff_dataDadosNaoSyncRebanho',
    'ff_dataDadosNaoSyncLotes',
    'ff_dataDadosNaoSyncSanidade',
    'ff_dataDadosNaoSyncRepro',
  ]) {
    final existing = prefs.getInt(key);
    if (existing == null || existing > markerMs) {
      await prefs.setInt(key, markerMs);
    }
  }

  final nowIso = DateTime.now().toUtc().toIso8601String();

  for (final g in groups) {
    final idPropriedade = g['idPropriedade'] as String?;
    final numeroAnimal = g['numeroAnimal'] as String?;
    final dn = g['dn'] as String? ?? '';
    final sx = g['sx'] as String? ?? '';
    if (idPropriedade == null || numeroAnimal == null) continue;

    try {
      final rows = await db.rawQuery('''
        SELECT * FROM local_rebanho
        WHERE COALESCE(deletado, 'NAO') != 'SIM'
          AND idPropriedade = ?
          AND numeroAnimal = ?
          AND COALESCE(dataNascimento, '') = ?
          AND COALESCE(sexo, '') = ?
        ORDER BY datetime(COALESCE(updated_at, created_at, '1970-01-01')) DESC,
                 datetime(COALESCE(created_at, '1970-01-01')) DESC
      ''', [idPropriedade, numeroAnimal, dn, sx]);

      if (rows.length < 2) continue;

      // EQUIVALÊNCIA TOTAL: para cada coluna (exceto ignoreFields), coleta
      // todos os valores não-vazios distintos entre as linhas. Se houver
      // mais de 1 valor distinto, o grupo é abortado.
      final allFields = rows.first.keys.where((k) => !ignoreFields.contains(k));
      bool conflict = false;
      String? conflictField;
      Set<String>? conflictValues;
      for (final field in allFields) {
        final values = <String>{};
        for (final r in rows) {
          final v = _normalize(r[field]);
          if (v != null) values.add(v);
        }
        if (values.length > 1) {
          conflict = true;
          conflictField = field;
          conflictValues = values;
          break;
        }
      }
      if (conflict) {
        report['conflitos'] = (report['conflitos'] ?? 0) + 1;
        debugPrint(
            '[SQLite][dedupRebanho] CONFLITO em "$conflictField" para numeroAnimal=$numeroAnimal valores=$conflictValues — grupo IGNORADO.');
        continue;
      }

      // Canônico: a linha mais recente (já ordenado DESC).
      final canonical = rows.first;
      final canonicalId = canonical['idRebanho'] as String?;
      if (canonicalId == null || canonicalId.isEmpty) continue;
      final duplicates =
          rows.where((r) => r['idRebanho'] != canonicalId).toList();
      if (duplicates.isEmpty) continue;

      // Como o grupo passou em equivalência total, pode haver campos vazios
      // no canônico que outros dups preencheram. Mesclar é seguro.
      final canonicalUpdates = <String, Object?>{};
      for (final field in allFields) {
        if (_normalize(canonical[field]) != null) continue;
        for (final dup in duplicates) {
          if (_normalize(dup[field]) != null) {
            canonicalUpdates[field] = dup[field];
            break;
          }
        }
      }

      await db.transaction((txn) async {
        if (canonicalUpdates.isNotEmpty) {
          canonicalUpdates['updated_at'] = nowIso;
          await txn.update('local_rebanho', canonicalUpdates,
              where: 'idRebanho = ?', whereArgs: [canonicalId]);
        }

        // Pré-carrega pesagens do canônico para deduplicar por
        // (dataPesagem, tipo, peso) e evitar inserir gêmeas.
        final canonPesagens = await txn.query(
          'local_historico_pesagens',
          where: 'idRebanho = ?',
          whereArgs: [canonicalId],
        );
        final canonKeys = <String>{};
        for (final p in canonPesagens) {
          canonKeys.add(_pesagemKey(p));
        }

        for (final dup in duplicates) {
          final dupId = dup['idRebanho'] as String?;
          if (dupId == null || dupId.isEmpty || dupId == canonicalId) continue;

          // Pesagens: re-inserir no canônico (com novo created_at) para que
          // a sync envie INSERT ao Supabase. Soft-delete da antiga.
          final pesagensDup = await txn.query(
            'local_historico_pesagens',
            where: 'idRebanho = ?',
            whereArgs: [dupId],
          );
          for (final p in pesagensDup) {
            final pid = p['id'];
            final isDeleted = (p['deletado'] as String?) == 'SIM';
            final key = _pesagemKey(p);

            if (!isDeleted && !canonKeys.contains(key)) {
              // Inserir clone no canônico
              final clone = Map<String, Object?>.from(p);
              clone.remove('id');
              clone['idRebanho'] = canonicalId;
              clone['created_at'] = nowIso;
              try {
                await txn.insert(
                  'local_historico_pesagens',
                  clone,
                  conflictAlgorithm: ConflictAlgorithm.ignore,
                );
                canonKeys.add(key);
                report['pesagensReinseridas'] =
                    (report['pesagensReinseridas'] ?? 0) + 1;
              } on DatabaseException catch (e) {
                if (!e.isUniqueConstraintError()) rethrow;
                // Já existe equivalente — ok, segue.
              }
            }
            // Soft-delete da pesagem do dup (será propagada via UPDT).
            await txn.update(
              'local_historico_pesagens',
              {'deletado': 'SIM'},
              where: 'id = ?',
              whereArgs: [pid],
            );
            report['pesagensSoftDelete'] =
                (report['pesagensSoftDelete'] ?? 0) + 1;
          }

          // Sanidade
          final n1 = await txn.update(
            'local_sanidade',
            {'id_rebanho': canonicalId, 'updated_at': nowIso},
            where: 'id_rebanho = ?',
            whereArgs: [dupId],
          );
          report['sanidadeReatribuidos'] =
              (report['sanidadeReatribuidos'] ?? 0) + n1;

          // Reprodução
          final n2 = await txn.update(
            'local_reproducao',
            {'id_rebanho_matriz': canonicalId, 'updated_at': nowIso},
            where: 'id_rebanho_matriz = ?',
            whereArgs: [dupId],
          );
          final n3 = await txn.update(
            'local_reproducao',
            {'id_rebanho_reprodutor': canonicalId, 'updated_at': nowIso},
            where: 'id_rebanho_reprodutor = ?',
            whereArgs: [dupId],
          );
          report['reproducaoReatribuidos'] =
              (report['reproducaoReatribuidos'] ?? 0) + n2 + n3;

          // Auto-refs em local_rebanho
          final n4 = await txn.update(
            'local_rebanho',
            {'rebanhoIdMatriz': canonicalId, 'updated_at': nowIso},
            where: 'rebanhoIdMatriz = ?',
            whereArgs: [dupId],
          );
          final n5 = await txn.update(
            'local_rebanho',
            {'rebanhoIdReprodutor': canonicalId, 'updated_at': nowIso},
            where: 'rebanhoIdReprodutor = ?',
            whereArgs: [dupId],
          );
          report['autoRefsAtualizadas'] =
              (report['autoRefsAtualizadas'] ?? 0) + n4 + n5;

          // Lotes: id_animais é JSON-array. Manipula via jsonDecode/encode.
          final lotesRows = await txn.query(
            'local_lotes',
            columns: ['id', 'id_animais'],
            where: "id_animais LIKE ? AND COALESCE(deletado,'NAO') != 'SIM'",
            whereArgs: ['%$dupId%'],
          );
          for (final lr in lotesRows) {
            final id = lr['id'];
            final ja = lr['id_animais'] as String?;
            if (ja == null || ja.isEmpty) continue;
            final novoJson = _replaceIdInJsonList(ja, dupId, canonicalId);
            if (novoJson != null && novoJson != ja) {
              await txn.update(
                'local_lotes',
                {'id_animais': novoJson, 'updated_at': nowIso},
                where: 'id = ?',
                whereArgs: [id],
              );
              report['lotesAtualizados'] =
                  (report['lotesAtualizados'] ?? 0) + 1;
            }
          }

          // Soft-delete do duplicado.
          await txn.update(
            'local_rebanho',
            {'deletado': 'SIM', 'updated_at': nowIso},
            where: 'idRebanho = ?',
            whereArgs: [dupId],
          );
        }

        report['fundidos'] = (report['fundidos'] ?? 0) + duplicates.length;
      });
    } catch (e, s) {
      report['erros'] = (report['erros'] ?? 0) + 1;
      debugPrint(
          '[SQLite][dedupRebanho] erro no grupo numeroAnimal=$numeroAnimal: $e\n$s');
      // Continua com outros grupos.
    }
  }

  debugPrint('[SQLite][dedupRebanho] Concluído. Relatório: $report');

  // Só marca flag se NENHUM erro ocorreu — assim, se houve falha, tenta
  // novamente no próximo boot (grupos já fundidos não voltam a aparecer
  // pois o duplicado está deletado='SIM').
  if ((report['erros'] ?? 0) == 0) {
    await prefs.setBool(prefsKey, true);
  } else {
    debugPrint(
        '[SQLite][dedupRebanho] flag NÃO gravada por causa de erros — re-executará no próximo boot.');
  }
}

/// Chave de identidade lógica de uma pesagem para detectar equivalentes
/// (mesmo valor de pesagem na mesma data e tipo).
String _pesagemKey(Map<String, Object?> p) {
  final dt = (p['dataPesagem'] ?? '').toString();
  final tp = (p['tipo'] ?? '').toString();
  final peso = p['peso'];
  final pesoStr = peso == null ? '' : peso.toString();
  return '$dt|$tp|$pesoStr';
}

String? _normalize(Object? v) {
  if (v == null) return null;
  final s = v.toString().trim();
  if (s.isEmpty || s.toLowerCase() == 'null') return null;
  return s;
}

/// Substitui `oldId` por `newId` num JSON-array de strings, deduplicando.
/// Retorna null se o JSON for inválido (não toca na linha).
String? _replaceIdInJsonList(String json, String oldId, String newId) {
  try {
    final decoded = jsonDecode(json);
    if (decoded is! List) return null;
    final seen = <String>{};
    final out = <String>[];
    for (final item in decoded) {
      if (item == null) continue;
      final s = item.toString();
      final mapped = s == oldId ? newId : s;
      if (seen.add(mapped)) out.add(mapped);
    }
    return jsonEncode(out);
  } catch (_) {
    return null;
  }
}
