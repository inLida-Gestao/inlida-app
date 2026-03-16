import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'page_propriedades_widget.dart' show PagePropriedadesWidget;
import 'package:flutter/material.dart';

class PagePropriedadesModel extends FlutterFlowModel<PagePropriedadesWidget> {
  ///  Local state fields for this component.

  int propriedadesIndex = 0;

  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in pagePropriedades widget.
  bool? temNet;
  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode;
  TextEditingController? pesquisarTextController;
  String? Function(BuildContext, String?)? pesquisarTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    pesquisarFocusNode?.dispose();
    pesquisarTextController?.dispose();
  }

  /// Action blocks.
  Future refreshPropriedades(BuildContext context) async {}
}
