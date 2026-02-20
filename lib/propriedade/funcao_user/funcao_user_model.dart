import '/backend/api_requests/api_calls.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import 'funcao_user_widget.dart' show FuncaoUserWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FuncaoUserModel extends FlutterFlowModel<FuncaoUserWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Dropdown_Atividades widget.
  String? dropdownAtividadesValue;
  FormFieldController<String>? dropdownAtividadesValueController;
  // Stores action output result for [Custom Action - checkInternetConnection] action in Dropdown_Atividades widget.
  bool? temNET;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
