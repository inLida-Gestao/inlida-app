// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class QtdRebanhosStruct extends BaseStruct {
  QtdRebanhosStruct({
    int? qtd,
  }) : _qtd = qtd;

  // "qtd" field.
  int? _qtd;
  int get qtd => _qtd ?? 0;
  set qtd(int? val) => _qtd = val;

  void incrementQtd(int amount) => qtd = qtd + amount;

  bool hasQtd() => _qtd != null;

  static QtdRebanhosStruct fromMap(Map<String, dynamic> data) =>
      QtdRebanhosStruct(
        qtd: castToType<int>(data['qtd']),
      );

  static QtdRebanhosStruct? maybeFromMap(dynamic data) => data is Map
      ? QtdRebanhosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'qtd': _qtd,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'qtd': serializeParam(
          _qtd,
          ParamType.int,
        ),
      }.withoutNulls;

  static QtdRebanhosStruct fromSerializableMap(Map<String, dynamic> data) =>
      QtdRebanhosStruct(
        qtd: deserializeParam(
          data['qtd'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'QtdRebanhosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is QtdRebanhosStruct && qtd == other.qtd;
  }

  @override
  int get hashCode => const ListEquality().hash([qtd]);
}

QtdRebanhosStruct createQtdRebanhosStruct({
  int? qtd,
}) =>
    QtdRebanhosStruct(
      qtd: qtd,
    );
