// Automatic FlutterFlow imports
import '/backend/sqlite/sqlite_manager.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:sqflite/sqflite.dart';

Future<Map<String, dynamic>> batchInsertLocalReproducao(
    List<dynamic> records) async {
  if (records.isEmpty) {
    return {'inserted': 0, 'errors': <Map<String, String>>[]};
  }

  final List<Map<String, dynamic>> mappedRecords = [];
  final List<Map<String, String>> errors = [];

  // Fase 1: Mapear registros
  for (int i = 0; i < records.length; i++) {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>.from(records[i]);
      data.remove('id');

      final Map<String, dynamic> cleanData = {};
      data.forEach((key, value) {
        if (value == "null") {
          cleanData[key] = null;
        } else if (key == 'created_at' && value != null) {
          try {
            final utcDate = DateTime.parse(value.toString()).toUtc();
            final localDate = utcDate.toLocal();
            cleanData[key] = localDate.toIso8601String();
          } catch (_) {
            cleanData[key] = value;
          }
        } else {
          cleanData[key] = value;
        }
      });

      mappedRecords.add(cleanData);
    } catch (e) {
      final id = _extractReproducaoId(records[i]);
      errors.add({'id': id, 'error': 'Erro ao mapear: $e'});
    }
  }

  final dedupedRecords = _dedupMappedReproducao(mappedRecords);
  final removedDuplicates = mappedRecords.length - dedupedRecords.length;
  if (removedDuplicates > 0) {
    debugPrint(
        '[SYNC][reproducao] PULL dedup: $removedDuplicates duplicata(s) por id_reproducao removida(s) antes do INSERT local.');
  }

  // Fase 2: Tentar batch insert
  try {
    final db = SQLiteManager.instance.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final cleanData in dedupedRecords) {
        batch.insert('local_reproducao', cleanData,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    return {'inserted': dedupedRecords.length, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][reproducao] Batch falhou ($batchError). Inserindo individualmente...');
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;

    for (final cleanData in dedupedRecords) {
      try {
        await db.insert('local_reproducao', cleanData,
            conflictAlgorithm: ConflictAlgorithm.replace);
        insertedCount++;
      } catch (e) {
        final id = cleanData['id_reproducao']?.toString() ??
            cleanData['idReproducao']?.toString() ??
            cleanData['id_rebanho']?.toString() ??
            'desconhecido';
        errors.add({'id': id, 'error': e.toString()});
      }
    }

    return {'inserted': insertedCount, 'errors': errors};
  }
}

List<Map<String, dynamic>> _dedupMappedReproducao(
  List<Map<String, dynamic>> records,
) {
  if (records.length < 2) return records;

  final output = <Map<String, dynamic>>[];
  final indexById = <String, int>{};
  for (final record in records) {
    final id = record['id_reproducao']?.toString().trim();
    if (id == null || id.isEmpty) {
      output.add(record);
      continue;
    }

    final existingIndex = indexById[id];
    if (existingIndex == null) {
      indexById[id] = output.length;
      output.add(record);
    } else {
      output[existingIndex] = record; // mantém a última ocorrência da página.
    }
  }
  return output;
}

String _extractReproducaoId(dynamic record) {
  if (record is Map) {
    return record['id_reproducao']?.toString() ??
        record['idReproducao']?.toString() ??
        record['id_rebanho']?.toString() ??
        'desconhecido';
  }
  return 'desconhecido';
}
