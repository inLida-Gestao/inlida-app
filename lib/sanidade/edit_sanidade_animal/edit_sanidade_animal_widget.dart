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
import 'dart:async';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'edit_sanidade_animal_model.dart';
export 'edit_sanidade_animal_model.dart';

class EditSanidadeAnimalWidget extends StatefulWidget {
  const EditSanidadeAnimalWidget({super.key});

  @override
  State<EditSanidadeAnimalWidget> createState() =>
      _EditSanidadeAnimalWidgetState();
}

class _EditSanidadeAnimalWidgetState extends State<EditSanidadeAnimalWidget> {
  late EditSanidadeAnimalModel _model;
  bool _isSaving = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditSanidadeAnimalModel());

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

    _model.textFieldVacinaOutrosTextController ??=
        TextEditingController(text: FFAppState().sanidadeSelecionada.vacOutros);
    _model.textFieldVacinaOutrosFocusNode ??= FocusNode();

    _model.textFieldVacinaObservacaoTextController ??=
        TextEditingController(text: FFAppState().sanidadeSelecionada.vacObs);
    _model.textFieldVacinaObservacaoFocusNode ??= FocusNode();

    _model.textFieldAntiparasitarioOutrosTextController ??=
        TextEditingController(
            text: FFAppState().sanidadeSelecionada.antiOutros);
    _model.textFieldAntiparasitarioOutrosFocusNode ??= FocusNode();

    _model.textFieldAntiparasitarioObservacaoTextController ??=
        TextEditingController(text: FFAppState().sanidadeSelecionada.antiObs);
    _model.textFieldAntiparasitarioObservacaoFocusNode ??= FocusNode();

    _model.textFieldTratamentoOutrosTextController ??= TextEditingController(
        text: FFAppState().sanidadeSelecionada.tratOutros);
    _model.textFieldTratamentoOutrosFocusNode ??= FocusNode();

    _model.textFieldTratamentoObservacaoTextController ??=
        TextEditingController(text: FFAppState().sanidadeSelecionada.tratObs);
    _model.textFieldTratamentoObservacaoFocusNode ??= FocusNode();

    _model.textFieldProtocoloOutrosTextController ??= TextEditingController(
        text: FFAppState().sanidadeSelecionada.reproOutros);
    _model.textFieldProtocoloOutrosFocusNode ??= FocusNode();

    _model.textFieldProtocoloObservacaoTextController ??=
        TextEditingController(text: FFAppState().sanidadeSelecionada.reproObs);
    _model.textFieldProtocoloObservacaoFocusNode ??= FocusNode();

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
      child: FutureBuilder<List<BuscarRebanhoRow>>(
        future: SQLiteManager.instance.buscarRebanho(
          idRebanho: FFAppState().sanidadeSelecionada.idRebanho,
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
          final containerBuscarRebanhoRowList = snapshot.data!;

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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
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
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ].divide(const SizedBox(width: 8.0)),
                          ),
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
                              var confirmDialogResponse =
                                  await showDialog<bool>(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title:
                                                const Text('Deletar sanidade'),
                                            content: const Text(
                                                'Deseja realmente apagar esse registro de sanidade? Esta ação não pode ser desfeita.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext, false),
                                                child: const Text('Não'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext, true),
                                                child: const Text('Sim'),
                                              ),
                                            ],
                                          );
                                        },
                                      ) ??
                                      false;
                              if (confirmDialogResponse) {
                                if (await action_blocks.blockIfAccountCanceled(context, refreshFromServer: true)) return;
                                if (!(FFAppState().dataDadosNaoSyncSanidade !=
                                    null)) {
                                  FFAppState().dataDadosNaoSyncSanidade =
                                      getCurrentTimestamp;
                                  safeSetState(() {});
                                }
                                await SQLiteManager.instance.deleteSanidade(
                                  idSanidade: FFAppState()
                                      .sanidadeSelecionada
                                      .idSanidade,
                                  updatedat: dateTimeFormat(
                                    "yyyy-MM-dd HH:mm:ss",
                                    getCurrentTimestamp,
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  ),
                                );
                                unawaited(
                                  () async {
                                    await action_blocks.qTDSanidades(context);
                                  }(),
                                );
                                unawaited(
                                  () async {
                                    await action_blocks.countSanidades(context);
                                  }(),
                                );
                                Navigator.pop(context);
                              }
                            },
                          ),
                      ].divide(const SizedBox(width: 16.0)),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Editar sanidade',
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
                                    'Animal',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .accent3,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 8.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            containerBuscarRebanhoRowList
                                                .firstOrNull?.nome,
                                            'Animal',
                                          ),
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
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                      if (containerBuscarRebanhoRowList
                                              .firstOrNull?.sexo ==
                                          'Macho')
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/Type=Macho.png',
                                            width: 24.0,
                                            height: 24.0,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      if (containerBuscarRebanhoRowList
                                              .firstOrNull?.sexo ==
                                          'Fêmea')
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/female.png',
                                            width: 24.0,
                                            height: 24.0,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                    ],
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
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      final datePickedDate =
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
                                                const Color(0xFF28A365),
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
                                                const Color(0xFF28A365),
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
                                          _model.datePicked =
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
                                          bottomLeft: Radius.circular(6.0),
                                          bottomRight: Radius.circular(6.0),
                                          topLeft: Radius.circular(6.0),
                                          topRight: Radius.circular(6.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16.0, 0.0, 8.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _model.datePicked != null
                                                    ? valueOrDefault<String>(
                                                        dateTimeFormat(
                                                          "d/M/y",
                                                          _model.datePicked,
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        ),
                                                        'Selecione uma data',
                                                      )
                                                    : dateTimeFormat(
                                                        "d/M/y",
                                                        functions.converterParaData(
                                                            FFAppState()
                                                                .sanidadeSelecionada
                                                                .dataSanidade),
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
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
                                                        _model.datePicked ==
                                                                null
                                                            ? const Color(
                                                                0xFFBEBEBE)
                                                            : const Color(
                                                                0xFF333333),
                                                        const Color(0xFFBEBEBE),
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
                                  if ((FFAppState()
                                              .sanidade
                                              .contains('Vacina') ==
                                          true) ||
                                      (FFAppState()
                                              .sanidadeSelecionada
                                              .vacinacao !=
                                          'null')) {
                                    FFAppState().addToSanidade('Vacina');
                                    safeSetState(() {});
                                  }
                                  if ((FFAppState()
                                              .sanidade
                                              .contains('Antiparasitário') ==
                                          true) ||
                                      (FFAppState()
                                              .sanidadeSelecionada
                                              .antiparasitario !=
                                          'null')) {
                                    FFAppState()
                                        .addToSanidade('Antiparasitário');
                                    safeSetState(() {});
                                  }
                                  if ((FFAppState()
                                              .sanidade
                                              .contains('Tratamento') ==
                                          true) ||
                                      (FFAppState()
                                              .sanidadeSelecionada
                                              .tratamento !=
                                          'null')) {
                                    FFAppState().addToSanidade('Tratamento');
                                    safeSetState(() {});
                                  }
                                  if ((FFAppState().sanidade.contains(
                                              'Protocolo reprodutivo') ==
                                          true) ||
                                      (FFAppState()
                                              .sanidadeSelecionada
                                              .protocoloReprodutivo !=
                                          'null')) {
                                    FFAppState()
                                        .addToSanidade('Protocolo reprodutivo');
                                    safeSetState(() {});
                                  }
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
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
                          if ((FFAppState().sanidade.contains('Vacina') ==
                                  true) ||
                              (FFAppState().sanidadeSelecionada.vacinacao !=
                                  'null'))
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
                                          if ((FFAppState()
                                                      .sanidadeSelecionada
                                                      .vacinacao !=
                                                  '') &&
                                              (FFAppState()
                                                      .sanidadeSelecionada
                                                      .vacinacao !=
                                                  'null'))
                                            Flexible(
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                multiSelectController: _model
                                                        .dropDownVacinaValueController ??=
                                                    FormListFieldController<
                                                        String>(_model
                                                            .dropDownVacinaValue ??=
                                                        List<String>.from(
                                                  functions.converterJSONparaLista(
                                                          FFAppState()
                                                              .sanidadeSelecionada
                                                              .vacinacao) ??
                                                      [],
                                                )),
                                                options: const [
                                                  'Aftosa',
                                                  'Antitetânica',
                                                  'Botulismo',
                                                  'Brucelose',
                                                  'Clostridiose',
                                                  'Diarréia (BVD)',
                                                  'Doença Respiratória (DBR)',
                                                  'Leptospirose',
                                                  'Parainfluenza e herpes',
                                                  'Raiva',
                                                  'Rinotraqueíte (IBR)'
                                                ],
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
                                                isMultiSelect: true,
                                                onMultiSelectChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .dropDownVacinaValue =
                                                        val),
                                              ),
                                            ),
                                          if (_model.dropDownVacinaValue !=
                                                  null &&
                                              (_model.dropDownVacinaValue)!
                                                  .isNotEmpty)
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
                                              0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (FFAppState()
                                                  .sanidadeSelecionada
                                                  .vacinacao ==
                                              'null')
                                            Flexible(
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                multiSelectController: _model
                                                        .dropDownVacinaNullValueController ??=
                                                    FormListFieldController<
                                                        String>(null),
                                                options: const [
                                                  'Aftosa',
                                                  'Antitetânica',
                                                  'Botulismo',
                                                  'Brucelose',
                                                  'Clostridiose',
                                                  'Diarréia (BVD)',
                                                  'Doença Respiratória (DBR)',
                                                  'Leptospirose',
                                                  'Parainfluenza e herpes',
                                                  'Raiva',
                                                  'Rinotraqueíte (IBR)'
                                                ],
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
                                                isMultiSelect: true,
                                                onMultiSelectChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .dropDownVacinaNullValue =
                                                        val),
                                              ),
                                            ),
                                          if (_model.dropDownVacinaNullValue !=
                                                  null &&
                                              (_model.dropDownVacinaNullValue)!
                                                  .isNotEmpty)
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
                                                      .dropDownVacinaNullValueController
                                                      ?.reset();
                                                  _model.dropDownVacinaNullValue =
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
                                        focusNode: _model
                                            .textFieldVacinaOutrosFocusNode,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: 'Vacinação',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
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
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
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
                          if ((FFAppState()
                                      .sanidade
                                      .contains('Antiparasitário') ==
                                  true) ||
                              (FFAppState()
                                      .sanidadeSelecionada
                                      .antiparasitario !=
                                  'null'))
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
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if ((FFAppState()
                                                    .sanidadeSelecionada
                                                    .antiparasitario !=
                                                '') &&
                                            (FFAppState()
                                                    .sanidadeSelecionada
                                                    .antiparasitario !=
                                                'null'))
                                          Flexible(
                                            child: FlutterFlowDropDown<String>(
                                              multiSelectController: _model
                                                      .dropDownAntiparasitarioValueController ??=
                                                  FormListFieldController<
                                                      String>(_model
                                                          .dropDownAntiparasitarioValue ??=
                                                      List<String>.from(
                                                functions.converterJSONparaLista(
                                                        FFAppState()
                                                            .sanidadeSelecionada
                                                            .antiparasitario) ??
                                                    [],
                                              )),
                                              options: const [
                                                'Abamectina',
                                                'Albendazol',
                                                'Babesiose (Tristeza Bovina) & Tripanossoma',
                                                'Brinco mosquicida',
                                                'Carrapaticida & Mosquicida (Pour ON)',
                                                'Carrapaticida & Mosquicida (Pulverização)',
                                                'Deltrametrina, Imidocarp, Nitroxinil & Triclorfon',
                                                'Doramectina',
                                                'Eprinomectina',
                                                'Ivermectina'
                                              ],
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (FFAppState()
                                                  .sanidadeSelecionada
                                                  .antiparasitario ==
                                              'null')
                                            Flexible(
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                multiSelectController: _model
                                                        .dropDownAntiparasitarioNullValueController ??=
                                                    FormListFieldController<
                                                        String>(null),
                                                options: const [
                                                  'Abamectina',
                                                  'Albendazol',
                                                  'Babesiose (Tristeza Bovina) & Tripanossoma',
                                                  'Brinco mosquicida',
                                                  'Carrapaticida & Mosquicida (Pour ON)',
                                                  'Carrapaticida & Mosquicida (Pulverização)',
                                                  'Deltrametrina, Imidocarp, Nitroxinil & Triclorfon',
                                                  'Doramectina',
                                                  'Eprinomectina',
                                                  'Ivermectina'
                                                ],
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
                                                isMultiSelect: true,
                                                onMultiSelectChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .dropDownAntiparasitarioNullValue =
                                                        val),
                                              ),
                                            ),
                                          if (_model.dropDownAntiparasitarioNullValue !=
                                                  null &&
                                              (_model.dropDownAntiparasitarioNullValue)!
                                                  .isNotEmpty)
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
                                                      .dropDownAntiparasitarioNullValueController
                                                      ?.reset();
                                                  _model.dropDownAntiparasitarioNullValue =
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
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
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
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
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
                          if ((FFAppState().sanidade.contains('Tratamento') ==
                                  true) ||
                              (FFAppState().sanidadeSelecionada.tratamento !=
                                  'null'))
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
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if ((FFAppState()
                                                    .sanidadeSelecionada
                                                    .tratamento !=
                                                '') &&
                                            (FFAppState()
                                                    .sanidadeSelecionada
                                                    .tratamento !=
                                                'null'))
                                          Flexible(
                                            child: FlutterFlowDropDown<String>(
                                              multiSelectController: _model
                                                      .dropDownTratamentoValueController ??=
                                                  FormListFieldController<
                                                      String>(_model
                                                          .dropDownTratamentoValue ??=
                                                      List<String>.from(
                                                functions.converterJSONparaLista(
                                                        FFAppState()
                                                            .sanidadeSelecionada
                                                            .tratamento) ??
                                                    [],
                                              )),
                                              options: const [
                                                'Anestésico, Sedativo & Similares',
                                                'Analgésico',
                                                'Anti-inflamatório',
                                                'Anti-séptico',
                                                'Castração Química',
                                                'Complexo Vitamínico & Mineral',
                                                'Homeopático',
                                                'Hormônio',
                                                'Antibiótico'
                                              ],
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (FFAppState()
                                                  .sanidadeSelecionada
                                                  .tratamento ==
                                              'null')
                                            Flexible(
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                multiSelectController: _model
                                                        .dropDownTratamentoNullValueController ??=
                                                    FormListFieldController<
                                                        String>(null),
                                                options: const [
                                                  'Anestésico, Sedativo & Similares',
                                                  'Analgésico',
                                                  'Anti-inflamatório',
                                                  'Anti-séptico',
                                                  'Castração Química',
                                                  'Complexo Vitamínico & Mineral',
                                                  'Homeopático',
                                                  'Hormônio',
                                                  'Antibiótico'
                                                ],
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
                                                isMultiSelect: true,
                                                onMultiSelectChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .dropDownTratamentoNullValue =
                                                        val),
                                              ),
                                            ),
                                          if (_model.dropDownTratamentoNullValue !=
                                                  null &&
                                              (_model.dropDownTratamentoNullValue)!
                                                  .isNotEmpty)
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
                                                      .dropDownTratamentoNullValueController
                                                      ?.reset();
                                                  _model.dropDownTratamentoNullValue =
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
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
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
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
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
                          if ((FFAppState()
                                      .sanidade
                                      .contains('Protocolo reprodutivo') ==
                                  true) ||
                              (FFAppState()
                                      .sanidadeSelecionada
                                      .protocoloReprodutivo !=
                                  'null'))
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
                                                _model.dropDownProtocoloValue ??=
                                                    FFAppState()
                                                        .sanidadeSelecionada
                                                        .protocoloReprodutivo,
                                              ),
                                              options: const [
                                                'D0-D7-D9',
                                                'D0-D8-D10',
                                                'D0-D9-D11',
                                                'D0-D7-D9-D11'
                                              ],
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
                                          if (_model.dropDownProtocoloValue !=
                                                  null &&
                                              _model.dropDownProtocoloValue !=
                                                  '')
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
                                                _model.dropDownD0Value ??=
                                                    FFAppState()
                                                        .sanidadeSelecionada
                                                        .protocoloD0,
                                              ),
                                              options: const [
                                                'BE  + Implante novo',
                                                'BE + Implante novo + PGF',
                                                'BE  + Implante reuso',
                                                'BE + Implante reuso + PGF'
                                              ],
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
                                          if (_model.dropDownD0Value != null &&
                                              _model.dropDownD0Value != '')
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
                                                      .dropDownD0ValueController
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
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color:
                                                      const Color(0xFF181818),
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                                _model.dropDownRetiradaValue ??=
                                                    FFAppState()
                                                        .sanidadeSelecionada
                                                        .protocoloRetirada,
                                              ),
                                              options: const [
                                                'eCG + PGF + CE',
                                                'eCG + PGR + CE + BE'
                                              ],
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
                                          if (_model.dropDownRetiradaValue !=
                                                  null &&
                                              _model.dropDownRetiradaValue !=
                                                  '')
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 24.0, 0.0, 0.0),
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
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                controller: _model
                                                        .dropDownIATFValueController ??=
                                                    FormFieldController<String>(
                                                  _model.dropDownIATFValue ??=
                                                      FFAppState()
                                                          .sanidadeSelecionada
                                                          .protocoloIatf,
                                                ),
                                                options: const [
                                                  'Com GnRH',
                                                  'Sem GnRH'
                                                ],
                                                onChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .dropDownIATFValue =
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
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
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                    !FlutterFlowTheme.of(
                                                            context)
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 0.0,
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
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
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
                            onPressed: _isSaving
                                ? null
                                : () async {
                                    if (_isSaving) return;
                                    _isSaving = true;
                                    safeSetState(() {});
                                    try {
                                      var confirmDialogResponse =
                                          await showDialog<bool>(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Confirmar alterações'),
                                                    content: const Text(
                                                        'Deseja confirmar as alterações realizadas ?'),
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
                                                .dataDadosNaoSyncSanidade !=
                                            null)) {
                                          FFAppState()
                                                  .dataDadosNaoSyncSanidade =
                                              getCurrentTimestamp;
                                          safeSetState(() {});
                                        }
                                        await SQLiteManager.instance
                                            .uPDTSanidadeAnimal(
                                          dataSanidade: _model.datePicked !=
                                                  null
                                              ? dateTimeFormat(
                                                  "yyyy-MM-dd",
                                                  _model.datePicked,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                )
                                              : FFAppState()
                                                  .sanidadeSelecionada
                                                  .dataSanidade,
                                          idSanidade: FFAppState()
                                              .sanidadeSelecionada
                                              .idSanidade,
                                          updatedat: dateTimeFormat(
                                            "yyyy-MM-dd HH:mm:ss",
                                            getCurrentTimestamp,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          vacinacao: valueOrDefault<String>(
                                            () {
                                              if (_model.dropDownVacinaValue !=
                                                      null &&
                                                  (_model.dropDownVacinaValue)!
                                                      .isNotEmpty) {
                                                return functions
                                                    .converterListaParaJSON(
                                                        _model
                                                            .dropDownVacinaValue
                                                            ?.toList());
                                              } else if ((FFAppState()
                                                          .sanidadeSelecionada
                                                          .vacinacao ==
                                                      'null') &&
                                                  (_model.dropDownVacinaNullValue !=
                                                          null &&
                                                      (_model.dropDownVacinaNullValue)!
                                                          .isNotEmpty)) {
                                                return functions
                                                    .converterListaParaJSON(_model
                                                        .dropDownVacinaNullValue
                                                        ?.toList());
                                              } else {
                                                return 'null';
                                              }
                                            }(),
                                            'null',
                                          ),
                                          vacinacaoOutros: _model
                                              .textFieldVacinaOutrosTextController
                                              .text,
                                          vacinacaoObs: _model
                                              .textFieldVacinaObservacaoTextController
                                              .text,
                                          antiparasitario:
                                              valueOrDefault<String>(
                                            () {
                                              if (_model.dropDownAntiparasitarioValue !=
                                                      null &&
                                                  (_model.dropDownAntiparasitarioValue)!
                                                      .isNotEmpty) {
                                                return functions
                                                    .converterListaParaJSON(_model
                                                        .dropDownAntiparasitarioValue
                                                        ?.toList());
                                              } else if ((FFAppState()
                                                          .sanidadeSelecionada
                                                          .antiparasitario ==
                                                      'null') &&
                                                  (_model.dropDownAntiparasitarioNullValue !=
                                                          null &&
                                                      (_model.dropDownAntiparasitarioNullValue)!
                                                          .isNotEmpty)) {
                                                return functions
                                                    .converterListaParaJSON(_model
                                                        .dropDownAntiparasitarioNullValue
                                                        ?.toList());
                                              } else {
                                                return 'null';
                                              }
                                            }(),
                                            'null',
                                          ),
                                          antiparasitarioOutros: _model
                                              .textFieldAntiparasitarioOutrosTextController
                                              .text,
                                          antiparasitarioObs: _model
                                              .textFieldAntiparasitarioObservacaoTextController
                                              .text,
                                          tratamento: valueOrDefault<String>(
                                            () {
                                              if (_model.dropDownTratamentoValue !=
                                                      null &&
                                                  (_model.dropDownTratamentoValue)!
                                                      .isNotEmpty) {
                                                return functions
                                                    .converterListaParaJSON(_model
                                                        .dropDownTratamentoValue
                                                        ?.toList());
                                              } else if ((FFAppState()
                                                          .sanidadeSelecionada
                                                          .tratamento ==
                                                      'null') &&
                                                  (_model.dropDownTratamentoNullValue !=
                                                          null &&
                                                      (_model.dropDownTratamentoNullValue)!
                                                          .isNotEmpty)) {
                                                return functions
                                                    .converterListaParaJSON(_model
                                                        .dropDownTratamentoNullValue
                                                        ?.toList());
                                              } else {
                                                return 'null';
                                              }
                                            }(),
                                            'null',
                                          ),
                                          tratamentoOutros: _model
                                              .textFieldTratamentoOutrosTextController
                                              .text,
                                          tratamentoObs: _model
                                              .textFieldTratamentoObservacaoTextController
                                              .text,
                                          protocoloReprodutivo:
                                              valueOrDefault<String>(
                                            _model.dropDownProtocoloValue,
                                            'null',
                                          ),
                                          protocoloreprodutivoOutros: _model
                                              .textFieldProtocoloOutrosTextController
                                              .text,
                                          protocoloreprodutivoObs: _model
                                              .textFieldProtocoloObservacaoTextController
                                              .text,
                                          protocolod0: _model.dropDownD0Value,
                                          protocoloretirada:
                                              _model.dropDownRetiradaValue,
                                          protocoloiatf:
                                              _model.dropDownIATFValue,
                                        );
                                        FFAppState().sanidade = [];
                                        FFAppState().vacinasCount = 0;
                                        FFAppState().tratamentosCount = 0;
                                        FFAppState().antiParasitarioCount = 0;
                                        FFAppState().protocolosReproCount = 0;
                                        safeSetState(() {});
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Sanidade editada com sucesso.',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                            ),
                                            duration: const Duration(
                                                milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                        );
                                      }
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
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
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
      ),
    );
  }
}
