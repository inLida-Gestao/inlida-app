import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'add_rebanho_semen_widget.dart' show AddRebanhoSemenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddRebanhoSemenModel extends FlutterFlowModel<AddRebanhoSemenWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for N_animal widget.
  FocusNode? nAnimalFocusNode;
  TextEditingController? nAnimalTextController;
  String? Function(BuildContext, String?)? nAnimalTextControllerValidator;
  // State field(s) for Cdigoregistro widget.
  FocusNode? cdigoregistroFocusNode;
  TextEditingController? cdigoregistroTextController;
  String? Function(BuildContext, String?)? cdigoregistroTextControllerValidator;
  // State field(s) for Nome_Animal widget.
  FocusNode? nomeAnimalFocusNode;
  TextEditingController? nomeAnimalTextController;
  String? Function(BuildContext, String?)? nomeAnimalTextControllerValidator;
  String? _nomeAnimalTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  // State field(s) for DP-Raca widget.
  String? dPRacaValue;
  FormFieldController<String>? dPRacaValueController;
  // State field(s) for Anotacoes widget.
  FocusNode? anotacoesFocusNode;
  TextEditingController? anotacoesTextController;
  String? Function(BuildContext, String?)? anotacoesTextControllerValidator;

  @override
  void initState(BuildContext context) {
    nomeAnimalTextControllerValidator = _nomeAnimalTextControllerValidator;
  }

  @override
  void dispose() {
    nAnimalFocusNode?.dispose();
    nAnimalTextController?.dispose();

    cdigoregistroFocusNode?.dispose();
    cdigoregistroTextController?.dispose();

    nomeAnimalFocusNode?.dispose();
    nomeAnimalTextController?.dispose();

    anotacoesFocusNode?.dispose();
    anotacoesTextController?.dispose();
  }
}
