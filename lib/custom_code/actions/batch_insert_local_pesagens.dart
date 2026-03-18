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

      // Mapeamento específico Supabase -> SQLite (com fallback para snake_case)
      final idRebanho = source['idRebanho'] ?? source['idrebanho'] ?? source['id_rebanho'];
      if (idRebanho != null) {
        mapped['idRebanho'] = _cleanNull(idRebanho);
      }
      final dataPesagem = source['dataPesagem'] ?? source['datapesagem'] ?? source['data_pesagem'];
      if (dataPesagem != null) {
        mapped['dataPesagem'] = _cleanNull(dataPesagem);
      }
      if (source['tipo'] != null) {
        mapped['tipo'] = _cleanNull(source['tipo']);
      }
      if (source['peso'] != null) {
        mapped['peso'] = _toDouble(source['peso']);
      }
      final deletado = source['deletado'];
      if (deletado != null) {
        mapped['deletado'] = _cleanNull(deletado) ?? 'NAO';
      } else {
        mapped['deletado'] = 'NAO';
      }
      final createdAt = source['created_at'] ?? source['createdAt'];
      if (createdAt != null) {
        mapped['created_at'] = _cleanNull(createdAt);
      }
      final idPropriedade = source['id_propriedade'] ?? source['idPropriedade'] ?? source['idpropriedade'];
      if (idPropriedade != null) {
        mapped['id_propriedade'] = _cleanNull(idPropriedade);
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
