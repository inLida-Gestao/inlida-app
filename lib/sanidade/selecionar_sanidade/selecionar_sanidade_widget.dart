import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selecionar_sanidade_model.dart';
export 'selecionar_sanidade_model.dart';

class SelecionarSanidadeWidget extends StatefulWidget {
  const SelecionarSanidadeWidget({super.key});

  @override
  State<SelecionarSanidadeWidget> createState() =>
      _SelecionarSanidadeWidgetState();
}

class _SelecionarSanidadeWidgetState extends State<SelecionarSanidadeWidget> {
  late SelecionarSanidadeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelecionarSanidadeModel());

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
        height: 500.0,
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
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
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
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                    ),
                    Text(
                      'Adicionar sanidade',
                      textAlign: TextAlign.center,
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                                color: Color(0xFF14181B),
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                    ),
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1.0,
                color: Color(0xFFBEBEBE),
              ),
              Builder(
                builder: (context) {
                  final sanidadeOp = FFAppState().sanidadesOp.toList();

                  return SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children:
                          List.generate(sanidadeOp.length, (sanidadeOpIndex) {
                        final sanidadeOpItem = sanidadeOp[sanidadeOpIndex];
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            height: 63.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Color(0x00E0E3E7),
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 12.0, 8.0, 12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (FFAppState()
                                          .sanidade
                                          .contains(sanidadeOpItem) ==
                                      false)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        FFAppState()
                                            .addToSanidade(sanidadeOpItem);
                                        safeSetState(() {});
                                        if (sanidadeOpItem == 'Vacina') {
                                          FFAppState().vacinasCount =
                                              FFAppState().vacinasCount + 1;
                                          safeSetState(() {});
                                        } else if (sanidadeOpItem ==
                                            'Antiparasitário') {
                                          FFAppState().antiParasitarioCount =
                                              FFAppState()
                                                      .antiParasitarioCount +
                                                  1;
                                          safeSetState(() {});
                                        } else if (sanidadeOpItem ==
                                            'Tratamento') {
                                          FFAppState().tratamentosCount =
                                              FFAppState().tratamentosCount + 1;
                                          safeSetState(() {});
                                        } else {
                                          FFAppState().protocolosReproCount =
                                              FFAppState()
                                                      .protocolosReproCount +
                                                  1;
                                          safeSetState(() {});
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/Checkbox56567.png',
                                          width: 24.0,
                                          height: 24.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  if (FFAppState()
                                          .sanidade
                                          .contains(sanidadeOpItem) ==
                                      true)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        FFAppState()
                                            .removeFromSanidade(sanidadeOpItem);
                                        safeSetState(() {});
                                        if (sanidadeOpItem == 'Vacina') {
                                          FFAppState().vacinasCount =
                                              FFAppState().vacinasCount + -1;
                                          safeSetState(() {});
                                        } else if (sanidadeOpItem ==
                                            'Antiparasitário') {
                                          FFAppState().antiParasitarioCount =
                                              FFAppState()
                                                      .antiParasitarioCount +
                                                  -1;
                                          safeSetState(() {});
                                        } else if (sanidadeOpItem ==
                                            'Tratamento') {
                                          FFAppState().tratamentosCount =
                                              FFAppState().tratamentosCount +
                                                  -1;
                                          safeSetState(() {});
                                        } else {
                                          FFAppState().protocolosReproCount =
                                              FFAppState()
                                                      .protocolosReproCount +
                                                  -1;
                                          safeSetState(() {});
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/Checkbox45546.png',
                                          width: 24.0,
                                          height: 24.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    sanidadeOpItem,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          color: FFAppState().sanidade.contains(
                                                      sanidadeOpItem) ==
                                                  true
                                              ? Color(0xFF1E7A4C)
                                              : Color(0xFF474747),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
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
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
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
                  showLoadingIndicator: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
