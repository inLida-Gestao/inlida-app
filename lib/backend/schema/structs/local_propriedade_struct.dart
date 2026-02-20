// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LocalPropriedadeStruct extends BaseStruct {
  LocalPropriedadeStruct({
    String? nome,
    String? idPropriedade,
    String? usersID,
    String? anotacoes,
    int? areaAgricultura,
    int? areaBenfeitoria,
    int? areaPastagem,
    int? areaReserva,
    int? areaTotal,
    String? cidade,
    String? estado,
    String? icone,
    String? atividades,
    String? userID,
  })  : _nome = nome,
        _idPropriedade = idPropriedade,
        _usersID = usersID,
        _anotacoes = anotacoes,
        _areaAgricultura = areaAgricultura,
        _areaBenfeitoria = areaBenfeitoria,
        _areaPastagem = areaPastagem,
        _areaReserva = areaReserva,
        _areaTotal = areaTotal,
        _cidade = cidade,
        _estado = estado,
        _icone = icone,
        _atividades = atividades,
        _userID = userID;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "idPropriedade" field.
  String? _idPropriedade;
  String get idPropriedade => _idPropriedade ?? '';
  set idPropriedade(String? val) => _idPropriedade = val;

  bool hasIdPropriedade() => _idPropriedade != null;

  // "usersID" field.
  String? _usersID;
  String get usersID => _usersID ?? '';
  set usersID(String? val) => _usersID = val;

  bool hasUsersID() => _usersID != null;

  // "anotacoes" field.
  String? _anotacoes;
  String get anotacoes => _anotacoes ?? '';
  set anotacoes(String? val) => _anotacoes = val;

  bool hasAnotacoes() => _anotacoes != null;

  // "areaAgricultura" field.
  int? _areaAgricultura;
  int get areaAgricultura => _areaAgricultura ?? 0;
  set areaAgricultura(int? val) => _areaAgricultura = val;

  void incrementAreaAgricultura(int amount) =>
      areaAgricultura = areaAgricultura + amount;

  bool hasAreaAgricultura() => _areaAgricultura != null;

  // "areaBenfeitoria" field.
  int? _areaBenfeitoria;
  int get areaBenfeitoria => _areaBenfeitoria ?? 0;
  set areaBenfeitoria(int? val) => _areaBenfeitoria = val;

  void incrementAreaBenfeitoria(int amount) =>
      areaBenfeitoria = areaBenfeitoria + amount;

  bool hasAreaBenfeitoria() => _areaBenfeitoria != null;

  // "areaPastagem" field.
  int? _areaPastagem;
  int get areaPastagem => _areaPastagem ?? 0;
  set areaPastagem(int? val) => _areaPastagem = val;

  void incrementAreaPastagem(int amount) =>
      areaPastagem = areaPastagem + amount;

  bool hasAreaPastagem() => _areaPastagem != null;

  // "areaReserva" field.
  int? _areaReserva;
  int get areaReserva => _areaReserva ?? 0;
  set areaReserva(int? val) => _areaReserva = val;

  void incrementAreaReserva(int amount) => areaReserva = areaReserva + amount;

  bool hasAreaReserva() => _areaReserva != null;

  // "areaTotal" field.
  int? _areaTotal;
  int get areaTotal => _areaTotal ?? 0;
  set areaTotal(int? val) => _areaTotal = val;

  void incrementAreaTotal(int amount) => areaTotal = areaTotal + amount;

  bool hasAreaTotal() => _areaTotal != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  set cidade(String? val) => _cidade = val;

  bool hasCidade() => _cidade != null;

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  set estado(String? val) => _estado = val;

  bool hasEstado() => _estado != null;

  // "icone" field.
  String? _icone;
  String get icone => _icone ?? '';
  set icone(String? val) => _icone = val;

  bool hasIcone() => _icone != null;

  // "atividades" field.
  String? _atividades;
  String get atividades => _atividades ?? '';
  set atividades(String? val) => _atividades = val;

  bool hasAtividades() => _atividades != null;

  // "userID" field.
  String? _userID;
  String get userID => _userID ?? '';
  set userID(String? val) => _userID = val;

  bool hasUserID() => _userID != null;

  static LocalPropriedadeStruct fromMap(Map<String, dynamic> data) =>
      LocalPropriedadeStruct(
        nome: data['nome'] as String?,
        idPropriedade: data['idPropriedade'] as String?,
        usersID: data['usersID'] as String?,
        anotacoes: data['anotacoes'] as String?,
        areaAgricultura: castToType<int>(data['areaAgricultura']),
        areaBenfeitoria: castToType<int>(data['areaBenfeitoria']),
        areaPastagem: castToType<int>(data['areaPastagem']),
        areaReserva: castToType<int>(data['areaReserva']),
        areaTotal: castToType<int>(data['areaTotal']),
        cidade: data['cidade'] as String?,
        estado: data['estado'] as String?,
        icone: data['icone'] as String?,
        atividades: data['atividades'] as String?,
        userID: data['userID'] as String?,
      );

  static LocalPropriedadeStruct? maybeFromMap(dynamic data) => data is Map
      ? LocalPropriedadeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'idPropriedade': _idPropriedade,
        'usersID': _usersID,
        'anotacoes': _anotacoes,
        'areaAgricultura': _areaAgricultura,
        'areaBenfeitoria': _areaBenfeitoria,
        'areaPastagem': _areaPastagem,
        'areaReserva': _areaReserva,
        'areaTotal': _areaTotal,
        'cidade': _cidade,
        'estado': _estado,
        'icone': _icone,
        'atividades': _atividades,
        'userID': _userID,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'idPropriedade': serializeParam(
          _idPropriedade,
          ParamType.String,
        ),
        'usersID': serializeParam(
          _usersID,
          ParamType.String,
        ),
        'anotacoes': serializeParam(
          _anotacoes,
          ParamType.String,
        ),
        'areaAgricultura': serializeParam(
          _areaAgricultura,
          ParamType.int,
        ),
        'areaBenfeitoria': serializeParam(
          _areaBenfeitoria,
          ParamType.int,
        ),
        'areaPastagem': serializeParam(
          _areaPastagem,
          ParamType.int,
        ),
        'areaReserva': serializeParam(
          _areaReserva,
          ParamType.int,
        ),
        'areaTotal': serializeParam(
          _areaTotal,
          ParamType.int,
        ),
        'cidade': serializeParam(
          _cidade,
          ParamType.String,
        ),
        'estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'icone': serializeParam(
          _icone,
          ParamType.String,
        ),
        'atividades': serializeParam(
          _atividades,
          ParamType.String,
        ),
        'userID': serializeParam(
          _userID,
          ParamType.String,
        ),
      }.withoutNulls;

  static LocalPropriedadeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      LocalPropriedadeStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        idPropriedade: deserializeParam(
          data['idPropriedade'],
          ParamType.String,
          false,
        ),
        usersID: deserializeParam(
          data['usersID'],
          ParamType.String,
          false,
        ),
        anotacoes: deserializeParam(
          data['anotacoes'],
          ParamType.String,
          false,
        ),
        areaAgricultura: deserializeParam(
          data['areaAgricultura'],
          ParamType.int,
          false,
        ),
        areaBenfeitoria: deserializeParam(
          data['areaBenfeitoria'],
          ParamType.int,
          false,
        ),
        areaPastagem: deserializeParam(
          data['areaPastagem'],
          ParamType.int,
          false,
        ),
        areaReserva: deserializeParam(
          data['areaReserva'],
          ParamType.int,
          false,
        ),
        areaTotal: deserializeParam(
          data['areaTotal'],
          ParamType.int,
          false,
        ),
        cidade: deserializeParam(
          data['cidade'],
          ParamType.String,
          false,
        ),
        estado: deserializeParam(
          data['estado'],
          ParamType.String,
          false,
        ),
        icone: deserializeParam(
          data['icone'],
          ParamType.String,
          false,
        ),
        atividades: deserializeParam(
          data['atividades'],
          ParamType.String,
          false,
        ),
        userID: deserializeParam(
          data['userID'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LocalPropriedadeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LocalPropriedadeStruct &&
        nome == other.nome &&
        idPropriedade == other.idPropriedade &&
        usersID == other.usersID &&
        anotacoes == other.anotacoes &&
        areaAgricultura == other.areaAgricultura &&
        areaBenfeitoria == other.areaBenfeitoria &&
        areaPastagem == other.areaPastagem &&
        areaReserva == other.areaReserva &&
        areaTotal == other.areaTotal &&
        cidade == other.cidade &&
        estado == other.estado &&
        icone == other.icone &&
        atividades == other.atividades &&
        userID == other.userID;
  }

  @override
  int get hashCode => const ListEquality().hash([
        nome,
        idPropriedade,
        usersID,
        anotacoes,
        areaAgricultura,
        areaBenfeitoria,
        areaPastagem,
        areaReserva,
        areaTotal,
        cidade,
        estado,
        icone,
        atividades,
        userID
      ]);
}

LocalPropriedadeStruct createLocalPropriedadeStruct({
  String? nome,
  String? idPropriedade,
  String? usersID,
  String? anotacoes,
  int? areaAgricultura,
  int? areaBenfeitoria,
  int? areaPastagem,
  int? areaReserva,
  int? areaTotal,
  String? cidade,
  String? estado,
  String? icone,
  String? atividades,
  String? userID,
}) =>
    LocalPropriedadeStruct(
      nome: nome,
      idPropriedade: idPropriedade,
      usersID: usersID,
      anotacoes: anotacoes,
      areaAgricultura: areaAgricultura,
      areaBenfeitoria: areaBenfeitoria,
      areaPastagem: areaPastagem,
      areaReserva: areaReserva,
      areaTotal: areaTotal,
      cidade: cidade,
      estado: estado,
      icone: icone,
      atividades: atividades,
      userID: userID,
    );
