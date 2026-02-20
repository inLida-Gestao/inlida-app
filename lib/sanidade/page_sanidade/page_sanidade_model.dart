import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_sanidade_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/sanidade/edit_sanidade_animal/edit_sanidade_animal_widget.dart';
import '/sanidade/filtro_sanidades/filtro_sanidades_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'page_sanidade_widget.dart' show PageSanidadeWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PageSanidadeModel extends FlutterFlowModel<PageSanidadeWidget> {
  ///  Local state fields for this component.

  int? limit = 20;

  int? offset = 0;

  int pageNum = 1;

  ///  State fields for stateful widgets in this component.

  // Model for selecionarPropriedade component.
  late SelecionarPropriedadeModel selecionarPropriedadeModel;
  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode;
  TextEditingController? pesquisarTextController;
  String? Function(BuildContext, String?)? pesquisarTextControllerValidator;

  @override
  void initState(BuildContext context) {
    selecionarPropriedadeModel =
        createModel(context, () => SelecionarPropriedadeModel());
  }

  @override
  void dispose() {
    selecionarPropriedadeModel.dispose();
    pesquisarFocusNode?.dispose();
    pesquisarTextController?.dispose();
  }
}
