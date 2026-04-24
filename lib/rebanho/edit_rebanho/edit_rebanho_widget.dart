import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/saiba_mais_b_t_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/rebanho/add_pesagem/add_pesagem_widget.dart';
import '/rebanho/popup_rebanhos/popup_rebanhos_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/actions/actions.dart' as action_blocks;
import '/utils/peso_input_formatter.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'edit_rebanho_model.dart';
export 'edit_rebanho_model.dart';

class EditRebanhoWidget extends StatefulWidget {
  const EditRebanhoWidget({super.key});

  @override
  State<EditRebanhoWidget> createState() => _EditRebanhoWidgetState();
}

class _EditRebanhoWidgetState extends State<EditRebanhoWidget>
    with TickerProviderStateMixin {
  late EditRebanhoModel _model;

  double? _parsePeso(String? rawValue) => parsePesoFormatado(rawValue);

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

  String? _normalizeDropdownValue(String? value) {
    final normalized = _normalizeInputText(value);
    if (normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  DateTime? _parseStoredDate(String? value) {
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
    String placeholder = 'Selecionar',
  }) {
    final effectiveDate = selectedDate ?? _parseStoredDate(storedValue);
    if (effectiveDate == null) {
      return placeholder;
    }

    return dateTimeFormat(
      'dd/MM/yyyy',
      effectiveDate,
      locale: FFLocalizations.of(context).languageCode,
    );
  }

  Color _editableDateColor(
    BuildContext context, {
    DateTime? selectedDate,
    String? storedValue,
  }) {
    final hasValue =
        selectedDate != null || _parseStoredDate(storedValue) != null;
    return hasValue
        ? FlutterFlowTheme.of(context).secondaryText
        : const Color(0xFFBEBEBE);
  }

  Future<void> _refreshPesoAtualEDataUltimaPesagem() async {
    final idRebanho = FFAppState().rebanhoSelecionado.idRebanho;
    if (idRebanho.isEmpty) {
      return;
    }

    final rebanho = await SQLiteManager.instance.buscarRebanho(
      idRebanho: idRebanho,
    );
    final rebanhoAtual = rebanho.firstOrNull;
    if (rebanhoAtual == null) {
      return;
    }

    FFAppState().updateRebanhoSelecionadoStruct(
      (e) => e
        ..pesoAtual = rebanhoAtual.pesoAtual
        ..dataUltimaPesagem = rebanhoAtual.dataUltimaPesagem ?? '',
    );

    _model.pesoAtualTextController?.text =
        formatPesoInicial(rebanhoAtual.pesoAtual);
    _model.datePicked4 = _parseStoredDate(rebanhoAtual.dataUltimaPesagem);

    if (mounted) {
      safeSetState(() {});
    }
  }

  Future<void> _refreshHistPesagens() async {
    final idRebanho = FFAppState().rebanhoSelecionado.idRebanho;
    FFAppState().histPesagens = [];
    if (mounted) {
      safeSetState(() {});
    }

    if (idRebanho.isEmpty) {
      return;
    }

    final pesagens = await SQLiteManager.instance.buscaHistPesagens(
      idRebanho: idRebanho,
    );

    for (final item in pesagens) {
      FFAppState().addToHistPesagens(HistoricoPesagensStruct(
        id: item.id,
        idRebanho: item.idRebanho,
        dataPesagem: item.dataPesagem,
        tipo: item.tipo,
        peso: item.peso,
        deletado: item.deletado,
        createdAt: item.createdAt,
      ));
    }

    if (mounted) {
      safeSetState(() {});
    }
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditRebanhoModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.nAnimalTextController ??= TextEditingController(
      text: _normalizeInputText(FFAppState().rebanhoSelecionado.numeroAnimal),
    );
    _model.nAnimalFocusNode ??= FocusNode();

    _model.nChipTextController ??= TextEditingController(
      text: _normalizeInputText(FFAppState().rebanhoSelecionado.chip),
    );
    _model.nChipFocusNode ??= FocusNode();

    _model.cdigoregistroTextController ??= TextEditingController(
      text: _normalizeInputText(FFAppState().rebanhoSelecionado.codRegistro),
    );
    _model.cdigoregistroFocusNode ??= FocusNode();

    _model.nomeAnimalTextController ??= TextEditingController(
      text: _normalizeInputText(FFAppState().rebanhoSelecionado.nome),
    );
    _model.nomeAnimalFocusNode ??= FocusNode();

    _model.pesonascimentoTextController ??= TextEditingController(
        text: formatPesoInicial(
            FFAppState().rebanhoSelecionado.pesoNascimento));
    _model.pesonascimentoFocusNode ??= FocusNode();

    _model.pesodadesmamaTextController ??= TextEditingController(
        text: formatPesoInicial(
            FFAppState().rebanhoSelecionado.pesoDesmama));
    _model.pesodadesmamaFocusNode ??= FocusNode();

    _model.pesoAtualTextController ??= TextEditingController(
        text: formatPesoInicial(FFAppState().rebanhoSelecionado.pesoAtual));
    _model.pesoAtualFocusNode ??= FocusNode();

    _model.pesonascimentoTextController =
        ensurePesoController(_model.pesonascimentoTextController);
    _model.pesodadesmamaTextController =
        ensurePesoController(_model.pesodadesmamaTextController);
    _model.pesoAtualTextController =
        ensurePesoController(_model.pesoAtualTextController);

    _model.anotacoesTextController ??= TextEditingController(
      text: _normalizeInputText(FFAppState().rebanhoSelecionado.anotacoes),
    );
    _model.anotacoesFocusNode ??= FocusNode();

    _model.dPLoteValue =
        _normalizeDropdownValue(FFAppState().rebanhoSelecionado.loteId);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshHistPesagens();
      await _refreshPesoAtualEDataUltimaPesagem();
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 32.0, 0.0),
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
                      child: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                    Text(
                      'Rebanho',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: 22.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ].divide(const SizedBox(width: 16.0)),
                ),
                if (FFAppState().userLogado.permissao == 'Admin')
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
                      var confirmDialogResponse = await showDialog<bool>(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: const Text('Deletar registro'),
                                content: const Text(
                                    'Deseja realmente apagar esse registro? Esta ação não pode ser desfeita.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        alertDialogContext, false),
                                    child: const Text('Não'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext, true),
                                    child: const Text('Sim'),
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;
                      if (confirmDialogResponse) {
                        if (!(FFAppState().dataDadosNaoSyncRebanho != null)) {
                          FFAppState().dataDadosNaoSyncRebanho =
                              getCurrentTimestamp;
                          safeSetState(() {});
                        }
                        await SQLiteManager.instance.deleteRebanho(
                          idRebanho: FFAppState().rebanhoSelecionado.idRebanho,
                          updatedat: dateTimeFormat(
                            "yyyy-MM-dd HH:mm:ss",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                        );
                        FFAppState().update(() {});
                        if (context.mounted) {
                          await action_blocks.animaisRegistrados(context);
                        }
                        if (context.mounted) {
                          await action_blocks.animaisPropriedade(context);
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
              ].divide(const SizedBox(width: 16.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
            child: Text(
              'Editar animal',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: const Color(0xFF181818),
                    fontSize: 24.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxHeight: 700.0,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: const Alignment(0.0, 0),
                    child: TabBar(
                      isScrollable: true,
                      labelColor: const Color(0xFF1E7A4C),
                      unselectedLabelColor:
                          FlutterFlowTheme.of(context).accent3,
                      labelStyle: FlutterFlowTheme.of(context)
                          .titleMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleMediumFamily,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleMediumIsCustom,
                          ),
                      unselectedLabelStyle: const TextStyle(),
                      indicatorColor: const Color(0xFF1E7A4C),
                      tabs: const [
                        Tab(
                          text: 'Sobre o animal',
                        ),
                        Tab(
                          text: 'Progênie',
                        ),
                        Tab(
                          text: 'Mais detalhes',
                        ),
                        Tab(
                          text: 'Pesagens',
                        ),
                      ],
                      controller: _model.tabBarController,
                      onTap: (i) async {
                        [
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
                        Form(
                          key: _model.formKey2,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 16.0, 24.0, 24.0),
                            child: SingleChildScrollView(
                              primary: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 97.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Número',
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
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller:
                                                  _model.nAnimalTextController,
                                              focusNode:
                                                  _model.nAnimalFocusNode,
                                              onChanged: (value) {
                                                final upperValue =
                                                    value.toUpperCase();
                                                if (value != upperValue) {
                                                  _model.nAnimalTextController!
                                                          .value =
                                                      _model
                                                          .nAnimalTextController!
                                                          .value
                                                          .copyWith(
                                                    text: upperValue,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: upperValue
                                                                .length),
                                                    composing: TextRange.empty,
                                                  );
                                                }
                                                EasyDebounce.debounce(
                                                  '_model.nAnimalTextController',
                                                  const Duration(
                                                      milliseconds: 2000),
                                                  () => safeSetState(() {}),
                                                );
                                              },
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Número do animal',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00E0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x004B39EF),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFF1F1F1),
                                                suffixIcon: _model
                                                        .nAnimalTextController!
                                                        .text
                                                        .isNotEmpty
                                                    ? InkWell(
                                                        onTap: () async {
                                                          _model
                                                              .nAnimalTextController
                                                              ?.clear();
                                                          safeSetState(() {});
                                                        },
                                                        child: const Icon(
                                                          Icons.clear,
                                                          size: 14.0,
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
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              validator: _model
                                                  .nAnimalTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Chip',
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
                                        Container(
                                          width: double.infinity,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller:
                                                  _model.nChipTextController,
                                              focusNode: _model.nChipFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.nChipTextController',
                                                const Duration(
                                                    milliseconds: 2000),
                                                () => safeSetState(() {}),
                                              ),
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Chip do animal',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00E0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x004B39EF),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFF1F1F1),
                                                suffixIcon: _model
                                                        .nChipTextController!
                                                        .text
                                                        .isNotEmpty
                                                    ? InkWell(
                                                        onTap: () async {
                                                          _model
                                                              .nChipTextController
                                                              ?.clear();
                                                          safeSetState(() {});
                                                        },
                                                        child: const Icon(
                                                          Icons.clear,
                                                          size: 14.0,
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
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              validator: _model
                                                  .nChipTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
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
                                                      const SaibaMaisBTWidget(),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                          child: RichText(
                                            textScaler: MediaQuery.of(context)
                                                .textScaler,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Você pode usar a leitura eletrônica do bastão com o bluetooth do seu celular. ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color: const Color(
                                                            0xFF8E8E8E),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                                const TextSpan(
                                                  text: 'Saiba mais',
                                                  style: TextStyle(
                                                    color: Color(0xFF28A365),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.0,
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
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 97.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Código registro',
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
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model
                                                  .cdigoregistroTextController,
                                              focusNode:
                                                  _model.cdigoregistroFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.cdigoregistroTextController',
                                                const Duration(
                                                    milliseconds: 2000),
                                                () => safeSetState(() {}),
                                              ),
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Código registro',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00E0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x004B39EF),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFF1F1F1),
                                                suffixIcon: _model
                                                        .cdigoregistroTextController!
                                                        .text
                                                        .isNotEmpty
                                                    ? InkWell(
                                                        onTap: () async {
                                                          _model
                                                              .cdigoregistroTextController
                                                              ?.clear();
                                                          safeSetState(() {});
                                                        },
                                                        child: const Icon(
                                                          Icons.clear,
                                                          size: 14.0,
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
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              validator: _model
                                                  .cdigoregistroTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 97.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nome  ',
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
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model
                                                  .nomeAnimalTextController,
                                              focusNode:
                                                  _model.nomeAnimalFocusNode,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Nome do animal',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00E0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x004B39EF),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFF1F1F1),
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
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              validator: _model
                                                  .nomeAnimalTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 97.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sexo*',
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
                                        FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropDownSexoValueController ??=
                                              FormFieldController<String>(
                                            _model.dropDownSexoValue ??=
                                                _normalizeDropdownValue(
                                              FFAppState()
                                                  .rebanhoSelecionado
                                                  .sexo,
                                            ),
                                          ),
                                          options: const ['Macho', 'Fêmea'],
                                          onChanged: (val) => safeSetState(() =>
                                              _model.dropDownSexoValue = val),
                                          width: double.infinity,
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
                                          hintText: 'Selecionar',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor: const Color(0xFFF1F1F1),
                                          elevation: 2.0,
                                          borderColor: const Color(0x00E0E3E7),
                                          borderWidth: 2.0,
                                          borderRadius: 8.0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                          hidesUnderline: true,
                                          isOverButton: true,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Categoria*',
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
                                        if (_model.dropDownSexoValue == 'Fêmea')
                                          FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .dPCategoriaFemeaValueController ??=
                                                FormFieldController<String>(
                                              _model.dPCategoriaFemeaValue ??=
                                                  _normalizeDropdownValue(
                                                FFAppState()
                                                    .rebanhoSelecionado
                                                    .categoria,
                                              ),
                                            ),
                                            options: FFAppState()
                                                .categoriasRebanhoFemea,
                                            onChanged: (val) => safeSetState(
                                                () => _model
                                                        .dPCategoriaFemeaValue =
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
                                            hintText: 'Selecionar',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor: const Color(0xFFF1F1F1),
                                            elevation: 2.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 2.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        if (_model.dropDownSexoValue == 'Macho')
                                          FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .dPCategoriaMachoValueController ??=
                                                FormFieldController<String>(
                                              _model.dPCategoriaMachoValue ??=
                                                  _normalizeDropdownValue(
                                                FFAppState()
                                                    .rebanhoSelecionado
                                                    .categoria,
                                              ),
                                            ),
                                            options: FFAppState()
                                                .categoriasRebanhoMacho,
                                            onChanged: (val) => safeSetState(
                                                () => _model
                                                        .dPCategoriaMachoValue =
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
                                            hintText: 'Selecionar',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor: const Color(0xFFF1F1F1),
                                            elevation: 2.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 2.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        if ((FFAppState()
                                                    .rebanhoSelecionado
                                                    .tipo ==
                                                'Nascimento') &&
                                            responsiveVisibility(
                                              context: context,
                                              phone: false,
                                              tablet: false,
                                              tabletLandscape: false,
                                              desktop: false,
                                            ))
                                          Container(
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .customColor3,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      () {
                                                        if (_model
                                                                .dropDownSexoValue ==
                                                            'Macho') {
                                                          return 'Bezerro';
                                                        } else if (_model
                                                                .dropDownSexoValue ==
                                                            'Fêmea') {
                                                          return 'Bezerra';
                                                        } else {
                                                          return 'Sem Categoria';
                                                        }
                                                      }(),
                                                      'Categoria',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
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
                                                ],
                                              ),
                                            ),
                                          ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 2.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Data de nascimento',
                                            style: FlutterFlowTheme.of(context)
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
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              final datePicked1Date =
                                                  await showDatePicker(
                                                initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                                        const Color(0xFF28A365),
                                                    headerForegroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .info,
                                                    headerTextStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineLarge
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLargeFamily,
                                                              fontSize: 32.0,
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
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF1F1F1),
                                                borderRadius: BorderRadius.only(
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
                                                        16.0, 0.0, 8.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                      _formatEditableDate(
                                                        context,
                                                        selectedDate:
                                                          _model.datePicked1,
                                                        storedValue: FFAppState()
                                                          .rebanhoSelecionado
                                                          .dataNascimento,
                                                      ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                                        .datePicked1,
                                                                    storedValue: FFAppState()
                                                                      .rebanhoSelecionado
                                                                      .dataNascimento,
                                                                    ),
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
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .calendar_month_outlined,
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
                                          ),
                                        ].divide(const SizedBox(height: 8.0)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 97.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Peso nascimento (kg)',
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
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model
                                                  .pesonascimentoTextController,
                                              focusNode: _model
                                                  .pesonascimentoFocusNode,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Peso do animal',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00E0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x004B39EF),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFF1F1F1),
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
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: const [
                                                FilteringTextInputFormatter.digitsOnly,
                                                PesoInputFormatter(),
                                              ],
                                              validator: _model
                                                  .pesonascimentoTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 97.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Porte',
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
                                        FlutterFlowDropDown<String>(
                                          controller:
                                              _model.dPPorteValueController ??=
                                                  FormFieldController<String>(
                                            _model.dPPorteValue ??=
                                              _normalizeDropdownValue(
                                              FFAppState()
                                                .rebanhoSelecionado
                                                .porte,
                                            ),
                                          ),
                                          options: const ['P', 'M', 'G'],
                                          onChanged: (val) => safeSetState(
                                              () => _model.dPPorteValue = val),
                                          width: double.infinity,
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
                                          hintText: 'Selecionar',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor: const Color(0xFFF1F1F1),
                                          elevation: 2.0,
                                          borderColor: const Color(0x00E0E3E7),
                                          borderWidth: 2.0,
                                          borderRadius: 8.0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                          hidesUnderline: true,
                                          isOverButton: true,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 97.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Raça',
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
                                        FlutterFlowDropDown<String>(
                                          controller:
                                              _model.dPRacaValueController ??=
                                                  FormFieldController<String>(
                                            _model.dPRacaValue ??=
                                              _normalizeDropdownValue(
                                              FFAppState()
                                                .rebanhoSelecionado
                                                .raca,
                                            ),
                                          ),
                                          options: FFAppState().raca,
                                          onChanged: (val) => safeSetState(
                                              () => _model.dPRacaValue = val),
                                          width: double.infinity,
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
                                          hintText: 'Selecionar',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor: const Color(0xFFF1F1F1),
                                          elevation: 2.0,
                                          borderColor: const Color(0x00E0E3E7),
                                          borderWidth: 2.0,
                                          borderRadius: 8.0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                          hidesUnderline: true,
                                          isOverButton: true,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 97.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Lote',
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
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                controller: _model
                                                        .dPLoteValueController ??=
                                                    FormFieldController<String>(
                                                  _model.dPLoteValue,
                                                ),
                                                options: List<String>.from(
                                                    (FFAppState()
                                                            .rebanhoLotesSelecionar
                                                            .toList()
                                                          ..sort((a, b) => a
                                                              .nome
                                                              .toLowerCase()
                                                              .compareTo(b.nome
                                                                  .toLowerCase())))
                                                        .map((e) => e.idLote)
                                                        .toList()),
                                                optionLabels: (FFAppState()
                                                        .rebanhoLotesSelecionar
                                                        .toList()
                                                      ..sort((a, b) => a.nome
                                                          .toLowerCase()
                                                          .compareTo(b.nome
                                                              .toLowerCase())))
                                                    .map((e) => e.nome)
                                                    .toList(),
                                                onChanged: (val) =>
                                                    safeSetState(() => _model
                                                        .dPLoteValue = val),
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
                                                      color:
                                                          FlutterFlowTheme.of(
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
                                                hintText: 'Selecionar',
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                                fillColor:
                                                    const Color(0xFFF1F1F1),
                                                elevation: 2.0,
                                                borderColor:
                                                    const Color(0x00E0E3E7),
                                                borderWidth: 2.0,
                                                borderRadius: 8.0,
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        16.0, 4.0, 16.0, 4.0),
                                                hidesUnderline: true,
                                                isOverButton: true,
                                                isSearchable: true,
                                                isMultiSelect: false,
                                              ),
                                            ),
                                            if (_model.dPLoteValue != null &&
                                                _model.dPLoteValue != '')
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  safeSetState(() {
                                                    _model.dPLoteValue = null;
                                                    _model.dPLoteValueController
                                                        ?.value = null;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 24.0,
                                                ),
                                              ),
                                          ].divide(const SizedBox(width: 8.0)),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  if (responsiveVisibility(
                                    context: context,
                                    phone: false,
                                    tablet: false,
                                    tabletLandscape: false,
                                    desktop: false,
                                  ))
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Data de entrada no lote',
                                            style: FlutterFlowTheme.of(context)
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
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              final datePicked2Date =
                                                  await showDatePicker(
                                                initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                                        const Color(0xFF28A365),
                                                    headerForegroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .info,
                                                    headerTextStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineLarge
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLargeFamily,
                                                              fontSize: 32.0,
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

                                              if (datePicked2Date != null) {
                                                safeSetState(() {
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
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF1F1F1),
                                                borderRadius: BorderRadius.only(
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
                                                        16.0, 0.0, 8.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                      _formatEditableDate(
                                                        context,
                                                        selectedDate:
                                                          _model.datePicked2,
                                                        storedValue: FFAppState()
                                                          .rebanhoSelecionado
                                                          .dataEntradaLote,
                                                      ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                                        .datePicked2,
                                                                    storedValue: FFAppState()
                                                                      .rebanhoSelecionado
                                                                      .dataEntradaLote,
                                                                    ),
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
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .calendar_month_outlined,
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
                                          ),
                                        ].divide(const SizedBox(height: 8.0)),
                                      ),
                                    ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model.nChipTextController
                                                    ?.text = valueOrDefault<
                                                            String>(
                                                          FFAppState()
                                                              .rebanhoSelecionado
                                                              .chip,
                                                          'N/A',
                                                        ) ==
                                                        'null'
                                                    ? 'N/A'
                                                    : valueOrDefault<String>(
                                                        FFAppState()
                                                            .rebanhoSelecionado
                                                            .chip,
                                                        'N/A',
                                                      );

                                                _model.cdigoregistroTextController
                                                        ?.text =
                                                    valueOrDefault<String>(
                                                  FFAppState()
                                                              .rebanhoSelecionado
                                                              .codRegistro ==
                                                          'null'
                                                      ? 'N/A'
                                                      : FFAppState()
                                                          .rebanhoSelecionado
                                                          .codRegistro,
                                                  'N/A',
                                                );

                                                _model.nomeAnimalTextController
                                                        ?.text =
                                                    valueOrDefault<String>(
                                                  FFAppState()
                                                              .rebanhoSelecionado
                                                              .nome ==
                                                          'null'
                                                      ? 'N/A'
                                                      : FFAppState()
                                                          .rebanhoSelecionado
                                                          .nome,
                                                  'N/A',
                                                );

                                                _model.pesonascimentoTextController
                                                        ?.text =
                                                    FFAppState()
                                                        .rebanhoSelecionado
                                                        .pesoNascimento
                                                        .toString();

                                                _model.pesodadesmamaTextController
                                                        ?.text =
                                                    FFAppState()
                                                        .rebanhoSelecionado
                                                        .pesoDesmama
                                                        .toString();

                                                _model.anotacoesTextController
                                                        ?.text =
                                                    valueOrDefault<String>(
                                                  FFAppState()
                                                              .rebanhoSelecionado
                                                              .anotacoes ==
                                                          'null'
                                                      ? 'N/A'
                                                      : FFAppState()
                                                          .rebanhoSelecionado
                                                          .anotacoes,
                                                  'N/A',
                                                );

                                                _model.nAnimalTextController
                                                        ?.text =
                                                    valueOrDefault<String>(
                                                  FFAppState()
                                                      .rebanhoSelecionado
                                                      .numeroAnimal,
                                                  'S/N',
                                                );

                                                _model.pesoAtualTextController
                                                        ?.text =
                                                    FFAppState()
                                                        .rebanhoSelecionado
                                                        .pesoAtual
                                                        .toString();
                                              });
                                              safeSetState(() {
                                                _model
                                                    .dropDownSexoValueController
                                                    ?.reset();
                                                _model.dropDownSexoValue = null;
                                                _model
                                                    .dPCategoriaFemeaValueController
                                                    ?.reset();
                                                _model.dPCategoriaFemeaValue =
                                                    null;
                                                _model.dPPorteValueController
                                                    ?.reset();
                                                _model.dPPorteValue = null;
                                                _model.dPRacaValueController
                                                    ?.reset();
                                                _model.dPRacaValue = null;
                                                _model.dPStatusValueController
                                                    ?.reset();
                                                _model.dPStatusValue = null;
                                                _model.dPOrigemValueController
                                                    ?.reset();
                                                _model.dPOrigemValue = null;
                                              });
                                              FFAppState().valueFormat = '';
                                              FFAppState().valueDouble = 0.0;
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
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              });
                                            },
                                            text: 'Próximo',
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
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmallFamily,
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmallIsCustom,
                                                  ),
                                              elevation: 3.0,
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
                                ].divide(const SizedBox(height: 24.0)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 24.0, 24.0, 24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
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
                                                const AlignmentDirectional(
                                                    -1.0, 0.0),
                                            child: Text(
                                              'Matriz',
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
                                          if (responsiveVisibility(
                                            context: context,
                                            phone: false,
                                            tablet: false,
                                            tabletLandscape: false,
                                            desktop: false,
                                          ))
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      -1.0, 0.0),
                                              child: Text(
                                                'Não foi possível encontrar uma matriz.',
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
                                            ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Builder(
                                                  builder: (context) => InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      await showAlignedDialog(
                                                        barrierColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        isGlobal: false,
                                                        avoidOverflow: true,
                                                        targetAnchor:
                                                            const AlignmentDirectional(
                                                                    0.0, 1.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                        followerAnchor:
                                                            const AlignmentDirectional(
                                                                    0.0, -1.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                        builder:
                                                            (dialogContext) {
                                                          return const Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: SizedBox(
                                                              height: 450.0,
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  PopupRebanhosWidget(
                                                                sexo: 'Fêmea',
                                                                sanidade: false,
                                                                reproducao:
                                                                    false,
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor3,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(16.0,
                                                                0.0, 16.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                '${valueOrDefault<String>(
                                                                  FFAppState()
                                                                      .matrizSelecionada
                                                                      .numAnimal,
                                                                  'S/N',
                                                                )} • ${valueOrDefault<String>(
                                                                  valueOrDefault<
                                                                              String>(
                                                                            FFAppState().matrizSelecionada.nomeAnimal,
                                                                            'S/N',
                                                                          ) ==
                                                                          'null'
                                                                      ? 'S/N'
                                                                      : valueOrDefault<
                                                                          String>(
                                                                          FFAppState()
                                                                              .matrizSelecionada
                                                                              .nomeAnimal,
                                                                          'S/N',
                                                                        ),
                                                                  'S/N',
                                                                )} • ${valueOrDefault<String>(
                                                                  valueOrDefault<
                                                                              String>(
                                                                            FFAppState().matrizSelecionada.dataNascAnimal,
                                                                            'N/A',
                                                                          ) ==
                                                                          'null'
                                                                      ? 'N/A'
                                                                      : dateTimeFormat(
                                                                          "d/M/y",
                                                                          functions
                                                                              .converterParaData(valueOrDefault<String>(
                                                                            FFAppState().matrizSelecionada.dataNascAnimal,
                                                                            'N/A',
                                                                          )),
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        ),
                                                                  'S/D',
                                                                )}',
                                                                'Selecionar Matriz',
                                                              ),
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
                                                                  .keyboard_arrow_down_sharp,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 24.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  FFAppState()
                                                          .matrizSelecionada =
                                                      AnimalSelecionadoStruct
                                                          .fromSerializableMap(
                                                              jsonDecode('{}'));
                                                  safeSetState(() {});
                                                },
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent3,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ].divide(
                                                const SizedBox(width: 16.0)),
                                          ),
                                        ].divide(const SizedBox(height: 8.0)),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Reprodutor',
                                            style: FlutterFlowTheme.of(context)
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
                                          if (responsiveVisibility(
                                            context: context,
                                            phone: false,
                                            tablet: false,
                                            tabletLandscape: false,
                                            desktop: false,
                                          ))
                                            Text(
                                              'Não foi possível encontrar reprodutor.',
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
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Builder(
                                                  builder: (context) => InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      await showAlignedDialog(
                                                        barrierColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        isGlobal: false,
                                                        avoidOverflow: true,
                                                        targetAnchor:
                                                            const AlignmentDirectional(
                                                                    0.0, 1.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                        followerAnchor:
                                                            const AlignmentDirectional(
                                                                    0.0, -1.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                        builder:
                                                            (dialogContext) {
                                                          return const Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: SizedBox(
                                                              height: 450.0,
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  PopupRebanhosWidget(
                                                                sexo: 'Macho',
                                                                sanidade: false,
                                                                reproducao:
                                                                    false,
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor3,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(16.0,
                                                                0.0, 16.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                '${valueOrDefault<String>(
                                                                  FFAppState()
                                                                      .reprodutorSelecionado
                                                                      .numAnimal,
                                                                  'S/N',
                                                                )} • ${valueOrDefault<String>(
                                                                      FFAppState()
                                                                          .reprodutorSelecionado
                                                                          .nomeAnimal,
                                                                      'S/N',
                                                                    ) == 'null' ? 'S/N' : valueOrDefault<String>(
                                                                    FFAppState()
                                                                        .reprodutorSelecionado
                                                                        .nomeAnimal,
                                                                    'S/N',
                                                                  )} • ${valueOrDefault<String>(
                                                                  valueOrDefault<
                                                                              String>(
                                                                            FFAppState().reprodutorSelecionado.dataNascAnimal,
                                                                            'N/A',
                                                                          ) ==
                                                                          'null'
                                                                      ? 'N/A'
                                                                      : valueOrDefault<
                                                                          String>(
                                                                          dateTimeFormat(
                                                                            "d/M/y",
                                                                            functions.converterParaData(valueOrDefault<String>(
                                                                              FFAppState().reprodutorSelecionado.dataNascAnimal,
                                                                              'N/A',
                                                                            )),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'S/D',
                                                                        ),
                                                                  'S/D',
                                                                )}',
                                                                'Selecionar Reprodutor',
                                                              ),
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
                                                                  .keyboard_arrow_down_sharp,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 24.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  FFAppState()
                                                          .reprodutorSelecionado =
                                                      AnimalSelecionadoStruct
                                                          .fromSerializableMap(
                                                              jsonDecode('{}'));
                                                  safeSetState(() {});
                                                },
                                                child: Icon(
                                                  Icons.close_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent3,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ].divide(
                                                const SizedBox(width: 16.0)),
                                          ),
                                        ].divide(const SizedBox(height: 8.0)),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 8.0)),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          safeSetState(() {
                                            _model.tabBarController!.animateTo(
                                              max(
                                                  0,
                                                  _model.tabBarController!
                                                          .index -
                                                      1),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                          });
                                        },
                                        text: 'Voltar',
                                        options: FFButtonOptions(
                                          width: 160.0,
                                          height: 56.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: const Color(0x004B39EF),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: const Color(0xFF1E7A4C),
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
                                        onPressed: () async {
                                          safeSetState(() {
                                            _model.tabBarController!.animateTo(
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
                                        text: 'Próximo',
                                        options: FFButtonOptions(
                                          width: 160.0,
                                          height: 56.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: const Color(0xFF28A365),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: Colors.white,
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
                                            color: Color(0x0028A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 16.0)),
                                ),
                              ].divide(const SizedBox(height: 24.0)),
                            ),
                          ),
                        ),
                        Form(
                          key: _model.formKey1,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 24.0, 24.0, 24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Data da desmama',
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
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final datePicked3Date =
                                                    await showDatePicker(
                                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                                          const Color(
                                                              0xFF28A365),
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
                                                                fontSize: 32.0,
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

                                                if (datePicked3Date != null) {
                                                  safeSetState(() {
                                                    _model.datePicked3 =
                                                        DateTime(
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
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                                          .fromSTEB(
                                                          16.0, 0.0, 8.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _formatEditableDate(
                                                          context,
                                                          selectedDate:
                                                            _model.datePicked3,
                                                          storedValue: FFAppState()
                                                            .rebanhoSelecionado
                                                            .dataDesmama,
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
                                                                      .datePicked3,
                                                                  storedValue: FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .dataDesmama,
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
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .calendar_month_outlined,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 79.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Peso da desmama (kg)',
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
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model
                                                  .pesodadesmamaTextController,
                                              focusNode:
                                                  _model.pesodadesmamaFocusNode,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Peso da desmama',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00E0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x004B39EF),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFF1F1F1),
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
                                                        .secondaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: const [
                                                FilteringTextInputFormatter.digitsOnly,
                                                PesoInputFormatter(),
                                              ],
                                              validator: _model
                                                  .pesodadesmamaTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Data da última pesagem',
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
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            final datePicked4Date =
                                                await showDatePicker(
                                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                                              context: context,
                                              initialDate: getCurrentTimestamp,
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2050),
                                              builder: (context, child) {
                                                return wrapInMaterialDatePickerTheme(
                                                  context,
                                                  child!,
                                                  headerBackgroundColor:
                                                      const Color(0xFF28A365),
                                                  headerForegroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .info,
                                                  headerTextStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
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
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFF1F1F1),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(6.0),
                                                bottomRight:
                                                    Radius.circular(6.0),
                                                topLeft: Radius.circular(6.0),
                                                topRight: Radius.circular(6.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 8.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _formatEditableDate(
                                                      context,
                                                      selectedDate:
                                                        _model.datePicked4,
                                                      storedValue: FFAppState()
                                                        .rebanhoSelecionado
                                                        .dataUltimaPesagem,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color:
                                                              _editableDateColor(
                                                              context,
                                                              selectedDate:
                                                                _model
                                                                  .datePicked4,
                                                              storedValue: FFAppState()
                                                                .rebanhoSelecionado
                                                                .dataUltimaPesagem,
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
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .calendar_month_outlined,
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
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 79.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Peso atual (kg)',
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
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model
                                                  .pesoAtualTextController,
                                              focusNode:
                                                  _model.pesoAtualFocusNode,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Peso do animal',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00E0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x004B39EF),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFF1F1F1),
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
                                                        .secondaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              keyboardType: TextInputType.number,
                                              inputFormatters: const [
                                                FilteringTextInputFormatter.digitsOnly,
                                                PesoInputFormatter(),
                                              ],
                                              validator: _model
                                                  .pesoAtualTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 96.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status*',
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
                                        FlutterFlowDropDown<String>(
                                          controller:
                                              _model.dPStatusValueController ??=
                                                  FormFieldController<String>(
                                            _model.dPStatusValue ??=
                                              _normalizeDropdownValue(
                                              FFAppState()
                                                .rebanhoSelecionado
                                                .status,
                                            ),
                                          ),
                                          options: FFAppState().statusRebanho,
                                          onChanged: (val) => safeSetState(
                                              () => _model.dPStatusValue = val),
                                          width: double.infinity,
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
                                          hintText: 'Selecionar',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor: const Color(0xFFF1F1F1),
                                          elevation: 0.0,
                                          borderColor: const Color(0x00E0E3E7),
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                          hidesUnderline: true,
                                          isOverButton: true,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Origem',
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
                                        FlutterFlowDropDown<String>(
                                          controller:
                                              _model.dPOrigemValueController ??=
                                                  FormFieldController<String>(
                                            _model.dPOrigemValue ??=
                                              _normalizeDropdownValue(
                                              FFAppState()
                                                .rebanhoSelecionado
                                                .origem,
                                            ),
                                          ),
                                          options: FFAppState().origemRebanho,
                                          onChanged: (val) => safeSetState(
                                              () => _model.dPOrigemValue = val),
                                          width: double.infinity,
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
                                          hintText: 'Selecionar',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor: const Color(0xFFF1F1F1),
                                          elevation: 2.0,
                                          borderColor: const Color(0x00E0E3E7),
                                          borderWidth: 2.0,
                                          borderRadius: 8.0,
                                          margin: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                          hidesUnderline: true,
                                          isOverButton: true,
                                          isSearchable: false,
                                          isMultiSelect: false,
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  if (_model.dPOrigemValue == 'Compra')
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Data de compra',
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
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final datePicked5Date =
                                                    await showDatePicker(
                                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                                          const Color(
                                                              0xFF28A365),
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
                                                                fontSize: 32.0,
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
                                                          const Color(
                                                              0xFF28A365),
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
                                                    _model.datePicked5 =
                                                        DateTime(
                                                      datePicked5Date.year,
                                                      datePicked5Date.month,
                                                      datePicked5Date.day,
                                                    );
                                                  });
                                                } else if (_model.datePicked5 !=
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
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                                          .fromSTEB(
                                                          16.0, 0.0, 8.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _formatEditableDate(
                                                          context,
                                                          selectedDate:
                                                            _model.datePicked5,
                                                          storedValue: FFAppState()
                                                            .rebanhoSelecionado
                                                            .dataAcao,
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
                                                                  storedValue: FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .dataAcao,
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
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .calendar_month_outlined,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_model.dPOrigemValue == 'Compra')
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Valor da compra (R\$)',
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
                                            SizedBox(
                                              width: double.infinity,
                                              height: 56.0,
                                              child: custom_widgets
                                                  .CurrencyInputBR(
                                                width: double.infinity,
                                                height: 56.0,
                                                initialValue: FFAppState()
                                                    .rebanhoSelecionado
                                                    .valorCompra,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor3,
                                                borderColor: Colors.transparent,
                                                focusedBorderColor:
                                                    Colors.transparent,
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 16.0,
                                                borderRadius: 8.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_model.dPStatusValue == 'Vendido')
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Data de venda',
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
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final datePicked6Date =
                                                    await showDatePicker(
                                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                                          const Color(
                                                              0xFF28A365),
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
                                                                fontSize: 32.0,
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
                                                          const Color(
                                                              0xFF28A365),
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

                                                if (datePicked6Date != null) {
                                                  safeSetState(() {
                                                    _model.datePicked6 =
                                                        DateTime(
                                                      datePicked6Date.year,
                                                      datePicked6Date.month,
                                                      datePicked6Date.day,
                                                    );
                                                  });
                                                } else if (_model.datePicked6 !=
                                                    null) {
                                                  safeSetState(() {
                                                    _model.datePicked6 =
                                                        getCurrentTimestamp;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 56.0,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                                          .fromSTEB(
                                                          16.0, 0.0, 8.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _formatEditableDate(
                                                          context,
                                                          selectedDate:
                                                            _model.datePicked6,
                                                          storedValue: FFAppState()
                                                            .rebanhoSelecionado
                                                            .dataVenda,
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
                                                                      .datePicked6,
                                                                  storedValue: FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .dataVenda,
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
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .calendar_month_outlined,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_model.dPStatusValue == 'Vendido')
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Valor da venda (R\$)',
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
                                            SizedBox(
                                              width: double.infinity,
                                              height: 56.0,
                                              child: custom_widgets
                                                  .CurrencyInputBR2(
                                                width: double.infinity,
                                                height: 56.0,
                                                initialValue: FFAppState()
                                                    .rebanhoSelecionado
                                                    .valorVenda,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor3,
                                                borderColor: Colors.transparent,
                                                focusedBorderColor:
                                                    Colors.transparent,
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 16.0,
                                                borderRadius: 8.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_model.dPOrigemValue == 'Movimentação')
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Data de movimentaçao entrada',
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
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final datePicked7Date =
                                                    await showDatePicker(
                                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                                          const Color(
                                                              0xFF28A365),
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
                                                                fontSize: 32.0,
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
                                                          const Color(
                                                              0xFF28A365),
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

                                                if (datePicked7Date != null) {
                                                  safeSetState(() {
                                                    _model.datePicked7 =
                                                        DateTime(
                                                      datePicked7Date.year,
                                                      datePicked7Date.month,
                                                      datePicked7Date.day,
                                                    );
                                                  });
                                                } else if (_model.datePicked7 !=
                                                    null) {
                                                  safeSetState(() {
                                                    _model.datePicked7 =
                                                        getCurrentTimestamp;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 56.0,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                                          .fromSTEB(
                                                          16.0, 0.0, 8.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _formatEditableDate(
                                                          context,
                                                          selectedDate:
                                                            _model.datePicked7,
                                                          storedValue: FFAppState()
                                                            .rebanhoSelecionado
                                                            .movimentacaoentrada,
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
                                                                      .datePicked7,
                                                                  storedValue: FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .movimentacaoentrada,
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
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .calendar_month_outlined,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_model.dPOrigemValue == 'Movimentação')
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Data de movimentaçao saída',
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
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final datePicked8Date =
                                                    await showDatePicker(
                                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                                          const Color(
                                                              0xFF28A365),
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
                                                                fontSize: 32.0,
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
                                                          const Color(
                                                              0xFF28A365),
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

                                                if (datePicked8Date != null) {
                                                  safeSetState(() {
                                                    _model.datePicked8 =
                                                        DateTime(
                                                      datePicked8Date.year,
                                                      datePicked8Date.month,
                                                      datePicked8Date.day,
                                                    );
                                                  });
                                                } else if (_model.datePicked8 !=
                                                    null) {
                                                  safeSetState(() {
                                                    _model.datePicked8 =
                                                        getCurrentTimestamp;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 56.0,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                                          .fromSTEB(
                                                          16.0, 0.0, 8.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _formatEditableDate(
                                                          context,
                                                          selectedDate:
                                                            _model.datePicked8,
                                                          storedValue: FFAppState()
                                                            .rebanhoSelecionado
                                                            .movimentacaosaida,
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
                                                                      .datePicked8,
                                                                  storedValue: FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .movimentacaosaida,
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
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .calendar_month_outlined,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_model.dPStatusValue == 'Morto')
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Data da morte',
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
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final datePicked9Date =
                                                    await showDatePicker(
                                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                                          const Color(
                                                              0xFF28A365),
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
                                                                fontSize: 32.0,
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
                                                          const Color(
                                                              0xFF28A365),
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

                                                if (datePicked9Date != null) {
                                                  safeSetState(() {
                                                    _model.datePicked9 =
                                                        DateTime(
                                                      datePicked9Date.year,
                                                      datePicked9Date.month,
                                                      datePicked9Date.day,
                                                    );
                                                  });
                                                } else if (_model.datePicked9 !=
                                                    null) {
                                                  safeSetState(() {
                                                    _model.datePicked9 =
                                                        getCurrentTimestamp;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: 56.0,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                                          .fromSTEB(
                                                          16.0, 0.0, 8.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _formatEditableDate(
                                                          context,
                                                          selectedDate:
                                                            _model.datePicked9,
                                                          storedValue: FFAppState()
                                                            .rebanhoSelecionado
                                                            .datamorte,
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
                                                                      .datePicked9,
                                                                  storedValue: FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .datamorte,
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
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .calendar_month_outlined,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_model.dPStatusValue == 'Morto')
                                    Container(
                                      width: double.infinity,
                                      height: 97.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Motivo da morte',
                                            style: FlutterFlowTheme.of(context)
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
                                          FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .dPMotivoMorteValueController ??=
                                                FormFieldController<String>(
                                              _model.dPMotivoMorteValue ??=
                                                  _normalizeDropdownValue(
                                                FFAppState()
                                                    .rebanhoSelecionado
                                                    .motivoMorte,
                                              ),
                                            ),
                                            options: const [
                                              'ACIDENTE',
                                              'ANIMAL PEÇONHENTO',
                                              'ATAQUE AVE',
                                              'DOENÇA',
                                              'ESTRESSE TÉRMICO',
                                              'INTOXICAÇÃO',
                                              'NEONATO',
                                              'PARTO DISTÓCICO',
                                              'PREDADOR',
                                              'DESCONHECIDA',
                                              'MANTIMENTO',
                                              'NATIMORTO'
                                            ],
                                            onChanged: (val) => safeSetState(
                                                () => _model
                                                    .dPMotivoMorteValue = val),
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
                                            hintText: 'Selecionar',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor: const Color(0xFFF1F1F1),
                                            elevation: 2.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 2.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ].divide(const SizedBox(height: 8.0)),
                                      ),
                                    ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
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
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 104.0,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF1F1F1),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6.0),
                                              bottomRight: Radius.circular(6.0),
                                              topLeft: Radius.circular(6.0),
                                              topRight: Radius.circular(6.0),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model
                                                  .anotacoesTextController,
                                              focusNode:
                                                  _model.anotacoesFocusNode,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: const Color(
                                                              0xFFBEBEBE),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00E0E3E7),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x004B39EF),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        16.0, 0.0, 16.0, 0.0),
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
                                                  .anotacoesTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model.tabBarController!
                                                    .animateTo(
                                                  max(
                                                      0,
                                                      _model.tabBarController!
                                                              .index -
                                                          1),
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              });
                                            },
                                            text: 'Voltar',
                                            options: FFButtonOptions(
                                              width: 160.0,
                                              height: 56.0,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
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
                                            onPressed: () async {
                                              if (!await sanitizePesoControllersBeforeSave(
                                                  context, [
                                                _model
                                                    .pesonascimentoTextController,
                                                _model
                                                    .pesodadesmamaTextController,
                                                _model.pesoAtualTextController,
                                              ])) {
                                                return;
                                              }
                                              if (!(FFAppState()
                                                      .dataDadosNaoSyncRebanho !=
                                                  null)) {
                                                FFAppState()
                                                        .dataDadosNaoSyncRebanho =
                                                    getCurrentTimestamp;
                                                safeSetState(() {});
                                              }
                                              _model.loteAtual = FFAppState()
                                                  .rebanhoSelecionado
                                                  .loteId;
                                              safeSetState(() {});
                                              await SQLiteManager.instance
                                                  .uPDTRebanho(
                                                numeroAnimal: _model
                                                    .nAnimalTextController.text,
                                                chip: _model
                                                    .nChipTextController.text,
                                                codRegistro: _model
                                                    .cdigoregistroTextController
                                                    .text,
                                                nome: _model
                                                    .nomeAnimalTextController
                                                    .text,
                                                sexo: _model.dropDownSexoValue,
                                                categoria:
                                                    valueOrDefault<String>(
                                                  () {
                                                    if (FFAppState()
                                                            .rebanhoSelecionado
                                                            .tipo ==
                                                        'Nascimento') {
                                                      return valueOrDefault<
                                                          String>(
                                                        () {
                                                          if (_model
                                                                  .dropDownSexoValue ==
                                                              'Macho') {
                                                            return 'Bezerro';
                                                          } else if (_model
                                                                  .dropDownSexoValue ==
                                                              'Fêmea') {
                                                            return 'Bezerra';
                                                          } else {
                                                            return 'Sem Categoria';
                                                          }
                                                        }(),
                                                        'Sem Categoria',
                                                      );
                                                    } else if ((FFAppState()
                                                                .rebanhoSelecionado
                                                                .tipo !=
                                                            'Nascimento') &&
                                                        (_model.dropDownSexoValue ==
                                                            'Macho')) {
                                                      return _model
                                                          .dPCategoriaMachoValue;
                                                    } else if ((FFAppState()
                                                                .rebanhoSelecionado
                                                                .tipo !=
                                                            'Nascimento') &&
                                                        (_model.dropDownSexoValue ==
                                                            'Fêmea')) {
                                                      return _model
                                                          .dPCategoriaFemeaValue;
                                                    } else {
                                                      return 'Sem Categoria';
                                                    }
                                                  }(),
                                                  'Sem Categoria',
                                                ),
                                                dataNascimento:
                                                    _model.datePicked1 != null
                                                        ? dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.datePicked1,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          )
                                                        : dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            functions.converterParaData(
                                                                FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .dataNascimento),
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                pesoNascimento: _parsePeso(
                                                    _model
                                                        .pesonascimentoTextController
                                                        .text),
                                                porte: _model.dPPorteValue,
                                                raca: valueOrDefault<String>(
                                                  _model.dPRacaValue,
                                                  'null',
                                                ),
                                                dataEntradaLote:
                                                    _model.datePicked1 != null
                                                        ? dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.datePicked1,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          )
                                                        : dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            functions.converterParaData(
                                                                FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .dataNascimento),
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                dataDesmama:
                                                    _model.datePicked3 != null
                                                        ? dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.datePicked3,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          )
                                                        : dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            functions.converterParaData(
                                                                FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .dataDesmama),
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                pesoDesmama: _parsePeso(_model
                                                    .pesodadesmamaTextController
                                                    .text),
                                                pesoAtual: _parsePeso(
                                                    _model
                                                        .pesoAtualTextController
                                                        .text),
                                                statusRebanho:
                                                    valueOrDefault<String>(
                                                  _model.dPStatusValue,
                                                  'Na propriedade',
                                                ),
                                                origem: _model.dPOrigemValue,
                                                anotacoes: _model
                                                    .anotacoesTextController
                                                    .text,
                                                dataAcao: _model.datePicked5 !=
                                                        null
                                                    ? dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        _model.datePicked5,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      )
                                                    : dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        functions.converterParaData(
                                                            FFAppState()
                                                                .rebanhoSelecionado
                                                                .dataAcao),
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      ),
                                                valorCompra:
                                                    FFAppState().valueDouble,
                                                dataUltimaPesagem:
                                                    _model.datePicked4 != null
                                                        ? dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.datePicked4,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          )
                                                        : dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            functions.converterParaData(
                                                                FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .dataUltimaPesagem),
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                nomeConcat:
                                                    '${_model.nAnimalTextController.text} - ${_model.nomeAnimalTextController.text} - ${_model.datePicked1 != null ? dateTimeFormat(
                                                        "d/M/y",
                                                        _model.datePicked1,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      ) : dateTimeFormat(
                                                        "d/M/y",
                                                        functions.converterParaData(
                                                            FFAppState()
                                                                .rebanhoSelecionado
                                                                .dataNascimento),
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      )}',
                                                idRebanho: FFAppState()
                                                    .rebanhoSelecionado
                                                    .idRebanho,
                                                updatedat: dateTimeFormat(
                                                  "yyyy-MM-dd HH:mm:ss",
                                                  getCurrentTimestamp,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                ),
                                                loteID: _model.dPLoteValue,
                                                loteNome: FFAppState()
                                                    .rebanhoLotesSelecionar
                                                    .where((e) =>
                                                        e.idLote ==
                                                        _model.dPLoteValue)
                                                    .toList()
                                                    .firstOrNull
                                                    ?.nome,
                                                movimentacaoentrada:
                                                    _model.datePicked7 != null
                                                        ? dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.datePicked7,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          )
                                                        : dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            functions.converterParaData(
                                                                FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .movimentacaoentrada),
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                dataVenda: _model.datePicked6 !=
                                                        null
                                                    ? dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        _model.datePicked6,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      )
                                                    : dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        functions.converterParaData(
                                                            FFAppState()
                                                                .rebanhoSelecionado
                                                                .dataVenda),
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      ),
                                                valorVenda: FFAppState()
                                                    .valueDouble2
                                                    .toString(),
                                                numeroMatriz: FFAppState()
                                                    .matrizSelecionada
                                                    .numAnimal,
                                                dataNascMatriz: FFAppState()
                                                    .matrizSelecionada
                                                    .dataNascAnimal,
                                                racaMatriz: FFAppState()
                                                    .matrizSelecionada
                                                    .racaAnimal,
                                                numeroReprodutor: FFAppState()
                                                    .reprodutorSelecionado
                                                    .numAnimal,
                                                nomeReprodutor: FFAppState()
                                                    .reprodutorSelecionado
                                                    .nomeAnimal,
                                                dataNascReprodutor: FFAppState()
                                                    .reprodutorSelecionado
                                                    .dataNascAnimal,
                                                racaReprodutor: FFAppState()
                                                    .reprodutorSelecionado
                                                    .racaAnimal,
                                                nomeMatriz: FFAppState()
                                                    .matrizSelecionada
                                                    .nomeAnimal,
                                                movimentacaosaida:
                                                    _model.datePicked8 != null
                                                        ? dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            _model.datePicked8,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          )
                                                        : dateTimeFormat(
                                                            "yyyy-MM-dd",
                                                            functions.converterParaData(
                                                                FFAppState()
                                                                    .rebanhoSelecionado
                                                                    .movimentacaosaida),
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ),
                                                datamorte: _model.datePicked9 !=
                                                        null
                                                    ? dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        _model.datePicked9,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      )
                                                    : dateTimeFormat(
                                                        "yyyy-MM-dd",
                                                        functions.converterParaData(
                                                            FFAppState()
                                                                .rebanhoSelecionado
                                                                .datamorte),
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      ),
                                                motivomorte:
                                                    _model.dPMotivoMorteValue,
                                                categoriamatriz: FFAppState()
                                                    .matrizSelecionada
                                                    .categoria,
                                                rebanhoIdMatriz: FFAppState()
                                                            .matrizSelecionada
                                                            .idRebanho !=
                                                        ''
                                                    ? FFAppState()
                                                        .matrizSelecionada
                                                        .idRebanho
                                                    : FFAppState()
                                                        .rebanhoSelecionado
                                                        .rebanhoIdMatriz,
                                                rebanhoIdReprodutor: FFAppState()
                                                            .reprodutorSelecionado
                                                            .idRebanho !=
                                                        ''
                                                    ? FFAppState()
                                                        .reprodutorSelecionado
                                                        .idRebanho
                                                    : FFAppState()
                                                        .rebanhoSelecionado
                                                        .rebanhoIdReprodutor,
                                              );
                                              final novoPesoNascimento =
                                                  _parsePeso(_model
                                                      .pesonascimentoTextController
                                                      .text);
                                              if (novoPesoNascimento != null &&
                                                  FFAppState()
                                                          .rebanhoSelecionado
                                                          .pesoNascimento !=
                                                      novoPesoNascimento) {
                                                await SQLiteManager.instance
                                                    .updatePesagemByTipo(
                                                  idRebanho: FFAppState()
                                                      .rebanhoSelecionado
                                                      .idRebanho,
                                                  tipo: 'Nascimento',
                                                  peso: novoPesoNascimento,
                                                  dataPesagem: _model
                                                              .datePicked1 !=
                                                          null
                                                      ? dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.datePicked1,
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        )
                                                      : null,
                                                );
                                              }
                                              final novoPesoDesmama =
                                                  _parsePeso(_model
                                                      .pesodadesmamaTextController
                                                      .text);
                                              if (novoPesoDesmama != null &&
                                                  FFAppState()
                                                          .rebanhoSelecionado
                                                          .pesoDesmama !=
                                                      novoPesoDesmama) {
                                                await SQLiteManager.instance
                                                    .updatePesagemByTipo(
                                                  idRebanho: FFAppState()
                                                      .rebanhoSelecionado
                                                      .idRebanho,
                                                  tipo: 'Desmama',
                                                  peso: novoPesoDesmama,
                                                  dataPesagem: _model
                                                              .datePicked3 !=
                                                          null
                                                      ? dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.datePicked3,
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        )
                                                      : null,
                                                );
                                              }

                                              // Se peso atual estava vazio e peso desmama foi adicionado,
                                              // atualizar peso atual com peso desmama
                                              final pesoAtualOriginal =
                                                  FFAppState()
                                                      .rebanhoSelecionado
                                                      .pesoAtual;
                                              if ((pesoAtualOriginal ==
                                                          0.0) &&
                                                  novoPesoDesmama != null &&
                                                  novoPesoDesmama > 0) {
                                                _model.pesoAtualTextController
                                                        .text =
                                                    novoPesoDesmama ==
                                                            novoPesoDesmama
                                                                .truncateToDouble()
                                                        ? novoPesoDesmama
                                                            .toInt()
                                                            .toString()
                                                        : novoPesoDesmama
                                                            .toString();
                                              }

                                              final novoPesoAtual =
                                                  _parsePeso(_model
                                                      .pesoAtualTextController
                                                      .text);
                                              if (novoPesoAtual != null &&
                                                  FFAppState()
                                                          .rebanhoSelecionado
                                                          .pesoAtual !=
                                                      novoPesoAtual) {
                                                await SQLiteManager.instance
                                                    .addPesagem(
                                                  dataPesagem: _model
                                                              .datePicked4 !=
                                                          null
                                                      ? dateTimeFormat(
                                                          "yyyy-MM-dd",
                                                          _model.datePicked4,
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        )
                                                      : (FFAppState()
                                                                  .rebanhoSelecionado
                                                                  .dataUltimaPesagem
                                                                  .isNotEmpty
                                                              ? dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  functions.converterParaData(
                                                                      FFAppState()
                                                                          .rebanhoSelecionado
                                                                          .dataUltimaPesagem),
                                                                  locale:
                                                                      FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                )
                                                              : dateTimeFormat(
                                                                  "yyyy-MM-dd",
                                                                  getCurrentTimestamp,
                                                                  locale:
                                                                      FFLocalizations.of(
                                                                              context)
                                                                          .languageCode,
                                                                )),
                                                  tipo: 'Atual',
                                                  peso: valueOrDefault<double>(
                                                    _parsePeso(_model
                                                        .pesoAtualTextController
                                                        .text),
                                                    0.0,
                                                  ),
                                                  deletado: 'NAO',
                                                  createdat: dateTimeFormat(
                                                    "yyyy-MM-dd HH:mm:ss",
                                                    getCurrentTimestamp,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ),
                                                  idRebanho: FFAppState()
                                                      .rebanhoSelecionado
                                                      .idRebanho,
                                                  idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
                                                );
                                              }
                                              if (FFAppState()
                                                      .rebanhoSelecionado
                                                      .loteId !=
                                                  '') {
                                                _model.loteSelecionadoEditExiste =
                                                    await SQLiteManager.instance
                                                        .buscarLote(
                                                  idLote: _model.loteAtual,
                                                );
                                                final loteExisteItem = _model
                                                    .loteSelecionadoEditExiste
                                                    ?.firstOrNull;
                                                if (loteExisteItem != null &&
                                                    loteExisteItem.idAnimais !=
                                                        null) {
                                                  _model.idAnimais = functions
                                                      .converterJSONparaLista(
                                                          loteExisteItem
                                                              .idAnimais!)
                                                      .toList()
                                                      .cast<String>();
                                                  safeSetState(() {});
                                                  _model.removeFromIdAnimais(
                                                      FFAppState()
                                                          .rebanhoSelecionado
                                                          .idRebanho);
                                                  safeSetState(() {});
                                                  await SQLiteManager.instance
                                                      .uPDTLoteRebanho(
                                                    idAnimais: functions
                                                        .converterListaParaJSON(
                                                            _model.idAnimais
                                                                .toList()),
                                                    updatedat: dateTimeFormat(
                                                      "yyyy-MM-dd HH:mm:ss",
                                                      getCurrentTimestamp,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    idLote: _model.loteAtual,
                                                  );
                                                }
                                                _model.loteSelecionadoEdit2 =
                                                    await SQLiteManager.instance
                                                        .buscarLote(
                                                  idLote: _model.dPLoteValue,
                                                );
                                                final loteEdit2Item = _model
                                                    .loteSelecionadoEdit2
                                                    ?.firstOrNull;
                                                if (loteEdit2Item != null &&
                                                    loteEdit2Item.idAnimais !=
                                                        null) {
                                                  _model.idAnimais = functions
                                                      .converterJSONparaLista(
                                                          loteEdit2Item
                                                              .idAnimais!)
                                                      .toList()
                                                      .cast<String>();
                                                  safeSetState(() {});
                                                  _model.addToIdAnimais(
                                                      FFAppState()
                                                          .rebanhoSelecionado
                                                          .idRebanho);
                                                  safeSetState(() {});
                                                  await SQLiteManager.instance
                                                      .uPDTLoteRebanho(
                                                    idAnimais: functions
                                                        .converterListaParaJSON(
                                                            _model.idAnimais
                                                                .toList()),
                                                    updatedat: dateTimeFormat(
                                                      "yyyy-MM-dd HH:mm:ss",
                                                      getCurrentTimestamp,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    idLote: _model.dPLoteValue,
                                                  );
                                                }
                                              } else {
                                                if (_model.dPLoteValue !=
                                                        null &&
                                                    _model.dPLoteValue != '') {
                                                  _model.loteSelecionadoEdit =
                                                      await SQLiteManager
                                                          .instance
                                                          .buscarLote(
                                                    idLote: _model.dPLoteValue,
                                                  );
                                                  final loteEditItem = _model
                                                      .loteSelecionadoEdit
                                                      ?.firstOrNull;
                                                  if (loteEditItem != null &&
                                                      loteEditItem.idAnimais !=
                                                          null) {
                                                    _model.idAnimais = functions
                                                        .converterJSONparaLista(
                                                            loteEditItem
                                                                .idAnimais!)
                                                        .toList()
                                                        .cast<String>();
                                                  } else {
                                                    _model.idAnimais = [];
                                                  }
                                                  safeSetState(() {});
                                                  _model.addToIdAnimais(
                                                      FFAppState()
                                                          .rebanhoSelecionado
                                                          .idRebanho);
                                                  safeSetState(() {});
                                                  await SQLiteManager.instance
                                                      .uPDTLoteRebanho(
                                                    idAnimais: functions
                                                        .converterListaParaJSON(
                                                            _model.idAnimais
                                                                .toList()),
                                                    updatedat: dateTimeFormat(
                                                      "yyyy-MM-dd HH:mm:ss",
                                                      getCurrentTimestamp,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    idLote: _model.dPLoteValue,
                                                  );
                                                }
                                              }

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Animal editado com sucesso',
                                                    style: TextStyle(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                  ),
                                                  duration: const Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                ),
                                              );
                                              FFAppState().update(() {});
                                              Navigator.pop(context);
                                            },
                                            text: 'Salvar',
                                            options: FFButtonOptions(
                                              width: 160.0,
                                              height: 56.0,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmallFamily,
                                                    color: Colors.white,
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
                                                color: Color(0x0028A365),
                                                width: 0.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(width: 16.0)),
                                    ),
                                  ),
                                ].divide(const SizedBox(height: 24.0)),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        24.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  'Histórico das pesagens',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            fontSize: 17.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                              ),
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
                                                      final pesagem = FFAppState()
                                                          .histPesagens
                                                          .where((e) =>
                                                              e.deletado ==
                                                              'NAO')
                                                          .toList()
                                                          .sortedList(
                                                              keyOf: (e) => functions
                                                                  .converterParaData(
                                                                      e.dataPesagem) ??
                                                                  DateTime(1900),
                                                              desc: false)
                                                          .toList();

                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            pesagem.length,
                                                        itemBuilder: (context,
                                                            pesagemIndex) {
                                                          final pesagemItem =
                                                              pesagem[
                                                                  pesagemIndex];
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
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
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
                                                                            MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '${valueOrDefault<String>(
                                                                              pesagemItem.peso == pesagemItem.peso.truncateToDouble() ? pesagemItem.peso.toInt().toString() : pesagemItem.peso.toString(),
                                                                              '0',
                                                                            )} KG',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: const Color(0xFF474747),
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            dateTimeFormat(
                                                                              "d/M/y",
                                                                              functions.converterParaData(pesagemItem.dataPesagem),
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: const Color(0xFF5F5F5F),
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      if (pesagemItem
                                                                              .tipo ==
                                                                          'Nascimento')
                                                                        Container(
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              24.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                const Color(0xFFB1CC29),
                                                                            borderRadius:
                                                                                BorderRadius.circular(4.0),
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Text(
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
                                                                      if (pesagemItem
                                                                              .tipo ==
                                                                          'Desmama')
                                                                        Container(
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              24.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                const Color(0xFFB1CC29),
                                                                            borderRadius:
                                                                                BorderRadius.circular(4.0),
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Text(
                                                                              'Desmama',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Colors.white,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
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
                                                                          var confirmDialogResponse = await showDialog<bool>(
                                                                                context: context,
                                                                                builder: (alertDialogContext) {
                                                                                  return AlertDialog(
                                                                                    title: const Text('Deletar pesagem'),
                                                                                    content: const Text('Tem certeza que deseja deletar esta pesagem ?'),
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
                                                                            await SQLiteManager.instance.deletePesagem(
                                                                              idRebanho: pesagemItem.idRebanho,
                                                                              idPesagem: pesagemItem.id,
                                                                            );
                                                                            FFAppState().removeFromHistPesagens(HistoricoPesagensStruct(
                                                                              id: pesagemItem.id,
                                                                              idRebanho: pesagemItem.idRebanho,
                                                                              dataPesagem: pesagemItem.dataPesagem,
                                                                              tipo: pesagemItem.tipo,
                                                                              peso: pesagemItem.peso,
                                                                              deletado: pesagemItem.deletado,
                                                                              createdAt: pesagemItem.createdAt,
                                                                            ));
                                                                            safeSetState(() {});
                                                                            if (!(FFAppState().dataDadosNaoSyncProp ==
                                                                                null)) {
                                                                              FFAppState().dataDadosNaoSyncProp = getCurrentTimestamp;
                                                                              safeSetState(() {});
                                                                            }
                                                                            await _refreshHistPesagens();
                                                                            await _refreshPesoAtualEDataUltimaPesagem();
                                                                          }
                                                                        },
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .trashAlt,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          size:
                                                                              16.0,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  height: 1.0,
                                                                  thickness:
                                                                      1.0,
                                                                  color: Color(
                                                                      0xFFEDEDED),
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
                                            ].divide(
                                                const SizedBox(height: 8.0)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(24.0, 24.0, 24.0, 24.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
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
                                                  child: AddPesagemWidget(
                                                    idRebanho: FFAppState()
                                                        .rebanhoSelecionado
                                                        .idRebanho,
                                                  ),
                                                );
                                              },
                                            );
                                            await _refreshHistPesagens();
                                            await _refreshPesoAtualEDataUltimaPesagem();
                                          },
                                          text: 'Adicionar pesagem',
                                          icon: const Icon(
                                            Icons.add,
                                            size: 24.0,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 48.0,
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                            iconAlignment: IconAlignment.start,
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
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
  }
}
