import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_reproducao_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/reproducao/edit_reproducao_rebanho/edit_reproducao_rebanho_widget.dart';
import '/reproducao/filtros_reproducao/filtros_reproducao_widget.dart';
import '/reproducao/view_reproducao_rebanho/view_reproducao_rebanho_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'page_reproducoes_model.dart';
export 'page_reproducoes_model.dart';

class PageReproducoesWidget extends StatefulWidget {
  const PageReproducoesWidget({super.key});

  @override
  State<PageReproducoesWidget> createState() => _PageReproducoesWidgetState();
}

class _PageReproducoesWidgetState extends State<PageReproducoesWidget> {
  late PageReproducoesModel _model;

  Future<void> _prepareReproducaoContext({
    required String? idRebanhoReprodutor,
    required String? idRebanhoMatriz,
  }) async {
    final reprodutor = await SQLiteManager.instance.buscarRebanho(
      idRebanho: idRebanhoReprodutor,
    );
    final matriz = await SQLiteManager.instance.buscarRebanho(
      idRebanho: idRebanhoMatriz,
    );

    FFAppState().reprodutorSelecionado = AnimalSelecionadoStruct(
      numAnimal: reprodutor.firstOrNull?.numeroAnimal,
      nomeAnimal: reprodutor.firstOrNull?.nome,
      dataNascAnimal: reprodutor.firstOrNull?.dataNascimento,
      racaAnimal: reprodutor.firstOrNull?.raca,
      idRebanho: reprodutor.firstOrNull?.idRebanho,
    );

    FFAppState().matrizSelecionada = AnimalSelecionadoStruct(
      numAnimal: matriz.firstOrNull?.numeroAnimal,
      nomeAnimal: matriz.firstOrNull?.nome,
      dataNascAnimal: matriz.firstOrNull?.dataNascimento,
      racaAnimal: matriz.firstOrNull?.raca,
      idRebanho: matriz.firstOrNull?.idRebanho,
    );

    safeSetState(() {});
  }

  Future<void> _openViewReproducao({
    required BuildContext ctx,
    required String idReproducao,
    required String? idRebanhoReprodutor,
    required String? idRebanhoMatriz,
  }) async {
    await _prepareReproducaoContext(
      idRebanhoReprodutor: idRebanhoReprodutor,
      idRebanhoMatriz: idRebanhoMatriz,
    );

    await showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      context: ctx,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment:
              AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(ctx)),
          child: ViewReproducaoRebanhoWidget(
            idReproducao: idReproducao,
          ),
        );
      },
    );
  }

  Future<void> _openEditReproducao({
    required BuildContext ctx,
    required String idReproducao,
    required String? idRebanhoReprodutor,
    required String? idRebanhoMatriz,
  }) async {
    await _prepareReproducaoContext(
      idRebanhoReprodutor: idRebanhoReprodutor,
      idRebanhoMatriz: idRebanhoMatriz,
    );

    await showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      context: ctx,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment:
              AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(ctx)),
          child: EditReproducaoRebanhoWidget(
            idReproducao: idReproducao,
          ),
        );
      },
    );
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageReproducoesModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await action_blocks.qTDReproducoes(context);
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
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              child: wrapWithModel(
                model: _model.selecionarPropriedadeModel,
                updateCallback: () => safeSetState(() {}),
                child: SelecionarPropriedadeWidget(),
              ),
            ),
            if (FFAppState().visibilidadeProgressBarRepro == true)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carregando dados:',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (FFAppState().visibilidadeProgressBarRepro == true)
                          LinearPercentIndicator(
                            percent: (int total, int indexPag) {
                              return indexPag / total.ceil() > 1.0
                                  ? 1.0
                                  : indexPag / total.ceil();
                            }(FFAppState().totalReproducoes,
                                FFAppState().indexReproPaginacao),
                            width: MediaQuery.sizeOf(context).width * 0.88,
                            lineHeight: 20.0,
                            animation: true,
                            animateFromLastPercent: true,
                            progressColor: FlutterFlowTheme.of(context).primary,
                            backgroundColor:
                                FlutterFlowTheme.of(context).accent4,
                            center: Text(
                              formatNumber(
                                (int total, int indexPag) {
                                  return indexPag / total.ceil() > 1.0
                                      ? 1.0
                                      : indexPag / total.ceil();
                                }(FFAppState().totalReproducoes,
                                    FFAppState().indexReproPaginacao),
                                formatType: FormatType.percent,
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .headlineSmallFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .headlineSmallIsCustom,
                                  ),
                            ),
                            barRadius: Radius.circular(8.0),
                            padding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                  ].divide(SizedBox(height: 6.0)),
                ),
              ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: Container(
                width: double.infinity,
                height: 120.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F8F8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Reproduo.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  FFAppState().countReproducoes.toString(),
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
                              Flexible(
                                child: Text(
                                  'Reproduções',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF8E8E8E),
                                        fontSize: 11.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F8F8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Reproduo.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  FFAppState().countInseminacoes.toString(),
                                  '0',
                                ),
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              Flexible(
                                child: Text(
                                  'Inseminações',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF8E8E8E),
                                        fontSize: 11.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F8F8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Reproduo.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  FFAppState().countMontaNatural.toString(),
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
                                  'Montas Naturais',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF8E8E8E),
                                        fontSize: 11.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ),
                      ),
                    ),
                  ]
                      .divide(SizedBox(width: 8.0))
                      .addToStart(SizedBox(width: 24.0))
                      .addToEnd(SizedBox(width: 24.0)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0.0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: _model.pesquisarTextController,
                  focusNode: _model.pesquisarFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.pesquisarTextController',
                    Duration(milliseconds: 2000),
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
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0.0),
              child: Container(
                width: double.infinity,
                height: 40.0,
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
                                child: FiltrosReproducaoWidget(),
                              );
                            },
                          ).then((value) => safeSetState(() {}));
                        },
                        child: Container(
                          width: 102.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(0xFFBEBEBE),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
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
                                    'assets/images/Filter.png',
                                    width: 16.0,
                                    height: 16.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      if (FFAppState().filtroPrevisaoPartoTxt != null &&
                          FFAppState().filtroPrevisaoPartoTxt != '')
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(0xFFBEBEBE),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            child: Text(
                              FFAppState().filtroPrevisaoPartoTxt,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF5F5F5F),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      if (FFAppState().filtroDataReproducaoTxt != null &&
                          FFAppState().filtroDataReproducaoTxt != '')
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(0xFFBEBEBE),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            child: Text(
                              FFAppState().filtroDataReproducaoTxt,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF5F5F5F),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      Builder(
                        builder: (context) {
                          final filtroRepro =
                              FFAppState().filtrosAplicadosReproducao.toList();

                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(filtroRepro.length,
                                (filtroReproIndex) {
                              final filtroReproItem =
                                  filtroRepro[filtroReproIndex];
                              return Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(24.0),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Color(0xFFBEBEBE),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Text(
                                    filtroReproItem,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0xFF5F5F5F),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              );
                            }).divide(SizedBox(width: 8.0)),
                          );
                        },
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Builder(
                builder: (context) {
                  if (_model.pesquisarTextController.text == null ||
                      _model.pesquisarTextController.text == '') {
                    return FutureBuilder<List<ListarReproducoesPaginadaRow>>(
                      future: SQLiteManager.instance.listarReproducoesPaginada(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        limitRep: _model.limit,
                        offsetRep: _model.offset.toString(),
                        tipoRepro: FFAppState().filtroReproducao,
                        inseminador: FFAppState().filtroInseminador,
                        loteNome: FFAppState().filtroLoteReproducao,
                        dataRepro: dateTimeFormat(
                          "yyyy-MM-dd",
                          FFAppState().filtroDataReproducao,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        dataPrev: dateTimeFormat(
                          "yyyy-MM-dd",
                          FFAppState().filtroDataParto,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        dataHoje: dateTimeFormat(
                          "yyyy-MM-dd",
                          FFAppState().filtroDataHoje,
                          locale: FFLocalizations.of(context).languageCode,
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          );
                        }
                        final reproducaoPaginadaListarReproducoesPaginadaRowList =
                            snapshot.data!;

                        return Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(reproducaoPaginadaListarReproducoesPaginadaRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 48.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x41000040),
                                          offset: Offset(
                                            2.0,
                                            2.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Reproduoreproducao.png',
                                              height: 74.0,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          RichText(
                                            textScaler: MediaQuery.of(context)
                                                .textScaler,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Nenhuma reprodução foi encontrada',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                )
                                              ],
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
                                                      ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ].divide(SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (reproducaoPaginadaListarReproducoesPaginadaRowList
                                  .isNotEmpty)
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 14.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          final reproducao =
                                              reproducaoPaginadaListarReproducoesPaginadaRowList
                                                  .sortedList(
                                                      keyOf: (e) =>
                                                          e.createdAt!,
                                                      desc: true)
                                                  .toList();
                                          if (reproducao.isEmpty) {
                                            return Center(
                                              child: Container(
                                                height: 200.0,
                                                child: EmptyReproducaoWidget(),
                                              ),
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            itemCount: reproducao.length,
                                            itemBuilder:
                                                (context, reproducaoIndex) {
                                              final reproducaoItem =
                                                  reproducao[reproducaoIndex];
                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                    Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    24.0,
                                                                    8.0,
                                                                    24.0,
                                                                    8.0),
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children:
                                                                          [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Reproducao5675.png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                          ),
                                                                        ),
                                                                        ClipRRect(
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
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                23.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Color(0xFFF1F1F1),
                                                                              borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(100.0),
                                                                                bottomRight: Radius.circular(100.0),
                                                                                topLeft: Radius.circular(100.0),
                                                                                topRight: Radius.circular(100.0),
                                                                              ),
                                                                            ),
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                              child: Text(
                                                                                '${valueOrDefault<String>(
                                                                                  reproducaoItem.tipoReproducao,
                                                                                  '--',
                                                                                )} (${reproducaoItem.tipoReproducao == 'Inseminação' ? (functions.converterParaData(reproducaoItem.dataInseminacao) != null
                                                                                    ? dateTimeFormat(
                                                                                        "dd/MM/yy",
                                                                                        functions.converterParaData(reproducaoItem.dataInseminacao),
                                                                                        locale: FFLocalizations.of(context).languageCode,
                                                                                      )
                                                                                    : 'N/A') : (functions.converterParaData(reproducaoItem.dataInicial) != null
                                                                                    ? dateTimeFormat(
                                                                                        "dd/MM/yy",
                                                                                        functions.converterParaData(reproducaoItem.dataInicial),
                                                                                        locale: FFLocalizations.of(context).languageCode,
                                                                                      )
                                                                                    : 'N/A')})',
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.poppins(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: Color(0xFF5F5F5F),
                                                                                      fontSize: 10.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        if ((reproducaoItem.ressinc != null && reproducaoItem.ressinc != '') &&
                                                                          (reproducaoItem.ressinc != '-') &&
                                                                          (reproducaoItem.ressinc != 'null'))
                                                                          Container(
                                                                            width:
                                                                                20.0,
                                                                            height:
                                                                                20.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(100.0),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                              child: Text(
                                                                                'R',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ].divide(SizedBox(
                                                                              width: 8.0)),
                                                                    ),
                                                                    if (reproducaoItem
                                                                            .idLote !=
                                                                        ' ')
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Lotes887.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Lote da reprodução:',
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFF5F5F5F),
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              valueOrDefault<String>(
                                                                                valueOrDefault<String>(
                                                                                          reproducaoItem.loteNome,
                                                                                          '--',
                                                                                        ) ==
                                                                                        'null'
                                                                                    ? 'S/L'
                                                                                    : valueOrDefault<String>(
                                                                                        reproducaoItem.loteNome,
                                                                                        'S/L',
                                                                                      ),
                                                                                'S/L',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    font: GoogleFonts.poppins(
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF5F5F5F),
                                                                                    fontSize: 14.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 3.0)),
                                                                      ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Sexofemea.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                7.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'Matriz:',
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    font: GoogleFonts.poppins(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF474747),
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              valueOrDefault<String>(
                                                                                '${valueOrDefault<String>(
                                                                                  reproducaoItem.numMatriz,
                                                                                  '--',
                                                                                )} • ${valueOrDefault<String>(
                                                                                      reproducaoItem.nomeMatriz,
                                                                                      '--',
                                                                                    ) == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                                    reproducaoItem.nomeMatriz,
                                                                                    '--',
                                                                                  )} • ${reproducaoItem.nascimentoMatriz == 'null' ? 'N/A' : dateTimeFormat(
                                                                                      "dd/MM/yyyy",
                                                                                      functions.converterParaData(reproducaoItem.nascimentoMatriz),
                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                    )}',
                                                                                '--',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    font: GoogleFonts.plusJakartaSans(
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF474747),
                                                                                    fontSize: 14.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 3.0)),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children:
                                                                          [
                                                                        ClipRRect(
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
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                23.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: colorFromCssString(
                                                                                () {
                                                                                  if (reproducaoItem.statusReproducao == 'Prenhez') {
                                                                                    return '#EFF5D4';
                                                                                  } else if (reproducaoItem.statusReproducao == 'Não diagnosticado') {
                                                                                    return '#F1F1F1';
                                                                                  } else {
                                                                                    return '#f5d7d4';
                                                                                  }
                                                                                }(),
                                                                                defaultColor: Color(0xFFF5D7D4),
                                                                              ),
                                                                              borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(100.0),
                                                                                bottomRight: Radius.circular(100.0),
                                                                                topLeft: Radius.circular(100.0),
                                                                                topRight: Radius.circular(100.0),
                                                                              ),
                                                                            ),
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Text(
                                                                                    valueOrDefault<String>(
                                                                                      '${reproducaoItem.statusReproducao}',
                                                                                      '--',
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                          font: GoogleFonts.poppins(
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                          color: colorFromCssString(
                                                                                            () {
                                                                                              if (reproducaoItem.statusReproducao == 'Prenhez') {
                                                                                                return '#1e7a4c';
                                                                                              } else if (reproducaoItem.statusReproducao == 'Não diagnosticado') {
                                                                                                return '#5F5F5F';
                                                                                              } else {
                                                                                                return '#cc3729';
                                                                                              }
                                                                                            }(),
                                                                                            defaultColor: Color(0xFFCC3729),
                                                                                          ),
                                                                                          fontSize: 10.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                  if ((reproducaoItem.statusReproducao != null &&
                                                                                          reproducaoItem.statusReproducao != '' &&
                                                                                          reproducaoItem.statusReproducao != 'Não diagnosticado') &&
                                                                                      (functions.converterParaData(reproducaoItem.dataStatus) != null))
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        ' (${dateTimeFormat(
                                                                                          "dd/MM/yy",
                                                                                          functions.converterParaData(reproducaoItem.dataStatus),
                                                                                          locale: FFLocalizations.of(context).languageCode,
                                                                                        )})',
                                                                                        '--',
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.poppins(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: colorFromCssString(
                                                                                              reproducaoItem.statusReproducao == 'Prenhez' ? '#1e7a4c' : '#cc3729',
                                                                                              defaultColor: Color(0xFFCC3729),
                                                                                            ),
                                                                                            fontSize: 10.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 8.0)),
                                                                    ),
                                                                    if (reproducaoItem
                                                                            .parida ==
                                                                        'SIM')
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              bottomLeft: Radius.circular(100.0),
                                                                              bottomRight: Radius.circular(100.0),
                                                                              topLeft: Radius.circular(100.0),
                                                                              topRight: Radius.circular(100.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              height: 23.0,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xFFEFF5D4),
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(100.0),
                                                                                  bottomRight: Radius.circular(100.0),
                                                                                  topLeft: Radius.circular(100.0),
                                                                                  topRight: Radius.circular(100.0),
                                                                                ),
                                                                              ),
                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                child: Text(
                                                                                  valueOrDefault<String>(
                                                                                    'Parida em (${valueOrDefault<String>(
                                                                                      functions.converterParaData(reproducaoItem.dataParto) != null
                                                                                          ? dateTimeFormat(
                                                                                              "dd/MM/yy",
                                                                                              functions.converterParaData(reproducaoItem.dataParto),
                                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                                            )
                                                                                          : 'S/D',
                                                                                      'S/D',
                                                                                    )})',
                                                                                    '--',
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.poppins(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: Color(0xFF1E7A4C),
                                                                                        fontSize: 10.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 8.0)),
                                                                      ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Sexomacho.png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Reprodutor:',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                font: GoogleFonts.poppins(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                                color: Color(0xFF474747),
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                              ),
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            '${valueOrDefault<String>(
                                                                              valueOrDefault<String>(
                                                                                        reproducaoItem.numReprodutor,
                                                                                        '--',
                                                                                      ) ==
                                                                                      'null'
                                                                                  ? 'S/N'
                                                                                  : valueOrDefault<String>(
                                                                                      reproducaoItem.numReprodutor,
                                                                                      'S/N',
                                                                                    ),
                                                                              'S/N',
                                                                            )} • ${valueOrDefault<String>(
                                                                              valueOrDefault<String>(
                                                                                        reproducaoItem.nomeReprodutor,
                                                                                        'S/N',
                                                                                      ) ==
                                                                                      'null'
                                                                                  ? 'S/N'
                                                                                  : valueOrDefault<String>(
                                                                                      reproducaoItem.nomeReprodutor,
                                                                                      'S/N',
                                                                                    ),
                                                                              'S/N',
                                                                            )} • ${valueOrDefault<String>(
                                                                              valueOrDefault<String>(
                                                                                        reproducaoItem.nascimentoReprodutor,
                                                                                        '--',
                                                                                      ) ==
                                                                                      'null'
                                                                                  ? 'N/A'
                                                                                  : dateTimeFormat(
                                                                                      "d/M/y",
                                                                                      functions.converterParaData(valueOrDefault<String>(
                                                                                        reproducaoItem.nascimentoReprodutor,
                                                                                        '--',
                                                                                      )),
                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                    ),
                                                                              'N/A',
                                                                            )}',
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 3.0)),
                                                                    ),
                                                                    if (reproducaoItem
                                                                            .tipoReproducao ==
                                                                        'Inseminação')
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children:
                                                                            [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children:
                                                                                [
                                                                              Text(
                                                                                'Previsão de parto:',
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.poppins(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: Color(0xFF474747),
                                                                                      fontSize: 14.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ].divide(SizedBox(width: 5.0)),
                                                                          ),
                                                                          Text(
                                                                            valueOrDefault<String>(
                                                                              functions.converterParaData(reproducaoItem.previsaoParto) !=
                                                                                      null
                                                                                  ? dateTimeFormat(
                                                                                      "dd/MM/yy",
                                                                                      functions.converterParaData(reproducaoItem.previsaoParto),
                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                    )
                                                                                  : 'S/D',
                                                                              'S/D',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 3.0)),
                                                                      ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          4.0)),
                                                                ),
                                                              ),
                                                                Row(
                                                                mainAxisSize:
                                                                  MainAxisSize
                                                                    .min,
                                                                children: [
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
                                                                    await _openViewReproducao(
                                                                    ctx: context,
                                                                    idReproducao:
                                                                      reproducaoItem.idReproducao!,
                                                                    idRebanhoReprodutor:
                                                                      reproducaoItem.idRebanhoReprodutor,
                                                                    idRebanhoMatriz:
                                                                      reproducaoItem.idRebanhoMatriz,
                                                                    );
                                                                  },
                                                                  child:
                                                                    Icon(
                                                                    Icons
                                                                      .visibility_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                        context)
                                                                      .primaryText,
                                                                    size:
                                                                      24.0,
                                                                  ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                      16.0),
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
                                                                    await _openEditReproducao(
                                                                    ctx: context,
                                                                    idReproducao:
                                                                      reproducaoItem.idReproducao!,
                                                                    idRebanhoReprodutor:
                                                                      reproducaoItem.idRebanhoReprodutor,
                                                                    idRebanhoMatriz:
                                                                      reproducaoItem.idRebanhoMatriz,
                                                                    );
                                                                  },
                                                                  child:
                                                                    Icon(
                                                                    Icons
                                                                      .edit_outlined,
                                                                    color: Color(
                                                                      0xFF1E7A4C),
                                                                    size:
                                                                      24.0,
                                                                  ),
                                                                  ),
                                                                ],
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
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FlutterFlowIconButton(
                                      borderRadius: 8.0,
                                      buttonSize: 40.0,
                                      disabledIconColor:
                                          FlutterFlowTheme.of(context).tertiary,
                                      icon: Icon(
                                        Icons.keyboard_arrow_left_sharp,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      onPressed: (_model.pageNum == 1)
                                          ? null
                                          : () async {
                                              _model.pageNum =
                                                  _model.pageNum! + -1;
                                              _model.offset =
                                                  _model.offset + -20;
                                              safeSetState(() {});
                                            },
                                    ),
                                    RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: valueOrDefault<String>(
                                              _model.pageNum?.toString(),
                                              '1',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                          TextSpan(
                                            text: ' de ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                          TextSpan(
                                            text: valueOrDefault<String>(
                                              ((FFAppState().countReproducoes /
                                                          _model.limit)
                                                      .ceil())
                                                  .toString(),
                                              '1',
                                            ),
                                            style: TextStyle(),
                                          )
                                        ],
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
                                    ),
                                    FlutterFlowIconButton(
                                      borderRadius: 8.0,
                                      buttonSize: 40.0,
                                      disabledIconColor:
                                          FlutterFlowTheme.of(context).tertiary,
                                      icon: Icon(
                                        Icons.keyboard_arrow_right_sharp,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      onPressed: (_model.pageNum ==
                                              valueOrDefault<int>(
                                                (FFAppState().countReproducoes /
                                                        _model.limit)
                                                    .ceil(),
                                                1,
                                              ))
                                          ? null
                                          : () async {
                                              _model.pageNum =
                                                  _model.pageNum! + 1;
                                              _model.offset =
                                                  _model.offset + 20;
                                              safeSetState(() {});
                                            },
                                    ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return FutureBuilder<List<ListarReproducoesPesqRow>>(
                      future: SQLiteManager.instance.listarReproducoesPesq(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        tipoRepro: FFAppState().filtroReproducao,
                        inseminador: FFAppState().filtroInseminador,
                        loteNome: FFAppState().filtroLoteReproducao,
                        pesquisa: _model.pesquisarTextController.text,
                        dataRepro: dateTimeFormat(
                          "yyyy-MM-dd",
                          FFAppState().filtroDataReproducao,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        dataPrev: dateTimeFormat(
                          "yyyy-MM-dd",
                          FFAppState().filtroDataParto,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        dataHoje: dateTimeFormat(
                          "yyyy-MM-dd",
                          FFAppState().filtroDataHoje,
                          locale: FFLocalizations.of(context).languageCode,
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          );
                        }
                        final reproducaoPesqListarReproducoesPesqRowList =
                            snapshot.data!;

                        return Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(reproducaoPesqListarReproducoesPesqRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 48.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x41000040),
                                          offset: Offset(
                                            2.0,
                                            2.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Reproduoreproducao.png',
                                              height: 74.0,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          RichText(
                                            textScaler: MediaQuery.of(context)
                                                .textScaler,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Nenhuma reprodução foi encontrada',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                )
                                              ],
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
                                                      ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ].divide(SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (reproducaoPesqListarReproducoesPesqRowList
                                  .isNotEmpty)
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 14.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          final reproducao =
                                              reproducaoPesqListarReproducoesPesqRowList
                                                  .toList()
                                                  .take(20)
                                                  .toList();
                                          if (reproducao.isEmpty) {
                                            return Center(
                                              child: Container(
                                                height: 200.0,
                                                child: EmptyReproducaoWidget(),
                                              ),
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            itemCount: reproducao.length,
                                            itemBuilder:
                                                (context, reproducaoIndex) {
                                              final reproducaoItem =
                                                  reproducao[reproducaoIndex];
                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                    Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    24.0,
                                                                    8.0,
                                                                    24.0,
                                                                    8.0),
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children:
                                                                          [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Reproducao5675.png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                          ),
                                                                        ),
                                                                        ClipRRect(
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
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                23.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Color(0xFFF1F1F1),
                                                                              borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(100.0),
                                                                                bottomRight: Radius.circular(100.0),
                                                                                topLeft: Radius.circular(100.0),
                                                                                topRight: Radius.circular(100.0),
                                                                              ),
                                                                            ),
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                              child: Text(
                                                                                '${valueOrDefault<String>(
                                                                                  reproducaoItem.tipoReproducao,
                                                                                  '--',
                                                                                )} (${reproducaoItem.tipoReproducao == 'Inseminação' ? (functions.converterParaData(reproducaoItem.dataInseminacao) != null
                                                                                    ? dateTimeFormat(
                                                                                        "dd/MM/yy",
                                                                                        functions.converterParaData(reproducaoItem.dataInseminacao),
                                                                                        locale: FFLocalizations.of(context).languageCode,
                                                                                      )
                                                                                    : 'N/A') : (functions.converterParaData(reproducaoItem.dataInicial) != null
                                                                                    ? dateTimeFormat(
                                                                                        "dd/MM/yy",
                                                                                        functions.converterParaData(reproducaoItem.dataInicial),
                                                                                        locale: FFLocalizations.of(context).languageCode,
                                                                                      )
                                                                                    : 'N/A')})',
                                                                                textAlign: TextAlign.center,
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.poppins(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: Color(0xFF5F5F5F),
                                                                                      fontSize: 10.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        if ((reproducaoItem.ressinc != null && reproducaoItem.ressinc != '') &&
                                                                          (reproducaoItem.ressinc != '-') &&
                                                                          (reproducaoItem.ressinc != 'null'))
                                                                          Container(
                                                                            width:
                                                                                20.0,
                                                                            height:
                                                                                20.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              borderRadius: BorderRadius.circular(100.0),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                              child: Text(
                                                                                'R',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ].divide(SizedBox(
                                                                              width: 8.0)),
                                                                    ),
                                                                    if (reproducaoItem
                                                                            .idLote !=
                                                                        ' ')
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Lotes887.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Lote da reprodução:',
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFF5F5F5F),
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              valueOrDefault<String>(
                                                                                valueOrDefault<String>(
                                                                                          reproducaoItem.loteNome,
                                                                                          '--',
                                                                                        ) ==
                                                                                        'null'
                                                                                    ? 'S/L'
                                                                                    : valueOrDefault<String>(
                                                                                        reproducaoItem.loteNome,
                                                                                        'S/L',
                                                                                      ),
                                                                                'S/L',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    font: GoogleFonts.poppins(
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF5F5F5F),
                                                                                    fontSize: 14.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 3.0)),
                                                                      ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Sexofemea.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                7.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'Matriz:',
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    font: GoogleFonts.poppins(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF474747),
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              valueOrDefault<String>(
                                                                                '${valueOrDefault<String>(
                                                                                  valueOrDefault<String>(
                                                                                            reproducaoItem.numMatriz,
                                                                                            'S/N',
                                                                                          ) ==
                                                                                          'null'
                                                                                      ? 'S/N'
                                                                                      : valueOrDefault<String>(
                                                                                          reproducaoItem.numMatriz,
                                                                                          'S/N',
                                                                                        ),
                                                                                  'S/N',
                                                                                )} • ${valueOrDefault<String>(
                                                                                  valueOrDefault<String>(
                                                                                            reproducaoItem.nomeMatriz,
                                                                                            '--',
                                                                                          ) ==
                                                                                          'null'
                                                                                      ? 'S/N'
                                                                                      : valueOrDefault<String>(
                                                                                          reproducaoItem.nomeMatriz,
                                                                                          'S/N',
                                                                                        ),
                                                                                  'S/N',
                                                                                )} • ${valueOrDefault<String>(
                                                                                  reproducaoItem.nascimentoMatriz == 'null'
                                                                                      ? 'N/A'
                                                                                      : (functions.converterParaData(reproducaoItem.nascimentoMatriz) != null
                                                                                          ? valueOrDefault<String>(
                                                                                              dateTimeFormat(
                                                                                                "dd/MM/yyyy",
                                                                                                functions.converterParaData(reproducaoItem.nascimentoMatriz),
                                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                                              ),
                                                                                              'N/A',
                                                                                            )
                                                                                          : 'N/A'),
                                                                                  'N/A',
                                                                                )}',
                                                                                '--',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                    font: GoogleFonts.plusJakartaSans(
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF474747),
                                                                                    fontSize: 14.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 3.0)),
                                                                      ),
                                                                    ),
                                                                    if (reproducaoItem
                                                                            .tipoReproducao ==
                                                                        'Inseminação')
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              bottomLeft: Radius.circular(100.0),
                                                                              bottomRight: Radius.circular(100.0),
                                                                              topLeft: Radius.circular(100.0),
                                                                              topRight: Radius.circular(100.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              height: 23.0,
                                                                              decoration: BoxDecoration(
                                                                                color: colorFromCssString(
                                                                                  () {
                                                                                    if (reproducaoItem.statusReproducao == 'Prenhez') {
                                                                                      return '#EFF5D4';
                                                                                    } else if (reproducaoItem.statusReproducao == 'Não diagnosticado') {
                                                                                      return '#F1F1F1';
                                                                                    } else {
                                                                                      return '#f5d7d4';
                                                                                    }
                                                                                  }(),
                                                                                  defaultColor: Color(0xFFF5D7D4),
                                                                                ),
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(100.0),
                                                                                  bottomRight: Radius.circular(100.0),
                                                                                  topLeft: Radius.circular(100.0),
                                                                                  topRight: Radius.circular(100.0),
                                                                                ),
                                                                              ),
                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      valueOrDefault<String>(
                                                                                        '${reproducaoItem.statusReproducao}',
                                                                                        '--',
                                                                                      ),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                            font: GoogleFonts.poppins(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                            color: colorFromCssString(
                                                                                              () {
                                                                                                if (reproducaoItem.statusReproducao == 'Prenhez') {
                                                                                                  return '#1e7a4c';
                                                                                                } else if (reproducaoItem.statusReproducao == 'Não diagnosticado') {
                                                                                                  return '#5F5F5F';
                                                                                                } else {
                                                                                                  return '#cc3729';
                                                                                                }
                                                                                              }(),
                                                                                              defaultColor: Color(0xFFCC3729),
                                                                                            ),
                                                                                            fontSize: 10.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    if ((reproducaoItem.statusReproducao != null &&
                                                                                            reproducaoItem.statusReproducao != '' &&
                                                                                            reproducaoItem.statusReproducao != 'Não diagnosticado') &&
                                                                                        (functions.converterParaData(reproducaoItem.dataStatus) != null))
                                                                                      Text(
                                                                                        valueOrDefault<String>(
                                                                                          ' (${dateTimeFormat(
                                                                                            "dd/MM/yy",
                                                                                            functions.converterParaData(reproducaoItem.dataStatus),
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          )})',
                                                                                          '--',
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                              font: GoogleFonts.poppins(
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                              ),
                                                                                              color: colorFromCssString(
                                                                                                reproducaoItem.statusReproducao == 'Prenhez' ? '#1e7a4c' : '#cc3729',
                                                                                                defaultColor: Color(0xFFCC3729),
                                                                                              ),
                                                                                              fontSize: 10.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 8.0)),
                                                                      ),
                                                                    if (reproducaoItem
                                                                            .parida ==
                                                                        'SIM')
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              bottomLeft: Radius.circular(100.0),
                                                                              bottomRight: Radius.circular(100.0),
                                                                              topLeft: Radius.circular(100.0),
                                                                              topRight: Radius.circular(100.0),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              height: 23.0,
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xFFEFF5D4),
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(100.0),
                                                                                  bottomRight: Radius.circular(100.0),
                                                                                  topLeft: Radius.circular(100.0),
                                                                                  topRight: Radius.circular(100.0),
                                                                                ),
                                                                              ),
                                                                              alignment: AlignmentDirectional(0.0, 0.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                child: Text(
                                                                                  valueOrDefault<String>(
                                                                                    'Parida em (${valueOrDefault<String>(
                                                                                      functions.converterParaData(reproducaoItem.dataParto) != null
                                                                                          ? dateTimeFormat(
                                                                                              "dd/MM/yy",
                                                                                              functions.converterParaData(reproducaoItem.dataParto),
                                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                                            )
                                                                                          : 'S/D',
                                                                                      'S/D',
                                                                                    )})',
                                                                                    '--',
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.poppins(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: Color(0xFF1E7A4C),
                                                                                        fontSize: 10.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 8.0)),
                                                                      ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Sexomacho.png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Reprodutor:',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                font: GoogleFonts.poppins(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                                color: Color(0xFF474747),
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                              ),
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            '${valueOrDefault<String>(
                                                                              valueOrDefault<String>(
                                                                                        reproducaoItem.numReprodutor,
                                                                                        '--',
                                                                                      ) ==
                                                                                      'null'
                                                                                  ? 'S/N'
                                                                                  : valueOrDefault<String>(
                                                                                      reproducaoItem.numReprodutor,
                                                                                      'S/N',
                                                                                    ),
                                                                              'S/N',
                                                                            )} • ${valueOrDefault<String>(
                                                                              valueOrDefault<String>(
                                                                                        reproducaoItem.nomeReprodutor,
                                                                                        'S/N',
                                                                                      ) ==
                                                                                      'null'
                                                                                  ? 'S/N'
                                                                                  : valueOrDefault<String>(
                                                                                      reproducaoItem.nomeReprodutor,
                                                                                      'S/N',
                                                                                    ),
                                                                              'S/N',
                                                                            )} • ${valueOrDefault<String>(
                                                                              valueOrDefault<String>(
                                                                                        reproducaoItem.nascimentoReprodutor,
                                                                                        '--',
                                                                                      ) ==
                                                                                      'null'
                                                                                  ? 'N/A'
                                                                                  : dateTimeFormat(
                                                                                      "d/M/y",
                                                                                      functions.converterParaData(valueOrDefault<String>(
                                                                                        reproducaoItem.nascimentoReprodutor,
                                                                                        'N/A',
                                                                                      )),
                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                    ),
                                                                              'N/A',
                                                                            )}',
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 3.0)),
                                                                    ),
                                                                    if (reproducaoItem
                                                                            .tipoReproducao ==
                                                                        'Inseminação')
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children:
                                                                            [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children:
                                                                                [
                                                                              Text(
                                                                                'Previsão de parto:',
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.poppins(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: Color(0xFF474747),
                                                                                      fontSize: 14.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ].divide(SizedBox(width: 5.0)),
                                                                          ),
                                                                          Text(
                                                                            valueOrDefault<String>(
                                                                              functions.converterParaData(reproducaoItem.previsaoParto) !=
                                                                                      null
                                                                                  ? dateTimeFormat(
                                                                                      "dd/MM/yy",
                                                                                      functions.converterParaData(reproducaoItem.previsaoParto),
                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                    )
                                                                                  : 'S/D',
                                                                              'S/D',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 3.0)),
                                                                      ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          4.0)),
                                                                ),
                                                              ),
                                                                Row(
                                                                mainAxisSize:
                                                                  MainAxisSize
                                                                    .min,
                                                                children: [
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
                                                                    await _openViewReproducao(
                                                                    ctx: context,
                                                                    idReproducao:
                                                                      reproducaoItem.idReproducao!,
                                                                    idRebanhoReprodutor:
                                                                      reproducaoItem.idRebanhoReprodutor,
                                                                    idRebanhoMatriz:
                                                                      reproducaoItem.idRebanhoMatriz,
                                                                    );
                                                                  },
                                                                  child:
                                                                    Icon(
                                                                    Icons
                                                                      .visibility_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                        context)
                                                                      .primaryText,
                                                                    size:
                                                                      24.0,
                                                                  ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                      16.0),
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
                                                                    await _openEditReproducao(
                                                                    ctx: context,
                                                                    idReproducao:
                                                                      reproducaoItem.idReproducao!,
                                                                    idRebanhoReprodutor:
                                                                      reproducaoItem.idRebanhoReprodutor,
                                                                    idRebanhoMatriz:
                                                                      reproducaoItem.idRebanhoMatriz,
                                                                    );
                                                                  },
                                                                  child:
                                                                    Icon(
                                                                    Icons
                                                                      .edit_outlined,
                                                                    color: Color(
                                                                      0xFF1E7A4C),
                                                                    size:
                                                                      24.0,
                                                                  ),
                                                                  ),
                                                                ],
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
          ],
        ),
      ),
    );
  }
}
