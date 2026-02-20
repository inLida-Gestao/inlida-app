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

Future<bool> batchInsertLocalLotes(List<dynamic> records) async {
  if (records.isEmpty) return true;

  try {
    final db = SQLiteManager.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final record in records) {
        final Map<String, dynamic> source = Map<String, dynamic>.from(record);
        final Map<String, dynamic> mapped = {};

        if (source['id_propriedade'] != null)
          mapped['id_propriedade'] = _cleanNull(source['id_propriedade']);
        if (source['id_animais'] != null)
          mapped['id_animais'] = _cleanNull(source['id_animais']);
        if (source['nome'] != null)
          mapped['nome'] = _cleanNull(source['nome']);
        if (source['anotacoes'] != null)
          mapped['anotacoes'] = _cleanNull(source['anotacoes']);
        if (source['ativo'] != null)
          mapped['ativo'] = _cleanNull(source['ativo']);
        if (source['motivo'] != null)
          mapped['motivo'] = _cleanNull(source['motivo']);
        if (source['data_motivo'] != null)
          mapped['data_motivo'] = _cleanNull(source['data_motivo'].toString());
        if (source['id_lote'] != null)
          mapped['id_lote'] = _cleanNull(source['id_lote']);
        if (source['deletado'] != null)
          mapped['deletado'] = _cleanNull(source['deletado']);
        if (source['created_at'] != null)
          mapped['created_at'] = _cleanNull(source['created_at'].toString());
        if (source['updated_at'] != null)
          mapped['updated_at'] = _cleanNull(source['updated_at'].toString());
        if (source['valorVenda'] != null)
          mapped['valorVenda'] = source['valorVenda'];
        if (source['data_entrada_piquete'] != null)
          mapped['data_entrada_piquete'] =
              _cleanNull(source['data_entrada_piquete'].toString());
        if (source['data_saida_piquete'] != null)
          mapped['data_saida_piquete'] =
              _cleanNull(source['data_saida_piquete'].toString());

        batch.insert('local_lotes', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);
    });

    return true;
  } catch (e) {
    debugPrint('Erro batch insert lotes: $e');
    return false;
  }
}

dynamic _cleanNull(dynamic value) {
  return (value == "null") ? null : value;
}
