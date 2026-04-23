import '/backend/sqlite/sqlite_manager.dart';
import '/components/select_color_icon_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/propriedade/popup_cidades/popup_cidades_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'edit_propriedade_model.dart';
export 'edit_propriedade_model.dart';

class EditPropriedadeWidget extends StatefulWidget {
  const EditPropriedadeWidget({super.key});

  @override
  State<EditPropriedadeWidget> createState() => _EditPropriedadeWidgetState();
}

class _EditPropriedadeWidgetState extends State<EditPropriedadeWidget> {
  late EditPropriedadeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditPropriedadeModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: const Duration(milliseconds: 250),
        callback: (timer) async {
          _model.temNet = await actions.checkInternetConnection();

          safeSetState(() {});
        },
        startImmediately: false,
      );
    });

    _model.nomePropriedadeTextController ??= TextEditingController(
        text: valueOrDefault<String>(
      FFAppState().propriedadeBuscada.nome,
      'Nome da propriedade',
    ));
    _model.nomePropriedadeFocusNode ??= FocusNode();

    _model.benfeitoriaTextController ??= TextEditingController(
        text: FFAppState().propriedadeBuscada.areaBenfeitoria.toString());
    _model.benfeitoriaFocusNode ??= FocusNode();

    _model.tFpastagemTextController ??= TextEditingController(
        text: FFAppState().propriedadeBuscada.areaPastagem.toString());
    _model.tFpastagemFocusNode ??= FocusNode();

    _model.tFreservaTextController ??= TextEditingController(
        text: FFAppState().propriedadeBuscada.areaReserva.toString());
    _model.tFreservaFocusNode ??= FocusNode();

    _model.tFagriculturaTextController ??= TextEditingController(
        text: FFAppState().propriedadeBuscada.areaAgricultura.toString());
    _model.tFagriculturaFocusNode ??= FocusNode();

    _model.textController6 ??=
        TextEditingController(text: FFAppState().propriedadeBuscada.anotacoes);
    _model.textFieldFocusNode ??= FocusNode();

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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 16.0),
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Editar propriedade',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: const Color(0xFF181818),
                          fontSize: 24.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                        var confirmDialogResponse = await showDialog<bool>(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: const Text('Deletar propriedade'),
                                  content: const Text(
                                      'Deseja realmente apagar essa propriedade? Esta ação não pode ser desfeita.'),
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
                        if (!(FFAppState().dataDadosNaoSyncProp != null)) {
                          FFAppState().dataDadosNaoSyncProp =
                              getCurrentTimestamp;
                          safeSetState(() {});
                        }
                        await SQLiteManager.instance.deletePropriedade(
                          idPropriedade:
                              FFAppState().propriedadeBuscada.idPropriedade,
                          updatedat: dateTimeFormat(
                            "yyyy-MM-dd HH:mm:ss",
                            getCurrentTimestamp,
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                        );
                        Navigator.pop(context);
                        }
                      },
                    ),
                ],
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
                      targetAnchor: const AlignmentDirectional(0.0, 1.0)
                          .resolve(Directionality.of(context)),
                      followerAnchor: const AlignmentDirectional(0.0, -1.0)
                          .resolve(Directionality.of(context)),
                      builder: (dialogContext) {
                        return const Material(
                          color: Colors.transparent,
                          child: SelectColorIconWidget(),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: const BorderRadius.only(
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
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              valueOrDefault<String>(
                                FFAppState().iconeSelecionado != ''
                                    ? FFAppState().iconeSelecionado
                                    : functions.stringToImgPath(
                                        FFAppState().propriedadeBuscada.icone),
                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/kpdgcsdxpwzi/Milho.png',
                              ),
                              width: 32.0,
                              height: 32.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Alterar ícone',
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
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF474747),
                                size: 24.0,
                              ),
                            ].divide(const SizedBox(width: 8.0)),
                          ),
                        ],
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nome da propriedade*',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    TextFormField(
                      controller: _model.nomePropriedadeTextController,
                      focusNode: _model.nomePropriedadeFocusNode,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: ' Nome da propriedade',
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  color: const Color(0xFFBEBEBE),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  lineHeight: 1.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00E0E3E7),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF28A365),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F1F1),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            lineHeight: 2.5,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                      cursorColor: FlutterFlowTheme.of(context).secondaryText,
                      validator: _model.nomePropriedadeTextControllerValidator
                          .asValidator(context),
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UF*',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    FlutterFlowDropDown<String>(
                      controller: _model.dropdownUFValueController ??=
                          FormFieldController<String>(
                        _model.dropdownUFValue ??=
                            FFAppState().propriedadeBuscada.estado,
                      ),
                      options: const [
                        'AC',
                        'AL',
                        'AP',
                        'AM',
                        'BA',
                        'CE',
                        'DF',
                        'ES',
                        'GO',
                        'MA',
                        'MT',
                        'MS',
                        'MG',
                        'PA',
                        'PB',
                        'PR',
                        'PE',
                        'PI',
                        'RJ',
                        'RN',
                        'RS',
                        'RO',
                        'RR',
                        'SC',
                        'SP',
                        'SE',
                        'TO'
                      ],
                      onChanged: (val) =>
                          safeSetState(() => _model.dropdownUFValue = val),
                      width: double.infinity,
                      height: 54.0,
                      maxHeight: 300.0,
                      searchHintTextStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                      searchTextStyle: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                      textStyle: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFFBEBEBE),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                      hintText: 'UF',
                      searchHintText: 'Pesquisar UF...',
                      searchCursorColor: FlutterFlowTheme.of(context).secondary,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      fillColor: const Color(0xFFF1F1F1),
                      elevation: 0.0,
                      borderColor: const Color(0x00E0E3E7),
                      borderWidth: 0.0,
                      borderRadius: 8.0,
                      margin: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 4.0, 16.0, 4.0),
                      hidesUnderline: true,
                      isOverButton: true,
                      isSearchable: true,
                      isMultiSelect: false,
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cidade*',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).customColor3,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Builder(
                        builder: (context) => Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: InkWell(
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
                                    const AlignmentDirectional(0.0, 1.0)
                                        .resolve(Directionality.of(context)),
                                followerAnchor:
                                    const AlignmentDirectional(0.0, -1.0)
                                        .resolve(Directionality.of(context)),
                                builder: (dialogContext) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: PopupCidadesWidget(
                                      uf: _model.dropdownUFValue!,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    FFAppState().cidadeSelecionada != ''
                                        ? FFAppState().cidadeSelecionada
                                        : FFAppState()
                                            .propriedadeBuscada
                                            .cidade,
                                    'Cidade',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color:
                                            FFAppState().cidadeSelecionada != ''
                                                ? FlutterFlowTheme.of(context)
                                                    .secondaryText
                                                : FlutterFlowTheme.of(context)
                                                    .accent3,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Área  de benfeitoria (ha)',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.benfeitoriaTextController,
                        focusNode: _model.benfeitoriaFocusNode,
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
                          hintText: '0',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).customColor3,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              lineHeight: 2.5,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        keyboardType: TextInputType.number,
                        cursorColor: FlutterFlowTheme.of(context).secondaryText,
                        validator: _model.benfeitoriaTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Área de pastagem (ha)*',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.tFpastagemTextController,
                        focusNode: _model.tFpastagemFocusNode,
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
                          hintText: '0',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).customColor3,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              lineHeight: 2.5,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        keyboardType: TextInputType.number,
                        cursorColor: FlutterFlowTheme.of(context).secondaryText,
                        validator: _model.tFpastagemTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Área de reserva APP (ha)',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.tFreservaTextController,
                        focusNode: _model.tFreservaFocusNode,
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
                          hintText: '0',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).customColor3,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              lineHeight: 2.5,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        keyboardType: TextInputType.number,
                        cursorColor: FlutterFlowTheme.of(context).secondaryText,
                        validator: _model.tFreservaTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Área de agricultura (ha)',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.tFagriculturaTextController,
                        focusNode: _model.tFagriculturaFocusNode,
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
                          hintText: '0',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).customColor3,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              lineHeight: 2.5,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        keyboardType: TextInputType.number,
                        cursorColor: FlutterFlowTheme.of(context).secondaryText,
                        validator: _model.tFagriculturaTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Área total (ha)',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    Container(
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
                      child: Align(
                        alignment: const AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            valueOrDefault<String>(
                              (valueOrDefault<int>(
                                        int.tryParse(_model
                                            .benfeitoriaTextController.text),
                                        0,
                                      ) +
                                      valueOrDefault<int>(
                                        int.tryParse(_model
                                            .tFpastagemTextController.text),
                                        0,
                                      ) +
                                      valueOrDefault<int>(
                                        int.tryParse(_model
                                            .tFreservaTextController.text),
                                        0,
                                      ) +
                                      valueOrDefault<int>(
                                        int.tryParse(_model
                                            .tFagriculturaTextController.text),
                                        0,
                                      ))
                                  .toString(),
                              '0',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: valueOrDefault<Color>(
                                    (_model.benfeitoriaTextController.text ==
                                                '') ||
                                            (_model.tFpastagemTextController
                                                    .text ==
                                                '') ||
                                            (_model.tFreservaTextController
                                                    .text ==
                                                '') ||
                                            (_model.tFagriculturaTextController
                                                    .text ==
                                                '')
                                        ? const Color(0xFFBEBEBE)
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    const Color(0xFFBEBEBE),
                                  ),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atividades*',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                    if (FFAppState().propriedadeBuscada.atividades != '')
                      Container(
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
                        child: FlutterFlowDropDown<String>(
                          multiSelectController:
                              _model.dropdownAtividadesValueController ??=
                                  FormListFieldController<String>(
                                      _model.dropdownAtividadesValue ??=
                                          List<String>.from(
                            functions.converterJSONparaLista(FFAppState()
                                    .propriedadeBuscada
                                    .atividades) ??
                                [],
                          )),
                          options: const [
                            'Engorda',
                            'Cria',
                            'Leite',
                            'Recria',
                            'Confinamento'
                          ],
                          width: 300.0,
                          height: 56.0,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          hintText: 'Selecione',
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          fillColor: const Color(0xFFF1F1F1),
                          elevation: 0.0,
                          borderColor: const Color(0x00E0E3E7),
                          borderWidth: 0.0,
                          borderRadius: 8.0,
                          margin: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 4.0, 16.0, 4.0),
                          hidesUnderline: true,
                          isOverButton: true,
                          isSearchable: false,
                          isMultiSelect: true,
                          onMultiSelectChanged: (val) => safeSetState(
                              () => _model.dropdownAtividadesValue = val),
                        ),
                      ),
                    if (FFAppState().propriedadeBuscada.atividades == '')
                      Container(
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
                        child: FlutterFlowDropDown<String>(
                          multiSelectController: _model
                                  .dropdownAtividadesSemInfoValueController ??=
                              FormListFieldController<String>(null),
                          options: const [
                            'Engorda',
                            'Cria',
                            'Leite',
                            'Recria',
                            'Confinamento'
                          ],
                          width: 300.0,
                          height: 56.0,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          hintText: 'Selecione',
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          fillColor: const Color(0xFFF1F1F1),
                          elevation: 0.0,
                          borderColor: const Color(0x00E0E3E7),
                          borderWidth: 0.0,
                          borderRadius: 8.0,
                          margin: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 4.0, 16.0, 4.0),
                          hidesUnderline: true,
                          isOverButton: true,
                          isSearchable: false,
                          isMultiSelect: true,
                          onMultiSelectChanged: (val) => safeSetState(() =>
                              _model.dropdownAtividadesSemInfoValue = val),
                        ),
                      ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anotações',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: const Color(0xFF474747),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
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
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 0.0, 0.0),
                        child: TextFormField(
                          controller: _model.textController6,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Anotações',
                            hintStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: const Color(0xFFBEBEBE),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00FFFFFF),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x004B39EF),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          cursorColor: FlutterFlowTheme.of(context).secondary,
                          validator: _model.textController6Validator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
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
                          width: 155.0,
                          height: 56.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: const Color(0x001E7A4C),
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleSmallFamily,
                                color: const Color(0xFF1E7A4C),
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(
                            color: Color(0xFF1E7A4C),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: ((_model
                                        .nomePropriedadeTextController.text ==
                                    '') ||
                                (_model.dropdownUFValue == null ||
                                    _model.dropdownUFValue == '') ||
                                (_model.tFpastagemTextController.text == ''))
                            ? null
                            : () async {
                                if (FFAppState()
                                        .propriedadeBuscada
                                        .atividades !=
                                    '') {
                                  await SQLiteManager.instance
                                      .updatePropriedade(
                                    nome: _model
                                        .nomePropriedadeTextController.text,
                                    estado: _model.dropdownUFValue,
                                    cidade: valueOrDefault<String>(
                                      FFAppState().cidadeSelecionada != ''
                                          ? FFAppState().cidadeSelecionada
                                          : FFAppState()
                                              .propriedadeBuscada
                                              .cidade,
                                      'Cidade',
                                    ),
                                    areaAgricultura: int.tryParse(_model
                                        .tFagriculturaTextController.text),
                                    areaBenfeitoria: int.tryParse(
                                        _model.benfeitoriaTextController.text),
                                    idPropriedade: FFAppState()
                                        .propriedadeBuscada
                                        .idPropriedade,
                                    areaPastagem: int.parse(
                                        _model.tFpastagemTextController.text),
                                    areaReserva: int.tryParse(
                                        _model.tFreservaTextController.text),
                                    areaTotal: valueOrDefault<int>(
                                      int
                                              .parse(
                                                  _model
                                                      .benfeitoriaTextController
                                                      .text) +
                                          int
                                              .parse(
                                                  _model.tFpastagemTextController
                                                      .text) +
                                          int.parse(_model
                                              .tFreservaTextController.text) +
                                          int.parse(_model
                                              .tFagriculturaTextController
                                              .text),
                                      0,
                                    ),
                                    icone: FFAppState().iconeSelecionado != ''
                                        ? functions.imgPathToString(
                                            FFAppState().iconeSelecionado)
                                        : FFAppState().propriedadeBuscada.icone,
                                    atividades: FFAppState()
                                                .propriedadeBuscada
                                                .atividades !=
                                            ''
                                        ? functions.converterListaParaJSON(
                                            _model.dropdownAtividadesValue
                                                ?.toList())
                                        : functions.converterListaParaJSON(
                                            _model
                                                .dropdownAtividadesSemInfoValue
                                                ?.toList()),
                                    anotacoes: _model.textController6.text,
                                    usersID:
                                        FFAppState().propriedadeBuscada.usersID,
                                    updatedat: dateTimeFormat(
                                      "yyyy-MM-dd HH:mm:ss",
                                      getCurrentTimestamp,
                                      locale: FFLocalizations.of(context)
                                          .languageCode,
                                    ),
                                  );
                                  if (!(FFAppState().dataDadosNaoSyncProp !=
                                      null)) {
                                    FFAppState().dataDadosNaoSyncProp =
                                        getCurrentTimestamp;
                                    safeSetState(() {});
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Propriedade atualizada com sucesso.',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                    ),
                                  );
                                  FFAppState().update(() {});
                                  Navigator.pop(context);
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        content: const Text(
                                            'Selecione uma atividade.'),
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
                                }
                              },
                        text: 'Salvar',
                        options: FFButtonOptions(
                          width: 155.0,
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
                                color: Colors.white,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleSmallIsCustom,
                              ),
                          elevation: 3.0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          disabledColor: FlutterFlowTheme.of(context).tertiary,
                          disabledTextColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(width: 16.0)),
                ),
              ),
            ].divide(const SizedBox(height: 32.0)),
          ),
        ),
      ),
    );
  }
}
