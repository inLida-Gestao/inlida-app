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

  // Fase 2: Tentar batch insert
  try {
    final db = SQLiteManager.instance.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final cleanData in mappedRecords) {
        batch.insert('local_reproducao', cleanData,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    return {'inserted': mappedRecords.length, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][reproducao] Batch falhou ($batchError). Inserindo individualmente...');
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;

    for (final cleanData in mappedRecords) {
      try {
        await db.insert('local_reproducao', cleanData,
            conflictAlgorithm: ConflictAlgorithm.replace);
        insertedCount++;
      } catch (e) {
        final id = cleanData['idReproducao']?.toString() ??
            cleanData['id_rebanho']?.toString() ??
            'desconhecido';
        errors.add({'id': id, 'error': e.toString()});
      }
    }

    return {'inserted': insertedCount, 'errors': errors};
  }
}

String _extractReproducaoId(dynamic record) {
  if (record is Map) {
    return record['idReproducao']?.toString() ??
        record['id_rebanho']?.toString() ??
        'desconhecido';
  }
  return 'desconhecido';
}
