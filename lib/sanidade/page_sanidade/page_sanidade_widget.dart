import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_sanidade_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/sanidade/edit_sanidade_animal/edit_sanidade_animal_widget.dart';
import '/sanidade/filtro_sanidades/filtro_sanidades_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'page_sanidade_model.dart';
export 'page_sanidade_model.dart';

class PageSanidadeWidget extends StatefulWidget {
  const PageSanidadeWidget({super.key});

  @override
  State<PageSanidadeWidget> createState() => _PageSanidadeWidgetState();
}

class _PageSanidadeWidgetState extends State<PageSanidadeWidget> {
  late PageSanidadeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageSanidadeModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await action_blocks.qTDSanidades(context);
    });

    _model.pesquisarTextController ??= TextEditingController();
    _model.pesquisarFocusNode ??= FocusNode();

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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              child: wrapWithModel(
                model: _model.selecionarPropriedadeModel,
                updateCallback: () => safeSetState(() {}),
                child: const SelecionarPropriedadeWidget(),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 123.0,
                          height: 122.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Sanidade.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  FFAppState().qtdVacinas.toString(),
                                  '0',
                                ),
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              Text(
                                'Vacinas aplicadas',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 123.0,
                          height: 122.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Sanidade.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  FFAppState().qtdAntiparasitarios.toString(),
                                  '0',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              Flexible(
                                child: Text(
                                  'Antiparasitários aplicados',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 123.0,
                          height: 122.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Sanidade.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  FFAppState().qtdTratamento.toString(),
                                  '0',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              Text(
                                'Tratamentos aplicados',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 123.0,
                          height: 122.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Sanidade.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  FFAppState()
                                      .qtdProtocoloReprodutivo
                                      .toString(),
                                  '0',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              Text(
                                'Protocolos reprodutivos',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ].divide(const SizedBox(width: 8.0)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _model.pesquisarTextController,
                  focusNode: _model.pesquisarFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.pesquisarTextController',
                    const Duration(milliseconds: 2000),
                    () => safeSetState(() {}),
                  ),
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelStyle: FlutterFlowTheme.of(context)
                        .labelMedium
                        .override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                        ),
                    hintText: 'Pesquisar',
                    hintStyle: FlutterFlowTheme.of(context)
                        .labelMedium
                        .override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelMediumFamily,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).labelMediumIsCustom,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).tertiary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).tertiary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    prefixIcon: Icon(
                      Icons.search_sharp,
                      color: FlutterFlowTheme.of(context).accent3,
                      size: 24.0,
                    ),
                    suffixIcon: _model.pesquisarTextController!.text.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              _model.pesquisarTextController?.clear();
                              safeSetState(() {});
                            },
                            child: Icon(
                              Icons.clear,
                              color: FlutterFlowTheme.of(context).accent3,
                              size: 22,
                            ),
                          )
                        : null,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        lineHeight: 1.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  validator: _model.pesquisarTextControllerValidator
                      .asValidator(context),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: const FiltroSanidadesWidget(),
                              );
                            },
                          ).then((value) => safeSetState(() {}));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: const Color(0xFFBEBEBE),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Filtrar',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/Filter78978.png',
                                    width: 16.0,
                                    height: 16.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ].divide(const SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      if (FFAppState().filtroDataSanidadeTxt != '')
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: const Color(0xFFBEBEBE),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  FFAppState().filtroDataSanidadeTxt,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ].divide(const SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                      Builder(
                        builder: (context) {
                          final sanidade =
                              FFAppState().filtrosSanidades.toList();

                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            children:
                                List.generate(sanidade.length, (sanidadeIndex) {
                              final sanidadeItem = sanidade[sanidadeIndex];
                              return Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(24.0),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: const Color(0xFFBEBEBE),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        sanidadeItem,
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
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                ),
                              );
                            }).divide(const SizedBox(width: 8.0)),
                          );
                        },
                      ),
                    ].divide(const SizedBox(width: 8.0)),
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFEDEDED),
            ),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 14.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Builder(
                            builder: (context) {
                              if (_model.pesquisarTextController.text != '') {
                                return FutureBuilder<
                                    List<BuscaSanidadesPesqRow>>(
                                  future:
                                      SQLiteManager.instance.buscaSanidadesPesq(
                                    idPropriedade: FFAppState()
                                        .propriedadeSelecionada
                                        .idPropriedade,
                                    pesquisa:
                                        _model.pesquisarTextController.text,
                                    vacinas: FFAppState().filtroVacinacao,
                                    antiparasitario:
                                        FFAppState().filtroAntiparasitario,
                                    tratamentos: FFAppState().filtroTratamento,
                                    protocolo:
                                        FFAppState().filtroProtocoloReprodutivo,
                                    idRebanho:
                                        FFAppState().filtroSanidadeAnimal,
                                    idLote: FFAppState().filtroLoteSanidade,
                                    dataSanidade: dateTimeFormat(
                                      "yyyy-MM-dd",
                                      FFAppState().filtroDataSanidade,
                                      locale: FFLocalizations.of(context)
                                          .languageCode,
                                    ),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final containerBuscaSanidadesPesqRowList =
                                        snapshot.data!;

                                    return Container(
                                      decoration: const BoxDecoration(),
                                      child: Builder(
                                        builder: (context) {
                                          final sanidades =
                                              containerBuscaSanidadesPesqRowList
                                                  .toList();
                                          if (sanidades.isEmpty) {
                                            return Center(
                                              child: SizedBox(
                                                height: 200.0,
                                                child:
                                                    const EmptySanidadeWidget(),
                                              ),
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: sanidades.length,
                                            itemBuilder:
                                                (context, sanidadesIndex) {
                                              final sanidadesItem =
                                                  sanidades[sanidadesIndex];
                                              return FutureBuilder<
                                                  List<BuscarLoteRow>>(
                                                future: SQLiteManager.instance
                                                    .buscarLote(
                                                  idLote: sanidadesItem.idLote,
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final containerBuscarLoteRowList =
                                                      snapshot.data!;

                                                  return Container(
                                                    decoration:
                                                        const BoxDecoration(),
                                                    child: FutureBuilder<
                                                        List<BuscarRebanhoRow>>(
                                                      future: SQLiteManager
                                                          .instance
                                                          .buscarRebanho(
                                                        idRebanho: sanidadesItem
                                                            .idRebanho,
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        final containerBuscarRebanhoRowList =
                                                            snapshot.data!;

                                                        return Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Builder(
                                                                builder:
                                                                    (context) =>
                                                                        Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          24.0,
                                                                          24.0,
                                                                          24.0,
                                                                          24.0),
                                                                  child:
                                                                      InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      FFAppState()
                                                                              .sanidadeSelecionada =
                                                                          SanidadeStruct(
                                                                        idPropriedade:
                                                                            sanidadesItem.idPropriedade,
                                                                        idRebanho:
                                                                            sanidadesItem.idRebanho,
                                                                        dataSanidade:
                                                                            sanidadesItem.dataSanidade,
                                                                        idLote:
                                                                            sanidadesItem.idLote,
                                                                        porcentagemLote:
                                                                            sanidadesItem.porcentagemLote,
                                                                        idSanidade:
                                                                            sanidadesItem.idSanidade,
                                                                        updatedAt:
                                                                            sanidadesItem.updatedAt,
                                                                        deletado:
                                                                            sanidadesItem.deletado,
                                                                        vacinacao:
                                                                            sanidadesItem.vacinacao,
                                                                        vacOutros:
                                                                            sanidadesItem.vacinacaoOutros,
                                                                        vacObs:
                                                                            sanidadesItem.vacinacaoObs,
                                                                        antiparasitario:
                                                                            sanidadesItem.antiparasitario,
                                                                        antiOutros:
                                                                            sanidadesItem.antiparasitarioOutros,
                                                                        antiObs:
                                                                            sanidadesItem.antiparasitarioObs,
                                                                        tratamento:
                                                                            sanidadesItem.tratamento,
                                                                        tratOutros:
                                                                            sanidadesItem.tratamentoOutros,
                                                                        tratObs:
                                                                            sanidadesItem.tratamentoObs,
                                                                        protocoloReprodutivo:
                                                                            sanidadesItem.protocoloReprodutivo,
                                                                        reproOutros:
                                                                            sanidadesItem.protocoloReprodutivoOutros,
                                                                        reproObs:
                                                                            sanidadesItem.protocoloReprodutivoObs,
                                                                        createdAt:
                                                                            sanidadesItem.createdAt,
                                                                        protocoloD0:
                                                                            sanidadesItem.protocoloD0,
                                                                        protocoloRetirada:
                                                                            sanidadesItem.protocoloRetirada,
                                                                        protocoloIatf:
                                                                            sanidadesItem.protocoloIatf,
                                                                      );
                                                                      safeSetState(
                                                                          () {});
                                                                      await showDialog(
                                                                        barrierColor:
                                                                            Colors.transparent,
                                                                        barrierDismissible:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (dialogContext) {
                                                                          return Dialog(
                                                                            elevation:
                                                                                0,
                                                                            insetPadding:
                                                                                EdgeInsets.zero,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            alignment:
                                                                                const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                            child:
                                                                                const EditSanidadeAnimalWidget(),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
                                                                        if (sanidadesItem.idRebanho !=
                                                                                null &&
                                                                            sanidadesItem.idRebanho !=
                                                                                '')
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children:
                                                                                [
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Image.asset(
                                                                                  'assets/images/Group_1.png',
                                                                                  width: 24.0,
                                                                                  height: 24.0,
                                                                                  fit: BoxFit.scaleDown,
                                                                                ),
                                                                              ),
                                                                              if (containerBuscarRebanhoRowList.firstOrNull?.sexo == 'Macho')
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  child: Image.asset(
                                                                                    'assets/images/Type=Macho.png',
                                                                                    width: 24.0,
                                                                                    height: 24.0,
                                                                                    fit: BoxFit.scaleDown,
                                                                                  ),
                                                                                ),
                                                                              if (containerBuscarRebanhoRowList.firstOrNull?.sexo == 'Fêmea')
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  child: Image.asset(
                                                                                    'assets/images/female.png',
                                                                                    width: 24.0,
                                                                                    height: 24.0,
                                                                                    fit: BoxFit.scaleDown,
                                                                                  ),
                                                                                ),
                                                                            ].divide(const SizedBox(width: 3.0)),
                                                                          ),
                                                                        if (sanidadesItem.idRebanho !=
                                                                                null &&
                                                                            sanidadesItem.idRebanho !=
                                                                                '')
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children:
                                                                                [
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  containerBuscarRebanhoRowList.firstOrNull?.numeroAnimal,
                                                                                  'Sem número',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF474747),
                                                                                      fontSize: 16.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                '•',
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF5F5F5F),
                                                                                      fontSize: 14.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  containerBuscarRebanhoRowList.firstOrNull?.nome,
                                                                                  'Sem nome',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF474747),
                                                                                      fontSize: 16.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                '•',
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF5F5F5F),
                                                                                      fontSize: 14.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  dateTimeFormat(
                                                                                    "d/M/y",
                                                                                    functions.converterParaData(containerBuscarRebanhoRowList.firstOrNull?.dataNascimento),
                                                                                    locale: FFLocalizations.of(context).languageCode,
                                                                                  ),
                                                                                  'Sem data',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF474747),
                                                                                      fontSize: 16.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ].divide(const SizedBox(width: 3.0)),
                                                                          ),
                                                                        if (sanidadesItem.idRebanho !=
                                                                                null &&
                                                                            sanidadesItem.idRebanho !=
                                                                                '')
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children:
                                                                                [
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        containerBuscarRebanhoRowList.firstOrNull?.categoria,
                                                                                        'Sem categoria',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF5F5F5F),
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      '•',
                                                                                      maxLines: 1,
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF474747),
                                                                                            fontSize: 16.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        valueOrDefault<String>(
                                                                                                  containerBuscarRebanhoRowList.firstOrNull?.raca,
                                                                                                  'Sem raça',
                                                                                                ) ==
                                                                                                'null'
                                                                                            ? 'Sem raça'
                                                                                            : valueOrDefault<String>(
                                                                                                containerBuscarRebanhoRowList.firstOrNull?.raca,
                                                                                                'Sem raça',
                                                                                              ),
                                                                                        'Sem raça',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF5F5F5F),
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                  ].divide(const SizedBox(width: 4.0)),
                                                                                ),
                                                                              ),
                                                                              const Icon(
                                                                                Icons.chevron_right,
                                                                                color: Color(0xFF5F5F5F),
                                                                                size: 24.0,
                                                                              ),
                                                                            ].divide(const SizedBox(width: 8.0)),
                                                                          ),
                                                                        if (sanidadesItem.idRebanho !=
                                                                                null &&
                                                                            sanidadesItem.idRebanho !=
                                                                                '')
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children:
                                                                                [
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Image.asset(
                                                                                  'assets/images/Lotes.png',
                                                                                  width: 24.0,
                                                                                  height: 24.0,
                                                                                  fit: BoxFit.scaleDown,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  containerBuscarRebanhoRowList.firstOrNull?.loteNome,
                                                                                  'Sem lote',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF5F5F5F),
                                                                                      fontSize: 14.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ].divide(const SizedBox(width: 3.0)),
                                                                          ),
                                                                        if (sanidadesItem.idLote !=
                                                                                null &&
                                                                            sanidadesItem.idLote !=
                                                                                '')
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children:
                                                                                [
                                                                              Flexible(
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                      child: Image.asset(
                                                                                        'assets/images/Lotes.png',
                                                                                        width: 24.0,
                                                                                        height: 24.0,
                                                                                        fit: BoxFit.scaleDown,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        containerBuscarLoteRowList.firstOrNull?.nome,
                                                                                        'Sem Lote',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF5F5F5F),
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              const Icon(
                                                                                Icons.chevron_right,
                                                                                color: Color(0xFF5F5F5F),
                                                                                size: 24.0,
                                                                              ),
                                                                            ].divide(const SizedBox(width: 3.0)),
                                                                          ),
                                                                        if ((sanidadesItem.vacinacao !=
                                                                                'null') &&
                                                                            (sanidadesItem.vacinacao != null &&
                                                                                sanidadesItem.vacinacao != ''))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Vacinação:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: const Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                Builder(
                                                                                  builder: (context) {
                                                                                    final vacinas = functions.converterJSONparaLista(sanidadesItem.vacinacao!).toList();

                                                                                    return SingleChildScrollView(
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: List.generate(vacinas.length, (vacinasIndex) {
                                                                                          final vacinasItem = vacinas[vacinasIndex];
                                                                                          return Align(
                                                                                            alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: BoxDecoration(
                                                                                                color: const Color(0xFFB1CC29),
                                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                                              ),
                                                                                              child: Align(
                                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                                  child: Text(
                                                                                                    vacinasItem,
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                          fontSize: 10.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                        ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }).divide(const SizedBox(width: 8.0)),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ].divide(const SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.antiparasitario !=
                                                                                'null') &&
                                                                            (sanidadesItem.antiparasitario != null &&
                                                                                sanidadesItem.antiparasitario != ''))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Antiparasitário:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: const Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                Builder(
                                                                                  builder: (context) {
                                                                                    final antiparasitario = functions.converterJSONparaLista(sanidadesItem.antiparasitario!).toList();

                                                                                    return SingleChildScrollView(
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: List.generate(antiparasitario.length, (antiparasitarioIndex) {
                                                                                          final antiparasitarioItem = antiparasitario[antiparasitarioIndex];
                                                                                          return Align(
                                                                                            alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: BoxDecoration(
                                                                                                color: const Color(0xFFB1CC29),
                                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                                              ),
                                                                                              child: Align(
                                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                                  child: Text(
                                                                                                    antiparasitarioItem,
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                          fontSize: 10.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                        ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }).divide(const SizedBox(width: 8.0)),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ].divide(const SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.tratamento !=
                                                                                'null') &&
                                                                            (sanidadesItem.tratamento != null &&
                                                                                sanidadesItem.tratamento != ''))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Tratamento:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: const Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                Builder(
                                                                                  builder: (context) {
                                                                                    final tratamenteSanidade = functions.converterJSONparaLista(sanidadesItem.tratamento!).toList();

                                                                                    return SingleChildScrollView(
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: List.generate(tratamenteSanidade.length, (tratamenteSanidadeIndex) {
                                                                                          final tratamenteSanidadeItem = tratamenteSanidade[tratamenteSanidadeIndex];
                                                                                          return Align(
                                                                                            alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: BoxDecoration(
                                                                                                color: const Color(0xFFB1CC29),
                                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                                              ),
                                                                                              child: Align(
                                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                                  child: Text(
                                                                                                    tratamenteSanidadeItem,
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                          fontSize: 10.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                        ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }).divide(const SizedBox(width: 8.0)),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ].divide(const SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.protocoloReprodutivo !=
                                                                                'null') &&
                                                                            (sanidadesItem.protocoloReprodutivo != null &&
                                                                                sanidadesItem.protocoloReprodutivo != ''))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Protocolo:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: const Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                        child: Container(
                                                                                          height: 23.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: const Color(0xFFB1CC29),
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  sanidadesItem.protocoloReprodutivo,
                                                                                                  'N/A',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                      fontSize: 10.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 8.0)),
                                                                                  ),
                                                                                ),
                                                                              ].divide(const SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.protocoloD0 !=
                                                                                'null') &&
                                                                            (sanidadesItem.protocoloD0 != null &&
                                                                                sanidadesItem.protocoloD0 != ''))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Protocolo D0:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: const Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                        child: Container(
                                                                                          height: 23.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: const Color(0xFFB1CC29),
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  sanidadesItem.protocoloD0,
                                                                                                  'N/A',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                      fontSize: 10.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 8.0)),
                                                                                  ),
                                                                                ),
                                                                              ].divide(const SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.protocoloRetirada !=
                                                                                'null') &&
                                                                            (sanidadesItem.protocoloRetirada != null &&
                                                                                sanidadesItem.protocoloRetirada != ''))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Protocolo retirada:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: const Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                        child: Container(
                                                                                          height: 23.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: const Color(0xFFB1CC29),
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  sanidadesItem.protocoloRetirada,
                                                                                                  'N/A',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                      fontSize: 10.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 8.0)),
                                                                                  ),
                                                                                ),
                                                                              ].divide(const SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if (((sanidadesItem.protocoloIatf != 'null') &&
                                                                                (sanidadesItem.protocoloIatf == null || sanidadesItem.protocoloIatf == '')) &&
                                                                            responsiveVisibility(
                                                                              context: context,
                                                                              phone: false,
                                                                              tablet: false,
                                                                              tabletLandscape: false,
                                                                              desktop: false,
                                                                            ))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Protocolo IATF:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: const Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                        child: Container(
                                                                                          height: 23.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: const Color(0xFFB1CC29),
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  sanidadesItem.protocoloIatf,
                                                                                                  'N/A',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                      fontSize: 10.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 8.0)),
                                                                                  ),
                                                                                ),
                                                                              ].divide(const SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                      ].divide(const SizedBox(
                                                                              height: 8.0)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Divider(
                                                                thickness: 1.0,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return FutureBuilder<
                                    List<BuscaSanidadesPaginadaRow>>(
                                  future: SQLiteManager.instance
                                      .buscaSanidadesPaginada(
                                    idPropriedade: FFAppState()
                                        .propriedadeSelecionada
                                        .idPropriedade,
                                    vacinas: FFAppState().filtroVacinacao,
                                    antiparasitario:
                                        FFAppState().filtroAntiparasitario,
                                    tratamentos: FFAppState().filtroTratamento,
                                    protocolo:
                                        FFAppState().filtroProtocoloReprodutivo,
                                    idRebanho:
                                        FFAppState().filtroSanidadeAnimal,
                                    idLote: FFAppState().filtroLoteSanidade,
                                    dataSanidade: dateTimeFormat(
                                      "yyyy-MM-dd",
                                      FFAppState().filtroDataSanidade,
                                      locale: FFLocalizations.of(context)
                                          .languageCode,
                                    ),
                                    limitRows: _model.limit,
                                    offsetRows: functions.calcDeslocamento(
                                        _model.pageNum, _model.limit!),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final containerBuscaSanidadesPaginadaRowList =
                                        snapshot.data!;

                                    return Container(
                                      decoration: const BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Builder(
                                              builder: (context) {
                                                final sanidades =
                                                    containerBuscaSanidadesPaginadaRowList
                                                        .toList();
                                                if (sanidades.isEmpty) {
                                                  return Center(
                                                    child: SizedBox(
                                                      height: 200.0,
                                                      child:
                                                          const EmptySanidadeWidget(),
                                                    ),
                                                  );
                                                }

                                                return ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: sanidades.length,
                                                  itemBuilder: (context,
                                                      sanidadesIndex) {
                                                    final sanidadesItem =
                                                        sanidades[
                                                            sanidadesIndex];
                                                    return FutureBuilder<
                                                        List<BuscarLoteRow>>(
                                                      future: SQLiteManager
                                                          .instance
                                                          .buscarLote(
                                                        idLote: sanidadesItem
                                                            .idLote,
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        final containerBuscarLoteRowList =
                                                            snapshot.data!;

                                                        return Container(
                                                          decoration:
                                                              const BoxDecoration(),
                                                          child: FutureBuilder<
                                                              List<
                                                                  BuscarRebanhoRow>>(
                                                            future: SQLiteManager
                                                                .instance
                                                                .buscarRebanho(
                                                              idRebanho:
                                                                  sanidadesItem
                                                                      .idRebanho,
                                                            ),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<
                                                                              Color>(
                                                                        FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              final containerBuscarRebanhoRowList =
                                                                  snapshot
                                                                      .data!;

                                                              return Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Builder(
                                                                      builder:
                                                                          (context) =>
                                                                              Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            24.0,
                                                                            24.0,
                                                                            24.0,
                                                                            24.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            FFAppState().sanidadeSelecionada =
                                                                                SanidadeStruct(
                                                                              idPropriedade: sanidadesItem.idPropriedade,
                                                                              idRebanho: sanidadesItem.idRebanho,
                                                                              dataSanidade: sanidadesItem.dataSanidade,
                                                                              idLote: sanidadesItem.idLote,
                                                                              porcentagemLote: sanidadesItem.porcentagemLote,
                                                                              idSanidade: sanidadesItem.idSanidade,
                                                                              updatedAt: sanidadesItem.updatedAt,
                                                                              deletado: sanidadesItem.deletado,
                                                                              vacinacao: sanidadesItem.vacinacao,
                                                                              vacOutros: sanidadesItem.vacinacaoOutros,
                                                                              vacObs: sanidadesItem.vacinacaoObs,
                                                                              antiparasitario: sanidadesItem.antiparasitario,
                                                                              antiOutros: sanidadesItem.antiparasitarioOutros,
                                                                              antiObs: sanidadesItem.antiparasitarioObs,
                                                                              tratamento: sanidadesItem.tratamento,
                                                                              tratOutros: sanidadesItem.tratamentoOutros,
                                                                              tratObs: sanidadesItem.tratamentoObs,
                                                                              protocoloReprodutivo: sanidadesItem.protocoloReprodutivo,
                                                                              reproOutros: sanidadesItem.protocoloReprodutivoOutros,
                                                                              reproObs: sanidadesItem.protocoloReprodutivoObs,
                                                                              createdAt: sanidadesItem.createdAt,
                                                                              protocoloD0: sanidadesItem.protocoloD0,
                                                                              protocoloRetirada: sanidadesItem.protocoloRetirada,
                                                                              protocoloIatf: sanidadesItem.protocoloIatf,
                                                                            );
                                                                            safeSetState(() {});
                                                                            await showDialog(
                                                                              barrierColor: Colors.transparent,
                                                                              barrierDismissible: false,
                                                                              context: context,
                                                                              builder: (dialogContext) {
                                                                                return Dialog(
                                                                                  elevation: 0,
                                                                                  insetPadding: EdgeInsets.zero,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                  child: const EditSanidadeAnimalWidget(),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children:
                                                                                [
                                                                              if (sanidadesItem.idRebanho != null && sanidadesItem.idRebanho != '')
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                      child: Image.asset(
                                                                                        'assets/images/Group_1.png',
                                                                                        width: 24.0,
                                                                                        height: 24.0,
                                                                                        fit: BoxFit.scaleDown,
                                                                                      ),
                                                                                    ),
                                                                                    if (containerBuscarRebanhoRowList.firstOrNull?.sexo == 'Macho')
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                        child: Image.asset(
                                                                                          'assets/images/Type=Macho.png',
                                                                                          width: 24.0,
                                                                                          height: 24.0,
                                                                                          fit: BoxFit.scaleDown,
                                                                                        ),
                                                                                      ),
                                                                                    if (containerBuscarRebanhoRowList.firstOrNull?.sexo == 'Fêmea')
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                        child: Image.asset(
                                                                                          'assets/images/female.png',
                                                                                          width: 24.0,
                                                                                          height: 24.0,
                                                                                          fit: BoxFit.scaleDown,
                                                                                        ),
                                                                                      ),
                                                                                  ].divide(const SizedBox(width: 3.0)),
                                                                                ),
                                                                              if (sanidadesItem.idRebanho != null && sanidadesItem.idRebanho != '')
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        containerBuscarRebanhoRowList.firstOrNull?.numeroAnimal,
                                                                                        'Sem número',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF474747),
                                                                                            fontSize: 16.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      '•',
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF5F5F5F),
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        containerBuscarRebanhoRowList.firstOrNull?.nome,
                                                                                        'Sem nome',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF474747),
                                                                                            fontSize: 16.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      '•',
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF5F5F5F),
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        dateTimeFormat(
                                                                                          "d/M/y",
                                                                                          functions.converterParaData(containerBuscarRebanhoRowList.firstOrNull?.dataNascimento),
                                                                                          locale: FFLocalizations.of(context).languageCode,
                                                                                        ),
                                                                                        'Sem data',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF474747),
                                                                                            fontSize: 16.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                  ].divide(const SizedBox(width: 3.0)),
                                                                                ),
                                                                              if (sanidadesItem.idRebanho != null && sanidadesItem.idRebanho != '')
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    SingleChildScrollView(
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          Text(
                                                                                            valueOrDefault<String>(
                                                                                              containerBuscarRebanhoRowList.firstOrNull?.categoria,
                                                                                              'Sem categoria',
                                                                                            ),
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  font: GoogleFonts.plusJakartaSans(
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                  ),
                                                                                                  color: const Color(0xFF5F5F5F),
                                                                                                  fontSize: 14.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                          Text(
                                                                                            '•',
                                                                                            maxLines: 1,
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  font: GoogleFonts.plusJakartaSans(
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                  ),
                                                                                                  color: const Color(0xFF474747),
                                                                                                  fontSize: 16.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                          Text(
                                                                                            valueOrDefault<String>(
                                                                                                      containerBuscarRebanhoRowList.firstOrNull?.raca,
                                                                                                      'Sem raça',
                                                                                                    ) ==
                                                                                                    'null'
                                                                                                ? 'Sem raça'
                                                                                                : valueOrDefault<String>(
                                                                                                    containerBuscarRebanhoRowList.firstOrNull?.raca,
                                                                                                    'Sem raça',
                                                                                                  ),
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  font: GoogleFonts.plusJakartaSans(
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                  ),
                                                                                                  color: const Color(0xFF5F5F5F),
                                                                                                  fontSize: 14.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                        ].divide(const SizedBox(width: 4.0)),
                                                                                      ),
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.chevron_right,
                                                                                      color: Color(0xFF5F5F5F),
                                                                                      size: 24.0,
                                                                                    ),
                                                                                  ].divide(const SizedBox(width: 8.0)),
                                                                                ),
                                                                              if (sanidadesItem.idRebanho != null && sanidadesItem.idRebanho != '')
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                      child: Image.asset(
                                                                                        'assets/images/Lotes.png',
                                                                                        width: 24.0,
                                                                                        height: 24.0,
                                                                                        fit: BoxFit.scaleDown,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        containerBuscarRebanhoRowList.firstOrNull?.loteNome,
                                                                                        'Sem lote',
                                                                                      ),
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.plusJakartaSans(
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: const Color(0xFF5F5F5F),
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                  ].divide(const SizedBox(width: 3.0)),
                                                                                ),
                                                                              if (sanidadesItem.idLote != null && sanidadesItem.idLote != '')
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Flexible(
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Lotes.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            valueOrDefault<String>(
                                                                                              containerBuscarLoteRowList.firstOrNull?.nome,
                                                                                              'Sem Lote',
                                                                                            ),
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  font: GoogleFonts.plusJakartaSans(
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                  ),
                                                                                                  color: const Color(0xFF5F5F5F),
                                                                                                  fontSize: 14.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.chevron_right,
                                                                                      color: Color(0xFF5F5F5F),
                                                                                      size: 24.0,
                                                                                    ),
                                                                                  ].divide(const SizedBox(width: 3.0)),
                                                                                ),
                                                                              if ((sanidadesItem.vacinacao != 'null') && (sanidadesItem.vacinacao != null && sanidadesItem.vacinacao != ''))
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Vacinação:',
                                                                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                              font: GoogleFonts.plusJakartaSans(
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                              color: const Color(0xFF474747),
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                      Builder(
                                                                                        builder: (context) {
                                                                                          final vacinas = functions.converterJSONparaLista(sanidadesItem.vacinacao!).toList();

                                                                                          return SingleChildScrollView(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            child: Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: List.generate(vacinas.length, (vacinasIndex) {
                                                                                                final vacinasItem = vacinas[vacinasIndex];
                                                                                                return Align(
                                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                                  child: Container(
                                                                                                    height: 23.0,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: const Color(0xFFB1CC29),
                                                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                                                    ),
                                                                                                    child: Align(
                                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                                        child: Text(
                                                                                                          vacinasItem,
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                                fontSize: 10.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              }).divide(const SizedBox(width: 8.0)),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 3.0)),
                                                                                  ),
                                                                                ),
                                                                              if ((sanidadesItem.antiparasitario != 'null') && (sanidadesItem.antiparasitario != null && sanidadesItem.antiparasitario != ''))
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Antiparasitário:',
                                                                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                              font: GoogleFonts.plusJakartaSans(
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                              color: const Color(0xFF474747),
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                      Builder(
                                                                                        builder: (context) {
                                                                                          final antiparasitario = functions.converterJSONparaLista(sanidadesItem.antiparasitario!).toList();

                                                                                          return SingleChildScrollView(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            child: Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: List.generate(antiparasitario.length, (antiparasitarioIndex) {
                                                                                                final antiparasitarioItem = antiparasitario[antiparasitarioIndex];
                                                                                                return Align(
                                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                                  child: Container(
                                                                                                    height: 23.0,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: const Color(0xFFB1CC29),
                                                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                                                    ),
                                                                                                    child: Align(
                                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                                        child: Text(
                                                                                                          antiparasitarioItem,
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                                fontSize: 10.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              }).divide(const SizedBox(width: 8.0)),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 3.0)),
                                                                                  ),
                                                                                ),
                                                                              if ((sanidadesItem.tratamento != 'null') && (sanidadesItem.tratamento != null && sanidadesItem.tratamento != ''))
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Tratamento:',
                                                                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                              font: GoogleFonts.plusJakartaSans(
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                              color: const Color(0xFF474747),
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                      Builder(
                                                                                        builder: (context) {
                                                                                          final tratamenteSanidade = functions.converterJSONparaLista(sanidadesItem.tratamento!).toList();

                                                                                          return SingleChildScrollView(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            child: Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: List.generate(tratamenteSanidade.length, (tratamenteSanidadeIndex) {
                                                                                                final tratamenteSanidadeItem = tratamenteSanidade[tratamenteSanidadeIndex];
                                                                                                return Align(
                                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                                  child: Container(
                                                                                                    height: 23.0,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: const Color(0xFFB1CC29),
                                                                                                      borderRadius: BorderRadius.circular(4.0),
                                                                                                    ),
                                                                                                    child: Align(
                                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                                        child: Text(
                                                                                                          tratamenteSanidadeItem,
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                                fontSize: 10.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              }).divide(const SizedBox(width: 8.0)),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 3.0)),
                                                                                  ),
                                                                                ),
                                                                              if ((sanidadesItem.protocoloReprodutivo != 'null') && (sanidadesItem.protocoloReprodutivo != null && sanidadesItem.protocoloReprodutivo != ''))
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Protocolo:',
                                                                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                              font: GoogleFonts.plusJakartaSans(
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                              color: const Color(0xFF474747),
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                      SingleChildScrollView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Align(
                                                                                              alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                              child: Container(
                                                                                                height: 23.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: const Color(0xFFB1CC29),
                                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                                ),
                                                                                                child: Align(
                                                                                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                                    child: Text(
                                                                                                      valueOrDefault<String>(
                                                                                                        sanidadesItem.protocoloReprodutivo,
                                                                                                        'N/A',
                                                                                                      ),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                            fontSize: 10.0,
                                                                                                            letterSpacing: 0.0,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 8.0)),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 3.0)),
                                                                                  ),
                                                                                ),
                                                                              if ((sanidadesItem.protocoloD0 != 'null') && (sanidadesItem.protocoloD0 != null && sanidadesItem.protocoloD0 != ''))
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Protocolo D0:',
                                                                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                              font: GoogleFonts.plusJakartaSans(
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                              color: const Color(0xFF474747),
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                      SingleChildScrollView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Align(
                                                                                              alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                              child: Container(
                                                                                                height: 23.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: const Color(0xFFB1CC29),
                                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                                ),
                                                                                                child: Align(
                                                                                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                                    child: Text(
                                                                                                      valueOrDefault<String>(
                                                                                                        sanidadesItem.protocoloD0,
                                                                                                        'N/A',
                                                                                                      ),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                            fontSize: 10.0,
                                                                                                            letterSpacing: 0.0,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 8.0)),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 3.0)),
                                                                                  ),
                                                                                ),
                                                                              if ((sanidadesItem.protocoloRetirada != 'null') && (sanidadesItem.protocoloRetirada != null && sanidadesItem.protocoloRetirada != ''))
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Protocolo retirada:',
                                                                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                              font: GoogleFonts.plusJakartaSans(
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                              color: const Color(0xFF474747),
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                      SingleChildScrollView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Align(
                                                                                              alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                              child: Container(
                                                                                                height: 23.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: const Color(0xFFB1CC29),
                                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                                ),
                                                                                                child: Align(
                                                                                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                                    child: Text(
                                                                                                      valueOrDefault<String>(
                                                                                                        sanidadesItem.protocoloRetirada,
                                                                                                        'N/A',
                                                                                                      ),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                            fontSize: 10.0,
                                                                                                            letterSpacing: 0.0,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 8.0)),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 3.0)),
                                                                                  ),
                                                                                ),
                                                                              if (((sanidadesItem.protocoloIatf != 'null') && (sanidadesItem.protocoloIatf == null || sanidadesItem.protocoloIatf == '')) &&
                                                                                  responsiveVisibility(
                                                                                    context: context,
                                                                                    phone: false,
                                                                                    tablet: false,
                                                                                    tabletLandscape: false,
                                                                                    desktop: false,
                                                                                  ))
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Protocolo IATF:',
                                                                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                              font: GoogleFonts.plusJakartaSans(
                                                                                                fontWeight: FontWeight.normal,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                              color: const Color(0xFF474747),
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.normal,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                      SingleChildScrollView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Align(
                                                                                              alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                              child: Container(
                                                                                                height: 23.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: const Color(0xFFB1CC29),
                                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                                ),
                                                                                                child: Align(
                                                                                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                                    child: Text(
                                                                                                      valueOrDefault<String>(
                                                                                                        sanidadesItem.protocoloIatf,
                                                                                                        'N/A',
                                                                                                      ),
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                            color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                                            fontSize: 10.0,
                                                                                                            letterSpacing: 0.0,
                                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 8.0)),
                                                                                        ),
                                                                                      ),
                                                                                    ].divide(const SizedBox(width: 3.0)),
                                                                                  ),
                                                                                ),
                                                                            ].divide(const SizedBox(height: 8.0)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1.0,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderRadius: 8.0,
                                                  buttonSize: 40.0,
                                                  disabledIconColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .tertiary,
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_left_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: (_model.pageNum ==
                                                          1)
                                                      ? null
                                                      : () async {
                                                          _model.pageNum =
                                                              _model.pageNum +
                                                                  -1;
                                                          safeSetState(() {});
                                                        },
                                                ),
                                                RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: valueOrDefault<
                                                            String>(
                                                          _model.pageNum
                                                              .toString(),
                                                          '1',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
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
                                                      TextSpan(
                                                        text: ' de ',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      TextSpan(
                                                        text: valueOrDefault<
                                                            String>(
                                                          ((FFAppState().qtdSanidades /
                                                                      (_model
                                                                          .limit!))
                                                                  .ceil())
                                                              .toString(),
                                                          '1',
                                                        ),
                                                        style:
                                                            const TextStyle(),
                                                      )
                                                    ],
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                        ),
                                                  ),
                                                ),
                                                FlutterFlowIconButton(
                                                  borderRadius: 8.0,
                                                  buttonSize: 40.0,
                                                  disabledIconColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .tertiary,
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_right_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: (_model.pageNum ==
                                                          valueOrDefault<int>(
                                                            (FFAppState()
                                                                        .qtdSanidades /
                                                                    (_model
                                                                        .limit!))
                                                                .ceil(),
                                                            1,
                                                          ))
                                                      ? null
                                                      : () async {
                                                          _model.pageNum =
                                                              _model.pageNum +
                                                                  1;
                                                          safeSetState(() {});
                                                        },
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 8.0)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
