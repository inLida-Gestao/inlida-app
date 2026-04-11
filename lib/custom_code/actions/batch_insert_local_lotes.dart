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

Future<Map<String, dynamic>> batchInsertLocalLotes(List<dynamic> records) async {
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

        if (source['id_propriedade'] != null) {
          mapped['id_propriedade'] = _cleanNull(source['id_propriedade']);
        }
        if (source['id_animais'] != null) {
          mapped['id_animais'] = _cleanNull(source['id_animais']);
        }
        if (source['nome'] != null) {
          mapped['nome'] = _cleanNull(source['nome']);
        }
        if (source['anotacoes'] != null) {
          mapped['anotacoes'] = _cleanNull(source['anotacoes']);
        }
        if (source['ativo'] != null) {
          mapped['ativo'] = _cleanNull(source['ativo']);
        }
        if (source['motivo'] != null) {
          mapped['motivo'] = _cleanNull(source['motivo']);
        }
        if (source['data_motivo'] != null) {
          mapped['data_motivo'] = _cleanNull(source['data_motivo'].toString());
        }
        if (source['id_lote'] != null) {
          mapped['id_lote'] = _cleanNull(source['id_lote']);
        }
        if (source['deletado'] != null) {
          mapped['deletado'] = _cleanNull(source['deletado']);
        }
        if (source['created_at'] != null) {
          mapped['created_at'] = _cleanNull(source['created_at'].toString());
        }
        if (source['updated_at'] != null) {
          mapped['updated_at'] = _cleanNull(source['updated_at'].toString());
        }
        if (source['valorVenda'] != null) {
          mapped['valorVenda'] = source['valorVenda'];
        }
        if (source['data_entrada_piquete'] != null) {
          mapped['data_entrada_piquete'] =
              _cleanNull(source['data_entrada_piquete'].toString());
        }
        if (source['data_saida_piquete'] != null) {
          mapped['data_saida_piquete'] =
              _cleanNull(source['data_saida_piquete'].toString());
        }

      mappedRecords.add(mapped);
    } catch (e) {
      final id = (records[i] is Map ? records[i]['id_lote']?.toString() : null) ?? 'desconhecido';
      errors.add({'id': id, 'error': 'Erro ao mapear: $e'});
    }
  }

  // Fase 2: Tentar batch insert
  try {
    final db = SQLiteManager.instance.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final mapped in mappedRecords) {
        batch.insert('local_lotes', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    return {'inserted': mappedRecords.length, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][lotes] Batch falhou ($batchError). Inserindo individualmente...');
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;

    for (final mapped in mappedRecords) {
      try {
        await db.insert('local_lotes', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
        insertedCount++;
      } catch (e) {
        final id = mapped['id_lote']?.toString() ?? 'desconhecido';
        errors.add({'id': id, 'error': e.toString()});
      }
    }

    return {'inserted': insertedCount, 'errors': errors};
  }
}

dynamic _cleanNull(dynamic value) {
  if (value == "null" || value == '') return null;
  if (value is List || value is Map) {
    return jsonEncode(value);
  }
  return value;
}
