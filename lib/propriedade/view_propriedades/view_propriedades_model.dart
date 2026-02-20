import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/propriedade/add_usuario/add_usuario_widget.dart';
import '/propriedade/edit_propriedade/edit_propriedade_widget.dart';
import '/propriedade/funcao_user/funcao_user_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'view_propriedades_widget.dart' show ViewPropriedadesWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewPropriedadesModel extends FlutterFlowModel<ViewPropriedadesWidget> {
  ///  State fields for stateful widgets in this component.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - checkInternetConnection] action in viewPropriedades widget.
  bool? temNet;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Nome-Propriedade widget.
  FocusNode? nomePropriedadeFocusNode;
  TextEditingController? nomePropriedadeTextController;
  String? Function(BuildContext, String?)?
      nomePropriedadeTextControllerValidator;
  // State field(s) for UF widget.
  FocusNode? ufFocusNode;
  TextEditingController? ufTextController;
  String? Function(BuildContext, String?)? ufTextControllerValidator;
  // State field(s) for Cidade widget.
  FocusNode? cidadeFocusNode;
  TextEditingController? cidadeTextController;
  String? Function(BuildContext, String?)? cidadeTextControllerValidator;
  // State field(s) for areBenfeitoria widget.
  FocusNode? areBenfeitoriaFocusNode;
  TextEditingController? areBenfeitoriaTextController;
  String? Function(BuildContext, String?)?
      areBenfeitoriaTextControllerValidator;
  // State field(s) for areaPastagem widget.
  FocusNode? areaPastagemFocusNode;
  TextEditingController? areaPastagemTextController;
  String? Function(BuildContext, String?)? areaPastagemTextControllerValidator;
  // State field(s) for areaReserva widget.
  FocusNode? areaReservaFocusNode;
  TextEditingController? areaReservaTextController;
  String? Function(BuildContext, String?)? areaReservaTextControllerValidator;
  // State field(s) for areaAgricultura widget.
  FocusNode? areaAgriculturaFocusNode;
  TextEditingController? areaAgriculturaTextController;
  String? Function(BuildContext, String?)?
      areaAgriculturaTextControllerValidator;
  // State field(s) for areaTotal widget.
  FocusNode? areaTotalFocusNode;
  TextEditingController? areaTotalTextController;
  String? Function(BuildContext, String?)? areaTotalTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController9;
  String? Function(BuildContext, String?)? textController9Validator;
  Stream<List<UsersPropriedadesRow>>? containerSupabaseStream;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    tabBarController?.dispose();
    nomePropriedadeFocusNode?.dispose();
    nomePropriedadeTextController?.dispose();

    ufFocusNode?.dispose();
    ufTextController?.dispose();

    cidadeFocusNode?.dispose();
    cidadeTextController?.dispose();

    areBenfeitoriaFocusNode?.dispose();
    areBenfeitoriaTextController?.dispose();

    areaPastagemFocusNode?.dispose();
    areaPastagemTextController?.dispose();

    areaReservaFocusNode?.dispose();
    areaReservaTextController?.dispose();

    areaAgriculturaFocusNode?.dispose();
    areaAgriculturaTextController?.dispose();

    areaTotalFocusNode?.dispose();
    areaTotalTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController9?.dispose();
  }
}
