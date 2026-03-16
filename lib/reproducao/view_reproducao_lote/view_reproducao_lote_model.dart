import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'view_reproducao_lote_widget.dart' show ViewReproducaoLoteWidget;
import 'package:flutter/material.dart';

class ViewReproducaoLoteModel
    extends FlutterFlowModel<ViewReproducaoLoteWidget> {
  ///  Local state fields for this component.

  String tipoReproducao = 'Inseminação';

  double score = 0.5;

  int partidaSemen = 1;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - SQLite (Buscar Reproducao)] action in viewReproducaoLote widget.
  List<BuscarReproducaoRow>? reproducao;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
