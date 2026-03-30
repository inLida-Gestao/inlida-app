import '/flutter_flow/flutter_flow_util.dart';
import 'selecao_propriedade_widget.dart' show SelecaoPropriedadeWidget;
import 'package:flutter/material.dart';

class SelecaoPropriedadeModel
    extends FlutterFlowModel<SelecaoPropriedadeWidget> {
  // State field(s) for search.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchTextController?.dispose();
  }
}
