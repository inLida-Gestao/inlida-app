import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rebanho/add_rebanho/add_rebanho_widget.dart';
import '/rebanho/add_rebanho_nascimento/add_rebanho_nascimento_widget.dart';
import '/rebanho/add_rebanho_semen/add_rebanho_semen_widget.dart';
import 'dart:ui';
import 'sub_menu_rebanho_widget.dart' show SubMenuRebanhoWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
