import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'excluir_conta_widget.dart' show ExcluirContaWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExcluirContaModel extends FlutterFlowModel<ExcluirContaWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (Delete user)] action in Button widget.
  ApiCallResponse? apiResultrak;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
