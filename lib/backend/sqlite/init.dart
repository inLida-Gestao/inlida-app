import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const int _largeStartupDbBytes = 25 * 1024 * 1024;
const int _largeStartupTableRows = 50000;

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

int? _getPrefsIntSafe(SharedPreferences prefs, String key) {
  try {
    final raw = prefs.get(key);
    if (raw is int) return raw;
    if (raw is String) {
      final parsedInt = int.tryParse(raw);
      if (parsedInt != null) return parsedInt;
      final parsedDate = DateTime.tryParse(raw);
      return parsedDate?.millisecondsSinceEpoch;
    }
  } catch (e) {
    debugPrint('[SQLite] Preferência "$key" inválida: $e');
  }
  return null;
}

Future<int> _safeFileSizeBytes(String path) async {
  try {
    final file = File(path);
    if (!await file.exists()) return 0;
    return await file.length();
  } catch (e) {
    debugPrint('[SQLite] Erro ao medir tamanho do banco: $e');
    return 0;
  }
}

Future<void> _setPendingMarkerIfEarlier(
  SharedPreferences prefs,
  String key,
  int markerMs,
) async {
  final existing = _getPrefsIntSafe(prefs, key);
  if (existing == null || existing > markerMs) {
    await prefs.setInt(key, markerMs);
  }
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
  final int installedVersion = _getPrefsIntSafe(prefs, prefsKey) ?? 0;
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
  final bool isDeferredDatabaseUpgrade = exists &&
      expectedVersion > 0 &&
      installedVersion != expectedVersion &&
      hasPendingLocalSync;

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
  final databaseSizeBytes = await _safeFileSizeBytes(databasePath);
  final largeStartupDb = databaseSizeBytes >= _largeStartupDbBytes;
  if (largeStartupDb) {
    debugPrint(
        '[SQLite] Base local grande (${(databaseSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB). '
        'Manutenções pesadas de abertura serão adiadas.');
  }

  // Em atualização com dados locais pendentes, o banco antigo é preservado.
  // Antes de qualquer query nova, garanta colunas adicionadas em versões
  // recentes para evitar crash na splash por "no such column".
  await _ensureLocalSchemaCompatibility(database);
  await _backfillLocalRebanhoDirtyFlags(database, prefs);
  await _backfillLocalPesagemKeys(database, prefs);
  if (largeStartupDb) {
    debugPrint(
        '[SQLite] Dedup por id_pesagem pulado na abertura para evitar travar update Android.');
  } else {
    await _dedupPesagemPorIdPesagem(database);
  }

  // Validar compatibilidade FTS5 (Android não tem FTS5 no SQLite do sistema)
  await _ensureFts5Compatibility(database);

  // Criar índices para otimizar buscas no rebanho popup
  await _ensureRebanhoIndexes(database, allowHeavyIndexes: !largeStartupDb);

  final shouldRunStartupMaintenance =
      await _shouldRunStartupMaintenance(database, isDeferredDatabaseUpgrade);

  // CRÍTICO: em bases grandes/antigas com pendências locais, não rode
  // deduplicações pesadas antes do runApp. Isso era a causa provável da splash
  // longa/kill pelo SO após atualização. A sync foi blindada para não depender
  // dessas limpezas síncronas.
  if (shouldRunStartupMaintenance) {
    await _dedupReproducaoPorIdReproducao(database);
    await _dedupSanidadePorIdSanidade(database);
  } else {
    debugPrint(
        '[SQLite] Manutenção pesada de startup adiada para preservar abertura rápida.');
  }

  // Local_lotes é pequeno; limpar duplicatas por id_lote antes do índice
  // evita que bases antigas continuem duplicando a cada download.
  await _dedupLotesPorIdLote(database);

  // Criar índices UNIQUE para suportar UPSERT incremental
  await _ensureUniqueBusinessKeys(database, allowHeavyIndexes: !largeStartupDb);

  // Criar tabela de auditoria de erros de sincronização
  await _ensureSyncErrorLogTable(database);

  if (shouldRunStartupMaintenance) {
    // Limpar duplicatas históricas de Nascimento/Desmama
    await _dedupePesagensFixas(database, prefs, expectedVersion);

    // Limpar duplicatas de pesagens (mesmo idRebanho/dataPesagem/tipo/peso)
    // causadas pelo bug de pré-dedup quebrada (created_at não enviado ao
    // servidor) antes do fix v1.8.7+112.
    await _dedupPesagensDuplicadas(database);

    // Limpar duplicatas lógicas de reprodução causadas por duplo toque/loop de
    // lote (mesma matriz/reprodutor/data/período com id_reproducao diferente).
    await _dedupReproducaoLogicoDuplicado(database, prefs);

    // Limpar duplicatas lógicas de sanidade causadas por duplo toque/loop de
    // lote, mantendo canônico e propagando soft-delete das duplicatas.
    await _dedupSanidadeLogicoDuplicado(database, prefs);
  }

  return database;
}

Future<void> _ensureLocalSchemaCompatibility(Database db) async {
  final columnsByTable = <String, Map<String, String>>{
    'local_historico_pesagens': {
      'id_pesagem': 'TEXT',
      'sync_dirty': 'INTEGER',
      'sync_op': 'TEXT',
      'sync_updated_at': 'TEXT',
    },
    'local_rebanho': {
      'movimentacao_entrada': 'TEXT',
      'movimentacao_saida': 'TEXT',
      'data_morte': 'TEXT',
      'motivo_morte': 'TEXT',
      'categoria_matriz': 'TEXT',
      'sync_dirty': 'INTEGER',
      'sync_op': 'TEXT',
      'sync_updated_at': 'TEXT',
    },
    'local_lotes': {
      'sync_dirty': 'INTEGER',
      'sync_op': 'TEXT',
      'sync_updated_at': 'TEXT',
    },
    'local_reproducao': {
      'racaMatriz': 'TEXT',
      'racaReprodutor': 'TEXT',
      'chipReprodutor': 'TEXT',
      'chipMatriz': 'TEXT',
      'ressinc': 'TEXT',
      'parida': 'TEXT',
      'data_parto': 'TEXT',
      'gnrh': 'TEXT',
      'cio': 'TEXT',
    },
    'local_sanidade': {
      'protocolo_d0': 'TEXT',
      'protocolo_retirada': 'TEXT',
      'protocolo_iatf': 'TEXT',
    },
  };

  for (final tableEntry in columnsByTable.entries) {
    try {
      final existingColumns = await _tableColumns(db, tableEntry.key);
      if (existingColumns.isEmpty) continue;
      for (final columnEntry in tableEntry.value.entries) {
        if (existingColumns.contains(columnEntry.key)) continue;
        await db.execute(
            'ALTER TABLE ${tableEntry.key} ADD COLUMN ${columnEntry.key} ${columnEntry.value}');
        debugPrint(
            '[SQLite] Coluna ${tableEntry.key}.${columnEntry.key} criada para compatibilidade.');
      }
    } catch (e) {
      debugPrint(
          '[SQLite] Erro ao garantir compatibilidade de ${tableEntry.key}: $e');
    }
  }
}

Future<void> _backfillLocalRebanhoDirtyFlags(
  Database db,
  SharedPreferences prefs,
) async {
  try {
    if (!await _tableExists(db, 'local_rebanho')) return;
    final columns = await _tableColumns(db, 'local_rebanho');
    if (!columns.contains('sync_dirty') ||
        !columns.contains('sync_op') ||
        !columns.contains('sync_updated_at')) {
      return;
    }

    final markerMs = _getPrefsIntSafe(prefs, 'ff_dataDadosNaoSyncRebanho');
    var insertsMarked = 0;
    var updatesMarked = 0;
    var deletesMarked = 0;
    if (markerMs != null) {
      final marker = DateTime.fromMillisecondsSinceEpoch(markerMs)
          .toIso8601String()
          .substring(0, 19)
          .replaceFirst('T', ' ');
      insertsMarked = await db.rawUpdate(
        '''
        UPDATE local_rebanho
        SET sync_dirty = 1,
            sync_op = 'insert',
            sync_updated_at = COALESCE(created_at, updated_at)
        WHERE sync_dirty IS NULL
          AND COALESCE(idRebanho, '') != ''
          AND COALESCE(deletado, 'NAO') != 'SIM'
          AND datetime(created_at, 'localtime') >= datetime(?, 'localtime')
        ''',
        [marker],
      );
      updatesMarked = await db.rawUpdate(
        '''
        UPDATE local_rebanho
        SET sync_dirty = 1,
            sync_op = 'update',
            sync_updated_at = COALESCE(updated_at, created_at)
        WHERE sync_dirty IS NULL
          AND COALESCE(idRebanho, '') != ''
          AND COALESCE(deletado, 'NAO') != 'SIM'
          AND datetime(updated_at, 'localtime') >= datetime(?, 'localtime')
          AND (
            created_at IS NULL
            OR datetime(created_at, 'localtime') < datetime(?, 'localtime')
          )
        ''',
        [marker, marker],
      );
      deletesMarked = await db.rawUpdate(
        '''
        UPDATE local_rebanho
        SET sync_dirty = 1,
            sync_op = 'delete',
            sync_updated_at = COALESCE(updated_at, created_at)
        WHERE sync_dirty IS NULL
          AND COALESCE(idRebanho, '') != ''
          AND COALESCE(deletado, 'NAO') = 'SIM'
          AND datetime(updated_at, 'localtime') >= datetime(?, 'localtime')
        ''',
        [marker],
      );
    }

    if (insertsMarked > 0 || updatesMarked > 0 || deletesMarked > 0) {
      debugPrint(
          '[SQLite] Backfill sync rebanho: inserts=$insertsMarked updates=$updatesMarked deletes=$deletesMarked.');
    }
  } catch (e) {
    debugPrint('[SQLite] Erro no backfill de sync rebanho: $e');
  }
}

Future<void> _backfillLocalPesagemKeys(
  Database db,
  SharedPreferences prefs,
) async {
  try {
    if (!await _tableExists(db, 'local_historico_pesagens')) return;
    final markerMs = _getPrefsIntSafe(prefs, 'ff_dataDadosNaoSyncRebanho');
    final args = <Object?>[];
    final pendingFilter = StringBuffer('''
      AND (
        sync_dirty = 1
    ''');
    if (markerMs != null) {
      final marker = DateTime.fromMillisecondsSinceEpoch(markerMs)
          .toIso8601String()
          .substring(0, 19)
          .replaceFirst('T', ' ');
      pendingFilter.write('''
        OR datetime(created_at, 'localtime') >= datetime(?, 'localtime')
      ''');
      args.add(marker);
    }
    pendingFilter.write('''
      )
    ''');

    final updated = await db.rawUpdate('''
      UPDATE local_historico_pesagens
      SET id_pesagem = 'legacy:' ||
          COALESCE(idRebanho, '') || '|' ||
          COALESCE(substr(dataPesagem, 1, 10), '') || '|' ||
          COALESCE(tipo, '') || '|' ||
          CASE
            WHEN peso IS NULL THEN ''
            ELSE printf('%.3f', CAST(peso AS REAL))
           END || '|' ||
           COALESCE(created_at, '')
      WHERE COALESCE(id_pesagem, '') = ''
      ${pendingFilter.toString()}
    ''', args);
    if (updated > 0) {
      debugPrint(
          '[SQLite] Backfill id_pesagem pendente aplicado em $updated pesagem(ns).');
    }
  } catch (e) {
    debugPrint('[SQLite] Erro ao preencher id_pesagem local: $e');
  }
}

Future<void> _dedupPesagemPorIdPesagem(Database db) async {
  try {
    final total = await _safeTableCount(db, 'local_historico_pesagens');
    if (total > _largeStartupTableRows) {
      debugPrint(
          '[SQLite] Dedup id_pesagem adiado: $total pesagem(ns) locais.');
      return;
    }
    final groups = await db.rawQuery('''
      SELECT id_pesagem, COUNT(*) AS qtd
      FROM local_historico_pesagens
      WHERE COALESCE(id_pesagem, '') != ''
      GROUP BY id_pesagem
      HAVING COUNT(*) > 1
    ''');
    var removed = 0;
    for (final group in groups) {
      final idPesagem = group['id_pesagem']?.toString();
      if (idPesagem == null || idPesagem.isEmpty) continue;
      final rows = await db.query(
        'local_historico_pesagens',
        columns: ['id'],
        where: 'id_pesagem = ?',
        whereArgs: [idPesagem],
        orderBy: 'id DESC',
      );
      for (final row in rows.skip(1)) {
        final id = row['id'];
        if (id == null) continue;
        await db.delete(
          'local_historico_pesagens',
          where: 'id = ?',
          whereArgs: [id],
        );
        removed++;
      }
    }
    if (removed > 0) {
      debugPrint(
          '[SQLite] $removed pesagem(ns) duplicada(s) por id_pesagem removida(s).');
    }
  } catch (e) {
    debugPrint('[SQLite] Erro ao deduplicar id_pesagem local: $e');
  }
}

Future<Set<String>> _tableColumns(Database db, String tableName) async {
  final info = await db.rawQuery('PRAGMA table_info($tableName)');
  return info.map((row) => row['name']?.toString()).whereType<String>().toSet();
}

Future<bool> _tableExists(Database db, String tableName) async {
  final rows = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name=? LIMIT 1",
    [tableName],
  );
  return rows.isNotEmpty;
}

Future<int> _safeTableCount(Database db, String tableName) async {
  try {
    if (!await _tableExists(db, tableName)) return 0;
    final rows = await db.rawQuery('SELECT COUNT(*) AS qtd FROM $tableName');
    return Sqflite.firstIntValue(rows) ?? 0;
  } catch (e) {
    debugPrint('[SQLite] Erro ao contar $tableName: $e');
    return 0;
  }
}

Future<bool> _shouldRunStartupMaintenance(
  Database db,
  bool isDeferredDatabaseUpgrade,
) async {
  if (isDeferredDatabaseUpgrade) {
    debugPrint(
        '[SQLite] Upgrade do asset adiado por pendências locais; manutenção pesada será pulada na splash.');
    return false;
  }

  final counts = <String, int>{
    'local_rebanho': await _safeTableCount(db, 'local_rebanho'),
    'local_historico_pesagens':
        await _safeTableCount(db, 'local_historico_pesagens'),
    'local_reproducao': await _safeTableCount(db, 'local_reproducao'),
    'local_sanidade': await _safeTableCount(db, 'local_sanidade'),
  };
  final total = counts.values.fold<int>(0, (sum, value) => sum + value);
  debugPrint('[SQLite] Tamanho base local para manutenção startup: $counts');

  // Limite conservador: mantém limpeza síncrona para bases pequenas, mas evita
  // travar a splash/ser morto pelo SO em bases reais/grandes após update.
  return total <= 1500;
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
Future<bool> _indexExists(Database db, String indexName) async {
  try {
    final rows = await db.rawQuery(
      "SELECT 1 FROM sqlite_master WHERE type='index' AND name=? LIMIT 1",
      [indexName],
    );
    return rows.isNotEmpty;
  } catch (e) {
    debugPrint('[SQLite] Erro ao verificar índice $indexName: $e');
    return false;
  }
}

Future<void> _ensureRebanhoIndexes(
  Database db, {
  required bool allowHeavyIndexes,
}) async {
  const indexes = <({String name, String sql, bool heavy})>[
    // Índice composto principal para a busca do popup
    (
      name: 'idx_rebanho_prop_deletado',
      heavy: false,
      sql: '''CREATE INDEX IF NOT EXISTS idx_rebanho_prop_deletado
       ON local_rebanho (idPropriedade, deletado)''',
    ),
    // Índice para busca por numeroAnimal (LIKE prefix)
    (
      name: 'idx_rebanho_numero_animal',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_rebanho_numero_animal
       ON local_rebanho (idPropriedade, deletado, numeroAnimal)''',
    ),
    // Índice para busca por nome (LIKE prefix)
    (
      name: 'idx_rebanho_nome',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_rebanho_nome
       ON local_rebanho (idPropriedade, deletado, nome)''',
    ),
    // Índice para busca por chip
    (
      name: 'idx_rebanho_chip',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_rebanho_chip
       ON local_rebanho (idPropriedade, deletado, chip)''',
    ),
    // Índice para filtros por sexo e status
    (
      name: 'idx_rebanho_sexo_status',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_rebanho_sexo_status
       ON local_rebanho (idPropriedade, deletado, sexo, statusRebanho, categoria)''',
    ),
    (
      name: 'idx_rebanho_sync_created',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_rebanho_sync_created
       ON local_rebanho (created_at, idRebanho, deletado)''',
    ),
    (
      name: 'idx_rebanho_sync_updated',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_rebanho_sync_updated
       ON local_rebanho (updated_at, idRebanho)''',
    ),
    (
      name: 'idx_rebanho_sync_dirty',
      heavy: false,
      sql: '''CREATE INDEX IF NOT EXISTS idx_rebanho_sync_dirty
       ON local_rebanho (sync_dirty, sync_op, idPropriedade, idRebanho)''',
    ),
  ];

  for (final index in indexes) {
    try {
      if (!allowHeavyIndexes &&
          index.heavy &&
          !await _indexExists(db, index.name)) {
        debugPrint(
            '[SQLite] Índice pesado ${index.name} adiado para preservar abertura.');
        continue;
      }
      await db.execute(index.sql);
    } catch (e) {
      debugPrint('[SQLite] Erro ao criar índice: $e');
    }
  }
  debugPrint('[SQLite] Índices de busca do rebanho verificados/criados.');
}

Future<void> _dedupLotesPorIdLote(Database db) async {
  try {
    final groups = await db.rawQuery('''
      SELECT COALESCE(id_lote, '') AS idLote, COUNT(*) AS qtd
      FROM local_lotes
      WHERE COALESCE(id_lote, '') != ''
        AND LOWER(COALESCE(id_lote, '')) != 'null'
      GROUP BY COALESCE(id_lote, '')
      HAVING COUNT(*) > 1
    ''');
    if (groups.isEmpty) {
      debugPrint('[SQLite][dedupLotes] nenhuma duplicata por id_lote.');
      return;
    }

    var removed = 0;
    for (final group in groups) {
      final idLote = group['idLote']?.toString();
      if (idLote == null || idLote.isEmpty) continue;

      final rows = await db.rawQuery('''
        SELECT *
        FROM local_lotes
        WHERE id_lote = ?
        ORDER BY
          COALESCE(sync_dirty, 0) DESC,
          datetime(COALESCE(sync_updated_at, updated_at, created_at), 'localtime') DESC,
          id DESC
      ''', [idLote]);
      if (rows.length < 2) continue;

      final keepId = rows.first['id'];
      if (keepId == null) continue;

      final merged = Map<String, Object?>.from(rows.first);
      for (final duplicate in rows.skip(1)) {
        for (final key in duplicate.keys) {
          if (key == 'id') continue;
          if (_normalize(merged[key]) == null &&
              _normalize(duplicate[key]) != null) {
            merged[key] = duplicate[key];
          }
        }
      }

      final dirtyRows = rows
          .where((row) => row['sync_dirty'] == 1 || row['sync_dirty'] == '1')
          .toList();
      if (dirtyRows.isNotEmpty) {
        final dirtyRow = dirtyRows.first;
        merged['sync_dirty'] = 1;
        merged['sync_op'] = _normalize(dirtyRow['sync_op']) ?? 'update';
        merged['sync_updated_at'] = _normalize(dirtyRow['sync_updated_at']) ??
            _normalize(dirtyRow['updated_at']) ??
            _normalize(dirtyRow['created_at']);
      }

      merged.remove('id');
      await db.update(
        'local_lotes',
        merged,
        where: 'id = ?',
        whereArgs: [keepId],
      );
      final duplicateIds =
          rows.skip(1).map((row) => row['id']).whereType<int>().toList();
      if (duplicateIds.isNotEmpty) {
        final placeholders = List.filled(duplicateIds.length, '?').join(',');
        removed += await db.delete(
          'local_lotes',
          where: 'id IN ($placeholders)',
          whereArgs: duplicateIds,
        );
      }
    }
    debugPrint(
        '[SQLite][dedupLotes] ${groups.length} grupo(s), $removed duplicata(s) removida(s).');
  } catch (e, s) {
    debugPrint('[SQLite][dedupLotes] erro ao limpar duplicatas: $e\n$s');
  }
}

/// Cria índices UNIQUE nas colunas de chave de negócio para que
/// ConflictAlgorithm.replace funcione como UPSERT na sync incremental.
Future<void> _ensureUniqueBusinessKeys(
  Database db, {
  required bool allowHeavyIndexes,
}) async {
  const indexes = <({String name, String sql, bool heavy})>[
    (
      name: 'idx_unique_propriedade',
      heavy: false,
      sql: '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_propriedade
       ON local_propriedades (idPropriedade)''',
    ),
    (
      name: 'idx_unique_rebanho',
      heavy: false,
      sql: '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_rebanho
       ON local_rebanho (idRebanho)''',
    ),
    (
      name: 'idx_unique_lote',
      heavy: false,
      sql: '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_lote
       ON local_lotes (id_lote)''',
    ),
    (
      name: 'idx_unique_reproducao',
      heavy: true,
      sql: '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_reproducao
       ON local_reproducao (id_reproducao)''',
    ),
    (
      name: 'idx_unique_sanidade',
      heavy: true,
      sql: '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_sanidade
       ON local_sanidade (id_sanidade)''',
    ),
    (
      name: 'idx_unique_pesagem',
      heavy: true,
      sql: '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_pesagem
       ON local_historico_pesagens (idRebanho, dataPesagem, tipo, created_at)''',
    ),
    (
      name: 'idx_unique_pesagem_id_pesagem',
      heavy: true,
      sql: '''CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_pesagem_id_pesagem
       ON local_historico_pesagens (id_pesagem)''',
    ),
    (
      name: 'idx_pesagem_prop_created',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_pesagem_prop_created
       ON local_historico_pesagens (id_propriedade, created_at)''',
    ),
    (
      name: 'idx_pesagem_rebanho_created',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_pesagem_rebanho_created
       ON local_historico_pesagens (idRebanho, created_at)''',
    ),
    (
      name: 'idx_pesagem_created',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_pesagem_created
       ON local_historico_pesagens (created_at)''',
    ),
    (
      name: 'idx_pesagem_sync_dirty',
      heavy: true,
      sql: '''CREATE INDEX IF NOT EXISTS idx_pesagem_sync_dirty
       ON local_historico_pesagens (sync_dirty, sync_op, id_pesagem)''',
    ),
  ];

  // Dropar índice antigo de pesagem (sem created_at) se existir,
  // para permitir múltiplas pesagens no mesmo dia.
  try {
    // Verifica se o índice antigo existe e se tem apenas 3 colunas
    final idxInfo = await db.rawQuery("PRAGMA index_info(idx_unique_pesagem)");
    if (idxInfo.isNotEmpty && idxInfo.length <= 3 && allowHeavyIndexes) {
      await db.execute('DROP INDEX IF EXISTS idx_unique_pesagem');
      debugPrint(
          '[SQLite] Índice antigo idx_unique_pesagem (3 cols) removido.');
    }
  } catch (e) {
    debugPrint('[SQLite] Erro ao verificar/dropar índice antigo: $e');
  }

  for (final index in indexes) {
    try {
      if (!allowHeavyIndexes &&
          index.heavy &&
          !await _indexExists(db, index.name)) {
        debugPrint(
            '[SQLite] Índice pesado ${index.name} adiado para preservar abertura.');
        continue;
      }
      await db.execute(index.sql);
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
    await _setPendingMarkerIfEarlier(prefs, key, markerMs);
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

            if (isDeleted) continue;

            var podeDeletarOriginal = canonKeys.contains(key);
            if (!podeDeletarOriginal) {
              // Inserir clone no canônico. Só deletamos a pesagem original se
              // o clone for confirmado; falha aqui aborta a transação do grupo.
              final clone = Map<String, Object?>.from(p);
              clone.remove('id');
              clone['idRebanho'] = canonicalId;
              clone['created_at'] = nowIso;
              await txn.insert('local_historico_pesagens', clone);
              canonKeys.add(key);
              podeDeletarOriginal = true;
              report['pesagensReinseridas'] =
                  (report['pesagensReinseridas'] ?? 0) + 1;
            }

            if (podeDeletarOriginal) {
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

// ============================================================================
// DEDUP LÓGICO V3 — mesmo animal com idRebanho diferente.
// ============================================================================
// Cobre o caso restante observado em produção: duplicatas ativas com número do
// animal igual na mesma propriedade, mas idRebanho diferente. A rotina v2 era
// conservadora e pulava grupos após edições (campos divergentes); aqui a regra
// é manter a versão mais recente e marcar as antigas como deletado=SIM para o
// sync atualizar o Supabase. Para evitar falso positivo, se houver datas de
// nascimento diferentes e não vazias, o grupo é ignorado.
Future<void> _dedupRebanhoLogicoDuplicadoV3(
  Database db,
  SharedPreferences prefs,
) async {
  const ignoreFields = <String>{
    'id',
    'idRebanho',
    'created_at',
    'updated_at',
    'deletado',
  };

  int recencyScore(Map<String, Object?> row) {
    final updated = _normalize(row['updated_at']);
    final created = _normalize(row['created_at']);
    final raw = updated ?? created;
    if (raw != null) {
      final parsed = DateTime.tryParse(
        raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'),
      );
      if (parsed != null) return parsed.millisecondsSinceEpoch;
    }
    return (row['id'] as int?) ?? 0;
  }

  Future<void> markPendingSync() async {
    final markerMs = DateTime.now()
        .subtract(const Duration(minutes: 5))
        .millisecondsSinceEpoch;
    for (final key in const [
      'ff_dataDadosNaoSyncRebanho',
      'ff_dataDadosNaoSyncLotes',
      'ff_dataDadosNaoSyncSanidade',
      'ff_dataDadosNaoSyncRepro',
    ]) {
      await _setPendingMarkerIfEarlier(prefs, key, markerMs);
    }
  }

  final report = <String, int>{
    'gruposDetectados': 0,
    'fundidos': 0,
    'ignoradosDataNascimento': 0,
    'erros': 0,
    'pesagensReinseridas': 0,
    'pesagensSoftDelete': 0,
    'sanidadeReatribuidos': 0,
    'reproducaoReatribuidos': 0,
    'lotesAtualizados': 0,
    'autoRefsAtualizadas': 0,
  };

  var houveMutacao = false;
  try {
    final groups = await db.rawQuery('''
      SELECT idPropriedade, numeroAnimal, COUNT(*) AS qtd
      FROM local_rebanho
      WHERE COALESCE(deletado, 'NAO') != 'SIM'
        AND COALESCE(idPropriedade, '') != ''
        AND COALESCE(numeroAnimal, '') != ''
      GROUP BY idPropriedade, numeroAnimal
      HAVING COUNT(*) > 1
    ''');

    if (groups.isEmpty) {
      debugPrint('[SQLite][dedupRebanhoV3] nenhuma duplicata lógica.');
      return;
    }
    report['gruposDetectados'] = groups.length;
    debugPrint(
        '[SQLite][dedupRebanhoV3] ${groups.length} grupo(s) lógico(s) candidato(s).');

    for (final group in groups) {
      final idPropriedade = group['idPropriedade'] as String?;
      final numeroAnimal = group['numeroAnimal'] as String?;
      if (idPropriedade == null || numeroAnimal == null) continue;

      try {
        final rows = await db.rawQuery('''
          SELECT * FROM local_rebanho
          WHERE COALESCE(deletado, 'NAO') != 'SIM'
            AND idPropriedade = ?
            AND numeroAnimal = ?
        ''', [idPropriedade, numeroAnimal]);
        if (rows.length < 2) continue;

        final birthDates = rows
            .map((r) => _normalize(r['dataNascimento']))
            .whereType<String>()
            .toSet();
        if (birthDates.length > 1) {
          report['ignoradosDataNascimento'] =
              (report['ignoradosDataNascimento'] ?? 0) + 1;
          debugPrint(
              '[SQLite][dedupRebanhoV3] grupo ignorado por datas diferentes: propriedade=$idPropriedade numero=$numeroAnimal datas=$birthDates');
          continue;
        }

        final sorted = List<Map<String, Object?>>.from(rows);
        sorted.sort((a, b) {
          final cmp = recencyScore(b).compareTo(recencyScore(a));
          if (cmp != 0) return cmp;
          final ai = (a['id'] as int?) ?? 0;
          final bi = (b['id'] as int?) ?? 0;
          return bi.compareTo(ai);
        });

        final canonical = sorted.first;
        final canonicalId = canonical['idRebanho'] as String?;
        if (canonicalId == null || canonicalId.isEmpty) continue;
        final duplicates =
            sorted.where((r) => r['idRebanho'] != canonicalId).toList();
        if (duplicates.isEmpty) continue;

        final nowIso = DateTime.now().toUtc().toIso8601String();
        await db.transaction((txn) async {
          final canonicalUpdates = <String, Object?>{};
          final fields = canonical.keys.where((k) => !ignoreFields.contains(k));
          for (final field in fields) {
            if (_normalize(canonical[field]) != null) continue;
            for (final dup in duplicates) {
              if (_normalize(dup[field]) != null) {
                canonicalUpdates[field] = dup[field];
                break;
              }
            }
          }
          if (canonicalUpdates.isNotEmpty) {
            canonicalUpdates['updated_at'] = nowIso;
            await txn.update(
              'local_rebanho',
              canonicalUpdates,
              where: 'idRebanho = ?',
              whereArgs: [canonicalId],
            );
          }

          final canonPesagens = await txn.query(
            'local_historico_pesagens',
            where: 'idRebanho = ?',
            whereArgs: [canonicalId],
          );
          final canonKeys = canonPesagens.map(_pesagemKey).toSet();

          for (final dup in duplicates) {
            final dupId = dup['idRebanho'] as String?;
            if (dupId == null || dupId.isEmpty || dupId == canonicalId) {
              continue;
            }

            final pesagensDup = await txn.query(
              'local_historico_pesagens',
              where: 'idRebanho = ?',
              whereArgs: [dupId],
            );
            for (final p in pesagensDup) {
              final pid = p['id'];
              final isDeleted = (p['deletado'] as String?) == 'SIM';
              final key = _pesagemKey(p);

              if (isDeleted) continue;

              var podeDeletarOriginal = canonKeys.contains(key);
              if (!podeDeletarOriginal) {
                final clone = Map<String, Object?>.from(p);
                clone.remove('id');
                clone['idRebanho'] = canonicalId;
                clone['created_at'] = nowIso;
                await txn.insert('local_historico_pesagens', clone);
                canonKeys.add(key);
                podeDeletarOriginal = true;
                report['pesagensReinseridas'] =
                    (report['pesagensReinseridas'] ?? 0) + 1;
              }

              if (podeDeletarOriginal) {
                await txn.update(
                  'local_historico_pesagens',
                  {'deletado': 'SIM'},
                  where: 'id = ?',
                  whereArgs: [pid],
                );
                report['pesagensSoftDelete'] =
                    (report['pesagensSoftDelete'] ?? 0) + 1;
              }
            }

            final n1 = await txn.update(
              'local_sanidade',
              {'id_rebanho': canonicalId, 'updated_at': nowIso},
              where: 'id_rebanho = ?',
              whereArgs: [dupId],
            );
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
            final n4 = await txn.update(
              'local_rebanho',
              {
                'rebanhoIdMatriz': canonicalId,
                'updated_at': nowIso,
              },
              where: 'rebanhoIdMatriz = ?',
              whereArgs: [dupId],
            );
            final n5 = await txn.update(
              'local_rebanho',
              {
                'rebanhoIdReprodutor': canonicalId,
                'updated_at': nowIso,
              },
              where: 'rebanhoIdReprodutor = ?',
              whereArgs: [dupId],
            );

            report['sanidadeReatribuidos'] =
                (report['sanidadeReatribuidos'] ?? 0) + n1;
            report['reproducaoReatribuidos'] =
                (report['reproducaoReatribuidos'] ?? 0) + n2 + n3;
            report['autoRefsAtualizadas'] =
                (report['autoRefsAtualizadas'] ?? 0) + n4 + n5;

            final lotesRows = await txn.query(
              'local_lotes',
              columns: ['id', 'id_animais'],
              where: "id_animais LIKE ? AND COALESCE(deletado,'NAO') != 'SIM'",
              whereArgs: ['%$dupId%'],
            );
            for (final lote in lotesRows) {
              final novoJson = _replaceIdInJsonList(
                (lote['id_animais'] ?? '').toString(),
                dupId,
                canonicalId,
              );
              if (novoJson != null && novoJson != lote['id_animais']) {
                await txn.update(
                  'local_lotes',
                  {'id_animais': novoJson, 'updated_at': nowIso},
                  where: 'id = ?',
                  whereArgs: [lote['id']],
                );
                report['lotesAtualizados'] =
                    (report['lotesAtualizados'] ?? 0) + 1;
              }
            }

            await txn.update(
              'local_rebanho',
              {
                'deletado': 'SIM',
                'updated_at': nowIso,
              },
              where: 'idRebanho = ?',
              whereArgs: [dupId],
            );
            houveMutacao = true;
            report['fundidos'] = (report['fundidos'] ?? 0) + 1;
          }
        });
      } catch (e, s) {
        report['erros'] = (report['erros'] ?? 0) + 1;
        debugPrint(
            '[SQLite][dedupRebanhoV3] erro no grupo propriedade=$idPropriedade numero=$numeroAnimal: $e\n$s');
      }
    }

    if (houveMutacao) {
      await markPendingSync();
    }
    debugPrint('[SQLite][dedupRebanhoV3] Concluído. Relatório: $report');
  } catch (e, s) {
    debugPrint('[SQLite][dedupRebanhoV3] ERRO GLOBAL: $e\n$s');
  }
}

Future<void> dedupLocalRebanhoLogicoDuplicado(Database db) async {
  final prefs = await SharedPreferences.getInstance();
  await _dedupRebanhoLogicoDuplicadoV3(db, prefs);
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

// ============================================================================
// DEDUPLICAÇÃO DE PESAGENS DUPLICADAS
// ============================================================================
// Causa raiz: até v1.8.6+111 o payload de INSERT em historico_pesagens NÃO
// incluía `created_at`. O servidor gerava seu próprio now() e a pré-dedup
// (que comparava por created_at) NUNCA batia. Cada retry após timeout pós
// sucesso criava outra linha. Pior: o PULL trazia as duplicatas de volta
// como linhas locais distintas (cada uma com id próprio).
//
// Esta rotina identifica grupos de pesagens locais que dividem a mesma
// chave lógica `(idRebanho, dataPesagem, tipo, peso)` (excluindo já
// deletadas) e mantém apenas UMA — a sobrevivente é a com MENOR id (mais
// antiga, mais provável de já estar no Supabase com o id correto). As
// outras são marcadas `deletado='SIM'` e propagadas via UPDT por id.
//
// Roda em TODA inicialização (sem flag) porque o PULL pode trazer novas
// duplicatas até toda a base estar limpa.
// ============================================================================
Future<void> _dedupPesagensDuplicadas(Database db) async {
  try {
    final groups = await db.rawQuery('''
      SELECT idRebanho,
             COALESCE(dataPesagem, '') AS dp,
             COALESCE(tipo, '') AS tp,
             COALESCE(peso, 0) AS pe,
             COUNT(*) AS qtd
      FROM local_historico_pesagens
      WHERE COALESCE(deletado, 'NAO') != 'SIM'
        AND COALESCE(idRebanho, '') != ''
      GROUP BY idRebanho,
               COALESCE(dataPesagem, ''),
               COALESCE(tipo, ''),
               COALESCE(peso, 0)
      HAVING COUNT(*) > 1
    ''');

    if (groups.isEmpty) return;

    int total = 0;
    for (final g in groups) {
      final idRebanho = g['idRebanho'] as String?;
      final dp = g['dp'] as String? ?? '';
      final tp = g['tp'] as String? ?? '';
      final pe = g['pe'];
      if (idRebanho == null) continue;

      // MANTÉM o de MENOR id (geralmente o que o servidor já reconhece) e
      // marca os outros como deletados.
      final rows = await db.rawQuery('''
        SELECT id FROM local_historico_pesagens
        WHERE COALESCE(deletado, 'NAO') != 'SIM'
          AND idRebanho = ?
          AND COALESCE(dataPesagem, '') = ?
          AND COALESCE(tipo, '') = ?
          AND COALESCE(peso, 0) = ?
        ORDER BY id ASC
      ''', [idRebanho, dp, tp, pe]);

      if (rows.length < 2) continue;

      // Skip o primeiro (sobrevivente). Soft-delete os demais.
      for (final r in rows.skip(1)) {
        final id = r['id'];
        if (id == null) continue;
        await db.update(
          'local_historico_pesagens',
          {'deletado': 'SIM'},
          where: 'id = ?',
          whereArgs: [id],
        );
        total++;
      }
    }

    if (total > 0) {
      debugPrint(
          '[SQLite][dedupPesagens] ${groups.length} grupo(s) com duplicata; $total pesagem(ns) marcadas deletado=SIM (propagarão via UPDT na próxima sync).');
    }
  } catch (e, s) {
    debugPrint('[SQLite][dedupPesagens] ERRO: $e\n$s');
  }
}

// ============================================================================
// _dedupRebanhoPorIdRebanho — limpa duplicatas com MESMO idRebanho.
//
// Problema: PULL (batchInsertLocalRebanho) usa ConflictAlgorithm.replace,
// que só substitui se houver UNIQUE INDEX em idRebanho. Se a base já tem
// duplicatas (de bugs anteriores), o CREATE UNIQUE INDEX falha silenciosamente
// e o REPLACE degrada para INSERT puro — cada PULL duplica tudo. Cada edição
// do usuário (UPDATE WHERE idRebanho=?) também afeta as duas linhas, e a
// duplicação se amplifica a cada ciclo PUSH/PULL.
//
// Estratégia AGRESSIVA (idRebanho é UUID único = mesma entidade lógica):
// - GROUP BY idRebanho HAVING COUNT(*) > 1, considerando TODAS as linhas
//   (incluindo deletado='SIM'), senão UNIQUE INDEX continua falhando.
// - Canônico = linha mais RECENTE (maior updated_at; fallback created_at;
//   fallback maior id local). Se o usuário fez 2 edições do MESMO animal
//   em momentos diferentes, a edição mais recente prevalece (não há "duas
//   versões válidas" de uma mesma entidade UUID).
// - Merge defensivo PARA TRÁS: para campos onde o canônico tem NULL/'',
//   adota valor da duplicata (preserva dados que possam estar só lá).
//   Campos onde ambos têm valor: canônico ganha (é a versão mais recente
//   editada pelo usuário).
// - Hard delete das duplicatas: servidor só conhece UMA cópia por idRebanho;
//   apagar local não desincroniza nada remoto.
// - Marker dataDadosNaoSyncRebanho zerado quando há merge → mesclagens
//   sobem como UPDATE no próximo sync.
// - Try/catch por grupo + global: boot nunca trava.
// ============================================================================
Future<void> _dedupRebanhoPorIdRebanho(Database db) async {
  // Campos de identificação / não comparados em conflito.
  const ignoreFields = <String>{
    'id',
    'idRebanho',
    'created_at',
    'updated_at',
    'deletado',
  };

  bool isEmpty(Object? v) {
    if (v == null) return true;
    if (v is String && v.trim().isEmpty) return true;
    return false;
  }

  // Score para escolher canônico: prioriza updated_at, fallback created_at,
  // fallback id. Retorna inteiro comparável.
  int recencyScore(Map<String, Object?> row) {
    final u = row['updated_at']?.toString();
    final c = row['created_at']?.toString();
    final ts = (u != null && u.isNotEmpty) ? u : (c ?? '');
    if (ts.isEmpty) return 0;
    try {
      // Aceita ISO (com ou sem T) e formato "yyyy-MM-dd HH:mm:ss".
      final parsed =
          DateTime.tryParse(ts.contains('T') ? ts : ts.replaceFirst(' ', 'T'));
      if (parsed != null) return parsed.millisecondsSinceEpoch;
    } catch (_) {}
    return 0;
  }

  int gruposDetectados = 0;
  int gruposFundidos = 0;
  int linhasRemovidas = 0;
  int gruposComErro = 0;
  bool houveMerge = false;

  try {
    final groups = await db.rawQuery('''
      SELECT idRebanho
      FROM local_rebanho
      WHERE COALESCE(idRebanho, '') != ''
      GROUP BY idRebanho
      HAVING COUNT(*) > 1
    ''');
    gruposDetectados = groups.length;
    if (gruposDetectados == 0) {
      debugPrint('[SQLite][dedupRebanhoIdR] Nenhuma duplicata por idRebanho.');
      return;
    }
    debugPrint(
        '[SQLite][dedupRebanhoIdR] $gruposDetectados grupo(s) duplicado(s) por idRebanho detectado(s).');

    for (final g in groups) {
      final idRebanho = g['idRebanho'] as String?;
      if (idRebanho == null || idRebanho.isEmpty) continue;

      try {
        await db.transaction((txn) async {
          final rows = await txn.query(
            'local_rebanho',
            where: 'idRebanho = ?',
            whereArgs: [idRebanho],
          );
          if (rows.length < 2) return;

          // Canônico = mais recente (updated_at DESC, depois id DESC).
          final sorted = List<Map<String, Object?>>.from(rows);
          sorted.sort((a, b) {
            final cmp = recencyScore(b).compareTo(recencyScore(a));
            if (cmp != 0) return cmp;
            final ai = (a['id'] as int?) ?? 0;
            final bi = (b['id'] as int?) ?? 0;
            return bi.compareTo(ai);
          });

          final canonical = sorted.first;
          final duplicates = sorted.skip(1).toList();

          // Merge defensivo PARA TRÁS: preenche campos vazios do canônico
          // com valores das duplicatas (pega a primeira ocorrência não-vazia).
          final mergedFields = <String, Object?>{};
          for (final dup in duplicates) {
            for (final entry in dup.entries) {
              final field = entry.key;
              if (ignoreFields.contains(field)) continue;
              final dupVal = entry.value;
              if (isEmpty(dupVal)) continue;
              final canVal = mergedFields.containsKey(field)
                  ? mergedFields[field]
                  : canonical[field];
              if (isEmpty(canVal)) {
                mergedFields[field] = dupVal;
              }
            }
          }

          if (mergedFields.isNotEmpty) {
            mergedFields['updated_at'] = DateTime.now().toIso8601String();
            await txn.update(
              'local_rebanho',
              mergedFields,
              where: 'id = ?',
              whereArgs: [canonical['id']],
            );
            houveMerge = true;
          }

          // Hard delete das duplicatas.
          for (final dup in duplicates) {
            await txn.delete(
              'local_rebanho',
              where: 'id = ?',
              whereArgs: [dup['id']],
            );
            linhasRemovidas++;
          }
          gruposFundidos++;
        });
      } catch (e, s) {
        gruposComErro++;
        debugPrint(
            '[SQLite][dedupRebanhoIdR] Erro no grupo idRebanho=$idRebanho: $e\n$s');
      }
    }

    // Se houve merge, marca janela de sync para reenviar como UPDATE.
    // ATENÇÃO: o app_state.dart grava como millisecondsSinceEpoch (Int).
    // Manter o mesmo formato para não quebrar o load do FFAppState.
    if (houveMerge) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final fiveMinAgoMs = DateTime.now()
            .subtract(const Duration(minutes: 5))
            .millisecondsSinceEpoch;
        await prefs.setInt('ff_dataDadosNaoSyncRebanho', fiveMinAgoMs);
        debugPrint(
            '[SQLite][dedupRebanhoIdR] Marker ff_dataDadosNaoSyncRebanho=$fiveMinAgoMs (Int ms — mesclagens subirão como UPDATE).');
      } catch (e) {
        debugPrint(
            '[SQLite][dedupRebanhoIdR] Falha ao gravar marker de sync: $e');
      }
    }

    debugPrint(
        '[SQLite][dedupRebanhoIdR] Resumo: detectados=$gruposDetectados fundidos=$gruposFundidos erros=$gruposComErro linhasRemovidas=$linhasRemovidas');
  } catch (e, s) {
    debugPrint('[SQLite][dedupRebanhoIdR] ERRO GLOBAL: $e\n$s');
  }
}

// ============================================================================
// _dedupReproducaoPorIdReproducao — limpa duplicatas com MESMO id_reproducao.
// ============================================================================
Future<void> _dedupReproducaoPorIdReproducao(Database db) async {
  const ignoreFields = <String>{
    'id',
    'id_reproducao',
    'created_at',
    'updated_at',
    'deletado',
  };

  bool isEmpty(Object? value) => _normalize(value) == null;

  int recencyScore(Map<String, Object?> row) {
    final updated = _normalize(row['updated_at']);
    final created = _normalize(row['created_at']);
    final raw = updated ?? created;
    if (raw != null) {
      final parsed = DateTime.tryParse(
        raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'),
      );
      if (parsed != null) return parsed.millisecondsSinceEpoch;
    }
    return (row['id'] as int?) ?? 0;
  }

  var gruposDetectados = 0;
  var gruposFundidos = 0;
  var linhasRemovidas = 0;
  var gruposComErro = 0;
  var houveMerge = false;

  try {
    final groups = await db.rawQuery('''
      SELECT id_reproducao
      FROM local_reproducao
      WHERE COALESCE(id_reproducao, '') != ''
      GROUP BY id_reproducao
      HAVING COUNT(*) > 1
    ''');
    gruposDetectados = groups.length;
    if (gruposDetectados == 0) {
      debugPrint('[SQLite][dedupReproId] Nenhuma duplicata por id_reproducao.');
      return;
    }
    debugPrint(
        '[SQLite][dedupReproId] $gruposDetectados grupo(s) duplicado(s) por id_reproducao detectado(s).');

    for (final g in groups) {
      final idReproducao = g['id_reproducao'] as String?;
      if (idReproducao == null || idReproducao.isEmpty) continue;

      try {
        await db.transaction((txn) async {
          final rows = await txn.query(
            'local_reproducao',
            where: 'id_reproducao = ?',
            whereArgs: [idReproducao],
          );
          if (rows.length < 2) return;

          final sorted = List<Map<String, Object?>>.from(rows);
          sorted.sort((a, b) {
            final cmp = recencyScore(b).compareTo(recencyScore(a));
            if (cmp != 0) return cmp;
            final ai = (a['id'] as int?) ?? 0;
            final bi = (b['id'] as int?) ?? 0;
            return bi.compareTo(ai);
          });

          final canonical = sorted.first;
          final duplicates = sorted.skip(1).toList();
          final mergedFields = <String, Object?>{};

          for (final dup in duplicates) {
            for (final entry in dup.entries) {
              final field = entry.key;
              if (ignoreFields.contains(field)) continue;
              final dupVal = entry.value;
              if (isEmpty(dupVal)) continue;
              final canVal = mergedFields.containsKey(field)
                  ? mergedFields[field]
                  : canonical[field];
              if (isEmpty(canVal)) {
                mergedFields[field] = dupVal;
              }
            }
          }

          if (mergedFields.isNotEmpty) {
            mergedFields['updated_at'] =
                DateTime.now().toUtc().toIso8601String();
            await txn.update(
              'local_reproducao',
              mergedFields,
              where: 'id = ?',
              whereArgs: [canonical['id']],
            );
            houveMerge = true;
          }

          for (final dup in duplicates) {
            await txn.delete(
              'local_reproducao',
              where: 'id = ?',
              whereArgs: [dup['id']],
            );
            linhasRemovidas++;
          }
          gruposFundidos++;
        });
      } catch (e, s) {
        gruposComErro++;
        debugPrint(
            '[SQLite][dedupReproId] Erro no grupo id_reproducao=$idReproducao: $e\n$s');
      }
    }

    if (houveMerge) {
      final prefs = await SharedPreferences.getInstance();
      await _markReproPendingSync(prefs, '[SQLite][dedupReproId]');
    }

    debugPrint(
        '[SQLite][dedupReproId] Resumo: detectados=$gruposDetectados fundidos=$gruposFundidos erros=$gruposComErro linhasRemovidas=$linhasRemovidas');
  } catch (e, s) {
    debugPrint('[SQLite][dedupReproId] ERRO GLOBAL: $e\n$s');
  }
}

// ============================================================================
// DEDUP LÓGICO DE REPRODUÇÃO — mesma operação com id_reproducao diferente.
// ============================================================================
Future<void> _dedupReproducaoLogicoDuplicado(
  Database db,
  SharedPreferences prefs,
) async {
  const ignoreFields = <String>{
    'id',
    'id_reproducao',
    'created_at',
    'updated_at',
    'deletado',
  };
  const maxCreatedAtDistance = Duration(minutes: 10);

  bool isEmpty(Object? value) => _normalize(value) == null;

  int recencyScore(Map<String, Object?> row) {
    final updated = _normalize(row['updated_at']);
    final created = _normalize(row['created_at']);
    final raw = updated ?? created;
    if (raw != null) {
      final parsed = DateTime.tryParse(
        raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'),
      );
      if (parsed != null) return parsed.millisecondsSinceEpoch;
    }
    return (row['id'] as int?) ?? 0;
  }

  int? createdScore(Map<String, Object?> row) {
    final raw = _normalize(row['created_at']);
    if (raw == null) return null;
    final parsed = DateTime.tryParse(
      raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'),
    );
    return parsed?.millisecondsSinceEpoch;
  }

  final report = <String, int>{
    'gruposDetectados': 0,
    'fundidos': 0,
    'ignoradosTempo': 0,
    'erros': 0,
  };
  var houveMutacao = false;

  try {
    final groups = await db.rawQuery('''
      SELECT
        COALESCE(id_propriedade, '') AS idProp,
        COALESCE(tipo_reproducao, '') AS tipo,
        COALESCE(id_rebanho_matriz, '') AS matriz,
        COALESCE(id_rebanho_reprodutor, '') AS reprodutor,
        COALESCE(data_inseminacao, '') AS dataIns,
        COALESCE(data_partida_semen, '') AS dataSemen,
        COALESCE(partida_semen, '') AS partida,
        COALESCE(data_inicial, '') AS dataIni,
        COALESCE(data_final, '') AS dataFim,
        COALESCE(id_lote, '') AS lote,
        COUNT(*) AS qtd
      FROM local_reproducao
      WHERE COALESCE(deletado, 'NAO') != 'SIM'
        AND COALESCE(id_reproducao, '') != ''
        AND COALESCE(id_propriedade, '') != ''
        AND COALESCE(tipo_reproducao, '') != ''
        AND COALESCE(id_rebanho_matriz, '') != ''
        AND (
          COALESCE(data_inseminacao, '') != ''
          OR COALESCE(data_inicial, '') != ''
          OR COALESCE(data_final, '') != ''
        )
      GROUP BY
        COALESCE(id_propriedade, ''),
        COALESCE(tipo_reproducao, ''),
        COALESCE(id_rebanho_matriz, ''),
        COALESCE(id_rebanho_reprodutor, ''),
        COALESCE(data_inseminacao, ''),
        COALESCE(data_partida_semen, ''),
        COALESCE(partida_semen, ''),
        COALESCE(data_inicial, ''),
        COALESCE(data_final, ''),
        COALESCE(id_lote, '')
      HAVING COUNT(*) > 1
    ''');

    if (groups.isEmpty) {
      debugPrint('[SQLite][dedupReproLogico] nenhuma duplicata lógica.');
      return;
    }
    report['gruposDetectados'] = groups.length;
    debugPrint(
        '[SQLite][dedupReproLogico] ${groups.length} grupo(s) lógico(s) candidato(s).');

    for (final group in groups) {
      try {
        final rows = await db.rawQuery('''
          SELECT *
          FROM local_reproducao
          WHERE COALESCE(deletado, 'NAO') != 'SIM'
            AND COALESCE(id_propriedade, '') = ?
            AND COALESCE(tipo_reproducao, '') = ?
            AND COALESCE(id_rebanho_matriz, '') = ?
            AND COALESCE(id_rebanho_reprodutor, '') = ?
            AND COALESCE(data_inseminacao, '') = ?
            AND COALESCE(data_partida_semen, '') = ?
            AND COALESCE(partida_semen, '') = ?
            AND COALESCE(data_inicial, '') = ?
            AND COALESCE(data_final, '') = ?
            AND COALESCE(id_lote, '') = ?
        ''', [
          group['idProp'],
          group['tipo'],
          group['matriz'],
          group['reprodutor'],
          group['dataIns'],
          group['dataSemen'],
          group['partida'],
          group['dataIni'],
          group['dataFim'],
          group['lote'],
        ]);
        if (rows.length < 2) continue;

        final createdScores = rows.map(createdScore).whereType<int>().toList();
        if (createdScores.length > 1) {
          createdScores.sort();
          final distance = createdScores.last - createdScores.first;
          if (distance > maxCreatedAtDistance.inMilliseconds) {
            report['ignoradosTempo'] = (report['ignoradosTempo'] ?? 0) + 1;
            debugPrint(
                '[SQLite][dedupReproLogico] grupo ignorado por intervalo entre created_at maior que ${maxCreatedAtDistance.inMinutes}min: matriz=${group['matriz']} tipo=${group['tipo']} data=${group['dataIns']}${group['dataIni']}');
            continue;
          }
        }

        final sorted = List<Map<String, Object?>>.from(rows);
        sorted.sort((a, b) {
          final cmp = recencyScore(b).compareTo(recencyScore(a));
          if (cmp != 0) return cmp;
          final ai = (a['id'] as int?) ?? 0;
          final bi = (b['id'] as int?) ?? 0;
          return bi.compareTo(ai);
        });

        final canonical = sorted.first;
        final canonicalId = canonical['id_reproducao'] as String?;
        if (canonicalId == null || canonicalId.isEmpty) continue;
        final duplicates =
            sorted.where((r) => r['id_reproducao'] != canonicalId).toList();
        if (duplicates.isEmpty) continue;

        final nowIso = DateTime.now().toUtc().toIso8601String();
        await db.transaction((txn) async {
          final canonicalUpdates = <String, Object?>{};
          for (final dup in duplicates) {
            for (final entry in dup.entries) {
              final field = entry.key;
              if (ignoreFields.contains(field)) continue;
              final dupVal = entry.value;
              if (isEmpty(dupVal)) continue;
              final canVal = canonicalUpdates.containsKey(field)
                  ? canonicalUpdates[field]
                  : canonical[field];
              if (isEmpty(canVal)) {
                canonicalUpdates[field] = dupVal;
              }
            }
          }

          if (canonicalUpdates.isNotEmpty) {
            canonicalUpdates['updated_at'] = nowIso;
            await txn.update(
              'local_reproducao',
              canonicalUpdates,
              where: 'id = ?',
              whereArgs: [canonical['id']],
            );
          }

          for (final dup in duplicates) {
            await txn.update(
              'local_reproducao',
              {'deletado': 'SIM', 'updated_at': nowIso},
              where: 'id = ?',
              whereArgs: [dup['id']],
            );
            report['fundidos'] = (report['fundidos'] ?? 0) + 1;
          }
          houveMutacao = true;
        });
      } catch (e, s) {
        report['erros'] = (report['erros'] ?? 0) + 1;
        debugPrint('[SQLite][dedupReproLogico] erro no grupo: $e\n$s');
      }
    }

    if (houveMutacao) {
      await _markReproPendingSync(prefs, '[SQLite][dedupReproLogico]');
    }
    debugPrint('[SQLite][dedupReproLogico] Concluído. Relatório: $report');
  } catch (e, s) {
    debugPrint('[SQLite][dedupReproLogico] ERRO GLOBAL: $e\n$s');
  }
}

Future<void> _markReproPendingSync(
  SharedPreferences prefs,
  String label,
) async {
  final markerMs = DateTime.now()
      .subtract(const Duration(minutes: 5))
      .millisecondsSinceEpoch;
  final existing = _getPrefsIntSafe(prefs, 'ff_dataDadosNaoSyncRepro');
  await _setPendingMarkerIfEarlier(prefs, 'ff_dataDadosNaoSyncRepro', markerMs);
  if (existing == null || existing > markerMs) {
    debugPrint('$label Marker ff_dataDadosNaoSyncRepro=$markerMs.');
  }
}

// ============================================================================
// _dedupSanidadePorIdSanidade — limpa duplicatas com MESMO id_sanidade.
// ============================================================================
Future<void> _dedupSanidadePorIdSanidade(Database db) async {
  const ignoreFields = <String>{
    'id',
    'id_sanidade',
    'created_at',
    'updated_at',
    'deletado',
  };

  bool isEmpty(Object? value) => _normalize(value) == null;

  int recencyScore(Map<String, Object?> row) {
    final updated = _normalize(row['updated_at']);
    final created = _normalize(row['created_at']);
    final raw = updated ?? created;
    if (raw != null) {
      final parsed = DateTime.tryParse(
        raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'),
      );
      if (parsed != null) return parsed.millisecondsSinceEpoch;
    }
    return (row['id'] as int?) ?? 0;
  }

  var gruposDetectados = 0;
  var gruposFundidos = 0;
  var linhasRemovidas = 0;
  var gruposComErro = 0;
  var houveMerge = false;

  try {
    final groups = await db.rawQuery('''
      SELECT id_sanidade
      FROM local_sanidade
      WHERE COALESCE(id_sanidade, '') != ''
      GROUP BY id_sanidade
      HAVING COUNT(*) > 1
    ''');
    gruposDetectados = groups.length;
    if (gruposDetectados == 0) {
      debugPrint(
          '[SQLite][dedupSanidadeId] Nenhuma duplicata por id_sanidade.');
      return;
    }
    debugPrint(
        '[SQLite][dedupSanidadeId] $gruposDetectados grupo(s) duplicado(s) por id_sanidade detectado(s).');

    for (final group in groups) {
      final idSanidade = group['id_sanidade'] as String?;
      if (idSanidade == null || idSanidade.isEmpty) continue;

      try {
        await db.transaction((txn) async {
          final rows = await txn.query(
            'local_sanidade',
            where: 'id_sanidade = ?',
            whereArgs: [idSanidade],
          );
          if (rows.length < 2) return;

          final sorted = List<Map<String, Object?>>.from(rows);
          sorted.sort((a, b) {
            final cmp = recencyScore(b).compareTo(recencyScore(a));
            if (cmp != 0) return cmp;
            final ai = (a['id'] as int?) ?? 0;
            final bi = (b['id'] as int?) ?? 0;
            return bi.compareTo(ai);
          });

          final canonical = sorted.first;
          final duplicates = sorted.skip(1).toList();
          final mergedFields = <String, Object?>{};

          for (final dup in duplicates) {
            for (final entry in dup.entries) {
              final field = entry.key;
              if (ignoreFields.contains(field)) continue;
              final dupVal = entry.value;
              if (isEmpty(dupVal)) continue;
              final canVal = mergedFields.containsKey(field)
                  ? mergedFields[field]
                  : canonical[field];
              if (isEmpty(canVal)) {
                mergedFields[field] = dupVal;
              }
            }
          }

          if (mergedFields.isNotEmpty) {
            mergedFields['updated_at'] =
                DateTime.now().toUtc().toIso8601String();
            await txn.update(
              'local_sanidade',
              mergedFields,
              where: 'id = ?',
              whereArgs: [canonical['id']],
            );
            houveMerge = true;
          }

          for (final dup in duplicates) {
            await txn.delete(
              'local_sanidade',
              where: 'id = ?',
              whereArgs: [dup['id']],
            );
            linhasRemovidas++;
          }
          gruposFundidos++;
        });
      } catch (e, s) {
        gruposComErro++;
        debugPrint(
            '[SQLite][dedupSanidadeId] Erro no grupo id_sanidade=$idSanidade: $e\n$s');
      }
    }

    if (houveMerge) {
      final prefs = await SharedPreferences.getInstance();
      await _markSanidadePendingSync(prefs, '[SQLite][dedupSanidadeId]');
    }

    debugPrint(
        '[SQLite][dedupSanidadeId] Resumo: detectados=$gruposDetectados fundidos=$gruposFundidos erros=$gruposComErro linhasRemovidas=$linhasRemovidas');
  } catch (e, s) {
    debugPrint('[SQLite][dedupSanidadeId] ERRO GLOBAL: $e\n$s');
  }
}

// ============================================================================
// DEDUP LÓGICO DE SANIDADE — mesma aplicação com id_sanidade diferente.
// ============================================================================
Future<void> _dedupSanidadeLogicoDuplicado(
  Database db,
  SharedPreferences prefs,
) async {
  const ignoreFields = <String>{
    'id',
    'id_sanidade',
    'created_at',
    'updated_at',
    'deletado',
  };
  const maxCreatedAtDistance = Duration(minutes: 10);

  bool isEmpty(Object? value) => _normalize(value) == null;

  int recencyScore(Map<String, Object?> row) {
    final updated = _normalize(row['updated_at']);
    final created = _normalize(row['created_at']);
    final raw = updated ?? created;
    if (raw != null) {
      final parsed = DateTime.tryParse(
        raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'),
      );
      if (parsed != null) return parsed.millisecondsSinceEpoch;
    }
    return (row['id'] as int?) ?? 0;
  }

  int? createdScore(Map<String, Object?> row) {
    final raw = _normalize(row['created_at']);
    if (raw == null) return null;
    final parsed = DateTime.tryParse(
      raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'),
    );
    return parsed?.millisecondsSinceEpoch;
  }

  final report = <String, int>{
    'gruposDetectados': 0,
    'fundidos': 0,
    'ignoradosTempo': 0,
    'erros': 0,
  };
  var houveMutacao = false;

  try {
    final groups = await db.rawQuery('''
      SELECT
        COALESCE(id_propriedade, '') AS idProp,
        COALESCE(id_rebanho, '') AS rebanho,
        COALESCE(id_lote, '') AS lote,
        COALESCE(data_sanidade, '') AS dataSan,
        COALESCE(CAST(porcentagem_lote AS TEXT), '') AS pctLote,
        COALESCE(vacinacao, '') AS vac,
        COALESCE(vacinacao_outros, '') AS vacOutros,
        COALESCE(vacinacao_obs, '') AS vacObs,
        COALESCE(antiparasitario, '') AS anti,
        COALESCE(antiparasitario_outros, '') AS antiOutros,
        COALESCE(antiparasitario_obs, '') AS antiObs,
        COALESCE(tratamento, '') AS trat,
        COALESCE(tratamento_outros, '') AS tratOutros,
        COALESCE(tratamento_obs, '') AS tratObs,
        COALESCE(protocolo_reprodutivo, '') AS proto,
        COALESCE(protocolo_reprodutivo_outros, '') AS protoOutros,
        COALESCE(protocolo_reprodutivo_obs, '') AS protoObs,
        COALESCE(protocolo_d0, '') AS protoD0,
        COALESCE(protocolo_retirada, '') AS protoRetirada,
        COALESCE(protocolo_iatf, '') AS protoIatf,
        COUNT(*) AS qtd
      FROM local_sanidade
      WHERE COALESCE(deletado, 'NAO') != 'SIM'
        AND COALESCE(id_sanidade, '') != ''
        AND COALESCE(id_propriedade, '') != ''
        AND COALESCE(data_sanidade, '') != ''
        AND (
          COALESCE(id_rebanho, '') != ''
          OR COALESCE(id_lote, '') != ''
        )
      GROUP BY
        COALESCE(id_propriedade, ''),
        COALESCE(id_rebanho, ''),
        COALESCE(id_lote, ''),
        COALESCE(data_sanidade, ''),
        COALESCE(CAST(porcentagem_lote AS TEXT), ''),
        COALESCE(vacinacao, ''),
        COALESCE(vacinacao_outros, ''),
        COALESCE(vacinacao_obs, ''),
        COALESCE(antiparasitario, ''),
        COALESCE(antiparasitario_outros, ''),
        COALESCE(antiparasitario_obs, ''),
        COALESCE(tratamento, ''),
        COALESCE(tratamento_outros, ''),
        COALESCE(tratamento_obs, ''),
        COALESCE(protocolo_reprodutivo, ''),
        COALESCE(protocolo_reprodutivo_outros, ''),
        COALESCE(protocolo_reprodutivo_obs, ''),
        COALESCE(protocolo_d0, ''),
        COALESCE(protocolo_retirada, ''),
        COALESCE(protocolo_iatf, '')
      HAVING COUNT(*) > 1
    ''');

    if (groups.isEmpty) {
      debugPrint('[SQLite][dedupSanidadeLogico] nenhuma duplicata lógica.');
      return;
    }
    report['gruposDetectados'] = groups.length;
    debugPrint(
        '[SQLite][dedupSanidadeLogico] ${groups.length} grupo(s) lógico(s) candidato(s).');

    for (final group in groups) {
      try {
        final rows = await db.rawQuery('''
          SELECT *
          FROM local_sanidade
          WHERE COALESCE(deletado, 'NAO') != 'SIM'
            AND COALESCE(id_propriedade, '') = ?
            AND COALESCE(id_rebanho, '') = ?
            AND COALESCE(id_lote, '') = ?
            AND COALESCE(data_sanidade, '') = ?
            AND COALESCE(CAST(porcentagem_lote AS TEXT), '') = ?
            AND COALESCE(vacinacao, '') = ?
            AND COALESCE(vacinacao_outros, '') = ?
            AND COALESCE(vacinacao_obs, '') = ?
            AND COALESCE(antiparasitario, '') = ?
            AND COALESCE(antiparasitario_outros, '') = ?
            AND COALESCE(antiparasitario_obs, '') = ?
            AND COALESCE(tratamento, '') = ?
            AND COALESCE(tratamento_outros, '') = ?
            AND COALESCE(tratamento_obs, '') = ?
            AND COALESCE(protocolo_reprodutivo, '') = ?
            AND COALESCE(protocolo_reprodutivo_outros, '') = ?
            AND COALESCE(protocolo_reprodutivo_obs, '') = ?
            AND COALESCE(protocolo_d0, '') = ?
            AND COALESCE(protocolo_retirada, '') = ?
            AND COALESCE(protocolo_iatf, '') = ?
        ''', [
          group['idProp'],
          group['rebanho'],
          group['lote'],
          group['dataSan'],
          group['pctLote'],
          group['vac'],
          group['vacOutros'],
          group['vacObs'],
          group['anti'],
          group['antiOutros'],
          group['antiObs'],
          group['trat'],
          group['tratOutros'],
          group['tratObs'],
          group['proto'],
          group['protoOutros'],
          group['protoObs'],
          group['protoD0'],
          group['protoRetirada'],
          group['protoIatf'],
        ]);
        if (rows.length < 2) continue;

        final createdScores = rows.map(createdScore).whereType<int>().toList();
        if (createdScores.length > 1) {
          createdScores.sort();
          final distance = createdScores.last - createdScores.first;
          if (distance > maxCreatedAtDistance.inMilliseconds) {
            report['ignoradosTempo'] = (report['ignoradosTempo'] ?? 0) + 1;
            debugPrint(
                '[SQLite][dedupSanidadeLogico] grupo ignorado por intervalo entre created_at maior que ${maxCreatedAtDistance.inMinutes}min: rebanho=${group['rebanho']} lote=${group['lote']} data=${group['dataSan']}');
            continue;
          }
        }

        final sorted = List<Map<String, Object?>>.from(rows);
        sorted.sort((a, b) {
          final cmp = recencyScore(b).compareTo(recencyScore(a));
          if (cmp != 0) return cmp;
          final ai = (a['id'] as int?) ?? 0;
          final bi = (b['id'] as int?) ?? 0;
          return bi.compareTo(ai);
        });

        final canonical = sorted.first;
        final canonicalId = canonical['id_sanidade'] as String?;
        if (canonicalId == null || canonicalId.isEmpty) continue;
        final duplicates =
            sorted.where((r) => r['id_sanidade'] != canonicalId).toList();
        if (duplicates.isEmpty) continue;

        final nowIso = DateTime.now().toUtc().toIso8601String();
        await db.transaction((txn) async {
          final canonicalUpdates = <String, Object?>{};
          for (final dup in duplicates) {
            for (final entry in dup.entries) {
              final field = entry.key;
              if (ignoreFields.contains(field)) continue;
              final dupVal = entry.value;
              if (isEmpty(dupVal)) continue;
              final canVal = canonicalUpdates.containsKey(field)
                  ? canonicalUpdates[field]
                  : canonical[field];
              if (isEmpty(canVal)) {
                canonicalUpdates[field] = dupVal;
              }
            }
          }

          if (canonicalUpdates.isNotEmpty) {
            canonicalUpdates['updated_at'] = nowIso;
            await txn.update(
              'local_sanidade',
              canonicalUpdates,
              where: 'id = ?',
              whereArgs: [canonical['id']],
            );
          }

          for (final dup in duplicates) {
            await txn.update(
              'local_sanidade',
              {'deletado': 'SIM', 'updated_at': nowIso},
              where: 'id = ?',
              whereArgs: [dup['id']],
            );
            report['fundidos'] = (report['fundidos'] ?? 0) + 1;
          }
          houveMutacao = true;
        });
      } catch (e, s) {
        report['erros'] = (report['erros'] ?? 0) + 1;
        debugPrint('[SQLite][dedupSanidadeLogico] erro no grupo: $e\n$s');
      }
    }

    if (houveMutacao) {
      await _markSanidadePendingSync(prefs, '[SQLite][dedupSanidadeLogico]');
    }
    debugPrint('[SQLite][dedupSanidadeLogico] Concluído. Relatório: $report');
  } catch (e, s) {
    debugPrint('[SQLite][dedupSanidadeLogico] ERRO GLOBAL: $e\n$s');
  }
}

Future<void> _markSanidadePendingSync(
  SharedPreferences prefs,
  String label,
) async {
  final markerMs = DateTime.now()
      .subtract(const Duration(minutes: 5))
      .millisecondsSinceEpoch;
  final existing = _getPrefsIntSafe(prefs, 'ff_dataDadosNaoSyncSanidade');
  await _setPendingMarkerIfEarlier(
      prefs, 'ff_dataDadosNaoSyncSanidade', markerMs);
  if (existing == null || existing > markerMs) {
    debugPrint('$label Marker ff_dataDadosNaoSyncSanidade=$markerMs.');
  }
}
