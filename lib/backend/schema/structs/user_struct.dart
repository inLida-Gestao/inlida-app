// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    String? nome,
    String? email,
    String? foto,
    String? id,
    String? telefone,
    String? permissao,
    String? acesso,
  })  : _nome = nome,
        _email = email,
        _foto = foto,
        _id = id,
        _telefone = telefone,
        _permissao = permissao,
        _acesso = acesso;

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

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  // "permissao" field.
  String? _permissao;
  String get permissao => _permissao ?? '';
  set permissao(String? val) => _permissao = val;

  bool hasPermissao() => _permissao != null;

  // "acesso" field.
  String? _acesso;
  String get acesso => _acesso ?? '';
  set acesso(String? val) => _acesso = val;

  bool hasAcesso() => _acesso != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        nome: data['nome'] as String?,
        email: data['email'] as String?,
        foto: data['foto'] as String?,
        id: data['id'] as String?,
        telefone: data['telefone'] as String?,
        permissao: data['permissao'] as String?,
        acesso: data['acesso'] as String?,
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'email': _email,
        'foto': _foto,
        'id': _id,
        'telefone': _telefone,
        'permissao': _permissao,
        'acesso': _acesso,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
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
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
          ParamType.String,
        ),
        'permissao': serializeParam(
          _permissao,
          ParamType.String,
        ),
        'acesso': serializeParam(
          _acesso,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
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
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
          ParamType.String,
          false,
        ),
        permissao: deserializeParam(
          data['permissao'],
          ParamType.String,
          false,
        ),
        acesso: deserializeParam(
          data['acesso'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserStruct &&
        nome == other.nome &&
        email == other.email &&
        foto == other.foto &&
        id == other.id &&
        telefone == other.telefone &&
        permissao == other.permissao &&
        acesso == other.acesso;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([nome, email, foto, id, telefone, permissao, acesso]);
}

UserStruct createUserStruct({
  String? nome,
  String? email,
  String? foto,
  String? id,
  String? telefone,
  String? permissao,
  String? acesso,
}) =>
    UserStruct(
      nome: nome,
      email: email,
      foto: foto,
      id: id,
      telefone: telefone,
      permissao: permissao,
      acesso: acesso,
    );
