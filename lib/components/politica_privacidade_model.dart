import '/flutter_flow/flutter_flow_util.dart';
import 'politica_privacidade_widget.dart' show PoliticaPrivacidadeWidget;
import 'package:flutter/material.dart';

class PoliticaPrivacidadeModel
    extends FlutterFlowModel<PoliticaPrivacidadeWidget> {
  ///  Local state fields for this component.

  String menu = 'intro';

  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
