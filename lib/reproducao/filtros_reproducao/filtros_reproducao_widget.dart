import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'filtros_reproducao_model.dart';
export 'filtros_reproducao_model.dart';

class FiltrosReproducaoWidget extends StatefulWidget {
  const FiltrosReproducaoWidget({super.key});

  @override
  State<FiltrosReproducaoWidget> createState() =>
      _FiltrosReproducaoWidgetState();
}

class _FiltrosReproducaoWidgetState extends State<FiltrosReproducaoWidget> {
  late FiltrosReproducaoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FiltrosReproducaoModel());

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

    return FutureBuilder<List<ListarReproducoesRow>>(
      future: SQLiteManager.instance.listarReproducoes(
        idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }
        final optionsListarReproducoesRowList = snapshot.data!;

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
            height: 680.0,
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(25.0, 25.0, 25.0, 25.0),
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
                                width: 40.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            'Filtrar',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
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
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              FFAppState().filtrosAplicadosReproducao = [];
                              FFAppState().filtroReproducao = '';
                              FFAppState().filtroDataReproducao = null;
                              FFAppState().filtroDataParto = null;
                              FFAppState().filtroMatrizReproducao = '';
                              FFAppState().filtroReprodutorReproducao = '';
                              FFAppState().filtroLoteReproducao = '';
                              FFAppState().filtroInseminador = '';
                              FFAppState().filtroDataReproducaoTxt = '';
                              FFAppState().filtroPrevisaoPartoTxt = '';
                              FFAppState().filtroDataHoje = null;
                              safeSetState(() {});
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Limpar',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).accent3,
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tipo de reprodução',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: Color(0xFF2F2F2F),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (FFAppState().filtroReproducao ==
                                                'Inseminação') {
                                              FFAppState()
                                                  .removeFromFiltrosAplicadosReproducao(
                                                      FFAppState()
                                                          .filtroReproducao);
                                              safeSetState(() {});
                                              FFAppState().filtroReproducao =
                                                  '';
                                              safeSetState(() {});
                                            } else {
                                              FFAppState()
                                                  .removeFromFiltrosAplicadosReproducao(
                                                      FFAppState()
                                                          .filtroReproducao);
                                              safeSetState(() {});
                                              FFAppState().filtroReproducao =
                                                  'Inseminação';
                                              safeSetState(() {});
                                              FFAppState()
                                                  .addToFiltrosAplicadosReproducao(
                                                      FFAppState()
                                                          .filtroReproducao);
                                              safeSetState(() {});
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(100.0),
                                              bottomRight:
                                                  Radius.circular(100.0),
                                              topLeft: Radius.circular(100.0),
                                              topRight: Radius.circular(100.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FFAppState()
                                                            .filtroReproducao ==
                                                        'Inseminação'
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .customColor7
                                                    : Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(100.0),
                                                  bottomRight:
                                                      Radius.circular(100.0),
                                                  topLeft:
                                                      Radius.circular(100.0),
                                                  topRight:
                                                      Radius.circular(100.0),
                                                ),
                                                border: Border.all(
                                                  color: FFAppState()
                                                              .filtroReproducao ==
                                                          'Inseminação'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .customColor5,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'Inseminação',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FFAppState()
                                                                        .filtroReproducao ==
                                                                    'Inseminação'
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    if (FFAppState()
                                                            .filtroReproducao ==
                                                        'Inseminação')
                                                      Icon(
                                                        Icons.close,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 16.0,
                                                      ),
                                                  ].divide(
                                                      SizedBox(width: 8.0)),
                                                ),
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
                                            if (FFAppState().filtroReproducao ==
                                                'Monta Natural') {
                                              FFAppState()
                                                  .removeFromFiltrosAplicadosReproducao(
                                                      FFAppState()
                                                          .filtroReproducao);
                                              safeSetState(() {});
                                              FFAppState().filtroReproducao =
                                                  '';
                                              safeSetState(() {});
                                            } else {
                                              FFAppState()
                                                  .removeFromFiltrosAplicadosReproducao(
                                                      FFAppState()
                                                          .filtroReproducao);
                                              safeSetState(() {});
                                              FFAppState().filtroReproducao =
                                                  'Monta Natural';
                                              safeSetState(() {});
                                              FFAppState()
                                                  .addToFiltrosAplicadosReproducao(
                                                      FFAppState()
                                                          .filtroReproducao);
                                              safeSetState(() {});
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(100.0),
                                              bottomRight:
                                                  Radius.circular(100.0),
                                              topLeft: Radius.circular(100.0),
                                              topRight: Radius.circular(100.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FFAppState()
                                                            .filtroReproducao ==
                                                        'Monta Natural'
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .customColor7
                                                    : Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(100.0),
                                                  bottomRight:
                                                      Radius.circular(100.0),
                                                  topLeft:
                                                      Radius.circular(100.0),
                                                  topRight:
                                                      Radius.circular(100.0),
                                                ),
                                                border: Border.all(
                                                  color: FFAppState()
                                                              .filtroReproducao ==
                                                          'Monta Natural'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .customColor5,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'Monta Natural',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FFAppState()
                                                                        .filtroReproducao ==
                                                                    'Monta Natural'
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    if (FFAppState()
                                                            .filtroReproducao ==
                                                        'Monta Natural')
                                                      Icon(
                                                        Icons.close,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 16.0,
                                                      ),
                                                  ].divide(
                                                      SizedBox(width: 8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Data da reprodução',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xFF2F2F2F),
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropDownValueController1 ??=
                                              FormFieldController<String>(null),
                                          options: [
                                            'Últimos 30 dias',
                                            'Últimos 60 dias',
                                            'Últimos 90 dias'
                                          ],
                                          onChanged: (val) async {
                                            safeSetState(() =>
                                                _model.dropDownValue1 = val);
                                            FFAppState().filtroDataReproducao =
                                                () {
                                              if (_model.dropDownValue1 ==
                                                  'Últimos 30 dias') {
                                                return functions.hojeMenos30();
                                              } else if (_model
                                                      .dropDownValue1 ==
                                                  'Últimos 60 dias') {
                                                return functions.hojeMenos60();
                                              } else if (_model
                                                      .dropDownValue1 ==
                                                  'Últimos 90 dias') {
                                                return functions.hojeMenos90();
                                              } else {
                                                return getCurrentTimestamp;
                                              }
                                            }();
                                            FFAppState()
                                                    .filtroDataReproducaoTxt =
                                                _model.dropDownValue1!;
                                            safeSetState(() {});
                                          },
                                          width: 200.0,
                                          height: 56.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          hintText: 'Selecionar período...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .customColor3,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                        Text(
                                          () {
                                            if (_model.dropDownValue1 ==
                                                'Últimos 30 dias') {
                                              return '${dateTimeFormat(
                                                "dMMM",
                                                functions.hojeMenos30(),
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )} - ${dateTimeFormat(
                                                "dMMM",
                                                getCurrentTimestamp,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )}';
                                            } else if (_model.dropDownValue1 ==
                                                'Últimos 60 dias') {
                                              return '${dateTimeFormat(
                                                "dMMM",
                                                functions.hojeMenos60(),
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )} - ${dateTimeFormat(
                                                "dMMM",
                                                getCurrentTimestamp,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )}';
                                            } else if (_model.dropDownValue1 ==
                                                'Últimos 90 dias') {
                                              return '${dateTimeFormat(
                                                "dMMM",
                                                functions.hojeMenos90(),
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )} - ${dateTimeFormat(
                                                "dMMM",
                                                getCurrentTimestamp,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )}';
                                            } else {
                                              return ' ';
                                            }
                                          }(),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Previsão de parto',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xFF2F2F2F),
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropDownValueController2 ??=
                                              FormFieldController<String>(null),
                                          options: [
                                            'em 1 mês',
                                            'em 2 meses',
                                            'em 3 meses'
                                          ],
                                          onChanged: (val) async {
                                            safeSetState(() =>
                                                _model.dropDownValue2 = val);
                                            FFAppState().filtroDataParto = () {
                                              if (_model.dropDownValue2 ==
                                                  'em 1 mês') {
                                                return functions.hojeMais30();
                                              } else if (_model
                                                      .dropDownValue2 ==
                                                  'em 2 meses') {
                                                return functions.hojeMais60();
                                              } else if (_model
                                                      .dropDownValue2 ==
                                                  'em 3 meses') {
                                                return functions.hojeMais90();
                                              } else {
                                                return getCurrentTimestamp;
                                              }
                                            }();
                                            FFAppState()
                                                    .filtroPrevisaoPartoTxt =
                                                _model.dropDownValue2!;
                                            FFAppState().filtroDataHoje =
                                                getCurrentTimestamp;
                                            safeSetState(() {});
                                          },
                                          width: 200.0,
                                          height: 56.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          hintText: 'Selecionar período...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .customColor3,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                        Text(
                                          () {
                                            if (_model.dropDownValue2 ==
                                                'em 1 mês') {
                                              return '${dateTimeFormat(
                                                "dMMM",
                                                getCurrentTimestamp,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )} - ${dateTimeFormat(
                                                "dMMM",
                                                functions.hojeMais30(),
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )}';
                                            } else if (_model.dropDownValue2 ==
                                                'em 2 meses') {
                                              return '${dateTimeFormat(
                                                "dMMM",
                                                getCurrentTimestamp,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )} - ${dateTimeFormat(
                                                "dMMM",
                                                functions.hojeMais60(),
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )}';
                                            } else if (_model.dropDownValue2 ==
                                                'em 3 meses') {
                                              return '${dateTimeFormat(
                                                "dMMM",
                                                getCurrentTimestamp,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )} - ${dateTimeFormat(
                                                "dMMM",
                                                functions.hojeMais90(),
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              )}';
                                            } else {
                                              return ' ';
                                            }
                                          }(),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
                          ),
                          if (responsiveVisibility(
                            context: context,
                            phone: false,
                            tablet: false,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Matriz',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF2F2F2F),
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          final matriz =
                                              optionsListarReproducoesRowList
                                                  .where((e) =>
                                                      e.nomeMatriz != ' ')
                                                  .toList()
                                                  .map((e) => e.nomeMatriz)
                                                  .withoutNulls
                                                  .toList()
                                                  .unique((e) => e)
                                                  .toList();

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                  matriz.length, (matrizIndex) {
                                                final matrizItem =
                                                    matriz[matrizIndex];
                                                return InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (FFAppState()
                                                                .filtroMatrizReproducao !=
                                                            null &&
                                                        FFAppState()
                                                                .filtroMatrizReproducao !=
                                                            '') {
                                                      if (FFAppState()
                                                              .filtroMatrizReproducao ==
                                                          matrizItem) {
                                                        FFAppState()
                                                            .removeFromFiltrosAplicadosReproducao(
                                                                FFAppState()
                                                                    .filtroMatrizReproducao);
                                                        safeSetState(() {});
                                                        FFAppState()
                                                            .filtroMatrizReproducao = '';
                                                        safeSetState(() {});
                                                      } else {
                                                        FFAppState()
                                                            .removeFromFiltrosAplicadosReproducao(
                                                                FFAppState()
                                                                    .filtroMatrizReproducao);
                                                        safeSetState(() {});
                                                        FFAppState()
                                                            .addToFiltrosAplicadosReproducao(
                                                                matrizItem);
                                                        FFAppState()
                                                                .filtroMatrizReproducao =
                                                            matrizItem;
                                                        safeSetState(() {});
                                                      }
                                                    } else {
                                                      FFAppState()
                                                          .addToFiltrosAplicadosReproducao(
                                                              matrizItem);
                                                      FFAppState()
                                                              .filtroMatrizReproducao =
                                                          matrizItem;
                                                      safeSetState(() {});
                                                    }
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(
                                                              100.0),
                                                      bottomRight:
                                                          Radius.circular(
                                                              100.0),
                                                      topLeft: Radius.circular(
                                                          100.0),
                                                      topRight: Radius.circular(
                                                          100.0),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: FFAppState()
                                                                    .filtroMatrizReproducao ==
                                                                matrizItem
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .customColor7
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  100.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  100.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  100.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  100.0),
                                                        ),
                                                        border: Border.all(
                                                          color: FFAppState()
                                                                      .filtroMatrizReproducao ==
                                                                  matrizItem
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .secondary
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .customColor5,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    4.0,
                                                                    8.0,
                                                                    4.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              matrizItem,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FFAppState().filtroCategoriasRebanho ==
                                                                            matrizItem
                                                                        ? Color(
                                                                            0xFF1E7A4C)
                                                                        : FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            if (FFAppState()
                                                                    .filtroMatrizReproducao ==
                                                                matrizItem)
                                                              Icon(
                                                                Icons.close,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                size: 16.0,
                                                              ),
                                                          ].divide(SizedBox(
                                                              width: 8.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).divide(SizedBox(width: 8.0)),
                                            ),
                                          );
                                        },
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          if (responsiveVisibility(
                            context: context,
                            phone: false,
                            tablet: false,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reprodutor',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF2F2F2F),
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          final reprodutor =
                                              optionsListarReproducoesRowList
                                                  .where((e) =>
                                                      e.nomeReprodutor != ' ')
                                                  .toList()
                                                  .map((e) => e.nomeReprodutor)
                                                  .withoutNulls
                                                  .toList()
                                                  .unique((e) => e)
                                                  .toList();

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                  reprodutor.length,
                                                  (reprodutorIndex) {
                                                final reprodutorItem =
                                                    reprodutor[reprodutorIndex];
                                                return InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (FFAppState()
                                                                .filtroReprodutorReproducao !=
                                                            null &&
                                                        FFAppState()
                                                                .filtroReprodutorReproducao !=
                                                            '') {
                                                      if (FFAppState()
                                                              .filtroReprodutorReproducao ==
                                                          reprodutorItem) {
                                                        FFAppState()
                                                            .removeFromFiltrosAplicadosReproducao(
                                                                FFAppState()
                                                                    .filtroReprodutorReproducao);
                                                        safeSetState(() {});
                                                        FFAppState()
                                                            .filtroCategoriasRebanho = '';
                                                        FFAppState()
                                                            .filtroReprodutorReproducao = '';
                                                        safeSetState(() {});
                                                      } else {
                                                        FFAppState()
                                                            .removeFromFiltrosAplicadosReproducao(
                                                                FFAppState()
                                                                    .filtroReprodutorReproducao);
                                                        safeSetState(() {});
                                                        FFAppState()
                                                            .addToFiltrosAplicadosReproducao(
                                                                reprodutorItem);
                                                        FFAppState()
                                                                .filtroReprodutorReproducao =
                                                            reprodutorItem;
                                                        safeSetState(() {});
                                                      }
                                                    } else {
                                                      FFAppState()
                                                          .addToFiltrosAplicadosReproducao(
                                                              reprodutorItem);
                                                      FFAppState()
                                                              .filtroReprodutorReproducao =
                                                          reprodutorItem;
                                                      safeSetState(() {});
                                                    }
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(
                                                              100.0),
                                                      bottomRight:
                                                          Radius.circular(
                                                              100.0),
                                                      topLeft: Radius.circular(
                                                          100.0),
                                                      topRight: Radius.circular(
                                                          100.0),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: FFAppState()
                                                                    .filtroReprodutorReproducao ==
                                                                reprodutorItem
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .customColor7
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  100.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  100.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  100.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  100.0),
                                                        ),
                                                        border: Border.all(
                                                          color: FFAppState()
                                                                      .filtroReprodutorReproducao ==
                                                                  reprodutorItem
                                                              ? FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .secondary
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .customColor5,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    4.0,
                                                                    8.0,
                                                                    4.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              reprodutorItem,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FFAppState().filtroReprodutorReproducao ==
                                                                            reprodutorItem
                                                                        ? Color(
                                                                            0xFF1E7A4C)
                                                                        : FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            if (FFAppState()
                                                                    .filtroReprodutorReproducao ==
                                                                reprodutorItem)
                                                              Icon(
                                                                Icons.close,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                size: 16.0,
                                                              ),
                                                          ].divide(SizedBox(
                                                              width: 8.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).divide(SizedBox(width: 8.0)),
                                            ),
                                          );
                                        },
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          if (responsiveVisibility(
                            context: context,
                            phone: false,
                            tablet: false,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Lote',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF2F2F2F),
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(100.0),
                                                bottomRight:
                                                    Radius.circular(100.0),
                                                topLeft: Radius.circular(100.0),
                                                topRight:
                                                    Radius.circular(100.0),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(100.0),
                                                    bottomRight:
                                                        Radius.circular(100.0),
                                                    topLeft:
                                                        Radius.circular(100.0),
                                                    topRight:
                                                        Radius.circular(100.0),
                                                  ),
                                                  border: Border.all(
                                                    color: Color(0xFFEDEDED),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 4.0, 8.0, 4.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Hello World',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Icon(
                                                        Icons.close,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 16.0,
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lote',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xFF2F2F2F),
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        final lote =
                                            optionsListarReproducoesRowList
                                                .where((e) => e.loteNome != ' ')
                                                .toList()
                                                .map((e) => e.loteNome)
                                                .withoutNulls
                                                .toList()
                                                .unique((e) => e)
                                                .toList();

                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(lote.length,
                                                (loteIndex) {
                                              final loteItem = lote[loteIndex];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (FFAppState()
                                                              .filtroLoteReproducao !=
                                                          null &&
                                                      FFAppState()
                                                              .filtroLoteReproducao !=
                                                          '') {
                                                    if (FFAppState()
                                                            .filtroLoteReproducao ==
                                                        loteItem) {
                                                      FFAppState()
                                                          .removeFromFiltrosAplicadosReproducao(
                                                              FFAppState()
                                                                  .filtroLoteReproducao);
                                                      safeSetState(() {});
                                                      FFAppState()
                                                          .filtroLoteReproducao = '';
                                                      safeSetState(() {});
                                                    } else {
                                                      FFAppState()
                                                          .removeFromFiltrosAplicadosReproducao(
                                                              FFAppState()
                                                                  .filtroLoteReproducao);
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .filtroLoteReproducao =
                                                          loteItem;
                                                      FFAppState()
                                                          .addToFiltrosAplicadosReproducao(
                                                              loteItem);
                                                      safeSetState(() {});
                                                    }
                                                  } else {
                                                    FFAppState()
                                                            .filtroLoteReproducao =
                                                        loteItem;
                                                    FFAppState()
                                                        .addToFiltrosAplicadosReproducao(
                                                            loteItem);
                                                    safeSetState(() {});
                                                  }
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(100.0),
                                                    bottomRight:
                                                        Radius.circular(100.0),
                                                    topLeft:
                                                        Radius.circular(100.0),
                                                    topRight:
                                                        Radius.circular(100.0),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FFAppState()
                                                                  .filtroLoteReproducao ==
                                                              loteItem
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .customColor7
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                100.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                100.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                100.0),
                                                        topRight:
                                                            Radius.circular(
                                                                100.0),
                                                      ),
                                                      border: Border.all(
                                                        color: FFAppState()
                                                                    .filtroLoteReproducao ==
                                                                loteItem
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .customColor5,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  4.0,
                                                                  8.0,
                                                                  4.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            loteItem,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FFAppState()
                                                                              .filtroLoteReproducao ==
                                                                          loteItem
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                          if (loteItem ==
                                                              FFAppState()
                                                                  .filtroLoteReproducao)
                                                            Icon(
                                                              Icons.close,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                        ].divide(SizedBox(
                                                            width: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).divide(SizedBox(width: 8.0)),
                                          ),
                                        );
                                      },
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Inseminador',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xFF2F2F2F),
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        final inseminador =
                                            optionsListarReproducoesRowList
                                                .where((e) =>
                                                    e.inseminador != null &&
                                                    e.inseminador != '')
                                                .toList()
                                                .map((e) => e.inseminador)
                                                .withoutNulls
                                                .toList()
                                                .unique((e) => e)
                                                .toList();

                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                                inseminador.length,
                                                (inseminadorIndex) {
                                              final inseminadorItem =
                                                  inseminador[inseminadorIndex];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (FFAppState()
                                                          .filtroInseminador ==
                                                      inseminadorItem) {
                                                    FFAppState()
                                                        .removeFromFiltrosAplicadosReproducao(
                                                            FFAppState()
                                                                .filtroInseminador);
                                                    safeSetState(() {});
                                                    FFAppState()
                                                        .filtroInseminador = '';
                                                    safeSetState(() {});
                                                  } else {
                                                    FFAppState()
                                                        .removeFromFiltrosAplicadosReproducao(
                                                            FFAppState()
                                                                .filtroInseminador);
                                                    safeSetState(() {});
                                                    FFAppState()
                                                            .filtroInseminador =
                                                        inseminadorItem;
                                                    safeSetState(() {});
                                                    FFAppState()
                                                        .addToFiltrosAplicadosReproducao(
                                                            FFAppState()
                                                                .filtroInseminador);
                                                    safeSetState(() {});
                                                  }
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(100.0),
                                                    bottomRight:
                                                        Radius.circular(100.0),
                                                    topLeft:
                                                        Radius.circular(100.0),
                                                    topRight:
                                                        Radius.circular(100.0),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FFAppState()
                                                                  .filtroInseminador ==
                                                              inseminadorItem
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .customColor7
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                100.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                100.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                100.0),
                                                        topRight:
                                                            Radius.circular(
                                                                100.0),
                                                      ),
                                                      border: Border.all(
                                                        color: FFAppState()
                                                                    .filtroInseminador ==
                                                                inseminadorItem
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .secondary
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .customColor5,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  4.0,
                                                                  8.0,
                                                                  4.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            inseminadorItem,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FFAppState()
                                                                              .filtroInseminador ==
                                                                          inseminadorItem
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                          if (FFAppState()
                                                                  .filtroInseminador ==
                                                              inseminadorItem)
                                                            Icon(
                                                              Icons.close,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 16.0,
                                                            ),
                                                        ].divide(SizedBox(
                                                            width: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).divide(SizedBox(width: 8.0)),
                                          ),
                                        );
                                      },
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 32.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      text: 'Ver resultados',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 47.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFF28A365),
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleSmallFamily,
                              color: Colors.white,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleSmallIsCustom,
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
          ),
        );
      },
    );
  }
}
