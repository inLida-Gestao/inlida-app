import '/components/empty_prop_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import 'page_lotes_widget.dart' show PageLotesWidget;
import 'package:flutter/material.dart';

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
