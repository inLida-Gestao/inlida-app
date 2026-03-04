import '/flutter_flow/flutter_flow_util.dart';
import 'filtros_reproducao_widget.dart' show FiltrosReproducaoWidget;
import 'package:flutter/material.dart';

class FiltrosReproducaoModel extends FlutterFlowModel<FiltrosReproducaoWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for date pickers - Data da reprodução
  DateTime? dataReproducaoInicio;
  DateTime? dataReproducaoFim;
  // State field(s) for date pickers - Previsão de parto
  DateTime? dataPartoInicio;
  DateTime? dataPartoFim;
  // State field(s) for DropDown widget - Categoria
  List<String> categoriasSelecionadas = [];
  bool? showCategoriaDropdown = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
