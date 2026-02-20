import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/politica_privacidade_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/perfil/edit_senha/edit_senha_widget.dart';
import '/perfil/editar_perfil/editar_perfil_widget.dart';
import '/perfil/excluir_conta/excluir_conta_widget.dart';
import 'dart:ui';
import 'minha_conta_widget.dart' show MinhaContaWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MinhaContaModel extends FlutterFlowModel<MinhaContaWidget> {
  ///  Local state fields for this component.

  String page = 'home';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
