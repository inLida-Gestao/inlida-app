import '/components/empty_prop_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import 'pesquisa_geral_widget.dart' show PesquisaGeralWidget;
import 'package:flutter/material.dart';

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
