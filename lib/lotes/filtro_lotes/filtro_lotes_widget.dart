import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'filtro_lotes_model.dart';
export 'filtro_lotes_model.dart';

class FiltroLotesWidget extends StatefulWidget {
  const FiltroLotesWidget({super.key});

  @override
  State<FiltroLotesWidget> createState() => _FiltroLotesWidgetState();
}

class _FiltroLotesWidgetState extends State<FiltroLotesWidget> {
  late FiltroLotesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FiltroLotesModel());

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
        height: 350.0,
        constraints: BoxConstraints(
          maxHeight: 399.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(25.0, 25.0, 25.0, 25.0),
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
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/Icon_Button5656.png',
                          width: 36.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      'Filtrar',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.poppins(
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
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        FFAppState().filtroAtivoLotes = '';
                        FFAppState().filtroAplicadosLotes = [];
                        safeSetState(() {});
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Limpar',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              font: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                              color: valueOrDefault<Color>(
                                FFAppState().filtroAplicadosLotes.firstOrNull ==
                                            null ||
                                        FFAppState()
                                                .filtroAplicadosLotes
                                                .firstOrNull ==
                                            ''
                                    ? Color(0xFFBEBEBE)
                                    : Color(0xFF060606),
                                Color(0xFFBEBEBE),
                              ),
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .fontStyle,
                            ),
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
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status do lote',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: Color(0xFF2F2F2F),
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (FFAppState().filtroAtivoLotes == 'Ativo') {
                                FFAppState().removeFromFiltroAplicadosLotes(
                                    FFAppState().filtroAtivoLotes);
                                safeSetState(() {});
                                FFAppState().filtroAtivoLotes = '';
                                safeSetState(() {});
                              } else {
                                FFAppState().removeFromFiltroAplicadosLotes(
                                    FFAppState().filtroAtivoLotes);
                                safeSetState(() {});
                                FFAppState().filtroAtivoLotes = 'Ativo';
                                safeSetState(() {});
                                FFAppState().addToFiltroAplicadosLotes(
                                    FFAppState().filtroAtivoLotes);
                                safeSetState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorFromCssString(
                                  FFAppState().filtroAtivoLotes == 'Ativo'
                                      ? '#D6F5E5'
                                      : '#FFFFFF',
                                  defaultColor: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: colorFromCssString(
                                    FFAppState().filtroAtivoLotes == 'Ativo'
                                        ? '#1E7A4C'
                                        : '#EDEDED',
                                    defaultColor: Color(0xFFEDEDED),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Ativo',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: colorFromCssString(
                                              FFAppState().filtroAtivoLotes ==
                                                      'Ativo'
                                                  ? '#1E7A4C'
                                                  : '#2F2F2F',
                                              defaultColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    if (FFAppState().filtroAtivoLotes ==
                                        'Ativo')
                                      Icon(
                                        Icons.close,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 16.0,
                                      ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (FFAppState().filtroAtivoLotes == 'Inativo') {
                                FFAppState().removeFromFiltroAplicadosLotes(
                                    FFAppState().filtroAtivoLotes);
                                safeSetState(() {});
                                FFAppState().filtroAtivoLotes = '';
                                safeSetState(() {});
                              } else {
                                FFAppState().removeFromFiltroAplicadosLotes(
                                    FFAppState().filtroAtivoLotes);
                                safeSetState(() {});
                                FFAppState().filtroAtivoLotes = 'Inativo';
                                safeSetState(() {});
                                FFAppState().addToFiltroAplicadosLotes(
                                    FFAppState().filtroAtivoLotes);
                                safeSetState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorFromCssString(
                                  FFAppState().filtroAtivoLotes == 'Inativo'
                                      ? '#D6F5E5'
                                      : '#FFFFFF',
                                  defaultColor: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: colorFromCssString(
                                    FFAppState().filtroAtivoLotes == 'Inativo'
                                        ? '#1E7A4C'
                                        : '#EDEDED',
                                    defaultColor: Color(0xFFEDEDED),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Inativo',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: colorFromCssString(
                                              FFAppState().filtroAtivoLotes ==
                                                      'Inativo'
                                                  ? '#1E7A4C'
                                                  : '#2F2F2F',
                                              defaultColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    if (FFAppState().filtroAtivoLotes ==
                                        'Inativo')
                                      Icon(
                                        Icons.close,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 16.0,
                                      ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
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
                  Navigator.pop(context);
                },
                text: 'Ver resultados',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 47.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
