import '/flutter_flow/flutter_flow_util.dart';
import 'pesquisa_widget.dart' show PesquisaWidget;
import 'package:flutter/material.dart';

class PesquisaModel extends FlutterFlowModel<PesquisaWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
