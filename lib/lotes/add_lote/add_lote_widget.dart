import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/rebanho/filtros_rebanho/filtros_rebanho_widget.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_lote_model.dart';
export 'add_lote_model.dart';

class AddLoteWidget extends StatefulWidget {
  const AddLoteWidget({super.key});

  @override
  State<AddLoteWidget> createState() => _AddLoteWidgetState();
}

class _AddLoteWidgetState extends State<AddLoteWidget>
    with TickerProviderStateMixin {
  late AddLoteModel _model;
  bool _isSaving = false;

  String _normalizeLoteNome(String? loteNome) {
    final normalized = loteNome?.trim();
    if (normalized == null ||
        normalized.isEmpty ||
        normalized.toLowerCase() == 'null') {
      return 'Sem lote';
    }

    return normalized;
  }

  List<BuscaRebanhoPaginadaPesquisaRow> _animalsInOtherLots() {
    return _model.rebanhosSelecionados.where((animal) {
      final loteNome = animal.loteNome?.trim();
      return loteNome != null &&
          loteNome.isNotEmpty &&
          loteNome.toLowerCase() != 'null';
    }).toList();
  }

  void _applySelectedAnimalsToLot() {
    FFAppState().rebanhosLoteIndex = 0;
    safeSetState(() {});
    while (
        FFAppState().rebanhosLoteIndex < _model.rebanhosSelecionados.length) {
      _model.addToRebanhosAplicados(_model.rebanhosSelecionados
          .elementAtOrNull(FFAppState().rebanhosLoteIndex)!);
      safeSetState(() {});
      _model.addToRebanhoIAplicados(_model.rebanhosSelecionados
          .elementAtOrNull(FFAppState().rebanhosLoteIndex)!
          .idRebanho!);
      safeSetState(() {});
      FFAppState().rebanhosLoteIndex = FFAppState().rebanhosLoteIndex + 1;
      safeSetState(() {});
    }
    _model.rebanhosSelecionados = [];
    safeSetState(() {});
  }

  void _confirmAnimalsAlreadyInLot(
    List<BuscaRebanhoPaginadaPesquisaRow> animais,
  ) {
    if (animais.isEmpty) {
      _applySelectedAnimalsToLot();
      return;
    }

    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Animais já estão em outro lote'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Os animais abaixo já estão vinculados a outro lote. Deseja adicioná-los mesmo assim?',
                  ),
                  const SizedBox(height: 16.0),
                  ...animais.map(
                    (animal) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '${animal.numeroAnimal ?? 'S/N'} • ${animal.nome ?? 'Sem nome'} • Lote atual: ${_normalizeLoteNome(animal.loteNome)}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _applySelectedAnimalsToLot();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF28A365),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Confirmar'),
            ),
          ],
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
    _model = createModel(context, () => AddLoteModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.nomeloteTextController ??= TextEditingController();
    _model.nomeloteFocusNode ??= FocusNode();

    _model.anotacoesTextController ??= TextEditingController();
    _model.anotacoesFocusNode ??= FocusNode();

    _model.ativoInativoValue = true;
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/Menu_button_(1).png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              'Lotes',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: const Color(0xFF232908),
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ].divide(const SizedBox(width: 8.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    child: Text(
                      'Adicionar lote',
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: const Color(0xFF181818),
                            fontSize: 24.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: const Alignment(0.0, 0),
                          child: TabBar(
                            labelColor: const Color(0xFF1E7A4C),
                            unselectedLabelColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  lineHeight: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleMediumIsCustom,
                                ),
                            unselectedLabelStyle: const TextStyle(),
                            indicatorColor: const Color(0xFF1E7A4C),
                            tabs: const [
                              Tab(
                                text: 'Informações',
                              ),
                              Tab(
                                text: 'Animais',
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [() async {}, () async {}][i]();
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 24.0, 0.0, 24.0),
                                  child: SingleChildScrollView(
                                    primary: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        -1.0, -1.0),
                                                child: Text(
                                                  'Nome do lote*',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: const Color(
                                                            0xFF2F2F2F),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              TextFormField(
                                                controller: _model
                                                    .nomeloteTextController,
                                                focusNode:
                                                    _model.nomeloteFocusNode,
                                                autofocus: true,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  hintText: 'Nome do lote',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: const Color(
                                                            0xFFBEBEBE),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xFF28A365),
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  filled: true,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                cursorColor:
                                                    const Color(0xFF28A365),
                                                validator: _model
                                                    .nomeloteTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ].divide(
                                                const SizedBox(height: 8.0)),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          -1.0, -1.0),
                                                  child: Text(
                                                    'Anotações',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: const Color(
                                                              0xFF2F2F2F),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: _model
                                                      .anotacoesTextController,
                                                  focusNode:
                                                      _model.anotacoesFocusNode,
                                                  autofocus: true,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: 'Escreva algo...',
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0xFF28A365),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    errorBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                    filled: true,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  maxLines: 5,
                                                  cursorColor:
                                                      const Color(0xFF28A365),
                                                  validator: _model
                                                      .anotacoesTextControllerValidator
                                                      .asValidator(context),
                                                ),
                                              ].divide(
                                                  const SizedBox(height: 8.0)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x41000000),
                                                  offset: Offset(
                                                    2.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(6.0),
                                                bottomRight:
                                                    Radius.circular(6.0),
                                                topLeft: Radius.circular(6.0),
                                                topRight: Radius.circular(6.0),
                                              ),
                                              border: Border.all(
                                                color: const Color(0xFFBEBEBE),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Este lote está ativo?',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFF474747),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  Switch.adaptive(
                                                    value: _model
                                                        .ativoInativoValue!,
                                                    onChanged:
                                                        (newValue) async {
                                                      safeSetState(() => _model
                                                              .ativoInativoValue =
                                                          newValue);
                                                      if (newValue) {
                                                        safeSetState(() {
                                                          _model
                                                              .dropDownMotivoValueController
                                                              ?.reset();
                                                          _model.dropDownMotivoValue =
                                                              null;
                                                        });
                                                      }
                                                    },
                                                    activeColor:
                                                        const Color(0xFF28A365),
                                                    activeTrackColor:
                                                        const Color(0xFF28A365),
                                                    inactiveTrackColor:
                                                        const Color(0xFFF1F1F1),
                                                    inactiveThumbColor:
                                                        const Color(0xFF8E8E8E),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (_model.ativoInativoValue == false)
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 150.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Motivo',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: const Color(
                                                                    0xFF474747),
                                                                fontSize: 16.0,
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
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 56.0,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xFFF1F1F1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      6.0),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    FlutterFlowDropDown<
                                                                        String>(
                                                                  controller: _model
                                                                          .dropDownMotivoValueController ??=
                                                                      FormFieldController<
                                                                              String>(
                                                                          null),
                                                                  options: const [
                                                                    'Lote vendido'
                                                                  ],
                                                                  onChanged: (val) =>
                                                                      safeSetState(() =>
                                                                          _model.dropDownMotivoValue =
                                                                              val),
                                                                  width: 200.0,
                                                                  height: 56.0,
                                                                  textStyle: FlutterFlowTheme.of(
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
                                                                  hintText:
                                                                      'Selecionar',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down_rounded,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    size: 24.0,
                                                                  ),
                                                                  elevation:
                                                                      2.0,
                                                                  borderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderWidth:
                                                                      0.0,
                                                                  borderRadius:
                                                                      8.0,
                                                                  margin: const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      12.0,
                                                                      0.0,
                                                                      12.0,
                                                                      0.0),
                                                                  hidesUnderline:
                                                                      true,
                                                                  isOverButton:
                                                                      false,
                                                                  isSearchable:
                                                                      false,
                                                                  isMultiSelect:
                                                                      false,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Data',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: const Color(
                                                                    0xFF474747),
                                                                fontSize: 16.0,
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
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 56.0,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xFFF1F1F1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      6.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      6.0),
                                                            ),
                                                          ),
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
                                                              final datePickedDate =
                                                                  await showDatePicker(
                                                                initialEntryMode:
                                                                    DatePickerEntryMode
                                                                        .calendarOnly,
                                                                context:
                                                                    context,
                                                                initialDate: (_model
                                                                        .datePicked ??
                                                                    DateTime
                                                                        .now()),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2050),
                                                                builder:
                                                                    (context,
                                                                        child) {
                                                                  return wrapInMaterialDatePickerTheme(
                                                                    context,
                                                                    child!,
                                                                    headerBackgroundColor:
                                                                        const Color(
                                                                            0xFF28A365),
                                                                    headerForegroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .info,
                                                                    headerTextStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).headlineLargeFamily,
                                                                          fontSize:
                                                                              32.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).headlineLargeIsCustom,
                                                                        ),
                                                                    pickerBackgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                    pickerForegroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    selectedDateTimeBackgroundColor:
                                                                        const Color(
                                                                            0xFF28A365),
                                                                    selectedDateTimeForegroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .info,
                                                                    actionButtonForegroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    iconSize:
                                                                        24.0,
                                                                  );
                                                                },
                                                              );

                                                              if (datePickedDate !=
                                                                  null) {
                                                                safeSetState(
                                                                    () {
                                                                  _model.datePicked =
                                                                      DateTime(
                                                                    datePickedDate
                                                                        .year,
                                                                    datePickedDate
                                                                        .month,
                                                                    datePickedDate
                                                                        .day,
                                                                  );
                                                                });
                                                              } else if (_model
                                                                      .datePicked !=
                                                                  null) {
                                                                safeSetState(
                                                                    () {
                                                                  _model.datePicked =
                                                                      _model
                                                                          .datePicked;
                                                                });
                                                              }
                                                            },
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    dateTimeFormat(
                                                                      "dd/MM/yyyy",
                                                                      _model
                                                                          .datePicked,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    'Selecione uma data',
                                                                  ),
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
                                                              ].addToStart(
                                                                  const SizedBox(
                                                                      width:
                                                                          12.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 24.0)),
                                            ),
                                          ),
                                        if (_model.ativoInativoValue == false)
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 5.0, 24.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Valor da venda (R\$)',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: const Color(
                                                                0xFF474747),
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 56.0,
                                                  child: custom_widgets
                                                      .CurrencyInputBR2(
                                                    width: double.infinity,
                                                    height: 56.0,
                                                    initialValue: 0.0,
                                                    fillColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .customColor3,
                                                    borderColor:
                                                        Colors.transparent,
                                                    focusedBorderColor:
                                                        Colors.transparent,
                                                    textColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    fontSize: 16.0,
                                                    borderRadius: 8.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              safeSetState(() {
                                                _model.tabBarController!
                                                    .animateTo(
                                                  min(
                                                      _model.tabBarController!
                                                              .length -
                                                          1,
                                                      _model.tabBarController!
                                                              .index +
                                                          1),
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 244.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 4.0,
                                                    color: Color(0x40000000),
                                                    offset: Offset(
                                                      2.0,
                                                      2.0,
                                                    ),
                                                  )
                                                ],
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6.0),
                                                  bottomRight:
                                                      Radius.circular(6.0),
                                                  topLeft: Radius.circular(6.0),
                                                  topRight:
                                                      Radius.circular(6.0),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 24.0, 24.0, 24.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Animais neste lote (0)',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: const Color(
                                                                      0xFF474747),
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                          Text(
                                                            'Ver todos',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: const Color(
                                                                      0xFF1E7A4C),
                                                                  fontSize:
                                                                      16.0,
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
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/images/Rebanho.svg',
                                                                width: 77.0,
                                                                height: 58.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Nenhum animal foi adicionado',
                                                              maxLines: 1,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    lineHeight:
                                                                        1.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                            Text(
                                                              'Clique aqui para adicionar',
                                                              maxLines: 1,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: const Color(
                                                                        0xFF1E7A4C),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    lineHeight:
                                                                        1.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(const SizedBox(
                                                      height: 32.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    safeSetState(() {
                                                      _model
                                                          .anotacoesTextController
                                                          ?.clear();
                                                      _model.textController3
                                                          ?.clear();
                                                      _model
                                                          .nomeloteTextController
                                                          ?.clear();
                                                    });
                                                    safeSetState(() {
                                                      _model.ativoInativoValue =
                                                          true;
                                                    });
                                                    _model.rebanhosSelecionados =
                                                        [];
                                                    _model.rebanhosAplicados =
                                                        [];
                                                    safeSetState(() {});
                                                  },
                                                  text: 'Cancelar',
                                                  options: FFButtonOptions(
                                                    width: 156.0,
                                                    height: 56.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                            24.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color:
                                                        const Color(0x004B39EF),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmallFamily,
                                                          color: const Color(
                                                              0xFF1E7A4C),
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleSmallIsCustom,
                                                        ),
                                                    elevation: 0.0,
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xFF1E7A4C),
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  text: 'Próximo',
                                                  options: FFButtonOptions(
                                                    width: 156.0,
                                                    height: 56.0,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                            24.0, 0.0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                    color:
                                                        const Color(0xFF28A365),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmallFamily,
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleSmallIsCustom,
                                                        ),
                                                    elevation: 0.0,
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ]
                                                .divide(
                                                    const SizedBox(width: 16.0))
                                                .addToStart(
                                                    const SizedBox(width: 24.0))
                                                .addToEnd(const SizedBox(
                                                    width: 24.0)),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 24.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 16.0, 24.0, 30.0),
                                child: SingleChildScrollView(
                                  primary: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: FutureBuilder<
                                            List<
                                                BuscaRebanhoPaginadaPesquisaRow>>(
                                          future: SQLiteManager.instance
                                              .buscaRebanhoPaginadaPesquisa(
                                            idPropriedade: FFAppState()
                                                .propriedadeSelecionada
                                                .idPropriedade,
                                            sexo:
                                                FFAppState().filtroSexoRebanho,
                                            categoria: FFAppState()
                                                .filtroCategoriasRebanho,
                                            raca: FFAppState().filtroRaca,
                                            origem: FFAppState()
                                                .filtroOrigemRebanho,
                                            loteId:
                                                FFAppState().filtroLoteRebanho,
                                            pesquisa:
                                                _model.textController3.text,
                                            statusReb: FFAppState()
                                                .filtroStatusRebanho,
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
                                            final animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList =
                                                snapshot.data!;

                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6.0),
                                                  bottomRight:
                                                      Radius.circular(6.0),
                                                  topLeft: Radius.circular(6.0),
                                                  topRight:
                                                      Radius.circular(6.0),
                                                ),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFBEBEBE),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        12.0, 12.0, 12.0, 12.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      valueOrDefault<String>(
                                                        'Animais fora do lote (${valueOrDefault<String>(
                                                          (valueOrDefault<int>(
                                                                    animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList
                                                                        .length,
                                                                    0,
                                                                  ) -
                                                                  valueOrDefault<
                                                                      int>(
                                                                    _model
                                                                        .rebanhosSelecionados
                                                                        .length,
                                                                    0,
                                                                  ))
                                                              .toString(),
                                                          '0',
                                                        )})',
                                                        '0',
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: const Color(
                                                                0xFF181818),
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24.0),
                                                        shape:
                                                            BoxShape.rectangle,
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
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/search3554.png',
                                                                width: 24.0,
                                                                height: 24.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 200.0,
                                                              child:
                                                                  TextFormField(
                                                                controller: _model
                                                                    .textController3,
                                                                focusNode: _model
                                                                    .textFieldFocusNode,
                                                                onChanged: (_) =>
                                                                    EasyDebounce
                                                                        .debounce(
                                                                  '_model.textController3',
                                                                  const Duration(
                                                                      milliseconds:
                                                                          2000),
                                                                  () async {
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                ),
                                                                autofocus:
                                                                    false,
                                                                obscureText:
                                                                    false,
                                                                decoration:
                                                                    InputDecoration(
                                                                  isDense: true,
                                                                  labelStyle: FlutterFlowTheme.of(
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
                                                                  hintText:
                                                                      'Pesquisar',
                                                                  hintStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).labelMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                      ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color(
                                                                          0x00000000),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color(
                                                                          0x00000000),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  contentPadding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          2.0,
                                                                          0.0,
                                                                          0.0),
                                                                ),
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
                                                                cursorColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                validator: _model
                                                                    .textController3Validator
                                                                    .asValidator(
                                                                        context),
                                                              ),
                                                            ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 8.0)),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 40.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
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
                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Padding(
                                                                      padding: MediaQuery
                                                                          .viewInsetsOf(
                                                                              context),
                                                                      child:
                                                                          const FiltrosRebanhoWidget(),
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    safeSetState(
                                                                        () {}));
                                                              },
                                                              child: Container(
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
                                                                  border: Border
                                                                      .all(
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
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/Filter78978.png',
                                                                          width:
                                                                              16.0,
                                                                          height:
                                                                              16.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ].divide(const SizedBox(
                                                                        width:
                                                                            8.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 8.0)),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 1.0,
                                                      color: Color(0xFFEDEDED),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                checkboxTheme:
                                                                    CheckboxThemeData(
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  materialTapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                                unselectedWidgetColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                              ),
                                                              child: Checkbox(
                                                                value: _model
                                                                        .checkboxValue1 ??=
                                                                    false,
                                                                onChanged:
                                                                    (newValue) async {
                                                                  safeSetState(() =>
                                                                      _model.checkboxValue1 =
                                                                          newValue!);
                                                                  if (newValue!) {
                                                                    _model.rebanhosSelecionados =
                                                                        [];
                                                                    safeSetState(
                                                                        () {});
                                                                    _model.rebanhosSelecionados = animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList
                                                                        .toList()
                                                                        .cast<
                                                                            BuscaRebanhoPaginadaPesquisaRow>();
                                                                    _model.rebanhoIdSelecionados = animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList
                                                                        .map((e) => e
                                                                            .idRebanho)
                                                                        .withoutNulls
                                                                        .toList()
                                                                        .cast<
                                                                            String>();
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    _model.rebanhosSelecionados =
                                                                        [];
                                                                    _model.rebanhoIdSelecionados =
                                                                        [];
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                },
                                                                side:
                                                                    BorderSide(
                                                                  width: 2,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                ),
                                                                activeColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                                checkColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Selecionar todos',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    fontSize:
                                                                        14.0,
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
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 5.0)),
                                                        ),
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            final animaisEmOutrosLotes =
                                                                _animalsInOtherLots();
                                                            _confirmAnimalsAlreadyInLot(
                                                                animaisEmOutrosLotes);
                                                          },
                                                          text: 'Adicionar',
                                                          options:
                                                              FFButtonOptions(
                                                            height: 34.0,
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    24.0,
                                                                    0.0,
                                                                    24.0,
                                                                    0.0),
                                                            iconPadding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                            color: const Color(
                                                                0xFF28A365),
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .titleSmallFamily,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .titleSmallIsCustom,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Builder(
                                                      builder: (context) {
                                                        final rebanhosSelect =
                                                            animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList
                                                                .where((e) =>
                                                                    e.statusRebanho ==
                                                                    'Na propriedade')
                                                                .toList()
                                                                .sortedList(
                                                                    keyOf: (e) =>
                                                                        e.createdAt ??
                                                                        '',
                                                                    desc: true)
                                                                .toList()
                                                                .take(20)
                                                                .toList();

                                                        return ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              rebanhosSelect
                                                                  .length,
                                                          itemBuilder: (context,
                                                              rebanhosSelectIndex) {
                                                            final rebanhosSelectItem =
                                                                rebanhosSelect[
                                                                    rebanhosSelectIndex];
                                                            return Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Theme(
                                                                      data:
                                                                          ThemeData(
                                                                        checkboxTheme:
                                                                            CheckboxThemeData(
                                                                          visualDensity:
                                                                              VisualDensity.compact,
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        unselectedWidgetColor:
                                                                            FlutterFlowTheme.of(context).alternate,
                                                                      ),
                                                                      child:
                                                                          Checkbox(
                                                                        value: _model.checkboxValueMap2[rebanhosSelectItem] ??= _model
                                                                            .rebanhoIdSelecionados
                                                                            .contains(rebanhosSelectItem.idRebanho),
                                                                        onChanged: _model.rebanhoIAplicados.contains(rebanhosSelectItem.idRebanho)
                                                                            ? null
                                                                            : (newValue) async {
                                                                                safeSetState(() => _model.checkboxValueMap2[rebanhosSelectItem] = newValue!);
                                                                                if (newValue!) {
                                                                                  _model.addToRebanhosSelecionados(rebanhosSelectItem);
                                                                                  _model.addToRebanhoIdSelecionados(rebanhosSelectItem.idRebanho!);
                                                                                  safeSetState(() {});
                                                                                } else {
                                                                                  _model.removeFromRebanhosSelecionados(rebanhosSelectItem);
                                                                                  _model.removeFromRebanhoIdSelecionados(rebanhosSelectItem.idRebanho!);
                                                                                  safeSetState(() {});
                                                                                }
                                                                              },
                                                                        side:
                                                                            BorderSide(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                        ),
                                                                        activeColor:
                                                                            FlutterFlowTheme.of(context).secondary,
                                                                        checkColor: _model.rebanhoIAplicados.contains(rebanhosSelectItem.idRebanho)
                                                                            ? null
                                                                            : FlutterFlowTheme.of(context).info,
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
                                                                        SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Image.asset(
                                                                                  'assets/images/Group_11_3_(1).png',
                                                                                  width: 24.0,
                                                                                  height: 24.0,
                                                                                  fit: BoxFit.scaleDown,
                                                                                ),
                                                                              ),
                                                                              if (rebanhosSelectItem.sexo == 'Macho')
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  child: Image.asset(
                                                                                    'assets/images/Sexomacho.png',
                                                                                    width: 24.0,
                                                                                    height: 24.0,
                                                                                    fit: BoxFit.scaleDown,
                                                                                  ),
                                                                                ),
                                                                              if (rebanhosSelectItem.sexo == 'Fêmea')
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  child: Image.asset(
                                                                                    'assets/images/Sexofemea.png',
                                                                                    width: 24.0,
                                                                                    height: 24.0,
                                                                                    fit: BoxFit.scaleDown,
                                                                                  ),
                                                                                ),
                                                                            ],
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
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  rebanhosSelectItem.numeroAnimal,
                                                                                  '000',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF474747),
                                                                                      fontSize: 16.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
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
                                                                                      color: const Color(0xFF474747),
                                                                                      fontSize: 16.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  () {
                                                                                    if (valueOrDefault<String>(
                                                                                          rebanhosSelectItem.nome,
                                                                                          'nome',
                                                                                        ) ==
                                                                                        'null') {
                                                                                      return 'S/N';
                                                                                    } else if (valueOrDefault<String>(
                                                                                          rebanhosSelectItem.nome,
                                                                                          'nome',
                                                                                        ) ==
                                                                                        '') {
                                                                                      return 'S/N';
                                                                                    } else {
                                                                                      return valueOrDefault<String>(
                                                                                        rebanhosSelectItem.nome,
                                                                                        'nome',
                                                                                      );
                                                                                    }
                                                                                  }(),
                                                                                  'S/N',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF474747),
                                                                                      fontSize: 16.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
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
                                                                                      color: const Color(0xFF474747),
                                                                                      fontSize: 16.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                dateTimeFormat(
                                                                                  "d/M/y",
                                                                                  functions.converterParaData(rebanhosSelectItem.dataNascimento),
                                                                                  locale: FFLocalizations.of(context).languageCode,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.plusJakartaSans(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      color: const Color(0xFF474747),
                                                                                      fontSize: 16.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ].divide(const SizedBox(width: 4.0)),
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
                                                                              Text(
                                                                                '${(valueOrDefault<String>(
                                                                                      rebanhosSelectItem.categoria,
                                                                                      'N/A',
                                                                                    ) == 'null') || (valueOrDefault<String>(
                                                                                      rebanhosSelectItem.categoria,
                                                                                      'N/A',
                                                                                    ) == '') ? 'N/A' : valueOrDefault<String>(
                                                                                    rebanhosSelectItem.categoria,
                                                                                    'N/A',
                                                                                  )} • ${(valueOrDefault<String>(
                                                                                      rebanhosSelectItem.raca,
                                                                                      'N/A',
                                                                                    ) == 'null') || (valueOrDefault<String>(
                                                                                      rebanhosSelectItem.raca,
                                                                                      'N/A',
                                                                                    ) == '') ? 'N/A' : valueOrDefault<String>(
                                                                                    rebanhosSelectItem.raca,
                                                                                    'N/A',
                                                                                  )}',
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
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  child: Image.asset(
                                                                                    'assets/images/Lotes4343434.png',
                                                                                    width: 24.0,
                                                                                    height: 24.0,
                                                                                    fit: BoxFit.scaleDown,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'Lote:',
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
                                                                                    () {
                                                                                      if (valueOrDefault<String>(
                                                                                            rebanhosSelectItem.loteNome,
                                                                                            'Animal sem lote',
                                                                                          ) ==
                                                                                          'null') {
                                                                                        return 'S/L';
                                                                                      } else if (valueOrDefault<String>(
                                                                                            rebanhosSelectItem.loteNome,
                                                                                            'Animal sem lote',
                                                                                          ) ==
                                                                                          '') {
                                                                                        return 'S/L';
                                                                                      } else {
                                                                                        return valueOrDefault<String>(
                                                                                          rebanhosSelectItem.loteNome,
                                                                                          'Animal sem lote',
                                                                                        );
                                                                                      }
                                                                                    }(),
                                                                                    'S/L',
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
                                                                              ].divide(const SizedBox(width: 5.0)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ].divide(const SizedBox(
                                                                              height: 8.0)),
                                                                    ),
                                                                  ].divide(
                                                                      const SizedBox(
                                                                          width:
                                                                              8.0)),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ].divide(const SizedBox(
                                                      height: 16.0)),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(6.0),
                                              bottomRight: Radius.circular(6.0),
                                              topLeft: Radius.circular(6.0),
                                              topRight: Radius.circular(6.0),
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFBEBEBE),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                12.0, 12.0, 12.0, 12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  valueOrDefault<String>(
                                                    'Animais adicionados (${valueOrDefault<String>(
                                                      _model.rebanhosAplicados
                                                          .length
                                                          .toString(),
                                                      '0',
                                                    )})',
                                                    '0',
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: const Color(
                                                                0xFF181818),
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: TextFormField(
                                                    controller: _model
                                                        .pesquisarTextController,
                                                    focusNode: _model
                                                        .pesquisarFocusNode,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      '_model.pesquisarTextController',
                                                      const Duration(
                                                          milliseconds: 2000),
                                                      () => safeSetState(() {}),
                                                    ),
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMediumIsCustom,
                                                              ),
                                                      hintText: 'Pesquisar',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMediumIsCustom,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      filled: true,
                                                      fillColor: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      prefixIcon: Icon(
                                                        Icons.search_sharp,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent3,
                                                        size: 24.0,
                                                      ),
                                                      suffixIcon: _model
                                                              .pesquisarTextController!
                                                              .text
                                                              .isNotEmpty
                                                          ? InkWell(
                                                              onTap: () async {
                                                                _model
                                                                    .pesquisarTextController
                                                                    ?.clear();
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: Icon(
                                                                Icons.clear,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .accent3,
                                                                size: 22,
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          lineHeight: 1.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                    cursorColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    validator: _model
                                                        .pesquisarTextControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    if (responsiveVisibility(
                                                      context: context,
                                                      phone: false,
                                                    ))
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Theme(
                                                            data: ThemeData(
                                                              checkboxTheme:
                                                                  CheckboxThemeData(
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.0),
                                                                ),
                                                              ),
                                                              unselectedWidgetColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                            ),
                                                            child: Checkbox(
                                                              value: _model
                                                                      .checkboxValue3 ??=
                                                                  false,
                                                              onChanged:
                                                                  (newValue) async {
                                                                safeSetState(() =>
                                                                    _model.checkboxValue3 =
                                                                        newValue!);
                                                              },
                                                              side: BorderSide(
                                                                width: 2,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                              ),
                                                              activeColor:
                                                                  const Color(
                                                                      0xFF1E7A4C),
                                                              checkColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .info,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Selecionar todos',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: const Color(
                                                                      0xFF474747),
                                                                  fontSize:
                                                                      14.0,
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
                                                        ],
                                                      ),
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        _model.rebanhosSelecionados =
                                                            [];
                                                        _model.rebanhoIdSelecionados =
                                                            [];
                                                        _model.rebanhoIAplicados =
                                                            [];
                                                        _model.rebanhosAplicados =
                                                            [];
                                                        safeSetState(() {});
                                                      },
                                                      text: 'Remover Todos',
                                                      options: FFButtonOptions(
                                                        height: 34.0,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(24.0,
                                                                0.0, 24.0, 0.0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 0.0),
                                                        color: const Color(
                                                            0xFFFF0000),
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmallFamily,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmallIsCustom,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (_model.rebanhosAplicados
                                                    .isNotEmpty)
                                                  Builder(
                                                    builder: (context) {
                                                      final rebanhoAplicado = _model
                                                          .rebanhosAplicados
                                                          .where((e) =>
                                                              (_model.pesquisarTextController.text ==
                                                                  '') ||
                                                              ((e.numeroAnimal!)
                                                                      .toLowerCase()
                                                                      .contains(_model
                                                                          .pesquisarTextController
                                                                          .text
                                                                          .toLowerCase()) ||
                                                                  (e.nome!)
                                                                      .toLowerCase()
                                                                      .contains(_model
                                                                          .pesquisarTextController
                                                                          .text
                                                                          .toLowerCase()) ||
                                                                  (e.chip!)
                                                                      .toLowerCase()
                                                                      .contains(_model.pesquisarTextController.text.toLowerCase())))
                                                          .toList()
                                                          .take(_model.mostrarAdicionados)
                                                          .toList();

                                                      return ListView.separated(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        primary: false,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            rebanhoAplicado
                                                                .length,
                                                        separatorBuilder: (_,
                                                                __) =>
                                                            const SizedBox(
                                                                height: 8.0),
                                                        itemBuilder: (context,
                                                            rebanhoAplicadoIndex) {
                                                          final rebanhoAplicadoItem =
                                                              rebanhoAplicado[
                                                                  rebanhoAplicadoIndex];
                                                          return SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Theme(
                                                                  data:
                                                                      ThemeData(
                                                                    checkboxTheme:
                                                                        CheckboxThemeData(
                                                                      visualDensity:
                                                                          VisualDensity
                                                                              .compact,
                                                                      materialTapTargetSize:
                                                                          MaterialTapTargetSize
                                                                              .shrinkWrap,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4.0),
                                                                      ),
                                                                    ),
                                                                    unselectedWidgetColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .alternate,
                                                                  ),
                                                                  child:
                                                                      Checkbox(
                                                                    value: _model
                                                                            .checkboxValueMap4[
                                                                        rebanhoAplicadoItem] ??= true,
                                                                    onChanged:
                                                                        (newValue) async {
                                                                      safeSetState(() =>
                                                                          _model.checkboxValueMap4[rebanhoAplicadoItem] =
                                                                              newValue!);

                                                                      if (!newValue!) {
                                                                        _model.removeFromRebanhosAplicados(
                                                                            rebanhoAplicadoItem);
                                                                        _model.removeFromRebanhoIAplicados(
                                                                            rebanhoAplicadoItem.idRebanho!);
                                                                        safeSetState(
                                                                            () {});
                                                                      }
                                                                    },
                                                                    side:
                                                                        BorderSide(
                                                                      width: 2,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                    ),
                                                                    activeColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                    checkColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .info,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
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
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                          if (rebanhoAplicadoItem.sexo ==
                                                                              'Macho')
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: Image.asset(
                                                                                'assets/images/Sexomacho.png',
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                fit: BoxFit.scaleDown,
                                                                              ),
                                                                            ),
                                                                          if (rebanhoAplicadoItem.sexo ==
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
                                                                        ],
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
                                                                          Text(
                                                                            valueOrDefault<String>(
                                                                              rebanhoAplicadoItem.numeroAnimal,
                                                                              '000',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.plusJakartaSans(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: const Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
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
                                                                                  color: const Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            valueOrDefault<String>(
                                                                              () {
                                                                                if (rebanhoAplicadoItem.nome == 'null') {
                                                                                  return 'S/N';
                                                                                } else if (rebanhoAplicadoItem.nome == null || rebanhoAplicadoItem.nome == '') {
                                                                                  return 'S/N';
                                                                                } else {
                                                                                  return rebanhoAplicadoItem.nome;
                                                                                }
                                                                              }(),
                                                                              'S/N',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.plusJakartaSans(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: const Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
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
                                                                                  color: const Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            dateTimeFormat(
                                                                              "d/M/y",
                                                                              functions.converterParaData(rebanhoAplicadoItem.dataNascimento),
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.plusJakartaSans(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: const Color(0xFF474747),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 4.0)),
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
                                                                          Text(
                                                                            '${(rebanhoAplicadoItem.categoria == 'null') || (rebanhoAplicadoItem.categoria == null || rebanhoAplicadoItem.categoria == '') ? 'N/A' : rebanhoAplicadoItem.categoria} • ${(rebanhoAplicadoItem.raca == 'null') || (rebanhoAplicadoItem.raca == null || rebanhoAplicadoItem.raca == '') ? 'N/A' : rebanhoAplicadoItem.raca}',
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
                                                                              SvgPicture.asset(
                                                                            'assets/images/Lotes_(2).svg',
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Lote:',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
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
                                                                          valueOrDefault<
                                                                              String>(
                                                                            () {
                                                                              if (rebanhoAplicadoItem.loteNome == 'null') {
                                                                                return 'S/L';
                                                                              } else if (rebanhoAplicadoItem.loteNome == null || rebanhoAplicadoItem.loteNome == '') {
                                                                                return 'S/L';
                                                                              } else {
                                                                                return rebanhoAplicadoItem.loteNome;
                                                                              }
                                                                            }(),
                                                                            'S/L',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
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
                                                                      ].divide(const SizedBox(
                                                                              width: 5.0)),
                                                                    ),
                                                                  ].divide(const SizedBox(
                                                                      height:
                                                                          8.0)),
                                                                ),
                                                              ].divide(
                                                                  const SizedBox(
                                                                      width:
                                                                          8.0)),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                if (!(_model.rebanhosAplicados
                                                    .isNotEmpty))
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/Frame_2608648555.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    if (_model
                                                            .mostrarAdicionados >
                                                        5)
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
                                                          _model.mostrarAdicionados =
                                                              _model.mostrarAdicionados +
                                                                  -5;
                                                          safeSetState(() {});
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Mostrar menos',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    fontSize:
                                                                        12.0,
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
                                                            Icon(
                                                              Icons
                                                                  .keyboard_arrow_up,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 24.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    if (_model
                                                            .mostrarAdicionados <
                                                        _model.rebanhosAplicados
                                                            .length)
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
                                                          _model.mostrarAdicionados =
                                                              _model.mostrarAdicionados +
                                                                  5;
                                                          safeSetState(() {});
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Mostrar mais',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                                    fontSize:
                                                                        12.0,
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
                                                            Icon(
                                                              Icons
                                                                  .keyboard_arrow_down_outlined,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 24.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ].divide(
                                                  const SizedBox(height: 16.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                safeSetState(() {
                                                  _model.nomeloteTextController
                                                      ?.clear();
                                                  _model.anotacoesTextController
                                                      ?.clear();
                                                  _model.textController3
                                                      ?.clear();
                                                });
                                                safeSetState(() {
                                                  _model.ativoInativoValue =
                                                      true;
                                                });
                                                _model.rebanhosSelecionados =
                                                    [];
                                                _model.rebanhosAplicados = [];
                                                _model.rebanhoIdSelecionados =
                                                    [];
                                                _model.rebanhoIAplicados = [];
                                                safeSetState(() {});
                                                Navigator.pop(context);
                                              },
                                              text: 'Cancelar',
                                              options: FFButtonOptions(
                                                width: 155.0,
                                                height: 56.0,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                color: const Color(0x001E7A4C),
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmallFamily,
                                                          color: const Color(
                                                              0xFF1E7A4C),
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleSmallIsCustom,
                                                        ),
                                                elevation: 0.0,
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF1E7A4C),
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FFButtonWidget(
                                              onPressed:
                                                  (_model.nomeloteTextController
                                                              .text ==
                                                          '')
                                                      ? null
                                                      : () async {
                                                          if (_isSaving) return;
                                                          _isSaving = true;
                                                          safeSetState(() {});
                                                          try {
                                                            if (await action_blocks
                                                                .blockIfAccountCanceled(
                                                                    context,
                                                                    refreshFromServer:
                                                                        true))
                                                              return;
                                                            if (!(FFAppState()
                                                                    .dataDadosNaoSyncLotes !=
                                                                null)) {
                                                              FFAppState()
                                                                      .dataDadosNaoSyncLotes =
                                                                  getCurrentTimestamp;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.idLote =
                                                                random_data
                                                                    .randomString(
                                                              20,
                                                              20,
                                                              true,
                                                              false,
                                                              true,
                                                            );
                                                            _model.index = 0;
                                                            safeSetState(() {});
                                                            while (_model
                                                                    .index <
                                                                _model
                                                                    .rebanhoIAplicados
                                                                    .length) {
                                                              _model.rebanhoIndex2 =
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .buscarRebanho(
                                                                idRebanho: _model
                                                                    .rebanhoIAplicados
                                                                    .elementAtOrNull(
                                                                        _model
                                                                            .index),
                                                              );
                                                              if ((_model.rebanhoIndex2?.firstOrNull
                                                                              ?.loteID ==
                                                                          null ||
                                                                      _model.rebanhoIndex2?.firstOrNull
                                                                              ?.loteID ==
                                                                          '') ||
                                                                  (_model
                                                                          .rebanhoIndex2
                                                                          ?.firstOrNull
                                                                          ?.loteID ==
                                                                      ' ')) {
                                                                if (_model
                                                                        .ativoInativoValue ==
                                                                    true) {
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .uPDTRebanhoLote(
                                                                    loteNome: _model
                                                                        .nomeloteTextController
                                                                        .text,
                                                                    loteID: _model
                                                                        .idLote,
                                                                    updatedat:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    idRebanho: _model
                                                                        .rebanhoIndex2
                                                                        ?.firstOrNull
                                                                        ?.idRebanho,
                                                                    dataEntradaLote:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                  );
                                                                } else {
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .uPDTRebanhoLoteVenda(
                                                                    loteNome: _model
                                                                        .nomeloteTextController
                                                                        .text,
                                                                    loteID: _model
                                                                        .idLote,
                                                                    updatedat:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    idRebanho: _model
                                                                        .rebanhoIndex2
                                                                        ?.firstOrNull
                                                                        ?.idRebanho,
                                                                    dataEntradaLote:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    dataVenda:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .datePicked,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    valorVenda:
                                                                        FFAppState()
                                                                            .valueDouble2,
                                                                  );
                                                                }
                                                              } else {
                                                                if (_model
                                                                        .ativoInativoValue ==
                                                                    true) {
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .uPDTRebanhoLote(
                                                                    loteNome: _model
                                                                        .nomeloteTextController
                                                                        .text,
                                                                    loteID: _model
                                                                        .idLote,
                                                                    updatedat:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    idRebanho: _model
                                                                        .rebanhoIAplicados
                                                                        .elementAtOrNull(
                                                                            _model.index),
                                                                    dataEntradaLote:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                  );
                                                                } else {
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .uPDTRebanhoLoteVenda(
                                                                    loteNome: _model
                                                                        .nomeloteTextController
                                                                        .text,
                                                                    loteID: _model
                                                                        .idLote,
                                                                    updatedat:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    idRebanho: _model
                                                                        .rebanhoIAplicados
                                                                        .elementAtOrNull(
                                                                            _model.index),
                                                                    dataEntradaLote:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    dataVenda:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd",
                                                                      _model
                                                                          .datePicked,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    valorVenda:
                                                                        FFAppState()
                                                                            .valueDouble2,
                                                                  );
                                                                }
                                                              }

                                                              _model.index =
                                                                  _model.index +
                                                                      1;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            await SQLiteManager
                                                                .instance
                                                                .insertLote(
                                                              idPropriedade:
                                                                  FFAppState()
                                                                      .propriedadeSelecionada
                                                                      .idPropriedade,
                                                              nome: _model
                                                                  .nomeloteTextController
                                                                  .text,
                                                              anotacoes: _model
                                                                  .anotacoesTextController
                                                                  .text,
                                                              ativo:
                                                                  _model.ativoInativoValue ==
                                                                          true
                                                                      ? 'Ativo'
                                                                      : 'Inativo',
                                                              motivo: _model
                                                                  .dropDownMotivoValue,
                                                              dataMotivo:
                                                                  dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              idLote:
                                                                  _model.idLote,
                                                              deletado: 'NAO',
                                                              createdat:
                                                                  dateTimeFormat(
                                                                "yyyy-MM-dd HH:mm:ss",
                                                                getCurrentTimestamp,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              updatedat:
                                                                  dateTimeFormat(
                                                                "yyyy-MM-dd HH:mm:ss",
                                                                getCurrentTimestamp,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              valorVenda:
                                                                  FFAppState()
                                                                      .valueDouble2,
                                                            );
                                                            if (!(FFAppState()
                                                                    .dataDadosNaoSyncRebanho !=
                                                                null)) {
                                                              FFAppState()
                                                                      .dataDadosNaoSyncRebanho =
                                                                  getCurrentTimestamp;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                            _model.rebanhosSelecionados =
                                                                [];
                                                            _model.rebanhosAplicados =
                                                                [];
                                                            safeSetState(() {});
                                                            await action_blocks
                                                                .countLotesAtivoInativo(
                                                                    context);
                                                            await action_blocks
                                                                .countLotesCadastrados(
                                                                    context);
                                                            FFAppState()
                                                                .update(() {});
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Lote criado com sucesso.',
                                                                  style:
                                                                      TextStyle(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                  ),
                                                                ),
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        4000),
                                                                backgroundColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                              ),
                                                            );

                                                            safeSetState(() {});
                                                          } catch (e, s) {
                                                            debugPrint(
                                                                '[AddLote] Erro ao criar lote: $e\n$s');
                                                            if (mounted) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'Não foi possível salvar o lote. Tente novamente.',
                                                                    style:
                                                                        TextStyle(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                    ),
                                                                  ),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          4000),
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                ),
                                                              );
                                                            }
                                                          } finally {
                                                            if (mounted) {
                                                              _isSaving = false;
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                          }
                                                        },
                                              text: 'Salvar',
                                              options: FFButtonOptions(
                                                width: 155.0,
                                                height: 56.0,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                color: const Color(0xFF28A365),
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmallFamily,
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleSmallIsCustom,
                                                        ),
                                                elevation: 0.0,
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                disabledColor:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                              ),
                                            ),
                                          ),
                                        ].divide(const SizedBox(width: 16.0)),
                                      ),
                                    ].divide(const SizedBox(height: 32.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ].divide(const SizedBox(height: 24.0)),
            ),
          ),
        ),
      ],
    );
  }
}
