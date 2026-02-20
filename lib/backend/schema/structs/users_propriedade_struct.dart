// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersPropriedadeStruct extends BaseStruct {
  UsersPropriedadeStruct({
    String? userId,
    String? nome,
    String? email,
    String? foto,
    String? permissao,
    String? idPropriedade,
    String? deletado,
  })  : _userId = userId,
        _nome = nome,
        _email = email,
        _foto = foto,
        _permissao = permissao,
        _idPropriedade = idPropriedade,
        _deletado = deletado;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  set foto(String? val) => _foto = val;

  bool hasFoto() => _foto != null;

  // "permissao" field.
  String? _permissao;
  String get permissao => _permissao ?? '';
  set permissao(String? val) => _permissao = val;

  bool hasPermissao() => _permissao != null;

  // "idPropriedade" field.
  String? _idPropriedade;
  String get idPropriedade => _idPropriedade ?? '';
  set idPropriedade(String? val) => _idPropriedade = val;

  bool hasIdPropriedade() => _idPropriedade != null;

  // "deletado" field.
  String? _deletado;
  String get deletado => _deletado ?? '';
  set deletado(String? val) => _deletado = val;

  bool hasDeletado() => _deletado != null;

  static UsersPropriedadeStruct fromMap(Map<String, dynamic> data) =>
      UsersPropriedadeStruct(
        userId: data['user_id'] as String?,
        nome: data['nome'] as String?,
        email: data['email'] as String?,
        foto: data['foto'] as String?,
        permissao: data['permissao'] as String?,
        idPropriedade: data['idPropriedade'] as String?,
        deletado: data['deletado'] as String?,
      );

  static UsersPropriedadeStruct? maybeFromMap(dynamic data) => data is Map
      ? UsersPropriedadeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'user_id': _userId,
        'nome': _nome,
        'email': _email,
        'foto': _foto,
        'permissao': _permissao,
        'idPropriedade': _idPropriedade,
        'deletado': _deletado,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'foto': serializeParam(
          _foto,
          ParamType.String,
        ),
        'permissao': serializeParam(
          _permissao,
          ParamType.String,
        ),
        'idPropriedade': serializeParam(
          _idPropriedade,
          ParamType.String,
        ),
        'deletado': serializeParam(
          _deletado,
          ParamType.String,
        ),
      }.withoutNulls;

  static UsersPropriedadeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      UsersPropriedadeStruct(
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        foto: deserializeParam(
          data['foto'],
          ParamType.String,
          false,
        ),
        permissao: deserializeParam(
          data['permissao'],
          ParamType.String,
          false,
        ),
        idPropriedade: deserializeParam(
          data['idPropriedade'],
          ParamType.String,
          false,
        ),
        deletado: deserializeParam(
          data['deletado'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UsersPropriedadeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UsersPropriedadeStruct &&
        userId == other.userId &&
        nome == other.nome &&
        email == other.email &&
        foto == other.foto &&
        permissao == other.permissao &&
        idPropriedade == other.idPropriedade &&
        deletado == other.deletado;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([userId, nome, email, foto, permissao, idPropriedade, deletado]);
}

UsersPropriedadeStruct createUsersPropriedadeStruct({
  String? userId,
  String? nome,
  String? email,
  String? foto,
  String? permissao,
  String? idPropriedade,
  String? deletado,
}) =>
    UsersPropriedadeStruct(
      userId: userId,
      nome: nome,
      email: email,
      foto: foto,
      permissao: permissao,
      idPropriedade: idPropriedade,
      deletado: deletado,
    );
