import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/propriedade/add_propriedade/add_propriedade_widget.dart';
import '/propriedade/filtro_propriedades/filtro_propriedades_widget.dart';
import '/propriedade/filtros_ordenacao_propriedade/filtros_ordenacao_propriedade_widget.dart';
import '/propriedade/ordernar_propriedades/ordernar_propriedades_widget.dart';
import '/propriedade/view_propriedades/view_propriedades_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'page_propriedades_widget.dart' show PagePropriedadesWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
