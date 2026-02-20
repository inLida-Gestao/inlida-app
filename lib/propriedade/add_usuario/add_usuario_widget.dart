import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_usuario_model.dart';
export 'add_usuario_model.dart';

class AddUsuarioWidget extends StatefulWidget {
  const AddUsuarioWidget({
    super.key,
    required this.idPropriedade,
    required this.donoPropriedade,
  });

  final String? idPropriedade;
  final String? donoPropriedade;

  @override
  State<AddUsuarioWidget> createState() => _AddUsuarioWidgetState();
}

class _AddUsuarioWidgetState extends State<AddUsuarioWidget> {
  late AddUsuarioModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddUsuarioModel());

    _model.emailPropriedadeTextController ??= TextEditingController();
    _model.emailPropriedadeFocusNode ??= FocusNode();

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

    return Material(
      color: Colors.transparent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      Text(
                        'Adicionar usuário',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF2F2F2F),
                                  fontSize: 24.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                      ),
                      Opacity(
                        opacity: 0.0,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1.0,
                color: Color(0xFFBEBEBE),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuário',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: Color(0xFF474747),
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      TextFormField(
                        controller: _model.emailPropriedadeTextController,
                        focusNode: _model.emailPropriedadeFocusNode,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'E-mail do usuário à adicionar',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                color: Color(0xFFBEBEBE),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                lineHeight: 1.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00E0E3E7),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF28A365),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF1F1F1),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              lineHeight: 2.5,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).secondaryText,
                        validator: _model
                            .emailPropriedadeTextControllerValidator
                            .asValidator(context),
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                ),
              ),
              Divider(
                thickness: 1.0,
                color: Color(0xFFBEBEBE),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    var _shouldSetState = false;
                    _model.user = await UsersTable().queryRows(
                      queryFn: (q) => q.eqOrNull(
                        'email',
                        _model.emailPropriedadeTextController.text,
                      ),
                    );
                    _shouldSetState = true;
                    if (_model.user!.length > 0) {
                      _model.userNaPropriedade =
                          await UsersPropriedadesTable().queryRows(
                        queryFn: (q) => q
                            .eqOrNull(
                              'email',
                              _model.emailPropriedadeTextController.text,
                            )
                            .eqOrNull(
                              'idPropriedade',
                              widget!.idPropriedade,
                            ),
                      );
                      _shouldSetState = true;
                      if (_model.userNaPropriedade!.length > 0) {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              content: Text(
                                  'Usuário já está adicionado nesta propriedade.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                        if (_shouldSetState) safeSetState(() {});
                        return;
                      } else {
                        if (!(FFAppState().dataDadosNaoSyncProp != null)) {
                          FFAppState().dataDadosNaoSyncProp =
                              getCurrentTimestamp;
                          safeSetState(() {});
                        }
                        await UsersPropriedadesTable().insert({
                          'user_id': _model.user?.firstOrNull?.userID,
                          'nome': _model.user?.firstOrNull?.nome,
                          'email': _model.user?.firstOrNull?.email,
                          'foto': _model.user?.firstOrNull?.foto,
                          'permissao': 'Visualizador',
                          'deletado': 'NAO',
                          'idPropriedade': widget!.idPropriedade,
                        });
                        _model.propriedade =
                            await SQLiteManager.instance.buscaPropriedade(
                          idPropriedade: widget!.idPropriedade,
                        );
                        _shouldSetState = true;
                        if (_model.propriedade?.firstOrNull?.usersID == ' ') {
                          _model.usersProp = _model.user!
                              .map((e) => e.userID)
                              .toList()
                              .cast<String>();
                          safeSetState(() {});
                          await SQLiteManager.instance.addUserNaPropriedade(
                            idPropriedade: widget!.idPropriedade,
                            usersID: functions.converterListaParaJSON(
                                _model.usersProp.toList()),
                            updatedat: dateTimeFormat(
                              "yyyy-MM-dd HH:mm:ss",
                              getCurrentTimestamp,
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                          );
                        } else {
                          _model.usersProp = functions
                              .converterJSONparaLista(
                                  _model.propriedade!.firstOrNull!.usersID!)
                              .toList()
                              .cast<String>();
                          safeSetState(() {});
                          _model
                              .addToUsersProp(_model.user!.firstOrNull!.userID);
                          safeSetState(() {});
                          await SQLiteManager.instance.addUserNaPropriedade(
                            idPropriedade: widget!.idPropriedade,
                            usersID: functions.converterListaParaJSON(
                                _model.usersProp.toList()),
                            updatedat: dateTimeFormat(
                              "yyyy-MM-dd HH:mm:ss",
                              getCurrentTimestamp,
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                          );
                        }

                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              content:
                                  Text('Usuário(s) adicionado(s) com sucesso.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('Usuário não existe'),
                            content: Text(
                                'Não há nenhum usuário cadastrado com este email verifique o email ou solicite que o mesmo faça o cadastro.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext),
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    if (_shouldSetState) safeSetState(() {});
                  },
                  text: 'Adicionar',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 47.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF28A365),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
