import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'select_color_icon_widget.dart' show SelectColorIconWidget;
import 'package:flutter/material.dart';

class SelectColorIconModel extends FlutterFlowModel<SelectColorIconWidget> {
  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in selectColorIcon widget.
  bool? temNet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
