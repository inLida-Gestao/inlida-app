import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sub_menu_rebanho_widget.dart' show SubMenuRebanhoWidget;
import 'package:flutter/material.dart';

class SubMenuRebanhoModel extends FlutterFlowModel<SubMenuRebanhoWidget> {
  ///  Local state fields for this component.

  int index = 0;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - SQLite (listarPropriedades)] action in Row widget.
  List<ListarPropriedadesRow>? propriedadesNasc;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotesRebNasc;
  // Stores action output result for [Backend Call - SQLite (listarPropriedades)] action in Row widget.
  List<ListarPropriedadesRow>? propriedadessReb;
  // Stores action output result for [Backend Call - SQLite (Buscar Lotes)] action in Row widget.
  List<BuscarLotesRow>? lotesReb;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
