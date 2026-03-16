import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/propriedade/add_propriedade/add_propriedade_widget.dart';
import '/propriedade/filtro_propriedades/filtro_propriedades_widget.dart';
import '/propriedade/filtros_ordenacao_propriedade/filtros_ordenacao_propriedade_widget.dart';
import '/propriedade/ordernar_propriedades/ordernar_propriedades_widget.dart';
import '/propriedade/view_propriedades/view_propriedades_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'page_propriedades_model.dart';
export 'page_propriedades_model.dart';

class PagePropriedadesWidget extends StatefulWidget {
  const PagePropriedadesWidget({super.key});

  @override
  State<PagePropriedadesWidget> createState() => _PagePropriedadesWidgetState();
}

class _PagePropriedadesWidgetState extends State<PagePropriedadesWidget> {
  late PagePropriedadesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PagePropriedadesModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: const Duration(milliseconds: 250),
        callback: (timer) async {
          _model.temNet = await actions.checkInternetConnection();

          safeSetState(() {});
        },
        startImmediately: true,
      );
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

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: FutureBuilder<List<ListarPropriedadesRow>>(
                  future: SQLiteManager.instance.listarPropriedades(
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F8F8),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 12.0, 12.0, 12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                'assets/images/mdi_farm.png',
                                                width: 24.0,
                                                height: 24.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Text(
                                              valueOrDefault<String>(
                                                containerBodyOfflineListarPropriedadesRowList
                                                    .length
                                                    .toString(),
                                                '0',
                                              ),
                                              maxLines: 1,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    fontSize: 24.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            Text(
                                              'Propriedades\ncadastradas',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color:
                                                        const Color(0xFF2F2F2F),
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ].divide(const SizedBox(height: 0.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F8F8),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 12.0, 12.0, 12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                'assets/images/Group_11_3_(3).png',
                                                width: 24.0,
                                                height: 24.0,
                                                fit: BoxFit.cover,
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
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    fontSize: 24.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            Text(
                                              'Animais\ncadastrados',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color:
                                                        const Color(0xFF2F2F2F),
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ].divide(const SizedBox(height: 0.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ].divide(const SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
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
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
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
                                  suffixIcon: _model.pesquisarTextController!
                                          .text.isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            _model.pesquisarTextController
                                                ?.clear();
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
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                validator: _model
                                    .pesquisarTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        FFAppState().propEstados =
                                            containerBodyOfflineListarPropriedadesRowList
                                                .unique((e) => e.estado!)
                                                .map((e) => e.estado)
                                                .withoutNulls
                                                .toList()
                                                .cast<String>();
                                        FFAppState().propCidades =
                                            containerBodyOfflineListarPropriedadesRowList
                                                .unique((e) => e.cidade!)
                                                .map((e) => e.cidade)
                                                .withoutNulls
                                                .toList()
                                                .cast<String>();
                                        safeSetState(() {});
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child:
                                                  const FiltroPropriedadesWidget(),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: const Color(0xFFBEBEBE),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 8.0, 16.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Filtrar',
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
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
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
                                    if (FFAppState().filtroNumeroAnimais > 0.0)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: const Color(0xFFBEBEBE),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 8.0, 16.0, 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Animais: ${valueOrDefault<String>(
                                                  FFAppState()
                                                      .filtroNumeroAnimais
                                                      .toString(),
                                                  '0',
                                                )}',
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
                                            ].divide(
                                                const SizedBox(width: 8.0)),
                                          ),
                                        ),
                                      ),
                                    Builder(
                                      builder: (context) {
                                        final nomes = FFAppState()
                                            .filtrosAplicadosProp
                                            .toList();

                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(nomes.length,
                                              (nomesIndex) {
                                            final nomesItem = nomes[nomesIndex];
                                            return Container(
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
                                                      nomesItem,
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                  ].divide(const SizedBox(
                                                      width: 8.0)),
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
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
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
                                      child:
                                          const FiltrosOrdenacaoPropriedadeWidget(),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    FFAppState().ordenacaoRebanho == ''
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryBackground
                                        : const Color(0xFFD6F5E5),
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(
                                    color: valueOrDefault<Color>(
                                      FFAppState().ordenacaoRebanho == ''
                                          ? FlutterFlowTheme.of(context)
                                              .tertiary
                                          : FlutterFlowTheme.of(context)
                                              .secondary,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          if (FFAppState()
                                                  .ordenacaoPropriedade ==
                                              'crescente')
                                            Icon(
                                              Icons.arrow_upward,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 14.0,
                                            ),
                                          if (FFAppState()
                                                  .ordenacaoPropriedade ==
                                              'decrescente')
                                            Icon(
                                              Icons.arrow_downward,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 14.0,
                                            ),
                                          Text(
                                            valueOrDefault<String>(
                                              () {
                                                if (FFAppState()
                                                        .ordenacaoPropriedade ==
                                                    'crescente') {
                                                  return 'Crescente';
                                                } else if (FFAppState()
                                                        .ordenacaoPropriedade ==
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
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: valueOrDefault<Color>(
                                                    FFAppState().ordenacaoPropriedade ==
                                                            ''
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .accent3
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    FlutterFlowTheme.of(context)
                                                        .accent3,
                                                  ),
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 8.0)),
                                      ),
                                      if ((FFAppState().ordenacaoPropTipo !=
                                              '') &&
                                          (FFAppState().ordenacaoPropTipo !=
                                              ''))
                                        SizedBox(
                                          height: 100.0,
                                          child: VerticalDivider(
                                            thickness: 2.0,
                                            color: FlutterFlowTheme.of(context)
                                                .accent4,
                                          ),
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if ((FFAppState()
                                                      .ordenacaoPropriedade !=
                                                  '') &&
                                              (FFAppState().ordenacaoPropTipo !=
                                                  ''))
                                            Text(
                                              valueOrDefault<String>(
                                                () {
                                                  if (FFAppState()
                                                          .ordenacaoPropTipo ==
                                                      'numero') {
                                                    return 'Número de animais';
                                                  } else if (FFAppState()
                                                          .ordenacaoPropTipo ==
                                                      'nome') {
                                                    return 'Nome da propriedade';
                                                  } else if (FFAppState()
                                                          .ordenacaoPropTipo ==
                                                      'uf') {
                                                    return 'UF';
                                                  } else {
                                                    return 'N/A';
                                                  }
                                                }(),
                                                'N/A',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    fontSize: 15.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          if (FFAppState()
                                                  .ordenacaoPropriedade ==
                                              'crescente')
                                            Icon(
                                              Icons.keyboard_arrow_up_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 24.0,
                                            ),
                                          if (FFAppState()
                                                  .ordenacaoPropriedade ==
                                              'decrescente')
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
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
                                      child: const OrdernarPropriedadesWidget(),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                              child: Container(
                                width: 327.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).accent4,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12.0, 8.0, 12.0, 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (FFAppState().filtroTipoOrdenacao !=
                                          '')
                                        Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if (FFAppState()
                                                      .filtroOrdenacao ==
                                                  'Crescente')
                                                Icon(
                                                  Icons.arrow_downward_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent3,
                                                  size: 12.0,
                                                ),
                                              if (FFAppState()
                                                      .filtroOrdenacao ==
                                                  'Decrescente')
                                                Icon(
                                                  Icons.arrow_upward,
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
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                      if (FFAppState().filtroTipoOrdenacao !=
                                          '')
                                        SizedBox(
                                          height: 100.0,
                                          child: VerticalDivider(
                                            thickness: 2.0,
                                            color: FlutterFlowTheme.of(context)
                                                .accent4,
                                          ),
                                        ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              valueOrDefault<String>(
                                                FFAppState()
                                                    .filtroTipoOrdenacao,
                                                'Ordernar por',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FFAppState()
                                                                .filtroTipoOrdenacao !=
                                                            ''
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .secondary
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .accent3,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: FFAppState()
                                                          .filtroTipoOrdenacao !=
                                                      ''
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondary
                                                  : FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 20.0,
                                            ),
                                          ].divide(const SizedBox(width: 8.0)),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    FFAppState().pagePropriedades =
                                        'addPropriedades';
                                    safeSetState(() {});
                                    await showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return Dialog(
                                          elevation: 0,
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          alignment: const AlignmentDirectional(
                                                  0.0, 0.0)
                                              .resolve(
                                                  Directionality.of(context)),
                                          child: const AddPropriedadeWidget(),
                                        );
                                      },
                                    );
                                  },
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
                                            child: Image.network(
                                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-lida-ki7iwq/assets/r08famiy2psl/Propriedades9668.png',
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
                                                      'Nenhuma propriedade foi cadastrada.',
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
                                                ),
                                                const TextSpan(
                                                  text:
                                                      '\nClique aqui para adicionar',
                                                  style: TextStyle(
                                                    color: Color(0xFF1E7A4C),
                                                    fontWeight: FontWeight.w600,
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
                              ),
                            ),
                          Flexible(
                            child: Builder(
                              builder: (context) {
                                if ((FFAppState().ordenacaoPropriedade ==
                                        'crescente') &&
                                    (FFAppState().ordenacaoPropTipo ==
                                        'nome')) {
                                  return Visibility(
                                    visible:
                                        containerBodyOfflineListarPropriedadesRowList
                                            .isNotEmpty,
                                    child: FutureBuilder<
                                        List<ListarPropriedadesCrescNomeRow>>(
                                      future: SQLiteManager.instance
                                          .listarPropriedadesCrescNome(
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
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        final listaPropriedadesCresNomeListarPropriedadesCrescNomeRowList =
                                            snapshot.data!;

                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final propriedade =
                                                  listaPropriedadesCresNomeListarPropriedadesCrescNomeRowList
                                                      .where((e) =>
                                                          ((FFAppState().filtroPropAtividades == '') &&
                                                              (FFAppState().filtroPropEstados ==
                                                                  '') &&
                                                              (FFAppState().filtroPropCidades ==
                                                                  '') &&
                                                              (FFAppState().filtroNumeroAnimais ==
                                                                  0.0) &&
                                                              (_model.pesquisarTextController.text ==
                                                                  '') &&
                                                              (e.deletado ==
                                                                  'NAO')) ||
                                                          (((e.atividades!).contains(
                                                                  FFAppState()
                                                                      .filtroPropAtividades)) &&
                                                              ((e.cidade == FFAppState().filtroPropCidades) ||
                                                                  (FFAppState().filtroPropCidades ==
                                                                      '')) &&
                                                              ((e.estado == FFAppState().filtroPropEstados) ||
                                                                  (FFAppState().filtroPropEstados ==
                                                                      '')) &&
                                                              ((functions.convertIntToDouble(
                                                                          valueOrDefault<
                                                                              int>(
                                                                        (String
                                                                            qtdAnimais) {
                                                                          return qtdAnimais == '[]'
                                                                              ? 0
                                                                              : qtdAnimais.split(',').length;
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
                                                                      .pesquisarTextController
                                                                      .text
                                                                      .toLowerCase())) &&
                                                              (e.deletado == 'NAO')))
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
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Builder(
                                                            builder:
                                                                (context) =>
                                                                    Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      9.0,
                                                                      0.0,
                                                                      8.0),
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
                                                                onTap:
                                                                    () async {
                                                                  await action_blocks
                                                                      .buscaPropriedade(
                                                                    context,
                                                                    idPropriedade:
                                                                        propriedadeItem
                                                                            .idPropriedade,
                                                                  );
                                                                  await showDialog(
                                                                    barrierColor:
                                                                        Colors
                                                                            .transparent,
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
                                                                            ViewPropriedadesWidget(
                                                                          idPropriedade:
                                                                              propriedadeItem.idPropriedade!,
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                8.0),
                                                                            child:
                                                                                ClipRRect(
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
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                2.0),
                                                                            child:
                                                                                Text(
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
                                                                      FontAwesomeIcons
                                                                          .angleRight,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .customColor9,
                                                                      size:
                                                                          16.0,
                                                                    ),
                                                                  ]
                                                                      .addToStart(const SizedBox(
                                                                          width:
                                                                              24.0))
                                                                      .addToEnd(const SizedBox(
                                                                          width:
                                                                              24.0)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                            thickness: 1.0,
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
                                        );
                                      },
                                    ),
                                  );
                                } else if ((FFAppState().ordenacaoPropriedade ==
                                        'decrescente') &&
                                    (FFAppState().ordenacaoPropTipo ==
                                        'nome')) {
                                  return Visibility(
                                    visible:
                                        containerBodyOfflineListarPropriedadesRowList
                                            .isNotEmpty,
                                    child: FutureBuilder<
                                        List<ListarPropriedadesDecNomeRow>>(
                                      future: SQLiteManager.instance
                                          .listarPropriedadesDecNome(
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
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        final listaPropriedadesDecresNomeListarPropriedadesDecNomeRowList =
                                            snapshot.data!;

                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final propriedade =
                                                  listaPropriedadesDecresNomeListarPropriedadesDecNomeRowList
                                                      .where((e) =>
                                                          ((FFAppState().filtroPropAtividades == '') &&
                                                              (FFAppState().filtroPropEstados ==
                                                                  '') &&
                                                              (FFAppState().filtroPropCidades ==
                                                                  '') &&
                                                              (FFAppState().filtroNumeroAnimais ==
                                                                  0.0) &&
                                                              (_model.pesquisarTextController.text ==
                                                                  '') &&
                                                              (e.deletado ==
                                                                  'NAO')) ||
                                                          (((e.atividades!).contains(
                                                                  FFAppState()
                                                                      .filtroPropAtividades)) &&
                                                              ((e.cidade == FFAppState().filtroPropCidades) ||
                                                                  (FFAppState().filtroPropCidades ==
                                                                      '')) &&
                                                              ((e.estado == FFAppState().filtroPropEstados) ||
                                                                  (FFAppState().filtroPropEstados ==
                                                                      '')) &&
                                                              ((functions.convertIntToDouble(
                                                                          valueOrDefault<
                                                                              int>(
                                                                        (String
                                                                            qtdAnimais) {
                                                                          return qtdAnimais == '[]'
                                                                              ? 0
                                                                              : qtdAnimais.split(',').length;
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
                                                                      .pesquisarTextController
                                                                      .text
                                                                      .toLowerCase())) &&
                                                              (e.deletado == 'NAO')))
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
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Builder(
                                                            builder:
                                                                (context) =>
                                                                    Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      9.0,
                                                                      0.0,
                                                                      8.0),
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
                                                                onTap:
                                                                    () async {
                                                                  await action_blocks
                                                                      .buscaPropriedade(
                                                                    context,
                                                                    idPropriedade:
                                                                        propriedadeItem
                                                                            .idPropriedade,
                                                                  );
                                                                  await showDialog(
                                                                    barrierColor:
                                                                        Colors
                                                                            .transparent,
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
                                                                            ViewPropriedadesWidget(
                                                                          idPropriedade:
                                                                              propriedadeItem.idPropriedade!,
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                8.0),
                                                                            child:
                                                                                ClipRRect(
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
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                2.0),
                                                                            child:
                                                                                Text(
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
                                                                      FontAwesomeIcons
                                                                          .angleRight,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .customColor9,
                                                                      size:
                                                                          16.0,
                                                                    ),
                                                                  ]
                                                                      .addToStart(const SizedBox(
                                                                          width:
                                                                              24.0))
                                                                      .addToEnd(const SizedBox(
                                                                          width:
                                                                              24.0)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                            thickness: 1.0,
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
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Visibility(
                                    visible:
                                        containerBodyOfflineListarPropriedadesRowList
                                            .isNotEmpty,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
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
                                                          (_model.pesquisarTextController.text ==
                                                              '') &&
                                                          (e.deletado ==
                                                              'NAO')) ||
                                                      (((e.atividades!).contains(
                                                              FFAppState()
                                                                  .filtroPropAtividades)) &&
                                                          ((e.cidade == FFAppState().filtroPropCidades) ||
                                                              (FFAppState().filtroPropCidades ==
                                                                  '')) &&
                                                          ((e.estado == FFAppState().filtroPropEstados) ||
                                                              (FFAppState().filtroPropEstados ==
                                                                  '')) &&
                                                          ((functions.convertIntToDouble(
                                                                      valueOrDefault<
                                                                          int>(
                                                                    (String
                                                                        qtdAnimais) {
                                                                      return qtdAnimais ==
                                                                              '[]'
                                                                          ? 0
                                                                          : qtdAnimais
                                                                              .split(',')
                                                                              .length;
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
                                                                  .pesquisarTextController
                                                                  .text
                                                                  .toLowerCase())) &&
                                                          (e.deletado == 'NAO')))
                                                  .toList()
                                                  .sortedList(keyOf: (e) => e.createdAt!, desc: true)
                                                  .toList();

                                          return SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: List.generate(
                                                  propriedade.length,
                                                  (propriedadeIndex) {
                                                final propriedadeItem =
                                                    propriedade[
                                                        propriedadeIndex];
                                                return Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Builder(
                                                        builder: (context) =>
                                                            Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  9.0,
                                                                  0.0,
                                                                  8.0),
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
                                                              await action_blocks
                                                                  .buscaPropriedade(
                                                                context,
                                                                idPropriedade:
                                                                    propriedadeItem
                                                                        .idPropriedade,
                                                              );
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
                                                                        ViewPropriedadesWidget(
                                                                      idPropriedade:
                                                                          propriedadeItem
                                                                              .idPropriedade!,
                                                                    ),
                                                                  );
                                                                },
                                                              );
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
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            8.0),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          child:
                                                                              Image.network(
                                                                            valueOrDefault<String>(
                                                                              functions.stringToImgPath(valueOrDefault<String>(
                                                                                propriedadeItem.icone,
                                                                                'https://5259b9664eda98cebc6cec09d515ad33.cdn.bubble.io/f1729245177676x354205975463888640/mdi_farm6556.png',
                                                                              )),
                                                                              'https://5259b9664eda98cebc6cec09d515ad33.cdn.bubble.io/f1729245177676x354205975463888640/mdi_farm6556.png',
                                                                            ),
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            2.0),
                                                                        child:
                                                                            Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            propriedadeItem.nome,
                                                                            'Nome propriedade',
                                                                          ),
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
                                                                      ),
                                                                      Text(
                                                                        '${valueOrDefault<String>(
                                                                          propriedadeItem
                                                                              .cidade,
                                                                          'cidade',
                                                                        )} - ${valueOrDefault<String>(
                                                                          propriedadeItem
                                                                              .estado,
                                                                          'estado',
                                                                        )}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
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
                                                                  FontAwesomeIcons
                                                                      .angleRight,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .customColor9,
                                                                  size: 16.0,
                                                                ),
                                                              ]
                                                                  .addToStart(
                                                                      const SizedBox(
                                                                          width:
                                                                              24.0))
                                                                  .addToEnd(
                                                                      const SizedBox(
                                                                          width:
                                                                              24.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        thickness: 1.0,
                                                        color:
                                                            Color(0xFFEDEDED),
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
                                  );
                                }
                              },
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
      ],
    );
  }
}
