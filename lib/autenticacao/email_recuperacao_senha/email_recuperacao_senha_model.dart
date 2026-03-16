import '/flutter_flow/flutter_flow_util.dart';
import 'email_recuperacao_senha_widget.dart' show EmailRecuperacaoSenhaWidget;
import 'package:flutter/material.dart';

class EmailRecuperacaoSenhaModel
    extends FlutterFlowModel<EmailRecuperacaoSenhaWidget> {
  ///  Local state fields for this component.

  bool politicas = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
