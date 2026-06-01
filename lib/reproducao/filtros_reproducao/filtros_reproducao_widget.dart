import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
  static const List<String> _diagnosticoOptions = [
    'Não diagnosticado',
    'Absorção',
    'Aborto',
    'Natimorto',
    'Prenhez',
    'Vazio',
  ];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FiltrosReproducaoModel());

    _model.dataReproducaoInicio = FFAppState().filtroDataReproducao;
    _model.dataReproducaoFim = FFAppState().filtroDataReproducaoFim;
    _model.dataPartoInicio = FFAppState().filtroDataParto;
    _model.dataPartoFim = FFAppState().filtroDataPartoFim;
    _model.categoriasSelecionadas =
        List<String>.from(FFAppState().filtroCategoriaReproducao);
    _model.showCategoriaDropdown = false;
    _model.diagnosticosSelecionados =
        List<String>.from(FFAppState().filtroDiagnosticoReproducao);
    _model.showDiagnosticoDropdown = false;

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
          shape: const RoundedRectangleBorder(
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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if ((_model.showCategoriaDropdown ?? false) ||
                    (_model.showDiagnosticoDropdown ?? false)) {
                  safeSetState(() {
                    _model.showCategoriaDropdown = false;
                    _model.showDiagnosticoDropdown = false;
                  });
                }
              },
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          25.0, 25.0, 25.0, 25.0),
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
                                    color: const Color(0xFF2F2F2F),
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
                                FFAppState().filtroDataReproducaoFim = null;
                                FFAppState().filtroDataParto = null;
                                FFAppState().filtroDataPartoFim = null;
                                FFAppState().filtroMatrizReproducao = '';
                                FFAppState().filtroReprodutorReproducao = '';
                                FFAppState().filtroLoteReproducao = '';
                                FFAppState().filtroInseminador = '';
                                FFAppState().filtroDataReproducaoTxt = '';
                                FFAppState().filtroPrevisaoPartoTxt = '';
                                FFAppState().filtroDataHoje = null;
                                FFAppState().filtroCategoriaReproducao = [];
                                FFAppState().filtroDiagnosticoReproducao = [];
                                _model.dataReproducaoInicio = null;
                                _model.dataReproducaoFim = null;
                                _model.dataPartoInicio = null;
                                _model.dataPartoFim = null;
                                _model.categoriasSelecionadas = [];
                                _model.showCategoriaDropdown = false;
                                _model.diagnosticosSelecionados = [];
                                _model.showDiagnosticoDropdown = false;
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
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
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
                    const Divider(
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
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
                                            color: const Color(0xFF2F2F2F),
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
                                              if (FFAppState()
                                                      .filtroReproducao ==
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
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                  color: FFAppState()
                                                              .filtroReproducao ==
                                                          'Inseminação'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .customColor7
                                                      : Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.only(
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
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          8.0, 4.0, 8.0, 4.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Inseminação',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
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
                                                                  letterSpacing:
                                                                      0.0,
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          size: 16.0,
                                                        ),
                                                    ].divide(const SizedBox(
                                                        width: 8.0)),
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
                                              if (FFAppState()
                                                      .filtroReproducao ==
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
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                  color: FFAppState()
                                                              .filtroReproducao ==
                                                          'Monta Natural'
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .customColor7
                                                      : Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.only(
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
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          8.0, 4.0, 8.0, 4.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Monta Natural',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
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
                                                                  letterSpacing:
                                                                      0.0,
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          size: 16.0,
                                                        ),
                                                    ].divide(const SizedBox(
                                                        width: 8.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ].divide(const SizedBox(width: 8.0)),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Data da reprodução',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF2F2F2F),
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
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final picked =
                                                    await showDatePicker(
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendarOnly,
                                                  context: context,
                                                  initialDate: _model
                                                          .dataReproducaoInicio ??
                                                      getCurrentTimestamp,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2050),
                                                  builder: (context, child) {
                                                    return wrapInMaterialDatePickerTheme(
                                                      context,
                                                      child!,
                                                      headerBackgroundColor:
                                                          const Color(
                                                              0xFF28A365),
                                                      headerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      headerTextStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLargeFamily,
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLargeIsCustom,
                                                              ),
                                                      pickerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      pickerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      selectedDateTimeBackgroundColor:
                                                          const Color(
                                                              0xFF28A365),
                                                      selectedDateTimeForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      actionButtonForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      iconSize: 24.0,
                                                    );
                                                  },
                                                );
                                                if (picked != null) {
                                                  _model.dataReproducaoInicio =
                                                      DateTime(
                                                          picked.year,
                                                          picked.month,
                                                          picked.day);
                                                  FFAppState()
                                                          .filtroDataReproducao =
                                                      _model
                                                          .dataReproducaoInicio;
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
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
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        _model.dataReproducaoInicio !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "d/M/y",
                                                                _model
                                                                    .dataReproducaoInicio,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode)
                                                            : 'Data inicial',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: _model
                                                                              .dataReproducaoInicio !=
                                                                          null
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Icon(Icons.calendar_today,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 20.0),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Text('até',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        )),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final picked =
                                                    await showDatePicker(
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendarOnly,
                                                  context: context,
                                                  initialDate: _model
                                                          .dataReproducaoFim ??
                                                      getCurrentTimestamp,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2050),
                                                  builder: (context, child) {
                                                    return wrapInMaterialDatePickerTheme(
                                                      context,
                                                      child!,
                                                      headerBackgroundColor:
                                                          const Color(
                                                              0xFF28A365),
                                                      headerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      headerTextStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLargeFamily,
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLargeIsCustom,
                                                              ),
                                                      pickerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      pickerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      selectedDateTimeBackgroundColor:
                                                          const Color(
                                                              0xFF28A365),
                                                      selectedDateTimeForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      actionButtonForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      iconSize: 24.0,
                                                    );
                                                  },
                                                );
                                                if (picked != null) {
                                                  _model.dataReproducaoFim =
                                                      DateTime(
                                                          picked.year,
                                                          picked.month,
                                                          picked.day);
                                                  FFAppState()
                                                          .filtroDataReproducaoFim =
                                                      _model.dataReproducaoFim;
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
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
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        _model.dataReproducaoFim !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "d/M/y",
                                                                _model
                                                                    .dataReproducaoFim,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode)
                                                            : 'Data final',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: _model
                                                                              .dataReproducaoFim !=
                                                                          null
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Icon(Icons.calendar_today,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 20.0),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Previsão de parto',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF2F2F2F),
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
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final picked =
                                                    await showDatePicker(
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendarOnly,
                                                  context: context,
                                                  initialDate:
                                                      _model.dataPartoInicio ??
                                                          getCurrentTimestamp,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2050),
                                                  builder: (context, child) {
                                                    return wrapInMaterialDatePickerTheme(
                                                      context,
                                                      child!,
                                                      headerBackgroundColor:
                                                          const Color(
                                                              0xFF28A365),
                                                      headerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      headerTextStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLargeFamily,
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLargeIsCustom,
                                                              ),
                                                      pickerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      pickerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      selectedDateTimeBackgroundColor:
                                                          const Color(
                                                              0xFF28A365),
                                                      selectedDateTimeForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      actionButtonForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      iconSize: 24.0,
                                                    );
                                                  },
                                                );
                                                if (picked != null) {
                                                  _model.dataPartoInicio =
                                                      DateTime(
                                                          picked.year,
                                                          picked.month,
                                                          picked.day);
                                                  FFAppState().filtroDataParto =
                                                      _model.dataPartoInicio;
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
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
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        _model.dataPartoInicio !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "d/M/y",
                                                                _model
                                                                    .dataPartoInicio,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode)
                                                            : 'Data inicial',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: _model
                                                                              .dataPartoInicio !=
                                                                          null
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Icon(Icons.calendar_today,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 20.0),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Text('até',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        )),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final picked =
                                                    await showDatePicker(
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendarOnly,
                                                  context: context,
                                                  initialDate:
                                                      _model.dataPartoFim ??
                                                          getCurrentTimestamp,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2050),
                                                  builder: (context, child) {
                                                    return wrapInMaterialDatePickerTheme(
                                                      context,
                                                      child!,
                                                      headerBackgroundColor:
                                                          const Color(
                                                              0xFF28A365),
                                                      headerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      headerTextStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLargeFamily,
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLargeIsCustom,
                                                              ),
                                                      pickerBackgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryBackground,
                                                      pickerForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      selectedDateTimeBackgroundColor:
                                                          const Color(
                                                              0xFF28A365),
                                                      selectedDateTimeForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .info,
                                                      actionButtonForegroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      iconSize: 24.0,
                                                    );
                                                  },
                                                );
                                                if (picked != null) {
                                                  _model.dataPartoFim =
                                                      DateTime(
                                                          picked.year,
                                                          picked.month,
                                                          picked.day);
                                                  FFAppState()
                                                          .filtroDataPartoFim =
                                                      _model.dataPartoFim;
                                                  safeSetState(() {});
                                                }
                                              },
                                              child: Container(
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
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        _model.dataPartoFim !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "d/M/y",
                                                                _model
                                                                    .dataPartoFim,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode)
                                                            : 'Data final',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: _model
                                                                              .dataPartoFim !=
                                                                          null
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      Icon(Icons.calendar_today,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 20.0),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Categoria',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF2F2F2F),
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          safeSetState(() {
                                            _model.showCategoriaDropdown =
                                                !(_model.showCategoriaDropdown ??
                                                    false);
                                            _model.showDiagnosticoDropdown =
                                                false;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .customColor3,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12.0, 0.0, 12.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _model.categoriasSelecionadas
                                                            .isNotEmpty
                                                        ? _model
                                                            .categoriasSelecionadas
                                                            .join(', ')
                                                        : 'Selecionar categorias...',
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                              color: _model
                                                                      .categoriasSelecionadas
                                                                      .isNotEmpty
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumIsCustom,
                                                            ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(
                                                  (_model.showCategoriaDropdown ??
                                                          false)
                                                      ? Icons
                                                          .keyboard_arrow_up_rounded
                                                      : Icons
                                                          .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_model.showCategoriaDropdown ?? false)
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxHeight: 250.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 8.0,
                                                color: Color(0x1A000000),
                                                offset: Offset(0.0, 4.0),
                                                spreadRadius: 0.0,
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: FFAppState()
                                                    .categoriasRebanho
                                                    .map((categoria) => InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            safeSetState(() {
                                                              if (_model
                                                                  .categoriasSelecionadas
                                                                  .contains(
                                                                      categoria)) {
                                                                _model
                                                                    .categoriasSelecionadas
                                                                    .remove(
                                                                        categoria);
                                                              } else {
                                                                _model
                                                                    .categoriasSelecionadas
                                                                    .add(
                                                                        categoria);
                                                              }
                                                              FFAppState()
                                                                  .filtroCategoriaReproducao = List<
                                                                      String>.from(
                                                                  _model
                                                                      .categoriasSelecionadas);
                                                            });
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    12.0,
                                                                    12.0,
                                                                    12.0,
                                                                    12.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: _model
                                                                      .categoriasSelecionadas
                                                                      .contains(
                                                                          categoria)
                                                                  ? const Color(
                                                                      0x1A28A365)
                                                                  : Colors
                                                                      .transparent,
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Container(
                                                                  width: 20.0,
                                                                  height: 20.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: _model
                                                                            .categoriasSelecionadas
                                                                            .contains(
                                                                                categoria)
                                                                        ? const Color(
                                                                            0xFF28A365)
                                                                        : Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: _model
                                                                              .categoriasSelecionadas
                                                                              .contains(
                                                                                  categoria)
                                                                          ? const Color(
                                                                              0xFF28A365)
                                                                          : FlutterFlowTheme.of(context)
                                                                              .secondaryText,
                                                                      width:
                                                                          1.5,
                                                                    ),
                                                                  ),
                                                                  child: _model
                                                                          .categoriasSelecionadas
                                                                          .contains(
                                                                              categoria)
                                                                      ? const Icon(
                                                                          Icons
                                                                              .check,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              14.0)
                                                                      : null,
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Text(
                                                                  categoria,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Diagnóstico',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF2F2F2F),
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          safeSetState(() {
                                            _model.showDiagnosticoDropdown =
                                                !(_model.showDiagnosticoDropdown ??
                                                    false);
                                            _model.showCategoriaDropdown =
                                                false;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .customColor3,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12.0, 0.0, 12.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _model.diagnosticosSelecionados
                                                            .isNotEmpty
                                                        ? _model
                                                            .diagnosticosSelecionados
                                                            .join(', ')
                                                        : 'Selecionar diagnósticos...',
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                              color: _model
                                                                      .diagnosticosSelecionados
                                                                      .isNotEmpty
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumIsCustom,
                                                            ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(
                                                  (_model.showDiagnosticoDropdown ??
                                                          false)
                                                      ? Icons
                                                          .keyboard_arrow_up_rounded
                                                      : Icons
                                                          .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_model.showDiagnosticoDropdown ??
                                          false)
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxHeight: 250.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 8.0,
                                                color: Color(0x1A000000),
                                                offset: Offset(0.0, 4.0),
                                                spreadRadius: 0.0,
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: _diagnosticoOptions
                                                    .map(
                                                        (diagnostico) =>
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                safeSetState(
                                                                    () {
                                                                  if (_model
                                                                      .diagnosticosSelecionados
                                                                      .contains(
                                                                          diagnostico)) {
                                                                    _model
                                                                        .diagnosticosSelecionados
                                                                        .remove(
                                                                            diagnostico);
                                                                  } else {
                                                                    _model
                                                                        .diagnosticosSelecionados
                                                                        .add(
                                                                            diagnostico);
                                                                  }
                                                                  FFAppState()
                                                                      .filtroDiagnosticoReproducao = List<
                                                                          String>.from(
                                                                      _model
                                                                          .diagnosticosSelecionados);
                                                                });
                                                              },
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        12.0,
                                                                        12.0,
                                                                        12.0,
                                                                        12.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: _model
                                                                          .diagnosticosSelecionados
                                                                          .contains(
                                                                              diagnostico)
                                                                      ? const Color(
                                                                          0x1A28A365)
                                                                      : Colors
                                                                          .transparent,
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          20.0,
                                                                      height:
                                                                          20.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: _model.diagnosticosSelecionados.contains(diagnostico)
                                                                            ? const Color(0xFF28A365)
                                                                            : Colors.transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4.0),
                                                                        border:
                                                                            Border.all(
                                                                          color: _model.diagnosticosSelecionados.contains(diagnostico)
                                                                              ? const Color(0xFF28A365)
                                                                              : FlutterFlowTheme.of(context).secondaryText,
                                                                          width:
                                                                              1.5,
                                                                        ),
                                                                      ),
                                                                      child: _model.diagnosticosSelecionados.contains(
                                                                              diagnostico)
                                                                          ? const Icon(
                                                                              Icons.check,
                                                                              color: Colors.white,
                                                                              size: 14.0)
                                                                          : null,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10.0),
                                                                    Text(
                                                                      diagnostico,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ].divide(const SizedBox(height: 8.0)),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                                color: const Color(0xFF2F2F2F),
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                                    matriz.length,
                                                    (matrizIndex) {
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
                                                          const BorderRadius
                                                              .only(
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
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FFAppState()
                                                                      .filtroMatrizReproducao ==
                                                                  matrizItem
                                                              ? FlutterFlowTheme
                                                                      .of(context)
                                                                  .customColor7
                                                              : Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
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
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .customColor5,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8.0,
                                                                  4.0,
                                                                  8.0,
                                                                  4.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                matrizItem,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FFAppState().filtroCategoriasRebanho ==
                                                                              matrizItem
                                                                          ? const Color(
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
                                                            ].divide(
                                                                const SizedBox(
                                                                    width:
                                                                        8.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).divide(
                                                    const SizedBox(width: 8.0)),
                                              ),
                                            );
                                          },
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                                color: const Color(0xFF2F2F2F),
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                                    .map(
                                                        (e) => e.nomeReprodutor)
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
                                                      reprodutor[
                                                          reprodutorIndex];
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
                                                          const BorderRadius
                                                              .only(
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
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FFAppState()
                                                                      .filtroReprodutorReproducao ==
                                                                  reprodutorItem
                                                              ? FlutterFlowTheme
                                                                      .of(context)
                                                                  .customColor7
                                                              : Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
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
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .customColor5,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8.0,
                                                                  4.0,
                                                                  8.0,
                                                                  4.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                reprodutorItem,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: FFAppState().filtroReprodutorReproducao ==
                                                                              reprodutorItem
                                                                          ? const Color(
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
                                                            ].divide(
                                                                const SizedBox(
                                                                    width:
                                                                        8.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).divide(
                                                    const SizedBox(width: 8.0)),
                                              ),
                                            );
                                          },
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                                color: const Color(0xFF2F2F2F),
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
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
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.only(
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
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFFEDEDED),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            8.0, 4.0, 8.0, 4.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Hello World',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          size: 16.0,
                                                        ),
                                                      ].divide(const SizedBox(
                                                          width: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(
                                                const SizedBox(width: 8.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
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
                                              color: const Color(0xFF2F2F2F),
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
                                                  .map(
                                                      (e) => e.loteNome?.trim())
                                                  .withoutNulls
                                                  .where((loteNome) =>
                                                      loteNome.isNotEmpty &&
                                                      loteNome.toLowerCase() !=
                                                          'null')
                                                  .toList()
                                                  .unique((e) => e)
                                                  .toList();

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                  lote.length, (loteIndex) {
                                                final loteItem =
                                                    lote[loteIndex];
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
                                                        const BorderRadius.only(
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
                                                                    .filtroLoteReproducao ==
                                                                loteItem
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .customColor7
                                                            : Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
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
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(8.0,
                                                                4.0, 8.0, 4.0),
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
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FFAppState().filtroLoteReproducao ==
                                                                            loteItem
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .secondary
                                                                        : FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            if (loteItem ==
                                                                FFAppState()
                                                                    .filtroLoteReproducao)
                                                              Icon(
                                                                Icons.close,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                size: 16.0,
                                                              ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 8.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).divide(
                                                  const SizedBox(width: 8.0)),
                                            ),
                                          );
                                        },
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Inseminador',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF2F2F2F),
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
                                                    inseminador[
                                                        inseminadorIndex];
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
                                                        const BorderRadius.only(
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
                                                                    .filtroInseminador ==
                                                                inseminadorItem
                                                            ? FlutterFlowTheme
                                                                    .of(context)
                                                                .customColor7
                                                            : Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
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
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(8.0,
                                                                4.0, 8.0, 4.0),
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
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FFAppState().filtroInseminador ==
                                                                            inseminadorItem
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .secondary
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
                                                                    .filtroInseminador ==
                                                                inseminadorItem)
                                                              Icon(
                                                                Icons.close,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                size: 16.0,
                                                              ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 8.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).divide(
                                                  const SizedBox(width: 8.0)),
                                            ),
                                          );
                                        },
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1.0,
                      color: Color(0xFFBEBEBE),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 16.0, 24.0, 32.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        text: 'Ver resultados',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 47.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: const Color(0xFF28A365),
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleSmallFamily,
                                color: Colors.white,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(
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
          ),
        );
      },
    );
  }
}
