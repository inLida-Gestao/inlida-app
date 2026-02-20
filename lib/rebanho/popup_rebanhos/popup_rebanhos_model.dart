import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_rebanho_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'popup_rebanhos_widget.dart' show PopupRebanhosWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupRebanhosModel extends FlutterFlowModel<PopupRebanhosWidget> {
  ///  Local state fields for this component.

  int? limit = 10;

  int offset = 0;

  ///  State fields for stateful widgets in this component.

  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode1;
  TextEditingController? pesquisarTextController1;
  String? Function(BuildContext, String?)? pesquisarTextController1Validator;
  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode2;
  TextEditingController? pesquisarTextController2;
  String? Function(BuildContext, String?)? pesquisarTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    pesquisarFocusNode1?.dispose();
    pesquisarTextController1?.dispose();

    pesquisarFocusNode2?.dispose();
    pesquisarTextController2?.dispose();
  }
}
