import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_lote_widget.dart';
import '/components/empty_prop_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lotes/filtro_lotes/filtro_lotes_widget.dart';
import '/lotes/view_lote/view_lote_widget.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import 'page_lotes_widget.dart' show PageLotesWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PageLotesModel extends FlutterFlowModel<PageLotesWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for selecionarPropriedade component.
  late SelecionarPropriedadeModel selecionarPropriedadeModel;
  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode;
  TextEditingController? pesquisarTextController;
  String? Function(BuildContext, String?)? pesquisarTextControllerValidator;
  // Model for emptyProp component.
  late EmptyPropModel emptyPropModel;

  @override
  void initState(BuildContext context) {
    selecionarPropriedadeModel =
        createModel(context, () => SelecionarPropriedadeModel());
    emptyPropModel = createModel(context, () => EmptyPropModel());
  }

  @override
  void dispose() {
    selecionarPropriedadeModel.dispose();
    pesquisarFocusNode?.dispose();
    pesquisarTextController?.dispose();

    emptyPropModel.dispose();
  }
}
