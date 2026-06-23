// Automatic FlutterFlow imports
import '/backend/sqlite/sqlite_manager.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:sqflite/sqflite.dart';

String? _cleanNull(dynamic value) {
  if (value == null || value == 'null' || value == '') return null;
  return value.toString();
}

double? _toDouble(dynamic value) {
  if (value == null || value == 'null') return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Normaliza datas ISO (ex: "2026-01-15T00:00:00+00:00") para "yyyy-MM-dd"
/// para evitar duplicatas no índice UNIQUE legado de pesagens.
String? _normalizeDateToYMD(dynamic value) {
  if (value == null || value == 'null') return null;
  final str = value.toString().trim();
  if (str.isEmpty) return null;
  if (str.length == 10 && RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(str)) {
    return str;
  }
  final dt = DateTime.tryParse(str);
  if (dt != null) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
  return str;
}

String _formatPesoKey(dynamic value) {
  final parsed = _toDouble(value);
  if (parsed == null) return '';
  return parsed.toStringAsFixed(3);
}

String? _stablePesagemId(Map<String, dynamic> source) {
  final explicit =
      source['id_pesagem'] ?? source['idPesagem'] ?? source['idpesagem'];
  final cleanedExplicit = _cleanNull(explicit);
  if (cleanedExplicit != null) return cleanedExplicit;

  final remoteId = _cleanNull(source['id']);
  if (remoteId != null) return 'legacy_remote:$remoteId';

  final idRebanho =
      source['idRebanho'] ?? source['idrebanho'] ?? source['id_rebanho'];
  final dataPesagem =
      source['dataPesagem'] ?? source['datapesagem'] ?? source['data_pesagem'];
  return 'legacy:${_cleanNull(idRebanho) ?? ''}|'
      '${_normalizeDateToYMD(dataPesagem) ?? ''}|'
      '${_cleanNull(source['tipo']) ?? ''}|'
      '${_formatPesoKey(source['peso'])}|'
      '${_cleanNull(source['created_at'] ?? source['createdAt']) ?? ''}';
}

Future<Map<String, dynamic>> batchInsertLocalPesagens(
    List<dynamic> records) async {
  if (records.isEmpty) {
    return {'inserted': 0, 'errors': <Map<String, String>>[]};
  }

  final List<Map<String, dynamic>> mappedRecords = [];
  final List<Map<String, String>> errors = [];

  for (int i = 0; i < records.length; i++) {
    try {
      final Map<String, dynamic> source = Map<String, dynamic>.from(records[i]);
      final Map<String, dynamic> mapped = {};
      mapped['id_pesagem'] = _stablePesagemId(source);

      // Mapeamento específico Supabase -> SQLite (com fallback para snake_case)
      final idRebanho =
          source['idRebanho'] ?? source['idrebanho'] ?? source['id_rebanho'];
      if (idRebanho != null) {
        mapped['idRebanho'] = _cleanNull(idRebanho);
      }
      final dataPesagem = source['dataPesagem'] ??
          source['datapesagem'] ??
          source['data_pesagem'];
      if (dataPesagem != null) {
        mapped['dataPesagem'] = _normalizeDateToYMD(dataPesagem);
      }
      if (source['tipo'] != null) {
        mapped['tipo'] = _cleanNull(source['tipo']);
      }
      if (source['peso'] != null) {
        mapped['peso'] = _toDouble(source['peso']);
      }
      final deletado = source['deletado'];
      if (deletado != null) {
        mapped['deletado'] = _cleanNull(deletado) ?? 'NAO';
      } else {
        mapped['deletado'] = 'NAO';
      }
      final createdAt = source['created_at'] ?? source['createdAt'];
      if (createdAt != null) {
        mapped['created_at'] = _cleanNull(createdAt);
      }
      final idPropriedade = source['id_propriedade'] ??
          source['idPropriedade'] ??
          source['idpropriedade'];
      if (idPropriedade != null) {
        mapped['id_propriedade'] = _cleanNull(idPropriedade);
      }
      mapped['sync_dirty'] = 0;
      mapped['sync_op'] = null;
      mapped['sync_updated_at'] = null;

      mappedRecords.add(mapped);
    } catch (e) {
      final id = _extractPesagemId(records[i]);
      errors.add({'id': id, 'error': 'Erro ao mapear: $e'});
    }
  }

  // Tentar batch insert
  try {
    final dedupedRecords = _dedupMappedPesagens(mappedRecords);
    final db = SQLiteManager.instance.database;
    await db.transaction((txn) async {
      for (final mapped in dedupedRecords) {
        await _replaceLocalPesagem(txn, mapped);
      }
    });

    return {'inserted': dedupedRecords.length, 'errors': errors};
  } catch (batchError) {
    debugPrint(
        '[SYNC][pesagens] Batch falhou ($batchError). Inserindo individualmente...');
    final db = SQLiteManager.instance.database;
    int insertedCount = 0;

    for (final mapped in _dedupMappedPesagens(mappedRecords)) {
      try {
        await _replaceLocalPesagem(db, mapped);
        insertedCount++;
      } catch (e) {
        final id = mapped['idRebanho']?.toString() ?? 'desconhecido';
        errors.add({'id': id, 'error': e.toString()});
      }
    }

    return {'inserted': insertedCount, 'errors': errors};
  }
}

Future<void> _replaceLocalPesagem(
  DatabaseExecutor db,
  Map<String, dynamic> mapped,
) async {
  final idPesagem = _cleanNull(mapped['id_pesagem']);
  if (idPesagem != null) {
    await db.delete(
      'local_historico_pesagens',
      where: 'id_pesagem = ? AND COALESCE(sync_dirty, 0) = 0',
      whereArgs: [idPesagem],
    );
  }

  final idRebanho = _cleanNull(mapped['idRebanho']);
  final dataPesagem = _cleanNull(mapped['dataPesagem']);
  final tipo = _cleanNull(mapped['tipo']);
  final pesoKey = _formatPesoKey(mapped['peso']);
  final createdAt = _cleanNull(mapped['created_at']);
  if (idRebanho != null &&
      dataPesagem != null &&
      tipo != null &&
      pesoKey.isNotEmpty) {
    await db.delete(
      'local_historico_pesagens',
      where: '''
        idRebanho = ?
        AND dataPesagem = ?
        AND tipo = ?
        AND printf('%.3f', CAST(peso AS REAL)) = ?
        AND COALESCE(deletado, 'NAO') != 'SIM'
        AND COALESCE(sync_op, '') != 'delete'
      ''',
      whereArgs: [idRebanho, dataPesagem, tipo, pesoKey],
    );
  }

  if (idRebanho != null &&
      dataPesagem != null &&
      tipo != null &&
      pesoKey.isNotEmpty &&
      createdAt != null) {
    await db.delete(
      'local_historico_pesagens',
      where: '''
        idRebanho = ?
        AND dataPesagem = ?
        AND tipo = ?
        AND printf('%.3f', CAST(peso AS REAL)) = ?
        AND created_at = ?
        AND COALESCE(sync_dirty, 0) = 0
      ''',
      whereArgs: [idRebanho, dataPesagem, tipo, pesoKey, createdAt],
    );
  }

  await db.insert(
    'local_historico_pesagens',
    mapped,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

List<Map<String, dynamic>> _dedupMappedPesagens(
    List<Map<String, dynamic>> mappedRecords) {
  final byKey = <String, Map<String, dynamic>>{};
  for (final mapped in mappedRecords) {
    final idPesagem = _cleanNull(mapped['id_pesagem']);
    final fallback = [
      _cleanNull(mapped['idRebanho']) ?? '',
      _cleanNull(mapped['dataPesagem']) ?? '',
      _cleanNull(mapped['tipo']) ?? '',
      _formatPesoKey(mapped['peso']),
      _cleanNull(mapped['created_at']) ?? '',
    ].join('|');
    byKey[idPesagem ?? fallback] = mapped;
  }
  return byKey.values.toList();
}

String _extractPesagemId(dynamic record) {
  if (record is Map) {
    return record['id_pesagem']?.toString() ??
        record['id_rebanho']?.toString() ??
        'desconhecido';
  }
  return 'desconhecido';
}
