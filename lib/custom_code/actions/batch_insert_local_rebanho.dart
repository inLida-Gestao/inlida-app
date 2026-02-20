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

Future<bool> batchInsertLocalRebanho(List<dynamic> records) async {
  if (records.isEmpty) return true;

  try {
    final db = SQLiteManager.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final record in records) {
        final Map<String, dynamic> source = Map<String, dynamic>.from(record);
        final Map<String, dynamic> mapped = {};

        // Mapeamento específico Supabase -> SQLite
        if (source['idPropriedade'] != null)
          mapped['idPropriedade'] = _cleanNull(source['idPropriedade']);
        if (source['numeroAnimal'] != null)
          mapped['numeroAnimal'] = _cleanNull(source['numeroAnimal']);
        if (source['chip'] != null) mapped['chip'] = _cleanNull(source['chip']);
        if (source['codRegistro'] != null)
          mapped['codRegistro'] = _cleanNull(source['codRegistro']);
        if (source['nome'] != null) mapped['nome'] = _cleanNull(source['nome']);
        if (source['sexo'] != null) mapped['sexo'] = _cleanNull(source['sexo']);
        if (source['categoria'] != null)
          mapped['categoria'] = _cleanNull(source['categoria']);
        if (source['dataNascimento'] != null)
          mapped['dataNascimento'] = _cleanNull(source['dataNascimento']);
        if (source['pesoNascimento'] != null)
          mapped['pesoNascimento'] = source['pesoNascimento'];
        if (source['porte'] != null)
          mapped['porte'] = _cleanNull(source['porte']);
        if (source['raca'] != null) mapped['raca'] = _cleanNull(source['raca']);
        if (source['loteID'] != null)
          mapped['loteID'] = _cleanNull(source['loteID']);
        if (source['dataEntradaLote'] != null)
          mapped['dataEntradaLote'] = _cleanNull(source['dataEntradaLote']);
        if (source['rebanhoIdMatriz'] != null)
          mapped['rebanhoIdMatriz'] = _cleanNull(source['rebanhoIdMatriz']);
        if (source['rebanhoIdReprodutor'] != null)
          mapped['rebanhoIdReprodutor'] =
              _cleanNull(source['rebanhoIdReprodutor']);
        if (source['dataDesmama'] != null)
          mapped['dataDesmama'] = _cleanNull(source['dataDesmama']);
        if (source['pesoDesmama'] != null)
          mapped['pesoDesmama'] = source['pesoDesmama'];
        if (source['pesoAtual'] != null)
          mapped['pesoAtual'] = source['pesoAtual'];
        if (source['status'] != null)
          mapped['statusRebanho'] =
              _cleanNull(source['status']); // MAPEAMENTO CRÍTICO
        if (source['origem'] != null)
          mapped['origem'] = _cleanNull(source['origem']);
        if (source['anotacoes'] != null)
          mapped['anotacoes'] = _cleanNull(source['anotacoes']);
        if (source['idRebanho'] != null)
          mapped['idRebanho'] = _cleanNull(source['idRebanho']);
        if (source['deletado'] != null)
          mapped['deletado'] = _cleanNull(source['deletado']);
        if (source['created_at'] != null)
          mapped['created_at'] = _cleanNull(source['created_at']);
        if (source['updated_at'] != null)
          mapped['updated_at'] = _cleanNull(source['updated_at']);
        if (source['loteNome'] != null)
          mapped['loteNome'] = _cleanNull(source['loteNome']);
        if (source['tipo'] != null) mapped['tipo'] = _cleanNull(source['tipo']);
        if (source['dataAcao'] != null)
          mapped['dataAcao'] = _cleanNull(source['dataAcao']);
        if (source['valorCompra'] != null)
          mapped['valorCompra'] = source['valorCompra'];
        if (source['dataUltimaPesagem'] != null)
          mapped['dataUltimaPesagem'] = _cleanNull(source['dataUltimaPesagem']);
        if (source['nomeConcat'] != null)
          mapped['nomeConcat'] = _cleanNull(source['nomeConcat']);
        if (source['dataVenda'] != null)
          mapped['dataVenda'] = _cleanNull(source['dataVenda']);
        if (source['valorVenda'] != null)
          mapped['valorVenda'] = source['valorVenda'];
        if (source['movimentacao_entrada'] != null)
          mapped['movimentacao_entrada'] =
              _cleanNull(source['movimentacao_entrada']);
        if (source['numeroMatriz'] != null)
          mapped['numeroMatriz'] = _cleanNull(source['numeroMatriz']);
        if (source['nomeMatriz'] != null)
          mapped['nomeMatriz'] = _cleanNull(source['nomeMatriz']);
        if (source['dataNascMatriz'] != null)
          mapped['dataNascMatriz'] = _cleanNull(source['dataNascMatriz']);
        if (source['racaMatriz'] != null)
          mapped['racaMatriz'] = _cleanNull(source['racaMatriz']);
        if (source['numeroReprodutor'] != null)
          mapped['numeroReprodutor'] = _cleanNull(source['numeroReprodutor']);
        if (source['nomeReprodutor'] != null)
          mapped['nomeReprodutor'] = _cleanNull(source['nomeReprodutor']);
        if (source['dataNascReprodutor'] != null)
          mapped['dataNascReprodutor'] =
              _cleanNull(source['dataNascReprodutor']);
        if (source['racaReprodutor'] != null)
          mapped['racaReprodutor'] = _cleanNull(source['racaReprodutor']);
        if (source['movimentacao_saida'] != null)
          mapped['movimentacao_saida'] =
              _cleanNull(source['movimentacao_saida']);
        if (source['data_morte'] != null)
          mapped['data_morte'] = _cleanNull(source['data_morte']);
        if (source['motivo_morte'] != null)
          mapped['motivo_morte'] = _cleanNull(source['motivo_morte']);
        if (source['categoria_matriz'] != null)
          mapped['categoria_matriz'] = _cleanNull(source['categoria_matriz']);

        batch.insert('local_rebanho', mapped,
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
