import '/backend/api_requests/api_calls.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'funcao_user_model.dart';
export 'funcao_user_model.dart';

class FuncaoUserWidget extends StatefulWidget {
  const FuncaoUserWidget({
    super.key,
    this.funcaoAtual,
    required this.user,
  });

  final String? funcaoAtual;
  final String? user;

  @override
  State<FuncaoUserWidget> createState() => _FuncaoUserWidgetState();
}

class _FuncaoUserWidgetState extends State<FuncaoUserWidget> {
  late FuncaoUserModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FuncaoUserModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FlutterFlowDropDown<String>(
      controller: _model.dropdownAtividadesValueController ??=
          FormFieldController<String>(
        _model.dropdownAtividadesValue ??= widget.funcaoAtual,
      ),
      options: const ['Admin', 'Visualizador'],
      onChanged: (val) async {
        safeSetState(() => _model.dropdownAtividadesValue = val);
        _model.temNET = await actions.checkInternetConnection();
        if (_model.temNET == true) {
          await UsersPropriedadesTable().update(
            data: {
              'permissao': _model.dropdownAtividadesValue,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'user_id',
              widget.user,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Função atualizada',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
              duration: const Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).secondary,
            ),
          );
        } else {
          if (!(FFAppState().dataDadosNaoSyncProp != null)) {
            FFAppState().dataDadosNaoSyncProp = getCurrentTimestamp;
            safeSetState(() {});
          }
          await SQLiteManager.instance.uPDTFuncaoUserLocal(
            userID: widget.user,
            permissao: _model.dropdownAtividadesValue,
          );
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                content: const Text('Função atualizada'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
        }

        safeSetState(() {});
      },
      width: 130.0,
      height: 56.0,
      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
          ),
      hintText: 'Função',
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 24.0,
      ),
      fillColor: const Color(0xFFF1F1F1),
      elevation: 0.0,
      borderColor: const Color(0x00E0E3E7),
      borderWidth: 0.0,
      borderRadius: 8.0,
      margin: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
      hidesUnderline: true,
      isOverButton: true,
      isSearchable: false,
      isMultiSelect: false,
    );
  }
}
