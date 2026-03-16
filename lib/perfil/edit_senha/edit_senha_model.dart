import '/flutter_flow/flutter_flow_util.dart';
import 'edit_senha_widget.dart' show EditSenhaWidget;
import 'package:flutter/material.dart';

class EditSenhaModel extends FlutterFlowModel<EditSenhaWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField-novasenha widget.
  FocusNode? textFieldNovasenhaFocusNode;
  TextEditingController? textFieldNovasenhaTextController;
  late bool textFieldNovasenhaVisibility;
  String? Function(BuildContext, String?)?
      textFieldNovasenhaTextControllerValidator;
  // State field(s) for TextField-confirmacao widget.
  FocusNode? textFieldConfirmacaoFocusNode;
  TextEditingController? textFieldConfirmacaoTextController;
  late bool textFieldConfirmacaoVisibility;
  String? Function(BuildContext, String?)?
      textFieldConfirmacaoTextControllerValidator;

  @override
  void initState(BuildContext context) {
    textFieldNovasenhaVisibility = false;
    textFieldConfirmacaoVisibility = false;
  }

  @override
  void dispose() {
    textFieldNovasenhaFocusNode?.dispose();
    textFieldNovasenhaTextController?.dispose();

    textFieldConfirmacaoFocusNode?.dispose();
    textFieldConfirmacaoTextController?.dispose();
  }
}
