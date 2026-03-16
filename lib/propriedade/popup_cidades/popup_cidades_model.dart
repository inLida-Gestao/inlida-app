import '/flutter_flow/flutter_flow_util.dart';
import 'popup_cidades_widget.dart' show PopupCidadesWidget;
import 'package:flutter/material.dart';

class PopupCidadesModel extends FlutterFlowModel<PopupCidadesWidget> {
  ///  Local state fields for this component.

  int? limit = 10;

  int offset = 0;

  ///  State fields for stateful widgets in this component.

  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode;
  TextEditingController? pesquisarTextController;
  String? Function(BuildContext, String?)? pesquisarTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    pesquisarFocusNode?.dispose();
    pesquisarTextController?.dispose();
  }
}
