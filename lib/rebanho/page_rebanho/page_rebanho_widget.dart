import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/rebanho/filtros_ordenacao_rebanho/filtros_ordenacao_rebanho_widget.dart';
import '/rebanho/filtros_rebanho/filtros_rebanho_widget.dart';
import '/rebanho/view_rebanho/view_rebanho_widget.dart';
import '/rebanho/edit_rebanho/edit_rebanho_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/actions/actions.dart' as action_blocks;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'page_rebanho_model.dart';
export 'page_rebanho_model.dart';

class PageRebanhoWidget extends StatefulWidget {
  const PageRebanhoWidget({
    super.key,
    this.idPropriedade,
  });

  final String? idPropriedade;

  @override
  State<PageRebanhoWidget> createState() => _PageRebanhoWidgetState();
}

class _PageRebanhoWidgetState extends State<PageRebanhoWidget> {
  static const List<String> _defaultStatusFilters = [
    'Na propriedade',
    'Sêmen',
  ];

  late PageRebanhoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageRebanhoModel());

    _model.pesquisarTextController ??= TextEditingController();
    _model.pesquisarFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyDefaultStatusFilters();
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void _applyDefaultStatusFilters() {
    final appliedFilters = FFAppState()
        .filtrosAplicadosRebanho
        .where((item) => !FFAppState().statusRebanho.contains(item))
        .toList();

    FFAppState().filtroStatusRebanhoList =
        List<String>.from(_defaultStatusFilters);
    FFAppState().filtroStatusRebanho = _defaultStatusFilters.join('|');
    FFAppState().filtrosAplicadosRebanho = [
      ...appliedFilters,
      ..._defaultStatusFilters,
    ];
  }

  String _statusFilterValue() {
    if (FFAppState().filtroStatusRebanhoList.isNotEmpty) {
      return FFAppState().filtroStatusRebanhoList.join('|');
    }

    return FFAppState().filtroStatusRebanho;
  }

  String _dataNascInicioFilterValue() {
    final d = FFAppState().filtroDataNascimentoInicio;
    if (d == null) return '';
    return dateTimeFormat('yyyy-MM-dd', d);
  }

  String _dataNascFimFilterValue() {
    final d = FFAppState().filtroDataNascimentoFim;
    if (d == null) return '';
    return dateTimeFormat('yyyy-MM-dd', d);
  }

  Future<void> _openEditRebanho(BuildContext ctx, String? idRebanho) async {
    if (idRebanho == null) return;

    final rebanhoData = await SQLiteManager.instance.buscarRebanho(
      idRebanho: idRebanho,
    );
    if (rebanhoData.isEmpty) return;

    final reb = rebanhoData.first;

    final matrizData = await SQLiteManager.instance.buscarRebanho(
      idRebanho: reb.rebanhoIdMatriz,
    );
    final reprodutorData = await SQLiteManager.instance.buscarRebanho(
      idRebanho: reb.rebanhoIdReprodutor,
    );

    FFAppState().updateRebanhoSelecionadoStruct(
      (e) => e
        ..idPropriedade = reb.idPropriedade
        ..numeroAnimal = reb.numeroAnimal
        ..chip = reb.chip
        ..codRegistro = reb.codRegistro
        ..nome = reb.nome
        ..sexo = reb.sexo
        ..categoria = reb.categoria
        ..dataNascimento = reb.dataNascimento
        ..pesoNascimento = reb.pesoNascimento
        ..porte = reb.porte
        ..raca = reb.raca
        ..loteId = reb.loteID
        ..dataEntradaLote = reb.dataEntradaLote
        ..rebanhoIdMatriz = reb.rebanhoIdMatriz
        ..rebanhoIdReprodutor = reb.rebanhoIdReprodutor
        ..dataDesmama = reb.dataDesmama
        ..pesoDesmama = reb.pesoDesmama
        ..pesoAtual = reb.pesoAtual
        ..status = reb.statusRebanho
        ..origem = reb.origem
        ..anotacoes = reb.anotacoes
        ..idRebanho = reb.idRebanho
        ..tipo = reb.tipo
        ..dataAcao = reb.dataAcao
        ..valorCompra = reb.valorCompra
        ..dataUltimaPesagem = reb.dataUltimaPesagem
        ..loteNome = reb.loteNome
        ..movimentacaoentrada = reb.movimentacaoEntrada
        ..dataVenda = reb.dataVenda
        ..valorVenda = reb.valorVenda
        ..numeroMatriz = reb.numeroMatriz
        ..nomeMatriz = reb.nomeMatriz
        ..dataNascMatriz = reb.dataNascMatriz
        ..racaMatriz = reb.racaMatriz
        ..numeroReprodutor = reb.numeroReprodutor
        ..nomeReprodutor = reb.nomeReprodutor
        ..dataNascReprodutor = reb.dataNascReprodutor
        ..racaReprodutor = reb.racaReprodutor
        ..movimentacaosaida = reb.movimentacaoSaida
        ..datamorte = reb.dataMorte
        ..motivoMorte = reb.motivoMorte
        ..categoriaMatriz = reb.categoriaMatriz,
    );

    FFAppState().matrizSelecionada = AnimalSelecionadoStruct(
      numAnimal: matrizData.firstOrNull?.numeroAnimal,
      nomeAnimal: matrizData.firstOrNull?.nome,
      dataNascAnimal: matrizData.firstOrNull?.dataNascimento,
      racaAnimal: matrizData.firstOrNull?.raca,
      categoria: matrizData.firstOrNull?.categoria,
    );

    FFAppState().reprodutorSelecionado = AnimalSelecionadoStruct(
      numAnimal: reprodutorData.firstOrNull?.numeroAnimal,
      nomeAnimal: reprodutorData.firstOrNull?.nome,
      dataNascAnimal: reprodutorData.firstOrNull?.dataNascimento,
      racaAnimal: reprodutorData.firstOrNull?.raca,
      categoria: reprodutorData.firstOrNull?.categoria,
    );

    safeSetState(() {});

    final lotesData = await SQLiteManager.instance.buscarLotes(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    );

    FFAppState().rebanhoLotesSelecionar = [];
    safeSetState(() {});

    if (lotesData.isNotEmpty) {
      for (final lote in lotesData) {
        FFAppState().addToRebanhoLotesSelecionar(LocalLotesStruct(
          idLote: lote.idLote,
          nome: lote.nome,
        ));
      }
      safeSetState(() {});
    }

    if (!ctx.mounted) return;

    await showDialog(
      barrierColor: Colors.transparent,
      context: ctx,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: const AlignmentDirectional(0.0, 0.0)
              .resolve(Directionality.of(ctx)),
          child: const EditRebanhoWidget(),
        );
      },
    );

    safeSetState(() {});
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
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: wrapWithModel(
                  model: _model.selecionarPropriedadeModel,
                  updateCallback: () => safeSetState(() {}),
                  child: SelecionarPropriedadeWidget(
                    onPropriedadeChanged: () async {
                      _model.pageNum = 1;
                      _model.offset = 0;
                      _model.pesquisarTextController?.clear();
                      await action_blocks.animaisPropriedade(context);
                      safeSetState(() {});
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (FFAppState().visibleProgressBar == true)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 8.0, 0.0, 0.0),
                        child: LinearPercentIndicator(
                          percent: (int total, int indexPag) {
                            return indexPag / total.ceil() > 1.0
                                ? 1.0
                                : indexPag / total.ceil();
                          }(FFAppState().totalRebanhos,
                              FFAppState().indexRebPaginacao),
                          width: MediaQuery.sizeOf(context).width * 0.87,
                          lineHeight: 20.0,
                          animation: true,
                          animateFromLastPercent: true,
                          progressColor: FlutterFlowTheme.of(context).primary,
                          backgroundColor: FlutterFlowTheme.of(context).accent4,
                          center: Text(
                            formatNumber(
                              (int ctrl, int total, int indexPag) {
                                return (indexPag - ctrl) / total.ceil() > 1.0
                                    ? 1.0
                                    : (indexPag - ctrl) / total.ceil();
                              }(
                                  FFAppState().ctrlUltimaPagina,
                                  FFAppState().totalRebanhos,
                                  FFAppState().indexRebPaginacao),
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
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .headlineSmallIsCustom,
                                ),
                          ),
                          barRadius: const Radius.circular(8.0),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: 159.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12.0, 12.0, 12.0, 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/Group_11_3_(3).png',
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    FFAppState()
                                        .qtdAnimaisPropriedade
                                        .toString(),
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
                                  'Animais \nna propriedade',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: const Color(0xFF2F2F2F),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ].divide(const SizedBox(height: 6.0)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 159.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12.0, 12.0, 12.0, 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/Group_11_3_(3).png',
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    FFAppState().animaisRegistrados.toString(),
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
                                  'Animais \nregistrados',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: const Color(0xFF2F2F2F),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ].divide(const SizedBox(height: 6.0)),
                            ),
                          ),
                        ),
                      ),
                    ].divide(const SizedBox(width: 8.0)),
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
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                      hintText: 'Pesquisar',
                      hintStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
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
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      prefixIcon: Icon(
                        Icons.search_sharp,
                        color: FlutterFlowTheme.of(context).accent3,
                        size: 24.0,
                      ),
                      suffixIcon:
                          _model.pesquisarTextController!.text.isNotEmpty
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
                    const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 4.0, 0.0, 0.0),
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
                                    child: const FiltrosRebanhoWidget(),
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
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
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
                          Builder(
                            builder: (context) {
                              final rebanho =
                                  FFAppState().filtrosAplicadosRebanho.toList();

                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(rebanho.length,
                                    (rebanhoIndex) {
                                  final rebanhoItem = rebanho[rebanhoIndex];
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 8.0, 16.0, 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            rebanhoItem,
                                            style: FlutterFlowTheme.of(context)
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
                                          ),
                                        ].divide(const SizedBox(width: 8.0)),
                                      ),
                                    ),
                                  );
                                }).divide(const SizedBox(width: 8.0)),
                              );
                            },
                          ),
                          if (FFAppState().filtroDataNascimentoInicio != null ||
                              FFAppState().filtroDataNascimentoFim != null)
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
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Nascimento: ${FFAppState().filtroDataNascimentoInicio != null ? dateTimeFormat('d/M/y', FFAppState().filtroDataNascimentoInicio!, locale: FFLocalizations.of(context).languageCode) : '...'} - ${FFAppState().filtroDataNascimentoFim != null ? dateTimeFormat('d/M/y', FFAppState().filtroDataNascimentoFim!, locale: FFLocalizations.of(context).languageCode) : '...'}',
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
                                  ],
                                ),
                              ),
                            ),
                        ].divide(const SizedBox(width: 8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: Color(0xFFEDEDED),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 8.0),
                child: InkWell(
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
                          child: const FiltrosOrdenacaoRebanhoWidget(),
                        );
                      },
                    ).then((value) {
                      _model.pageNum = 1;
                      _model.offset = 0;
                      safeSetState(() {});
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: valueOrDefault<Color>(
                        FFAppState().ordenacaoRebanho == ''
                            ? FlutterFlowTheme.of(context).secondaryBackground
                            : const Color(0xFFD6F5E5),
                        FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(
                        color: valueOrDefault<Color>(
                          FFAppState().ordenacaoRebanho == ''
                              ? FlutterFlowTheme.of(context).tertiary
                              : FlutterFlowTheme.of(context).secondary,
                          FlutterFlowTheme.of(context).accent3,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (FFAppState().ordenacaoRebanho == 'crescente')
                                Icon(
                                  Icons.arrow_upward,
                                  color: FlutterFlowTheme.of(context).accent3,
                                  size: 14.0,
                                ),
                              if (FFAppState().ordenacaoRebanho ==
                                  'decrescente')
                                Icon(
                                  Icons.arrow_downward,
                                  color: FlutterFlowTheme.of(context).accent3,
                                  size: 14.0,
                                ),
                              Text(
                                valueOrDefault<String>(
                                  () {
                                    if (FFAppState().ordenacaoRebanho ==
                                        'crescente') {
                                      return 'Crescente';
                                    } else if (FFAppState().ordenacaoRebanho ==
                                        'decrescente') {
                                      return 'Decrescente';
                                    } else {
                                      return 'Sem ordenação';
                                    }
                                  }(),
                                  'Sem ordenação',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: valueOrDefault<Color>(
                                        FFAppState().ordenacaoRebanho == ''
                                            ? FlutterFlowTheme.of(context)
                                                .accent3
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        FlutterFlowTheme.of(context).accent3,
                                      ),
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ].divide(const SizedBox(width: 6.0)),
                          ),
                          if ((FFAppState().ordenacaoRebanho != '') &&
                              (FFAppState().ordenacaoRebanhoTipo != ''))
                            SizedBox(
                              height: 100.0,
                              child: VerticalDivider(
                                thickness: 2.0,
                                color: FlutterFlowTheme.of(context).accent4,
                              ),
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if ((FFAppState().ordenacaoRebanho != '') &&
                                  (FFAppState().ordenacaoRebanhoTipo != ''))
                                Text(
                                  valueOrDefault<String>(
                                    () {
                                      if (FFAppState().ordenacaoRebanhoTipo ==
                                          'numero') {
                                        return 'Número do animal';
                                      } else if (FFAppState()
                                              .ordenacaoRebanhoTipo ==
                                          'nome') {
                                        return 'Nome do animal';
                                      } else if (FFAppState()
                                              .ordenacaoRebanhoTipo ==
                                          'nascimento') {
                                        return 'Data de nascimento';
                                      } else {
                                        return 'N/A';
                                      }
                                    }(),
                                    'N/A',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              if (FFAppState().ordenacaoRebanho == 'crescente')
                                Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 24.0,
                                ),
                              if (FFAppState().ordenacaoRebanho ==
                                  'decrescente')
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 24.0,
                                ),
                            ].divide(const SizedBox(width: 6.0)),
                          ),
                        ].divide(const SizedBox(width: 8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  if ((_model.pesquisarTextController.text == '') &&
                      (FFAppState().ordenacaoRebanho == '') &&
                      (FFAppState().ordenacaoRebanhoTipo == '')) {
                    return Visibility(
                      visible: FFAppState().propriedadeSelecionada != null,
                      child: FutureBuilder<List<BuscaRebanhoPaginadaRow>>(
                        key: const ValueKey('sem_ord'),
                        future: SQLiteManager.instance.buscaRebanhoPaginada(
                          idPropriedade:
                              FFAppState().propriedadeSelecionada.idPropriedade,
                          limitReb: _model.limit,
                          offsetReb: _model.offset,
                          sexo: FFAppState().filtroSexoRebanho,
                          categoria: FFAppState().filtroCategoriasRebanho,
                          raca: FFAppState().filtroRaca,
                          origem: FFAppState().filtroOrigemRebanho,
                          statusReb: _statusFilterValue(),
                          dataNascInicio: _dataNascInicioFilterValue(),
                          dataNascFim: _dataNascFimFilterValue(),
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
                          final containerPadraoSemOrdBuscaRebanhoPaginadaRowList =
                              snapshot.data!;

                          return Container(
                            decoration: const BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (!(containerPadraoSemOrdBuscaRebanhoPaginadaRowList
                                    .isNotEmpty))
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            24.0, 24.0, 24.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            color: Color(0x41000040),
                                            offset: Offset(
                                              2.0,
                                              2.0,
                                            ),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(32.0, 32.0, 32.0, 32.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                'assets/images/Mask_group.png',
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
                                                        'Nenhum animal foi cadastrado nesta propriedade.',
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
                                          ].divide(
                                              const SizedBox(height: 24.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (containerPadraoSemOrdBuscaRebanhoPaginadaRowList
                                    .isNotEmpty)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 14.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          final animais =
                                              containerPadraoSemOrdBuscaRebanhoPaginadaRowList
                                                  .toList();

                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: List.generate(
                                                animais.length, (animaisIndex) {
                                              final animaisItem =
                                                  animais[animaisIndex];
                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 24.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Builder(
                                                        builder: (context) =>
                                                            Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  24.0,
                                                                  0.0,
                                                                  24.0,
                                                                  24.0),
                                                          child: InkWell(
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
                                                              FFAppState()
                                                                  .crias = [];
                                                              safeSetState(
                                                                  () {});
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                              _model.criasFemea =
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .buscarCriasRebanhoMatriz(
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                              );
                                                              if (_model.criasFemea !=
                                                                      null &&
                                                                  (_model.criasFemea)!
                                                                      .isNotEmpty) {
                                                                while (_model
                                                                        .indexCrias <
                                                                    _model
                                                                        .criasFemea!
                                                                        .length) {
                                                                  FFAppState()
                                                                      .addToCrias(
                                                                          AnimaisStruct(
                                                                    idRebanho: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.idRebanho,
                                                                    sexo: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.sexo,
                                                                    numeroAnimal: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.numeroAnimal,
                                                                    nome: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.nome,
                                                                    dataNascimento: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.dataNascimento,
                                                                    categoria: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.categoria,
                                                                    raca: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.raca,
                                                                    loteNome: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.loteNome,
                                                                    rebanhoIdMatriz: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.rebanhoIdMatriz,
                                                                    rebanhoIdReprodutor: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.rebanhoIdReprodutor,
                                                                    numeroMatriz: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.numeroMatriz,
                                                                    nomeMatriz: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.nomeMatriz,
                                                                    dataNascMatriz: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.dataNascMatriz,
                                                                    racaMatriz: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.racaMatriz,
                                                                    numeroReprodutor: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.numeroReprodutor,
                                                                    nomeReprodutor: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.nomeReprodutor,
                                                                    dataNascReprodutor: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.dataNascReprodutor,
                                                                    racaReprodutor: _model
                                                                        .criasFemea
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.racaReprodutor,
                                                                  ));
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.indexCrias =
                                                                      _model.indexCrias +
                                                                          1;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                                _model.indexCrias =
                                                                    0;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.criasMacho =
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .buscarCriasRebanhoReprodutor(
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                              );
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                              if (_model.criasMacho !=
                                                                      null &&
                                                                  (_model.criasMacho)!
                                                                      .isNotEmpty) {
                                                                while (_model
                                                                        .indexCrias <
                                                                    _model
                                                                        .criasMacho!
                                                                        .length) {
                                                                  FFAppState()
                                                                      .addToCrias(
                                                                          AnimaisStruct(
                                                                    idRebanho: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.idRebanho,
                                                                    sexo: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.sexo,
                                                                    numeroAnimal: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.numeroAnimal,
                                                                    nome: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.nome,
                                                                    dataNascimento: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.dataNascimento,
                                                                    categoria: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.categoria,
                                                                    raca: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.raca,
                                                                    loteNome: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.loteNome,
                                                                    rebanhoIdMatriz: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.rebanhoIdMatriz,
                                                                    rebanhoIdReprodutor: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.rebanhoIdReprodutor,
                                                                    numeroMatriz: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.numeroMatriz,
                                                                    nomeMatriz: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.nomeMatriz,
                                                                    dataNascMatriz: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.dataNascMatriz,
                                                                    racaMatriz: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.racaMatriz,
                                                                    numeroReprodutor: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.numeroReprodutor,
                                                                    nomeReprodutor: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.nomeReprodutor,
                                                                    dataNascReprodutor: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.dataNascReprodutor,
                                                                    racaReprodutor: _model
                                                                        .criasMacho
                                                                        ?.elementAtOrNull(
                                                                            _model.indexCrias)
                                                                        ?.racaReprodutor,
                                                                  ));
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.indexCrias =
                                                                      _model.indexCrias +
                                                                          1;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                                _model.indexCrias =
                                                                    0;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.histPesagens =
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .buscaHistPesagens(
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                              );
                                                              FFAppState()
                                                                  .histPesagens = [];
                                                              safeSetState(
                                                                  () {});
                                                              if (_model.histPesagens !=
                                                                      null &&
                                                                  (_model.histPesagens)!
                                                                      .isNotEmpty) {
                                                                while (_model
                                                                        .indexPesagens <
                                                                    _model
                                                                        .histPesagens!
                                                                        .length) {
                                                                  FFAppState()
                                                                      .addToHistPesagens(
                                                                          HistoricoPesagensStruct(
                                                                    idRebanho: _model
                                                                        .histPesagens
                                                                        ?.elementAtOrNull(
                                                                            _model.indexPesagens)
                                                                        ?.idRebanho,
                                                                    dataPesagem: _model
                                                                        .histPesagens
                                                                        ?.elementAtOrNull(
                                                                            _model.indexPesagens)
                                                                        ?.dataPesagem,
                                                                    tipo: _model
                                                                        .histPesagens
                                                                        ?.elementAtOrNull(
                                                                            _model.indexPesagens)
                                                                        ?.tipo,
                                                                    deletado: _model
                                                                        .histPesagens
                                                                        ?.elementAtOrNull(
                                                                            _model.indexPesagens)
                                                                        ?.deletado,
                                                                    createdAt: _model
                                                                        .histPesagens
                                                                        ?.elementAtOrNull(
                                                                            _model.indexPesagens)
                                                                        ?.createdAt,
                                                                    id: _model
                                                                        .histPesagens
                                                                        ?.elementAtOrNull(
                                                                            _model.indexPesagens)
                                                                        ?.id,
                                                                    peso: _model
                                                                        .histPesagens
                                                                        ?.elementAtOrNull(
                                                                            _model.indexPesagens)
                                                                        ?.peso,
                                                                  ));
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.indexPesagens =
                                                                      _model.indexPesagens +
                                                                          1;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                                _model.indexPesagens =
                                                                    0;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.lotes =
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .buscarLotes(
                                                                idPropriedade:
                                                                    FFAppState()
                                                                        .propriedadeSelecionada
                                                                        .idPropriedade,
                                                              );
                                                              FFAppState()
                                                                  .rebanhoLotesSelecionar = [];
                                                              safeSetState(
                                                                  () {});
                                                              if (_model.lotes!
                                                                  .isNotEmpty) {
                                                                while (_model
                                                                        .index <
                                                                    _model
                                                                        .lotes!
                                                                        .length) {
                                                                  FFAppState()
                                                                      .addToRebanhoLotesSelecionar(
                                                                          LocalLotesStruct(
                                                                    idLote: _model
                                                                        .lotes
                                                                        ?.elementAtOrNull(
                                                                            _model.index)
                                                                        ?.idLote,
                                                                    nome: _model
                                                                        .lotes
                                                                        ?.elementAtOrNull(
                                                                            _model.index)
                                                                        ?.nome,
                                                                  ));
                                                                  safeSetState(
                                                                      () {});
                                                                  _model.index =
                                                                      _model.index +
                                                                          1;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                              }
                                                              await showDialog(
                                                                barrierColor: Colors
                                                                    .transparent,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (dialogContext) {
                                                                  return Dialog(
                                                                    elevation:
                                                                        0,
                                                                    insetPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    alignment: const AlignmentDirectional(
                                                                            0.0,
                                                                            0.0)
                                                                        .resolve(
                                                                            Directionality.of(context)),
                                                                    child:
                                                                        ViewRebanhoWidget(
                                                                      idRebanho:
                                                                          animaisItem
                                                                              .idRebanho!,
                                                                    ),
                                                                  );
                                                                },
                                                              );

                                                              safeSetState(
                                                                  () {});
                                                            },
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
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
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Group_11_3_(1).png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          if (animaisItem.sexo ==
                                                                              'Macho')
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: Image.asset(
                                                                                'assets/images/Sexomacho.png',
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          if (animaisItem.sexo ==
                                                                              'Fêmea')
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: Image.asset(
                                                                                'assets/images/Sexofemea.png',
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                fit: BoxFit.scaleDown,
                                                                              ),
                                                                            ),
                                                                          if (animaisItem.tipo ==
                                                                              'Nascimento')
                                                                            Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                              child: Container(
                                                                                width: 100.0,
                                                                                height: 24.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(0xFFB1CC29),
                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                ),
                                                                                child: Align(
                                                                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                  child: Text(
                                                                                    'Nascimento',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: Colors.white,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if (animaisItem.tipo ==
                                                                              'Sêmen')
                                                                            Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                              child: Container(
                                                                                width: 100.0,
                                                                                height: 24.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(0xFFB1CC29),
                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                ),
                                                                                child: Align(
                                                                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                  child: Text(
                                                                                    'Sêmen',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: Colors.white,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        '${valueOrDefault<String>(
                                                                          animaisItem
                                                                              .numeroAnimal,
                                                                          '0000',
                                                                        )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                            animaisItem.nome,
                                                                            'S/N',
                                                                          )} • ${dateTimeFormat(
                                                                          "d/M/y",
                                                                          functions
                                                                              .converterParaData(valueOrDefault<String>(
                                                                            animaisItem.dataNascimento,
                                                                            'xx/xx/xxxx',
                                                                          )),
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        )}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: const Color(0xFF474747),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        '${valueOrDefault<String>(
                                                                          animaisItem
                                                                              .categoria,
                                                                          'Sem Categoria',
                                                                        )} • ${valueOrDefault<String>(
                                                                              animaisItem.raca,
                                                                              'Sem raça',
                                                                            ) == 'null' ? 'Sem raça' : valueOrDefault<String>(
                                                                            animaisItem.raca,
                                                                            'Sem raça',
                                                                          )}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children:
                                                                              [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: Image.asset(
                                                                                'assets/images/Lotes4343434.png',
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'Lote: ${valueOrDefault<String>(
                                                                                    animaisItem.loteNome,
                                                                                    'N/A',
                                                                                  ) == 'null' ? 'S/L' : valueOrDefault<String>(
                                                                                  animaisItem.loteNome,
                                                                                  'S/L',
                                                                                )}',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: const Color(0xFF5F5F5F),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ].divide(const SizedBox(width: 4.0)),
                                                                        ),
                                                                      ),
                                                                    ].divide(const SizedBox(
                                                                        height:
                                                                            2.0)),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .visibility_outlined,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .customColor9,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            16.0),
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
                                                                        await _openEditRebanho(
                                                                            context,
                                                                            animaisItem.idRebanho);
                                                                      },
                                                                      child:
                                                                          const Icon(
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
                                                      Divider(
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if ((_model.pesquisarTextController.text == '') &&
                      (FFAppState().ordenacaoRebanho == 'crescente') &&
                      (FFAppState().ordenacaoRebanhoTipo == 'numero')) {
                    return FutureBuilder<List<RebanhoPagOrdNumCresRow>>(
                      key: const ValueKey('ord_num_cres'),
                      future: SQLiteManager.instance.rebanhoPagOrdNumCres(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        limitReb: _model.limit,
                        offsetReb: _model.offset,
                        sexo: FFAppState().filtroSexoRebanho,
                        categoria: FFAppState().filtroCategoriasRebanho,
                        raca: FFAppState().filtroRaca,
                        origem: FFAppState().filtroOrigemRebanho,
                        statusReb: _statusFilterValue(),
                        dataNascInicio: _dataNascInicioFilterValue(),
                        dataNascFim: _dataNascFimFilterValue(),
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
                        final crescenteNumAnimalRebanhoPagOrdNumCresRowList =
                            snapshot.data!;

                        return Container(
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(crescenteNumAnimalRebanhoPagOrdNumCresRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Mask_group.png',
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
                                                      'Nenhum animal foi cadastrado nesta propriedade.',
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
                                        ].divide(const SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (crescenteNumAnimalRebanhoPagOrdNumCresRowList
                                  .isNotEmpty)
                                Padding(
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
                                        final animais =
                                            crescenteNumAnimalRebanhoPagOrdNumCresRowList
                                                .toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(
                                              animais.length, (animaisIndex) {
                                            final animaisItem =
                                                animais[animaisIndex];
                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 24.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                0.0,
                                                                24.0,
                                                                24.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FFAppState().crias =
                                                                [];
                                                            safeSetState(() {});
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            _model.criasFemea2 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoMatriz(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            if (_model.criasFemea2 !=
                                                                    null &&
                                                                (_model.criasFemea2)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasFemea2!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasFemea2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.criasMacho2 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoReprodutor(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            if (_model.criasMacho2 !=
                                                                    null &&
                                                                (_model.criasMacho2)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasMacho2!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasMacho2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.histPesagens2 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscaHistPesagens(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            FFAppState()
                                                                .histPesagens = [];
                                                            safeSetState(() {});
                                                            if (_model.histPesagens2 !=
                                                                    null &&
                                                                (_model.histPesagens2)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexPesagens <
                                                                  _model
                                                                      .histPesagens2!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToHistPesagens(
                                                                        HistoricoPesagensStruct(
                                                                  idRebanho: _model
                                                                      .histPesagens2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.idRebanho,
                                                                  dataPesagem: _model
                                                                      .histPesagens2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.dataPesagem,
                                                                  tipo: _model
                                                                      .histPesagens2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.tipo,
                                                                  deletado: _model
                                                                      .histPesagens2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.deletado,
                                                                  createdAt: _model
                                                                      .histPesagens2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.createdAt,
                                                                  id: _model
                                                                      .histPesagens2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.id,
                                                                  peso: _model
                                                                      .histPesagens2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.peso,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexPesagens =
                                                                    _model.indexPesagens +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexPesagens =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.lotes2 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarLotes(
                                                              idPropriedade:
                                                                  FFAppState()
                                                                      .propriedadeSelecionada
                                                                      .idPropriedade,
                                                            );
                                                            FFAppState()
                                                                .rebanhoLotesSelecionar = [];
                                                            safeSetState(() {});
                                                            if (_model.lotes2!
                                                                .isNotEmpty) {
                                                              while (_model
                                                                      .index <
                                                                  _model.lotes2!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToRebanhoLotesSelecionar(
                                                                        LocalLotesStruct(
                                                                  idLote: _model
                                                                      .lotes2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.idLote,
                                                                  nome: _model
                                                                      .lotes2
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.nome,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.index =
                                                                    _model.index +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                            }
                                                            await showDialog(
                                                              barrierColor: Colors
                                                                  .transparent,
                                                              context: context,
                                                              builder:
                                                                  (dialogContext) {
                                                                return Dialog(
                                                                  elevation: 0,
                                                                  insetPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  alignment: const AlignmentDirectional(
                                                                          0.0,
                                                                          0.0)
                                                                      .resolve(
                                                                          Directionality.of(
                                                                              context)),
                                                                  child:
                                                                      ViewRebanhoWidget(
                                                                    idRebanho:
                                                                        animaisItem
                                                                            .idRebanho!,
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            safeSetState(() {});
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
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
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Group_11_3_(1).png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        if (animaisItem.sexo ==
                                                                            'Macho')
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Sexomacho.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.sexo ==
                                                                            'Fêmea')
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
                                                                        if (animaisItem.tipo ==
                                                                            'Nascimento')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Nascimento',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.tipo ==
                                                                            'Sêmen')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Sêmen',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .numeroAnimal,
                                                                        '0000',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${dateTimeFormat(
                                                                        "d/M/y",
                                                                        functions
                                                                            .converterParaData(valueOrDefault<String>(
                                                                          animaisItem
                                                                              .dataNascimento,
                                                                          'xx/xx/xxxx',
                                                                        )),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                const Color(0xFF474747),
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .categoria,
                                                                        'Sem Categoria',
                                                                      )} • ${valueOrDefault<String>(
                                                                            animaisItem.raca,
                                                                            'Sem raça',
                                                                          ) == 'null' ? 'Sem raça' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .raca,
                                                                          'Sem raça',
                                                                        )}',
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
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Lotes4343434.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Lote: ${valueOrDefault<String>(
                                                                                  animaisItem.loteNome,
                                                                                  'N/A',
                                                                                ) == 'null' ? 'S/L' : valueOrDefault<String>(
                                                                                animaisItem.loteNome,
                                                                                'S/L',
                                                                              )}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: const Color(0xFF5F5F5F),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 4.0)),
                                                                      ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .visibility_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .customColor9,
                                                                    size: 24.0,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          16.0),
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
                                                                      await _openEditRebanho(
                                                                          context,
                                                                          animaisItem
                                                                              .idRebanho);
                                                                    },
                                                                    child:
                                                                        const Icon(
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
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if ((_model.pesquisarTextController.text == '') &&
                      (FFAppState().ordenacaoRebanho == 'decrescente') &&
                      (FFAppState().ordenacaoRebanhoTipo == 'numero')) {
                    return FutureBuilder<List<RebanhoPagOrdNumDescRow>>(
                      key: const ValueKey('ord_num_desc'),
                      future: SQLiteManager.instance.rebanhoPagOrdNumDesc(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        limitReb: _model.limit,
                        offsetReb: _model.offset,
                        sexo: FFAppState().filtroSexoRebanho,
                        categoria: FFAppState().filtroCategoriasRebanho,
                        raca: FFAppState().filtroRaca,
                        origem: FFAppState().filtroOrigemRebanho,
                        statusReb: _statusFilterValue(),
                        dataNascInicio: _dataNascInicioFilterValue(),
                        dataNascFim: _dataNascFimFilterValue(),
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
                        final decrescenteNumAnimalRebanhoPagOrdNumDescRowList =
                            snapshot.data!;

                        return Container(
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(decrescenteNumAnimalRebanhoPagOrdNumDescRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Mask_group.png',
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
                                                      'Nenhum animal foi cadastrado nesta propriedade.',
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
                                        ].divide(const SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (decrescenteNumAnimalRebanhoPagOrdNumDescRowList
                                  .isNotEmpty)
                                Padding(
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
                                        final animais =
                                            decrescenteNumAnimalRebanhoPagOrdNumDescRowList
                                                .toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(
                                              animais.length, (animaisIndex) {
                                            final animaisItem =
                                                animais[animaisIndex];
                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 24.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                0.0,
                                                                24.0,
                                                                24.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FFAppState().crias =
                                                                [];
                                                            safeSetState(() {});
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            _model.criasFemea3 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoMatriz(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            if (_model.criasFemea3 !=
                                                                    null &&
                                                                (_model.criasFemea3)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasFemea3!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasFemea3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.criasMacho3 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoReprodutor(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            if (_model.criasMacho3 !=
                                                                    null &&
                                                                (_model.criasMacho3)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasMacho3!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasMacho3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.histPesagens3 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscaHistPesagens(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            FFAppState()
                                                                .histPesagens = [];
                                                            safeSetState(() {});
                                                            if (_model.histPesagens3 !=
                                                                    null &&
                                                                (_model.histPesagens3)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexPesagens <
                                                                  _model
                                                                      .histPesagens3!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToHistPesagens(
                                                                        HistoricoPesagensStruct(
                                                                  idRebanho: _model
                                                                      .histPesagens3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.idRebanho,
                                                                  dataPesagem: _model
                                                                      .histPesagens3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.dataPesagem,
                                                                  tipo: _model
                                                                      .histPesagens3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.tipo,
                                                                  deletado: _model
                                                                      .histPesagens3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.deletado,
                                                                  createdAt: _model
                                                                      .histPesagens3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.createdAt,
                                                                  id: _model
                                                                      .histPesagens3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.id,
                                                                  peso: _model
                                                                      .histPesagens3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.peso,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexPesagens =
                                                                    _model.indexPesagens +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexPesagens =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.lotes3 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarLotes(
                                                              idPropriedade:
                                                                  FFAppState()
                                                                      .propriedadeSelecionada
                                                                      .idPropriedade,
                                                            );
                                                            FFAppState()
                                                                .rebanhoLotesSelecionar = [];
                                                            safeSetState(() {});
                                                            if (_model.lotes3!
                                                                .isNotEmpty) {
                                                              while (_model
                                                                      .index <
                                                                  _model.lotes3!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToRebanhoLotesSelecionar(
                                                                        LocalLotesStruct(
                                                                  idLote: _model
                                                                      .lotes3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.idLote,
                                                                  nome: _model
                                                                      .lotes3
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.nome,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.index =
                                                                    _model.index +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                            }
                                                            await showDialog(
                                                              barrierColor: Colors
                                                                  .transparent,
                                                              context: context,
                                                              builder:
                                                                  (dialogContext) {
                                                                return Dialog(
                                                                  elevation: 0,
                                                                  insetPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  alignment: const AlignmentDirectional(
                                                                          0.0,
                                                                          0.0)
                                                                      .resolve(
                                                                          Directionality.of(
                                                                              context)),
                                                                  child:
                                                                      ViewRebanhoWidget(
                                                                    idRebanho:
                                                                        animaisItem
                                                                            .idRebanho!,
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            safeSetState(() {});
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
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
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Group_11_3_(1).png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        if (animaisItem.sexo ==
                                                                            'Macho')
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Sexomacho.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.sexo ==
                                                                            'Fêmea')
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
                                                                        if (animaisItem.tipo ==
                                                                            'Nascimento')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Nascimento',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.tipo ==
                                                                            'Sêmen')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Sêmen',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .numeroAnimal,
                                                                        '0000',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${dateTimeFormat(
                                                                        "d/M/y",
                                                                        functions
                                                                            .converterParaData(valueOrDefault<String>(
                                                                          animaisItem
                                                                              .dataNascimento,
                                                                          'xx/xx/xxxx',
                                                                        )),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                const Color(0xFF474747),
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .categoria,
                                                                        'Sem Categoria',
                                                                      )} • ${valueOrDefault<String>(
                                                                            animaisItem.raca,
                                                                            'Sem raça',
                                                                          ) == 'null' ? 'Sem raça' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .raca,
                                                                          'Sem raça',
                                                                        )}',
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
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Lotes4343434.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Lote: ${valueOrDefault<String>(
                                                                                  animaisItem.loteNome,
                                                                                  'N/A',
                                                                                ) == 'null' ? 'S/L' : valueOrDefault<String>(
                                                                                animaisItem.loteNome,
                                                                                'S/L',
                                                                              )}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: const Color(0xFF5F5F5F),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 4.0)),
                                                                      ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .visibility_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .customColor9,
                                                                    size: 24.0,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          16.0),
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
                                                                      await _openEditRebanho(
                                                                          context,
                                                                          animaisItem
                                                                              .idRebanho);
                                                                    },
                                                                    child:
                                                                        const Icon(
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
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if ((_model.pesquisarTextController.text == '') &&
                      (FFAppState().ordenacaoRebanho == 'crescente') &&
                      (FFAppState().ordenacaoRebanhoTipo == 'nome')) {
                    return FutureBuilder<List<RebanhoPagOrdNomCresRow>>(
                      key: const ValueKey('ord_nom_cres'),
                      future: SQLiteManager.instance.rebanhoPagOrdNomCres(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        limitReb: _model.limit,
                        offsetReb: _model.offset,
                        sexo: FFAppState().filtroSexoRebanho,
                        categoria: FFAppState().filtroCategoriasRebanho,
                        raca: FFAppState().filtroRaca,
                        origem: FFAppState().filtroOrigemRebanho,
                        statusReb: _statusFilterValue(),
                        dataNascInicio: _dataNascInicioFilterValue(),
                        dataNascFim: _dataNascFimFilterValue(),
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
                        final crescenteNomeAnimalRebanhoPagOrdNomCresRowList =
                            snapshot.data!;

                        return Container(
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(crescenteNomeAnimalRebanhoPagOrdNomCresRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Mask_group.png',
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
                                                      'Nenhum animal foi cadastrado nesta propriedade.',
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
                                        ].divide(const SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (crescenteNomeAnimalRebanhoPagOrdNomCresRowList
                                  .isNotEmpty)
                                Padding(
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
                                        final animais =
                                            crescenteNomeAnimalRebanhoPagOrdNomCresRowList
                                                .toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(
                                              animais.length, (animaisIndex) {
                                            final animaisItem =
                                                animais[animaisIndex];
                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 24.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                0.0,
                                                                24.0,
                                                                24.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FFAppState().crias =
                                                                [];
                                                            safeSetState(() {});
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            _model.criasFemea4 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoMatriz(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            if (_model.criasFemea4 !=
                                                                    null &&
                                                                (_model.criasFemea4)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasFemea4!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasFemea4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.criasMacho4 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoReprodutor(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            if (_model.criasMacho4 !=
                                                                    null &&
                                                                (_model.criasMacho4)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasMacho4!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasMacho4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.histPesagens4 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscaHistPesagens(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            FFAppState()
                                                                .histPesagens = [];
                                                            safeSetState(() {});
                                                            if (_model.histPesagens4 !=
                                                                    null &&
                                                                (_model.histPesagens4)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexPesagens <
                                                                  _model
                                                                      .histPesagens4!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToHistPesagens(
                                                                        HistoricoPesagensStruct(
                                                                  idRebanho: _model
                                                                      .histPesagens4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.idRebanho,
                                                                  dataPesagem: _model
                                                                      .histPesagens4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.dataPesagem,
                                                                  tipo: _model
                                                                      .histPesagens4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.tipo,
                                                                  deletado: _model
                                                                      .histPesagens4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.deletado,
                                                                  createdAt: _model
                                                                      .histPesagens4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.createdAt,
                                                                  id: _model
                                                                      .histPesagens4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.id,
                                                                  peso: _model
                                                                      .histPesagens4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.peso,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexPesagens =
                                                                    _model.indexPesagens +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexPesagens =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.lotes4 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarLotes(
                                                              idPropriedade:
                                                                  FFAppState()
                                                                      .propriedadeSelecionada
                                                                      .idPropriedade,
                                                            );
                                                            FFAppState()
                                                                .rebanhoLotesSelecionar = [];
                                                            safeSetState(() {});
                                                            if (_model.lotes4!
                                                                .isNotEmpty) {
                                                              while (_model
                                                                      .index <
                                                                  _model.lotes4!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToRebanhoLotesSelecionar(
                                                                        LocalLotesStruct(
                                                                  idLote: _model
                                                                      .lotes4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.idLote,
                                                                  nome: _model
                                                                      .lotes4
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.nome,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.index =
                                                                    _model.index +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                            }
                                                            await showDialog(
                                                              barrierColor: Colors
                                                                  .transparent,
                                                              context: context,
                                                              builder:
                                                                  (dialogContext) {
                                                                return Dialog(
                                                                  elevation: 0,
                                                                  insetPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  alignment: const AlignmentDirectional(
                                                                          0.0,
                                                                          0.0)
                                                                      .resolve(
                                                                          Directionality.of(
                                                                              context)),
                                                                  child:
                                                                      ViewRebanhoWidget(
                                                                    idRebanho:
                                                                        animaisItem
                                                                            .idRebanho!,
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            safeSetState(() {});
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
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
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Group_11_3_(1).png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        if (animaisItem.sexo ==
                                                                            'Macho')
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Sexomacho.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.sexo ==
                                                                            'Fêmea')
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
                                                                        if (animaisItem.tipo ==
                                                                            'Nascimento')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Nascimento',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.tipo ==
                                                                            'Sêmen')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Sêmen',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .numeroAnimal,
                                                                        '0000',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${dateTimeFormat(
                                                                        "d/M/y",
                                                                        functions
                                                                            .converterParaData(valueOrDefault<String>(
                                                                          animaisItem
                                                                              .dataNascimento,
                                                                          'xx/xx/xxxx',
                                                                        )),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                const Color(0xFF474747),
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .categoria,
                                                                        'Sem Categoria',
                                                                      )} • ${valueOrDefault<String>(
                                                                            animaisItem.raca,
                                                                            'Sem raça',
                                                                          ) == 'null' ? 'Sem raça' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .raca,
                                                                          'Sem raça',
                                                                        )}',
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
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Lotes4343434.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Lote: ${valueOrDefault<String>(
                                                                                  animaisItem.loteNome,
                                                                                  'N/A',
                                                                                ) == 'null' ? 'S/L' : valueOrDefault<String>(
                                                                                animaisItem.loteNome,
                                                                                'S/L',
                                                                              )}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: const Color(0xFF5F5F5F),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 4.0)),
                                                                      ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .visibility_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .customColor9,
                                                                    size: 24.0,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          16.0),
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
                                                                      await _openEditRebanho(
                                                                          context,
                                                                          animaisItem
                                                                              .idRebanho);
                                                                    },
                                                                    child:
                                                                        const Icon(
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
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if ((_model.pesquisarTextController.text == '') &&
                      (FFAppState().ordenacaoRebanho == 'decrescente') &&
                      (FFAppState().ordenacaoRebanhoTipo == 'nome')) {
                    return FutureBuilder<List<RebanhoPagOrdNomDescRow>>(
                      key: const ValueKey('ord_nom_desc'),
                      future: SQLiteManager.instance.rebanhoPagOrdNomDesc(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        limitReb: _model.limit,
                        offsetReb: _model.offset,
                        sexo: FFAppState().filtroSexoRebanho,
                        categoria: FFAppState().filtroCategoriasRebanho,
                        raca: FFAppState().filtroRaca,
                        origem: FFAppState().filtroOrigemRebanho,
                        statusReb: _statusFilterValue(),
                        dataNascInicio: _dataNascInicioFilterValue(),
                        dataNascFim: _dataNascFimFilterValue(),
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
                        final decrescenteNomeAnimalRebanhoPagOrdNomDescRowList =
                            snapshot.data!;

                        return Container(
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(decrescenteNomeAnimalRebanhoPagOrdNomDescRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Mask_group.png',
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
                                                      'Nenhum animal foi cadastrado nesta propriedade.',
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
                                        ].divide(const SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (decrescenteNomeAnimalRebanhoPagOrdNomDescRowList
                                  .isNotEmpty)
                                Padding(
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
                                        final animais =
                                            decrescenteNomeAnimalRebanhoPagOrdNomDescRowList
                                                .toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(
                                              animais.length, (animaisIndex) {
                                            final animaisItem =
                                                animais[animaisIndex];
                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 24.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                0.0,
                                                                24.0,
                                                                24.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FFAppState().crias =
                                                                [];
                                                            safeSetState(() {});
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            _model.criasFemea5 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoMatriz(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            if (_model.criasFemea5 !=
                                                                    null &&
                                                                (_model.criasFemea5)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasFemea5!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasFemea5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.criasMacho5 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoReprodutor(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            if (_model.criasMacho5 !=
                                                                    null &&
                                                                (_model.criasMacho5)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasMacho5!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasMacho5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.histPesagens5 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscaHistPesagens(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            FFAppState()
                                                                .histPesagens = [];
                                                            safeSetState(() {});
                                                            if (_model.histPesagens5 !=
                                                                    null &&
                                                                (_model.histPesagens5)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexPesagens <
                                                                  _model
                                                                      .histPesagens5!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToHistPesagens(
                                                                        HistoricoPesagensStruct(
                                                                  idRebanho: _model
                                                                      .histPesagens5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.idRebanho,
                                                                  dataPesagem: _model
                                                                      .histPesagens5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.dataPesagem,
                                                                  tipo: _model
                                                                      .histPesagens5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.tipo,
                                                                  deletado: _model
                                                                      .histPesagens5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.deletado,
                                                                  createdAt: _model
                                                                      .histPesagens5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.createdAt,
                                                                  id: _model
                                                                      .histPesagens5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.id,
                                                                  peso: _model
                                                                      .histPesagens5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.peso,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexPesagens =
                                                                    _model.indexPesagens +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexPesagens =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.lotes5 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarLotes(
                                                              idPropriedade:
                                                                  FFAppState()
                                                                      .propriedadeSelecionada
                                                                      .idPropriedade,
                                                            );
                                                            FFAppState()
                                                                .rebanhoLotesSelecionar = [];
                                                            safeSetState(() {});
                                                            if (_model.lotes5!
                                                                .isNotEmpty) {
                                                              while (_model
                                                                      .index <
                                                                  _model.lotes5!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToRebanhoLotesSelecionar(
                                                                        LocalLotesStruct(
                                                                  idLote: _model
                                                                      .lotes5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.idLote,
                                                                  nome: _model
                                                                      .lotes5
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.nome,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.index =
                                                                    _model.index +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                            }
                                                            await showDialog(
                                                              barrierColor: Colors
                                                                  .transparent,
                                                              context: context,
                                                              builder:
                                                                  (dialogContext) {
                                                                return Dialog(
                                                                  elevation: 0,
                                                                  insetPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  alignment: const AlignmentDirectional(
                                                                          0.0,
                                                                          0.0)
                                                                      .resolve(
                                                                          Directionality.of(
                                                                              context)),
                                                                  child:
                                                                      ViewRebanhoWidget(
                                                                    idRebanho:
                                                                        animaisItem
                                                                            .idRebanho!,
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            safeSetState(() {});
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
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
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Group_11_3_(1).png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        if (animaisItem.sexo ==
                                                                            'Macho')
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Sexomacho.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.sexo ==
                                                                            'Fêmea')
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
                                                                        if (animaisItem.tipo ==
                                                                            'Nascimento')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Nascimento',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.tipo ==
                                                                            'Sêmen')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Sêmen',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .numeroAnimal,
                                                                        '0000',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${dateTimeFormat(
                                                                        "d/M/y",
                                                                        functions
                                                                            .converterParaData(valueOrDefault<String>(
                                                                          animaisItem
                                                                              .dataNascimento,
                                                                          'xx/xx/xxxx',
                                                                        )),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                const Color(0xFF474747),
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .categoria,
                                                                        'Sem Categoria',
                                                                      )} • ${valueOrDefault<String>(
                                                                            animaisItem.raca,
                                                                            'Sem raça',
                                                                          ) == 'null' ? 'Sem raça' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .raca,
                                                                          'Sem raça',
                                                                        )}',
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
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Lotes4343434.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Lote: ${valueOrDefault<String>(
                                                                                  animaisItem.loteNome,
                                                                                  'N/A',
                                                                                ) == 'null' ? 'S/L' : valueOrDefault<String>(
                                                                                animaisItem.loteNome,
                                                                                'S/L',
                                                                              )}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: const Color(0xFF5F5F5F),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 4.0)),
                                                                      ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .visibility_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .customColor9,
                                                                    size: 24.0,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          16.0),
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
                                                                      await _openEditRebanho(
                                                                          context,
                                                                          animaisItem
                                                                              .idRebanho);
                                                                    },
                                                                    child:
                                                                        const Icon(
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
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if ((_model.pesquisarTextController.text == '') &&
                      (FFAppState().ordenacaoRebanho == 'crescente') &&
                      (FFAppState().ordenacaoRebanhoTipo == 'nascimento')) {
                    return FutureBuilder<List<RebanhoPagOrdDataCresRow>>(
                      key: const ValueKey('ord_data_cres'),
                      future: SQLiteManager.instance.rebanhoPagOrdDataCres(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        limitReb: _model.limit,
                        offsetReb: _model.offset,
                        sexo: FFAppState().filtroSexoRebanho,
                        categoria: FFAppState().filtroCategoriasRebanho,
                        raca: FFAppState().filtroRaca,
                        origem: FFAppState().filtroOrigemRebanho,
                        statusReb: _statusFilterValue(),
                        dataNascInicio: _dataNascInicioFilterValue(),
                        dataNascFim: _dataNascFimFilterValue(),
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
                        final crescenteDataNascRebanhoPagOrdDataCresRowList =
                            snapshot.data!;

                        return Container(
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(crescenteDataNascRebanhoPagOrdDataCresRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Mask_group.png',
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
                                                      'Nenhum animal foi cadastrado nesta propriedade.',
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
                                        ].divide(const SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (crescenteDataNascRebanhoPagOrdDataCresRowList
                                  .isNotEmpty)
                                Padding(
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
                                        final animais =
                                            crescenteDataNascRebanhoPagOrdDataCresRowList
                                                .toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(
                                              animais.length, (animaisIndex) {
                                            final animaisItem =
                                                animais[animaisIndex];
                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 24.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                0.0,
                                                                24.0,
                                                                24.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FFAppState().crias =
                                                                [];
                                                            safeSetState(() {});
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            _model.criasFemea6 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoMatriz(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            if (_model.criasFemea6 !=
                                                                    null &&
                                                                (_model.criasFemea6)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasFemea6!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasFemea6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.criasMacho6 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoReprodutor(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            if (_model.criasMacho6 !=
                                                                    null &&
                                                                (_model.criasMacho6)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasMacho6!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasMacho6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.histPesagens6 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscaHistPesagens(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            FFAppState()
                                                                .histPesagens = [];
                                                            safeSetState(() {});
                                                            if (_model.histPesagens6 !=
                                                                    null &&
                                                                (_model.histPesagens6)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexPesagens <
                                                                  _model
                                                                      .histPesagens6!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToHistPesagens(
                                                                        HistoricoPesagensStruct(
                                                                  idRebanho: _model
                                                                      .histPesagens6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.idRebanho,
                                                                  dataPesagem: _model
                                                                      .histPesagens6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.dataPesagem,
                                                                  tipo: _model
                                                                      .histPesagens6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.tipo,
                                                                  deletado: _model
                                                                      .histPesagens6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.deletado,
                                                                  createdAt: _model
                                                                      .histPesagens6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.createdAt,
                                                                  id: _model
                                                                      .histPesagens6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.id,
                                                                  peso: _model
                                                                      .histPesagens6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.peso,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexPesagens =
                                                                    _model.indexPesagens +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexPesagens =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.lotes6 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarLotes(
                                                              idPropriedade:
                                                                  FFAppState()
                                                                      .propriedadeSelecionada
                                                                      .idPropriedade,
                                                            );
                                                            FFAppState()
                                                                .rebanhoLotesSelecionar = [];
                                                            safeSetState(() {});
                                                            if (_model.lotes6!
                                                                .isNotEmpty) {
                                                              while (_model
                                                                      .index <
                                                                  _model.lotes6!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToRebanhoLotesSelecionar(
                                                                        LocalLotesStruct(
                                                                  idLote: _model
                                                                      .lotes6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.idLote,
                                                                  nome: _model
                                                                      .lotes6
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.nome,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.index =
                                                                    _model.index +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                            }
                                                            await showDialog(
                                                              barrierColor: Colors
                                                                  .transparent,
                                                              context: context,
                                                              builder:
                                                                  (dialogContext) {
                                                                return Dialog(
                                                                  elevation: 0,
                                                                  insetPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  alignment: const AlignmentDirectional(
                                                                          0.0,
                                                                          0.0)
                                                                      .resolve(
                                                                          Directionality.of(
                                                                              context)),
                                                                  child:
                                                                      ViewRebanhoWidget(
                                                                    idRebanho:
                                                                        animaisItem
                                                                            .idRebanho!,
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            safeSetState(() {});
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
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
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Group_11_3_(1).png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        if (animaisItem.sexo ==
                                                                            'Macho')
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Sexomacho.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.sexo ==
                                                                            'Fêmea')
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
                                                                        if (animaisItem.tipo ==
                                                                            'Nascimento')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Nascimento',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.tipo ==
                                                                            'Sêmen')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Sêmen',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .numeroAnimal,
                                                                        '0000',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${dateTimeFormat(
                                                                        "d/M/y",
                                                                        functions
                                                                            .converterParaData(valueOrDefault<String>(
                                                                          animaisItem
                                                                              .dataNascimento,
                                                                          'xx/xx/xxxx',
                                                                        )),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                const Color(0xFF474747),
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .categoria,
                                                                        'Sem Categoria',
                                                                      )} • ${valueOrDefault<String>(
                                                                            animaisItem.raca,
                                                                            'Sem raça',
                                                                          ) == 'null' ? 'Sem raça' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .raca,
                                                                          'Sem raça',
                                                                        )}',
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
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Lotes4343434.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Lote: ${valueOrDefault<String>(
                                                                                  animaisItem.loteNome,
                                                                                  'N/A',
                                                                                ) == 'null' ? 'S/L' : valueOrDefault<String>(
                                                                                animaisItem.loteNome,
                                                                                'S/L',
                                                                              )}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: const Color(0xFF5F5F5F),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 4.0)),
                                                                      ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .visibility_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .customColor9,
                                                                    size: 24.0,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          16.0),
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
                                                                      await _openEditRebanho(
                                                                          context,
                                                                          animaisItem
                                                                              .idRebanho);
                                                                    },
                                                                    child:
                                                                        const Icon(
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
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if ((_model.pesquisarTextController.text == '') &&
                      (FFAppState().ordenacaoRebanho == 'decrescente') &&
                      (FFAppState().ordenacaoRebanhoTipo == 'nascimento')) {
                    return FutureBuilder<List<RebanhoPagOrdDataDescRow>>(
                      key: const ValueKey('ord_data_desc'),
                      future: SQLiteManager.instance.rebanhoPagOrdDataDesc(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        limitReb: _model.limit,
                        offsetReb: _model.offset,
                        sexo: FFAppState().filtroSexoRebanho,
                        categoria: FFAppState().filtroCategoriasRebanho,
                        raca: FFAppState().filtroRaca,
                        origem: FFAppState().filtroOrigemRebanho,
                        statusReb: _statusFilterValue(),
                        dataNascInicio: _dataNascInicioFilterValue(),
                        dataNascFim: _dataNascFimFilterValue(),
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
                        final decrescenteDataNascRebanhoPagOrdDataDescRowList =
                            snapshot.data!;

                        return Container(
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(decrescenteDataNascRebanhoPagOrdDataDescRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Mask_group.png',
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
                                                      'Nenhum animal foi cadastrado nesta propriedade.',
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
                                        ].divide(const SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (decrescenteDataNascRebanhoPagOrdDataDescRowList
                                  .isNotEmpty)
                                Padding(
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
                                        final animais =
                                            decrescenteDataNascRebanhoPagOrdDataDescRowList
                                                .toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(
                                              animais.length, (animaisIndex) {
                                            final animaisItem =
                                                animais[animaisIndex];
                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 24.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                0.0,
                                                                24.0,
                                                                24.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FFAppState().crias =
                                                                [];
                                                            safeSetState(() {});
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            _model.criasFemea7 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoMatriz(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            if (_model.criasFemea7 !=
                                                                    null &&
                                                                (_model.criasFemea7)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasFemea7!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasFemea7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.criasMacho7 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarCriasRebanhoReprodutor(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                            if (_model.criasMacho7 !=
                                                                    null &&
                                                                (_model.criasMacho7)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexCrias <
                                                                  _model
                                                                      .criasMacho7!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToCrias(
                                                                        AnimaisStruct(
                                                                  idRebanho: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.idRebanho,
                                                                  sexo: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.sexo,
                                                                  numeroAnimal: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroAnimal,
                                                                  nome: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nome,
                                                                  dataNascimento: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascimento,
                                                                  categoria: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.categoria,
                                                                  raca: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.raca,
                                                                  loteNome: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.loteNome,
                                                                  rebanhoIdMatriz: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdMatriz,
                                                                  rebanhoIdReprodutor: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.rebanhoIdReprodutor,
                                                                  numeroMatriz: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroMatriz,
                                                                  nomeMatriz: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeMatriz,
                                                                  dataNascMatriz: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascMatriz,
                                                                  racaMatriz: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaMatriz,
                                                                  numeroReprodutor: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.numeroReprodutor,
                                                                  nomeReprodutor: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.nomeReprodutor,
                                                                  dataNascReprodutor: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.dataNascReprodutor,
                                                                  racaReprodutor: _model
                                                                      .criasMacho7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexCrias)
                                                                      ?.racaReprodutor,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexCrias =
                                                                    _model.indexCrias +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexCrias =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.histPesagens7 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscaHistPesagens(
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                            );
                                                            FFAppState()
                                                                .histPesagens = [];
                                                            safeSetState(() {});
                                                            if (_model.histPesagens7 !=
                                                                    null &&
                                                                (_model.histPesagens7)!
                                                                    .isNotEmpty) {
                                                              while (_model
                                                                      .indexPesagens <
                                                                  _model
                                                                      .histPesagens7!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToHistPesagens(
                                                                        HistoricoPesagensStruct(
                                                                  idRebanho: _model
                                                                      .histPesagens7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.idRebanho,
                                                                  dataPesagem: _model
                                                                      .histPesagens7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.dataPesagem,
                                                                  tipo: _model
                                                                      .histPesagens7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.tipo,
                                                                  deletado: _model
                                                                      .histPesagens7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.deletado,
                                                                  createdAt: _model
                                                                      .histPesagens7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.createdAt,
                                                                  id: _model
                                                                      .histPesagens7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.id,
                                                                  peso: _model
                                                                      .histPesagens7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .indexPesagens)
                                                                      ?.peso,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.indexPesagens =
                                                                    _model.indexPesagens +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                              _model.indexPesagens =
                                                                  0;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.lotes7 =
                                                                await SQLiteManager
                                                                    .instance
                                                                    .buscarLotes(
                                                              idPropriedade:
                                                                  FFAppState()
                                                                      .propriedadeSelecionada
                                                                      .idPropriedade,
                                                            );
                                                            FFAppState()
                                                                .rebanhoLotesSelecionar = [];
                                                            safeSetState(() {});
                                                            if (_model.lotes7!
                                                                .isNotEmpty) {
                                                              while (_model
                                                                      .index <
                                                                  _model.lotes7!
                                                                      .length) {
                                                                FFAppState()
                                                                    .addToRebanhoLotesSelecionar(
                                                                        LocalLotesStruct(
                                                                  idLote: _model
                                                                      .lotes7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.idLote,
                                                                  nome: _model
                                                                      .lotes7
                                                                      ?.elementAtOrNull(
                                                                          _model
                                                                              .index)
                                                                      ?.nome,
                                                                ));
                                                                safeSetState(
                                                                    () {});
                                                                _model.index =
                                                                    _model.index +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              }
                                                            }
                                                            await showDialog(
                                                              barrierColor: Colors
                                                                  .transparent,
                                                              context: context,
                                                              builder:
                                                                  (dialogContext) {
                                                                return Dialog(
                                                                  elevation: 0,
                                                                  insetPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  alignment: const AlignmentDirectional(
                                                                          0.0,
                                                                          0.0)
                                                                      .resolve(
                                                                          Directionality.of(
                                                                              context)),
                                                                  child:
                                                                      ViewRebanhoWidget(
                                                                    idRebanho:
                                                                        animaisItem
                                                                            .idRebanho!,
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            safeSetState(() {});
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
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
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Group_11_3_(1).png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        if (animaisItem.sexo ==
                                                                            'Macho')
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Sexomacho.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.sexo ==
                                                                            'Fêmea')
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
                                                                        if (animaisItem.tipo ==
                                                                            'Nascimento')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Nascimento',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        if (animaisItem.tipo ==
                                                                            'Sêmen')
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 100.0,
                                                                              height: 24.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFB1CC29),
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Sêmen',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .numeroAnimal,
                                                                        '0000',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${dateTimeFormat(
                                                                        "d/M/y",
                                                                        functions
                                                                            .converterParaData(valueOrDefault<String>(
                                                                          animaisItem
                                                                              .dataNascimento,
                                                                          'xx/xx/xxxx',
                                                                        )),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color:
                                                                                const Color(0xFF474747),
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        animaisItem
                                                                            .categoria,
                                                                        'Sem Categoria',
                                                                      )} • ${valueOrDefault<String>(
                                                                            animaisItem.raca,
                                                                            'Sem raça',
                                                                          ) == 'null' ? 'Sem raça' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .raca,
                                                                          'Sem raça',
                                                                        )}',
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
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/Lotes4343434.png',
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Lote: ${valueOrDefault<String>(
                                                                                  animaisItem.loteNome,
                                                                                  'N/A',
                                                                                ) == 'null' ? 'S/L' : valueOrDefault<String>(
                                                                                animaisItem.loteNome,
                                                                                'S/L',
                                                                              )}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: const Color(0xFF5F5F5F),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 4.0)),
                                                                      ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .visibility_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .customColor9,
                                                                    size: 24.0,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          16.0),
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
                                                                      await _openEditRebanho(
                                                                          context,
                                                                          animaisItem
                                                                              .idRebanho);
                                                                    },
                                                                    child:
                                                                        const Icon(
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
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return FutureBuilder<List<BuscaRebanhoPaginadaPesquisaRow>>(
                      key: const ValueKey('pesquisa'),
                      future:
                          SQLiteManager.instance.buscaRebanhoPaginadaPesquisa(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        sexo: FFAppState().filtroSexoRebanho,
                        categoria: FFAppState().filtroCategoriasRebanho,
                        raca: FFAppState().filtroRaca,
                        origem: FFAppState().filtroOrigemRebanho,
                        loteId: FFAppState().filtroLoteRebanho,
                        pesquisa: _model.pesquisarTextController.text,
                        statusReb: _statusFilterValue(),
                        dataNascInicio: _dataNascInicioFilterValue(),
                        dataNascFim: _dataNascFimFilterValue(),
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
                        final containerPesquisaPadraoSemOrdBuscaRebanhoPaginadaPesquisaRowList =
                            snapshot.data!;

                        return Container(
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(containerPesquisaPadraoSemOrdBuscaRebanhoPaginadaPesquisaRowList
                                  .isNotEmpty))
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              32.0, 32.0, 32.0, 32.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Mask_group.png',
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
                                                      'Nenhum animal foi cadastrado nesta propriedade.',
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
                                        ].divide(const SizedBox(height: 24.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
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
                                      final animais =
                                          containerPesquisaPadraoSemOrdBuscaRebanhoPaginadaPesquisaRowList
                                              .toList();

                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: List.generate(animais.length,
                                            (animaisIndex) {
                                          final animaisItem =
                                              animais[animaisIndex];
                                          return Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 24.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Builder(
                                                    builder: (context) =>
                                                        Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(24.0,
                                                              0.0, 24.0, 24.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          FFAppState().crias =
                                                              [];
                                                          safeSetState(() {});
                                                          _model.indexCrias = 0;
                                                          safeSetState(() {});
                                                          _model.criasFemeaPesq =
                                                              await SQLiteManager
                                                                  .instance
                                                                  .buscarCriasRebanhoMatriz(
                                                            idRebanho:
                                                                animaisItem
                                                                    .idRebanho,
                                                          );
                                                          if (_model.criasFemeaPesq !=
                                                                  null &&
                                                              (_model.criasFemeaPesq)!
                                                                  .isNotEmpty) {
                                                            while (_model
                                                                    .indexCrias <
                                                                _model
                                                                    .criasFemeaPesq!
                                                                    .length) {
                                                              FFAppState()
                                                                  .addToCrias(
                                                                      AnimaisStruct(
                                                                idRebanho: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.idRebanho,
                                                                sexo: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.sexo,
                                                                numeroAnimal: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.numeroAnimal,
                                                                nome: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.nome,
                                                                dataNascimento: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.dataNascimento,
                                                                categoria: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.categoria,
                                                                raca: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.raca,
                                                                loteNome: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.loteNome,
                                                                rebanhoIdMatriz: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.rebanhoIdMatriz,
                                                                rebanhoIdReprodutor: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.rebanhoIdReprodutor,
                                                                numeroMatriz: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.numeroMatriz,
                                                                nomeMatriz: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.nomeMatriz,
                                                                dataNascMatriz: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.dataNascMatriz,
                                                                racaMatriz: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.racaMatriz,
                                                                numeroReprodutor: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.numeroReprodutor,
                                                                nomeReprodutor: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.nomeReprodutor,
                                                                dataNascReprodutor: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.dataNascReprodutor,
                                                                racaReprodutor: _model
                                                                    .criasFemeaPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.racaReprodutor,
                                                              ));
                                                              safeSetState(
                                                                  () {});
                                                              _model.indexCrias =
                                                                  _model.indexCrias +
                                                                      1;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                          }
                                                          _model.criasMachoPesq =
                                                              await SQLiteManager
                                                                  .instance
                                                                  .buscarCriasRebanhoReprodutor(
                                                            idRebanho:
                                                                animaisItem
                                                                    .idRebanho,
                                                          );
                                                          _model.indexCrias = 0;
                                                          safeSetState(() {});
                                                          if (_model.criasMachoPesq !=
                                                                  null &&
                                                              (_model.criasMachoPesq)!
                                                                  .isNotEmpty) {
                                                            while (_model
                                                                    .indexCrias <
                                                                _model
                                                                    .criasMachoPesq!
                                                                    .length) {
                                                              FFAppState()
                                                                  .addToCrias(
                                                                      AnimaisStruct(
                                                                idRebanho: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.idRebanho,
                                                                sexo: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.sexo,
                                                                numeroAnimal: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.numeroAnimal,
                                                                nome: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.sexo,
                                                                dataNascimento: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.dataNascimento,
                                                                categoria: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.categoria,
                                                                raca: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.raca,
                                                                loteNome: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.loteNome,
                                                                rebanhoIdMatriz: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.rebanhoIdMatriz,
                                                                rebanhoIdReprodutor: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.rebanhoIdReprodutor,
                                                                numeroMatriz: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.numeroMatriz,
                                                                nomeMatriz: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.nomeMatriz,
                                                                dataNascMatriz: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.dataNascMatriz,
                                                                racaMatriz: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.racaMatriz,
                                                                numeroReprodutor: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.numeroReprodutor,
                                                                nomeReprodutor: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.nomeReprodutor,
                                                                dataNascReprodutor: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.dataNascReprodutor,
                                                                racaReprodutor: _model
                                                                    .criasMachoPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexCrias)
                                                                    ?.racaReprodutor,
                                                              ));
                                                              safeSetState(
                                                                  () {});
                                                              _model.indexCrias =
                                                                  _model.indexCrias +
                                                                      1;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.indexCrias =
                                                                0;
                                                            safeSetState(() {});
                                                          }
                                                          _model.histPesagensPesq =
                                                              await SQLiteManager
                                                                  .instance
                                                                  .buscaHistPesagens(
                                                            idRebanho:
                                                                animaisItem
                                                                    .idRebanho,
                                                          );
                                                          FFAppState()
                                                              .histPesagens = [];
                                                          safeSetState(() {});
                                                          FFAppState()
                                                              .indexPesagens = 0;
                                                          safeSetState(() {});
                                                          if (_model.histPesagensPesq !=
                                                                  null &&
                                                              (_model.histPesagensPesq)!
                                                                  .isNotEmpty) {
                                                            while (_model
                                                                    .indexPesagens <
                                                                _model
                                                                    .histPesagensPesq!
                                                                    .length) {
                                                              FFAppState()
                                                                  .addToHistPesagens(
                                                                      HistoricoPesagensStruct(
                                                                idRebanho: _model
                                                                    .histPesagensPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexPesagens)
                                                                    ?.idRebanho,
                                                                dataPesagem: _model
                                                                    .histPesagensPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexPesagens)
                                                                    ?.dataPesagem,
                                                                tipo: _model
                                                                    .histPesagensPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexPesagens)
                                                                    ?.tipo,
                                                                deletado: _model
                                                                    .histPesagensPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexPesagens)
                                                                    ?.deletado,
                                                                createdAt: _model
                                                                    .histPesagensPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexPesagens)
                                                                    ?.createdAt,
                                                                id: _model
                                                                    .histPesagensPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexPesagens)
                                                                    ?.id,
                                                                peso: _model
                                                                    .histPesagensPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexPesagens)
                                                                    ?.peso,
                                                                idPropriedade: _model
                                                                    .histPesagensPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .indexPesagens)
                                                                    ?.idPropriedade,
                                                              ));
                                                              safeSetState(
                                                                  () {});
                                                              _model.indexPesagens =
                                                                  _model.indexPesagens +
                                                                      1;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.indexPesagens =
                                                                0;
                                                            safeSetState(() {});
                                                          }
                                                          _model.lotesPesq =
                                                              await SQLiteManager
                                                                  .instance
                                                                  .buscarLotes(
                                                            idPropriedade: FFAppState()
                                                                .propriedadeSelecionada
                                                                .idPropriedade,
                                                          );
                                                          FFAppState()
                                                              .rebanhoLotesSelecionar = [];
                                                          safeSetState(() {});
                                                          if (_model.lotesPesq!
                                                              .isNotEmpty) {
                                                            while (_model
                                                                    .index <
                                                                _model
                                                                    .lotesPesq!
                                                                    .length) {
                                                              FFAppState()
                                                                  .addToRebanhoLotesSelecionar(
                                                                      LocalLotesStruct(
                                                                idLote: _model
                                                                    .lotesPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .index)
                                                                    ?.idLote,
                                                                nome: _model
                                                                    .lotesPesq
                                                                    ?.elementAtOrNull(
                                                                        _model
                                                                            .index)
                                                                    ?.nome,
                                                              ));
                                                              safeSetState(
                                                                  () {});
                                                              _model.index =
                                                                  _model.index +
                                                                      1;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                          }
                                                          await showDialog(
                                                            barrierColor: Colors
                                                                .transparent,
                                                            context: context,
                                                            builder:
                                                                (dialogContext) {
                                                              return Dialog(
                                                                elevation: 0,
                                                                insetPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                alignment: const AlignmentDirectional(
                                                                        0.0,
                                                                        0.0)
                                                                    .resolve(
                                                                        Directionality.of(
                                                                            context)),
                                                                child:
                                                                    ViewRebanhoWidget(
                                                                  idRebanho:
                                                                      animaisItem
                                                                          .idRebanho!,
                                                                ),
                                                              );
                                                            },
                                                          );

                                                          safeSetState(() {});
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
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
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/Group_11_3_(1).png',
                                                                          width:
                                                                              24.0,
                                                                          height:
                                                                              24.0,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                      if (animaisItem
                                                                              .sexo ==
                                                                          'Macho')
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
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                      if (animaisItem
                                                                              .sexo ==
                                                                          'Fêmea')
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/Sexofemea.png',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                          ),
                                                                        ),
                                                                      if (animaisItem
                                                                              .tipo ==
                                                                          'Nascimento')
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              8.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100.0,
                                                                            height:
                                                                                24.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: const Color(0xFFB1CC29),
                                                                              borderRadius: BorderRadius.circular(4.0),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                              child: Text(
                                                                                'Nascimento',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if (animaisItem
                                                                              .tipo ==
                                                                          'Sêmen')
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              8.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100.0,
                                                                            height:
                                                                                24.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: const Color(0xFFB1CC29),
                                                                              borderRadius: BorderRadius.circular(4.0),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                              child: Text(
                                                                                'Sêmen',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 0.0,
                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    '${valueOrDefault<String>(
                                                                      animaisItem
                                                                          .numeroAnimal,
                                                                      '0000',
                                                                    )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                        animaisItem
                                                                            .nome,
                                                                        'S/N',
                                                                      )} • ${dateTimeFormat(
                                                                      "d/M/y",
                                                                      functions.converterParaData(
                                                                          valueOrDefault<
                                                                              String>(
                                                                        animaisItem
                                                                            .dataNascimento,
                                                                        'xx/xx/xxxx',
                                                                      )),
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    )}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              const Color(0xFF474747),
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    '${valueOrDefault<String>(
                                                                      animaisItem
                                                                          .categoria,
                                                                      'Sem Categoria',
                                                                    )} • ${valueOrDefault<String>(
                                                                          animaisItem
                                                                              .raca,
                                                                          'Sem raça',
                                                                        ) == 'null' ? 'Sem raça' : valueOrDefault<String>(
                                                                        animaisItem
                                                                            .raca,
                                                                        'Sem raça',
                                                                      )}',
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
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/Lotes4343434.png',
                                                                          width:
                                                                              24.0,
                                                                          height:
                                                                              24.0,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          'Lote: ${valueOrDefault<String>(
                                                                                    animaisItem.loteNome,
                                                                                    'N/A',
                                                                                  ) == 'null' ? 'S/L' : valueOrDefault<String>(
                                                                                  animaisItem.loteNome,
                                                                                  'S/L',
                                                                                )}'
                                                                              .maybeHandleOverflow(
                                                                            maxChars:
                                                                                25,
                                                                            replacement:
                                                                                '…',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: const Color(0xFF5F5F5F),
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.normal,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ].divide(const SizedBox(
                                                                        width:
                                                                            4.0)),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0)),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .visibility_outlined,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .customColor9,
                                                                  size: 24.0,
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        16.0),
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    await _openEditRebanho(
                                                                        context,
                                                                        animaisItem
                                                                            .idRebanho);
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .edit_outlined,
                                                                    color: Color(
                                                                        0xFF1E7A4C),
                                                                    size: 24.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
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
                                            ),
                                          );
                                        }),
                                      );
                                    },
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
              if (_model.pesquisarTextController.text == '')
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
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
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        onPressed: (_model.pageNum == 1)
                            ? null
                            : () async {
                                _model.pageNum = _model.pageNum! + -1;
                                _model.offset = _model.offset! + -20;
                                safeSetState(() {});
                              },
                      ),
                      RichText(
                        textScaler: MediaQuery.of(context).textScaler,
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
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            TextSpan(
                              text: ' de ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            TextSpan(
                              text: valueOrDefault<String>(
                                ((FFAppState().qtdAnimaisPropriedade /
                                            (_model.limit!))
                                        .ceil())
                                    .toString(),
                                '1',
                              ),
                              style: const TextStyle(),
                            )
                          ],
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
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
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        onPressed: (_model.pageNum ==
                                valueOrDefault<int>(
                                  (FFAppState().animaisRegistrados /
                                          (_model.limit!))
                                      .ceil(),
                                  1,
                                ))
                            ? null
                            : () async {
                                _model.pageNum = _model.pageNum! + 1;
                                _model.offset = _model.offset! + 20;
                                safeSetState(() {});
                              },
                      ),
                    ].divide(const SizedBox(width: 8.0)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
