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

Future<bool> batchInsertLocalPesagens(List<dynamic> records) async {
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
          cleanData[key] = (value == "null") ? null : value;
        });

        batch.insert('local_historico_pesagens', cleanData,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);
    });

    return true;
  } catch (e) {
    return false;
  }
}
