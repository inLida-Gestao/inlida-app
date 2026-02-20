import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_lote_widget.dart';
import '/components/empty_prop_widget.dart';
import '/components/empty_reproducao_widget.dart';
import '/components/empty_sanidade_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/lotes/filtro_lotes/filtro_lotes_widget.dart';
import '/lotes/view_lote/view_lote_widget.dart';
import '/propriedade/add_propriedade/add_propriedade_widget.dart';
import '/propriedade/filtro_propriedades/filtro_propriedades_widget.dart';
import '/propriedade/ordernar_propriedades/ordernar_propriedades_widget.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/propriedade/view_propriedades/view_propriedades_widget.dart';
import '/rebanho/filtros_rebanho/filtros_rebanho_widget.dart';
import '/reproducao/filtros_reproducao/filtros_reproducao_widget.dart';
import '/reproducao/view_reproducao_lote/view_reproducao_lote_widget.dart';
import '/reproducao/view_reproducao_rebanho/view_reproducao_rebanho_widget.dart';
import '/sanidade/edit_sanidade_animal/edit_sanidade_animal_widget.dart';
import '/sanidade/edit_sanidade_lote/edit_sanidade_lote_widget.dart';
import '/sanidade/filtro_sanidades/filtro_sanidades_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'pesquisa_geral_widget.dart' show PesquisaGeralWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PesquisaGeralModel extends FlutterFlowModel<PesquisaGeralWidget> {
  ///  Local state fields for this component.

  int? indexCrias = 0;

  int? indexPesagens = 0;

  int? index = 0;

  int tab = 0;

  ///  State fields for stateful widgets in this component.

  // State field(s) for pesquisarReb widget.
  FocusNode? pesquisarRebFocusNode;
  TextEditingController? pesquisarRebTextController;
  String? Function(BuildContext, String?)? pesquisarRebTextControllerValidator;
  // State field(s) for pesquisarProp widget.
  FocusNode? pesquisarPropFocusNode;
  TextEditingController? pesquisarPropTextController;
  String? Function(BuildContext, String?)? pesquisarPropTextControllerValidator;
  // State field(s) for pesquisarLote widget.
  FocusNode? pesquisarLoteFocusNode;
  TextEditingController? pesquisarLoteTextController;
  String? Function(BuildContext, String?)? pesquisarLoteTextControllerValidator;
  // State field(s) for pesquisarRep widget.
  FocusNode? pesquisarRepFocusNode;
  TextEditingController? pesquisarRepTextController;
  String? Function(BuildContext, String?)? pesquisarRepTextControllerValidator;
  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode;
  TextEditingController? pesquisarTextController;
  String? Function(BuildContext, String?)? pesquisarTextControllerValidator;
  // Model for selecionarPropriedade component.
  late SelecionarPropriedadeModel selecionarPropriedadeModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

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
    pesquisarRebFocusNode?.dispose();
    pesquisarRebTextController?.dispose();

    pesquisarPropFocusNode?.dispose();
    pesquisarPropTextController?.dispose();

    pesquisarLoteFocusNode?.dispose();
    pesquisarLoteTextController?.dispose();

    pesquisarRepFocusNode?.dispose();
    pesquisarRepTextController?.dispose();

    pesquisarFocusNode?.dispose();
    pesquisarTextController?.dispose();

    selecionarPropriedadeModel.dispose();
    tabBarController?.dispose();
    emptyPropModel.dispose();
  }
}
