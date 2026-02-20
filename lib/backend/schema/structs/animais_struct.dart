// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AnimaisStruct extends BaseStruct {
  AnimaisStruct({
    String? idRebanho,
    String? sexo,
    String? numeroAnimal,
    String? nome,
    String? dataNascimento,
    String? categoria,
    String? raca,
    String? loteNome,
    String? rebanhoIdMatriz,
    String? rebanhoIdReprodutor,
    String? numeroMatriz,
    String? nomeMatriz,
    String? dataNascMatriz,
    String? racaMatriz,
    String? numeroReprodutor,
    String? nomeReprodutor,
    String? dataNascReprodutor,
    String? racaReprodutor,
  })  : _idRebanho = idRebanho,
        _sexo = sexo,
        _numeroAnimal = numeroAnimal,
        _nome = nome,
        _dataNascimento = dataNascimento,
        _categoria = categoria,
        _raca = raca,
        _loteNome = loteNome,
        _rebanhoIdMatriz = rebanhoIdMatriz,
        _rebanhoIdReprodutor = rebanhoIdReprodutor,
        _numeroMatriz = numeroMatriz,
        _nomeMatriz = nomeMatriz,
        _dataNascMatriz = dataNascMatriz,
        _racaMatriz = racaMatriz,
        _numeroReprodutor = numeroReprodutor,
        _nomeReprodutor = nomeReprodutor,
        _dataNascReprodutor = dataNascReprodutor,
        _racaReprodutor = racaReprodutor;

  // "idRebanho" field.
  String? _idRebanho;
  String get idRebanho => _idRebanho ?? '';
  set idRebanho(String? val) => _idRebanho = val;

  bool hasIdRebanho() => _idRebanho != null;

  // "sexo" field.
  String? _sexo;
  String get sexo => _sexo ?? '';
  set sexo(String? val) => _sexo = val;

  bool hasSexo() => _sexo != null;

  // "numeroAnimal" field.
  String? _numeroAnimal;
  String get numeroAnimal => _numeroAnimal ?? '';
  set numeroAnimal(String? val) => _numeroAnimal = val;

  bool hasNumeroAnimal() => _numeroAnimal != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "dataNascimento" field.
  String? _dataNascimento;
  String get dataNascimento => _dataNascimento ?? '';
  set dataNascimento(String? val) => _dataNascimento = val;

  bool hasDataNascimento() => _dataNascimento != null;

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  set categoria(String? val) => _categoria = val;

  bool hasCategoria() => _categoria != null;

  // "raca" field.
  String? _raca;
  String get raca => _raca ?? '';
  set raca(String? val) => _raca = val;

  bool hasRaca() => _raca != null;

  // "loteNome" field.
  String? _loteNome;
  String get loteNome => _loteNome ?? '';
  set loteNome(String? val) => _loteNome = val;

  bool hasLoteNome() => _loteNome != null;

  // "rebanhoIdMatriz" field.
  String? _rebanhoIdMatriz;
  String get rebanhoIdMatriz => _rebanhoIdMatriz ?? '';
  set rebanhoIdMatriz(String? val) => _rebanhoIdMatriz = val;

  bool hasRebanhoIdMatriz() => _rebanhoIdMatriz != null;

  // "rebanhoIdReprodutor" field.
  String? _rebanhoIdReprodutor;
  String get rebanhoIdReprodutor => _rebanhoIdReprodutor ?? '';
  set rebanhoIdReprodutor(String? val) => _rebanhoIdReprodutor = val;

  bool hasRebanhoIdReprodutor() => _rebanhoIdReprodutor != null;

  // "numeroMatriz" field.
  String? _numeroMatriz;
  String get numeroMatriz => _numeroMatriz ?? '';
  set numeroMatriz(String? val) => _numeroMatriz = val;

  bool hasNumeroMatriz() => _numeroMatriz != null;

  // "nomeMatriz" field.
  String? _nomeMatriz;
  String get nomeMatriz => _nomeMatriz ?? '';
  set nomeMatriz(String? val) => _nomeMatriz = val;

  bool hasNomeMatriz() => _nomeMatriz != null;

  // "dataNascMatriz" field.
  String? _dataNascMatriz;
  String get dataNascMatriz => _dataNascMatriz ?? '';
  set dataNascMatriz(String? val) => _dataNascMatriz = val;

  bool hasDataNascMatriz() => _dataNascMatriz != null;

  // "racaMatriz" field.
  String? _racaMatriz;
  String get racaMatriz => _racaMatriz ?? '';
  set racaMatriz(String? val) => _racaMatriz = val;

  bool hasRacaMatriz() => _racaMatriz != null;

  // "numeroReprodutor" field.
  String? _numeroReprodutor;
  String get numeroReprodutor => _numeroReprodutor ?? '';
  set numeroReprodutor(String? val) => _numeroReprodutor = val;

  bool hasNumeroReprodutor() => _numeroReprodutor != null;

  // "nomeReprodutor" field.
  String? _nomeReprodutor;
  String get nomeReprodutor => _nomeReprodutor ?? '';
  set nomeReprodutor(String? val) => _nomeReprodutor = val;

  bool hasNomeReprodutor() => _nomeReprodutor != null;

  // "dataNascReprodutor" field.
  String? _dataNascReprodutor;
  String get dataNascReprodutor => _dataNascReprodutor ?? '';
  set dataNascReprodutor(String? val) => _dataNascReprodutor = val;

  bool hasDataNascReprodutor() => _dataNascReprodutor != null;

  // "racaReprodutor" field.
  String? _racaReprodutor;
  String get racaReprodutor => _racaReprodutor ?? '';
  set racaReprodutor(String? val) => _racaReprodutor = val;

  bool hasRacaReprodutor() => _racaReprodutor != null;

  static AnimaisStruct fromMap(Map<String, dynamic> data) => AnimaisStruct(
        idRebanho: data['idRebanho'] as String?,
        sexo: data['sexo'] as String?,
        numeroAnimal: data['numeroAnimal'] as String?,
        nome: data['nome'] as String?,
        dataNascimento: data['dataNascimento'] as String?,
        categoria: data['categoria'] as String?,
        raca: data['raca'] as String?,
        loteNome: data['loteNome'] as String?,
        rebanhoIdMatriz: data['rebanhoIdMatriz'] as String?,
        rebanhoIdReprodutor: data['rebanhoIdReprodutor'] as String?,
        numeroMatriz: data['numeroMatriz'] as String?,
        nomeMatriz: data['nomeMatriz'] as String?,
        dataNascMatriz: data['dataNascMatriz'] as String?,
        racaMatriz: data['racaMatriz'] as String?,
        numeroReprodutor: data['numeroReprodutor'] as String?,
        nomeReprodutor: data['nomeReprodutor'] as String?,
        dataNascReprodutor: data['dataNascReprodutor'] as String?,
        racaReprodutor: data['racaReprodutor'] as String?,
      );

  static AnimaisStruct? maybeFromMap(dynamic data) =>
      data is Map ? AnimaisStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'idRebanho': _idRebanho,
        'sexo': _sexo,
        'numeroAnimal': _numeroAnimal,
        'nome': _nome,
        'dataNascimento': _dataNascimento,
        'categoria': _categoria,
        'raca': _raca,
        'loteNome': _loteNome,
        'rebanhoIdMatriz': _rebanhoIdMatriz,
        'rebanhoIdReprodutor': _rebanhoIdReprodutor,
        'numeroMatriz': _numeroMatriz,
        'nomeMatriz': _nomeMatriz,
        'dataNascMatriz': _dataNascMatriz,
        'racaMatriz': _racaMatriz,
        'numeroReprodutor': _numeroReprodutor,
        'nomeReprodutor': _nomeReprodutor,
        'dataNascReprodutor': _dataNascReprodutor,
        'racaReprodutor': _racaReprodutor,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'idRebanho': serializeParam(
          _idRebanho,
          ParamType.String,
        ),
        'sexo': serializeParam(
          _sexo,
          ParamType.String,
        ),
        'numeroAnimal': serializeParam(
          _numeroAnimal,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'dataNascimento': serializeParam(
          _dataNascimento,
          ParamType.String,
        ),
        'categoria': serializeParam(
          _categoria,
          ParamType.String,
        ),
        'raca': serializeParam(
          _raca,
          ParamType.String,
        ),
        'loteNome': serializeParam(
          _loteNome,
          ParamType.String,
        ),
        'rebanhoIdMatriz': serializeParam(
          _rebanhoIdMatriz,
          ParamType.String,
        ),
        'rebanhoIdReprodutor': serializeParam(
          _rebanhoIdReprodutor,
          ParamType.String,
        ),
        'numeroMatriz': serializeParam(
          _numeroMatriz,
          ParamType.String,
        ),
        'nomeMatriz': serializeParam(
          _nomeMatriz,
          ParamType.String,
        ),
        'dataNascMatriz': serializeParam(
          _dataNascMatriz,
          ParamType.String,
        ),
        'racaMatriz': serializeParam(
          _racaMatriz,
          ParamType.String,
        ),
        'numeroReprodutor': serializeParam(
          _numeroReprodutor,
          ParamType.String,
        ),
        'nomeReprodutor': serializeParam(
          _nomeReprodutor,
          ParamType.String,
        ),
        'dataNascReprodutor': serializeParam(
          _dataNascReprodutor,
          ParamType.String,
        ),
        'racaReprodutor': serializeParam(
          _racaReprodutor,
          ParamType.String,
        ),
      }.withoutNulls;

  static AnimaisStruct fromSerializableMap(Map<String, dynamic> data) =>
      AnimaisStruct(
        idRebanho: deserializeParam(
          data['idRebanho'],
          ParamType.String,
          false,
        ),
        sexo: deserializeParam(
          data['sexo'],
          ParamType.String,
          false,
        ),
        numeroAnimal: deserializeParam(
          data['numeroAnimal'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        dataNascimento: deserializeParam(
          data['dataNascimento'],
          ParamType.String,
          false,
        ),
        categoria: deserializeParam(
          data['categoria'],
          ParamType.String,
          false,
        ),
        raca: deserializeParam(
          data['raca'],
          ParamType.String,
          false,
        ),
        loteNome: deserializeParam(
          data['loteNome'],
          ParamType.String,
          false,
        ),
        rebanhoIdMatriz: deserializeParam(
          data['rebanhoIdMatriz'],
          ParamType.String,
          false,
        ),
        rebanhoIdReprodutor: deserializeParam(
          data['rebanhoIdReprodutor'],
          ParamType.String,
          false,
        ),
        numeroMatriz: deserializeParam(
          data['numeroMatriz'],
          ParamType.String,
          false,
        ),
        nomeMatriz: deserializeParam(
          data['nomeMatriz'],
          ParamType.String,
          false,
        ),
        dataNascMatriz: deserializeParam(
          data['dataNascMatriz'],
          ParamType.String,
          false,
        ),
        racaMatriz: deserializeParam(
          data['racaMatriz'],
          ParamType.String,
          false,
        ),
        numeroReprodutor: deserializeParam(
          data['numeroReprodutor'],
          ParamType.String,
          false,
        ),
        nomeReprodutor: deserializeParam(
          data['nomeReprodutor'],
          ParamType.String,
          false,
        ),
        dataNascReprodutor: deserializeParam(
          data['dataNascReprodutor'],
          ParamType.String,
          false,
        ),
        racaReprodutor: deserializeParam(
          data['racaReprodutor'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AnimaisStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AnimaisStruct &&
        idRebanho == other.idRebanho &&
        sexo == other.sexo &&
        numeroAnimal == other.numeroAnimal &&
        nome == other.nome &&
        dataNascimento == other.dataNascimento &&
        categoria == other.categoria &&
        raca == other.raca &&
        loteNome == other.loteNome &&
        rebanhoIdMatriz == other.rebanhoIdMatriz &&
        rebanhoIdReprodutor == other.rebanhoIdReprodutor &&
        numeroMatriz == other.numeroMatriz &&
        nomeMatriz == other.nomeMatriz &&
        dataNascMatriz == other.dataNascMatriz &&
        racaMatriz == other.racaMatriz &&
        numeroReprodutor == other.numeroReprodutor &&
        nomeReprodutor == other.nomeReprodutor &&
        dataNascReprodutor == other.dataNascReprodutor &&
        racaReprodutor == other.racaReprodutor;
  }

  @override
  int get hashCode => const ListEquality().hash([
        idRebanho,
        sexo,
        numeroAnimal,
        nome,
        dataNascimento,
        categoria,
        raca,
        loteNome,
        rebanhoIdMatriz,
        rebanhoIdReprodutor,
        numeroMatriz,
        nomeMatriz,
        dataNascMatriz,
        racaMatriz,
        numeroReprodutor,
        nomeReprodutor,
        dataNascReprodutor,
        racaReprodutor
      ]);
}

AnimaisStruct createAnimaisStruct({
  String? idRebanho,
  String? sexo,
  String? numeroAnimal,
  String? nome,
  String? dataNascimento,
  String? categoria,
  String? raca,
  String? loteNome,
  String? rebanhoIdMatriz,
  String? rebanhoIdReprodutor,
  String? numeroMatriz,
  String? nomeMatriz,
  String? dataNascMatriz,
  String? racaMatriz,
  String? numeroReprodutor,
  String? nomeReprodutor,
  String? dataNascReprodutor,
  String? racaReprodutor,
}) =>
    AnimaisStruct(
      idRebanho: idRebanho,
      sexo: sexo,
      numeroAnimal: numeroAnimal,
      nome: nome,
      dataNascimento: dataNascimento,
      categoria: categoria,
      raca: raca,
      loteNome: loteNome,
      rebanhoIdMatriz: rebanhoIdMatriz,
      rebanhoIdReprodutor: rebanhoIdReprodutor,
      numeroMatriz: numeroMatriz,
      nomeMatriz: nomeMatriz,
      dataNascMatriz: dataNascMatriz,
      racaMatriz: racaMatriz,
      numeroReprodutor: numeroReprodutor,
      nomeReprodutor: nomeReprodutor,
      dataNascReprodutor: dataNascReprodutor,
      racaReprodutor: racaReprodutor,
    );
