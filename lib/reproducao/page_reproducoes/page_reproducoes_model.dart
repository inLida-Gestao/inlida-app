import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import 'page_reproducoes_widget.dart' show PageReproducoesWidget;
import 'package:flutter/material.dart';

class PageReproducoesModel extends FlutterFlowModel<PageReproducoesWidget> {
  ///  Local state fields for this component.

  int limit = 20;

  int offset = 0;

  int? pageNum = 1;

  int countReproducoesFiltradas = 0;

  ///  State fields for stateful widgets in this component.

  // Model for selecionarPropriedade component.
  late SelecionarPropriedadeModel selecionarPropriedadeModel;
  // State field(s) for pesquisar widget.
  FocusNode? pesquisarFocusNode;
  TextEditingController? pesquisarTextController;
  String? Function(BuildContext, String?)? pesquisarTextControllerValidator;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Row widget.
  List<BuscarRebanhoRow>? reprodutor;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Row widget.
  List<BuscarRebanhoRow>? matriz;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Row widget.
  List<BuscarRebanhoRow>? reprodutor2;
  // Stores action output result for [Backend Call - SQLite (Buscar Rebanho)] action in Row widget.
  List<BuscarRebanhoRow>? matriz2;

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
