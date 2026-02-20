import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'add_usuario_widget.dart' show AddUsuarioWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddUsuarioModel extends FlutterFlowModel<AddUsuarioWidget> {
  ///  Local state fields for this component.

  int usersIndex = 0;

  List<String> usersProp = [];
  void addToUsersProp(String item) => usersProp.add(item);
  void removeFromUsersProp(String item) => usersProp.remove(item);
  void removeAtIndexFromUsersProp(int index) => usersProp.removeAt(index);
  void insertAtIndexInUsersProp(int index, String item) =>
      usersProp.insert(index, item);
  void updateUsersPropAtIndex(int index, Function(String) updateFn) =>
      usersProp[index] = updateFn(usersProp[index]);

  ///  State fields for stateful widgets in this component.

  // State field(s) for Email-Propriedade widget.
  FocusNode? emailPropriedadeFocusNode;
  TextEditingController? emailPropriedadeTextController;
  String? Function(BuildContext, String?)?
      emailPropriedadeTextControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<UsersRow>? user;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<UsersPropriedadesRow>? userNaPropriedade;
  // Stores action output result for [Backend Call - SQLite (Busca Propriedade)] action in Button widget.
  List<BuscaPropriedadeRow>? propriedade;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailPropriedadeFocusNode?.dispose();
    emailPropriedadeTextController?.dispose();
  }
}
