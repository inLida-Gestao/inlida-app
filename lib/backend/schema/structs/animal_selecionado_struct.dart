// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AnimalSelecionadoStruct extends BaseStruct {
  AnimalSelecionadoStruct({
    String? numAnimal,
    String? nomeAnimal,
    String? dataNascAnimal,
    String? racaAnimal,
    String? idRebanho,
    String? chip,
    String? categoria,
  })  : _numAnimal = numAnimal,
        _nomeAnimal = nomeAnimal,
        _dataNascAnimal = dataNascAnimal,
        _racaAnimal = racaAnimal,
        _idRebanho = idRebanho,
        _chip = chip,
        _categoria = categoria;

  // "numAnimal" field.
  String? _numAnimal;
  String get numAnimal => _numAnimal ?? '';
  set numAnimal(String? val) => _numAnimal = val;

  bool hasNumAnimal() => _numAnimal != null;

  // "nomeAnimal" field.
  String? _nomeAnimal;
  String get nomeAnimal => _nomeAnimal ?? '';
  set nomeAnimal(String? val) => _nomeAnimal = val;

  bool hasNomeAnimal() => _nomeAnimal != null;

  // "dataNascAnimal" field.
  String? _dataNascAnimal;
  String get dataNascAnimal => _dataNascAnimal ?? '';
  set dataNascAnimal(String? val) => _dataNascAnimal = val;

  bool hasDataNascAnimal() => _dataNascAnimal != null;

  // "racaAnimal" field.
  String? _racaAnimal;
  String get racaAnimal => _racaAnimal ?? '';
  set racaAnimal(String? val) => _racaAnimal = val;

  bool hasRacaAnimal() => _racaAnimal != null;

  // "idRebanho" field.
  String? _idRebanho;
  String get idRebanho => _idRebanho ?? '';
  set idRebanho(String? val) => _idRebanho = val;

  bool hasIdRebanho() => _idRebanho != null;

  // "chip" field.
  String? _chip;
  String get chip => _chip ?? '';
  set chip(String? val) => _chip = val;

  bool hasChip() => _chip != null;

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  set categoria(String? val) => _categoria = val;

  bool hasCategoria() => _categoria != null;

  static AnimalSelecionadoStruct fromMap(Map<String, dynamic> data) =>
      AnimalSelecionadoStruct(
        numAnimal: data['numAnimal'] as String?,
        nomeAnimal: data['nomeAnimal'] as String?,
        dataNascAnimal: data['dataNascAnimal'] as String?,
        racaAnimal: data['racaAnimal'] as String?,
        idRebanho: data['idRebanho'] as String?,
        chip: data['chip'] as String?,
        categoria: data['categoria'] as String?,
      );

  static AnimalSelecionadoStruct? maybeFromMap(dynamic data) => data is Map
      ? AnimalSelecionadoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'numAnimal': _numAnimal,
        'nomeAnimal': _nomeAnimal,
        'dataNascAnimal': _dataNascAnimal,
        'racaAnimal': _racaAnimal,
        'idRebanho': _idRebanho,
        'chip': _chip,
        'categoria': _categoria,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'numAnimal': serializeParam(
          _numAnimal,
          ParamType.String,
        ),
        'nomeAnimal': serializeParam(
          _nomeAnimal,
          ParamType.String,
        ),
        'dataNascAnimal': serializeParam(
          _dataNascAnimal,
          ParamType.String,
        ),
        'racaAnimal': serializeParam(
          _racaAnimal,
          ParamType.String,
        ),
        'idRebanho': serializeParam(
          _idRebanho,
          ParamType.String,
        ),
        'chip': serializeParam(
          _chip,
          ParamType.String,
        ),
        'categoria': serializeParam(
          _categoria,
          ParamType.String,
        ),
      }.withoutNulls;

  static AnimalSelecionadoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AnimalSelecionadoStruct(
        numAnimal: deserializeParam(
          data['numAnimal'],
          ParamType.String,
          false,
        ),
        nomeAnimal: deserializeParam(
          data['nomeAnimal'],
          ParamType.String,
          false,
        ),
        dataNascAnimal: deserializeParam(
          data['dataNascAnimal'],
          ParamType.String,
          false,
        ),
        racaAnimal: deserializeParam(
          data['racaAnimal'],
          ParamType.String,
          false,
        ),
        idRebanho: deserializeParam(
          data['idRebanho'],
          ParamType.String,
          false,
        ),
        chip: deserializeParam(
          data['chip'],
          ParamType.String,
          false,
        ),
        categoria: deserializeParam(
          data['categoria'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AnimalSelecionadoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AnimalSelecionadoStruct &&
        numAnimal == other.numAnimal &&
        nomeAnimal == other.nomeAnimal &&
        dataNascAnimal == other.dataNascAnimal &&
        racaAnimal == other.racaAnimal &&
        idRebanho == other.idRebanho &&
        chip == other.chip &&
        categoria == other.categoria;
  }

  @override
  int get hashCode => const ListEquality().hash([
        numAnimal,
        nomeAnimal,
        dataNascAnimal,
        racaAnimal,
        idRebanho,
        chip,
        categoria
      ]);
}

AnimalSelecionadoStruct createAnimalSelecionadoStruct({
  String? numAnimal,
  String? nomeAnimal,
  String? dataNascAnimal,
  String? racaAnimal,
  String? idRebanho,
  String? chip,
  String? categoria,
}) =>
    AnimalSelecionadoStruct(
      numAnimal: numAnimal,
      nomeAnimal: nomeAnimal,
      dataNascAnimal: dataNascAnimal,
      racaAnimal: racaAnimal,
      idRebanho: idRebanho,
      chip: chip,
      categoria: categoria,
    );
