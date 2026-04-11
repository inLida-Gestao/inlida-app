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

Future<Map<String, dynamic>> batchInsertLocalPropriedades(
    List<dynamic> records) async {
  if (records.isEmpty) {
    return {'inserted': 0, 'errors': <Map<String, String>>[]};
  }

  final List<Map<String, dynamic>> mappedRecords = [];
  final List<Map<String, String>> errors = [];

  // Fase 1: Mapear todos os registros
  for (int i = 0; i < records.length; i++) {
    try {
      final Map<String, dynamic> source =
          Map<String, dynamic>.from(records[i]);
      final Map<String, dynamic> mapped = {};

        if (source['userID'] != null) {
          mapped['userID'] = _cleanNull(source['userID']);
        }
        if (source['anotacoes'] != null) {
          mapped['anotacoes'] = _cleanNull(source['anotacoes']);
        }
        if (source['areaAgricultura'] != null) {
          mapped['areaAgricultura'] = source['areaAgricultura'];
        }
        if (source['areaBenfeitoria'] != null) {
          mapped['areaBenfeitoria'] = source['areaBenfeitoria'];
        }
        if (source['areaPastagem'] != null) {
          mapped['areaPastagem'] = source['areaPastagem'];
        }
        if (source['areaReserva'] != null) {
          mapped['areaReserva'] = source['areaReserva'];
        }
        if (source['areaTotal'] != null) {
          mapped['areaTotal'] = source['areaTotal'];
        }
        if (source['cidade'] != null) {
          mapped['cidade'] = _cleanNull(source['cidade']);
        }
        if (source['estado'] != null) {
          mapped['estado'] = _cleanNull(source['estado']);
        }
        if (source['icone'] != null) {
          mapped['icone'] = _cleanNull(source['icone']);
        }
        if (source['idPropriedade'] != null) {
          mapped['idPropriedade'] = _cleanNull(source['idPropriedade']);
        }
        if (source['atividades'] != null) {
          mapped['atividades'] = _cleanNull(source['atividades']);
        }
        if (source['nome'] != null) {
          mapped['nome'] = _cleanNull(source['nome']);
        }
        if (source['updated_at'] != null) {
          mapped['updated_at'] = _cleanNull(source['updated_at'].toString());
        }
        if (source['created_at'] != null) {
          mapped['created_at'] = _cleanNull(source['created_at'].toString());
        }
        if (source['usersID'] != null) {
          mapped['usersID'] = _cleanNull(source['usersID']);
        }
        if (source['rebanhosID'] != null) {
          mapped['rebanhosID'] = _cleanNull(source['rebanhosID']);
        }
        if (source['deletado'] != null) {
          mapped['deletado'] = _cleanNull(source['deletado']);
        }

      mappedRecords.add(mapped);
    } catch (e) {
      final id = (records[i] is Map ? records[i]['idPropriedade']?.toString() : null) ?? 'desconhecido';
      errors.add({'id': id, 'error': 'Erro ao mapear: $e'});
    }
  }

  // Fase 2: Tentar batch insert
  try {
    final db = SQLiteManager.instance.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final mapped in mappedRecords) {
        batch.insert('local_propriedades', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    return {'inserted': mappedRecords.length, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][propriedades] Batch falhou ($batchError). Inserindo individualmente...');
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;

    for (final mapped in mappedRecords) {
      try {
        await db.insert('local_propriedades', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
        insertedCount++;
      } catch (e) {
        final id = mapped['idPropriedade']?.toString() ?? 'desconhecido';
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
