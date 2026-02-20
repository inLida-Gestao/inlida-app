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

Future<bool> batchInsertLocalSanidade(List<dynamic> records) async {
  if (records.isEmpty) return true;

  try {
    final db = SQLiteManager.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final record in records) {
        final Map<String, dynamic> source = Map<String, dynamic>.from(record);
        final Map<String, dynamic> mapped = {};

        // Mapeamento específico Supabase -> SQLite
        if (source['created_at'] != null)
          mapped['created_at'] = _cleanNull(source['created_at']);
        if (source['id_propriedade'] != null)
          mapped['id_propriedade'] = _cleanNull(source['id_propriedade']);
        if (source['id_rebanho'] != null)
          mapped['id_rebanho'] = _cleanNull(source['id_rebanho']);
        if (source['data_sanidade'] != null)
          mapped['data_sanidade'] = _cleanNull(source['data_sanidade']);
        if (source['id_lote'] != null)
          mapped['id_lote'] = _cleanNull(source['id_lote']);
        if (source['porcentagem_lote'] != null)
          mapped['porcentagem_lote'] = source['porcentagem_lote'];
        if (source['id_sanidade'] != null)
          mapped['id_sanidade'] = _cleanNull(source['id_sanidade']);
        if (source['updated_at'] != null)
          mapped['updated_at'] = _cleanNull(source['updated_at']);
        if (source['deletado'] != null)
          mapped['deletado'] = _cleanNull(source['deletado']);
        if (source['vacinacao'] != null)
          mapped['vacinacao'] = _cleanNull(source['vacinacao']);
        if (source['vacinacao_outros'] != null)
          mapped['vacinacao_outros'] = _cleanNull(source['vacinacao_outros']);
        if (source['vacinacao_obs'] != null)
          mapped['vacinacao_obs'] = _cleanNull(source['vacinacao_obs']);
        if (source['antiparasitario'] != null)
          mapped['antiparasitario'] = _cleanNull(source['antiparasitario']);
        if (source['antiparasitario_outros'] != null)
          mapped['antiparasitario_outros'] =
              _cleanNull(source['antiparasitario_outros']);
        if (source['antiparasitario_obs'] != null)
          mapped['antiparasitario_obs'] =
              _cleanNull(source['antiparasitario_obs']);
        if (source['tratamento'] != null)
          mapped['tratamento'] = _cleanNull(source['tratamento']);
        if (source['tratamento_outros'] != null)
          mapped['tratamento_outros'] = _cleanNull(source['tratamento_outros']);
        if (source['tratamento_obs'] != null)
          mapped['tratamento_obs'] = _cleanNull(source['tratamento_obs']);
        if (source['protocolo_reprodutivo'] != null)
          mapped['protocolo_reprodutivo'] =
              _cleanNull(source['protocolo_reprodutivo']);
        if (source['protocolo_reprodutivo_outros'] != null)
          mapped['protocolo_reprodutivo_outros'] =
              _cleanNull(source['protocolo_reprodutivo_outros']);
        if (source['protocolo_reprodutivo_obs'] != null)
          mapped['protocolo_reprodutivo_obs'] =
              _cleanNull(source['protocolo_reprodutivo_obs']);
        if (source['protocolo_d0'] != null)
          mapped['protocolo_d0'] = _cleanNull(source['protocolo_d0']);
        if (source['protocolo_retirada'] != null)
          mapped['protocolo_retirada'] =
              _cleanNull(source['protocolo_retirada']);
        if (source['protocolo_iatf'] != null)
          mapped['protocolo_iatf'] = _cleanNull(source['protocolo_iatf']);

        batch.insert('local_sanidade', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);
    });

    return true;
  } catch (e) {
    return false;
  }
}

dynamic _cleanNull(dynamic value) {
  return (value == "null") ? null : value;
}
