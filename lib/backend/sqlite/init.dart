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
  final versionMatch = RegExp(r'_v(\d+)\.db$').firstMatch(databaseAssetFilename);
  final int expectedVersion = versionMatch != null
      ? int.parse(versionMatch.group(1)!)
      : 0;

  final prefs = await SharedPreferences.getInstance();
  final String prefsKey = 'sqlite_db_version_$databaseName';
  final int installedVersion = prefs.getInt(prefsKey) ?? 0;
  final bool hasPendingLocalSync = _hasPendingLocalSync(prefs);

  final exists = await databaseExists(databasePath);

  // Forçar recriação se a versão do asset mudou
  bool needsRecreation =
      !exists || (expectedVersion > 0 && installedVersion != expectedVersion);

  if (exists && needsRecreation && hasPendingLocalSync) {
    debugPrint('[SQLite] Atualização do banco adiada por pendências locais de sync. '
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
    debugPrint('[SQLite] Banco "$databaseName" v$expectedVersion instalado com sucesso.');
  } else {
    debugPrint('[SQLite] Banco "$databaseName" v$installedVersion já está atualizado.');
  }

  // Abrir o banco de dados
  final database = await openDatabase(databasePath);

  // Validar compatibilidade FTS5 (Android não tem FTS5 no SQLite do sistema)
  await _ensureFts5Compatibility(database);

  // Criar índices para otimizar buscas no rebanho popup
  await _ensureRebanhoIndexes(database);

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
    debugPrint('[SQLite] FTS5 NÃO suportado neste dispositivo ($e). Removendo triggers FTS...');
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
