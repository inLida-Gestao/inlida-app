// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PropriedadeSelecionadaStruct extends BaseStruct {
  PropriedadeSelecionadaStruct({
    String? idPropriedade,
    String? nome,
  })  : _idPropriedade = idPropriedade,
        _nome = nome;

  // "idPropriedade" field.
  String? _idPropriedade;
  String get idPropriedade => _idPropriedade ?? '';
  set idPropriedade(String? val) => _idPropriedade = val;

  bool hasIdPropriedade() => _idPropriedade != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  static PropriedadeSelecionadaStruct fromMap(Map<String, dynamic> data) =>
      PropriedadeSelecionadaStruct(
        idPropriedade: data['idPropriedade'] as String?,
        nome: data['nome'] as String?,
      );

  static PropriedadeSelecionadaStruct? maybeFromMap(dynamic data) => data is Map
      ? PropriedadeSelecionadaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'idPropriedade': _idPropriedade,
        'nome': _nome,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'idPropriedade': serializeParam(
          _idPropriedade,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
      }.withoutNulls;

  static PropriedadeSelecionadaStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PropriedadeSelecionadaStruct(
        idPropriedade: deserializeParam(
          data['idPropriedade'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PropriedadeSelecionadaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PropriedadeSelecionadaStruct &&
        idPropriedade == other.idPropriedade &&
        nome == other.nome;
  }

  @override
  int get hashCode => const ListEquality().hash([idPropriedade, nome]);
}

PropriedadeSelecionadaStruct createPropriedadeSelecionadaStruct({
  String? idPropriedade,
  String? nome,
}) =>
    PropriedadeSelecionadaStruct(
      idPropriedade: idPropriedade,
      nome: nome,
    );
