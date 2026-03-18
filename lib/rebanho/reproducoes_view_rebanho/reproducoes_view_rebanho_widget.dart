import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_reproducao_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/reproducao/view_reproducao_rebanho/view_reproducao_rebanho_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reproducoes_view_rebanho_model.dart';
export 'reproducoes_view_rebanho_model.dart';

class ReproducoesViewRebanhoWidget extends StatefulWidget {
  const ReproducoesViewRebanhoWidget({
    super.key,
    this.numAnimal,
    required this.createdAt,
    this.idRebanho,
  });

  final String? numAnimal;
  final String? createdAt;
  final String? idRebanho;

  @override
  State<ReproducoesViewRebanhoWidget> createState() =>
      _ReproducoesViewRebanhoWidgetState();
}

class _ReproducoesViewRebanhoWidgetState
    extends State<ReproducoesViewRebanhoWidget> {
  late ReproducoesViewRebanhoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReproducoesViewRebanhoModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BuscarReproducoesRebanhoRow>>(
      future: SQLiteManager.instance.buscarReproducoesRebanho(
        idRebanho: widget.idRebanho,
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
        final containerBuscarReproducoesRebanhoRowList = snapshot.data!;

        return Container(
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Builder(
                  builder: (context) {
                    final reproducao = containerBuscarReproducoesRebanhoRowList
                        .sortedList(keyOf: (e) => e.createdAt!, desc: true)
                        .toList();
                    if (reproducao.isEmpty) {
                      return Center(
                        child: SizedBox(
                          height: 200.0,
                          child: const EmptyReproducaoWidget(),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: reproducao.length,
                      itemBuilder: (context, reproducaoIndex) {
                        final reproducaoItem = reproducao[reproducaoIndex];
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Divider(
                                thickness: 1.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Builder(
                                builder: (context) => Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 8.0, 24.0, 8.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      FFAppState().reprodutorSelecionado =
                                          AnimalSelecionadoStruct(
                                        numAnimal: reproducaoItem.numReprodutor,
                                        nomeAnimal:
                                            reproducaoItem.nomeReprodutor,
                                        dataNascAnimal:
                                            reproducaoItem.nascimentoReprodutor,
                                        racaAnimal:
                                            reproducaoItem.racaReprodutor,
                                      );
                                      FFAppState().matrizSelecionada =
                                          AnimalSelecionadoStruct(
                                        numAnimal: reproducaoItem.numMatriz,
                                        nomeAnimal: reproducaoItem.nomeMatriz,
                                        dataNascAnimal:
                                            reproducaoItem.nascimentoMatriz,
                                        racaAnimal: reproducaoItem.racaMatriz,
                                      );
                                      await showDialog(
                                        barrierColor: Colors.transparent,
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            alignment:
                                                const AlignmentDirectional(
                                                        0.0, 0.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                            child: ViewReproducaoRebanhoWidget(
                                              idReproducao:
                                                  reproducaoItem.idReproducao!,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/Reproducao5675.png',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                  ),
                                                  if (responsiveVisibility(
                                                    context: context,
                                                    phone: false,
                                                  ))
                                                    ClipRRect(
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
                                                        height: 23.0,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFF1F1F1),
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
                                                        ),
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  8.0,
                                                                  0.0),
                                                          child: Text(
                                                            '${valueOrDefault<String>(
                                                              reproducaoItem
                                                                  .tipoReproducao,
                                                              '--',
                                                            )} (${valueOrDefault<String>(
                                                              reproducaoItem
                                                                          .tipoReproducao ==
                                                                      'Inseminação'
                                                                  ? valueOrDefault<
                                                                      String>(
                                                                      dateTimeFormat(
                                                                        "dd/MM/yy",
                                                                        functions
                                                                            .converterParaData(reproducaoItem.dataInseminacao),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      ),
                                                                      '--',
                                                                    )
                                                                  : valueOrDefault<
                                                                      String>(
                                                                      dateTimeFormat(
                                                                        "dd/MM/yy",
                                                                        functions
                                                                            .converterParaData(reproducaoItem.dataInicial),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      ),
                                                                      '--',
                                                                    ),
                                                              '--',
                                                            )})',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: const Color(
                                                                      0xFF5F5F5F),
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ClipRRect(
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
                                                      height: 23.0,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xFFF1F1F1),
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
                                                      ),
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(8.0,
                                                                0.0, 8.0, 0.0),
                                                        child: Text(
                                                          '${reproducaoItem.tipoReproducao} (${reproducaoItem.tipoReproducao == 'Inseminação' ? dateTimeFormat(
                                                              "dd/MM/yy",
                                                              functions.converterParaData(
                                                                  reproducaoItem
                                                                      .dataInseminacao),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            ) : dateTimeFormat(
                                                              "dd/MM/yy",
                                                              functions.converterParaData(
                                                                  reproducaoItem
                                                                      .dataInicial),
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            )})',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: const Color(
                                                                    0xFF5F5F5F),
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (['Tradicional', 'Precoce', 'Superprecoce'].contains(reproducaoItem.ressinc))
                                                    Container(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          'R',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
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
                                                      ),
                                                    ),
                                                ].divide(
                                                    const SizedBox(width: 8.0)),
                                              ),
                                              if (reproducaoItem.categoria ==
                                                  'rebanho')
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: Visibility(
                                                    visible: (reproducaoItem
                                                                    .idLote ==
                                                                null ||
                                                            reproducaoItem
                                                                    .idLote ==
                                                                '') ||
                                                        (reproducaoItem
                                                                .idLote !=
                                                            ' '),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.asset(
                                                            'assets/images/Sexofemea.png',
                                                            width: 24.0,
                                                            height: 24.0,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  7.0,
                                                                  0.0),
                                                          child: Text(
                                                            'Matriz:',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: const Color(
                                                                      0xFF474747),
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              '${valueOrDefault<String>(
                                                                reproducaoItem
                                                                    .numMatriz,
                                                                '--',
                                                              )} • ${valueOrDefault<String>(
                                                                reproducaoItem
                                                                    .nomeMatriz,
                                                                '--',
                                                              )} • ${dateTimeFormat(
                                                                "dd/MM/yyyy",
                                                                functions.converterParaData(
                                                                    reproducaoItem
                                                                        .nascimentoMatriz),
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )}',
                                                              '--',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .plusJakartaSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: const Color(
                                                                      0xFF474747),
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          width: 3.0)),
                                                    ),
                                                  ),
                                                ),
                                              if (reproducaoItem.categoria ==
                                                  'lote')
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/images/Lotes887.png',
                                                        width: 24.0,
                                                        height: 24.0,
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Lote:',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: const Color(
                                                                    0xFF5F5F5F),
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        valueOrDefault<String>(
                                                          reproducaoItem
                                                              .loteNome,
                                                          'S/L',
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyLarge
                                                            .override(
                                                              font: GoogleFonts
                                                                  .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                              color: const Color(
                                                                  0xFF5F5F5F),
                                                              fontSize: 14.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                    ),
                                                  ].divide(const SizedBox(
                                                      width: 3.0)),
                                                ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  ClipRRect(
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
                                                      height: 23.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            colorFromCssString(
                                                          reproducaoItem
                                                                      .statusReproducao ==
                                                                  'Prenhez'
                                                              ? '#EFF5D4'
                                                              : '#f5d7d4',
                                                          defaultColor:
                                                              const Color(
                                                                  0xFFF5D7D4),
                                                        ),
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
                                                      ),
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(8.0,
                                                                0.0, 8.0, 0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            '${valueOrDefault<String>(
                                                              reproducaoItem
                                                                  .statusReproducao,
                                                              '--',
                                                            )} (${valueOrDefault<String>(
                                                              dateTimeFormat(
                                                                "dd/MM/yy",
                                                                functions.converterParaData(
                                                                    reproducaoItem
                                                                        .dataStatus),
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              'S/D',
                                                            )})',
                                                            '--',
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                color:
                                                                    colorFromCssString(
                                                                  reproducaoItem
                                                                              .statusReproducao ==
                                                                          'Prenhez'
                                                                      ? '#1e7a4c'
                                                                      : '#cc3729',
                                                                  defaultColor:
                                                                      const Color(
                                                                          0xFFCC3729),
                                                                ),
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(
                                                    const SizedBox(width: 8.0)),
                                              ),
                                              if (reproducaoItem.parida ==
                                                  'SIM')
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ClipRRect(
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
                                                        height: 23.0,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFEFF5D4),
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
                                                        ),
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  8.0,
                                                                  0.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              'Parida em (${valueOrDefault<String>(
                                                                dateTimeFormat(
                                                                  "dd/MM/yy",
                                                                  functions.converterParaData(
                                                                      valueOrDefault<
                                                                          String>(
                                                                    reproducaoItem
                                                                        .dataParto,
                                                                    'dd/mm/yyyy',
                                                                  )),
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                'S/D',
                                                              )})',
                                                              '--',
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: const Color(
                                                                      0xFF1E7A4C),
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(const SizedBox(
                                                      width: 8.0)),
                                                ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/Sexomacho.png',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Reprodutor:',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          font: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                          color: const Color(
                                                              0xFF474747),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        reproducaoItem
                                                            .nomeReprodutor,
                                                        '--',
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: const Color(
                                                                    0xFF474747),
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                ].divide(
                                                    const SizedBox(width: 3.0)),
                                              ),
                                              if (reproducaoItem
                                                      .tipoReproducao ==
                                                  'Inseminação')
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Previsão de parto:',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: const Color(
                                                                    0xFF474747),
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          width: 5.0)),
                                                    ),
                                                    Text(
                                                      valueOrDefault<String>(
                                                        dateTimeFormat(
                                                          "dd/MM/yy",
                                                          functions
                                                              .converterParaData(
                                                                  reproducaoItem
                                                                      .previsaoParto),
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        ),
                                                        'S/D',
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: const Color(
                                                                    0xFF474747),
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ].divide(const SizedBox(
                                                      width: 3.0)),
                                                ),
                                            ].divide(
                                                const SizedBox(height: 4.0)),
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
