import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/rebanho/popup_rebanhos/popup_rebanhos_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'filtro_sanidades_model.dart';
export 'filtro_sanidades_model.dart';

class FiltroSanidadesWidget extends StatefulWidget {
  const FiltroSanidadesWidget({super.key});

  @override
  State<FiltroSanidadesWidget> createState() => _FiltroSanidadesWidgetState();
}

class _FiltroSanidadesWidgetState extends State<FiltroSanidadesWidget> {
  late FiltroSanidadesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FiltroSanidadesModel());

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
        height: 790.0,
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
            Column(
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
                              width: 36.0,
                              height: 36.0,
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
                            FFAppState().filtroVacinacao = '';
                            FFAppState().filtrosSanidades = [];
                            FFAppState().filtroAntiparasitario = '';
                            FFAppState().filtroTratamento = '';
                            FFAppState().filtroProtocoloReprodutivo = '';
                            FFAppState().filtroSanidadeAnimal = '';
                            FFAppState().filtroSanidadeAnimalNome = '';
                            FFAppState().filtroLoteSanidade = '';
                            FFAppState().filtroLoteSanidadeNome = '';
                            FFAppState().filtroDataSanidade = null;
                            FFAppState().filtroDataSanidadeTxt = '';
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
                                  color: Color(0xFFBEBEBE),
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
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 550.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                                    'Data da sanidade',
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
                                                .dropDownValueController ??=
                                            FormFieldController<String>(null),
                                        options: [
                                          'Últimos 30 dias',
                                          'Últimos 60 dias',
                                          'Últimos 90 dias'
                                        ],
                                        onChanged: (val) async {
                                          safeSetState(
                                              () => _model.dropDownValue = val);
                                          FFAppState().filtroDataSanidade = () {
                                            if (_model.dropDownValue ==
                                                'Últimos 30 dias') {
                                              return functions.hojeMenos30();
                                            } else if (_model.dropDownValue ==
                                                'Últimos 60 dias') {
                                              return functions.hojeMenos60();
                                            } else if (_model.dropDownValue ==
                                                'Últimos 90 dias') {
                                              return functions.hojeMenos90();
                                            } else {
                                              return getCurrentTimestamp;
                                            }
                                          }();
                                          FFAppState().filtroDataSanidadeTxt =
                                              _model.dropDownValue!;
                                          safeSetState(() {});
                                        },
                                        width: 200.0,
                                        height: 56.0,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        hintText: 'Selecionar período...',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .customColor3,
                                        elevation: 2.0,
                                        borderColor: Colors.transparent,
                                        borderWidth: 0.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                        hidesUnderline: true,
                                        isOverButton: false,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                      Text(
                                        () {
                                          if (_model.dropDownValue ==
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
                                          } else if (_model.dropDownValue ==
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
                                          } else if (_model.dropDownValue ==
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
                                                  !FlutterFlowTheme.of(context)
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
                                    'Tipos de vacinação',
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
                                      final vacina =
                                          FFAppState().vacinacao.toList();

                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(vacina.length,
                                              (vacinaIndex) {
                                            final vacinaItem =
                                                vacina[vacinaIndex];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (FFAppState()
                                                        .filtroVacinacao ==
                                                    vacinaItem) {
                                                  FFAppState()
                                                      .removeFromFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroVacinacao);
                                                  safeSetState(() {});
                                                  FFAppState().filtroVacinacao =
                                                      '';
                                                  safeSetState(() {});
                                                } else {
                                                  FFAppState()
                                                      .removeFromFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroVacinacao);
                                                  safeSetState(() {});
                                                  FFAppState().filtroVacinacao =
                                                      vacinaItem;
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .addToFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroVacinacao);
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: colorFromCssString(
                                                    FFAppState().filtroVacinacao ==
                                                            vacinaItem
                                                        ? '#D6F5E5'
                                                        : '#FFFFFF',
                                                    defaultColor:
                                                        Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: colorFromCssString(
                                                      FFAppState().filtroVacinacao ==
                                                              vacinaItem
                                                          ? '#1E7A4C'
                                                          : '#EDEDED',
                                                      defaultColor:
                                                          Color(0xFFEDEDED),
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 8.0, 16.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        vacinaItem,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color:
                                                                      colorFromCssString(
                                                                    FFAppState().filtroVacinacao ==
                                                                            vacinaItem
                                                                        ? '#1E7A4C'
                                                                        : '#2F2F2F',
                                                                    defaultColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      if (FFAppState()
                                                              .filtroVacinacao ==
                                                          vacinaItem)
                                                        Icon(
                                                          Icons.close,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 16.0,
                                                        ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).divide(SizedBox(width: 8.0)),
                                        ),
                                      );
                                    },
                                  ),
                                ].divide(SizedBox(height: 5.0)),
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
                                    'Tipos de antiparasitários',
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
                                      final antiparasitario =
                                          FFAppState().antiparasitario.toList();

                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                              antiparasitario.length,
                                              (antiparasitarioIndex) {
                                            final antiparasitarioItem =
                                                antiparasitario[
                                                    antiparasitarioIndex];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (FFAppState()
                                                        .filtroAntiparasitario ==
                                                    antiparasitarioItem) {
                                                  FFAppState()
                                                      .removeFromFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroAntiparasitario);
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .filtroAntiparasitario = '';
                                                  safeSetState(() {});
                                                } else {
                                                  FFAppState()
                                                      .removeFromFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroAntiparasitario);
                                                  safeSetState(() {});
                                                  FFAppState()
                                                          .filtroAntiparasitario =
                                                      antiparasitarioItem;
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .addToFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroAntiparasitario);
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: colorFromCssString(
                                                    FFAppState().filtroAntiparasitario ==
                                                            antiparasitarioItem
                                                        ? '#D6F5E5'
                                                        : '#FFFFFF',
                                                    defaultColor:
                                                        Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: colorFromCssString(
                                                      FFAppState().filtroAntiparasitario ==
                                                              antiparasitarioItem
                                                          ? '#1E7A4C'
                                                          : '#EDEDED',
                                                      defaultColor:
                                                          Color(0xFFEDEDED),
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 8.0, 16.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        antiparasitarioItem,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color:
                                                                      colorFromCssString(
                                                                    FFAppState().filtroAntiparasitario ==
                                                                            antiparasitarioItem
                                                                        ? '#1E7A4C'
                                                                        : '#2F2F2F',
                                                                    defaultColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      if (FFAppState()
                                                              .filtroAntiparasitario ==
                                                          antiparasitarioItem)
                                                        Icon(
                                                          Icons.close,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 16.0,
                                                        ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).divide(SizedBox(width: 8.0)),
                                        ),
                                      );
                                    },
                                  ),
                                ].divide(SizedBox(height: 5.0)),
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
                                    'Tipos de tratamentos',
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
                                      final tratamentos =
                                          FFAppState().tratamento.toList();

                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                              List.generate(tratamentos.length,
                                                  (tratamentosIndex) {
                                            final tratamentosItem =
                                                tratamentos[tratamentosIndex];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (FFAppState()
                                                        .filtroTratamento ==
                                                    tratamentosItem) {
                                                  FFAppState()
                                                      .removeFromFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroTratamento);
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .filtroTratamento = '';
                                                  safeSetState(() {});
                                                } else {
                                                  FFAppState()
                                                      .removeFromFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroTratamento);
                                                  safeSetState(() {});
                                                  FFAppState()
                                                          .filtroTratamento =
                                                      tratamentosItem;
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .addToFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroTratamento);
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: colorFromCssString(
                                                    FFAppState().filtroTratamento ==
                                                            tratamentosItem
                                                        ? '#D6F5E5'
                                                        : '#FFFFFF',
                                                    defaultColor:
                                                        Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: colorFromCssString(
                                                      FFAppState().filtroTratamento ==
                                                              tratamentosItem
                                                          ? '#1E7A4C'
                                                          : '#EDEDED',
                                                      defaultColor:
                                                          Color(0xFFEDEDED),
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 8.0, 16.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        tratamentosItem,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color:
                                                                      colorFromCssString(
                                                                    FFAppState().filtroTratamento ==
                                                                            tratamentosItem
                                                                        ? '#1E7A4C'
                                                                        : '#2F2F2F',
                                                                    defaultColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      if (FFAppState()
                                                              .filtroTratamento ==
                                                          tratamentosItem)
                                                        Icon(
                                                          Icons.close,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 16.0,
                                                        ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).divide(SizedBox(width: 8.0)),
                                        ),
                                      );
                                    },
                                  ),
                                ].divide(SizedBox(height: 5.0)),
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
                                    'Tipos de protocolos reprodutivos',
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
                                      final protocolos = FFAppState()
                                          .protocoloReprodutivo
                                          .toList();

                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                              List.generate(protocolos.length,
                                                  (protocolosIndex) {
                                            final protocolosItem =
                                                protocolos[protocolosIndex];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (FFAppState()
                                                        .filtroProtocoloReprodutivo ==
                                                    protocolosItem) {
                                                  FFAppState()
                                                      .removeFromFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroProtocoloReprodutivo);
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .filtroProtocoloReprodutivo = '';
                                                  safeSetState(() {});
                                                } else {
                                                  FFAppState()
                                                      .removeFromFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroProtocoloReprodutivo);
                                                  safeSetState(() {});
                                                  FFAppState()
                                                          .filtroAntiparasitario =
                                                      protocolosItem;
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .addToFiltrosSanidades(
                                                          FFAppState()
                                                              .filtroProtocoloReprodutivo);
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: colorFromCssString(
                                                    FFAppState().filtroProtocoloReprodutivo ==
                                                            protocolosItem
                                                        ? '#D6F5E5'
                                                        : '#FFFFFF',
                                                    defaultColor:
                                                        Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: colorFromCssString(
                                                      FFAppState().filtroProtocoloReprodutivo ==
                                                              protocolosItem
                                                          ? '#1E7A4C'
                                                          : '#EDEDED',
                                                      defaultColor:
                                                          Color(0xFFEDEDED),
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 8.0, 16.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        protocolosItem,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color:
                                                                      colorFromCssString(
                                                                    FFAppState().filtroProtocoloReprodutivo ==
                                                                            protocolosItem
                                                                        ? '#1E7A4C'
                                                                        : '#2F2F2F',
                                                                    defaultColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      if (FFAppState()
                                                              .filtroProtocoloReprodutivo ==
                                                          protocolosItem)
                                                        Icon(
                                                          Icons.close,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 16.0,
                                                        ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).divide(SizedBox(width: 8.0)),
                                        ),
                                      );
                                    },
                                  ),
                                ].divide(SizedBox(height: 5.0)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: FutureBuilder<List<ListarLotesRow>>(
                            future: SQLiteManager.instance.listarLotes(
                              idPropriedade: FFAppState()
                                  .propriedadeSelecionada
                                  .idPropriedade,
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
                              final containerListarLotesRowList =
                                  snapshot.data!;

                              return Container(
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
                                      Builder(
                                        builder: (context) {
                                          final lotes =
                                              containerListarLotesRowList
                                                  .toList();

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                  lotes.length, (lotesIndex) {
                                                final lotesItem =
                                                    lotes[lotesIndex];
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
                                                            .filtroLoteSanidade ==
                                                        lotesItem.idLote) {
                                                      FFAppState()
                                                          .removeFromFiltrosSanidades(
                                                              FFAppState()
                                                                  .filtroLoteSanidadeNome);
                                                      safeSetState(() {});
                                                      FFAppState()
                                                          .filtroLoteSanidade = '';
                                                      FFAppState()
                                                          .filtroLoteSanidadeNome = '';
                                                      safeSetState(() {});
                                                    } else {
                                                      FFAppState()
                                                          .removeFromFiltrosSanidades(
                                                              FFAppState()
                                                                  .filtroLoteSanidadeNome);
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .filtroLoteSanidade =
                                                          lotesItem.idLote!;
                                                      FFAppState()
                                                              .filtroLoteSanidadeNome =
                                                          lotesItem.nome!;
                                                      safeSetState(() {});
                                                      FFAppState()
                                                          .addToFiltrosSanidades(
                                                              FFAppState()
                                                                  .filtroLoteSanidadeNome);
                                                      safeSetState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: colorFromCssString(
                                                        FFAppState().filtroLoteSanidade ==
                                                                lotesItem.idLote
                                                            ? '#D6F5E5'
                                                            : '#FFFFFF',
                                                        defaultColor:
                                                            Colors.transparent,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color:
                                                            colorFromCssString(
                                                          FFAppState().filtroLoteSanidade ==
                                                                  lotesItem
                                                                      .idLote
                                                              ? '#1E7A4C'
                                                              : '#EDEDED',
                                                          defaultColor:
                                                              Color(0xFFEDEDED),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  8.0,
                                                                  16.0,
                                                                  8.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              lotesItem.nome,
                                                              'Nome lote',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color:
                                                                      colorFromCssString(
                                                                    FFAppState().filtroLoteSanidade ==
                                                                            lotesItem.idLote
                                                                        ? '#1E7A4C'
                                                                        : '#2F2F2F',
                                                                    defaultColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          if (FFAppState()
                                                                  .filtroLoteSanidade ==
                                                              lotesItem.idLote)
                                                            Icon(
                                                              Icons.close,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 16.0,
                                                            ),
                                                        ].divide(SizedBox(
                                                            width: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).divide(SizedBox(width: 8.0)),
                                            ),
                                          );
                                        },
                                      ),
                                    ].divide(SizedBox(height: 5.0)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: FutureBuilder<List<ListarRebanhosRow>>(
                            future: SQLiteManager.instance.listarRebanhos(
                              idPropriedade: FFAppState()
                                  .propriedadeSelecionada
                                  .idPropriedade,
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
                              final containerListarRebanhosRowList =
                                  snapshot.data!;

                              return Container(
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
                                        'Animal',
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
                                          final rebanho =
                                              containerListarRebanhosRowList
                                                  .toList();

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children:
                                                  List.generate(rebanho.length,
                                                      (rebanhoIndex) {
                                                final rebanhoItem =
                                                    rebanho[rebanhoIndex];
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
                                                            .filtroSanidadeAnimal ==
                                                        rebanhoItem.idRebanho) {
                                                      FFAppState()
                                                          .removeFromFiltrosSanidades(
                                                              FFAppState()
                                                                  .filtroSanidadeAnimalNome);
                                                      safeSetState(() {});
                                                      FFAppState()
                                                          .filtroSanidadeAnimal = '';
                                                      FFAppState()
                                                          .filtroSanidadeAnimalNome = '';
                                                      safeSetState(() {});
                                                    } else {
                                                      FFAppState()
                                                          .removeFromFiltrosSanidades(
                                                              FFAppState()
                                                                  .filtroSanidadeAnimalNome);
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .filtroSanidadeAnimal =
                                                          rebanhoItem
                                                              .idRebanho!;
                                                      FFAppState()
                                                              .filtroSanidadeAnimalNome =
                                                          rebanhoItem.nome!;
                                                      safeSetState(() {});
                                                      FFAppState()
                                                          .addToFiltrosSanidades(
                                                              FFAppState()
                                                                  .filtroSanidadeAnimalNome);
                                                      safeSetState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: colorFromCssString(
                                                        FFAppState().filtroSanidadeAnimal ==
                                                                rebanhoItem
                                                                    .idRebanho
                                                            ? '#D6F5E5'
                                                            : '#FFFFFF',
                                                        defaultColor:
                                                            Colors.transparent,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color:
                                                            colorFromCssString(
                                                          FFAppState().filtroSanidadeAnimal ==
                                                                  rebanhoItem
                                                                      .idRebanho
                                                              ? '#1E7A4C'
                                                              : '#EDEDED',
                                                          defaultColor:
                                                              Color(0xFFEDEDED),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  8.0,
                                                                  16.0,
                                                                  8.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              rebanhoItem.nome,
                                                              'Nome animal',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color:
                                                                      colorFromCssString(
                                                                    FFAppState().filtroSanidadeAnimal ==
                                                                            rebanhoItem.idRebanho
                                                                        ? '#1E7A4C'
                                                                        : '#2F2F2F',
                                                                    defaultColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          if (FFAppState()
                                                                  .filtroSanidadeAnimal ==
                                                              rebanhoItem
                                                                  .idRebanho)
                                                            Icon(
                                                              Icons.close,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 16.0,
                                                            ),
                                                        ].divide(SizedBox(
                                                            width: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).divide(SizedBox(width: 8.0)),
                                            ),
                                          );
                                        },
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Builder(
                                              builder: (context) => InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await showAlignedDialog(
                                                    barrierColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    isGlobal: false,
                                                    avoidOverflow: true,
                                                    targetAnchor:
                                                        AlignmentDirectional(
                                                                0.0, 1.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    followerAnchor:
                                                        AlignmentDirectional(
                                                                0.0, -1.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    builder: (dialogContext) {
                                                      return Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: Container(
                                                          height: 450.0,
                                                          width:
                                                              double.infinity,
                                                          child:
                                                              PopupRebanhosWidget(
                                                            sanidade: true,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 56.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .customColor3,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 0.0,
                                                                16.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            '${FFAppState().rebanhoSanidadeSelecionado.numAnimal} • ${valueOrDefault<String>(
                                                              FFAppState()
                                                                          .rebanhoSanidadeSelecionado
                                                                          .numAnimal ==
                                                                      'null'
                                                                  ? 'S/N'
                                                                  : valueOrDefault<
                                                                      String>(
                                                                      FFAppState()
                                                                          .rebanhoSanidadeSelecionado
                                                                          .numAnimal,
                                                                      'S/N',
                                                                    ),
                                                              'S/N',
                                                            )} • ${FFAppState().rebanhoSanidadeSelecionado.dataNascAnimal == 'null' ? 'N/A' : dateTimeFormat(
                                                                "d/M/y",
                                                                functions.converterParaData(
                                                                    FFAppState()
                                                                        .rebanhoSanidadeSelecionado
                                                                        .dataNascAnimal),
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )}',
                                                            'Selecionar Matriz',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .accent4,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down_sharp,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 24.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (FFAppState()
                                                  .rebanhoSanidadeSelecionado !=
                                              null)
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                FFAppState()
                                                        .rebanhoSanidadeSelecionado =
                                                    AnimalSelecionadoStruct();
                                                FFAppState()
                                                    .filtroSanidadeAnimal = '';
                                                safeSetState(() {});
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent3,
                                                size: 24.0,
                                              ),
                                            ),
                                        ].divide(SizedBox(width: 16.0)),
                                      ),
                                    ].divide(SizedBox(height: 5.0)),
                                  ),
                                ),
                              );
                            },
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
                      EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    text: 'Ver resultados',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 47.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
          ],
        ),
      ),
    );
  }
}
