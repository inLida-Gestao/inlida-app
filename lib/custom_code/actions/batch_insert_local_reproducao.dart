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
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:sqflite/sqflite.dart';

Future<bool> batchInsertLocalReproducao(List<dynamic> records) async {
  if (records.isEmpty) return true;

  try {
    final db = SQLiteManager.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final record in records) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(record);

        // Remove ID (autoincrement)
        data.remove('id');

        // Limpa valores "null" string para null real
        final Map<String, dynamic> cleanData = {};
        data.forEach((key, value) {
          if (value == "null") {
            cleanData[key] = null;
          } else if (key == 'created_at' && value != null) {
            // Converte created_at de UTC para o fuso horário local do dispositivo
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

        batch.insert('local_reproducao', cleanData,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);
    });

    return true;
  } catch (e) {
    return false;
  }
}
