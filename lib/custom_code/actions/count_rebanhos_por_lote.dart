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

Future<int> countRebanhosPorLote(String loteNome) async {
  try {
    final db = SQLiteManager.instance.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) as quantidade
      FROM local_rebanho 
      WHERE loteNome = ?
      AND (deletado = 'NAO')
    ''', [loteNome]);

    if (result.isNotEmpty) {
      return result.first['quantidade'] as int;
    }

    return 0;
  } catch (e) {
    print('Erro ao buscar quantidade de rebanhos: $e');
    return 0;
  }
}
