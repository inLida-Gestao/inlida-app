import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/rebanho/popup_rebanhos/popup_rebanhos_widget.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'edit_reproducao_rebanho_model.dart';
export 'edit_reproducao_rebanho_model.dart';

class EditReproducaoRebanhoWidget extends StatefulWidget {
  const EditReproducaoRebanhoWidget({
    super.key,
    required this.idReproducao,
  });

  final String? idReproducao;

  @override
  State<EditReproducaoRebanhoWidget> createState() =>
      _EditReproducaoRebanhoWidgetState();
}

class _EditReproducaoRebanhoWidgetState
    extends State<EditReproducaoRebanhoWidget> {
  late EditReproducaoRebanhoModel _model;
  bool _isSaving = false;
  bool _dataPartidaSemenCleared = false;
  bool _dataStatusCleared = false;
  bool _previsaoPartoCleared = false;
  bool _dataPartoCleared = false;

  String? _normalizeRessincValue(String? value) {
    if (value == null) return null;
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty || normalized == '-' || normalized == 'null') {
      return null;
    }
    if (normalized == 'tradicional') return 'Tradicional';
    if (normalized == 'precoce') return 'Precoce';
    if (normalized == 'superprecoce') return 'Superprecoce';
    return null;
  }

  String? _normalizeSimNaoValue(String? value) {
    if (value == null) return null;
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty || normalized == '-' || normalized == 'null') {
      return null;
    }
    if (normalized == 'sim' || normalized == 's' || normalized == 'yes') {
      return 'Sim';
    }
    if (normalized == 'não' ||
        normalized == 'nao' ||
        normalized == 'n' ||
        normalized == 'no') {
      return 'Não';
    }
    return null;
  }

  String _normalizeDisplayText(String? value, String fallback) {
    if (value == null) return fallback;
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
      return fallback;
    }
    return normalized;
  }

  String _formatDisplayDate(BuildContext context, String? value) {
    if (value == null) return 'N/A';
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
      return 'N/A';
    }
    return dateTimeFormat(
      "d/M/y",
      functions.converterParaData(normalized),
      locale: FFLocalizations.of(context).languageCode,
    );
  }

  String _normalizeInputText(String? value) {
    if (value == null) return '';
    final normalized = value.trim();
    if (normalized.isEmpty) return '';

    final lowercase = normalized.toLowerCase();
    if (lowercase == 'null' || lowercase == 'n/a' || normalized == '-') {
      return '';
    }

    return normalized;
  }

  DateTime? _parseEditableDate(String? value) {
    final normalized = _normalizeInputText(value);
    if (normalized.isEmpty) {
      return null;
    }

    return functions.converterParaData(normalized);
  }

  String _formatEditableDate(
    BuildContext context, {
    DateTime? selectedDate,
    String? storedValue,
    String placeholder = 'Selecione uma data',
    bool cleared = false,
  }) {
    if (cleared) {
      return placeholder;
    }

    final effectiveDate = selectedDate ?? _parseEditableDate(storedValue);
    if (effectiveDate == null) {
      return placeholder;
    }

    return dateTimeFormat(
      "d/M/y",
      effectiveDate,
      locale: FFLocalizations.of(context).languageCode,
    );
  }

  Color _editableDateColor(
    BuildContext context, {
    DateTime? selectedDate,
    String? storedValue,
    bool cleared = false,
  }) {
    final hasValue = !cleared &&
        (selectedDate != null || _parseEditableDate(storedValue) != null);
    return hasValue
        ? FlutterFlowTheme.of(context).secondaryText
        : const Color(0xFFBEBEBE);
  }

  bool _hasEditableDateValue(DateTime? selectedDate, String? storedValue,
      {bool cleared = false}) {
    return !cleared &&
        (selectedDate != null || _parseEditableDate(storedValue) != null);
  }

  String _buildReprodutorLabel(
      BuildContext context, BuscarReproducaoRow? reproducao) {
    final appStateNum = FFAppState().reprodutorSelecionado.numAnimal;
    final hasAppStateSelection =
        appStateNum.trim().isNotEmpty && appStateNum.toLowerCase() != 'null';

    final numero = hasAppStateSelection
        ? _normalizeDisplayText(appStateNum, 'S/N')
        : _normalizeDisplayText(reproducao?.numReprodutor, 'S/N');

    final nome = hasAppStateSelection
        ? _normalizeDisplayText(
            FFAppState().reprodutorSelecionado.nomeAnimal, 'S/N')
        : _normalizeDisplayText(reproducao?.nomeReprodutor, 'S/N');

    final nascimento = hasAppStateSelection
        ? _formatDisplayDate(
            context, FFAppState().reprodutorSelecionado.dataNascAnimal)
        : _formatDisplayDate(context, reproducao?.nascimentoReprodutor);

    return '$numero • $nome • $nascimento';
  }

  DateTime? _resolveDataInseminacao(BuscarReproducaoRow? reproducao) {
    return _model.datePicked1 ??
        functions.converterParaData(reproducao?.dataInseminacao);
  }

  DateTime? _resolveDataParto(BuscarReproducaoRow? reproducao) {
    return _model.datePicked7 ??
        functions.converterParaData(reproducao?.dataParto);
  }

  bool _isPartoConfirmado(BuscarReproducaoRow? reproducao) {
    if (_model.checkboxParidaValue != null) {
      return _model.checkboxParidaValue!;
    }

    final parida = reproducao?.parida?.trim().toLowerCase();
    if (parida == 'sim') {
      return true;
    }

    final dataParto = reproducao?.dataParto?.trim().toLowerCase();
    return dataParto != null && dataParto.isNotEmpty && dataParto != '-';
  }

  int? _resolveDiasEntreInseminacaoEParto(BuscarReproducaoRow? reproducao) {
    final dataInseminacao = _resolveDataInseminacao(reproducao);
    final dataParto = _resolveDataParto(reproducao);

    if (dataInseminacao == null || dataParto == null) {
      return null;
    }

    return functions.diasEntreDatas(dataInseminacao, dataParto);
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditReproducaoRebanhoModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.refresh = 1;
      safeSetState(() {});
      await Future.wait([
        Future(() async {
          _model.instantTimer1 = InstantTimer.periodic(
            duration: const Duration(milliseconds: 250),
            callback: (timer) async {
              if (_model.refresh <= 3) {
                _model.editReproducao =
                    await SQLiteManager.instance.buscarReproducao(
                  idReproducao: widget.idReproducao,
                );
                _model.tipoReproducao =
                    _model.editReproducao?.firstOrNull?.tipoReproducao ??
                        'Inseminação';
                _model.score =
                    _model.editReproducao?.firstOrNull?.scoreCorporal ?? 0.5;
                _model.partidaSemen =
                    _model.editReproducao?.firstOrNull?.partidaSemen ?? 1;
                _model.ressinc =
                    _model.editReproducao?.firstOrNull?.ressinc == 'SIM'
                        ? true
                        : false;
                final dataParto = _model.editReproducao?.firstOrNull?.dataParto;
                _model.parida = (_model.editReproducao?.firstOrNull?.parida ==
                            'SIM' ||
                        _model.editReproducao?.firstOrNull?.parida == 'Sim' ||
                        (dataParto != null &&
                            dataParto.isNotEmpty &&
                            dataParto != '-'))
                    ? true
                    : false;
                safeSetState(() {});
                _model.refresh = _model.refresh + 1;
                safeSetState(() {});
                _model.instantTimer1?.cancel();
              }
            },
            startImmediately: true,
          );
        }),
        Future(() async {
          _model.instantTimerrr = InstantTimer.periodic(
            duration: const Duration(milliseconds: 250),
            callback: (timer) async {
              if (FFAppState().rebuild == true) {
                safeSetState(() {});
                safeSetState(() {});
                FFAppState().rebuild = false;
                safeSetState(() {});
              }
            },
            startImmediately: true,
          );
        }),
      ]);
    });

    _model.textFieldAnotacoesFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget _buildClearFieldButton(VoidCallback onPressed) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: Icon(
          Icons.close,
          color: FlutterFlowTheme.of(context).accent3,
          size: 22.0,
        ),
      ),
    );
  }

  Widget _buildDateTrailingIcons({
    required bool showClearButton,
    required VoidCallback onClear,
    Color calendarColor = const Color(0xFF181818),
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showClearButton) _buildClearFieldButton(onClear),
        if (showClearButton) const SizedBox(width: 8.0),
        Icon(
          Icons.calendar_month_rounded,
          color: calendarColor,
          size: 24.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: FutureBuilder<List<BuscarReproducaoRow>>(
              future: SQLiteManager.instance.buscarReproducao(
                idReproducao: widget.idReproducao,
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
                final containerBuscarReproducaoRowList = snapshot.data!;
                final reproducao = containerBuscarReproducaoRowList.firstOrNull;
                final dataInseminacao = _resolveDataInseminacao(reproducao);
                final dataParto = _resolveDataParto(reproducao);
                final partoConfirmado = _isPartoConfirmado(reproducao);
                final diasEntreInseminacaoEParto = partoConfirmado
                    ? _resolveDiasEntreInseminacaoEParto(reproducao)
                    : null;

                return Container(
                  decoration: const BoxDecoration(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 24.0, 0.0, 0.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
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
                                          Icons.arrow_back_ios_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                        Text(
                                          'Reprodução',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: 22.0,
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
                                  ),
                                  if (FFAppState().userLogado.permissao ==
                                      'Admin')
                                    FlutterFlowIconButton(
                                      borderRadius: 8.0,
                                      buttonSize: 40.0,
                                      fillColor: const Color(0x0028A365),
                                      icon: FaIcon(
                                        FontAwesomeIcons.trashAlt,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 20.0,
                                      ),
                                      onPressed: () async {
                                        var confirmDialogResponse =
                                            await showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Deletar reprodução'),
                                                      content: const Text(
                                                          'Deseja realmente apagar esse registro de reprodução? Esta ação não pode ser desfeita.'),
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
                                          if (await action_blocks.blockIfAccountCanceled(context, refreshFromServer: true)) return;
                                          if (!(FFAppState()
                                                  .dataDadosNaoSyncRepro !=
                                              null)) {
                                            FFAppState().dataDadosNaoSyncRepro =
                                                getCurrentTimestamp;
                                            safeSetState(() {});
                                          }
                                          await SQLiteManager.instance
                                              .deleteReproducaoReb(
                                            idReproducao: widget.idReproducao,
                                            updatedat: dateTimeFormat(
                                              "yyyy-MM-dd HH:mm:ss",
                                              getCurrentTimestamp,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                ].divide(const SizedBox(width: 16.0)),
                              ),
                            ),
                            const Divider(
                              thickness: 2.0,
                              color: Color(0xFFEDEDED),
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reprodução',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .accent3,
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    Text(
                                      '${valueOrDefault<String>(
                                        containerBuscarReproducaoRowList
                                            .firstOrNull?.numMatriz,
                                        'S/N',
                                      )} • ${valueOrDefault<String>(
                                        valueOrDefault<String>(
                                                  containerBuscarReproducaoRowList
                                                      .firstOrNull?.nomeMatriz,
                                                  'S/N',
                                                ) ==
                                                'null'
                                            ? 'S/N'
                                            : valueOrDefault<String>(
                                                containerBuscarReproducaoRowList
                                                    .firstOrNull?.nomeMatriz,
                                                'S/N',
                                              ),
                                        'S/N',
                                      )} • ${valueOrDefault<String>(
                                        containerBuscarReproducaoRowList
                                                    .firstOrNull
                                                    ?.nascimentoMatriz ==
                                                'null'
                                            ? 'N/A'
                                            : dateTimeFormat(
                                                "d/M/y",
                                                functions.converterParaData(
                                                    containerBuscarReproducaoRowList
                                                        .firstOrNull
                                                        ?.nascimentoMatriz),
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              ),
                                        'N/A',
                                      )}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 24.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    if (containerBuscarReproducaoRowList
                                            .firstOrNull !=
                                        null)
                                      Text(
                                        'Lote: ${containerBuscarReproducaoRowList.firstOrNull?.loteNome != null && containerBuscarReproducaoRowList.firstOrNull?.loteNome != '' && containerBuscarReproducaoRowList.firstOrNull?.loteNome != 'null' ? containerBuscarReproducaoRowList.firstOrNull?.loteNome : 'Sem lote'}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14.0,
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
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                height: 189.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Tipo de reprodução',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF474747),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        _model.tipoReproducao = 'Inseminação';
                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 74.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F1F1),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(6.0),
                                            bottomRight: Radius.circular(6.0),
                                            topLeft: Radius.circular(6.0),
                                            topRight: Radius.circular(6.0),
                                          ),
                                          border: Border.all(
                                            color: _model.tipoReproducao ==
                                                    'Inseminação'
                                                ? FlutterFlowTheme.of(context)
                                                    .secondary
                                                : const Color(0x00000000),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if (_model.tipoReproducao ==
                                                  'Inseminação')
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/images/Radio_button.png',
                                                    width: 24.0,
                                                    height: 24.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              if (_model.tipoReproducao !=
                                                  'Inseminação')
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/images/Radio_button78.png',
                                                    width: 24.0,
                                                    height: 24.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              Text(
                                                'Inseminação',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFF474747),
                                                          fontSize: 20.0,
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
                                                const SizedBox(width: 10.0)),
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
                                        _model.tipoReproducao = 'Monta Natural';
                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 74.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F1F1),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(6.0),
                                            bottomRight: Radius.circular(6.0),
                                            topLeft: Radius.circular(6.0),
                                            topRight: Radius.circular(6.0),
                                          ),
                                          border: Border.all(
                                            color: _model.tipoReproducao ==
                                                    'Monta Natural'
                                                ? FlutterFlowTheme.of(context)
                                                    .secondary
                                                : const Color(0x00000000),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if (_model.tipoReproducao ==
                                                  'Monta Natural')
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/images/Radio_button.png',
                                                    width: 24.0,
                                                    height: 24.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              if (_model.tipoReproducao !=
                                                  'Monta Natural')
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/images/Radio_button78.png',
                                                    width: 24.0,
                                                    height: 24.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              Text(
                                                'Monta natural',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFF474747),
                                                          fontSize: 20.0,
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
                                                const SizedBox(width: 10.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Score corporal',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF474747),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F1F1),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(6.0),
                                          bottomRight: Radius.circular(6.0),
                                          topLeft: Radius.circular(6.0),
                                          topRight: Radius.circular(6.0),
                                        ),
                                        border: Border.all(
                                          color: const Color(0x001E7A4C),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 48.0,
                                              decoration: const BoxDecoration(),
                                              child: Visibility(
                                                visible: _model.score > 0.5,
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
                                                    _model.score =
                                                        _model.score + -0.5;
                                                    safeSetState(() {});
                                                  },
                                                  child: Container(
                                                    width: 48.0,
                                                    height: 48.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.minus,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              valueOrDefault<String>(
                                                _model.score.toString(),
                                                '0.5',
                                              ),
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
                                            Container(
                                              width: 48.0,
                                              decoration: const BoxDecoration(),
                                              child: Visibility(
                                                visible: _model.score < 5.0,
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
                                                    _model.score =
                                                        _model.score + 0.5;
                                                    safeSetState(() {});
                                                  },
                                                  child: Container(
                                                    width: 48.0,
                                                    height: 48.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ].divide(const SizedBox(width: 10.0)),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
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
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Reprodutor*',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF474747),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) => InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          await showAlignedDialog(
                                            barrierColor: Colors.transparent,
                                            context: context,
                                            isGlobal: false,
                                            avoidOverflow: true,
                                            targetAnchor:
                                                const AlignmentDirectional(
                                                        0.0, 1.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                            followerAnchor:
                                                const AlignmentDirectional(
                                                        0.0, -1.0)
                                                    .resolve(Directionality.of(
                                                        context)),
                                            builder: (dialogContext) {
                                              return Material(
                                                color: Colors.transparent,
                                                child: SizedBox(
                                                  height: 450.0,
                                                  width: double.infinity,
                                                  child: PopupRebanhosWidget(
                                                    sexo: 'Macho',
                                                    tipoReproducao:
                                                        _model.tipoReproducao,
                                                    reproducao: true,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
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
                                                .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _buildReprodutorLabel(
                                                    context,
                                                    containerBuscarReproducaoRowList
                                                        .firstOrNull,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                                Icon(
                                                  Icons
                                                      .keyboard_arrow_down_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
                            if (_model.tipoReproducao == 'Inseminação')
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
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            -1.0, 0.0),
                                        child: Text(
                                          'Data da inseminação*',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: const Color(0xFF474747),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          final datePicked1Date =
                                              await showDatePicker(
                                            initialEntryMode:
                                                DatePickerEntryMode
                                                    .calendarOnly,
                                            context: context,
                                            initialDate: getCurrentTimestamp,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2050),
                                            builder: (context, child) {
                                              return wrapInMaterialDatePickerTheme(
                                                context,
                                                child!,
                                                headerBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                headerForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                headerTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineLargeFamily,
                                                          fontSize: 32.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineLargeIsCustom,
                                                        ),
                                                pickerBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                pickerForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                selectedDateTimeBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                selectedDateTimeForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                actionButtonForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                iconSize: 24.0,
                                              );
                                            },
                                          );

                                          if (datePicked1Date != null) {
                                            safeSetState(() {
                                              _model.datePicked1 = DateTime(
                                                datePicked1Date.year,
                                                datePicked1Date.month,
                                                datePicked1Date.day,
                                              );
                                            });
                                          } else if (_model.datePicked1 !=
                                              null) {
                                            safeSetState(() {
                                              _model.datePicked1 =
                                                  getCurrentTimestamp;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F1F1),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(6.0),
                                              bottomRight: Radius.circular(6.0),
                                              topLeft: Radius.circular(6.0),
                                              topRight: Radius.circular(6.0),
                                            ),
                                            border: Border.all(
                                              color: const Color(0x001E7A4C),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _formatEditableDate(
                                                    context,
                                                    selectedDate:
                                                        _model.datePicked1,
                                                    storedValue: _model
                                                        .editReproducao
                                                        ?.firstOrNull
                                                        ?.dataInseminacao,
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color:
                                                                _editableDateColor(
                                                              context,
                                                              selectedDate: _model
                                                                  .datePicked1,
                                                              storedValue: _model
                                                                  .editReproducao
                                                                  ?.firstOrNull
                                                                  ?.dataInseminacao,
                                                            ),
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
                                                const Icon(
                                                  Icons.calendar_month_rounded,
                                                  color: Color(0xFF181818),
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      'Ressinc',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF474747),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropdownRessincValueController ??=
                                              FormFieldController<String>(
                                            _model.dropdownRessincValue ??=
                                                _normalizeRessincValue(
                                                    containerBuscarReproducaoRowList
                                                        .firstOrNull?.ressinc),
                                          ),
                                          options: const [
                                            'Tradicional',
                                            'Precoce',
                                            'Superprecoce'
                                          ],
                                          onChanged: (val) => safeSetState(() =>
                                              _model.dropdownRessincValue =
                                                  val),
                                          height: 56.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          hintText: 'Escolha uma opção...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .customColor3,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ),
                                      if (_model.dropdownRessincValue != null &&
                                          _model.dropdownRessincValue != '')
                                        FlutterFlowIconButton(
                                          borderRadius: 8.0,
                                          buttonSize: 40.0,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          icon: Icon(
                                            Icons.close,
                                            color: FlutterFlowTheme.of(context)
                                                .accent3,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            safeSetState(() {
                                              _model
                                                  .dropdownRessincValueController
                                                  ?.value = null;
                                              _model.dropdownRessincValue =
                                                  null;
                                            });
                                          },
                                        ),
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                ].divide(const SizedBox(height: 8.0)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      'GnRH',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF474747),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropdownGnrhValueController ??=
                                              FormFieldController<String>(
                                            _model.dropdownGnrhValue ??=
                                                _normalizeSimNaoValue(
                                                    containerBuscarReproducaoRowList
                                                        .firstOrNull?.gnrh),
                                          ),
                                          options: const ['Sim', 'Não'],
                                          onChanged: (val) => safeSetState(() =>
                                              _model.dropdownGnrhValue = val),
                                          height: 56.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          hintText: 'Escolha uma opção...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .customColor3,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ),
                                      if (_model.dropdownGnrhValue != null &&
                                          _model.dropdownGnrhValue != '')
                                        _buildClearFieldButton(() {
                                          safeSetState(() {
                                            _model.dropdownGnrhValueController
                                                ?.value = null;
                                            _model.dropdownGnrhValue = null;
                                          });
                                        }),
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                ].divide(const SizedBox(height: 8.0)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      'Cio',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF474747),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropdownCioValueController ??=
                                              FormFieldController<String>(
                                            _model.dropdownCioValue ??=
                                                _normalizeSimNaoValue(
                                                    containerBuscarReproducaoRowList
                                                        .firstOrNull?.cio),
                                          ),
                                          options: const ['Sim', 'Não'],
                                          onChanged: (val) => safeSetState(() =>
                                              _model.dropdownCioValue = val),
                                          height: 56.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          hintText: 'Escolha uma opção...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .customColor3,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ),
                                      if (_model.dropdownCioValue != null &&
                                          _model.dropdownCioValue != '')
                                        _buildClearFieldButton(() {
                                          safeSetState(() {
                                            _model.dropdownCioValueController
                                                ?.value = null;
                                            _model.dropdownCioValue = null;
                                          });
                                        }),
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                ].divide(const SizedBox(height: 8.0)),
                              ),
                            ),
                            if (_model.tipoReproducao == 'Inseminação')
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
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            -1.0, 0.0),
                                        child: Text(
                                          'Data de partida do sêmen',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: const Color(0xFF474747),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          final datePicked2Date =
                                              await showDatePicker(
                                            initialEntryMode:
                                                DatePickerEntryMode
                                                    .calendarOnly,
                                            context: context,
                                            initialDate: getCurrentTimestamp,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2050),
                                            builder: (context, child) {
                                              return wrapInMaterialDatePickerTheme(
                                                context,
                                                child!,
                                                headerBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                headerForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                headerTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineLargeFamily,
                                                          fontSize: 32.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineLargeIsCustom,
                                                        ),
                                                pickerBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                pickerForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                selectedDateTimeBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                selectedDateTimeForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                actionButtonForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                iconSize: 24.0,
                                              );
                                            },
                                          );

                                          if (datePicked2Date != null) {
                                            safeSetState(() {
                                              _dataPartidaSemenCleared = false;
                                              _model.datePicked2 = DateTime(
                                                datePicked2Date.year,
                                                datePicked2Date.month,
                                                datePicked2Date.day,
                                              );
                                            });
                                          } else if (_model.datePicked2 !=
                                              null) {
                                            safeSetState(() {
                                              _model.datePicked2 =
                                                  getCurrentTimestamp;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F1F1),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(6.0),
                                              bottomRight: Radius.circular(6.0),
                                              topLeft: Radius.circular(6.0),
                                              topRight: Radius.circular(6.0),
                                            ),
                                            border: Border.all(
                                              color: const Color(0x001E7A4C),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _formatEditableDate(
                                                    context,
                                                    selectedDate:
                                                        _model.datePicked2,
                                                    storedValue: _model
                                                        .editReproducao
                                                        ?.firstOrNull
                                                        ?.dataPartidaSemen,
                                                    cleared:
                                                        _dataPartidaSemenCleared,
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color:
                                                                _editableDateColor(
                                                              context,
                                                              selectedDate: _model
                                                                  .datePicked2,
                                                              storedValue: _model
                                                                  .editReproducao
                                                                  ?.firstOrNull
                                                                  ?.dataPartidaSemen,
                                                              cleared:
                                                                  _dataPartidaSemenCleared,
                                                            ),
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
                                                _buildDateTrailingIcons(
                                                  showClearButton:
                                                      _hasEditableDateValue(
                                                    _model.datePicked2,
                                                    _model
                                                        .editReproducao
                                                        ?.firstOrNull
                                                        ?.dataPartidaSemen,
                                                    cleared:
                                                        _dataPartidaSemenCleared,
                                                  ),
                                                  onClear: () {
                                                    safeSetState(() {
                                                      _model.datePicked2 = null;
                                                      _dataPartidaSemenCleared =
                                                          true;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            if (_model.tipoReproducao == 'Inseminação')
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            -1.0, 0.0),
                                        child: Text(
                                          'Partida do sêmen',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: const Color(0xFF474747),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F1F1),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(6.0),
                                            bottomRight: Radius.circular(6.0),
                                            topLeft: Radius.circular(6.0),
                                            topRight: Radius.circular(6.0),
                                          ),
                                          border: Border.all(
                                            color: const Color(0x001E7A4C),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 48.0,
                                                decoration:
                                                    const BoxDecoration(),
                                                child: Visibility(
                                                  visible:
                                                      _model.partidaSemen > 1,
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
                                                      _model.partidaSemen =
                                                          _model.partidaSemen +
                                                              -1;
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 48.0,
                                                      height: 48.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent4,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .minus,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                valueOrDefault<String>(
                                                  _model.partidaSemen
                                                      .toString(),
                                                  '1',
                                                ),
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
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                              ),
                                              Container(
                                                width: 48.0,
                                                decoration:
                                                    const BoxDecoration(),
                                                child: Visibility(
                                                  visible:
                                                      _model.partidaSemen < 5,
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
                                                      _model.partidaSemen =
                                                          _model.partidaSemen +
                                                              1;
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 48.0,
                                                      height: 48.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent4,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(
                                                const SizedBox(width: 10.0)),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            if ((_model.tipoReproducao == 'Inseminação') &&
                                ((_model.datePicked1 != null) ||
                                    (_model.editReproducao?.firstOrNull
                                                ?.previsaoParto !=
                                            null &&
                                        _model.editReproducao?.firstOrNull
                                                ?.previsaoParto !=
                                            '')))
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                              ),
                            if (_model.tipoReproducao == 'Monta Natural')
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                              ),
                            if (_model.tipoReproducao == 'Monta Natural')
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
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            -1.0, 0.0),
                                        child: Text(
                                          'Data inicial*',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: const Color(0xFF474747),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          final datePicked3Date =
                                              await showDatePicker(
                                            initialEntryMode:
                                                DatePickerEntryMode
                                                    .calendarOnly,
                                            context: context,
                                            initialDate: getCurrentTimestamp,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2050),
                                            builder: (context, child) {
                                              return wrapInMaterialDatePickerTheme(
                                                context,
                                                child!,
                                                headerBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                headerForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                headerTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineLargeFamily,
                                                          fontSize: 32.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineLargeIsCustom,
                                                        ),
                                                pickerBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                pickerForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                selectedDateTimeBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                selectedDateTimeForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                actionButtonForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                iconSize: 24.0,
                                              );
                                            },
                                          );

                                          if (datePicked3Date != null) {
                                            safeSetState(() {
                                              _model.datePicked3 = DateTime(
                                                datePicked3Date.year,
                                                datePicked3Date.month,
                                                datePicked3Date.day,
                                              );
                                            });
                                          } else if (_model.datePicked3 !=
                                              null) {
                                            safeSetState(() {
                                              _model.datePicked3 =
                                                  getCurrentTimestamp;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F1F1),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(6.0),
                                              bottomRight: Radius.circular(6.0),
                                              topLeft: Radius.circular(6.0),
                                              topRight: Radius.circular(6.0),
                                            ),
                                            border: Border.all(
                                              color: const Color(0x001E7A4C),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _formatEditableDate(
                                                    context,
                                                    selectedDate:
                                                        _model.datePicked3,
                                                    storedValue: _model
                                                        .editReproducao
                                                        ?.firstOrNull
                                                        ?.dataInicial,
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color:
                                                                _editableDateColor(
                                                              context,
                                                              selectedDate: _model
                                                                  .datePicked3,
                                                              storedValue: _model
                                                                  .editReproducao
                                                                  ?.firstOrNull
                                                                  ?.dataInicial,
                                                            ),
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
                                                const Icon(
                                                  Icons.calendar_month_rounded,
                                                  color: Color(0xFF181818),
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            if (_model.tipoReproducao == 'Monta Natural')
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
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            -1.0, 0.0),
                                        child: Text(
                                          'Data final*',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: const Color(0xFF474747),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          final datePicked4Date =
                                              await showDatePicker(
                                            initialEntryMode:
                                                DatePickerEntryMode
                                                    .calendarOnly,
                                            context: context,
                                            initialDate: getCurrentTimestamp,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2050),
                                            builder: (context, child) {
                                              return wrapInMaterialDatePickerTheme(
                                                context,
                                                child!,
                                                headerBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                headerForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                headerTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineLargeFamily,
                                                          fontSize: 32.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineLargeIsCustom,
                                                        ),
                                                pickerBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                pickerForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                selectedDateTimeBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                selectedDateTimeForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                actionButtonForegroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                iconSize: 24.0,
                                              );
                                            },
                                          );

                                          if (datePicked4Date != null) {
                                            safeSetState(() {
                                              _model.datePicked4 = DateTime(
                                                datePicked4Date.year,
                                                datePicked4Date.month,
                                                datePicked4Date.day,
                                              );
                                            });
                                          } else if (_model.datePicked4 !=
                                              null) {
                                            safeSetState(() {
                                              _model.datePicked4 =
                                                  getCurrentTimestamp;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F1F1),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(6.0),
                                              bottomRight: Radius.circular(6.0),
                                              topLeft: Radius.circular(6.0),
                                              topRight: Radius.circular(6.0),
                                            ),
                                            border: Border.all(
                                              color: const Color(0x001E7A4C),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _formatEditableDate(
                                                    context,
                                                    selectedDate:
                                                        _model.datePicked4,
                                                    storedValue: _model
                                                        .editReproducao
                                                        ?.firstOrNull
                                                        ?.dataFinal,
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color:
                                                                _editableDateColor(
                                                              context,
                                                              selectedDate: _model
                                                                  .datePicked4,
                                                              storedValue: _model
                                                                  .editReproducao
                                                                  ?.firstOrNull
                                                                  ?.dataFinal,
                                                            ),
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
                                                const Icon(
                                                  Icons.calendar_month_rounded,
                                                  color: Color(0xFF181818),
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ),
                                ),
                              ),
                            if (_model.tipoReproducao == 'Inseminação')
                              FutureBuilder<List<ListaInseminadoresRow>>(
                                future:
                                    SQLiteManager.instance.listaInseminadores(
                                  propriedade: FFAppState()
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
                                  final previsaodePartoListaInseminadoresRowList =
                                      snapshot.data!;

                                  return Container(
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
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Text(
                                              'Inseminador',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color:
                                                        const Color(0xFF474747),
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Autocomplete<String>(
                                              initialValue: TextEditingValue(
                                                text: _normalizeInputText(
                                                  containerBuscarReproducaoRowList
                                                      .firstOrNull?.inseminador,
                                                ),
                                              ),
                                              optionsBuilder:
                                                  (textEditingValue) {
                                                if (textEditingValue.text ==
                                                    '') {
                                                  return const Iterable<
                                                      String>.empty();
                                                }
                                                return previsaodePartoListaInseminadoresRowList
                                                    .map((e) => e.inseminador)
                                                    .withoutNulls
                                                    .toList()
                                                    .where((option) {
                                                  final lowercaseOption =
                                                      option.toLowerCase();
                                                  return lowercaseOption
                                                      .contains(textEditingValue
                                                          .text
                                                          .toLowerCase());
                                                });
                                              },
                                              optionsViewBuilder: (context,
                                                  onSelected, options) {
                                                return AutocompleteOptionsList(
                                                  textFieldKey: _model
                                                      .textFieldInseminadorKey,
                                                  textController: _model
                                                      .textFieldInseminadorTextController!,
                                                  options: options.toList(),
                                                  onSelected: onSelected,
                                                  textStyle:
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
                                                  textHighlightStyle:
                                                      const TextStyle(),
                                                  elevation: 4.0,
                                                  optionBackgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  optionHighlightColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                  maxHeight: 200.0,
                                                );
                                              },
                                              onSelected: (String selection) {
                                                safeSetState(() => _model
                                                        .textFieldInseminadorSelectedOption =
                                                    selection);
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              fieldViewBuilder: (
                                                context,
                                                textEditingController,
                                                focusNode,
                                                onEditingComplete,
                                              ) {
                                                _model.textFieldInseminadorFocusNode =
                                                    focusNode;

                                                _model.textFieldInseminadorTextController =
                                                    textEditingController;
                                                return TextFormField(
                                                  key: _model
                                                      .textFieldInseminadorKey,
                                                  controller:
                                                      textEditingController,
                                                  focusNode: focusNode,
                                                  onEditingComplete:
                                                      onEditingComplete,
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    labelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    hintText:
                                                        'Nome inseminador',
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .customColor3,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        lineHeight: 2.2,
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
                                                      .textFieldInseminadorTextControllerValidator
                                                      .asValidator(context),
                                                );
                                              },
                                            ),
                                          ),
                                        ].divide(const SizedBox(height: 8.0)),
                                      ),
                                    ),
                                  );
                                },
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
                                    24.0, 0.0, 24.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        unselectedWidgetColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                      ),
                                      child: Checkbox(
                                        value: _model.checkboxValue ??=
                                            _model.ressinc,
                                        onChanged: (newValue) async {
                                          safeSetState(() =>
                                              _model.checkboxValue = newValue!);
                                        },
                                        side: BorderSide(
                                          width: 2,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                        ),
                                        activeColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        checkColor:
                                            FlutterFlowTheme.of(context).info,
                                      ),
                                    ),
                                    Text(
                                      'Ressincronização',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ].divide(const SizedBox(width: 8.0)),
                                ),
                              ),
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
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      -1.0, 0.0),
                                              child: Text(
                                                'Diagnóstico*',
                                                style:
                                                    FlutterFlowTheme.of(context)
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
                                            ),
                                            FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .dropdownStatusValueController ??=
                                                  FormFieldController<String>(
                                                _model.dropdownStatusValue ??=
                                                    containerBuscarReproducaoRowList
                                                        .firstOrNull
                                                        ?.statusReproducao,
                                              ),
                                              options: const [
                                                'Não diagnosticado',
                                                'Absorção',
                                                'Aborto',
                                                'Natimorto',
                                                'Prenhez',
                                                'Vazio'
                                              ],
                                              onChanged: (val) => safeSetState(
                                                  () => _model
                                                          .dropdownStatusValue =
                                                      val),
                                              width: double.infinity,
                                              height: 56.0,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              hintText: 'Diagnóstico...',
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .customColor3,
                                              elevation: 2.0,
                                              borderColor: Colors.transparent,
                                              borderWidth: 0.0,
                                              borderRadius: 8.0,
                                              margin:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: false,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                          ].divide(const SizedBox(height: 8.0)),
                                        ),
                                        if (_model.dropdownStatusValue !=
                                                null &&
                                            _model.dropdownStatusValue != '')
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Data do diagnóstico',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
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
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  final datePicked5Date =
                                                      await showDatePicker(
                                                    initialEntryMode:
                                                        DatePickerEntryMode
                                                            .calendarOnly,
                                                    context: context,
                                                    initialDate:
                                                        getCurrentTimestamp,
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime(2050),
                                                    builder: (context, child) {
                                                      return wrapInMaterialDatePickerTheme(
                                                        context,
                                                        child!,
                                                        headerBackgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
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
                                                                  fontSize:
                                                                      32.0,
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
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
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

                                                  if (datePicked5Date != null) {
                                                    safeSetState(() {
                                                      _dataStatusCleared =
                                                          false;
                                                      _model.datePicked5 =
                                                          DateTime(
                                                        datePicked5Date.year,
                                                        datePicked5Date.month,
                                                        datePicked5Date.day,
                                                      );
                                                    });
                                                  } else if (_model
                                                          .datePicked5 !=
                                                      null) {
                                                    safeSetState(() {
                                                      _model.datePicked5 =
                                                          getCurrentTimestamp;
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 56.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFF1F1F1),
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
                                                          0x001E7A4C),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            8.0, 0.0, 8.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          _formatEditableDate(
                                                            context,
                                                            selectedDate: _model
                                                                .datePicked5,
                                                            storedValue: _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataStatus,
                                                            cleared:
                                                                _dataStatusCleared,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color:
                                                                    _editableDateColor(
                                                                  context,
                                                                  selectedDate:
                                                                      _model
                                                                          .datePicked5,
                                                                  storedValue: _model
                                                                      .editReproducao
                                                                      ?.firstOrNull
                                                                      ?.dataStatus,
                                                                  cleared:
                                                                      _dataStatusCleared,
                                                                ),
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
                                                        _buildDateTrailingIcons(
                                                          showClearButton:
                                                              _hasEditableDateValue(
                                                            _model.datePicked5,
                                                            _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataStatus,
                                                            cleared:
                                                                _dataStatusCleared,
                                                          ),
                                                          onClear: () {
                                                            safeSetState(() {
                                                              _model.datePicked5 =
                                                                  null;
                                                              _dataStatusCleared =
                                                                  true;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(
                                                const SizedBox(height: 8.0)),
                                          ),
                                      ].divide(const SizedBox(height: 24.0)),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
                            if ((_model.tipoReproducao == 'Inseminação') &&
                                ((_model.datePicked1 != null) ||
                                    (dateTimeFormat(
                                          "d/M/y",
                                          functions.converterParaData(_model
                                              .editReproducao
                                              ?.firstOrNull
                                              ?.dataInseminacao),
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        ) !=
                                        '')))
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Previsão do parto',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF474747),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        final baseDate = _model.datePicked1 ??
                                            functions.converterParaData(_model
                                                .editReproducao
                                                ?.firstOrNull
                                                ?.dataInseminacao);
                                        final datePicked6Date =
                                            await showDatePicker(
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                          context: context,
                                          initialDate: _model.datePicked6 ??
                                              (baseDate != null
                                                  ? functions
                                                      .dataMais295(baseDate)
                                                  : getCurrentTimestamp),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2050),
                                          builder: (context, child) {
                                            return wrapInMaterialDatePickerTheme(
                                              context,
                                              child!,
                                              headerBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              headerForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              headerTextStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineLargeFamily,
                                                        fontSize: 32.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineLargeIsCustom,
                                                      ),
                                              pickerBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              pickerForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              selectedDateTimeBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              selectedDateTimeForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              actionButtonForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              iconSize: 24.0,
                                            );
                                          },
                                        );

                                        if (datePicked6Date != null) {
                                          safeSetState(() {
                                            _previsaoPartoCleared = false;
                                            _model.datePicked6 = DateTime(
                                              datePicked6Date.year,
                                              datePicked6Date.month,
                                              datePicked6Date.day,
                                            );
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F1F1),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(6.0),
                                            bottomRight: Radius.circular(6.0),
                                            topLeft: Radius.circular(6.0),
                                            topRight: Radius.circular(6.0),
                                          ),
                                          border: Border.all(
                                            color: const Color(0x001E7A4C),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                valueOrDefault<String>(
                                                  _previsaoPartoCleared
                                                      ? null
                                                      : dateTimeFormat(
                                                          "d/M/y",
                                                          _model.datePicked6 ??
                                                              functions.dataMais295(_model
                                                                          .datePicked1 !=
                                                                      null
                                                                  ? _model
                                                                      .datePicked1!
                                                                  : functions.converterParaData(_model
                                                                      .editReproducao
                                                                      ?.firstOrNull
                                                                      ?.dataInseminacao)!),
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        ),
                                                  'Data da inseminação + 295 dias',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color: _previsaoPartoCleared
                                                          ? const Color(
                                                              0xFFBEBEBE)
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
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
                                              _buildDateTrailingIcons(
                                                showClearButton:
                                                    !_previsaoPartoCleared,
                                                onClear: () {
                                                  safeSetState(() {
                                                    _model.datePicked6 = null;
                                                    _previsaoPartoCleared =
                                                        true;
                                                  });
                                                },
                                                calendarColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                              ),
                            if (_model.tipoReproducao == 'Monta Natural')
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Previsão do parto',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF474747),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        final datePicked6Date =
                                            await showDatePicker(
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                          context: context,
                                          initialDate: getCurrentTimestamp,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2050),
                                          builder: (context, child) {
                                            return wrapInMaterialDatePickerTheme(
                                              context,
                                              child!,
                                              headerBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              headerForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              headerTextStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineLargeFamily,
                                                        fontSize: 32.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineLargeIsCustom,
                                                      ),
                                              pickerBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              pickerForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              selectedDateTimeBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              selectedDateTimeForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              actionButtonForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              iconSize: 24.0,
                                            );
                                          },
                                        );

                                        if (datePicked6Date != null) {
                                          safeSetState(() {
                                            _model.datePicked6 = DateTime(
                                              datePicked6Date.year,
                                              datePicked6Date.month,
                                              datePicked6Date.day,
                                            );
                                          });
                                        } else if (_model.datePicked6 != null) {
                                          safeSetState(() {
                                            _model.datePicked6 =
                                                getCurrentTimestamp;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F1F1),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(6.0),
                                            bottomRight: Radius.circular(6.0),
                                            topLeft: Radius.circular(6.0),
                                            topRight: Radius.circular(6.0),
                                          ),
                                          border: Border.all(
                                            color: const Color(0x001E7A4C),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _formatEditableDate(
                                                  context,
                                                  selectedDate:
                                                      _model.datePicked6,
                                                  storedValue: _model
                                                      .editReproducao
                                                      ?.firstOrNull
                                                      ?.previsaoParto,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color: _editableDateColor(
                                                        context,
                                                        selectedDate:
                                                            _model.datePicked6,
                                                        storedValue: _model
                                                            .editReproducao
                                                            ?.firstOrNull
                                                            ?.previsaoParto,
                                                      ),
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
                                              const Icon(
                                                Icons.calendar_month_rounded,
                                                color: Color(0xFF181818),
                                                size: 24.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Theme(
                                    data: ThemeData(
                                      checkboxTheme: CheckboxThemeData(
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      unselectedWidgetColor:
                                          FlutterFlowTheme.of(context).accent4,
                                    ),
                                    child: Checkbox(
                                      value: _model.checkboxParidaValue ??=
                                          _model.parida,
                                      onChanged: (newValue) async {
                                        safeSetState(() => _model
                                            .checkboxParidaValue = newValue!);
                                      },
                                      side: BorderSide(
                                        width: 2,
                                        color: FlutterFlowTheme.of(context)
                                            .accent4,
                                      ),
                                      activeColor:
                                          FlutterFlowTheme.of(context).primary,
                                      checkColor:
                                          FlutterFlowTheme.of(context).info,
                                    ),
                                  ),
                                  Text(
                                    'Parto confirmado',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ].divide(const SizedBox(width: 8.0)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Data de parto',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
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
                                      final datePicked7Date =
                                          await showDatePicker(
                                        initialEntryMode:
                                            DatePickerEntryMode.calendarOnly,
                                        context: context,
                                        initialDate: getCurrentTimestamp,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2050),
                                        builder: (context, child) {
                                          return wrapInMaterialDatePickerTheme(
                                            context,
                                            child!,
                                            headerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            headerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            headerTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .override(
                                                      fontFamily: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineLargeFamily,
                                                      fontSize: 32.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLargeIsCustom,
                                                    ),
                                            pickerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            pickerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            selectedDateTimeBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            selectedDateTimeForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            actionButtonForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            iconSize: 24.0,
                                          );
                                        },
                                      );

                                      if (datePicked7Date != null) {
                                        safeSetState(() {
                                          _dataPartoCleared = false;
                                          _model.datePicked7 = DateTime(
                                            datePicked7Date.year,
                                            datePicked7Date.month,
                                            datePicked7Date.day,
                                          );
                                        });
                                      } else if (_model.datePicked7 != null) {
                                        safeSetState(() {
                                          _model.datePicked7 =
                                              getCurrentTimestamp;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F1F1),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(6.0),
                                          bottomRight: Radius.circular(6.0),
                                          topLeft: Radius.circular(6.0),
                                          topRight: Radius.circular(6.0),
                                        ),
                                        border: Border.all(
                                          color: const Color(0x001E7A4C),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatEditableDate(
                                                context,
                                                selectedDate:
                                                    _model.datePicked7,
                                                storedValue: _model
                                                    .editReproducao
                                                    ?.firstOrNull
                                                    ?.dataParto,
                                                cleared: _dataPartoCleared,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: _editableDateColor(
                                                      context,
                                                      selectedDate:
                                                          _model.datePicked7,
                                                      storedValue: _model
                                                          .editReproducao
                                                          ?.firstOrNull
                                                          ?.dataParto,
                                                      cleared:
                                                          _dataPartoCleared,
                                                    ),
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            _buildDateTrailingIcons(
                                              showClearButton:
                                                  _hasEditableDateValue(
                                                _model.datePicked7,
                                                _model.editReproducao
                                                    ?.firstOrNull?.dataParto,
                                                cleared: _dataPartoCleared,
                                              ),
                                              onClear: () {
                                                safeSetState(() {
                                                  _model.datePicked7 = null;
                                                  _dataPartoCleared = true;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ].divide(const SizedBox(height: 8.0)),
                              ),
                            ),
                            if (partoConfirmado &&
                                dataInseminacao != null &&
                                dataParto != null &&
                                diasEntreInseminacaoEParto != null)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 0.0, 0.0),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Dias entre inseminação e parto: ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      TextSpan(
                                        text: valueOrDefault<String>(
                                          diasEntreInseminacaoEParto.toString(),
                                          '-',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
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
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'Anotações',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF474747),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 104.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F1F1),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(6.0),
                                          bottomRight: Radius.circular(6.0),
                                          topLeft: Radius.circular(6.0),
                                          topRight: Radius.circular(6.0),
                                        ),
                                        border: Border.all(
                                          color: const Color(0x001E7A4C),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: TextFormField(
                                          controller: _model
                                                  .textFieldAnotacoesTextController ??=
                                              TextEditingController(
                                            text: _normalizeInputText(
                                              containerBuscarReproducaoRowList
                                                  .firstOrNull?.anotacoes,
                                            ),
                                          ),
                                          focusNode: _model
                                              .textFieldAnotacoesFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumIsCustom,
                                                    ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMediumIsCustom,
                                                    ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00E0E3E7),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x0028A365),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          validator: _model
                                              .textFieldAnotacoesTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 24.0),
                              child: Container(
                                width: double.infinity,
                                height: 56.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          text: 'Cancelar',
                                          options: FFButtonOptions(
                                            width: 156.0,
                                            height: 56.0,
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: const Color(0x004B39EF),
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .titleSmall
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmallFamily,
                                                  color:
                                                      const Color(0xFF1E7A4C),
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
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
                                          onPressed: _isSaving
                                              ? null
                                              : () async {
                                                  if (_isSaving) return;
                                                  _isSaving = true;
                                                  safeSetState(() {});
                                                  try {
                                                    if (await action_blocks.blockIfAccountCanceled(context, refreshFromServer: true)) return;
                                                    if (!(FFAppState()
                                                            .dataDadosNaoSyncRepro !=
                                                        null)) {
                                                      FFAppState()
                                                              .dataDadosNaoSyncRepro =
                                                          getCurrentTimestamp;
                                                      safeSetState(() {});
                                                    }
                                                    _model.animalSelecionado =
                                                        await SQLiteManager
                                                            .instance
                                                            .buscarRebanho(
                                                      idRebanho: FFAppState()
                                                          .matrizSelecionada
                                                          .idRebanho,
                                                    );
                                                    if (_model.tipoReproducao ==
                                                        'Inseminação') {
                                                      await SQLiteManager
                                                          .instance
                                                          .uPDTReproducao(
                                                        tipoReproducao: _model
                                                            .tipoReproducao,
                                                        scoreCorporal:
                                                            _model.score,
                                                        dataInseminacao: _model
                                                                    .datePicked1 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked1,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataInseminacao,
                                                        dataPartidaSemen:
                                                            _dataPartidaSemenCleared
                                                                ? null
                                                                : _model.datePicked2 !=
                                                                        null
                                                                    ? dateTimeFormat(
                                                                        "yyyy-MM-dd",
                                                                        _model
                                                                            .datePicked2,
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )
                                                                    : _model
                                                                        .editReproducao
                                                                        ?.firstOrNull
                                                                        ?.dataPartidaSemen,
                                                        partidaSemen:
                                                            _model.partidaSemen,
                                                        previsaoParto:
                                                            _previsaoPartoCleared
                                                                ? null
                                                                : _model.datePicked6 !=
                                                                        null
                                                                    ? dateTimeFormat(
                                                                        "yyyy-MM-dd",
                                                                        _model
                                                                            .datePicked6!,
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )
                                                                    : _model.datePicked1 !=
                                                                            null
                                                                        ? dateTimeFormat(
                                                                            "yyyy-MM-dd",
                                                                            functions.dataMais295(_model.datePicked1!),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          )
                                                                        : _model
                                                                            .editReproducao
                                                                            ?.firstOrNull
                                                                            ?.previsaoParto,
                                                        idLote: _model
                                                            .animalSelecionado
                                                            ?.firstOrNull
                                                            ?.loteID,
                                                        dataInicial: _model
                                                                    .datePicked3 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked3,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataInicial,
                                                        dataFinal: _model
                                                                    .datePicked4 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked4,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataFinal,
                                                        inseminador: _model
                                                            .textFieldInseminadorTextController
                                                            .text,
                                                        anotacoes: _model
                                                            .textFieldAnotacoesTextController
                                                            .text,
                                                        idReproducao:
                                                            widget.idReproducao,
                                                        deletado: 'NAO',
                                                        updatedAt:
                                                            dateTimeFormat(
                                                          "yyyy-MM-dd HH:mm:ss",
                                                          getCurrentTimestamp,
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        ),
                                                        numMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .numAnimal,
                                                        nomeMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .nomeAnimal,
                                                        nascimentoMatriz:
                                                            FFAppState()
                                                                .matrizSelecionada
                                                                .dataNascAnimal,
                                                        numReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .numAnimal,
                                                        nomeReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .nomeAnimal,
                                                        nascimentoReprodutor:
                                                            FFAppState()
                                                                .reprodutorSelecionado
                                                                .dataNascAnimal,
                                                        loteNome: _model
                                                            .animalSelecionado
                                                            ?.firstOrNull
                                                            ?.loteNome,
                                                        statusReproducao:
                                                            valueOrDefault<
                                                                String>(
                                                          _model
                                                              .dropdownStatusValue,
                                                          'Não diagnosticado',
                                                        ),
                                                        dataStatus:
                                                            _dataStatusCleared
                                                                ? null
                                                                : _model.datePicked5 !=
                                                                        null
                                                                    ? dateTimeFormat(
                                                                        "yyyy-MM-dd",
                                                                        _model
                                                                            .datePicked5,
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )
                                                                    : _model
                                                                        .editReproducao
                                                                        ?.firstOrNull
                                                                        ?.dataStatus,
                                                        racaMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .racaAnimal,
                                                        racaReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .racaAnimal,
                                                        chipReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .chip,
                                                        chipMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .chip,
                                                        ressinc: valueOrDefault<
                                                            String>(
                                                          _model
                                                              .dropdownRessincValue,
                                                          '-',
                                                        ),
                                                        parida: (_model.checkboxParidaValue ??
                                                                    _model
                                                                        .parida) ==
                                                                true
                                                            ? 'Sim'
                                                            : 'Não',
                                                        dataParto:
                                                            _dataPartoCleared
                                                                ? null
                                                                : _model.datePicked7 !=
                                                                        null
                                                                    ? dateTimeFormat(
                                                                        "yyyy-MM-dd",
                                                                        _model
                                                                            .datePicked7,
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )
                                                                    : _model
                                                                        .editReproducao
                                                                        ?.firstOrNull
                                                                        ?.dataParto,
                                                        idrebanhomatriz:
                                                            FFAppState()
                                                                .matrizSelecionada
                                                                .idRebanho,
                                                        idrebanhoreprodutor:
                                                            FFAppState()
                                                                .reprodutorSelecionado
                                                                .idRebanho,
                                                        gnrh: valueOrDefault<
                                                            String>(
                                                          _model
                                                              .dropdownGnrhValue,
                                                          'Não',
                                                        ),
                                                        cio: valueOrDefault<
                                                            String>(
                                                          _model
                                                              .dropdownCioValue,
                                                          'Não',
                                                        ),
                                                      );
                                                    } else {
                                                      await SQLiteManager
                                                          .instance
                                                          .uPDTReproducaoMonta(
                                                        tipoReproducao: _model
                                                            .tipoReproducao,
                                                        scoreCorporal:
                                                            _model.score,
                                                        dataPartidaSemen: _model
                                                                    .datePicked2 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked2,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataPartidaSemen,
                                                        partidaSemen:
                                                            _model.partidaSemen,
                                                        previsaoParto: _model
                                                                    .datePicked6 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked6,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.previsaoParto,
                                                        idLote: _model
                                                            .animalSelecionado
                                                            ?.firstOrNull
                                                            ?.loteID,
                                                        dataInicial: _model
                                                                    .datePicked3 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked3,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataInicial,
                                                        dataFinal: _model
                                                                    .datePicked4 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked4,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataFinal,
                                                        anotacoes: _model
                                                            .textFieldAnotacoesTextController
                                                            .text,
                                                        idReproducao:
                                                            widget.idReproducao,
                                                        deletado: 'NAO',
                                                        updatedAt:
                                                            dateTimeFormat(
                                                          "yyyy-MM-dd HH:mm:ss",
                                                          getCurrentTimestamp,
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        ),
                                                        numMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .numAnimal,
                                                        nomeMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .nomeAnimal,
                                                        nascimentoMatriz:
                                                            FFAppState()
                                                                .matrizSelecionada
                                                                .dataNascAnimal,
                                                        numReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .numAnimal,
                                                        nomeReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .nomeAnimal,
                                                        nascimentoReprodutor:
                                                            FFAppState()
                                                                .reprodutorSelecionado
                                                                .dataNascAnimal,
                                                        loteNome: _model
                                                            .animalSelecionado
                                                            ?.firstOrNull
                                                            ?.loteNome,
                                                        statusReproducao:
                                                            valueOrDefault<
                                                                String>(
                                                          _model
                                                              .dropdownStatusValue,
                                                          'Não diagnosticado',
                                                        ),
                                                        dataStatus: _model
                                                                    .datePicked5 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked5,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataStatus,
                                                        racaMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .racaAnimal,
                                                        racaReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .racaAnimal,
                                                        chipReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .chip,
                                                        chipMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .chip,
                                                        ressinc: valueOrDefault<
                                                            String>(
                                                          _model
                                                              .dropdownRessincValue,
                                                          '-',
                                                        ),
                                                        parida: (_model.checkboxParidaValue ??
                                                                    _model
                                                                        .parida) ==
                                                                true
                                                            ? 'Sim'
                                                            : 'Não',
                                                        dataParto: _model
                                                                    .datePicked7 !=
                                                                null
                                                            ? dateTimeFormat(
                                                                "yyyy-MM-dd",
                                                                _model
                                                                    .datePicked7,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              )
                                                            : _model
                                                                .editReproducao
                                                                ?.firstOrNull
                                                                ?.dataParto,
                                                        idrebanhomatriz:
                                                            FFAppState()
                                                                .matrizSelecionada
                                                                .idRebanho,
                                                        idrebanhoreprodutor:
                                                            FFAppState()
                                                                .reprodutorSelecionado
                                                                .idRebanho,
                                                        gnrh: valueOrDefault<
                                                            String>(
                                                          _model
                                                              .dropdownGnrhValue,
                                                          'Não',
                                                        ),
                                                        cio: valueOrDefault<
                                                            String>(
                                                          _model
                                                              .dropdownCioValue,
                                                          'Não',
                                                        ),
                                                      );
                                                    }

                                                    await action_blocks
                                                        .qTDReproducoes(
                                                            context);
                                                    FFAppState().update(() {});
                                                    Navigator.pop(context);

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Reprodução em animal editada com sucesso.',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                          ),
                                                        ),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                      ),
                                                    );

                                                    safeSetState(() {});
                                                  } finally {
                                                    _isSaving = false;
                                                    if (mounted) {
                                                      safeSetState(() {});
                                                    }
                                                  }
                                                },
                                          text: 'Salvar',
                                          options: FFButtonOptions(
                                            height: 56.0,
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 0.0,
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(width: 16.0)),
                                  ),
                                ),
                              ),
                            ),
                          ].divide(const SizedBox(height: 24.0)),
                        ),
                      ),
                    ),
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
