import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_rebanho_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'popup_rebanhos_model.dart';
export 'popup_rebanhos_model.dart';

class PopupRebanhosWidget extends StatefulWidget {
  const PopupRebanhosWidget({
    super.key,
    this.sexo,
    bool? sanidade,
    bool? reproducao,
    this.tipoReproducao,
  })  : sanidade = sanidade ?? false,
        reproducao = reproducao ?? false;

  final String? sexo;
  final bool sanidade;
  final bool reproducao;
  final String? tipoReproducao;

  @override
  State<PopupRebanhosWidget> createState() => _PopupRebanhosWidgetState();
}

class _PopupRebanhosWidgetState extends State<PopupRebanhosWidget> {
  late PopupRebanhosModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupRebanhosModel());

    _model.pesquisarTextController1 ??= TextEditingController();
    _model.pesquisarFocusNode1 ??= FocusNode();

    _model.pesquisarTextController2 ??= TextEditingController();
    _model.pesquisarFocusNode2 ??= FocusNode();

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

    return Builder(
      builder: (context) {
        if (widget.sanidade == true) {
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            child: FutureBuilder<List<BuscaRebanhoPopupRow>>(
              future: _model.getBuscaRebanhoFuture(
                idPropriedade:
                    FFAppState().propriedadeSelecionada.idPropriedade,
                pesquisa: _model.pesquisarTextController1.text,
                excludeIdRebanho: FFAppState().rebanhoSelecionado.idRebanho,
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
                final containerBuscaRebanhoPopupRowList = snapshot.data!;

                return Container(
                  height: 400.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            8.0, 8.0, 8.0, 0.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.pesquisarTextController1,
                            focusNode: _model.pesquisarFocusNode1,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.pesquisarTextController1',
                              const Duration(milliseconds: 500),
                              () {
                                _model.invalidateBuscaCache();
                                safeSetState(() {});
                              },
                            ),
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelMediumIsCustom,
                                  ),
                              hintText: 'Pesquisar',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelMediumFamily,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
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
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              prefixIcon: Icon(
                                Icons.search_sharp,
                                color: FlutterFlowTheme.of(context).accent3,
                                size: 24.0,
                              ),
                              suffixIcon: _model
                                      .pesquisarTextController1!.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () async {
                                        _model.pesquisarTextController1
                                            ?.clear();
                                        _model.invalidateBuscaCache();
                                        safeSetState(() {});
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: FlutterFlowTheme.of(context)
                                            .accent3,
                                        size: 22,
                                      ),
                                    )
                                  : null,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            cursorColor:
                                FlutterFlowTheme.of(context).primaryText,
                            validator: _model.pesquisarTextController1Validator
                                .asValidator(context),
                          ),
                        ),
                      ),
                      if (!(containerBuscaRebanhoPopupRowList.isNotEmpty))
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
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  32.0, 32.0, 32.0, 32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/Mask_group.png',
                                      height: 74.0,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  RichText(
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'Nenhum animal foi cadastrado nesta propriedade.',
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
                                    textAlign: TextAlign.center,
                                  ),
                                ].divide(const SizedBox(height: 24.0)),
                              ),
                            ),
                          ),
                        ),
                      if (containerBuscaRebanhoPopupRowList.isNotEmpty)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 14.0, 0.0, 8.0),
                            child: Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                maxHeight: 500.0,
                              ),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(0.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 8.0, 0.0),
                                child: Builder(
                                  builder: (context) {
                                    final animais =
                                        containerBuscaRebanhoPopupRowList
                                            .toList();

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: animais.length,
                                      itemBuilder: (context, animaisIndex) {
                                        final animaisItem =
                                            animais[animaisIndex];
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 12.0, 24.0, 12.0),
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
                                                    if (animaisItem.sexo ==
                                                        'Fêmea') {
                                                      FFAppState()
                                                              .reprodutorSelecionado =
                                                          AnimalSelecionadoStruct
                                                              .fromSerializableMap(
                                                                  jsonDecode(
                                                                      '{}'));
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .matrizSelecionada =
                                                          AnimalSelecionadoStruct(
                                                        numAnimal: animaisItem
                                                            .numeroAnimal,
                                                        nomeAnimal:
                                                            animaisItem.nome,
                                                        dataNascAnimal:
                                                            animaisItem
                                                                .dataNascimento,
                                                        racaAnimal:
                                                            animaisItem.raca,
                                                        chip: animaisItem.chip,
                                                        idRebanho: animaisItem
                                                            .idRebanho,
                                                        categoria: animaisItem
                                                            .categoria,
                                                        loteNome: animaisItem
                                                            .loteNome,
                                                      );
                                                      safeSetState(() {});
                                                    } else {
                                                      FFAppState()
                                                              .matrizSelecionada =
                                                          AnimalSelecionadoStruct
                                                              .fromSerializableMap(
                                                                  jsonDecode(
                                                                      '{}'));
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .reprodutorSelecionado =
                                                          AnimalSelecionadoStruct(
                                                        numAnimal: animaisItem
                                                            .numeroAnimal,
                                                        nomeAnimal:
                                                            animaisItem.nome,
                                                        dataNascAnimal:
                                                            animaisItem
                                                                .dataNascimento,
                                                        racaAnimal:
                                                            animaisItem.raca,
                                                        chip: animaisItem.chip,
                                                        idRebanho: animaisItem
                                                            .idRebanho,
                                                        categoria: animaisItem
                                                            .categoria,
                                                        loteNome: animaisItem
                                                            .loteNome,
                                                      );
                                                      safeSetState(() {});
                                                    }

                                                    FFAppState()
                                                            .rebanhoSanidadeSelecionado =
                                                        AnimalSelecionadoStruct(
                                                      numAnimal: animaisItem
                                                          .numeroAnimal,
                                                      nomeAnimal:
                                                          animaisItem.nome,
                                                      dataNascAnimal:
                                                          animaisItem
                                                              .dataNascimento,
                                                      racaAnimal:
                                                          animaisItem.raca,
                                                      idRebanho:
                                                          animaisItem.idRebanho,
                                                      chip: animaisItem.chip,
                                                      loteNome:
                                                          animaisItem.loteNome,
                                                    );
                                                    safeSetState(() {});
                                                    FFAppState().rebuild = true;
                                                    safeSetState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${valueOrDefault<String>(
                                                                valueOrDefault<
                                                                            String>(
                                                                          animaisItem
                                                                              .numeroAnimal,
                                                                          '0000',
                                                                        ) ==
                                                                        'null'
                                                                    ? 'S/N'
                                                                    : valueOrDefault<
                                                                        String>(
                                                                        animaisItem
                                                                            .numeroAnimal,
                                                                        'S/N',
                                                                      ),
                                                                'S/N',
                                                              )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                  animaisItem
                                                                      .nome,
                                                                  'S/N',
                                                                )} • ${valueOrDefault<String>(
                                                                () {
                                                                  if (valueOrDefault<
                                                                          String>(
                                                                        animaisItem
                                                                            .dataNascimento,
                                                                        'xx/xx/xxxx',
                                                                      ) ==
                                                                      'null') {
                                                                    return 'N/A';
                                                                  } else if (valueOrDefault<
                                                                          String>(
                                                                        animaisItem
                                                                            .dataNascimento,
                                                                        'xx/xx/xxxx',
                                                                      ) ==
                                                                      '') {
                                                                    return 'N/A';
                                                                  } else {
                                                                    return dateTimeFormat(
                                                                      "d/M/yy",
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
                                                                    );
                                                                  }
                                                                }(),
                                                                'N/A',
                                                              )}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: const Color(
                                                                        0xFF474747),
                                                                    fontSize:
                                                                        15.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  height: 2.0)),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_right_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                height: 0.0,
                                                thickness: 1.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
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
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            child: Container(
              height: 420.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x33000000),
                    offset: Offset(
                      0.0,
                      2.0,
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 8.0, 8.0, 0.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.pesquisarTextController2,
                        focusNode: _model.pesquisarFocusNode2,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.pesquisarTextController2',
                          const Duration(milliseconds: 500),
                          () {
                            _model.invalidateBuscaCache();
                            safeSetState(() {});
                          },
                        ),
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          hintText: 'Pesquisar',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
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
                          suffixIcon: _model
                                  .pesquisarTextController2!.text.isNotEmpty
                              ? InkWell(
                                  onTap: () async {
                                    _model.pesquisarTextController2?.clear();
                                    _model.invalidateBuscaCache();
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
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        validator: _model.pesquisarTextController2Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  if ((_model.pesquisarTextController2.text != '') &&
                      responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                        tabletLandscape: false,
                        desktop: false,
                      ))
                    FutureBuilder<List<BuscaRebanhoPopupRow>>(
                      future: SQLiteManager.instance.buscaRebanhoPopup(
                        idPropriedade:
                            FFAppState().propriedadeSelecionada.idPropriedade,
                        pesquisa: _model.pesquisarTextController2.text,
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
                        final pesquisaRebanhoBuscaRebanhoPopupRowList =
                            snapshot.data!;

                        return Container(
                          height: 300.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!(pesquisaRebanhoBuscaRebanhoPopupRowList
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
                              if ((pesquisaRebanhoBuscaRebanhoPopupRowList
                                      .isNotEmpty) &&
                                  (widget.sexo == 'Fêmea'))
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 14.0, 0.0, 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 300.0,
                                      constraints: const BoxConstraints(
                                        maxHeight: 500.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: Builder(
                                          builder: (context) {
                                            final animais =
                                                pesquisaRebanhoBuscaRebanhoPopupRowList
                                                    .where((e) =>
                                                        (e.categoria !=
                                                            'Bezerra') &&
                                                        (e.idRebanho !=
                                                            FFAppState()
                                                                .rebanhoSelecionado
                                                                .idRebanho) &&
                                                        (e.statusRebanho ==
                                                            'Na propriedade') &&
                                                        (e.sexo == 'Fêmea'))
                                                    .toList()
                                                    .take(20)
                                                    .toList();

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              itemCount: animais.length,
                                              itemBuilder:
                                                  (context, animaisIndex) {
                                                final animaisItem =
                                                    animais[animaisIndex];
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
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                12.0,
                                                                24.0,
                                                                12.0),
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
                                                            if (animaisItem
                                                                    .sexo ==
                                                                'Fêmea') {
                                                              FFAppState()
                                                                      .matrizSelecionada =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            } else {
                                                              FFAppState()
                                                                      .reprodutorSelecionado =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            }

                                                            FFAppState()
                                                                .rebuild = true;
                                                            safeSetState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${valueOrDefault<String>(
                                                                      valueOrDefault<String>(
                                                                                animaisItem.numeroAnimal,
                                                                                '0000',
                                                                              ) ==
                                                                              'null'
                                                                          ? 'S/N'
                                                                          : valueOrDefault<String>(
                                                                              animaisItem.numeroAnimal,
                                                                              'S/N',
                                                                            ),
                                                                      'S/N',
                                                                    )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                        animaisItem
                                                                            .nome,
                                                                        'S/N',
                                                                      )} • ${valueOrDefault<String>(
                                                                      () {
                                                                        if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            'null') {
                                                                          return 'N/A';
                                                                        } else if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            '') {
                                                                          return 'N/A';
                                                                        } else {
                                                                          return dateTimeFormat(
                                                                            "d/M/yy",
                                                                            functions.converterParaData(valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            )),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          );
                                                                        }
                                                                      }(),
                                                                      'N/A',
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
                                                                              15.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0)),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .keyboard_arrow_right_sharp,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 24.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 0.0,
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
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
                                ),
                              if ((pesquisaRebanhoBuscaRebanhoPopupRowList
                                      .isNotEmpty) &&
                                  (widget.sexo == 'Macho'))
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 14.0, 0.0, 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxHeight: 500.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: Builder(
                                          builder: (context) {
                                            final animais =
                                                pesquisaRebanhoBuscaRebanhoPopupRowList
                                                    .where((e) =>
                                                        (e.idRebanho !=
                                                            FFAppState()
                                                                .rebanhoSelecionado
                                                                .idRebanho) &&
                                                        (e.statusRebanho ==
                                                            'Na propriedade') &&
                                                        (e.categoria ==
                                                            'Touro'))
                                                    .toList()
                                                    .take(20)
                                                    .toList();
                                            if (animais.isEmpty) {
                                              return const Center(
                                                child: EmptyRebanhoWidget(),
                                              );
                                            }

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              itemCount: animais.length,
                                              itemBuilder:
                                                  (context, animaisIndex) {
                                                final animaisItem =
                                                    animais[animaisIndex];
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
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                12.0,
                                                                24.0,
                                                                12.0),
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
                                                            if (animaisItem
                                                                    .sexo ==
                                                                'Fêmea') {
                                                              FFAppState()
                                                                      .matrizSelecionada =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            } else {
                                                              FFAppState()
                                                                      .reprodutorSelecionado =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            }

                                                            FFAppState()
                                                                .rebuild = true;
                                                            safeSetState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${valueOrDefault<String>(
                                                                      valueOrDefault<String>(
                                                                                animaisItem.numeroAnimal,
                                                                                '0000',
                                                                              ) ==
                                                                              'null'
                                                                          ? 'S/N'
                                                                          : valueOrDefault<String>(
                                                                              animaisItem.numeroAnimal,
                                                                              'S/N',
                                                                            ),
                                                                      'S/N',
                                                                    )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                        animaisItem
                                                                            .nome,
                                                                        'S/N',
                                                                      )} • ${valueOrDefault<String>(
                                                                      () {
                                                                        if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            'null') {
                                                                          return 'N/A';
                                                                        } else if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            '') {
                                                                          return 'N/A';
                                                                        } else {
                                                                          return dateTimeFormat(
                                                                            "d/M/yy",
                                                                            functions.converterParaData(valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            )),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          );
                                                                        }
                                                                      }(),
                                                                      'N/A',
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
                                                                              15.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0)),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .keyboard_arrow_right_sharp,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 24.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 0.0,
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
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
                                ),
                              if (((pesquisaRebanhoBuscaRebanhoPopupRowList
                                          .isNotEmpty) &&
                                      (widget.sexo == 'Macho') &&
                                      (widget.reproducao == true) &&
                                      (widget.tipoReproducao ==
                                          'Monta Natural')) &&
                                  responsiveVisibility(
                                    context: context,
                                    phone: false,
                                    tablet: false,
                                    tabletLandscape: false,
                                    desktop: false,
                                  ))
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 14.0, 0.0, 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxHeight: 500.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: Builder(
                                          builder: (context) {
                                            final animais =
                                                pesquisaRebanhoBuscaRebanhoPopupRowList
                                                    .where((e) =>
                                                        (e.idRebanho !=
                                                            FFAppState()
                                                                .rebanhoSelecionado
                                                                .idRebanho) &&
                                                        (e.statusRebanho ==
                                                            'Na propriedade') &&
                                                        (e.categoria ==
                                                            'Touro'))
                                                    .toList()
                                                    .take(20)
                                                    .toList();

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              itemCount: animais.length,
                                              itemBuilder:
                                                  (context, animaisIndex) {
                                                final animaisItem =
                                                    animais[animaisIndex];
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
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                12.0,
                                                                24.0,
                                                                12.0),
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
                                                            if (animaisItem
                                                                    .sexo ==
                                                                'Fêmea') {
                                                              FFAppState()
                                                                      .matrizSelecionada =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            } else {
                                                              FFAppState()
                                                                      .reprodutorSelecionado =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            }

                                                            FFAppState()
                                                                .rebuild = true;
                                                            safeSetState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        valueOrDefault<String>(
                                                                                  animaisItem.numeroAnimal,
                                                                                  '0000',
                                                                                ) ==
                                                                                'null'
                                                                            ? 'S/N'
                                                                            : valueOrDefault<String>(
                                                                                animaisItem.numeroAnimal,
                                                                                'S/N',
                                                                              ),
                                                                        'S/N',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${valueOrDefault<String>(
                                                                        () {
                                                                          if (valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              ) ==
                                                                              'null') {
                                                                            return 'N/A';
                                                                          } else if (valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              ) ==
                                                                              '') {
                                                                            return 'N/A';
                                                                          } else {
                                                                            return dateTimeFormat(
                                                                              "d/M/yy",
                                                                              functions.converterParaData(valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              )),
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            );
                                                                          }
                                                                        }(),
                                                                        'N/A',
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
                                                                                15.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .keyboard_arrow_right_sharp,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 24.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 0.0,
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
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
                                ),
                              if ((pesquisaRebanhoBuscaRebanhoPopupRowList
                                      .isNotEmpty) &&
                                  (widget.sexo == 'Macho') &&
                                  (widget.reproducao == true) &&
                                  (widget.tipoReproducao == 'Inseminação'))
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 14.0, 0.0, 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxHeight: 500.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: Builder(
                                          builder: (context) {
                                            final animais =
                                                pesquisaRebanhoBuscaRebanhoPopupRowList
                                                    .where((e) =>
                                                        (e.idRebanho !=
                                                            FFAppState()
                                                                .rebanhoSelecionado
                                                                .idRebanho) &&
                                                        (e.statusRebanho ==
                                                            'Sêmen'))
                                                    .toList()
                                                    .take(20)
                                                    .toList();

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              itemCount: animais.length,
                                              itemBuilder:
                                                  (context, animaisIndex) {
                                                final animaisItem =
                                                    animais[animaisIndex];
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
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                12.0,
                                                                24.0,
                                                                12.0),
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
                                                            if (animaisItem
                                                                    .sexo ==
                                                                'Fêmea') {
                                                              FFAppState()
                                                                      .matrizSelecionada =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            } else {
                                                              FFAppState()
                                                                      .reprodutorSelecionado =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            }

                                                            FFAppState()
                                                                .rebuild = true;
                                                            safeSetState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        valueOrDefault<String>(
                                                                                  animaisItem.numeroAnimal,
                                                                                  '0000',
                                                                                ) ==
                                                                                'null'
                                                                            ? 'S/N'
                                                                            : valueOrDefault<String>(
                                                                                animaisItem.numeroAnimal,
                                                                                'S/N',
                                                                              ),
                                                                        'S/N',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${valueOrDefault<String>(
                                                                        () {
                                                                          if (valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              ) ==
                                                                              'null') {
                                                                            return 'N/A';
                                                                          } else if (valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              ) ==
                                                                              '') {
                                                                            return 'N/A';
                                                                          } else {
                                                                            return dateTimeFormat(
                                                                              "d/M/yy",
                                                                              functions.converterParaData(valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              )),
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            );
                                                                          }
                                                                        }(),
                                                                        'N/A',
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
                                                                                15.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .keyboard_arrow_right_sharp,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 24.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 0.0,
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
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
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  FutureBuilder<List<BuscaRebanhoPopupRow>>(
                    future: _model.getBuscaRebanhoFuture(
                      idPropriedade:
                          FFAppState().propriedadeSelecionada.idPropriedade,
                      pesquisa: _model.pesquisarTextController2.text,
                      sexo: widget.sexo == 'Fêmea' ? 'Fêmea' : null,
                      categoriaExcluir:
                          widget.sexo == 'Fêmea' ? 'Bezerra' : null,
                      categoria: widget.sexo == 'Macho' &&
                              (widget.reproducao == false ||
                                  widget.tipoReproducao == 'Monta Natural')
                          ? 'Touro'
                          : null,
                      statusRebanho: widget.sexo == 'Fêmea'
                          ? 'Na propriedade'
                          : widget.sexo == 'Macho' &&
                                  widget.reproducao == true &&
                                  widget.tipoReproducao == 'Monta Natural'
                              ? 'Na propriedade'
                              : widget.sexo == 'Macho' &&
                                      widget.reproducao == true &&
                                      widget.tipoReproducao == 'Inseminação'
                                  ? 'Sêmen'
                                  : null,
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
                      final semPesquisaBuscaRebanhoPopupRowList =
                          snapshot.data!;

                      return Container(
                        constraints: const BoxConstraints(
                          maxHeight: 300.0,
                        ),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (!(semPesquisaBuscaRebanhoPopupRowList
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
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'Nenhum animal foi cadastrado nesta propriedade.',
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
                                              )
                                            ],
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
                                          textAlign: TextAlign.center,
                                        ),
                                      ].divide(const SizedBox(height: 24.0)),
                                    ),
                                  ),
                                ),
                              ),
                            if ((semPesquisaBuscaRebanhoPopupRowList
                                    .isNotEmpty) &&
                                (widget.sexo == 'Fêmea'))
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 14.0, 0.0, 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 300.0,
                                    constraints: const BoxConstraints(
                                      maxHeight: 300.0,
                                    ),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0.0),
                                        bottomRight: Radius.circular(0.0),
                                        topLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(0.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 0.0, 8.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final animais =
                                              semPesquisaBuscaRebanhoPopupRowList;

                                          return SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children:
                                                  List.generate(animais.length,
                                                      (animaisIndex) {
                                                final animaisItem =
                                                    animais[animaisIndex];
                                                return Container(
                                                  width: double.infinity,
                                                  height: 48.0,
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24.0,
                                                                12.0,
                                                                24.0,
                                                                12.0),
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
                                                            if (animaisItem
                                                                    .sexo ==
                                                                'Fêmea') {
                                                              FFAppState()
                                                                      .matrizSelecionada =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            } else {
                                                              FFAppState()
                                                                      .reprodutorSelecionado =
                                                                  AnimalSelecionadoStruct(
                                                                numAnimal:
                                                                    animaisItem
                                                                        .numeroAnimal,
                                                                nomeAnimal:
                                                                    animaisItem
                                                                        .nome,
                                                                dataNascAnimal:
                                                                    animaisItem
                                                                        .dataNascimento,
                                                                racaAnimal:
                                                                    animaisItem
                                                                        .raca,
                                                                chip:
                                                                    animaisItem
                                                                        .chip,
                                                                idRebanho:
                                                                    animaisItem
                                                                        .idRebanho,
                                                                categoria:
                                                                    animaisItem
                                                                        .categoria,
                                                                loteNome:
                                                                    animaisItem
                                                                        .loteNome,
                                                              );
                                                              _model.updatePage(
                                                                  () {});
                                                            }

                                                            FFAppState()
                                                                .rebuild = true;
                                                            safeSetState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${valueOrDefault<String>(
                                                                        valueOrDefault<String>(
                                                                                  animaisItem.numeroAnimal,
                                                                                  '0000',
                                                                                ) ==
                                                                                'null'
                                                                            ? 'S/N'
                                                                            : valueOrDefault<String>(
                                                                                animaisItem.numeroAnimal,
                                                                                'S/N',
                                                                              ),
                                                                        'S/N',
                                                                      )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                          animaisItem
                                                                              .nome,
                                                                          'S/N',
                                                                        )} • ${valueOrDefault<String>(
                                                                        () {
                                                                          if (valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              ) ==
                                                                              'null') {
                                                                            return 'N/A';
                                                                          } else if (valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              ) ==
                                                                              '') {
                                                                            return 'N/A';
                                                                          } else {
                                                                            return dateTimeFormat(
                                                                              "d/M/yy",
                                                                              functions.converterParaData(valueOrDefault<String>(
                                                                                animaisItem.dataNascimento,
                                                                                'xx/xx/xxxx',
                                                                              )),
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            );
                                                                          }
                                                                        }(),
                                                                        'N/A',
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
                                                                                15.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          2.0)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 0.0,
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if ((semPesquisaBuscaRebanhoPopupRowList
                                    .isNotEmpty) &&
                                (widget.sexo == 'Macho') &&
                                (widget.reproducao == false))
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 14.0, 0.0, 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 300.0,
                                    constraints: const BoxConstraints(
                                      maxHeight: 300.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                        topLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(0.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 0.0, 8.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final animais =
                                              semPesquisaBuscaRebanhoPopupRowList;
                                          if (animais.isEmpty) {
                                            return const Center(
                                              child: EmptyRebanhoWidget(),
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            itemCount: animais.length,
                                            itemBuilder:
                                                (context, animaisIndex) {
                                              final animaisItem =
                                                  animais[animaisIndex];
                                              return Container(
                                                width: double.infinity,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(24.0,
                                                              12.0, 24.0, 12.0),
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
                                                          if (animaisItem
                                                                  .sexo ==
                                                              'Fêmea') {
                                                            FFAppState()
                                                                    .matrizSelecionada =
                                                                AnimalSelecionadoStruct(
                                                              numAnimal: animaisItem
                                                                  .numeroAnimal,
                                                              nomeAnimal:
                                                                  animaisItem
                                                                      .nome,
                                                              dataNascAnimal:
                                                                  animaisItem
                                                                      .dataNascimento,
                                                              racaAnimal:
                                                                  animaisItem
                                                                      .raca,
                                                              chip: animaisItem
                                                                  .chip,
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                              categoria:
                                                                  animaisItem
                                                                      .categoria,
                                                              loteNome:
                                                                  animaisItem
                                                                      .loteNome,
                                                            );
                                                            _model.updatePage(
                                                                () {});
                                                          } else {
                                                            FFAppState()
                                                                    .reprodutorSelecionado =
                                                                AnimalSelecionadoStruct(
                                                              numAnimal: animaisItem
                                                                  .numeroAnimal,
                                                              nomeAnimal:
                                                                  animaisItem
                                                                      .nome,
                                                              dataNascAnimal:
                                                                  animaisItem
                                                                      .dataNascimento,
                                                              racaAnimal:
                                                                  animaisItem
                                                                      .raca,
                                                              chip: animaisItem
                                                                  .chip,
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                              categoria:
                                                                  animaisItem
                                                                      .categoria,
                                                              loteNome:
                                                                  animaisItem
                                                                      .loteNome,
                                                            );
                                                            _model.updatePage(
                                                                () {});
                                                          }

                                                          FFAppState().rebuild =
                                                              true;
                                                          safeSetState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${valueOrDefault<String>(
                                                                      valueOrDefault<String>(
                                                                                animaisItem.numeroAnimal,
                                                                                '0000',
                                                                              ) ==
                                                                              'null'
                                                                          ? 'S/N'
                                                                          : valueOrDefault<String>(
                                                                              animaisItem.numeroAnimal,
                                                                              'S/N',
                                                                            ),
                                                                      'S/N',
                                                                    )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                        animaisItem
                                                                            .nome,
                                                                        'S/N',
                                                                      )} • ${valueOrDefault<String>(
                                                                      () {
                                                                        if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            'null') {
                                                                          return 'N/A';
                                                                        } else if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            '') {
                                                                          return 'N/A';
                                                                        } else {
                                                                          return dateTimeFormat(
                                                                            "d/M/yy",
                                                                            functions.converterParaData(valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            )),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          );
                                                                        }
                                                                      }(),
                                                                      'N/A',
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
                                                                              15.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 0.0,
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
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
                              ),
                            if ((semPesquisaBuscaRebanhoPopupRowList
                                    .isNotEmpty) &&
                                (widget.sexo == 'Macho') &&
                                (widget.tipoReproducao == 'Monta Natural') &&
                                (widget.reproducao == true))
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 14.0, 0.0, 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    constraints: const BoxConstraints(
                                      maxHeight: 300.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                        topLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(0.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 0.0, 8.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final animais =
                                              semPesquisaBuscaRebanhoPopupRowList;
                                          if (animais.isEmpty) {
                                            return const Center(
                                              child: EmptyRebanhoWidget(),
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            itemCount: animais.length,
                                            itemBuilder:
                                                (context, animaisIndex) {
                                              final animaisItem =
                                                  animais[animaisIndex];
                                              return Container(
                                                width: double.infinity,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(24.0,
                                                              12.0, 24.0, 12.0),
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
                                                          if (animaisItem
                                                                  .sexo ==
                                                              'Fêmea') {
                                                            FFAppState()
                                                                    .matrizSelecionada =
                                                                AnimalSelecionadoStruct(
                                                              numAnimal: animaisItem
                                                                  .numeroAnimal,
                                                              nomeAnimal:
                                                                  animaisItem
                                                                      .nome,
                                                              dataNascAnimal:
                                                                  animaisItem
                                                                      .dataNascimento,
                                                              racaAnimal:
                                                                  animaisItem
                                                                      .raca,
                                                              chip: animaisItem
                                                                  .chip,
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                              categoria:
                                                                  animaisItem
                                                                      .categoria,
                                                              loteNome:
                                                                  animaisItem
                                                                      .loteNome,
                                                            );
                                                            _model.updatePage(
                                                                () {});
                                                          } else {
                                                            FFAppState()
                                                                    .reprodutorSelecionado =
                                                                AnimalSelecionadoStruct(
                                                              numAnimal: animaisItem
                                                                  .numeroAnimal,
                                                              nomeAnimal:
                                                                  animaisItem
                                                                      .nome,
                                                              dataNascAnimal:
                                                                  animaisItem
                                                                      .dataNascimento,
                                                              racaAnimal:
                                                                  animaisItem
                                                                      .raca,
                                                              chip: animaisItem
                                                                  .chip,
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                              categoria:
                                                                  animaisItem
                                                                      .categoria,
                                                              loteNome:
                                                                  animaisItem
                                                                      .loteNome,
                                                            );
                                                            _model.updatePage(
                                                                () {});
                                                          }

                                                          FFAppState().rebuild =
                                                              true;
                                                          safeSetState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${valueOrDefault<String>(
                                                                      valueOrDefault<String>(
                                                                                animaisItem.numeroAnimal,
                                                                                '0000',
                                                                              ) ==
                                                                              'null'
                                                                          ? 'S/N'
                                                                          : valueOrDefault<String>(
                                                                              animaisItem.numeroAnimal,
                                                                              'S/N',
                                                                            ),
                                                                      'S/N',
                                                                    )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                        animaisItem
                                                                            .nome,
                                                                        'S/N',
                                                                      )} • ${valueOrDefault<String>(
                                                                      () {
                                                                        if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            'null') {
                                                                          return 'N/A';
                                                                        } else if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            '') {
                                                                          return 'N/A';
                                                                        } else {
                                                                          return dateTimeFormat(
                                                                            "d/M/yy",
                                                                            functions.converterParaData(valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            )),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          );
                                                                        }
                                                                      }(),
                                                                      'N/A',
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
                                                                              15.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 0.0,
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
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
                              ),
                            if ((semPesquisaBuscaRebanhoPopupRowList
                                    .isNotEmpty) &&
                                (widget.sexo == 'Macho') &&
                                (widget.tipoReproducao == 'Inseminação') &&
                                (widget.reproducao == true))
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 14.0, 0.0, 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 300.0,
                                    constraints: const BoxConstraints(
                                      maxHeight: 300.0,
                                    ),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                        topLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(0.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 0.0, 8.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final animais =
                                              semPesquisaBuscaRebanhoPopupRowList;
                                          if (animais.isEmpty) {
                                            return const Center(
                                              child: EmptyRebanhoWidget(),
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            itemCount: animais.length,
                                            itemBuilder:
                                                (context, animaisIndex) {
                                              final animaisItem =
                                                  animais[animaisIndex];
                                              return Container(
                                                width: double.infinity,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(24.0,
                                                              12.0, 24.0, 12.0),
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
                                                          if (animaisItem
                                                                  .sexo ==
                                                              'Fêmea') {
                                                            FFAppState()
                                                                    .matrizSelecionada =
                                                                AnimalSelecionadoStruct(
                                                              numAnimal: animaisItem
                                                                  .numeroAnimal,
                                                              nomeAnimal:
                                                                  animaisItem
                                                                      .nome,
                                                              dataNascAnimal:
                                                                  animaisItem
                                                                      .dataNascimento,
                                                              racaAnimal:
                                                                  animaisItem
                                                                      .raca,
                                                              chip: animaisItem
                                                                  .chip,
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                              categoria:
                                                                  animaisItem
                                                                      .categoria,
                                                              loteNome:
                                                                  animaisItem
                                                                      .loteNome,
                                                            );
                                                            _model.updatePage(
                                                                () {});
                                                          } else {
                                                            FFAppState()
                                                                    .reprodutorSelecionado =
                                                                AnimalSelecionadoStruct(
                                                              numAnimal: animaisItem
                                                                  .numeroAnimal,
                                                              nomeAnimal:
                                                                  animaisItem
                                                                      .nome,
                                                              dataNascAnimal:
                                                                  animaisItem
                                                                      .dataNascimento,
                                                              racaAnimal:
                                                                  animaisItem
                                                                      .raca,
                                                              chip: animaisItem
                                                                  .chip,
                                                              idRebanho:
                                                                  animaisItem
                                                                      .idRebanho,
                                                              categoria:
                                                                  animaisItem
                                                                      .categoria,
                                                              loteNome:
                                                                  animaisItem
                                                                      .loteNome,
                                                            );
                                                            _model.updatePage(
                                                                () {});
                                                          }

                                                          FFAppState().rebuild =
                                                              true;
                                                          safeSetState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${valueOrDefault<String>(
                                                                      valueOrDefault<String>(
                                                                                animaisItem.numeroAnimal,
                                                                                '0000',
                                                                              ) ==
                                                                              'null'
                                                                          ? 'S/N'
                                                                          : valueOrDefault<String>(
                                                                              animaisItem.numeroAnimal,
                                                                              'S/N',
                                                                            ),
                                                                      'S/N',
                                                                    )} • ${animaisItem.nome == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                        animaisItem
                                                                            .nome,
                                                                        'S/N',
                                                                      )} • ${valueOrDefault<String>(
                                                                      () {
                                                                        if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            'null') {
                                                                          return 'N/A';
                                                                        } else if (valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            ) ==
                                                                            '') {
                                                                          return 'N/A';
                                                                        } else {
                                                                          return dateTimeFormat(
                                                                            "d/M/yy",
                                                                            functions.converterParaData(valueOrDefault<String>(
                                                                              animaisItem.dataNascimento,
                                                                              'xx/xx/xxxx',
                                                                            )),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          );
                                                                        }
                                                                      }(),
                                                                      'N/A',
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
                                                                              15.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 0.0,
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
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
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
