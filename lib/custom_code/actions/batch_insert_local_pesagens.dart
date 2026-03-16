// Automatic FlutterFlow imports
import '/backend/sqlite/sqlite_manager.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:sqflite/sqflite.dart';

String? _cleanNull(dynamic value) {
  if (value == null || value == 'null') return null;
  return value.toString();
}

double? _toDouble(dynamic value) {
  if (value == null || value == 'null') return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

Future<Map<String, dynamic>> batchInsertLocalPesagens(
    List<dynamic> records) async {
  if (records.isEmpty) {
    return {'inserted': 0, 'errors': <Map<String, String>>[]};
  }

  final List<Map<String, dynamic>> mappedRecords = [];
  final List<Map<String, String>> errors = [];

  for (int i = 0; i < records.length; i++) {
    try {
      final Map<String, dynamic> source = Map<String, dynamic>.from(records[i]);
      final Map<String, dynamic> mapped = {};

      // Mapeamento específico Supabase -> SQLite
      if (source['idRebanho'] != null) {
        mapped['idRebanho'] = _cleanNull(source['idRebanho']);
      }
      if (source['dataPesagem'] != null) {
        mapped['dataPesagem'] = _cleanNull(source['dataPesagem']);
      }
      if (source['tipo'] != null) {
        mapped['tipo'] = _cleanNull(source['tipo']);
      }
      if (source['peso'] != null) {
        mapped['peso'] = _toDouble(source['peso']);
      }
      if (source['deletado'] != null) {
        mapped['deletado'] = _cleanNull(source['deletado']);
      }
      if (source['created_at'] != null) {
        mapped['created_at'] = _cleanNull(source['created_at']);
      }
      if (source['id_propriedade'] != null) {
        mapped['id_propriedade'] = _cleanNull(source['id_propriedade']);
      }

      mappedRecords.add(mapped);
    } catch (e) {
      final id = _extractPesagemId(records[i]);
      errors.add({'id': id, 'error': 'Erro ao mapear: $e'});
    }
  }

  // Tentar batch insert
  try {
    final db = SQLiteManager.instance.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final mapped in mappedRecords) {
        batch.insert('local_historico_pesagens', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    return {'inserted': mappedRecords.length, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][pesagens] Batch falhou ($batchError). Inserindo individualmente...');
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;

    for (final mapped in mappedRecords) {
      try {
        await db.insert('local_historico_pesagens', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
        insertedCount++;
      } catch (e) {
        final id = mapped['idRebanho']?.toString() ?? 'desconhecido';
        errors.add({'id': id, 'error': e.toString()});
      }
    }

    return {'inserted': insertedCount, 'errors': errors};
  }
}

String _extractPesagemId(dynamic record) {
  if (record is Map) {
    return record['id_pesagem']?.toString() ??
        record['id_rebanho']?.toString() ??
        'desconhecido';
  }
  return 'desconhecido';
}
