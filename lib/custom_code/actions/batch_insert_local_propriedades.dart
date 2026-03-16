// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
import 'dart:convert';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:sqflite/sqflite.dart';

Future<bool> batchInsertLocalPropriedades(List<dynamic> records) async {
  if (records.isEmpty) return true;

  try {
    final db = SQLiteManager.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final record in records) {
        final Map<String, dynamic> source = Map<String, dynamic>.from(record);
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

        batch.insert('local_propriedades', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);
    });

    return true;
  } catch (e) {
    debugPrint('Erro batch insert propriedades: $e');
    return false;
  }
}

dynamic _cleanNull(dynamic value) {
  if (value == "null") return null;
  if (value is List || value is Map) {
    return jsonEncode(value);
  }
  return value;
}
