import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'add_pesagem_widget.dart' show AddPesagemWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddPesagemModel extends FlutterFlowModel<AddPesagemWidget> {
  ///  Local state fields for this component.

  int indexPesagem = 0;

  ///  State fields for stateful widgets in this component.

  DateTime? datePicked;
  // State field(s) for Peso widget.
  FocusNode? pesoFocusNode;
  TextEditingController? pesoTextController;
  String? Function(BuildContext, String?)? pesoTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    pesoFocusNode?.dispose();
    pesoTextController?.dispose();
  }
}
