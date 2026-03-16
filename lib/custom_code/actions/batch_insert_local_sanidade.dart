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

import 'dart:convert';
import 'package:sqflite/sqflite.dart';

Future<Map<String, dynamic>> batchInsertLocalSanidade(
    List<dynamic> records) async {
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

      // Mapeamento específico Supabase -> SQLite
      if (source['created_at'] != null) {
        mapped['created_at'] = _cleanNull(source['created_at']);
      }
      if (source['id_propriedade'] != null) {
        mapped['id_propriedade'] = _cleanNull(source['id_propriedade']);
      }
      if (source['id_rebanho'] != null) {
        mapped['id_rebanho'] = _cleanNull(source['id_rebanho']);
      }
      if (source['data_sanidade'] != null) {
        mapped['data_sanidade'] = _cleanNull(source['data_sanidade']);
      }
      if (source['id_lote'] != null) {
        mapped['id_lote'] = _cleanNull(source['id_lote']);
      }
      if (source['porcentagem_lote'] != null) {
        mapped['porcentagem_lote'] = source['porcentagem_lote'];
      }
      if (source['id_sanidade'] != null) {
        mapped['id_sanidade'] = _cleanNull(source['id_sanidade']);
      }
      if (source['updated_at'] != null) {
        mapped['updated_at'] = _cleanNull(source['updated_at']);
      }
      if (source['deletado'] != null) {
        mapped['deletado'] = _cleanNull(source['deletado']);
      }
      if (source['vacinacao'] != null) {
        mapped['vacinacao'] = _cleanNull(source['vacinacao']);
      }
      if (source['vacinacao_outros'] != null) {
        mapped['vacinacao_outros'] = _cleanNull(source['vacinacao_outros']);
      }
      if (source['vacinacao_obs'] != null) {
        mapped['vacinacao_obs'] = _cleanNull(source['vacinacao_obs']);
      }
      if (source['antiparasitario'] != null) {
        mapped['antiparasitario'] = _cleanNull(source['antiparasitario']);
      }
      if (source['antiparasitario_outros'] != null) {
        mapped['antiparasitario_outros'] =
            _cleanNull(source['antiparasitario_outros']);
      }
      if (source['antiparasitario_obs'] != null) {
        mapped['antiparasitario_obs'] =
            _cleanNull(source['antiparasitario_obs']);
      }
      if (source['tratamento'] != null) {
        mapped['tratamento'] = _cleanNull(source['tratamento']);
      }
      if (source['tratamento_outros'] != null) {
        mapped['tratamento_outros'] = _cleanNull(source['tratamento_outros']);
      }
      if (source['tratamento_obs'] != null) {
        mapped['tratamento_obs'] = _cleanNull(source['tratamento_obs']);
      }
      if (source['protocolo_reprodutivo'] != null) {
        mapped['protocolo_reprodutivo'] =
            _cleanNull(source['protocolo_reprodutivo']);
      }
      if (source['protocolo_reprodutivo_outros'] != null) {
        mapped['protocolo_reprodutivo_outros'] =
            _cleanNull(source['protocolo_reprodutivo_outros']);
      }
      if (source['protocolo_reprodutivo_obs'] != null) {
        mapped['protocolo_reprodutivo_obs'] =
            _cleanNull(source['protocolo_reprodutivo_obs']);
      }
      if (source['protocolo_d0'] != null) {
        mapped['protocolo_d0'] = _cleanNull(source['protocolo_d0']);
      }
      if (source['protocolo_retirada'] != null) {
        mapped['protocolo_retirada'] = _cleanNull(source['protocolo_retirada']);
      }
      if (source['protocolo_iatf'] != null) {
        mapped['protocolo_iatf'] = _cleanNull(source['protocolo_iatf']);
      }

      mappedRecords.add(mapped);
    } catch (e) {
      final id = _extractSanidadeId(records[i]);
      errors.add({'id': id, 'error': 'Erro ao mapear: $e'});
    }
  }

  // Fase 2: Tentar batch insert
  try {
    final db = SQLiteManager.instance.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final mapped in mappedRecords) {
        batch.insert('local_sanidade', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    return {'inserted': mappedRecords.length, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][sanidade] Batch falhou ($batchError). Inserindo individualmente...');
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;

    for (final mapped in mappedRecords) {
      try {
        await db.insert('local_sanidade', mapped,
            conflictAlgorithm: ConflictAlgorithm.replace);
        insertedCount++;
      } catch (e) {
        final id = mapped['id_sanidade']?.toString() ??
            mapped['id_rebanho']?.toString() ??
            'desconhecido';
        errors.add({'id': id, 'error': e.toString()});
      }
    }

    return {'inserted': insertedCount, 'errors': errors};
  }
}

String _extractSanidadeId(dynamic record) {
  if (record is Map) {
    return record['id_sanidade']?.toString() ??
        record['id_rebanho']?.toString() ??
        'desconhecido';
  }
  return 'desconhecido';
}

dynamic _cleanNull(dynamic value) {
  if (value == "null") return null;
  // Se o valor for uma List ou Map (ex: campo jsonb do Supabase),
  // converte para JSON string para armazenar corretamente no SQLite
  if (value is List || value is Map) {
    return jsonEncode(value);
  }
  return value;
}
