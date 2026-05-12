import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/rebanho/filtros_rebanho/filtros_rebanho_widget.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_lote_model.dart';
export 'edit_lote_model.dart';

class EditLoteWidget extends StatefulWidget {
  const EditLoteWidget({
    super.key,
    required this.idLote,
  });

  final String? idLote;

  @override
  State<EditLoteWidget> createState() => _EditLoteWidgetState();
}

class _EditLoteWidgetState extends State<EditLoteWidget>
    with TickerProviderStateMixin {
  late EditLoteModel _model;
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

  bool _isEmptyLoteId(String? loteId) {
    final normalized = loteId?.trim();
    return normalized == null ||
        normalized.isEmpty ||
        normalized.toLowerCase() == 'null';
  }

  bool _isCurrentLoteId(String? loteId) {
    final currentLoteId = widget.idLote?.trim();
    if (_isEmptyLoteId(loteId) ||
        currentLoteId == null ||
        currentLoteId.isEmpty) {
      return false;
    }
    return loteId!.trim() == currentLoteId;
  }

  List<RebanhoStruct> _animalsInOtherLots() {
    return _model.rebanhosSelecionados.where((animal) {
      final loteId = animal.loteId.trim();
      final loteNome = animal.loteNome.trim();

      if (_isCurrentLoteId(loteId)) {
        return false;
      }

      return loteNome.isNotEmpty && loteNome.toLowerCase() != 'null';
    }).toList();
  }

  void _applySelectedAnimalsToLot() {
    final appliedById = <String, RebanhoStruct>{};
    for (final animal in _model.rebanhosAplicados) {
      final id = animal.idRebanho.trim();
      if (id.isNotEmpty) {
        appliedById[id] = animal;
      }
    }
    for (final animal in _model.rebanhosSelecionados) {
      final id = animal.idRebanho.trim();
      if (id.isNotEmpty) {
        appliedById[id] = animal;
      }
    }
    _model.rebanhosAplicados = appliedById.values.toList();
    _model.rebanhoIdAplicados = appliedById.keys.toList();
    _model.rebanhosSelecionados = _model.rebanhosAplicados.toList();
    _model.rebanhoIdSelecionados = _model.rebanhoIdAplicados.toList();
    safeSetState(() {});
  }

  void _showSaveErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Não foi possível salvar o lote. Tente novamente.',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        ),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }

  void _confirmAnimalsAlreadyInLot(
    List<RebanhoStruct> animais,
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
                        '${animal.numeroAnimal} • ${animal.nome} • Lote atual: ${_normalizeLoteNome(animal.loteNome)}',
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
    _model = createModel(context, () => EditLoteModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.rebanhosAplicados =
          FFAppState().rebanhosLote.toList().cast<RebanhoStruct>();
      _model.rebanhosSelecionados =
          FFAppState().rebanhosLote.toList().cast<RebanhoStruct>();
      safeSetState(() {});
      _model.rebanhoIdSelecionados = FFAppState()
          .rebanhosLote
          .map((e) => e.idRebanho)
          .toList()
          .toList()
          .cast<String>();
      _model.rebanhoIdAplicados = FFAppState()
          .rebanhosLote
          .map((e) => e.idRebanho)
          .toList()
          .toList()
          .cast<String>();
      safeSetState(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.nomeloteFocusNode ??= FocusNode();

    _model.anotacoesFocusNode ??= FocusNode();

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

    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: FutureBuilder<List<BuscarLoteRow>>(
              future: SQLiteManager.instance.buscarLote(
                idLote: widget.idLote,
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
                final addloteBuscarLoteRowList = snapshot.data!;

                return Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/Menu_button_(1).png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Lotes',
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
                                            color: const Color(0xFF232908),
                                            fontSize: 22.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ].divide(const SizedBox(width: 8.0)),
                                ),
                                if (FFAppState().userLogado.permissao ==
                                    'Admin')
                                  FlutterFlowIconButton(
                                    borderRadius: 8.0,
                                    buttonSize: 40.0,
                                    fillColor: const Color(0x0028A365),
                                    icon: FaIcon(
                                      FontAwesomeIcons.trashAlt,
                                      color: FlutterFlowTheme.of(context).error,
                                      size: 20.0,
                                    ),
                                    onPressed: () async {
                                      // Check if lote has animals
                                      final animaisNoLote = await SQLiteManager
                                          .instance
                                          .qtdAnimaisNoLote(
                                        loteID: widget.idLote,
                                      );
                                      final qtd = animaisNoLote
                                              .firstOrNull?.qtdAnimais ??
                                          0;
                                      if (qtd > 0) {
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Não é possível excluir'),
                                              content: Text(
                                                  'Este lote possui $qtd ${qtd == 1 ? 'animal' : 'animais'}. Remova os animais do lote antes de excluí-lo.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        return;
                                      }
                                      var confirmDialogResponse =
                                          await showDialog<bool>(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Deletar lote'),
                                                    content: const Text(
                                                        'Deseja realmente apagar esse lote? Esta ação não pode ser desfeita.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext,
                                                                false),
                                                        child:
                                                            const Text('Não'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext,
                                                                true),
                                                        child:
                                                            const Text('Sim'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ) ??
                                              false;
                                      if (confirmDialogResponse) {
                                        if (!(FFAppState()
                                                .dataDadosNaoSyncLotes !=
                                            null)) {
                                          FFAppState().dataDadosNaoSyncLotes =
                                              getCurrentTimestamp;
                                          safeSetState(() {});
                                        }
                                        await SQLiteManager.instance.deleteLote(
                                          idLote: widget.idLote,
                                          updatedat: dateTimeFormat(
                                            "yyyy-MM-dd HH:mm:ss",
                                            getCurrentTimestamp,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                        );
                                        FFAppState().update(() {});
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                              ].divide(const SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: Text(
                            'Adicionar lote',
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
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: const Alignment(0.0, 0),
                                child: TabBar(
                                  labelColor: const Color(0xFF1E7A4C),
                                  unselectedLabelColor:
                                      FlutterFlowTheme.of(context)
                                          .secondaryText,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleMediumFamily,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        lineHeight: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 24.0, 0.0, 24.0),
                                        child: SingleChildScrollView(
                                          primary: false,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              -1.0, -1.0),
                                                      child: Text(
                                                        'Nome do lote*',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              color: const Color(
                                                                  0xFF2F2F2F),
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                                              .nomeloteTextController ??=
                                                          TextEditingController(
                                                        text:
                                                            addloteBuscarLoteRowList
                                                                .firstOrNull
                                                                ?.nome,
                                                      ),
                                                      focusNode: _model
                                                          .nomeloteFocusNode,
                                                      autofocus: true,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: false,
                                                        hintText:
                                                            'Nome do lote',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: const Color(
                                                                      0xFFBEBEBE),
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFF28A365),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        errorBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        focusedErrorBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        filled: true,
                                                      ),
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 16.0,
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
                                                      cursorColor: const Color(
                                                          0xFF28A365),
                                                      validator: _model
                                                          .nomeloteTextControllerValidator
                                                          .asValidator(context),
                                                    ),
                                                  ].divide(const SizedBox(
                                                      height: 8.0)),
                                                ),
                                              ),
                                              Container(
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
                                                          24.0, 0.0, 24.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                -1.0, -1.0),
                                                        child: Text(
                                                          'Anotações',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: const Color(
                                                                    0xFF2F2F2F),
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        controller: _model
                                                                .anotacoesTextController ??=
                                                            TextEditingController(
                                                          text: valueOrDefault<
                                                              String>(
                                                            valueOrDefault<
                                                                        String>(
                                                                      addloteBuscarLoteRowList
                                                                          .firstOrNull
                                                                          ?.anotacoes,
                                                                      'Sem anotações.',
                                                                    ) ==
                                                                    'null'
                                                                ? 'Sem anotações.'
                                                                : valueOrDefault<
                                                                    String>(
                                                                    addloteBuscarLoteRowList
                                                                        .firstOrNull
                                                                        ?.anotacoes,
                                                                    'Sem anotações.',
                                                                  ),
                                                            'Sem anotações.',
                                                          ),
                                                        ),
                                                        focusNode: _model
                                                            .anotacoesFocusNode,
                                                        autofocus: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Escreva algo...',
                                                          hintStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: const Color(
                                                                        0xFFBEBEBE),
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xFF28A365),
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                          errorBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                          filled: true,
                                                        ),
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
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      16.0,
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
                                                        maxLines: 5,
                                                        cursorColor:
                                                            const Color(
                                                                0xFF28A365),
                                                        validator: _model
                                                            .anotacoesTextControllerValidator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ].divide(const SizedBox(
                                                        height: 8.0)),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 80.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        blurRadius: 4.0,
                                                        color:
                                                            Color(0x41000000),
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
                                                      topLeft:
                                                          Radius.circular(6.0),
                                                      topRight:
                                                          Radius.circular(6.0),
                                                    ),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFFBEBEBE),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                            24.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Este lote está ativo?',
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
                                                        Switch.adaptive(
                                                          value: _model
                                                                  .ativoInativoValue ??=
                                                              addloteBuscarLoteRowList
                                                                          .firstOrNull
                                                                          ?.ativo ==
                                                                      'Ativo'
                                                                  ? true
                                                                  : false,
                                                          onChanged:
                                                              (newValue) async {
                                                            safeSetState(() =>
                                                                _model.ativoInativoValue =
                                                                    newValue);
                                                            if (newValue) {
                                                              safeSetState(
                                                                  () {});
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                            }
                                                          },
                                                          activeColor:
                                                              const Color(
                                                                  0xFF28A365),
                                                          activeTrackColor:
                                                              const Color(
                                                                  0xFF28A365),
                                                          inactiveTrackColor:
                                                              const Color(
                                                                  0xFFF1F1F1),
                                                          inactiveThumbColor:
                                                              const Color(
                                                                  0xFF8E8E8E),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (_model.ativoInativoValue ==
                                                  false)
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          width: 150.0,
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
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Motivo',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: const Color(
                                                                          0xFF474747),
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
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 56.0,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF1F1F1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            6.0),
                                                                    bottomRight:
                                                                        Radius.circular(
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
                                                                      child: FlutterFlowDropDown<
                                                                          String>(
                                                                        controller:
                                                                            _model.dropDownMotivoValueController ??=
                                                                                FormFieldController<String>(
                                                                          _model.dropDownMotivoValue ??= addloteBuscarLoteRowList
                                                                              .firstOrNull
                                                                              ?.motivo,
                                                                        ),
                                                                        options: const [
                                                                          'Lote vendido'
                                                                        ],
                                                                        onChanged:
                                                                            (val) =>
                                                                                safeSetState(() => _model.dropDownMotivoValue = val),
                                                                        width:
                                                                            200.0,
                                                                        height:
                                                                            56.0,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        hintText:
                                                                            'Selecionar',
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .keyboard_arrow_down_rounded,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                        elevation:
                                                                            2.0,
                                                                        borderColor:
                                                                            Colors.transparent,
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
                                                            ].divide(
                                                                const SizedBox(
                                                                    height:
                                                                        8.0)),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
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
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Data',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: const Color(
                                                                          0xFF474747),
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
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 56.0,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF1F1F1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            6.0),
                                                                    bottomRight:
                                                                        Radius.circular(
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
                                                                              const Color(0xFF28A365),
                                                                          headerForegroundColor:
                                                                              FlutterFlowTheme.of(context).info,
                                                                          headerTextStyle: FlutterFlowTheme.of(context)
                                                                              .headlineLarge
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).headlineLargeFamily,
                                                                                fontSize: 32.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineLargeIsCustom,
                                                                              ),
                                                                          pickerBackgroundColor:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          pickerForegroundColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          selectedDateTimeBackgroundColor:
                                                                              const Color(0xFF28A365),
                                                                          selectedDateTimeForegroundColor:
                                                                              FlutterFlowTheme.of(context).info,
                                                                          actionButtonForegroundColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
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
                                                                            _model.datePicked;
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          _model.datePicked != null
                                                                              ? valueOrDefault<String>(
                                                                                  dateTimeFormat(
                                                                                    "dd/MM/yyyy",
                                                                                    _model.datePicked,
                                                                                    locale: FFLocalizations.of(context).languageCode,
                                                                                  ),
                                                                                  'Selecione uma data',
                                                                                )
                                                                              : dateTimeFormat(
                                                                                  "d/M/y",
                                                                                  functions.converterParaData(addloteBuscarLoteRowList.firstOrNull?.dataMotivo),
                                                                                  locale: FFLocalizations.of(context).languageCode,
                                                                                ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ].addToStart(
                                                                        const SizedBox(
                                                                            width:
                                                                                12.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(
                                                                const SizedBox(
                                                                    height:
                                                                        8.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ].divide(const SizedBox(
                                                        width: 24.0)),
                                                  ),
                                                ),
                                              if (_model.ativoInativoValue ==
                                                  false)
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          24.0, 5.0, 24.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Valor da venda (R\$)',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
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
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 56.0,
                                                        child: custom_widgets
                                                            .CurrencyInputBR2(
                                                          width:
                                                              double.infinity,
                                                          height: 56.0,
                                                          initialValue:
                                                              valueOrDefault<
                                                                  double>(
                                                            addloteBuscarLoteRowList
                                                                .firstOrNull
                                                                ?.valorVenda,
                                                            0.0,
                                                          ),
                                                          fillColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .customColor3,
                                                          borderColor: Colors
                                                              .transparent,
                                                          focusedBorderColor:
                                                              Colors
                                                                  .transparent,
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
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 0.0, 24.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        blurRadius: 4.0,
                                                        color:
                                                            Color(0x40000000),
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
                                                      topLeft:
                                                          Radius.circular(6.0),
                                                      topRight:
                                                          Radius.circular(6.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(24.0,
                                                            24.0, 24.0, 24.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
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
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'Animais neste lote (${valueOrDefault<String>(
                                                                    FFAppState()
                                                                        .rebanhosLote
                                                                        .length
                                                                        .toString(),
                                                                    '0',
                                                                  )})',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: const Color(
                                                                            0xFF474747),
                                                                        fontSize:
                                                                            18.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                              ),
                                                              if (responsiveVisibility(
                                                                context:
                                                                    context,
                                                                phone: false,
                                                                tablet: false,
                                                                tabletLandscape:
                                                                    false,
                                                                desktop: false,
                                                              ))
                                                                Text(
                                                                  'Ver todos',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: const Color(
                                                                            0xFF1E7A4C),
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  24.0),
                                                          child: Text(
                                                            'Exibindo os primeiros 5 da lista',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent3,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                          ),
                                                        ),
                                                        if (!(FFAppState()
                                                            .rebanhosLote
                                                            .isNotEmpty))
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
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
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/images/Rebanho.svg',
                                                                      width:
                                                                          77.0,
                                                                      height:
                                                                          58.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Nenhum animal foi adicionado',
                                                                    maxLines: 1,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          lineHeight:
                                                                              1.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        if (FFAppState()
                                                            .rebanhosLote
                                                            .isNotEmpty)
                                                          Builder(
                                                            builder: (context) {
                                                              final rebanho =
                                                                  FFAppState()
                                                                      .rebanhosLote
                                                                      .toList()
                                                                      .take(5)
                                                                      .toList();

                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                children: List.generate(
                                                                        rebanho
                                                                            .length,
                                                                        (rebanhoIndex) {
                                                                  final rebanhoItem =
                                                                      rebanho[
                                                                          rebanhoIndex];
                                                                  return Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
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
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
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
                                                                              Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
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
                                                                                        if (rebanhoItem.sexo == 'Macho')
                                                                                          ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Sexomacho.png',
                                                                                              width: 24.0,
                                                                                              height: 24.0,
                                                                                              fit: BoxFit.scaleDown,
                                                                                            ),
                                                                                          ),
                                                                                        if (rebanhoItem.sexo == 'Fêmea')
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
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${valueOrDefault<String>(
                                                                                            rebanhoItem.numeroAnimal,
                                                                                            'numero',
                                                                                          )} • ${valueOrDefault<String>(
                                                                                            () {
                                                                                              if (valueOrDefault<String>(
                                                                                                    rebanhoItem.nome,
                                                                                                    'nome',
                                                                                                  ) ==
                                                                                                  'null') {
                                                                                                return 'S/N';
                                                                                              } else if (valueOrDefault<String>(
                                                                                                    rebanhoItem.nome,
                                                                                                    'nome',
                                                                                                  ) ==
                                                                                                  '') {
                                                                                                return 'S/N';
                                                                                              } else {
                                                                                                return valueOrDefault<String>(
                                                                                                  rebanhoItem.nome,
                                                                                                  'nome',
                                                                                                );
                                                                                              }
                                                                                            }(),
                                                                                            'S/N',
                                                                                          )} • ${dateTimeFormat(
                                                                                            "d/M/y",
                                                                                            functions.converterParaData(rebanhoItem.dataNascimento),
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          )}',
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
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Text(
                                                                                          valueOrDefault<String>(
                                                                                            rebanhoItem.categoria,
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
                                                                                          () {
                                                                                            if (valueOrDefault<String>(
                                                                                                  rebanhoItem.raca,
                                                                                                  'Sem raça',
                                                                                                ) ==
                                                                                                ' ') {
                                                                                              return 'Sem raça';
                                                                                            } else if (valueOrDefault<String>(
                                                                                                  rebanhoItem.raca,
                                                                                                  'Sem raça',
                                                                                                ) ==
                                                                                                '') {
                                                                                              return 'Sem raça';
                                                                                            } else if (valueOrDefault<String>(
                                                                                                  rebanhoItem.raca,
                                                                                                  'Sem raça',
                                                                                                ) ==
                                                                                                'null') {
                                                                                              return 'Sem raça';
                                                                                            } else {
                                                                                              return valueOrDefault<String>(
                                                                                                rebanhoItem.raca,
                                                                                                'Sem raça',
                                                                                              );
                                                                                            }
                                                                                          }(),
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
                                                                                ].divide(const SizedBox(height: 8.0)),
                                                                              ),
                                                                            ].divide(const SizedBox(width: 8.0)),
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
                                                                  );
                                                                })
                                                                    .divide(const SizedBox(
                                                                        height:
                                                                            10.0))
                                                                    .around(const SizedBox(
                                                                        height:
                                                                            10.0)),
                                                              );
                                                            },
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          safeSetState(() {
                                                            _model.anotacoesTextController
                                                                    ?.text =
                                                                valueOrDefault<
                                                                    String>(
                                                              valueOrDefault<
                                                                          String>(
                                                                        addloteBuscarLoteRowList
                                                                            .firstOrNull
                                                                            ?.anotacoes,
                                                                        'Sem anotações.',
                                                                      ) ==
                                                                      'null'
                                                                  ? 'Sem anotações.'
                                                                  : valueOrDefault<
                                                                      String>(
                                                                      addloteBuscarLoteRowList
                                                                          .firstOrNull
                                                                          ?.anotacoes,
                                                                      'Sem anotações.',
                                                                    ),
                                                              'Sem anotações.',
                                                            );

                                                            _model
                                                                .textController3
                                                                ?.clear();
                                                            _model.nomeloteTextController
                                                                    ?.text =
                                                                addloteBuscarLoteRowList
                                                                    .firstOrNull!
                                                                    .nome!;
                                                          });
                                                          safeSetState(() {
                                                            _model.ativoInativoValue =
                                                                addloteBuscarLoteRowList
                                                                            .firstOrNull
                                                                            ?.ativo ==
                                                                        'Ativo'
                                                                    ? true
                                                                    : false;
                                                          });
                                                          _model.rebanhosSelecionados =
                                                              [];
                                                          _model.rebanhosAplicados =
                                                              [];
                                                          safeSetState(() {});
                                                        },
                                                        text: 'Cancelar',
                                                        options:
                                                            FFButtonOptions(
                                                          width: 156.0,
                                                          height: 56.0,
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
                                                              0x004B39EF),
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .titleSmallFamily,
                                                                    color: const Color(
                                                                        0xFF1E7A4C),
                                                                    fontSize:
                                                                        18.0,
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
                                                            color: Color(
                                                                0xFF1E7A4C),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          safeSetState(() {
                                                            _model
                                                                .tabBarController!
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
                                                              curve:
                                                                  Curves.ease,
                                                            );
                                                          });
                                                        },
                                                        text: 'Próximo',
                                                        options:
                                                            FFButtonOptions(
                                                          width: 156.0,
                                                          height: 56.0,
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
                                                                        18.0,
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
                                                    ),
                                                  ]
                                                      .divide(const SizedBox(
                                                          width: 16.0))
                                                      .addToStart(
                                                          const SizedBox(
                                                              width: 24.0))
                                                      .addToEnd(const SizedBox(
                                                          width: 24.0)),
                                                ),
                                              ),
                                            ].divide(
                                                const SizedBox(height: 24.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
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
                                                  sexo: FFAppState()
                                                      .filtroSexoRebanho,
                                                  categoria: FFAppState()
                                                      .filtroCategoriasRebanho,
                                                  raca: FFAppState().filtroRaca,
                                                  origem: FFAppState()
                                                      .filtroOrigemRebanho,
                                                  loteId: FFAppState()
                                                      .filtroLoteRebanho,
                                                  pesquisa: _model
                                                      .textController3.text,
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
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                6.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                6.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                6.0),
                                                        topRight:
                                                            Radius.circular(
                                                                6.0),
                                                      ),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFFBEBEBE),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(12.0,
                                                              12.0, 12.0, 12.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              'Animais fora do lote (${valueOrDefault<String>(
                                                                (valueOrDefault<
                                                                            int>(
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
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: const Color(
                                                                      0xFF181818),
                                                                  fontSize:
                                                                      18.0,
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
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
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
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent4,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent4,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100.0),
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
                                                                            100.0),
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
                                                                            100.0),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  contentPadding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          16.0,
                                                                          8.0,
                                                                          16.0,
                                                                          8.0),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .search_sharp,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    size: 24.0,
                                                                  ),
                                                                  suffixIcon: _model
                                                                          .textController3!
                                                                          .text
                                                                          .isNotEmpty
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            _model.textController3?.clear();
                                                                            safeSetState(() {});
                                                                            safeSetState(() {});
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.clear,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).accent3,
                                                                            size:
                                                                                24.0,
                                                                          ),
                                                                        )
                                                                      : null,
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
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 40.0,
                                                            decoration:
                                                                BoxDecoration(
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
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
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
                                                                      await showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        enableDrag:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Padding(
                                                                            padding:
                                                                                MediaQuery.viewInsetsOf(context),
                                                                            child:
                                                                                const FiltrosRebanhoWidget(),
                                                                          );
                                                                        },
                                                                      ).then((value) =>
                                                                          safeSetState(
                                                                              () {}));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0xFFBEBEBE),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            16.0,
                                                                            8.0,
                                                                            16.0,
                                                                            8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children:
                                                                              [
                                                                            Text(
                                                                              'Filtrar',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                                ].divide(
                                                                    const SizedBox(
                                                                        width:
                                                                            8.0)),
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(
                                                            thickness: 1.0,
                                                            color: Color(
                                                                0xFFEDEDED),
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
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
                                                                          FlutterFlowTheme.of(context)
                                                                              .alternate,
                                                                    ),
                                                                    child:
                                                                        Checkbox(
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
                                                                          _model.index =
                                                                              0;
                                                                          safeSetState(
                                                                              () {});
                                                                          _model.rebanhoIdSelecionados = animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList
                                                                              .map((e) => e.idRebanho)
                                                                              .withoutNulls
                                                                              .toList()
                                                                              .cast<String>();
                                                                          safeSetState(
                                                                              () {});
                                                                          while (_model.index <
                                                                              animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.length) {
                                                                            _model.addToRebanhosSelecionados(RebanhoStruct(
                                                                              idPropriedade: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.idPropriedade,
                                                                              numeroAnimal: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.numeroAnimal,
                                                                              chip: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.chip,
                                                                              codRegistro: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.codRegistro,
                                                                              nome: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.nome,
                                                                              sexo: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.sexo,
                                                                              categoria: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.categoria,
                                                                              dataNascimento: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.dataNascimento,
                                                                              pesoNascimento: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.pesoNascimento,
                                                                              porte: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.porte,
                                                                              raca: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.raca,
                                                                              loteId: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.loteID,
                                                                              dataEntradaLote: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.dataEntradaLote,
                                                                              rebanhoIdMatriz: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.rebanhoIdMatriz,
                                                                              rebanhoIdReprodutor: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.rebanhoIdReprodutor,
                                                                              dataDesmama: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.dataDesmama,
                                                                              pesoDesmama: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.pesoDesmama,
                                                                              pesoAtual: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.pesoAtual,
                                                                              status: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.statusRebanho,
                                                                              origem: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.origem,
                                                                              anotacoes: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.anotacoes,
                                                                              idRebanho: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.idRebanho,
                                                                              tipo: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.tipo,
                                                                              dataAcao: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.dataAcao,
                                                                              valorCompra: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.valorCompra,
                                                                              dataUltimaPesagem: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.dataUltimaPesagem,
                                                                              nomeConcat: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.nomeConcat,
                                                                              loteNome: animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList.elementAtOrNull(_model.index)?.loteNome,
                                                                            ));
                                                                            safeSetState(() {});
                                                                            _model.index =
                                                                                _model.index + 1;
                                                                            safeSetState(() {});
                                                                          }
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
                                                                        width:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
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
                                                                  Text(
                                                                    'Selecionar todos',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        width:
                                                                            5.0)),
                                                              ),
                                                              FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  final animaisEmOutrosLotes =
                                                                      _animalsInOtherLots();
                                                                  _confirmAnimalsAlreadyInLot(
                                                                      animaisEmOutrosLotes);
                                                                },
                                                                text:
                                                                    'Adicionar',
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
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).titleSmallFamily,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                      ),
                                                                  elevation:
                                                                      0.0,
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
                                                              final rebanhosSelect = animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList
                                                                  .where((e) =>
                                                                      e.statusRebanho ==
                                                                      'Na propriedade')
                                                                  .toList()
                                                                  .sortedList(
                                                                      keyOf: (e) =>
                                                                          e.createdAt ??
                                                                          '',
                                                                      desc:
                                                                          true)
                                                                  .take(_model
                                                                      .mostrarFora)
                                                                  .toList();

                                                              return ListView
                                                                  .builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                primary: false,
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    rebanhosSelect
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
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
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          8.0),
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
                                                                          Theme(
                                                                            data:
                                                                                ThemeData(
                                                                              checkboxTheme: CheckboxThemeData(
                                                                                visualDensity: VisualDensity.compact,
                                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                ),
                                                                              ),
                                                                              unselectedWidgetColor: FlutterFlowTheme.of(context).alternate,
                                                                            ),
                                                                            child:
                                                                                Checkbox(
                                                                              value: _model.checkboxValueMap2[rebanhosSelectItem] ??= _model.rebanhoIdSelecionados.contains(rebanhosSelectItem.idRebanho),
                                                                              onChanged: _model.rebanhoIdAplicados.contains(rebanhosSelectItem.idRebanho)
                                                                                  ? null
                                                                                  : (newValue) async {
                                                                                      safeSetState(() => _model.checkboxValueMap2[rebanhosSelectItem] = newValue!);
                                                                                      if (newValue!) {
                                                                                        _model.addToRebanhosSelecionados(RebanhoStruct(
                                                                                          idPropriedade: rebanhosSelectItem.idPropriedade,
                                                                                          numeroAnimal: rebanhosSelectItem.numeroAnimal,
                                                                                          chip: rebanhosSelectItem.chip,
                                                                                          codRegistro: rebanhosSelectItem.codRegistro,
                                                                                          nome: rebanhosSelectItem.nome,
                                                                                          sexo: rebanhosSelectItem.sexo,
                                                                                          categoria: rebanhosSelectItem.categoria,
                                                                                          dataNascimento: rebanhosSelectItem.dataNascimento,
                                                                                          pesoNascimento: rebanhosSelectItem.pesoNascimento,
                                                                                          porte: rebanhosSelectItem.porte,
                                                                                          raca: rebanhosSelectItem.raca,
                                                                                          loteId: rebanhosSelectItem.loteID,
                                                                                          dataEntradaLote: rebanhosSelectItem.dataEntradaLote,
                                                                                          rebanhoIdMatriz: rebanhosSelectItem.rebanhoIdMatriz,
                                                                                          rebanhoIdReprodutor: rebanhosSelectItem.rebanhoIdReprodutor,
                                                                                          dataDesmama: rebanhosSelectItem.dataDesmama,
                                                                                          pesoDesmama: rebanhosSelectItem.pesoDesmama,
                                                                                          pesoAtual: rebanhosSelectItem.pesoAtual,
                                                                                          status: rebanhosSelectItem.statusRebanho,
                                                                                          origem: rebanhosSelectItem.origem,
                                                                                          anotacoes: rebanhosSelectItem.anotacoes,
                                                                                          idRebanho: rebanhosSelectItem.idRebanho,
                                                                                          tipo: rebanhosSelectItem.tipo,
                                                                                          dataAcao: rebanhosSelectItem.dataAcao,
                                                                                          valorCompra: rebanhosSelectItem.valorCompra,
                                                                                          dataUltimaPesagem: rebanhosSelectItem.dataUltimaPesagem,
                                                                                          nomeConcat: rebanhosSelectItem.nomeConcat,
                                                                                          loteNome: rebanhosSelectItem.loteNome,
                                                                                        ));
                                                                                        _model.addToRebanhoIdSelecionados(rebanhosSelectItem.idRebanho!);
                                                                                        safeSetState(() {});
                                                                                      } else {
                                                                                        _model.removeFromRebanhosSelecionados(RebanhoStruct(
                                                                                          idPropriedade: rebanhosSelectItem.idPropriedade,
                                                                                          numeroAnimal: rebanhosSelectItem.numeroAnimal,
                                                                                          chip: rebanhosSelectItem.chip,
                                                                                          codRegistro: rebanhosSelectItem.codRegistro,
                                                                                          nome: rebanhosSelectItem.nome,
                                                                                          sexo: rebanhosSelectItem.sexo,
                                                                                          categoria: rebanhosSelectItem.categoria,
                                                                                          dataNascimento: rebanhosSelectItem.dataNascimento,
                                                                                          pesoNascimento: rebanhosSelectItem.pesoNascimento,
                                                                                          porte: rebanhosSelectItem.porte,
                                                                                          raca: rebanhosSelectItem.raca,
                                                                                          loteId: rebanhosSelectItem.loteID,
                                                                                          dataEntradaLote: rebanhosSelectItem.dataEntradaLote,
                                                                                          rebanhoIdMatriz: rebanhosSelectItem.rebanhoIdMatriz,
                                                                                          rebanhoIdReprodutor: rebanhosSelectItem.rebanhoIdReprodutor,
                                                                                          dataDesmama: rebanhosSelectItem.dataDesmama,
                                                                                          pesoDesmama: rebanhosSelectItem.pesoDesmama,
                                                                                          pesoAtual: rebanhosSelectItem.pesoAtual,
                                                                                          status: rebanhosSelectItem.statusRebanho,
                                                                                          origem: rebanhosSelectItem.origem,
                                                                                          anotacoes: rebanhosSelectItem.anotacoes,
                                                                                          idRebanho: rebanhosSelectItem.idRebanho,
                                                                                          tipo: rebanhosSelectItem.tipo,
                                                                                          dataAcao: rebanhosSelectItem.dataAcao,
                                                                                          valorCompra: rebanhosSelectItem.valorCompra,
                                                                                          dataUltimaPesagem: rebanhosSelectItem.dataUltimaPesagem,
                                                                                          nomeConcat: rebanhosSelectItem.nomeConcat,
                                                                                          loteNome: rebanhosSelectItem.loteNome,
                                                                                        ));
                                                                                        _model.removeFromRebanhoIdSelecionados(rebanhosSelectItem.idRebanho!);
                                                                                        safeSetState(() {});
                                                                                      }
                                                                                    },
                                                                              side: BorderSide(
                                                                                width: 2,
                                                                                color: FlutterFlowTheme.of(context).alternate,
                                                                              ),
                                                                              activeColor: FlutterFlowTheme.of(context).secondary,
                                                                              checkColor: _model.rebanhoIdAplicados.contains(rebanhosSelectItem.idRebanho) ? null : FlutterFlowTheme.of(context).info,
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
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
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
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
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
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
                                                                                          )} • Raça: ${(valueOrDefault<String>(
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
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                        Flexible(
                                                                                          child: Text(
                                                                                            valueOrDefault<String>(
                                                                                              () {
                                                                                                if (rebanhosSelectItem.loteNome == ' ') {
                                                                                                  return 'S/L';
                                                                                                } else if (rebanhosSelectItem.loteNome == 'null') {
                                                                                                  return 'S/L';
                                                                                                } else if (rebanhosSelectItem.loteNome == null || rebanhosSelectItem.loteNome == '') {
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
                                                                                        ),
                                                                                      ].divide(const SizedBox(width: 5.0)),
                                                                                    ),
                                                                                    if ((rebanhosSelectItem.dataEntradaLote != 'null') || (rebanhosSelectItem.loteID != 'null') || (rebanhosSelectItem.loteID != ' '))
                                                                                      Text(
                                                                                        '(entrada em ${dateTimeFormat(
                                                                                          "d/M/y",
                                                                                          functions.converterParaData(rebanhosSelectItem.dataEntradaLote),
                                                                                          locale: FFLocalizations.of(context).languageCode,
                                                                                        )})',
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                              color: FlutterFlowTheme.of(context).customColor6,
                                                                                              letterSpacing: 0.0,
                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                            ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ].divide(const SizedBox(height: 8.0)),
                                                                            ),
                                                                          ),
                                                                        ].divide(const SizedBox(width: 8.0)),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              if (_model
                                                                      .mostrarFora >
                                                                  10)
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
                                                                    _model.mostrarFora =
                                                                        _model.mostrarFora +
                                                                            -10;
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        'Mostrar menos',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .keyboard_arrow_up,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              if (_model
                                                                      .mostrarFora <
                                                                  animaisForaLoteBuscaRebanhoPaginadaPesquisaRowList
                                                                      .length)
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
                                                                    _model.mostrarFora =
                                                                        _model.mostrarFora +
                                                                            10;
                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        'Mostrar mais',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: FlutterFlowTheme.of(context).secondary,
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .keyboard_arrow_down_outlined,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                            ],
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6.0),
                                                    bottomRight:
                                                        Radius.circular(6.0),
                                                    topLeft:
                                                        Radius.circular(6.0),
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
                                                          .fromSTEB(12.0, 12.0,
                                                          12.0, 12.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        valueOrDefault<String>(
                                                          'Animais adicionados (${valueOrDefault<String>(
                                                            _model
                                                                .rebanhosAplicados
                                                                .length
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
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: TextFormField(
                                                          controller: _model
                                                              .pesquisarTextController,
                                                          focusNode: _model
                                                              .pesquisarFocusNode,
                                                          onChanged: (_) =>
                                                              EasyDebounce
                                                                  .debounce(
                                                            '_model.pesquisarTextController',
                                                            const Duration(
                                                                milliseconds:
                                                                    2000),
                                                            () => safeSetState(
                                                                () {}),
                                                          ),
                                                          autofocus: false,
                                                          obscureText: false,
                                                          decoration:
                                                              InputDecoration(
                                                            isDense: true,
                                                            labelStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .labelMediumIsCustom,
                                                                    ),
                                                            hintText:
                                                                'Pesquisar',
                                                            hintStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily,
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .labelMediumIsCustom,
                                                                    ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
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
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
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
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
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
                                                              borderSide:
                                                                  BorderSide(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
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
                                                              Icons
                                                                  .search_sharp,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent3,
                                                              size: 24.0,
                                                            ),
                                                            suffixIcon: _model
                                                                    .pesquisarTextController!
                                                                    .text
                                                                    .isNotEmpty
                                                                ? InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      _model
                                                                          .pesquisarTextController
                                                                          ?.clear();
                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .clear,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent3,
                                                                      size: 22,
                                                                    ),
                                                                  )
                                                                : null,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                lineHeight: 1.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMediumIsCustom,
                                                              ),
                                                          cursorColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                          validator: _model
                                                              .pesquisarTextControllerValidator
                                                              .asValidator(
                                                                  context),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              _model.rebanhosIDAux = _model
                                                                  .rebanhoIdAplicados
                                                                  .toList()
                                                                  .cast<
                                                                      String>();
                                                              safeSetState(
                                                                  () {});
                                                              _model.rebanhoIdAplicados =
                                                                  [];
                                                              _model.rebanhosAplicados =
                                                                  [];
                                                              safeSetState(
                                                                  () {});
                                                            },
                                                            text:
                                                                'Remover Todos',
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
                                                                  0xFFFF0000),
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).titleSmallFamily,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).titleSmallIsCustom,
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
                                                      if (_model
                                                          .rebanhosAplicados
                                                          .isNotEmpty)
                                                        Builder(
                                                          builder: (context) {
                                                            final rebanhoAplicado = _model
                                                                .rebanhosAplicados
                                                                .where((e) =>
                                                                    (_model.pesquisarTextController
                                                                            .text ==
                                                                        '') ||
                                                                    (e.numeroAnimal.toLowerCase().contains(_model.pesquisarTextController.text.toLowerCase()) ||
                                                                        e.nome.toLowerCase().contains(_model
                                                                            .pesquisarTextController
                                                                            .text
                                                                            .toLowerCase()) ||
                                                                        e.chip.toLowerCase().contains(_model
                                                                            .pesquisarTextController
                                                                            .text
                                                                            .toLowerCase())))
                                                                .toList()
                                                                .take(
                                                                    _model.mostrarAdicionados)
                                                                .toList();

                                                            return ListView
                                                                .separated(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
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
                                                                      height:
                                                                          8.0),
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
                                                                                VisualDensity.compact,
                                                                            materialTapTargetSize:
                                                                                MaterialTapTargetSize.shrinkWrap,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(4.0),
                                                                            ),
                                                                          ),
                                                                          unselectedWidgetColor:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                        ),
                                                                        child:
                                                                            Checkbox(
                                                                          value: _model.checkboxValueMap3[rebanhoAplicadoItem] ??=
                                                                              true,
                                                                          onChanged:
                                                                              (newValue) async {
                                                                            safeSetState(() =>
                                                                                _model.checkboxValueMap3[rebanhoAplicadoItem] = newValue!);

                                                                            if (!newValue!) {
                                                                              _model.addToRebanhosIDAux(rebanhoAplicadoItem.idRebanho);
                                                                              safeSetState(() {});
                                                                              _model.removeFromRebanhosAplicados(rebanhoAplicadoItem);
                                                                              _model.removeFromRebanhosSelecionados(rebanhoAplicadoItem);
                                                                              _model.removeFromRebanhoIdAplicados(rebanhoAplicadoItem.idRebanho);
                                                                              _model.removeFromRebanhoIdSelecionados(rebanhoAplicadoItem.idRebanho);
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
                                                                          checkColor:
                                                                              FlutterFlowTheme.of(context).info,
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children:
                                                                            [
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
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
                                                                                if (rebanhoAplicadoItem.sexo == 'Macho')
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: Image.asset(
                                                                                      'assets/images/Sexomacho.png',
                                                                                      width: 24.0,
                                                                                      height: 24.0,
                                                                                      fit: BoxFit.scaleDown,
                                                                                    ),
                                                                                  ),
                                                                                if (rebanhoAplicadoItem.sexo == 'Fêmea')
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
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
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
                                                                                      if (valueOrDefault<String>(
                                                                                            rebanhoAplicadoItem.nome,
                                                                                            'nome',
                                                                                          ) ==
                                                                                          'null') {
                                                                                        return 'S/N';
                                                                                      } else if (valueOrDefault<String>(
                                                                                            rebanhoAplicadoItem.nome,
                                                                                            'nome',
                                                                                          ) ==
                                                                                          '') {
                                                                                        return 'S/N';
                                                                                      } else {
                                                                                        return valueOrDefault<String>(
                                                                                          rebanhoAplicadoItem.nome,
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
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Text(
                                                                                  '${(rebanhoAplicadoItem.categoria == 'null') || (rebanhoAplicadoItem.categoria == '') ? 'N/A' : rebanhoAplicadoItem.categoria} • Raça: ${(rebanhoAplicadoItem.raca == 'null') || (rebanhoAplicadoItem.raca == '') ? 'N/A' : rebanhoAplicadoItem.raca}',
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
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: SvgPicture.asset(
                                                                                      'assets/images/Lotes_(2).svg',
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
                                                                                        if (rebanhoAplicadoItem.loteNome == '  ') {
                                                                                          return 'S/L';
                                                                                        } else if (rebanhoAplicadoItem.loteNome == 'null') {
                                                                                          return 'S/L';
                                                                                        } else if (rebanhoAplicadoItem.loteNome == '') {
                                                                                          return 'S/L';
                                                                                        } else {
                                                                                          return rebanhoAplicadoItem.loteNome;
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
                                                                              if ((rebanhoAplicadoItem.dataEntradaLote != ' null') || (rebanhoAplicadoItem.loteId != 'null') || (rebanhoAplicadoItem.loteId != ' '))
                                                                                Text(
                                                                                  '(entrada em ${valueOrDefault<String>(
                                                                                    dateTimeFormat(
                                                                                      "d/M/y",
                                                                                      functions.converterParaData(rebanhoAplicadoItem.dataEntradaLote),
                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                    ),
                                                                                    'S/D',
                                                                                  )})',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).customColor6,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ].divide(const SizedBox(height: 8.0)),
                                                                      ),
                                                                    ].divide(const SizedBox(
                                                                        width:
                                                                            8.0)),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      if (!(_model
                                                          .rebanhosAplicados
                                                          .isNotEmpty))
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                                _model.mostrarAdicionados =
                                                                    _model.mostrarAdicionados +
                                                                        -5;
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Mostrar menos',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .keyboard_arrow_up,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    size: 24.0,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          if (_model
                                                                  .mostrarAdicionados <
                                                              _model
                                                                  .rebanhosAplicados
                                                                  .length)
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
                                                                _model.mostrarAdicionados =
                                                                    _model.mostrarAdicionados +
                                                                        5;
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Mostrar mais',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                                    size: 24.0,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ].divide(const SizedBox(
                                                        height: 16.0)),
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
                                                      Navigator.pop(context);
                                                    },
                                                    text: 'Cancelar',
                                                    options: FFButtonOptions(
                                                      width: 155.0,
                                                      height: 56.0,
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(24.0,
                                                              0.0, 24.0, 0.0),
                                                      iconPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              0.0, 0.0, 0.0),
                                                      color: const Color(
                                                          0x001E7A4C),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmallFamily,
                                                                color: const Color(
                                                                    0xFF1E7A4C),
                                                                fontSize: 18.0,
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
                                                        color:
                                                            Color(0xFF1E7A4C),
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
                                                    onPressed:
                                                        (_model.nomeloteTextController
                                                                    .text ==
                                                                '')
                                                            ? null
                                                            : () async {
                                                                if (_isSaving) {
                                                                  return;
                                                                }
                                                                _isSaving =
                                                                    true;
                                                                safeSetState(
                                                                    () {});
                                                                try {
                                                                  if (!(FFAppState()
                                                                          .dataDadosNaoSyncLotes !=
                                                                      null)) {
                                                                    FFAppState()
                                                                            .dataDadosNaoSyncLotes =
                                                                        getCurrentTimestamp;
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                  _model.index =
                                                                      0;
                                                                  safeSetState(
                                                                      () {});
                                                                  if (_model
                                                                      .rebanhoIdAplicados
                                                                      .isNotEmpty) {
                                                                    while (_model
                                                                            .index <
                                                                        _model
                                                                            .rebanhoIdAplicados
                                                                            .length) {
                                                                      _model.rebanhoIndex = await SQLiteManager
                                                                          .instance
                                                                          .buscarRebanho(
                                                                        idRebanho: _model
                                                                            .rebanhoIdAplicados
                                                                            .elementAtOrNull(_model.index),
                                                                      );
                                                                      final loteIdAtual = _model
                                                                          .rebanhoIndex
                                                                          ?.firstOrNull
                                                                          ?.loteID;
                                                                      if (_isEmptyLoteId(
                                                                              loteIdAtual) ||
                                                                          _isCurrentLoteId(
                                                                              loteIdAtual)) {
                                                                        if (_model.ativoInativoValue ==
                                                                            true) {
                                                                          await SQLiteManager
                                                                              .instance
                                                                              .uPDTRebanhoLote(
                                                                            loteNome:
                                                                                _model.nomeloteTextController.text,
                                                                            loteID:
                                                                                widget.idLote,
                                                                            updatedat:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            idRebanho:
                                                                                _model.rebanhoIdAplicados.elementAtOrNull(_model.index),
                                                                            dataEntradaLote:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                          );
                                                                        } else if (_model.dropDownMotivoValue != null &&
                                                                            _model.dropDownMotivoValue !=
                                                                                '' &&
                                                                            _model.datePicked !=
                                                                                null &&
                                                                            FFAppState().valueDouble2 >
                                                                                0) {
                                                                          await SQLiteManager
                                                                              .instance
                                                                              .uPDTRebanhoLoteVenda(
                                                                            loteNome:
                                                                                _model.nomeloteTextController.text,
                                                                            loteID:
                                                                                widget.idLote,
                                                                            updatedat:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            idRebanho:
                                                                                _model.rebanhoIdAplicados.elementAtOrNull(_model.index),
                                                                            dataEntradaLote:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            dataVenda:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd",
                                                                              _model.datePicked,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            valorVenda:
                                                                                FFAppState().valueDouble2,
                                                                          );
                                                                        } else {
                                                                          await SQLiteManager
                                                                              .instance
                                                                              .uPDTRebanhoLote(
                                                                            loteNome:
                                                                                _model.nomeloteTextController.text,
                                                                            loteID:
                                                                                widget.idLote,
                                                                            updatedat:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            idRebanho:
                                                                                _model.rebanhoIdAplicados.elementAtOrNull(_model.index),
                                                                            dataEntradaLote:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                          );
                                                                        }
                                                                      } else {
                                                                        _model.loteAnimalExiste = await SQLiteManager
                                                                            .instance
                                                                            .buscarLote(
                                                                          idLote:
                                                                              loteIdAtual,
                                                                        );
                                                                        final animaisDoLoteExistente =
                                                                            _model.loteAnimalExiste?.firstOrNull?.idAnimais ??
                                                                                '[]';
                                                                        _model.idAnimais = functions
                                                                            .converterJSONparaLista(animaisDoLoteExistente)
                                                                            .toList()
                                                                            .cast<String>();
                                                                        safeSetState(
                                                                            () {});
                                                                        _model.removeFromIdAnimais(_model
                                                                            .rebanhoIdAplicados
                                                                            .elementAtOrNull(_model.index)!);
                                                                        safeSetState(
                                                                            () {});
                                                                        await SQLiteManager
                                                                            .instance
                                                                            .uPDTLoteRebanho(
                                                                          idAnimais: functions.converterListaParaJSON(_model
                                                                              .idAnimais
                                                                              .toList()),
                                                                          updatedat:
                                                                              dateTimeFormat(
                                                                            "yyyy-MM-dd HH:mm:ss",
                                                                            getCurrentTimestamp,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          idLote:
                                                                              loteIdAtual,
                                                                        );
                                                                        if (_model.ativoInativoValue ==
                                                                            true) {
                                                                          await SQLiteManager
                                                                              .instance
                                                                              .uPDTRebanhoLote(
                                                                            loteNome:
                                                                                _model.nomeloteTextController.text,
                                                                            loteID:
                                                                                widget.idLote,
                                                                            updatedat:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            idRebanho:
                                                                                _model.rebanhoIdAplicados.elementAtOrNull(_model.index),
                                                                            dataEntradaLote:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                          );
                                                                        } else if (_model.dropDownMotivoValue != null &&
                                                                            _model.dropDownMotivoValue !=
                                                                                '' &&
                                                                            _model.datePicked !=
                                                                                null &&
                                                                            FFAppState().valueDouble2 >
                                                                                0) {
                                                                          await SQLiteManager
                                                                              .instance
                                                                              .uPDTRebanhoLoteVenda(
                                                                            loteNome:
                                                                                _model.nomeloteTextController.text,
                                                                            loteID:
                                                                                widget.idLote,
                                                                            updatedat:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            idRebanho:
                                                                                _model.rebanhoIdAplicados.elementAtOrNull(_model.index),
                                                                            dataEntradaLote:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            dataVenda:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd",
                                                                              _model.datePicked,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            valorVenda:
                                                                                FFAppState().valueDouble2,
                                                                          );
                                                                        } else {
                                                                          await SQLiteManager
                                                                              .instance
                                                                              .uPDTRebanhoLote(
                                                                            loteNome:
                                                                                _model.nomeloteTextController.text,
                                                                            loteID:
                                                                                widget.idLote,
                                                                            updatedat:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            idRebanho:
                                                                                _model.rebanhoIdAplicados.elementAtOrNull(_model.index),
                                                                            dataEntradaLote:
                                                                                dateTimeFormat(
                                                                              "yyyy-MM-dd HH:mm:ss",
                                                                              getCurrentTimestamp,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                          );
                                                                        }
                                                                      }

                                                                      _model.index =
                                                                          _model.index +
                                                                              1;
                                                                      safeSetState(
                                                                          () {});
                                                                    }
                                                                    if (!(FFAppState()
                                                                            .dataDadosNaoSyncRebanho !=
                                                                        null)) {
                                                                      FFAppState()
                                                                              .dataDadosNaoSyncRebanho =
                                                                          getCurrentTimestamp;
                                                                      safeSetState(
                                                                          () {});
                                                                    }
                                                                  }
                                                                  if (_model
                                                                      .rebanhosIDAux
                                                                      .isNotEmpty) {
                                                                    _model.index =
                                                                        0;
                                                                    safeSetState(
                                                                        () {});
                                                                    while (_model
                                                                            .index <
                                                                        _model
                                                                            .rebanhosIDAux
                                                                            .length) {
                                                                      if (_model
                                                                              .ativoInativoValue ==
                                                                          true) {
                                                                        await SQLiteManager
                                                                            .instance
                                                                            .uPDTRebanhoLote(
                                                                          loteNome:
                                                                              ' ',
                                                                          loteID:
                                                                              ' ',
                                                                          updatedat:
                                                                              dateTimeFormat(
                                                                            "yyyy-MM-dd HH:mm:ss",
                                                                            getCurrentTimestamp,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          idRebanho: _model
                                                                              .rebanhosIDAux
                                                                              .elementAtOrNull(_model.index),
                                                                          dataEntradaLote:
                                                                              ' ',
                                                                        );
                                                                      } else if (_model.dropDownMotivoValue != null &&
                                                                          _model.dropDownMotivoValue !=
                                                                              '' &&
                                                                          _model.datePicked !=
                                                                              null &&
                                                                          FFAppState().valueDouble2 >
                                                                              0) {
                                                                        await SQLiteManager
                                                                            .instance
                                                                            .uPDTRebanhoLoteVenda(
                                                                          loteNome:
                                                                              ' ',
                                                                          loteID:
                                                                              ' ',
                                                                          updatedat:
                                                                              dateTimeFormat(
                                                                            "yyyy-MM-dd HH:mm:ss",
                                                                            getCurrentTimestamp,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          idRebanho: _model
                                                                              .rebanhosIDAux
                                                                              .elementAtOrNull(_model.index),
                                                                          dataEntradaLote:
                                                                              ' ',
                                                                          dataVenda:
                                                                              ' ',
                                                                          valorVenda:
                                                                              0.0,
                                                                        );
                                                                      } else {
                                                                        await SQLiteManager
                                                                            .instance
                                                                            .uPDTRebanhoLote(
                                                                          loteNome:
                                                                              ' ',
                                                                          loteID:
                                                                              ' ',
                                                                          updatedat:
                                                                              dateTimeFormat(
                                                                            "yyyy-MM-dd HH:mm:ss",
                                                                            getCurrentTimestamp,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          idRebanho: _model
                                                                              .rebanhosIDAux
                                                                              .elementAtOrNull(_model.index),
                                                                          dataEntradaLote:
                                                                              ' ',
                                                                        );
                                                                      }

                                                                      _model.index =
                                                                          _model.index +
                                                                              1;
                                                                      safeSetState(
                                                                          () {});
                                                                    }
                                                                  }
                                                                  await SQLiteManager
                                                                      .instance
                                                                      .uPDTLote(
                                                                    idAnimais: functions.converterListaParaJSON(_model
                                                                        .rebanhoIdAplicados
                                                                        .toList()),
                                                                    nome: _model
                                                                        .nomeloteTextController
                                                                        .text,
                                                                    anotacoes: _model
                                                                        .anotacoesTextController
                                                                        .text,
                                                                    ativo: _model.ativoInativoValue ==
                                                                            true
                                                                        ? 'Ativo'
                                                                        : 'Inativo',
                                                                    motivo: _model
                                                                        .dropDownMotivoValue,
                                                                    dataMotivo: _model.datePicked !=
                                                                            null
                                                                        ? dateTimeFormat(
                                                                            "d/M/y",
                                                                            _model.datePicked,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          )
                                                                        : addloteBuscarLoteRowList
                                                                            .firstOrNull
                                                                            ?.dataMotivo,
                                                                    updatedat:
                                                                        dateTimeFormat(
                                                                      "yyyy-MM-dd HH:mm:ss",
                                                                      getCurrentTimestamp,
                                                                      locale: FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                    ),
                                                                    idLote: widget
                                                                        .idLote,
                                                                    valorVenda:
                                                                        FFAppState()
                                                                            .valueDouble2,
                                                                  );
                                                                  _model.rebanhosSelecionados =
                                                                      [];
                                                                  _model.rebanhosAplicados =
                                                                      [];
                                                                  safeSetState(
                                                                      () {});
                                                                  await action_blocks
                                                                      .countLotesAtivoInativo(
                                                                          context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Text(
                                                                        'Lote editado com sucesso.',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                        ),
                                                                      ),
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              4000),
                                                                      backgroundColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary,
                                                                    ),
                                                                  );

                                                                  safeSetState(
                                                                      () {});
                                                                } catch (e, s) {
                                                                  debugPrint(
                                                                      '[EditLote] Erro ao salvar lote: $e\n$s');
                                                                  if (mounted) {
                                                                    _showSaveErrorSnackBar();
                                                                  }
                                                                } finally {
                                                                  if (mounted) {
                                                                    _isSaving =
                                                                        false;
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
                                                              .fromSTEB(24.0,
                                                              0.0, 24.0, 0.0),
                                                      iconPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              0.0, 0.0, 0.0),
                                                      color: const Color(
                                                          0xFF28A365),
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
                                                                fontSize: 18.0,
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
                                                        color:
                                                            Colors.transparent,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      disabledColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                    ),
                                                  ),
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 16.0)),
                                            ),
                                          ].divide(
                                              const SizedBox(height: 32.0)),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
