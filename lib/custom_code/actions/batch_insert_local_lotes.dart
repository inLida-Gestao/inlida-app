// Automatic FlutterFlow imports
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
import 'dart:convert';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<Map<String, dynamic>> batchInsertLocalLotes(
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

      if (source.containsKey('id_propriedade')) {
        mapped['id_propriedade'] = _cleanNull(source['id_propriedade']);
      }
      if (source.containsKey('nome')) {
        mapped['nome'] = _cleanNull(source['nome']);
      }
      if (source.containsKey('anotacoes')) {
        mapped['anotacoes'] = _cleanNull(source['anotacoes']);
      }
      if (source.containsKey('ativo')) {
        mapped['ativo'] = _cleanNull(source['ativo']);
      }
      if (source.containsKey('motivo')) {
        mapped['motivo'] = _cleanNull(source['motivo']);
      }
      if (source.containsKey('data_motivo')) {
        mapped['data_motivo'] = _cleanNull(source['data_motivo']?.toString());
      }
      if (source.containsKey('id_lote')) {
        mapped['id_lote'] = _cleanNull(source['id_lote']);
      }
      if (source.containsKey('deletado')) {
        mapped['deletado'] = _cleanNull(source['deletado']);
      }
      if (source.containsKey('created_at')) {
        mapped['created_at'] = _cleanNull(source['created_at']?.toString());
      }
      if (source.containsKey('updated_at')) {
        mapped['updated_at'] = _cleanNull(source['updated_at']?.toString());
      }
      if (source.containsKey('valorVenda')) {
        mapped['valorVenda'] = source['valorVenda'];
      }
      if (source.containsKey('data_entrada_piquete')) {
        mapped['data_entrada_piquete'] =
            _cleanNull(source['data_entrada_piquete']?.toString());
      }
      if (source.containsKey('data_saida_piquete')) {
        mapped['data_saida_piquete'] =
            _cleanNull(source['data_saida_piquete']?.toString());
      }
      mapped['sync_dirty'] = 0;
      mapped['sync_op'] = null;
      mapped['sync_updated_at'] = null;

      mappedRecords.add(mapped);
    } catch (e) {
      final id =
          (records[i] is Map ? records[i]['id_lote']?.toString() : null) ??
              'desconhecido';
      errors.add({'id': id, 'error': 'Erro ao mapear: $e'});
    }
  }

  // Fase 2: Fazer upsert manual por id_lote. Não depender de UNIQUE INDEX:
  // bases antigas podem já ter duplicatas, fazendo o índice falhar.
  try {
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;
    await db.transaction((txn) async {
      for (final mapped in mappedRecords) {
        final idLote = mapped['id_lote']?.toString().trim();
        if (idLote == null || idLote.isEmpty || idLote == 'null') {
          errors.add({
            'id': 'desconhecido',
            'error': 'Registro de lote remoto sem id_lote',
          });
          continue;
        }

        final existingRows = await txn.query(
          'local_lotes',
          columns: ['id'],
          where: 'id_lote = ?',
          whereArgs: [idLote],
          orderBy: 'id DESC',
        );

        if (existingRows.isEmpty) {
          await txn.insert('local_lotes', mapped);
          insertedCount++;
          continue;
        }

        final keepId = existingRows.first['id'];
        await txn.update(
          'local_lotes',
          mapped,
          where: 'id = ?',
          whereArgs: [keepId],
        );
        insertedCount++;

        if (existingRows.length > 1) {
          final duplicateIds = existingRows
              .skip(1)
              .map((row) => row['id'])
              .whereType<int>()
              .toList();
          if (duplicateIds.isNotEmpty) {
            final placeholders =
                List.filled(duplicateIds.length, '?').join(',');
            await txn.delete(
              'local_lotes',
              where: 'id IN ($placeholders)',
              whereArgs: duplicateIds,
            );
          }
        }
      }
    });
    return {'inserted': insertedCount, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][lotes] Upsert transacional falhou ($batchError). Inserindo individualmente...');
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;

    for (final mapped in mappedRecords) {
      try {
        final idLote = mapped['id_lote']?.toString().trim();
        if (idLote == null || idLote.isEmpty || idLote == 'null') {
          throw StateError('Registro de lote remoto sem id_lote');
        }
        final updated = await db.update(
          'local_lotes',
          mapped,
          where: 'id_lote = ?',
          whereArgs: [idLote],
        );
        if (updated == 0) {
          await db.insert('local_lotes', mapped);
        }
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
