// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LocalLotesStruct extends BaseStruct {
  LocalLotesStruct({
    String? idLote,
    String? nome,
  })  : _idLote = idLote,
        _nome = nome;

  // "idLote" field.
  String? _idLote;
  String get idLote => _idLote ?? '';
  set idLote(String? val) => _idLote = val;

  bool hasIdLote() => _idLote != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  static LocalLotesStruct fromMap(Map<String, dynamic> data) =>
      LocalLotesStruct(
        idLote: data['idLote'] as String?,
        nome: data['nome'] as String?,
      );

  static LocalLotesStruct? maybeFromMap(dynamic data) => data is Map
      ? LocalLotesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'idLote': _idLote,
        'nome': _nome,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'idLote': serializeParam(
          _idLote,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
      }.withoutNulls;

  static LocalLotesStruct fromSerializableMap(Map<String, dynamic> data) =>
      LocalLotesStruct(
        idLote: deserializeParam(
          data['idLote'],
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
  String toString() => 'LocalLotesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LocalLotesStruct &&
        idLote == other.idLote &&
        nome == other.nome;
  }

  @override
  int get hashCode => const ListEquality().hash([idLote, nome]);
}

LocalLotesStruct createLocalLotesStruct({
  String? idLote,
  String? nome,
}) =>
    LocalLotesStruct(
      idLote: idLote,
      nome: nome,
    );
