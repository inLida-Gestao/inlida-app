import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/reproducao/edit_reproducao_lote/edit_reproducao_lote_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'view_reproducao_lote_widget.dart' show ViewReproducaoLoteWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
