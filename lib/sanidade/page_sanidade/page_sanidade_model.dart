import '/flutter_flow/flutter_flow_util.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import 'page_sanidade_widget.dart' show PageSanidadeWidget;
import 'package:flutter/material.dart';

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
