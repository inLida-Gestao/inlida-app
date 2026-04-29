// Automatic FlutterFlow imports
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
import 'dart:convert';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:sqflite/sqflite.dart';

Future<Map<String, dynamic>> batchInsertLocalRebanho(
    List<dynamic> records) async {
  if (records.isEmpty) {
    return {'inserted': 0, 'errors': <Map<String, String>>[]};
  }

  final List<Map<String, dynamic>> mappedRecords = [];
  final List<Map<String, String>> errors = [];

  // Fase 1: Mapear todos os registros
  for (int i = 0; i < records.length; i++) {
    try {
      final Map<String, dynamic> source = Map<String, dynamic>.from(records[i]);
      final Map<String, dynamic> mapped = {};

      // Mapeamento específico Supabase -> SQLite
      if (source['idPropriedade'] != null) {
        mapped['idPropriedade'] = _cleanNull(source['idPropriedade']);
      }
      if (source['numeroAnimal'] != null) {
        mapped['numeroAnimal'] = _cleanNull(source['numeroAnimal']);
      }
      if (source['chip'] != null) mapped['chip'] = _cleanNull(source['chip']);
      if (source['codRegistro'] != null) {
        mapped['codRegistro'] = _cleanNull(source['codRegistro']);
      }
      if (source['nome'] != null) mapped['nome'] = _cleanNull(source['nome']);
      if (source['sexo'] != null) mapped['sexo'] = _cleanNull(source['sexo']);
      if (source['categoria'] != null) {
        mapped['categoria'] = _cleanNull(source['categoria']);
      }
      if (source['dataNascimento'] != null) {
        mapped['dataNascimento'] = _cleanNull(source['dataNascimento']);
      }
      if (source['pesoNascimento'] != null) {
        mapped['pesoNascimento'] = source['pesoNascimento'];
      }
      if (source['porte'] != null) {
        mapped['porte'] = _cleanNull(source['porte']);
      }
      if (source['raca'] != null) mapped['raca'] = _cleanNull(source['raca']);
      if (source['loteID'] != null) {
        mapped['loteID'] = _cleanNull(source['loteID']);
      }
      if (source['dataEntradaLote'] != null) {
        mapped['dataEntradaLote'] = _cleanNull(source['dataEntradaLote']);
      }
      if (source['rebanhoIdMatriz'] != null) {
        mapped['rebanhoIdMatriz'] = _cleanNull(source['rebanhoIdMatriz']);
      }
      if (source['rebanhoIdReprodutor'] != null) {
        mapped['rebanhoIdReprodutor'] =
            _cleanNull(source['rebanhoIdReprodutor']);
      }
      if (source['dataDesmama'] != null) {
        mapped['dataDesmama'] = _cleanNull(source['dataDesmama']);
      }
      if (source['pesoDesmama'] != null) {
        mapped['pesoDesmama'] = source['pesoDesmama'];
      }
      if (source['pesoAtual'] != null) {
        mapped['pesoAtual'] = source['pesoAtual'];
      }
      if (source['status'] != null) {
        mapped['statusRebanho'] =
            _cleanNull(source['status']); // MAPEAMENTO CRÍTICO
      }
      if (source['origem'] != null) {
        mapped['origem'] = _cleanNull(source['origem']);
      }
      if (source['anotacoes'] != null) {
        mapped['anotacoes'] = _cleanNull(source['anotacoes']);
      }
      if (source['idRebanho'] != null) {
        mapped['idRebanho'] = _cleanNull(source['idRebanho']);
      }
      if (source['deletado'] != null) {
        mapped['deletado'] = _cleanNull(source['deletado']);
      }
      if (source['created_at'] != null) {
        mapped['created_at'] = _cleanNull(source['created_at']);
      }
      if (source['updated_at'] != null) {
        mapped['updated_at'] = _cleanNull(source['updated_at']);
      }
      if (source['loteNome'] != null) {
        mapped['loteNome'] = _cleanNull(source['loteNome']);
      }
      if (source['tipo'] != null) mapped['tipo'] = _cleanNull(source['tipo']);
      if (source['dataAcao'] != null) {
        mapped['dataAcao'] = _cleanNull(source['dataAcao']);
      }
      if (source['valorCompra'] != null) {
        mapped['valorCompra'] = source['valorCompra'];
      }
      if (source['dataUltimaPesagem'] != null) {
        mapped['dataUltimaPesagem'] = _cleanNull(source['dataUltimaPesagem']);
      }
      if (source['nomeConcat'] != null) {
        mapped['nomeConcat'] = _cleanNull(source['nomeConcat']);
      }
      if (source['dataVenda'] != null) {
        mapped['dataVenda'] = _cleanNull(source['dataVenda']);
      }
      if (source['valorVenda'] != null) {
        mapped['valorVenda'] = source['valorVenda'];
      }
      if (source['movimentacao_entrada'] != null) {
        mapped['movimentacao_entrada'] =
            _cleanNull(source['movimentacao_entrada']);
      }
      if (source['numeroMatriz'] != null) {
        mapped['numeroMatriz'] = _cleanNull(source['numeroMatriz']);
      }
      if (source['nomeMatriz'] != null) {
        mapped['nomeMatriz'] = _cleanNull(source['nomeMatriz']);
      }
      if (source['dataNascMatriz'] != null) {
        mapped['dataNascMatriz'] = _cleanNull(source['dataNascMatriz']);
      }
      if (source['racaMatriz'] != null) {
        mapped['racaMatriz'] = _cleanNull(source['racaMatriz']);
      }
      if (source['numeroReprodutor'] != null) {
        mapped['numeroReprodutor'] = _cleanNull(source['numeroReprodutor']);
      }
      if (source['nomeReprodutor'] != null) {
        mapped['nomeReprodutor'] = _cleanNull(source['nomeReprodutor']);
      }
      if (source['dataNascReprodutor'] != null) {
        mapped['dataNascReprodutor'] = _cleanNull(source['dataNascReprodutor']);
      }
      if (source['racaReprodutor'] != null) {
        mapped['racaReprodutor'] = _cleanNull(source['racaReprodutor']);
      }
      if (source['movimentacao_saida'] != null) {
        mapped['movimentacao_saida'] = _cleanNull(source['movimentacao_saida']);
      }
      if (source['data_morte'] != null) {
        mapped['data_morte'] = _cleanNull(source['data_morte']);
      }
      if (source['motivo_morte'] != null) {
        mapped['motivo_morte'] = _cleanNull(source['motivo_morte']);
      }
      if (source['categoria_matriz'] != null) {
        mapped['categoria_matriz'] = _cleanNull(source['categoria_matriz']);
      }

      mappedRecords.add(mapped);
    } catch (e) {
      final id = _extractRebanhoId(records[i]);
      errors.add({'id': id, 'error': 'Erro ao mapear: $e'});
    }
  }

  // Dedup do INPUT por idRebanho — mantém última ocorrência da página.
  // Defesa em profundidade: a RPC pode retornar repetidos por instabilidade
  // de paginação (ORDER BY updated_at com empates) e, mesmo com UNIQUE INDEX,
  // o REPLACE dentro de um batch produz ordem indeterminada.
  if (mappedRecords.length > 1) {
    final byKey = <String, Map<String, dynamic>>{};
    final ordered = <Map<String, dynamic>>[];
    final orderIndex = <String, int>{};
    for (final m in mappedRecords) {
      final key = m['idRebanho']?.toString();
      if (key == null || key.isEmpty) {
        ordered.add(m);
        continue;
      }
      if (byKey.containsKey(key)) {
        final idx = orderIndex[key]!;
        ordered[idx] = m; // sobrescreve com a última ocorrência
        byKey[key] = m;
      } else {
        byKey[key] = m;
        orderIndex[key] = ordered.length;
        ordered.add(m);
      }
    }
    final removed = mappedRecords.length - ordered.length;
    if (removed > 0) {
      debugPrint(
          '[SYNC][rebanho] Dedup do input do batch: $removed duplicata(s) removida(s).');
    }
    mappedRecords
      ..clear()
      ..addAll(ordered);
  }

  // Fase 2: Garantir que triggers FTS5 não bloqueiem o insert (Android)
  final db = SQLiteManager.instance.database;
  await _disableFtsTriggersSafely(db);

  // Fase 3: Tentar batch insert
  try {
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final mapped in mappedRecords) {
        batch.insert('local_rebanho', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    return {'inserted': mappedRecords.length, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][rebanho] Batch falhou ($batchError). Inserindo individualmente...');
    int insertedCount = 0;

    for (final mapped in mappedRecords) {
      try {
        await db.insert('local_rebanho', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
        insertedCount++;
      } catch (e) {
        final id = mapped['idRebanho']?.toString() ??
            mapped['numeroAnimal']?.toString() ??
            'desconhecido';
        errors.add({'id': id, 'error': e.toString()});
      }
    }

    return {'inserted': insertedCount, 'errors': errors};
  }
}

String _extractRebanhoId(dynamic record) {
  if (record is Map) {
    return record['idRebanho']?.toString() ??
        record['numeroAnimal']?.toString() ??
        record['nome']?.toString() ??
        'desconhecido';
  }
  return 'desconhecido';
}

dynamic _cleanNull(dynamic value) {
  if (value == "null" || value == '') return null;
  if (value is List || value is Map) {
    return jsonEncode(value);
  }
  return value;
}

/// Remove triggers FTS5 que podem falhar no Android (sistema SQLite sem FTS5).
/// Operação idempotente e segura — se os triggers já foram removidos, não faz nada.
Future<void> _disableFtsTriggersSafely(Database db) async {
  try {
    // Verificar se algum trigger FTS existe
    final triggers = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='trigger' AND name LIKE 'rebanho_fts_%'",
    );
    if (triggers.isEmpty) return; // Já foram removidos

    // Testar se FTS5 está funcional
    try {
      await db.rawQuery('SELECT * FROM local_rebanho_fts LIMIT 1');
      // FTS5 funciona — não precisa remover triggers
      return;
    } catch (_) {
      // FTS5 não funciona — remover triggers
    }

    debugPrint('[SYNC][rebanho] FTS5 não disponível. Removendo triggers...');
    for (final trigger in triggers) {
      final name = trigger['name'] as String;
      try {
        await db.execute('DROP TRIGGER IF EXISTS $name');
        debugPrint('[SYNC][rebanho] Trigger "$name" removido.');
      } catch (e) {
        debugPrint('[SYNC][rebanho] Erro ao remover trigger "$name": $e');
      }
    }
  } catch (e) {
    debugPrint('[SYNC][rebanho] Erro ao verificar triggers FTS: $e');
  }
}
