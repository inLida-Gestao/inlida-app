import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_lote_widget.dart';
import '/components/empty_prop_widget.dart';
import '/components/empty_reproducao_widget.dart';
import '/components/empty_sanidade_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/lotes/filtro_lotes/filtro_lotes_widget.dart';
import '/lotes/view_lote/view_lote_widget.dart';
import '/propriedade/add_propriedade/add_propriedade_widget.dart';
import '/propriedade/filtro_propriedades/filtro_propriedades_widget.dart';
import '/propriedade/ordernar_propriedades/ordernar_propriedades_widget.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/propriedade/view_propriedades/view_propriedades_widget.dart';
import '/rebanho/filtros_rebanho/filtros_rebanho_widget.dart';
import '/reproducao/filtros_reproducao/filtros_reproducao_widget.dart';
import '/reproducao/view_reproducao_lote/view_reproducao_lote_widget.dart';
import '/reproducao/view_reproducao_rebanho/view_reproducao_rebanho_widget.dart';
import '/sanidade/edit_sanidade_animal/edit_sanidade_animal_widget.dart';
import '/sanidade/edit_sanidade_lote/edit_sanidade_lote_widget.dart';
import '/sanidade/filtro_sanidades/filtro_sanidades_widget.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pesquisa_geral_model.dart';
export 'pesquisa_geral_model.dart';

class PesquisaGeralWidget extends StatefulWidget {
  const PesquisaGeralWidget({super.key});

  @override
  State<PesquisaGeralWidget> createState() => _PesquisaGeralWidgetState();
}

class _PesquisaGeralWidgetState extends State<PesquisaGeralWidget>
    with TickerProviderStateMixin {
  late PesquisaGeralModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PesquisaGeralModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await action_blocks.qTDReproducoes(context);
    });

    _model.pesquisarRebTextController ??= TextEditingController();
    _model.pesquisarRebFocusNode ??= FocusNode();

    _model.pesquisarPropTextController ??= TextEditingController();
    _model.pesquisarPropFocusNode ??= FocusNode();

    _model.pesquisarLoteTextController ??= TextEditingController();
    _model.pesquisarLoteFocusNode ??= FocusNode();

    _model.pesquisarRepTextController ??= TextEditingController();
    _model.pesquisarRepFocusNode ??= FocusNode();

    _model.pesquisarTextController ??= TextEditingController();
    _model.pesquisarFocusNode ??= FocusNode();

    _model.tabBarController = TabController(
      vsync: this,
      length: 5,
      initialIndex: 0,
    )
      ..addListener(() => safeSetState(() {}))
      ..addListener(() async {
        if (_model.tabBarController!.indexIsChanging) {
          return;
        }

        _model.tab = _model.tabBarCurrentIndex;
        safeSetState(() {});
      });

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
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  if (_model.tabBarCurrentIndex == 0)
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.pesquisarRebTextController,
                          focusNode: _model.pesquisarRebFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.pesquisarRebTextController',
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
                                color: FlutterFlowTheme.of(context).secondary,
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
                                    .pesquisarRebTextController!.text.isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      _model.pesquisarRebTextController
                                          ?.clear();
                                      safeSetState(() {});
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
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
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.pesquisarRebTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  if (_model.tabBarCurrentIndex == 1)
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.pesquisarPropTextController,
                          focusNode: _model.pesquisarPropFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.pesquisarPropTextController',
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
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            prefixIcon: Icon(
                              Icons.search_sharp,
                              color: FlutterFlowTheme.of(context).accent3,
                              size: 24.0,
                            ),
                            suffixIcon: _model.pesquisarPropTextController!.text
                                    .isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      _model.pesquisarPropTextController
                                          ?.clear();
                                      safeSetState(() {});
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
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
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.pesquisarPropTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  if (_model.tabBarCurrentIndex == 2)
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.pesquisarLoteTextController,
                          focusNode: _model.pesquisarLoteFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.pesquisarLoteTextController',
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
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            prefixIcon: Icon(
                              Icons.search_sharp,
                              color: FlutterFlowTheme.of(context).accent3,
                              size: 24.0,
                            ),
                            suffixIcon: _model.pesquisarLoteTextController!.text
                                    .isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      _model.pesquisarLoteTextController
                                          ?.clear();
                                      safeSetState(() {});
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
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
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.pesquisarLoteTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  if (_model.tabBarCurrentIndex == 3)
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.pesquisarRepTextController,
                          focusNode: _model.pesquisarRepFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.pesquisarRepTextController',
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
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            prefixIcon: Icon(
                              Icons.search_sharp,
                              color: FlutterFlowTheme.of(context).accent3,
                              size: 24.0,
                            ),
                            suffixIcon: _model
                                    .pesquisarRepTextController!.text.isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      _model.pesquisarRepTextController
                                          ?.clear();
                                      safeSetState(() {});
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
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
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.pesquisarRepTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  if (_model.tabBarCurrentIndex == 4)
                    Expanded(
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
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            prefixIcon: Icon(
                              Icons.search_sharp,
                              color: FlutterFlowTheme.of(context).accent3,
                              size: 24.0,
                            ),
                            suffixIcon: _model
                                    .pesquisarTextController!.text.isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      _model.pesquisarTextController?.clear();
                                      safeSetState(() {});
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
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
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.pesquisarTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                ].divide(const SizedBox(width: 24.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
            child: wrapWithModel(
              model: _model.selecionarPropriedadeModel,
              updateCallback: () => safeSetState(() {}),
              child: SelecionarPropriedadeWidget(
                onPropriedadeChanged: () async {
                  await action_blocks.qTDReproducoes(context);
                  safeSetState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: Column(
                children: [
                  Align(
                    alignment: const Alignment(-1.0, 0),
                    child: TabBar(
                      isScrollable: true,
                      labelColor: FlutterFlowTheme.of(context).primary,
                      unselectedLabelColor:
                          FlutterFlowTheme.of(context).accent3,
                      labelStyle: FlutterFlowTheme.of(context)
                          .titleMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleMediumFamily,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleMediumIsCustom,
                          ),
                      unselectedLabelStyle: FlutterFlowTheme.of(context)
                          .titleMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleMediumFamily,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleMediumIsCustom,
                          ),
                      indicatorColor: FlutterFlowTheme.of(context).primary,
                      tabs: const [
                        Tab(
                          text: 'Rebanho',
                        ),
                        Tab(
                          text: 'Propriedade',
                        ),
                        Tab(
                          text: 'Lote',
                        ),
                        Tab(
                          text: 'Reprodução',
                        ),
                        Tab(
                          text: 'Sanidade',
                        ),
                      ],
                      controller: _model.tabBarController,
                      onTap: (i) async {
                        [
                          () async {},
                          () async {},
                          () async {},
                          () async {},
                          () async {}
                        ][i]();
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _model.tabBarController,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 8.0, 24.0, 16.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child:
                                                      const FiltrosRebanhoWidget(),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: const Color(0xFFBEBEBE),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 8.0, 16.0, 8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Filtrar',
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
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/Filter78978.png',
                                                      width: 16.0,
                                                      height: 16.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ].divide(
                                                    const SizedBox(width: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final rebanho = FFAppState()
                                                .filtrosAplicadosRebanho
                                                .toList();

                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: List.generate(
                                                  rebanho.length,
                                                  (rebanhoIndex) {
                                                final rebanhoItem =
                                                    rebanho[rebanhoIndex];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFFBEBEBE),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 8.0,
                                                            16.0, 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          rebanhoItem,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          width: 8.0)),
                                                    ),
                                                  ),
                                                );
                                              }).divide(
                                                  const SizedBox(width: 8.0)),
                                            );
                                          },
                                        ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child:
                                    FutureBuilder<List<ListarPropriedadesRow>>(
                                  future:
                                      SQLiteManager.instance.listarPropriedades(
                                    userID: currentUserUid,
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
                                    final containerBodyOfflineListarPropriedadesRowList =
                                        snapshot.data!;

                                    return Container(
                                      decoration: const BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      onTap: () async {
                                                        FFAppState()
                                                                .propEstados =
                                                            containerBodyOfflineListarPropriedadesRowList
                                                                .unique((e) =>
                                                                    e.estado!)
                                                                .map((e) =>
                                                                    e.estado)
                                                                .withoutNulls
                                                                .toList()
                                                                .cast<String>();
                                                        FFAppState()
                                                                .propCidades =
                                                            containerBodyOfflineListarPropriedadesRowList
                                                                .unique((e) =>
                                                                    e.cidade!)
                                                                .map((e) =>
                                                                    e.cidade)
                                                                .withoutNulls
                                                                .toList()
                                                                .cast<String>();
                                                        safeSetState(() {});
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          enableDrag: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return Padding(
                                                              padding: MediaQuery
                                                                  .viewInsetsOf(
                                                                      context),
                                                              child:
                                                                  const FiltroPropriedadesWidget(),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFFBEBEBE),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  16.0,
                                                                  8.0,
                                                                  16.0,
                                                                  8.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                'Filtrar',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/Filter78978.png',
                                                                  width: 16.0,
                                                                  height: 16.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ].divide(
                                                                const SizedBox(
                                                                    width:
                                                                        8.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    if (FFAppState()
                                                            .filtroNumeroAnimais >
                                                        0.0)
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFFBEBEBE),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  16.0,
                                                                  8.0,
                                                                  16.0,
                                                                  8.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                'Animais: ${valueOrDefault<String>(
                                                                  FFAppState()
                                                                      .filtroNumeroAnimais
                                                                      .toString(),
                                                                  '0',
                                                                )}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                              ),
                                                            ].divide(
                                                                const SizedBox(
                                                                    width:
                                                                        8.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    Builder(
                                                      builder: (context) {
                                                        final nomes = FFAppState()
                                                            .filtrosAplicadosProp
                                                            .toList();

                                                        return Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: List
                                                              .generate(
                                                                  nomes.length,
                                                                  (nomesIndex) {
                                                            final nomesItem =
                                                                nomes[
                                                                    nomesIndex];
                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                border:
                                                                    Border.all(
                                                                  color: const Color(
                                                                      0xFFBEBEBE),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        16.0,
                                                                        8.0,
                                                                        16.0,
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      nomesItem,
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
                                                                  ].divide(
                                                                      const SizedBox(
                                                                          width:
                                                                              8.0)),
                                                                ),
                                                              ),
                                                            );
                                                          }).divide(
                                                              const SizedBox(
                                                                  width: 8.0)),
                                                        );
                                                      },
                                                    ),
                                                  ].divide(const SizedBox(
                                                      width: 8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.0,
                                            color: Color(0xFFEDEDED),
                                          ),
                                          if (responsiveVisibility(
                                            context: context,
                                            phone: false,
                                            tablet: false,
                                            tabletLandscape: false,
                                            desktop: false,
                                          ))
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          const OrdernarPropriedadesWidget(),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));
                                              },
                                              child: Container(
                                                width: 327.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent4,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.0, 8.0, 12.0, 8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (FFAppState()
                                                              .filtroTipoOrdenacao !=
                                                          '')
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              if (FFAppState()
                                                                      .filtroOrdenacao ==
                                                                  'Crescente')
                                                                Icon(
                                                                  Icons
                                                                      .arrow_downward_sharp,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent3,
                                                                  size: 12.0,
                                                                ),
                                                              if (FFAppState()
                                                                      .filtroOrdenacao ==
                                                                  'Decrescente')
                                                                Icon(
                                                                  Icons
                                                                      .arrow_upward,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent3,
                                                                  size: 12.0,
                                                                ),
                                                              Text(
                                                                FFAppState().filtroOrdenacao ==
                                                                        'Crescente'
                                                                    ? 'Crescente'
                                                                    : 'Decrescente',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      fontSize:
                                                                          16.0,
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
                                                                    width:
                                                                        8.0)),
                                                          ),
                                                        ),
                                                      if (FFAppState()
                                                              .filtroTipoOrdenacao !=
                                                          '')
                                                        SizedBox(
                                                          height: 100.0,
                                                          child:
                                                              VerticalDivider(
                                                            thickness: 2.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                          ),
                                                        ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                FFAppState()
                                                                    .filtroTipoOrdenacao,
                                                                'Ordernar por',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FFAppState().filtroTipoOrdenacao !=
                                                                            ''
                                                                        ? FlutterFlowTheme.of(context)
                                                                            .secondary
                                                                        : FlutterFlowTheme.of(context)
                                                                            .accent3,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .keyboard_arrow_down,
                                                              color: FFAppState()
                                                                          .filtroTipoOrdenacao !=
                                                                      ''
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent3,
                                                              size: 20.0,
                                                            ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 8.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (containerBodyOfflineListarPropriedadesRowList
                                              .isEmpty)
                                            Builder(
                                              builder: (context) => Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
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
                                                    FFAppState()
                                                            .pagePropriedades =
                                                        'addPropriedades';
                                                    safeSetState(() {});
                                                    await showDialog(
                                                      context: context,
                                                      builder: (dialogContext) {
                                                        return Dialog(
                                                          elevation: 0,
                                                          insetPadding:
                                                              EdgeInsets.zero,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          alignment: const AlignmentDirectional(
                                                                  0.0, 0.0)
                                                              .resolve(
                                                                  Directionality.of(
                                                                      context)),
                                                          child:
                                                              const AddPropriedadeWidget(),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          blurRadius: 4.0,
                                                          color:
                                                              Color(0x41000040),
                                                          offset: Offset(
                                                            2.0,
                                                            2.0,
                                                          ),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(32.0,
                                                              32.0, 32.0, 32.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-lida-ki7iwq/assets/r08famiy2psl/Propriedades9668.png',
                                                              height: 74.0,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          RichText(
                                                            textScaler:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Nenhuma propriedade foi cadastrada.',
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
                                                                const TextSpan(
                                                                  text:
                                                                      '\nClique aqui para adicionar',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF1E7A4C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                )
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ].divide(const SizedBox(
                                                            height: 24.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (containerBodyOfflineListarPropriedadesRowList
                                              .isNotEmpty)
                                            Flexible(
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Builder(
                                                  builder: (context) {
                                                    final propriedade =
                                                        containerBodyOfflineListarPropriedadesRowList
                                                            .where((e) =>
                                                                ((FFAppState().filtroPropAtividades == '') &&
                                                                    (FFAppState().filtroPropEstados ==
                                                                        '') &&
                                                                    (FFAppState().filtroPropCidades ==
                                                                        '') &&
                                                                    (FFAppState().filtroNumeroAnimais ==
                                                                        0.0) &&
                                                                    (_model.pesquisarPropTextController.text ==
                                                                        '')) ||
                                                                (((e.atividades!).contains(
                                                                        FFAppState()
                                                                            .filtroPropAtividades)) &&
                                                                    ((e.cidade == FFAppState().filtroPropCidades) ||
                                                                        (FFAppState().filtroPropCidades ==
                                                                            '')) &&
                                                                    ((e.estado == FFAppState().filtroPropEstados) ||
                                                                        (FFAppState().filtroPropEstados ==
                                                                            '')) &&
                                                                    ((functions.convertIntToDouble(valueOrDefault<
                                                                                int>(
                                                                              (String qtdAnimais) {
                                                                                return qtdAnimais == '[]' ? 0 : qtdAnimais.split(',').length;
                                                                              }(e.rebanhosID!),
                                                                              0,
                                                                            )) ==
                                                                            FFAppState()
                                                                                .filtroNumeroAnimais) ||
                                                                        (FFAppState().filtroNumeroAnimais ==
                                                                            0.0)) &&
                                                                    ((e.nome!)
                                                                        .toLowerCase()
                                                                        .contains(_model
                                                                            .pesquisarPropTextController
                                                                            .text
                                                                            .toLowerCase()))))
                                                            .toList()
                                                            .sortedList(
                                                                keyOf: (e) =>
                                                                    e.createdAt!,
                                                                desc: true)
                                                            .toList();

                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: List.generate(
                                                            propriedade.length,
                                                            (propriedadeIndex) {
                                                          final propriedadeItem =
                                                              propriedade[
                                                                  propriedadeIndex];
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
                                                                      .min,
                                                              children: [
                                                                Builder(
                                                                  builder:
                                                                      (context) =>
                                                                          Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        9.0,
                                                                        0.0,
                                                                        8.0),
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
                                                                        await action_blocks
                                                                            .buscaPropriedade(
                                                                          context,
                                                                          idPropriedade:
                                                                              propriedadeItem.idPropriedade,
                                                                        );
                                                                        await showDialog(
                                                                          barrierColor:
                                                                              Colors.transparent,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (dialogContext) {
                                                                            return Dialog(
                                                                              elevation: 0,
                                                                              insetPadding: EdgeInsets.zero,
                                                                              backgroundColor: Colors.transparent,
                                                                              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                              child: ViewPropriedadesWidget(
                                                                                idPropriedade: propriedadeItem.idPropriedade!,
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: Image.network(
                                                                                      valueOrDefault<String>(
                                                                                        functions.stringToImgPath(valueOrDefault<String>(
                                                                                          propriedadeItem.icone,
                                                                                          'https://5259b9664eda98cebc6cec09d515ad33.cdn.bubble.io/f1729245177676x354205975463888640/mdi_farm6556.png',
                                                                                        )),
                                                                                        'https://5259b9664eda98cebc6cec09d515ad33.cdn.bubble.io/f1729245177676x354205975463888640/mdi_farm6556.png',
                                                                                      ),
                                                                                      width: 24.0,
                                                                                      height: 24.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
                                                                                  child: Text(
                                                                                    valueOrDefault<String>(
                                                                                      propriedadeItem.nome,
                                                                                      'Nome propriedade',
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: const Color(0xFF474747),
                                                                                          fontSize: 16.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  '${valueOrDefault<String>(
                                                                                    propriedadeItem.cidade,
                                                                                    'cidade',
                                                                                  )} - ${valueOrDefault<String>(
                                                                                    propriedadeItem.estado,
                                                                                    'estado',
                                                                                  )}',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: const Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          FaIcon(
                                                                            FontAwesomeIcons.angleRight,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).customColor9,
                                                                            size:
                                                                                16.0,
                                                                          ),
                                                                        ].addToStart(const SizedBox(width: 24.0)).addToEnd(const SizedBox(width: 24.0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  thickness:
                                                                      1.0,
                                                                  color: Color(
                                                                      0xFFEDEDED),
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
                                        ].divide(const SizedBox(height: 16.0)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 16.0),
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
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child:
                                                        const FiltroLotesWidget(),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFBEBEBE),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        16.0, 8.0, 16.0, 8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'Filtrar',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: const Color(
                                                                0xFF5F5F5F),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/images/Filterfiltrar.png',
                                                        width: 16.0,
                                                        height: 16.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ].divide(const SizedBox(
                                                      width: 8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Builder(
                                            builder: (context) {
                                              final filtroLotes = FFAppState()
                                                  .filtroAplicadosLotes
                                                  .toList();

                                              return Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                    filtroLotes.length,
                                                    (filtroLotesIndex) {
                                                  final filtroLotesItem =
                                                      filtroLotes[
                                                          filtroLotesIndex];
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFFBEBEBE),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(16.0,
                                                              8.0, 16.0, 8.0),
                                                      child: Text(
                                                        filtroLotesItem,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: const Color(
                                                                      0xFF5F5F5F),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  );
                                                }).divide(
                                                    const SizedBox(width: 8.0)),
                                              );
                                            },
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
                              if (FFAppState()
                                      .propriedadeSelecionada
                                      .idPropriedade !=
                                  '')
                                Flexible(
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      final containerListarLotesRowList =
                                          snapshot.data!;

                                      return Container(
                                        decoration: const BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 14.0, 0.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 100.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: Builder(
                                                    builder: (context) {
                                                      final lote = containerListarLotesRowList
                                                          .where((e) =>
                                                              ((FFAppState().filtroAtivoLotes == '') &&
                                                                  (e.deletado ==
                                                                      'NAO') &&
                                                                  (_model.pesquisarLoteTextController.text ==
                                                                      '')) ||
                                                              (((e.ativo == FFAppState().filtroAtivoLotes) ||
                                                                      (FFAppState().filtroAtivoLotes ==
                                                                          '')) &&
                                                                  (e.deletado ==
                                                                      'NAO') &&
                                                                  ((e.nome!).toLowerCase().contains(_model
                                                                      .pesquisarLoteTextController
                                                                      .text
                                                                      .toLowerCase()))))
                                                          .toList()
                                                          .sortedList(
                                                              keyOf: (e) =>
                                                                  e.createdAt!,
                                                              desc: true)
                                                          .toList();
                                                      if (lote.isEmpty) {
                                                        return const Center(
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 230.0,
                                                            child:
                                                                EmptyLoteWidget(),
                                                          ),
                                                        );
                                                      }

                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: lote.length,
                                                        itemBuilder: (context,
                                                            loteIndex) {
                                                          final loteItem =
                                                              lote[loteIndex];
                                                          return Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      24.0),
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
                                                                          0.0,
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
                                                                          await action_blocks
                                                                              .buscaRebanhosLote(
                                                                            context,
                                                                            idLote:
                                                                                loteItem.idLote,
                                                                          );
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
                                                                                elevation: 0,
                                                                                insetPadding: EdgeInsets.zero,
                                                                                backgroundColor: Colors.transparent,
                                                                                alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                child: ViewLoteWidget(
                                                                                  idLote: loteItem.idLote!,
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: Image.asset(
                                                                                      'assets/images/Lotes4343434.png',
                                                                                      width: 24.0,
                                                                                      height: 24.0,
                                                                                      fit: BoxFit.contain,
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          valueOrDefault<String>(
                                                                                            loteItem.nome,
                                                                                            'Nome',
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                color: const Color(0xFF474747),
                                                                                                fontSize: 16.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                        Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: valueOrDefault<Color>(
                                                                                              loteItem.ativo == 'Ativo' ? const Color(0xFFD6F5E5) : const Color(0xFFF5D7D4),
                                                                                              const Color(0xFFD6F5E5),
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(100.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 2.0, 8.0, 2.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  valueOrDefault<String>(
                                                                                                            loteItem.ativo,
                                                                                                            'Ativo',
                                                                                                          ) ==
                                                                                                          'Ativo'
                                                                                                      ? 'Ativo'
                                                                                                      : 'Inativo',
                                                                                                  'Ativo',
                                                                                                ),
                                                                                                textAlign: TextAlign.center,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                      color: valueOrDefault<Color>(
                                                                                                        loteItem.ativo == 'Ativo' ? FlutterFlowTheme.of(context).secondary : const Color(0xFFCC3729),
                                                                                                        const Color(0xFF1E7A4C),
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    '${valueOrDefault<String>(
                                                                                      functions.converterJSONparaLista(loteItem.idAnimais!).length.toString(),
                                                                                      '0',
                                                                                    )} animais',
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: const Color(0xFF5F5F5F),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                  if (valueOrDefault<int>(
                                                                                        functions.converterJSONparaLista(loteItem.idAnimais!).length,
                                                                                        0,
                                                                                      ) ==
                                                                                      0)
                                                                                    FlutterFlowIconButton(
                                                                                      borderRadius: 8.0,
                                                                                      buttonSize: 30.0,
                                                                                      fillColor: FlutterFlowTheme.of(context).error,
                                                                                      icon: FaIcon(
                                                                                        FontAwesomeIcons.solidTrashAlt,
                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                        size: 16.0,
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        var confirmDialogResponse = await showDialog<bool>(
                                                                                              context: context,
                                                                                              builder: (alertDialogContext) {
                                                                                                return AlertDialog(
                                                                                                  title: const Text('Apagar lote'),
                                                                                                  content: const Text('Tem certeza que deseja apagar este lote ?'),
                                                                                                  actions: [
                                                                                                    TextButton(
                                                                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                                      child: const Text('Não'),
                                                                                                    ),
                                                                                                    TextButton(
                                                                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                                      child: const Text('Sim'),
                                                                                                    ),
                                                                                                  ],
                                                                                                );
                                                                                              },
                                                                                            ) ??
                                                                                            false;
                                                                                        if (confirmDialogResponse) {
                                                                                          await SQLiteManager.instance.deletarLote(
                                                                                            idLote: loteItem.idLote,
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                    ),
                                                                                ].divide(const SizedBox(height: 2.0)),
                                                                              ),
                                                                            ),
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: Image.asset(
                                                                                'assets/images/Arrowterert.png',
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          ],
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
                                  ),
                                ),
                              if (FFAppState()
                                      .propriedadeSelecionada
                                      .idPropriedade ==
                                  '')
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 24.0, 0.0, 0.0),
                                  child: wrapWithModel(
                                    model: _model.emptyPropModel,
                                    updateCallback: () => safeSetState(() {}),
                                    child: const EmptyPropWidget(),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 40.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child:
                                                      const FiltrosReproducaoWidget(),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                          child: Container(
                                            width: 102.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: const Color(0xFFBEBEBE),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 8.0, 16.0, 8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Filtrar',
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
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/Filter.png',
                                                      width: 16.0,
                                                      height: 16.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ].divide(
                                                    const SizedBox(width: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (FFAppState()
                                                .filtroPrevisaoPartoTxt !=
                                            '')
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: const Color(0xFFBEBEBE),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 8.0, 16.0, 8.0),
                                              child: Text(
                                                FFAppState()
                                                    .filtroPrevisaoPartoTxt,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: const Color(
                                                          0xFF5F5F5F),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        if (FFAppState()
                                                .filtroDataReproducaoTxt !=
                                            '')
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: const Color(0xFFBEBEBE),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 8.0, 16.0, 8.0),
                                              child: Text(
                                                FFAppState()
                                                    .filtroDataReproducaoTxt,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: const Color(
                                                          0xFF5F5F5F),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        Builder(
                                          builder: (context) {
                                            final filtroRepro = FFAppState()
                                                .filtrosAplicadosReproducao
                                                .toList();

                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: List.generate(
                                                  filtroRepro.length,
                                                  (filtroReproIndex) {
                                                final filtroReproItem =
                                                    filtroRepro[
                                                        filtroReproIndex];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFFBEBEBE),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 8.0,
                                                            16.0, 8.0),
                                                    child: Text(
                                                      filtroReproItem,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: const Color(
                                                                0xFF5F5F5F),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              }).divide(
                                                  const SizedBox(width: 8.0)),
                                            );
                                          },
                                        ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child:
                                    FutureBuilder<List<ListarReproducoesRow>>(
                                  future:
                                      SQLiteManager.instance.listarReproducoes(
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final containerListarReproducoesRowList =
                                        snapshot.data!;

                                    return Container(
                                      decoration: const BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (!(containerListarReproducoesRowList
                                              .isNotEmpty))
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 48.0, 24.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(32.0, 32.0,
                                                          32.0, 32.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/Reproduoreproducao.png',
                                                          height: 74.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Nenhuma reprodução foi cadastrada nesta propriedade (${FFAppState().propriedadeSelecionada.nome}).',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            )
                                                          ],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ].divide(const SizedBox(
                                                        height: 24.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                if (FFAppState()
                                                        .filtroDataReproducao !=
                                                    null) {
                                                  return Visibility(
                                                    visible:
                                                        containerListarReproducoesRowList
                                                            .isNotEmpty,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              14.0, 0.0, 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final reproducao = containerListarReproducoesRowList
                                                                .where((e) =>
                                                                    ((FFAppState().filtroReproducao == '') &&
                                                                        (FFAppState().filtroInseminador ==
                                                                            '') &&
                                                                        (FFAppState().filtroMatrizReproducao ==
                                                                            '') &&
                                                                        (FFAppState().filtroReprodutorReproducao ==
                                                                            '') &&
                                                                        (FFAppState()
                                                                                .filtroLoteReproducao ==
                                                                            '') &&
                                                                        (e.deletado ==
                                                                            'NAO') &&
                                                                        (FFAppState()
                                                                                .filtroDataReproducao ==
                                                                            null) &&
                                                                        (_model.pesquisarRepTextController
                                                                                .text ==
                                                                            '')) ||
                                                                    (((FFAppState().filtroReproducao == e.tipoReproducao) ||
                                                                            (FFAppState().filtroReproducao ==
                                                                                '')) &&
                                                                        ((e.inseminador == FFAppState().filtroInseminador) ||
                                                                            (FFAppState().filtroInseminador ==
                                                                                '')) &&
                                                                        ((FFAppState().filtroMatrizReproducao ==
                                                                                '') ||
                                                                            ((e.nomeMatriz!).contains(FFAppState().filtroMatrizReproducao))) &&
                                                                        ((FFAppState().filtroReprodutorReproducao == '') || ((e.nomeReprodutor!).contains(FFAppState().filtroReprodutorReproducao))) &&
                                                                        ((FFAppState().filtroLoteReproducao == '') || ((e.loteNome!).contains(FFAppState().filtroLoteReproducao))) &&
                                                                        (e.deletado == 'NAO') &&
                                                                        (((functions.converterParaData(e.createdAt)! >= FFAppState().filtroDataReproducao!) && (functions.converterParaData(e.createdAt)! <= getCurrentTimestamp)) || (FFAppState().filtroDataReproducao == null)) &&
                                                                        ((e.dataInseminacao!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()) || (e.dataInicial!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()) || (e.dataFinal!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()))))
                                                                .toList()
                                                                .sortedList(keyOf: (e) => e.createdAt!, desc: true)
                                                                .toList();
                                                            if (reproducao
                                                                .isEmpty) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  height: 200.0,
                                                                  child:
                                                                      EmptyReproducaoWidget(),
                                                                ),
                                                              );
                                                            }

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  reproducao
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  reproducaoIndex) {
                                                                final reproducaoItem =
                                                                    reproducao[
                                                                        reproducaoIndex];
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
                                                                      Divider(
                                                                        thickness:
                                                                            1.0,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                      ),
                                                                      Builder(
                                                                        builder:
                                                                            (context) =>
                                                                                Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              24.0,
                                                                              8.0,
                                                                              24.0,
                                                                              8.0),
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
                                                                              if (reproducaoItem.categoria == 'rebanho') {
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
                                                                                      child: ViewReproducaoRebanhoWidget(
                                                                                        idReproducao: reproducaoItem.idReproducao!,
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
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
                                                                                      child: ViewReproducaoLoteWidget(
                                                                                        idReproducao: reproducaoItem.idReproducao!,
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Reproducao5675.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                          ClipRRect(
                                                                                            borderRadius: const BorderRadius.only(
                                                                                              bottomLeft: Radius.circular(100.0),
                                                                                              bottomRight: Radius.circular(100.0),
                                                                                              topLeft: Radius.circular(100.0),
                                                                                              topRight: Radius.circular(100.0),
                                                                                            ),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: const BoxDecoration(
                                                                                                color: Color(0xFFF1F1F1),
                                                                                                borderRadius: BorderRadius.only(
                                                                                                  bottomLeft: Radius.circular(100.0),
                                                                                                  bottomRight: Radius.circular(100.0),
                                                                                                  topLeft: Radius.circular(100.0),
                                                                                                  topRight: Radius.circular(100.0),
                                                                                                ),
                                                                                              ),
                                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                                child: Text(
                                                                                                  '${valueOrDefault<String>(
                                                                                                    reproducaoItem.tipoReproducao,
                                                                                                    '--',
                                                                                                  )} (${reproducaoItem.tipoReproducao == 'Inseminação' ? dateTimeFormat(
                                                                                                      "dd/MM/yy",
                                                                                                      functions.converterParaData(reproducaoItem.dataInseminacao),
                                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                                    ) : dateTimeFormat(
                                                                                                      "dd/MM/yy",
                                                                                                      functions.converterParaData(reproducaoItem.dataInicial),
                                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                                    )})',
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                        font: GoogleFonts.poppins(
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                        ),
                                                                                                        color: const Color(0xFF5F5F5F),
                                                                                                        fontSize: 10.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ].divide(const SizedBox(width: 8.0)),
                                                                                      ),
                                                                                      if (reproducaoItem.categoria == 'rebanho')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                              child: Image.asset(
                                                                                                'assets/images/Sexofemea.png',
                                                                                                width: 24.0,
                                                                                                height: 24.0,
                                                                                                fit: BoxFit.scaleDown,
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 7.0, 0.0),
                                                                                              child: Text(
                                                                                                'Matriz:',
                                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                      font: GoogleFonts.poppins(
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
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: Align(
                                                                                                alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                                child: Text(
                                                                                                  valueOrDefault<String>(
                                                                                                    '${valueOrDefault<String>(
                                                                                                      reproducaoItem.numMatriz,
                                                                                                      '--',
                                                                                                    )} • ${valueOrDefault<String>(
                                                                                                      reproducaoItem.nomeMatriz,
                                                                                                      '--',
                                                                                                    )} • ${dateTimeFormat(
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
                                                                                                        color: const Color(0xFF474747),
                                                                                                        fontSize: 14.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 3.0)),
                                                                                        ),
                                                                                      if (reproducaoItem.categoria == 'lote')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                              child: Image.asset(
                                                                                                'assets/images/Lotes887.png',
                                                                                                width: 24.0,
                                                                                                height: 24.0,
                                                                                                fit: BoxFit.scaleDown,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'Lote:',
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                            Flexible(
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  reproducaoItem.loteNome,
                                                                                                  '--',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                      font: GoogleFonts.poppins(
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
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 3.0)),
                                                                                        ),
                                                                                      if (reproducaoItem.tipoReproducao == 'Inseminação')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: const BorderRadius.only(
                                                                                                bottomLeft: Radius.circular(100.0),
                                                                                                bottomRight: Radius.circular(100.0),
                                                                                                topLeft: Radius.circular(100.0),
                                                                                                topRight: Radius.circular(100.0),
                                                                                              ),
                                                                                              child: Container(
                                                                                                height: 23.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: colorFromCssString(
                                                                                                    reproducaoItem.statusReproducao == 'Prenhez' ? '#EFF5D4' : '#f5d7d4',
                                                                                                    defaultColor: const Color(0xFFF5D7D4),
                                                                                                  ),
                                                                                                  borderRadius: const BorderRadius.only(
                                                                                                    bottomLeft: Radius.circular(100.0),
                                                                                                    bottomRight: Radius.circular(100.0),
                                                                                                    topLeft: Radius.circular(100.0),
                                                                                                    topRight: Radius.circular(100.0),
                                                                                                  ),
                                                                                                ),
                                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                                  child: Text(
                                                                                                    valueOrDefault<String>(
                                                                                                      '${reproducaoItem.statusReproducao} (${dateTimeFormat(
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
                                                                                                            defaultColor: const Color(0xFFCC3729),
                                                                                                          ),
                                                                                                          fontSize: 10.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                        ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 8.0)),
                                                                                        ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Sexomacho.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            'Reprodutor:',
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  font: GoogleFonts.poppins(
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
                                                                                          Flexible(
                                                                                            child: Text(
                                                                                              valueOrDefault<String>(
                                                                                                reproducaoItem.nomeReprodutor,
                                                                                                '--',
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                          ),
                                                                                        ].divide(const SizedBox(width: 3.0)),
                                                                                      ),
                                                                                      if (reproducaoItem.tipoReproducao == 'Inseminação')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Previsão de parto:',
                                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                        font: GoogleFonts.poppins(
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                        ),
                                                                                                        color: const Color(0xFF474747),
                                                                                                        fontSize: 14.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ].divide(const SizedBox(width: 5.0)),
                                                                                            ),
                                                                                            Text(
                                                                                              dateTimeFormat(
                                                                                                "dd/MM/yy",
                                                                                                functions.converterParaData(reproducaoItem.previsaoParto),
                                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                          ].divide(const SizedBox(width: 3.0)),
                                                                                        ),
                                                                                    ].divide(const SizedBox(height: 4.0)),
                                                                                  ),
                                                                                ),
                                                                                Icon(
                                                                                  Icons.chevron_right,
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
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
                                                    ),
                                                  );
                                                } else if (FFAppState()
                                                        .filtroDataParto !=
                                                    null) {
                                                  return Visibility(
                                                    visible:
                                                        containerListarReproducoesRowList
                                                            .isNotEmpty,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              14.0, 0.0, 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final reproducao = containerListarReproducoesRowList
                                                                .where((e) =>
                                                                    ((FFAppState().filtroReproducao == '') &&
                                                                        (FFAppState().filtroInseminador ==
                                                                            '') &&
                                                                        (FFAppState().filtroMatrizReproducao ==
                                                                            '') &&
                                                                        (FFAppState().filtroReprodutorReproducao ==
                                                                            '') &&
                                                                        (FFAppState()
                                                                                .filtroLoteReproducao ==
                                                                            '') &&
                                                                        (e.deletado ==
                                                                            'NAO') &&
                                                                        (FFAppState()
                                                                                .filtroDataParto ==
                                                                            null) &&
                                                                        (_model.pesquisarRepTextController
                                                                                .text ==
                                                                            '')) ||
                                                                    (((FFAppState().filtroReproducao == e.tipoReproducao) ||
                                                                            (FFAppState().filtroReproducao ==
                                                                                '')) &&
                                                                        ((e.inseminador == FFAppState().filtroInseminador) ||
                                                                            (FFAppState().filtroInseminador ==
                                                                                '')) &&
                                                                        ((FFAppState().filtroMatrizReproducao ==
                                                                                '') ||
                                                                            ((e.nomeMatriz!).contains(FFAppState().filtroMatrizReproducao))) &&
                                                                        ((FFAppState().filtroReprodutorReproducao == '') || ((e.nomeReprodutor!).contains(FFAppState().filtroReprodutorReproducao))) &&
                                                                        ((FFAppState().filtroLoteReproducao == '') || ((e.loteNome!).contains(FFAppState().filtroLoteReproducao))) &&
                                                                        (e.deletado == 'NAO') &&
                                                                        (((functions.converterParaData(e.previsaoParto)! >= getCurrentTimestamp) && (functions.converterParaData(e.previsaoParto)! <= FFAppState().filtroDataParto!)) || (FFAppState().filtroDataParto == null)) &&
                                                                        ((e.dataInseminacao!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()) || (e.dataInicial!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()) || (e.dataFinal!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()))))
                                                                .toList()
                                                                .sortedList(keyOf: (e) => e.createdAt!, desc: true)
                                                                .toList();
                                                            if (reproducao
                                                                .isEmpty) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  height: 200.0,
                                                                  child:
                                                                      EmptyReproducaoWidget(),
                                                                ),
                                                              );
                                                            }

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  reproducao
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  reproducaoIndex) {
                                                                final reproducaoItem =
                                                                    reproducao[
                                                                        reproducaoIndex];
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
                                                                      Divider(
                                                                        thickness:
                                                                            1.0,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                      ),
                                                                      Builder(
                                                                        builder:
                                                                            (context) =>
                                                                                Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              24.0,
                                                                              8.0,
                                                                              24.0,
                                                                              8.0),
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
                                                                              if (reproducaoItem.categoria == 'rebanho') {
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
                                                                                      child: ViewReproducaoRebanhoWidget(
                                                                                        idReproducao: reproducaoItem.idReproducao!,
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
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
                                                                                      child: ViewReproducaoLoteWidget(
                                                                                        idReproducao: reproducaoItem.idReproducao!,
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Reproducao5675.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                          ClipRRect(
                                                                                            borderRadius: const BorderRadius.only(
                                                                                              bottomLeft: Radius.circular(100.0),
                                                                                              bottomRight: Radius.circular(100.0),
                                                                                              topLeft: Radius.circular(100.0),
                                                                                              topRight: Radius.circular(100.0),
                                                                                            ),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: const BoxDecoration(
                                                                                                color: Color(0xFFF1F1F1),
                                                                                                borderRadius: BorderRadius.only(
                                                                                                  bottomLeft: Radius.circular(100.0),
                                                                                                  bottomRight: Radius.circular(100.0),
                                                                                                  topLeft: Radius.circular(100.0),
                                                                                                  topRight: Radius.circular(100.0),
                                                                                                ),
                                                                                              ),
                                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                                child: Text(
                                                                                                  '${valueOrDefault<String>(
                                                                                                    reproducaoItem.tipoReproducao,
                                                                                                    '--',
                                                                                                  )} (${reproducaoItem.tipoReproducao == 'Inseminação' ? dateTimeFormat(
                                                                                                      "dd/MM/yy",
                                                                                                      functions.converterParaData(reproducaoItem.dataInseminacao),
                                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                                    ) : dateTimeFormat(
                                                                                                      "dd/MM/yy",
                                                                                                      functions.converterParaData(reproducaoItem.dataInicial),
                                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                                    )})',
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                        font: GoogleFonts.poppins(
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                        ),
                                                                                                        color: const Color(0xFF5F5F5F),
                                                                                                        fontSize: 10.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ].divide(const SizedBox(width: 8.0)),
                                                                                      ),
                                                                                      if (reproducaoItem.categoria == 'rebanho')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                              child: Image.asset(
                                                                                                'assets/images/Sexofemea.png',
                                                                                                width: 24.0,
                                                                                                height: 24.0,
                                                                                                fit: BoxFit.scaleDown,
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 7.0, 0.0),
                                                                                              child: Text(
                                                                                                'Matriz:',
                                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                      font: GoogleFonts.poppins(
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
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: Align(
                                                                                                alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                                child: Text(
                                                                                                  valueOrDefault<String>(
                                                                                                    '${valueOrDefault<String>(
                                                                                                      reproducaoItem.numMatriz,
                                                                                                      '--',
                                                                                                    )} • ${valueOrDefault<String>(
                                                                                                      reproducaoItem.nomeMatriz,
                                                                                                      '--',
                                                                                                    )} • ${dateTimeFormat(
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
                                                                                                        color: const Color(0xFF474747),
                                                                                                        fontSize: 14.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 3.0)),
                                                                                        ),
                                                                                      if (reproducaoItem.categoria == 'lote')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                              child: Image.asset(
                                                                                                'assets/images/Lotes887.png',
                                                                                                width: 24.0,
                                                                                                height: 24.0,
                                                                                                fit: BoxFit.scaleDown,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'Lote:',
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                            Flexible(
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  reproducaoItem.loteNome,
                                                                                                  '--',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                      font: GoogleFonts.poppins(
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
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 3.0)),
                                                                                        ),
                                                                                      if (reproducaoItem.tipoReproducao == 'Inseminação')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: const BorderRadius.only(
                                                                                                bottomLeft: Radius.circular(100.0),
                                                                                                bottomRight: Radius.circular(100.0),
                                                                                                topLeft: Radius.circular(100.0),
                                                                                                topRight: Radius.circular(100.0),
                                                                                              ),
                                                                                              child: Container(
                                                                                                height: 23.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: colorFromCssString(
                                                                                                    reproducaoItem.statusReproducao == 'Prenhez' ? '#EFF5D4' : '#f5d7d4',
                                                                                                    defaultColor: const Color(0xFFF5D7D4),
                                                                                                  ),
                                                                                                  borderRadius: const BorderRadius.only(
                                                                                                    bottomLeft: Radius.circular(100.0),
                                                                                                    bottomRight: Radius.circular(100.0),
                                                                                                    topLeft: Radius.circular(100.0),
                                                                                                    topRight: Radius.circular(100.0),
                                                                                                  ),
                                                                                                ),
                                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                                  child: Text(
                                                                                                    valueOrDefault<String>(
                                                                                                      '${reproducaoItem.statusReproducao} (${dateTimeFormat(
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
                                                                                                            defaultColor: const Color(0xFFCC3729),
                                                                                                          ),
                                                                                                          fontSize: 10.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                        ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 8.0)),
                                                                                        ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Sexomacho.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            'Reprodutor:',
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  font: GoogleFonts.poppins(
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
                                                                                          Flexible(
                                                                                            child: Text(
                                                                                              valueOrDefault<String>(
                                                                                                reproducaoItem.nomeReprodutor,
                                                                                                '--',
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                          ),
                                                                                        ].divide(const SizedBox(width: 3.0)),
                                                                                      ),
                                                                                      if (reproducaoItem.tipoReproducao == 'Inseminação')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Previsão de parto:',
                                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                        font: GoogleFonts.poppins(
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                        ),
                                                                                                        color: const Color(0xFF474747),
                                                                                                        fontSize: 14.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ].divide(const SizedBox(width: 5.0)),
                                                                                            ),
                                                                                            Text(
                                                                                              dateTimeFormat(
                                                                                                "dd/MM/yy",
                                                                                                functions.converterParaData(reproducaoItem.previsaoParto),
                                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                          ].divide(const SizedBox(width: 3.0)),
                                                                                        ),
                                                                                    ].divide(const SizedBox(height: 4.0)),
                                                                                  ),
                                                                                ),
                                                                                Icon(
                                                                                  Icons.chevron_right,
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
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
                                                    ),
                                                  );
                                                } else {
                                                  return Visibility(
                                                    visible:
                                                        containerListarReproducoesRowList
                                                            .isNotEmpty,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              14.0, 0.0, 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                        ),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final reproducao = containerListarReproducoesRowList
                                                                .where((e) =>
                                                                    ((FFAppState().filtroReproducao == '') &&
                                                                        (FFAppState().filtroInseminador ==
                                                                            '') &&
                                                                        (FFAppState().filtroMatrizReproducao ==
                                                                            '') &&
                                                                        (FFAppState()
                                                                                .filtroReprodutorReproducao ==
                                                                            '') &&
                                                                        (FFAppState()
                                                                                .filtroLoteReproducao ==
                                                                            '') &&
                                                                        (e.deletado ==
                                                                            'NAO') &&
                                                                        (_model.pesquisarRepTextController
                                                                                .text ==
                                                                            '')) ||
                                                                    (((FFAppState().filtroReproducao == e.tipoReproducao) ||
                                                                            (FFAppState().filtroReproducao ==
                                                                                '')) &&
                                                                        ((e.inseminador == FFAppState().filtroInseminador) ||
                                                                            (FFAppState().filtroInseminador ==
                                                                                '')) &&
                                                                        ((FFAppState().filtroMatrizReproducao ==
                                                                                '') ||
                                                                            ((e.nomeMatriz!).contains(FFAppState().filtroMatrizReproducao))) &&
                                                                        ((FFAppState().filtroReprodutorReproducao == '') || ((e.nomeReprodutor!).contains(FFAppState().filtroReprodutorReproducao))) &&
                                                                        ((FFAppState().filtroLoteReproducao == '') || ((e.loteNome!).contains(FFAppState().filtroLoteReproducao))) &&
                                                                        (e.deletado == 'NAO') &&
                                                                        ((e.dataInseminacao!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()) || (e.dataInicial!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()) || (e.dataFinal!).toLowerCase().contains(_model.pesquisarRepTextController.text.toLowerCase()))))
                                                                .toList()
                                                                .sortedList(keyOf: (e) => e.createdAt!, desc: true)
                                                                .toList();
                                                            if (reproducao
                                                                .isEmpty) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  height: 200.0,
                                                                  child:
                                                                      EmptyReproducaoWidget(),
                                                                ),
                                                              );
                                                            }

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  reproducao
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  reproducaoIndex) {
                                                                final reproducaoItem =
                                                                    reproducao[
                                                                        reproducaoIndex];
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
                                                                      Divider(
                                                                        thickness:
                                                                            1.0,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                      ),
                                                                      Builder(
                                                                        builder:
                                                                            (context) =>
                                                                                Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              24.0,
                                                                              8.0,
                                                                              24.0,
                                                                              8.0),
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
                                                                              if (reproducaoItem.categoria == 'rebanho') {
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
                                                                                      child: ViewReproducaoRebanhoWidget(
                                                                                        idReproducao: reproducaoItem.idReproducao!,
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
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
                                                                                      child: ViewReproducaoLoteWidget(
                                                                                        idReproducao: reproducaoItem.idReproducao!,
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Reproducao5675.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                          ClipRRect(
                                                                                            borderRadius: const BorderRadius.only(
                                                                                              bottomLeft: Radius.circular(100.0),
                                                                                              bottomRight: Radius.circular(100.0),
                                                                                              topLeft: Radius.circular(100.0),
                                                                                              topRight: Radius.circular(100.0),
                                                                                            ),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: const BoxDecoration(
                                                                                                color: Color(0xFFF1F1F1),
                                                                                                borderRadius: BorderRadius.only(
                                                                                                  bottomLeft: Radius.circular(100.0),
                                                                                                  bottomRight: Radius.circular(100.0),
                                                                                                  topLeft: Radius.circular(100.0),
                                                                                                  topRight: Radius.circular(100.0),
                                                                                                ),
                                                                                              ),
                                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                                                child: Text(
                                                                                                  '${valueOrDefault<String>(
                                                                                                    reproducaoItem.tipoReproducao,
                                                                                                    '--',
                                                                                                  )} (${reproducaoItem.tipoReproducao == 'Inseminação' ? dateTimeFormat(
                                                                                                      "dd/MM/yy",
                                                                                                      functions.converterParaData(reproducaoItem.dataInseminacao),
                                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                                    ) : dateTimeFormat(
                                                                                                      "dd/MM/yy",
                                                                                                      functions.converterParaData(reproducaoItem.dataInicial),
                                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                                    )})',
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                        font: GoogleFonts.poppins(
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                        ),
                                                                                                        color: const Color(0xFF5F5F5F),
                                                                                                        fontSize: 10.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ].divide(const SizedBox(width: 8.0)),
                                                                                      ),
                                                                                      if (reproducaoItem.categoria == 'rebanho')
                                                                                        Container(
                                                                                          decoration: const BoxDecoration(),
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              ClipRRect(
                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                child: Image.asset(
                                                                                                  'assets/images/Sexofemea.png',
                                                                                                  width: 24.0,
                                                                                                  height: 24.0,
                                                                                                  fit: BoxFit.scaleDown,
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 7.0, 0.0),
                                                                                                child: Text(
                                                                                                  'Matriz:',
                                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                        font: GoogleFonts.poppins(
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
                                                                                              ),
                                                                                              Flexible(
                                                                                                child: Text(
                                                                                                  valueOrDefault<String>(
                                                                                                    '${valueOrDefault<String>(
                                                                                                      reproducaoItem.numMatriz,
                                                                                                      '--',
                                                                                                    )} • ${valueOrDefault<String>(
                                                                                                      reproducaoItem.nomeMatriz,
                                                                                                      '--',
                                                                                                    )} • ${dateTimeFormat(
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
                                                                                                        color: const Color(0xFF474747),
                                                                                                        fontSize: 14.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                            ].divide(const SizedBox(width: 3.0)),
                                                                                          ),
                                                                                        ),
                                                                                      if (reproducaoItem.categoria == 'lote')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                              child: Image.asset(
                                                                                                'assets/images/Lotes887.png',
                                                                                                width: 24.0,
                                                                                                height: 24.0,
                                                                                                fit: BoxFit.scaleDown,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'Lote:',
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                            Flexible(
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  reproducaoItem.loteNome,
                                                                                                  '--',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                      font: GoogleFonts.poppins(
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
                                                                                            ),
                                                                                          ].divide(const SizedBox(width: 3.0)),
                                                                                        ),
                                                                                      if (reproducaoItem.tipoReproducao == 'Inseminação')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              borderRadius: const BorderRadius.only(
                                                                                                bottomLeft: Radius.circular(100.0),
                                                                                                bottomRight: Radius.circular(100.0),
                                                                                                topLeft: Radius.circular(100.0),
                                                                                                topRight: Radius.circular(100.0),
                                                                                              ),
                                                                                              child: Container(
                                                                                                height: 23.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: colorFromCssString(
                                                                                                    reproducaoItem.statusReproducao == 'Prenhez' ? '#EFF5D4' : '#f5d7d4',
                                                                                                    defaultColor: const Color(0xFFF5D7D4),
                                                                                                  ),
                                                                                                  borderRadius: const BorderRadius.only(
                                                                                                    bottomLeft: Radius.circular(100.0),
                                                                                                    bottomRight: Radius.circular(100.0),
                                                                                                    topLeft: Radius.circular(100.0),
                                                                                                    topRight: Radius.circular(100.0),
                                                                                                  ),
                                                                                                ),
                                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
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
                                                                                                                reproducaoItem.statusReproducao == 'Prenhez' ? '#1e7a4c' : '#cc3729',
                                                                                                                defaultColor: const Color(0xFFCC3729),
                                                                                                              ),
                                                                                                              fontSize: 10.0,
                                                                                                              letterSpacing: 0.0,
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                            ),
                                                                                                      ),
                                                                                                      if (reproducaoItem.statusReproducao != 'Não diagnosticado')
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
                                                                                                                  defaultColor: const Color(0xFFCC3729),
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
                                                                                          ].divide(const SizedBox(width: 8.0)),
                                                                                        ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Sexomacho.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            'Reprodutor:',
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  font: GoogleFonts.poppins(
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
                                                                                          Flexible(
                                                                                            child: Text(
                                                                                              valueOrDefault<String>(
                                                                                                reproducaoItem.nomeReprodutor,
                                                                                                '--',
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                          ),
                                                                                        ].divide(const SizedBox(width: 3.0)),
                                                                                      ),
                                                                                      if (reproducaoItem.tipoReproducao == 'Inseminação')
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Previsão de parto:',
                                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                        font: GoogleFonts.poppins(
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                        ),
                                                                                                        color: const Color(0xFF474747),
                                                                                                        fontSize: 14.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ].divide(const SizedBox(width: 5.0)),
                                                                                            ),
                                                                                            Text(
                                                                                              dateTimeFormat(
                                                                                                "dd/MM/yy",
                                                                                                functions.converterParaData(reproducaoItem.previsaoParto),
                                                                                                locale: FFLocalizations.of(context).languageCode,
                                                                                              ),
                                                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                    font: GoogleFonts.poppins(
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
                                                                                          ].divide(const SizedBox(width: 3.0)),
                                                                                        ),
                                                                                    ].divide(const SizedBox(height: 4.0)),
                                                                                  ),
                                                                                ),
                                                                                Icon(
                                                                                  Icons.chevron_right,
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
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
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 16.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child:
                                                      const FiltroSanidadesWidget(),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: const Color(0xFFBEBEBE),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 8.0, 16.0, 8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Filtrar',
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
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/Filter78978.png',
                                                      width: 16.0,
                                                      height: 16.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ].divide(
                                                    const SizedBox(width: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (FFAppState()
                                                .filtroDataSanidadeTxt !=
                                            '')
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: const Color(0xFFBEBEBE),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 8.0, 16.0, 8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    FFAppState()
                                                        .filtroDataSanidadeTxt,
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
                                                ].divide(
                                                    const SizedBox(width: 8.0)),
                                              ),
                                            ),
                                          ),
                                        Builder(
                                          builder: (context) {
                                            final sanidade = FFAppState()
                                                .filtrosSanidades
                                                .toList();

                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: List.generate(
                                                  sanidade.length,
                                                  (sanidadeIndex) {
                                                final sanidadeItem =
                                                    sanidade[sanidadeIndex];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFFBEBEBE),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 8.0,
                                                            16.0, 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          sanidadeItem,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          width: 8.0)),
                                                    ),
                                                  ),
                                                );
                                              }).divide(
                                                  const SizedBox(width: 8.0)),
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
                                child: FutureBuilder<List<ListarSanidadesRow>>(
                                  future:
                                      SQLiteManager.instance.listarSanidades(
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final containerListarSanidadesRowList =
                                        snapshot.data!;

                                    return Container(
                                      decoration: const BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (!(containerListarSanidadesRowList
                                              .isNotEmpty))
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 24.0, 24.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(32.0, 32.0,
                                                          32.0, 32.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/Sanidadesan.png',
                                                          height: 74.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Nenhuma sanidade foi cadastrada nesta propriedade (${FFAppState().propriedadeSelecionada.nome}).',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            )
                                                          ],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ].divide(const SizedBox(
                                                        height: 24.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (containerListarSanidadesRowList
                                              .isNotEmpty)
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 14.0, 0.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: Builder(
                                                    builder: (context) {
                                                      if (FFAppState()
                                                              .filtroDataSanidade ==
                                                          null) {
                                                        return Builder(
                                                          builder: (context) {
                                                            final sanidades = containerListarSanidadesRowList
                                                                .where((e) =>
                                                                    ((FFAppState().filtroVacinacao == '') &&
                                                                        (FFAppState().filtroAntiparasitario ==
                                                                            '') &&
                                                                        (FFAppState().filtroTratamento ==
                                                                            '') &&
                                                                        (FFAppState().filtroProtocoloReprodutivo ==
                                                                            '') &&
                                                                        (FFAppState().filtroLoteSanidade ==
                                                                            '') &&
                                                                        (FFAppState().filtroSanidadeAnimal ==
                                                                            '') &&
                                                                        (e.deletado ==
                                                                            'NAO') &&
                                                                        (_model.pesquisarTextController.text ==
                                                                            '')) ||
                                                                    (((FFAppState().filtroVacinacao == '') || (e.vacinacao?.contains(FFAppState().filtroVacinacao) ?? false)) &&
                                                                        ((FFAppState().filtroAntiparasitario == '') ||
                                                                            (e.antiparasitario?.contains(FFAppState().filtroAntiparasitario) ??
                                                                                false)) &&
                                                                        ((FFAppState().filtroTratamento == '') ||
                                                                            (e.tratamento?.contains(FFAppState().filtroTratamento) ??
                                                                                false)) &&
                                                                        ((e.protocoloReprodutivo?.contains(FFAppState().filtroProtocoloReprodutivo) ?? false) ||
                                                                            (FFAppState().filtroProtocoloReprodutivo ==
                                                                                '')) &&
                                                                        ((e.idLote == FFAppState().filtroLoteSanidade) ||
                                                                            (FFAppState().filtroLoteSanidade == '')) &&
                                                                        ((e.idRebanho == FFAppState().filtroSanidadeAnimal) || (FFAppState().filtroSanidadeAnimal == '')) &&
                                                                        (e.deletado == 'NAO') &&
                                                                        ((e.vacinacao!).toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()) || (e.antiparasitario!).toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()) || (e.tratamento!).toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()) || (e.protocoloReprodutivo!).toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()))))
                                                                .toList()
                                                                .sortedList(keyOf: (e) => e.createdAt!, desc: true)
                                                                .toList();
                                                            if (sanidades
                                                                .isEmpty) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  height: 200.0,
                                                                  child:
                                                                      EmptySanidadeWidget(),
                                                                ),
                                                              );
                                                            }

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  sanidades
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  sanidadesIndex) {
                                                                final sanidadesItem =
                                                                    sanidades[
                                                                        sanidadesIndex];
                                                                return FutureBuilder<
                                                                    List<
                                                                        BuscarLoteRow>>(
                                                                  future: SQLiteManager
                                                                      .instance
                                                                      .buscarLote(
                                                                    idLote: sanidadesItem
                                                                        .idLote,
                                                                  ),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    // Customize what your widget looks like when it's loading.
                                                                    if (!snapshot
                                                                        .hasData) {
                                                                      return Center(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              50.0,
                                                                          height:
                                                                              50.0,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final containerBuscarLoteRowList =
                                                                        snapshot
                                                                            .data!;

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
                                                                              sanidadesItem.idRebanho,
                                                                        ),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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
                                                                          final containerBuscarRebanhoRowList =
                                                                              snapshot.data!;

                                                                          return Container(
                                                                            width:
                                                                                double.infinity,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Builder(
                                                                                  builder: (context) => Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        if (sanidadesItem.idRebanho != null && sanidadesItem.idRebanho != '') {
                                                                                          FFAppState().sanidadeSelecionada = SanidadeStruct(
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
                                                                                        } else {
                                                                                          FFAppState().sanidadeSelecionada = SanidadeStruct(
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
                                                                                                child: const EditSanidadeLoteWidget(),
                                                                                              );
                                                                                            },
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
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
                                                                                          if (sanidadesItem.vacinacao != 'null')
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
                                                                                          if (sanidadesItem.antiparasitario != 'null')
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
                                                                                          if (sanidadesItem.protocoloReprodutivo != 'null')
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
                                                                                                  Builder(
                                                                                                    builder: (context) {
                                                                                                      final protocolo = functions.converterJSONparaLista(sanidadesItem.protocoloReprodutivo!).toList();

                                                                                                      return SingleChildScrollView(
                                                                                                        scrollDirection: Axis.horizontal,
                                                                                                        child: Row(
                                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                                          children: List.generate(protocolo.length, (protocoloIndex) {
                                                                                                            final protocoloItem = protocolo[protocoloIndex];
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
                                                                                                                      protocoloItem,
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
                                                                                          if (sanidadesItem.tratamento != 'null')
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
                                                                                        ].divide(const SizedBox(height: 8.0)),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Divider(
                                                                                  thickness: 1.0,
                                                                                  color: FlutterFlowTheme.of(context).alternate,
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
                                                        );
                                                      } else {
                                                        return Builder(
                                                          builder: (context) {
                                                            final sanidades = containerListarSanidadesRowList
                                                                .where((e) =>
                                                                    ((FFAppState().filtroVacinacao == '') &&
                                                                        (FFAppState().filtroAntiparasitario ==
                                                                            '') &&
                                                                        (FFAppState().filtroTratamento ==
                                                                            '') &&
                                                                        (FFAppState().filtroProtocoloReprodutivo ==
                                                                            '') &&
                                                                        (FFAppState().filtroLoteSanidade ==
                                                                            '') &&
                                                                        (FFAppState().filtroSanidadeAnimal ==
                                                                            '') &&
                                                                        (e.deletado ==
                                                                            'NAO') &&
                                                                        (FFAppState().filtroDataSanidade ==
                                                                            null) &&
                                                                        (_model.pesquisarTextController.text ==
                                                                            '')) ||
                                                                    (((FFAppState().filtroVacinacao == '') || (e.vacinacao?.contains(FFAppState().filtroVacinacao) ?? false)) &&
                                                                        ((FFAppState().filtroAntiparasitario == '') ||
                                                                            (e.antiparasitario?.contains(FFAppState().filtroAntiparasitario) ??
                                                                                false)) &&
                                                                        ((FFAppState().filtroTratamento == '') ||
                                                                            (e.tratamento?.contains(FFAppState().filtroTratamento) ??
                                                                                false)) &&
                                                                        ((e.protocoloReprodutivo?.contains(FFAppState().filtroProtocoloReprodutivo) ?? false) ||
                                                                            (FFAppState().filtroProtocoloReprodutivo ==
                                                                                '')) &&
                                                                        ((e.idLote == FFAppState().filtroLoteSanidade) ||
                                                                            (FFAppState().filtroLoteSanidade == '') ||
                                                                            (e.protocoloReprodutivo == 'null')) &&
                                                                        ((e.idRebanho == FFAppState().filtroSanidadeAnimal) || (FFAppState().filtroSanidadeAnimal == '')) &&
                                                                        (e.deletado == 'NAO') &&
                                                                        (((functions.converterParaData(e.dataSanidade)! >= FFAppState().filtroDataSanidade!) && (functions.converterParaData(e.dataSanidade)! <= getCurrentTimestamp)) || (FFAppState().filtroDataSanidade == null)) &&
                                                                        ((e.vacinacao!).toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()) || (e.antiparasitario!).toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()) || (e.tratamento!).toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()) || (e.protocoloReprodutivo!).toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()))))
                                                                .toList()
                                                                .sortedList(keyOf: (e) => e.createdAt!, desc: true)
                                                                .toList();
                                                            if (sanidades
                                                                .isEmpty) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  height: 200.0,
                                                                  child:
                                                                      EmptySanidadeWidget(),
                                                                ),
                                                              );
                                                            }

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  sanidades
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  sanidadesIndex) {
                                                                final sanidadesItem =
                                                                    sanidades[
                                                                        sanidadesIndex];
                                                                return FutureBuilder<
                                                                    List<
                                                                        BuscarLoteRow>>(
                                                                  future: SQLiteManager
                                                                      .instance
                                                                      .buscarLote(
                                                                    idLote: sanidadesItem
                                                                        .idLote,
                                                                  ),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    // Customize what your widget looks like when it's loading.
                                                                    if (!snapshot
                                                                        .hasData) {
                                                                      return Center(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              50.0,
                                                                          height:
                                                                              50.0,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final containerBuscarLoteRowList =
                                                                        snapshot
                                                                            .data!;

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
                                                                              sanidadesItem.idRebanho,
                                                                        ),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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
                                                                          final containerBuscarRebanhoRowList =
                                                                              snapshot.data!;

                                                                          return Container(
                                                                            width:
                                                                                double.infinity,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Builder(
                                                                                  builder: (context) => Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        if (sanidadesItem.idRebanho != null && sanidadesItem.idRebanho != '') {
                                                                                          FFAppState().sanidadeSelecionada = SanidadeStruct(
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
                                                                                        } else {
                                                                                          FFAppState().sanidadeSelecionada = SanidadeStruct(
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
                                                                                                child: const EditSanidadeLoteWidget(),
                                                                                              );
                                                                                            },
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
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
                                                                                          if (sanidadesItem.vacinacao != 'null')
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
                                                                                          if (sanidadesItem.antiparasitario != 'null')
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
                                                                                          if (sanidadesItem.protocoloReprodutivo != 'null')
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
                                                                                                  Builder(
                                                                                                    builder: (context) {
                                                                                                      final protocolo = functions.converterJSONparaLista(sanidadesItem.protocoloReprodutivo!).toList();

                                                                                                      return SingleChildScrollView(
                                                                                                        scrollDirection: Axis.horizontal,
                                                                                                        child: Row(
                                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                                          children: List.generate(protocolo.length, (protocoloIndex) {
                                                                                                            final protocoloItem = protocolo[protocoloIndex];
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
                                                                                                                      protocoloItem,
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
                                                                                          if (sanidadesItem.tratamento != 'null')
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
                                                                                        ].divide(const SizedBox(height: 8.0)),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Divider(
                                                                                  thickness: 1.0,
                                                                                  color: FlutterFlowTheme.of(context).alternate,
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
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
