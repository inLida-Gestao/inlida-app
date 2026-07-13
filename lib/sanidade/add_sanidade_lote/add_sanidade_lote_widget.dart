import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/sanidade/legenda_sanidade/legenda_sanidade_widget.dart';
import '/sanidade/selecionar_sanidade/selecionar_sanidade_widget.dart';
import '/actions/actions.dart' as action_blocks;
import '/sanidade/sanidade_dropdown_options.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'add_sanidade_lote_model.dart';
export 'add_sanidade_lote_model.dart';

class AddSanidadeLoteWidget extends StatefulWidget {
  const AddSanidadeLoteWidget({super.key});

  @override
  State<AddSanidadeLoteWidget> createState() => _AddSanidadeLoteWidgetState();
}

class _AddSanidadeLoteWidgetState extends State<AddSanidadeLoteWidget> {
  late AddSanidadeLoteModel _model;
  bool _isSaving = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddSanidadeLoteModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
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
    });

    _model.textFieldPorcentagemLoteTextController ??= TextEditingController();
    _model.textFieldPorcentagemLoteFocusNode ??= FocusNode();

    _model.textFieldVacinaOutrosTextController ??= TextEditingController();
    _model.textFieldVacinaOutrosFocusNode ??= FocusNode();

    _model.textFieldVacinaObservacaoTextController ??= TextEditingController();
    _model.textFieldVacinaObservacaoFocusNode ??= FocusNode();

    _model.textFieldAntiparasitarioOutrosTextController ??=
        TextEditingController();
    _model.textFieldAntiparasitarioOutrosFocusNode ??= FocusNode();

    _model.textFieldAntiparasitarioObservacaoTextController ??=
        TextEditingController();
    _model.textFieldAntiparasitarioObservacaoFocusNode ??= FocusNode();

    _model.textFieldTratamentoOutrosTextController ??= TextEditingController();
    _model.textFieldTratamentoOutrosFocusNode ??= FocusNode();

    _model.textFieldTratamentoObservacaoTextController ??=
        TextEditingController();
    _model.textFieldTratamentoObservacaoFocusNode ??= FocusNode();

    _model.textFieldProtocoloOutrosTextController ??= TextEditingController();
    _model.textFieldProtocoloOutrosFocusNode ??= FocusNode();

    _model.textFieldProtocoloObservacaoTextController ??=
        TextEditingController();
    _model.textFieldProtocoloObservacaoFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  bool _hasMultiSelectValue(List<String>? value) =>
      value?.any((item) => item.trim().isNotEmpty) ?? false;

  bool _hasSingleSelectValue(String? value) =>
      value?.trim().isNotEmpty ?? false;

  bool _hasSanidadeType(String type, bool hasFieldValue) =>
      FFAppState().sanidade.contains(type) || hasFieldValue;

  bool get _hasVacinaSelected => _hasSanidadeType(
      'Vacina', _hasMultiSelectValue(_model.dropDownVacinaValue));

  bool get _hasAntiparasitarioSelected => _hasSanidadeType('Antiparasitário',
      _hasMultiSelectValue(_model.dropDownAntiparasitarioValue));

  bool get _hasTratamentoSelected => _hasSanidadeType(
      'Tratamento', _hasMultiSelectValue(_model.dropDownTratamentoValue));

  bool get _hasProtocoloSelected => _hasSanidadeType('Protocolo reprodutivo',
      _hasSingleSelectValue(_model.dropDownProtocoloValue));

  bool get _canSaveSanidade {
    final hasAnyType = _hasVacinaSelected ||
        _hasAntiparasitarioSelected ||
        _hasTratamentoSelected ||
        _hasProtocoloSelected;

    return !_isSaving &&
        _model.dropDownLoteValue != null &&
        _model.dropDownLoteValue != '' &&
        _model.datePicked != null &&
        hasAnyType &&
        (!_hasVacinaSelected ||
            _hasMultiSelectValue(_model.dropDownVacinaValue)) &&
        (!_hasAntiparasitarioSelected ||
            _hasMultiSelectValue(_model.dropDownAntiparasitarioValue)) &&
        (!_hasTratamentoSelected ||
            _hasMultiSelectValue(_model.dropDownTratamentoValue)) &&
        (!_hasProtocoloSelected ||
            _hasSingleSelectValue(_model.dropDownProtocoloValue));
  }

  void _syncSanidadeTypesFromInputs() {
    void addType(String type) {
      if (!FFAppState().sanidade.contains(type)) {
        FFAppState().addToSanidade(type);
      }
    }

    if (_hasMultiSelectValue(_model.dropDownVacinaValue)) {
      addType('Vacina');
    }
    if (_hasMultiSelectValue(_model.dropDownAntiparasitarioValue)) {
      addType('Antiparasitário');
    }
    if (_hasMultiSelectValue(_model.dropDownTratamentoValue)) {
      addType('Tratamento');
    }
    if (_hasSingleSelectValue(_model.dropDownProtocoloValue)) {
      addType('Protocolo reprodutivo');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<List<ListarLotesRow>>(
      future: SQLiteManager.instance.listarLotes(
        idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
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
        final containerListarLotesRowList =
            snapshot.data!.where((lote) => lote.ativo == 'Ativo').toList();

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      safeSetState(() {
                        _model.dropDownLoteValueController?.reset();
                        _model.dropDownLoteValue = null;
                        _model.dropDownVacinaValueController?.reset();
                        _model.dropDownVacinaValue = null;
                        _model.dropDownAntiparasitarioValueController?.reset();
                        _model.dropDownAntiparasitarioValue = null;
                        _model.dropDownTratamentoValueController?.reset();
                        _model.dropDownTratamentoValue = null;
                        _model.dropDownProtocoloValueController?.reset();
                        _model.dropDownProtocoloValue = null;
                        _model.dropDownD0ValueController?.reset();
                        _model.dropDownD0Value = null;
                        _model.dropDownRetiradaValueController?.reset();
                        _model.dropDownRetiradaValue = null;
                        _model.dropDownIATFValueController?.reset();
                        _model.dropDownIATFValue = null;
                      });
                      safeSetState(() {
                        _model.textFieldVacinaOutrosTextController?.clear();
                        _model.textFieldVacinaObservacaoTextController?.clear();
                        _model.textFieldAntiparasitarioOutrosTextController
                            ?.clear();
                        _model.textFieldAntiparasitarioObservacaoTextController
                            ?.clear();
                        _model.textFieldTratamentoOutrosTextController?.clear();
                        _model.textFieldTratamentoObservacaoTextController
                            ?.clear();
                        _model.textFieldProtocoloOutrosTextController?.clear();
                        _model.textFieldProtocoloObservacaoTextController
                            ?.clear();
                      });
                      FFAppState().sanidade = [];
                      FFAppState().vacinasCount = 0;
                      FFAppState().tratamentosCount = 0;
                      FFAppState().antiParasitarioCount = 0;
                      FFAppState().protocolosReproCount = 0;
                      safeSetState(() {});
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_sharp,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        Text(
                          'Sanidade',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ].divide(const SizedBox(width: 16.0)),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adicionar sanidade em lote',
                          textAlign: TextAlign.start,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
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
                                  'Lote*',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
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
                                if (containerListarLotesRowList.isNotEmpty)
                                  FlutterFlowDropDown<String>(
                                    controller:
                                        _model.dropDownLoteValueController ??=
                                            FormFieldController<String>(
                                      _model.dropDownLoteValue ??= '',
                                    ),
                                    options: List<String>.from(
                                        containerListarLotesRowList
                                            .map((e) => e.idLote)
                                            .withoutNulls
                                            .toList()),
                                    optionLabels: containerListarLotesRowList
                                        .map((e) => e.nome)
                                        .withoutNulls
                                        .toList(),
                                    onChanged: (val) => safeSetState(
                                        () => _model.dropDownLoteValue = val),
                                    width: double.infinity,
                                    height: 56.0,
                                    searchHintTextStyle:
                                        FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelMediumIsCustom,
                                            ),
                                    searchTextStyle:
                                        FlutterFlowTheme.of(context)
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
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                    hintText: 'Selecionar',
                                    searchHintText: 'Pesquisar',
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
                                    margin:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 4.0, 16.0, 4.0),
                                    hidesUnderline: true,
                                    isOverButton: true,
                                    isSearchable: true,
                                    isMultiSelect: false,
                                    labelText: '',
                                    labelTextStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .labelMediumFamily,
                                          color: Colors.black,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .labelMediumIsCustom,
                                        ),
                                  ),
                                if (!(containerListarLotesRowList.isNotEmpty))
                                  Text(
                                    'Nenhum lote encontrado.',
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
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
                                  'Porcentagem do lote (%)',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
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
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: TextFormField(
                                    controller: _model
                                        .textFieldPorcentagemLoteTextController,
                                    focusNode: _model
                                        .textFieldPorcentagemLoteFocusNode,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: '% do lote',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFFBEBEBE),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFF1F1F1),
                                          width: 0.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF28A365),
                                          width: 0.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 0.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 0.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF1F1F1),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: const Color(0xFF161616),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9.,]')),
                                    ],
                                    validator: _model
                                        .textFieldPorcentagemLoteTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
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
                                  'Data da sanidade*',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
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
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    final datePickedDate = await showDatePicker(
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
                                              const Color(0xFF28A365),
                                          headerForegroundColor:
                                              FlutterFlowTheme.of(context).info,
                                          headerTextStyle: FlutterFlowTheme.of(
                                                  context)
                                              .headlineLarge
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLargeFamily,
                                                fontSize: 32.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
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
                                              const Color(0xFF28A365),
                                          selectedDateTimeForegroundColor:
                                              FlutterFlowTheme.of(context).info,
                                          actionButtonForegroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          iconSize: 24.0,
                                        );
                                      },
                                    );

                                    if (datePickedDate != null) {
                                      safeSetState(() {
                                        _model.datePicked = DateTime(
                                          datePickedDate.year,
                                          datePickedDate.month,
                                          datePickedDate.day,
                                        );
                                      });
                                    } else if (_model.datePicked != null) {
                                      safeSetState(() {
                                        _model.datePicked = getCurrentTimestamp;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 56.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF1F1F1),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6.0),
                                        bottomRight: Radius.circular(6.0),
                                        topLeft: Radius.circular(6.0),
                                        topRight: Radius.circular(6.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 8.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              valueOrDefault<String>(
                                                dateTimeFormat(
                                                  "d/M/y",
                                                  _model.datePicked,
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
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color:
                                                        valueOrDefault<Color>(
                                                      _model.datePicked == null
                                                          ? const Color(
                                                              0xFFBEBEBE)
                                                          : const Color(
                                                              0xFF333333),
                                                      const Color(0xFFBEBEBE),
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
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Calendar.png',
                                              width: 24.0,
                                              height: 24.0,
                                              fit: BoxFit.cover,
                                            ),
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
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: const SelecionarSanidadeWidget(),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                              text: 'Adicionar sanidade',
                              icon: const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 15.0,
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 56.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: const EdgeInsets.all(0.0),
                                color: const Color(0xFF28A365),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 0.0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              showLoadingIndicator: false,
                            ),
                          ),
                        ),
                        if (FFAppState().sanidade.contains('Vacina') == true)
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Vacinação',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: const Color(0xFF181818),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Vacinação',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: FlutterFlowDropDown<String>(
                                            multiSelectController: _model
                                                    .dropDownVacinaValueController ??=
                                                FormListFieldController<String>(
                                                    null),
                                            options: sanidadeVacinaOptions,
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
                                            elevation: 0.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: true,
                                            onMultiSelectChanged: (val) =>
                                                safeSetState(() => _model
                                                    .dropDownVacinaValue = val),
                                          ),
                                        ),
                                        if (_model.dropDownVacinaValue !=
                                                null &&
                                            (_model.dropDownVacinaValue)!
                                                .isNotEmpty)
                                          FlutterFlowIconButton(
                                            borderRadius: 8.0,
                                            buttonSize: 40.0,
                                            fillColor: const Color(0x0028A365),
                                            icon: Icon(
                                              Icons.close,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model
                                                    .dropDownVacinaValueController
                                                    ?.reset();
                                                _model.dropDownVacinaValue =
                                                    null;
                                              });
                                            },
                                          ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Vacinação (outros)',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model
                                          .textFieldVacinaOutrosTextController,
                                      focusNode:
                                          _model.textFieldVacinaOutrosFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Vacinação',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFFBEBEBE),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFFF1F1F1),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF28A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1F1F1),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF161616),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      validator: _model
                                          .textFieldVacinaOutrosTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Observação',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model
                                          .textFieldVacinaObservacaoTextController,
                                      focusNode: _model
                                          .textFieldVacinaObservacaoFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Observação',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFFBEBEBE),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFFF1F1F1),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF28A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1F1F1),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF161616),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      validator: _model
                                          .textFieldVacinaObservacaoTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (FFAppState().sanidade.contains('Antiparasitário') ==
                            true)
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Antiparasitário',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: const Color(0xFF181818),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Antiparasitário',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: FlutterFlowDropDown<String>(
                                            multiSelectController: _model
                                                    .dropDownAntiparasitarioValueController ??=
                                                FormListFieldController<String>(
                                                    null),
                                            options:
                                                sanidadeAntiparasitarioOptions,
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
                                            elevation: 0.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: true,
                                            onMultiSelectChanged: (val) =>
                                                safeSetState(() => _model
                                                        .dropDownAntiparasitarioValue =
                                                    val),
                                          ),
                                        ),
                                        if (_model.dropDownAntiparasitarioValue !=
                                                null &&
                                            (_model.dropDownAntiparasitarioValue)!
                                                .isNotEmpty)
                                          FlutterFlowIconButton(
                                            borderRadius: 8.0,
                                            buttonSize: 40.0,
                                            fillColor: const Color(0x0028A365),
                                            icon: Icon(
                                              Icons.close,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model
                                                    .dropDownAntiparasitarioValueController
                                                    ?.reset();
                                                _model.dropDownAntiparasitarioValue =
                                                    null;
                                              });
                                            },
                                          ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Antiparasitário (outros)',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model
                                          .textFieldAntiparasitarioOutrosTextController,
                                      focusNode: _model
                                          .textFieldAntiparasitarioOutrosFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Antiparasitário',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFFBEBEBE),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFFF1F1F1),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF28A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1F1F1),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF161616),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      validator: _model
                                          .textFieldAntiparasitarioOutrosTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Observação',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model
                                          .textFieldAntiparasitarioObservacaoTextController,
                                      focusNode: _model
                                          .textFieldAntiparasitarioObservacaoFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Observação',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFFBEBEBE),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFFF1F1F1),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF28A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1F1F1),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF161616),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      validator: _model
                                          .textFieldAntiparasitarioObservacaoTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (FFAppState().sanidade.contains('Tratamento') ==
                            true)
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tratamento',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: const Color(0xFF181818),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Tratamento',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: FlutterFlowDropDown<String>(
                                            multiSelectController: _model
                                                    .dropDownTratamentoValueController ??=
                                                FormListFieldController<String>(
                                                    null),
                                            options: sanidadeTratamentoOptions,
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
                                            elevation: 0.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: true,
                                            onMultiSelectChanged: (val) =>
                                                safeSetState(() => _model
                                                        .dropDownTratamentoValue =
                                                    val),
                                          ),
                                        ),
                                        if (_model.dropDownTratamentoValue !=
                                                null &&
                                            (_model.dropDownTratamentoValue)!
                                                .isNotEmpty)
                                          FlutterFlowIconButton(
                                            borderRadius: 8.0,
                                            buttonSize: 40.0,
                                            fillColor: const Color(0x0028A365),
                                            icon: Icon(
                                              Icons.close,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model
                                                    .dropDownTratamentoValueController
                                                    ?.reset();
                                                _model.dropDownTratamentoValue =
                                                    null;
                                              });
                                            },
                                          ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Tratamento (outros)',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model
                                          .textFieldTratamentoOutrosTextController,
                                      focusNode: _model
                                          .textFieldTratamentoOutrosFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Tratamento',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFFBEBEBE),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFFF1F1F1),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF28A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1F1F1),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF161616),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      validator: _model
                                          .textFieldTratamentoOutrosTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Observação',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model
                                          .textFieldTratamentoObservacaoTextController,
                                      focusNode: _model
                                          .textFieldTratamentoObservacaoFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Observação',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFFBEBEBE),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFFF1F1F1),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF28A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1F1F1),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF161616),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      validator: _model
                                          .textFieldTratamentoObservacaoTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (FFAppState()
                                .sanidade
                                .contains('Protocolo reprodutivo') ==
                            true)
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Protocolo reprodutivo',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: const Color(0xFF181818),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Protocolo reprodutivo',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .dropDownProtocoloValueController ??=
                                                FormFieldController<String>(
                                                    null),
                                            options: sanidadeProtocoloOptions,
                                            onChanged: (val) => safeSetState(
                                                () => _model
                                                        .dropDownProtocoloValue =
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
                                            elevation: 0.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                        if (_model.dropDownProtocoloValue !=
                                                null &&
                                            _model.dropDownProtocoloValue != '')
                                          FlutterFlowIconButton(
                                            borderRadius: 8.0,
                                            buttonSize: 40.0,
                                            fillColor: const Color(0x0028A365),
                                            icon: Icon(
                                              Icons.close,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model
                                                    .dropDownProtocoloValueController
                                                    ?.reset();
                                                _model.dropDownProtocoloValue =
                                                    null;
                                              });
                                            },
                                          ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'D0',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .dropDownD0ValueController ??=
                                                FormFieldController<String>(
                                                    null),
                                            options: sanidadeProtocoloD0Options,
                                            onChanged: (val) => safeSetState(
                                                () => _model.dropDownD0Value =
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
                                            elevation: 0.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                        if (_model.dropDownD0Value != null &&
                                            _model.dropDownD0Value != '')
                                          FlutterFlowIconButton(
                                            borderRadius: 8.0,
                                            buttonSize: 40.0,
                                            fillColor: const Color(0x0028A365),
                                            icon: Icon(
                                              Icons.close,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model.dropDownD0ValueController
                                                    ?.reset();
                                                _model.dropDownD0Value = null;
                                              });
                                            },
                                          ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Retirada',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: const Color(0xFF181818),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
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
                                                barrierColor:
                                                    Colors.transparent,
                                                context: context,
                                                isGlobal: false,
                                                avoidOverflow: true,
                                                targetAnchor:
                                                    const AlignmentDirectional(
                                                            1.0, 1.0)
                                                        .resolve(
                                                            Directionality.of(
                                                                context)),
                                                followerAnchor:
                                                    const AlignmentDirectional(
                                                            -1.0, -1.0)
                                                        .resolve(
                                                            Directionality.of(
                                                                context)),
                                                builder: (dialogContext) {
                                                  return const Material(
                                                    color: Colors.transparent,
                                                    child:
                                                        LegendaSanidadeWidget(),
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Legenda',
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
                                                                .secondary,
                                                        fontSize: 10.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                                FaIcon(
                                                  FontAwesomeIcons
                                                      .questionCircle,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  size: 16.0,
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 4.0)),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .dropDownRetiradaValueController ??=
                                                FormFieldController<String>(
                                                    null),
                                            options:
                                                sanidadeProtocoloRetiradaOptions,
                                            onChanged: (val) => safeSetState(
                                                () => _model
                                                        .dropDownRetiradaValue =
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
                                            elevation: 0.0,
                                            borderColor:
                                                const Color(0x00E0E3E7),
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 4.0, 16.0, 4.0),
                                            hidesUnderline: true,
                                            isOverButton: true,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ),
                                        if (_model.dropDownRetiradaValue !=
                                                null &&
                                            _model.dropDownRetiradaValue != '')
                                          FlutterFlowIconButton(
                                            borderRadius: 8.0,
                                            buttonSize: 40.0,
                                            fillColor: const Color(0x0028A365),
                                            icon: Icon(
                                              Icons.close,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              safeSetState(() {
                                                _model
                                                    .dropDownRetiradaValueController
                                                    ?.reset();
                                                _model.dropDownRetiradaValue =
                                                    null;
                                              });
                                            },
                                          ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                  ),
                                  if (responsiveVisibility(
                                    context: context,
                                    phone: false,
                                    tablet: false,
                                    tabletLandscape: false,
                                    desktop: false,
                                  ))
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 24.0, 0.0, 0.0),
                                      child: Text(
                                        'IATF',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFF181818),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .dropDownIATFValueController ??=
                                                  FormFieldController<String>(
                                                      null),
                                              options:
                                                  sanidadeProtocoloIatfOptions,
                                              onChanged: (val) => safeSetState(
                                                  () => _model
                                                      .dropDownIATFValue = val),
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
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  const Color(0xFFF1F1F1),
                                              elevation: 0.0,
                                              borderColor:
                                                  const Color(0x00E0E3E7),
                                              borderWidth: 0.0,
                                              borderRadius: 8.0,
                                              margin:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 4.0, 16.0, 4.0),
                                              hidesUnderline: true,
                                              isOverButton: true,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                          ),
                                          if (_model.dropDownIATFValue !=
                                                  null &&
                                              _model.dropDownIATFValue != '')
                                            FlutterFlowIconButton(
                                              borderRadius: 8.0,
                                              buttonSize: 40.0,
                                              fillColor:
                                                  const Color(0x0028A365),
                                              icon: Icon(
                                                Icons.close,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent3,
                                                size: 24.0,
                                              ),
                                              onPressed: () async {
                                                safeSetState(() {
                                                  _model
                                                      .dropDownIATFValueController
                                                      ?.reset();
                                                  _model.dropDownIATFValue =
                                                      null;
                                                });
                                              },
                                            ),
                                        ].divide(const SizedBox(width: 8.0)),
                                      ),
                                    ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Protocolo reprodutivo (outros)',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model
                                          .textFieldProtocoloOutrosTextController,
                                      focusNode: _model
                                          .textFieldProtocoloOutrosFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Protocolo reprodutivo',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFFBEBEBE),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFFF1F1F1),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF28A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1F1F1),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF161616),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      validator: _model
                                          .textFieldProtocoloOutrosTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                    child: Text(
                                      'Observação',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF181818),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model
                                          .textFieldProtocoloObservacaoTextController,
                                      focusNode: _model
                                          .textFieldProtocoloObservacaoFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Observação',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: const Color(0xFFBEBEBE),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFFF1F1F1),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF28A365),
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1F1F1),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF161616),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      validator: _model
                                          .textFieldProtocoloObservacaoTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            safeSetState(() {
                              _model.dropDownLoteValueController?.reset();
                              _model.dropDownLoteValue = null;
                              _model.dropDownVacinaValueController?.reset();
                              _model.dropDownVacinaValue = null;
                              _model.dropDownAntiparasitarioValueController
                                  ?.reset();
                              _model.dropDownAntiparasitarioValue = null;
                              _model.dropDownTratamentoValueController?.reset();
                              _model.dropDownTratamentoValue = null;
                              _model.dropDownProtocoloValueController?.reset();
                              _model.dropDownProtocoloValue = null;
                              _model.dropDownD0ValueController?.reset();
                              _model.dropDownD0Value = null;
                              _model.dropDownRetiradaValueController?.reset();
                              _model.dropDownRetiradaValue = null;
                              _model.dropDownIATFValueController?.reset();
                              _model.dropDownIATFValue = null;
                            });
                            safeSetState(() {
                              _model.textFieldVacinaOutrosTextController
                                  ?.clear();
                              _model.textFieldVacinaObservacaoTextController
                                  ?.clear();
                              _model.textFieldTratamentoOutrosTextController
                                  ?.clear();
                              _model.textFieldTratamentoObservacaoTextController
                                  ?.clear();
                              _model
                                  .textFieldAntiparasitarioObservacaoTextController
                                  ?.clear();
                              _model
                                  .textFieldAntiparasitarioOutrosTextController
                                  ?.clear();
                              _model.textFieldProtocoloOutrosTextController
                                  ?.clear();
                              _model.textFieldProtocoloObservacaoTextController
                                  ?.clear();
                            });
                            FFAppState().sanidade = [];
                            FFAppState().vacinasCount = 0;
                            FFAppState().tratamentosCount = 0;
                            FFAppState().antiParasitarioCount = 0;
                            FFAppState().protocolosReproCount = 0;
                            safeSetState(() {});
                            Navigator.pop(context);
                          },
                          text: 'Cancelar',
                          options: FFButtonOptions(
                            height: 56.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: const Color(0x004B39EF),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleSmallFamily,
                                  color: const Color(0xFF28A365),
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleSmallIsCustom,
                                ),
                            elevation: 0.0,
                            borderSide: const BorderSide(
                              color: Color(0xFF28A365),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: !_canSaveSanidade
                              ? null
                              : () async {
                                  if (_isSaving) return;
                                  _isSaving = true;
                                  safeSetState(() {});
                                  try {
                                    if (await action_blocks
                                        .blockIfAccountCanceled(context,
                                            refreshFromServer: true)) return;
                                    _syncSanidadeTypesFromInputs();
                                    if (!(FFAppState()
                                            .dataDadosNaoSyncSanidade !=
                                        null)) {
                                      FFAppState().dataDadosNaoSyncSanidade =
                                          getCurrentTimestamp;
                                      safeSetState(() {});
                                    }
                                    _model.loteSelecionado = await SQLiteManager
                                        .instance
                                        .buscarAnimaisDoLote(
                                      loteid: _model.dropDownLoteValue,
                                      idPropriedade: FFAppState()
                                          .propriedadeSelecionada
                                          .idPropriedade,
                                    );
                                    _model.index = 0;
                                    safeSetState(() {});
                                    if (_model.loteSelecionado == null ||
                                        _model.loteSelecionado!.isEmpty) {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: const Text('Atenção'),
                                            content: const Text(
                                                'O lote selecionado não possui nenhum animal.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext),
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    if (_model.loteSelecionado!.isNotEmpty) {
                                      while (_model.index <
                                          _model.loteSelecionado!.length) {
                                        await SQLiteManager.instance
                                            .insertSanidadeAnimal(
                                          idPropriedade: FFAppState()
                                              .propriedadeSelecionada
                                              .idPropriedade,
                                          idRebanho: _model.loteSelecionado
                                              ?.elementAtOrNull(_model.index)
                                              ?.idRebanho,
                                          dataSanidade: dateTimeFormat(
                                            "yyyy-MM-dd",
                                            _model.datePicked,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          idLote: _model.dropDownLoteValue,
                                          porcentagemLote: double.tryParse(_model
                                              .textFieldPorcentagemLoteTextController
                                              .text
                                              .replaceAll(',', '.')),
                                          idSanidade: random_data.randomString(
                                            20,
                                            20,
                                            true,
                                            false,
                                            true,
                                          ),
                                          updatedat: dateTimeFormat(
                                            "yyyy-MM-dd HH:mm:ss",
                                            getCurrentTimestamp,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          deletado: 'NAO',
                                          vacinacao: _model
                                                          .dropDownVacinaValue !=
                                                      null &&
                                                  (_model.dropDownVacinaValue)!
                                                      .isNotEmpty
                                              ? functions
                                                  .converterListaParaJSON(_model
                                                      .dropDownVacinaValue
                                                      ?.toList())
                                              : 'null',
                                          vacinacaoOutros: _model
                                              .textFieldVacinaOutrosTextController
                                              .text,
                                          vacinacaoObs: _model
                                              .textFieldVacinaObservacaoTextController
                                              .text,
                                          antiparasitario: _model
                                                          .dropDownAntiparasitarioValue !=
                                                      null &&
                                                  (_model.dropDownAntiparasitarioValue)!
                                                      .isNotEmpty
                                              ? functions
                                                  .converterListaParaJSON(_model
                                                      .dropDownAntiparasitarioValue
                                                      ?.toList())
                                              : 'null',
                                          antiparasitarioOutros: _model
                                              .textFieldAntiparasitarioOutrosTextController
                                              .text,
                                          antiparasitarioObs: _model
                                              .textFieldAntiparasitarioObservacaoTextController
                                              .text,
                                          tratamento: _model
                                                          .dropDownTratamentoValue !=
                                                      null &&
                                                  (_model.dropDownTratamentoValue)!
                                                      .isNotEmpty
                                              ? functions
                                                  .converterListaParaJSON(_model
                                                      .dropDownTratamentoValue
                                                      ?.toList())
                                              : 'null',
                                          tratamentoOutros: _model
                                              .textFieldTratamentoOutrosTextController
                                              .text,
                                          tratamentoObs: _model
                                              .textFieldTratamentoObservacaoTextController
                                              .text,
                                          protocoloReprodutivo: _model
                                                          .dropDownProtocoloValue !=
                                                      null &&
                                                  _model.dropDownProtocoloValue !=
                                                      ''
                                              ? _model.dropDownProtocoloValue
                                              : 'null',
                                          protocoloreprodutivoOutros: _model
                                              .textFieldProtocoloOutrosTextController
                                              .text,
                                          protocoloreprodutivoObs: _model
                                              .textFieldProtocoloObservacaoTextController
                                              .text,
                                          createdat: dateTimeFormat(
                                            "yyyy-MM-dd HH:mm:ss",
                                            getCurrentTimestamp,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          protocolod0: _model.dropDownD0Value,
                                          protocoloretirada:
                                              _model.dropDownRetiradaValue,
                                          protocoloiatf:
                                              _model.dropDownIATFValue,
                                        );
                                        _model.index = _model.index + 1;
                                        safeSetState(() {});
                                      }
                                    }
                                    safeSetState(() {
                                      _model.dropDownLoteValueController
                                          ?.reset();
                                      _model.dropDownLoteValue = null;
                                      _model.dropDownVacinaValueController
                                          ?.reset();
                                      _model.dropDownVacinaValue = null;
                                      _model
                                          .dropDownAntiparasitarioValueController
                                          ?.reset();
                                      _model.dropDownAntiparasitarioValue =
                                          null;
                                      _model.dropDownTratamentoValueController
                                          ?.reset();
                                      _model.dropDownTratamentoValue = null;
                                      _model.dropDownProtocoloValueController
                                          ?.reset();
                                      _model.dropDownProtocoloValue = null;
                                      _model.dropDownD0ValueController?.reset();
                                      _model.dropDownD0Value = null;
                                      _model.dropDownRetiradaValueController
                                          ?.reset();
                                      _model.dropDownRetiradaValue = null;
                                      _model.dropDownIATFValueController
                                          ?.reset();
                                      _model.dropDownIATFValue = null;
                                    });
                                    safeSetState(() {
                                      _model.textFieldVacinaOutrosTextController
                                          ?.clear();
                                      _model
                                          .textFieldVacinaObservacaoTextController
                                          ?.clear();
                                      _model
                                          .textFieldAntiparasitarioOutrosTextController
                                          ?.clear();
                                      _model
                                          .textFieldAntiparasitarioObservacaoTextController
                                          ?.clear();
                                      _model
                                          .textFieldTratamentoOutrosTextController
                                          ?.clear();
                                      _model
                                          .textFieldTratamentoObservacaoTextController
                                          ?.clear();
                                      _model
                                          .textFieldProtocoloOutrosTextController
                                          ?.clear();
                                      _model
                                          .textFieldProtocoloObservacaoTextController
                                          ?.clear();
                                      _model
                                          .textFieldPorcentagemLoteTextController
                                          ?.clear();
                                    });
                                    FFAppState().sanidade = [];
                                    FFAppState().vacinasCount = 0;
                                    FFAppState().tratamentosCount = 0;
                                    FFAppState().antiParasitarioCount = 0;
                                    FFAppState().protocolosReproCount = 0;
                                    safeSetState(() {});
                                    await action_blocks.countSanidades(context);
                                    await action_blocks.qTDSanidades(context);
                                    FFAppState().update(() {});
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Sanidade adicionada com sucesso.',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                        ),
                                        duration:
                                            const Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: const Color(0xFF28A365),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleSmallFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleSmallIsCustom,
                                ),
                            elevation: 0.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            disabledColor: const Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                    ].divide(const SizedBox(width: 16.0)),
                  ),
                ].divide(const SizedBox(height: 24.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}
