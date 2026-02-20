import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/empty_crias_widget.dart';
import '/components/empty_pesagem_widget.dart';
import '/components/empty_sanidade_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rebanho/add_pesagem/add_pesagem_widget.dart';
import '/rebanho/edit_rebanho/edit_rebanho_widget.dart';
import '/rebanho/reproducoes_view_rebanho/reproducoes_view_rebanho_widget.dart';
import '/sanidade/edit_sanidade_animal/edit_sanidade_animal_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'view_rebanho_model.dart';
export 'view_rebanho_model.dart';

class ViewRebanhoWidget extends StatefulWidget {
  const ViewRebanhoWidget({
    super.key,
    required this.idRebanho,
  });

  final String? idRebanho;

  @override
  State<ViewRebanhoWidget> createState() => _ViewRebanhoWidgetState();
}

class _ViewRebanhoWidgetState extends State<ViewRebanhoWidget>
    with TickerProviderStateMixin {
  late ViewRebanhoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewRebanhoModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 5,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.nAnimalFocusNode1 ??= FocusNode();

    _model.nChipFocusNode ??= FocusNode();

    _model.cdigoregistroFocusNode ??= FocusNode();

    _model.nomeAnimalFocusNode ??= FocusNode();

    _model.nAnimalFocusNode2 ??= FocusNode();

    _model.nAnimalFocusNode3 ??= FocusNode();

    _model.nAnimalFocusNode4 ??= FocusNode();

    _model.nAnimalFocusNode5 ??= FocusNode();

    _model.nAnimalFocusNode6 ??= FocusNode();

    _model.nAnimalFocusNode7 ??= FocusNode();

    _model.nAnimalFocusNode8 ??= FocusNode();

    _model.nAnimalFocusNode9 ??= FocusNode();

    _model.nAnimalFocusNode10 ??= FocusNode();

    _model.nAnimalFocusNode11 ??= FocusNode();

    _model.nAnimalFocusNode12 ??= FocusNode();

    _model.nAnimalFocusNode13 ??= FocusNode();

    _model.nAnimalOlocoFocusNode ??= FocusNode();

    _model.nAnimalFocusNode14 ??= FocusNode();

    _model.nAnimalFocusNode15 ??= FocusNode();

    _model.anotacoesFocusNode ??= FocusNode();

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

    return FutureBuilder<List<BuscarRebanhoRow>>(
      future: SQLiteManager.instance.buscarRebanho(
        idRebanho: widget!.idRebanho,
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
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                          Icons.arrow_back_ios_sharp,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        Text(
                          'Rebanho',
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
                      ].divide(SizedBox(width: 16.0)),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  color: Color(0xFFEDEDED),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            containerBuscarRebanhoRowList.firstOrNull?.tipo ==
                                    'Sêmen'
                                ? 'Sêmen'
                                : 'Animal',
                            'Animal',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Color(0xFF8E8E8E),
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0x00F1F1F1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6.0),
                              bottomRight: Radius.circular(6.0),
                              topLeft: Radius.circular(6.0),
                              topRight: Radius.circular(6.0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (containerBuscarRebanhoRowList
                                      .firstOrNull?.tipo !=
                                  'Sêmen')
                                Flexible(
                                  child: Text(
                                    '${valueOrDefault<String>(
                                      containerBuscarRebanhoRowList
                                          .firstOrNull?.numeroAnimal,
                                      '00000',
                                    )} • ${valueOrDefault<String>(
                                          containerBuscarRebanhoRowList
                                              .firstOrNull?.nome,
                                          'nome',
                                        ) == 'null' ? 'S/N' : valueOrDefault<String>(
                                        containerBuscarRebanhoRowList
                                            .firstOrNull?.nome,
                                        'nome',
                                      )} • ${containerBuscarRebanhoRowList.firstOrNull?.dataNascimento == 'null' ? 'N/A' : dateTimeFormat(
                                        "d/M/y",
                                        functions.converterParaData(
                                            containerBuscarRebanhoRowList
                                                .firstOrNull?.dataNascimento),
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      )}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: 20.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ),
                              if (containerBuscarRebanhoRowList
                                      .firstOrNull?.tipo ==
                                  'Sêmen')
                                Flexible(
                                  child: Text(
                                    '${valueOrDefault<String>(
                                      containerBuscarRebanhoRowList
                                          .firstOrNull?.numeroAnimal,
                                      '00000',
                                    )} • ${valueOrDefault<String>(
                                          containerBuscarRebanhoRowList
                                              .firstOrNull?.nome,
                                          'nome',
                                        ) == 'null' ? 'S/N' : valueOrDefault<String>(
                                        containerBuscarRebanhoRowList
                                            .firstOrNull?.nome,
                                        'nome',
                                      )}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: 20.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    height: 700.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment(0.0, 0),
                          child: TabBar(
                            isScrollable: true,
                            labelColor: FlutterFlowTheme.of(context).secondary,
                            unselectedLabelColor:
                                FlutterFlowTheme.of(context).accent3,
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleMediumIsCustom,
                                ),
                            unselectedLabelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleMediumIsCustom,
                                ),
                            indicatorColor:
                                FlutterFlowTheme.of(context).primary,
                            tabs: [
                              Tab(
                                text: 'Informações',
                              ),
                              Tab(
                                text: 'Crias',
                              ),
                              Tab(
                                text: 'Pesagens',
                              ),
                              Tab(
                                text: 'Reproduções',
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
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 16.0, 24.0, 40.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Número do animal',
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
                                                              .accent4,
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
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller: _model
                                                              .nAnimalTextController1 ??=
                                                          TextEditingController(
                                                        text: valueOrDefault<
                                                            String>(
                                                          containerBuscarRebanhoRowList
                                                              .firstOrNull
                                                              ?.numeroAnimal,
                                                          'N/A',
                                                        ),
                                                      ),
                                                      focusNode: _model
                                                          .nAnimalFocusNode1,
                                                      autofocus: true,
                                                      readOnly: true,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Número do animal',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: Color(
                                                                      0xFFBEBEBE),
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
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0x00E0E3E7),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0x004B39EF),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
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
                                                                      8.0),
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
                                                                      8.0),
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            Color(0xFFF1F1F1),
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                      validator: _model
                                                          .nAnimalTextController1Validator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Chip',
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
                                                              .accent4,
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
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                                .nChipTextController ??=
                                                            TextEditingController(
                                                          text: valueOrDefault<
                                                                      String>(
                                                                    containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.chip,
                                                                    'N/A',
                                                                  ) ==
                                                                  'null'
                                                              ? ' '
                                                              : valueOrDefault<
                                                                  String>(
                                                                  containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.chip,
                                                                  'N/A',
                                                                ),
                                                        ),
                                                        focusNode: _model
                                                            .nChipFocusNode,
                                                        autofocus: true,
                                                        readOnly: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Chip do animal',
                                                          hintStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: Color(
                                                                        0xFFBEBEBE),
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
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00E0E3E7),
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x004B39EF),
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
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
                                                                        8.0),
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
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Color(0xFFF1F1F1),
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
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
                                                        validator: _model
                                                            .nChipTextControllerValidator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Código registro',
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
                                                              .accent4,
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
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller: _model
                                                              .cdigoregistroTextController ??=
                                                          TextEditingController(
                                                        text: valueOrDefault<
                                                            String>(
                                                          valueOrDefault<
                                                                      String>(
                                                                    containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.codRegistro,
                                                                    'N/A',
                                                                  ) ==
                                                                  'null'
                                                              ? 'S/N'
                                                              : valueOrDefault<
                                                                  String>(
                                                                  containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.codRegistro,
                                                                  'N/A',
                                                                ),
                                                          'S/N',
                                                        ),
                                                      ),
                                                      focusNode: _model
                                                          .cdigoregistroFocusNode,
                                                      autofocus: true,
                                                      readOnly: true,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Código registro',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: Color(
                                                                      0xFFBEBEBE),
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
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0x00E0E3E7),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0x004B39EF),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
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
                                                                      8.0),
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
                                                                      8.0),
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            Color(0xFFF1F1F1),
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                      validator: _model
                                                          .cdigoregistroTextControllerValidator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Nome do animal',
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
                                                              .accent4,
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
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller: _model
                                                              .nomeAnimalTextController ??=
                                                          TextEditingController(
                                                        text: valueOrDefault<
                                                            String>(
                                                          valueOrDefault<
                                                                      String>(
                                                                    containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.nome,
                                                                    'N/A',
                                                                  ) ==
                                                                  'null'
                                                              ? 'S/N'
                                                              : valueOrDefault<
                                                                  String>(
                                                                  containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.nome,
                                                                  'N/A',
                                                                ),
                                                          'S/N',
                                                        ),
                                                      ),
                                                      focusNode: _model
                                                          .nomeAnimalFocusNode,
                                                      autofocus: true,
                                                      readOnly: true,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Nome do animal',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: Color(
                                                                      0xFFBEBEBE),
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
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0x00E0E3E7),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0x004B39EF),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
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
                                                                      8.0),
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
                                                                      8.0),
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            Color(0xFFF1F1F1),
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                      validator: _model
                                                          .nomeAnimalTextControllerValidator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Sexo',
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
                                                              .accent4,
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
                                                    width: double.infinity,
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF1F1F1),
                                                      borderRadius:
                                                          BorderRadius.only(
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
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  8.0,
                                                                  0.0,
                                                                  8.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          if (containerBuscarRebanhoRowList
                                                                  .firstOrNull
                                                                  ?.sexo ==
                                                              'Fêmea')
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/Sexofemea.png',
                                                                width: 24.0,
                                                                height: 24.0,
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                              ),
                                                            ),
                                                          if (containerBuscarRebanhoRowList
                                                                  .firstOrNull
                                                                  ?.sexo ==
                                                              'Macho')
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/Sexomacho.png',
                                                                width: 24.0,
                                                                height: 24.0,
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                              ),
                                                            ),
                                                          Expanded(
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  TextFormField(
                                                                controller: _model
                                                                        .nAnimalTextController2 ??=
                                                                    TextEditingController(
                                                                  text: containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.sexo,
                                                                ),
                                                                focusNode: _model
                                                                    .nAnimalFocusNode2,
                                                                autofocus: true,
                                                                readOnly: true,
                                                                obscureText:
                                                                    false,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Sexo',
                                                                  hintStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: Color(
                                                                            0xFFBEBEBE),
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0x00E0E3E7),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0x004B39EF),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  errorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
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
                                                                              .w600,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyMediumIsCustom,
                                                                    ),
                                                                validator: _model
                                                                    .nAnimalTextController2Validator
                                                                    .asValidator(
                                                                        context),
                                                              ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
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
                                                            'Categoria',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
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
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 56.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFF1F1F1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6.0),
                                                                bottomRight: Radius
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
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.nAnimalTextController3 ??=
                                                                                TextEditingController(
                                                                          text:
                                                                              valueOrDefault<String>(
                                                                            containerBuscarRebanhoRowList.firstOrNull?.categoria,
                                                                            'N/A',
                                                                          ),
                                                                        ),
                                                                        focusNode:
                                                                            _model.nAnimalFocusNode3,
                                                                        autofocus:
                                                                            true,
                                                                        readOnly:
                                                                            true,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              'Categoria',
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFFBEBEBE),
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00E0E3E7),
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x004B39EF),
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          errorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        validator: _model
                                                                            .nAnimalTextController3Validator
                                                                            .asValidator(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
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
                                                            'Porte',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
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
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 56.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFF1F1F1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6.0),
                                                                bottomRight: Radius
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
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                          .nAnimalTextController4 ??=
                                                                      TextEditingController(
                                                                    text: valueOrDefault<
                                                                        String>(
                                                                      containerBuscarRebanhoRowList
                                                                          .firstOrNull
                                                                          ?.porte,
                                                                      'N/A',
                                                                    ),
                                                                  ),
                                                                  focusNode: _model
                                                                      .nAnimalFocusNode4,
                                                                  autofocus:
                                                                      true,
                                                                  readOnly:
                                                                      true,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'Porte',
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              Color(0xFFBEBEBE),
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0x00E0E3E7),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0x004B39EF),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  validator: _model
                                                                      .nAnimalTextController4Validator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 24.0)),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
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
                                                            'Nascimento',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
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
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 56.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFF1F1F1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6.0),
                                                                bottomRight: Radius
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
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.nAnimalTextController5 ??=
                                                                                TextEditingController(
                                                                          text:
                                                                              valueOrDefault<String>(
                                                                            dateTimeFormat(
                                                                              "d/M/y",
                                                                              functions.converterParaData(containerBuscarRebanhoRowList.firstOrNull?.dataNascimento),
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            'N/A',
                                                                          ),
                                                                        ),
                                                                        focusNode:
                                                                            _model.nAnimalFocusNode5,
                                                                        autofocus:
                                                                            true,
                                                                        readOnly:
                                                                            true,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              'Nascimento',
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFFBEBEBE),
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00E0E3E7),
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x004B39EF),
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          errorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        validator: _model
                                                                            .nAnimalTextController5Validator
                                                                            .asValidator(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
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
                                                            'Peso nascimento',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
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
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 56.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFF1F1F1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        6.0),
                                                                bottomRight: Radius
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
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.nAnimalTextController6 ??=
                                                                                TextEditingController(
                                                                          text:
                                                                              valueOrDefault<String>(
                                                                            containerBuscarRebanhoRowList.firstOrNull?.pesoNascimento?.toString(),
                                                                            'N/A',
                                                                          ),
                                                                        ),
                                                                        focusNode:
                                                                            _model.nAnimalFocusNode6,
                                                                        autofocus:
                                                                            true,
                                                                        readOnly:
                                                                            true,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              'Nascimento',
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFFBEBEBE),
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00E0E3E7),
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x004B39EF),
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          errorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        validator: _model
                                                                            .nAnimalTextController6Validator
                                                                            .asValidator(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 8.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 24.0)),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Lote',
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
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller: _model
                                                                    .nAnimalTextController7 ??=
                                                                TextEditingController(
                                                              text:
                                                                  valueOrDefault<
                                                                      String>(
                                                                valueOrDefault<
                                                                            String>(
                                                                          containerBuscarRebanhoRowList
                                                                              .firstOrNull
                                                                              ?.loteNome,
                                                                          'N/A',
                                                                        ) ==
                                                                        'null'
                                                                    ? 'N/A'
                                                                    : valueOrDefault<
                                                                        String>(
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.loteNome,
                                                                        'N/A',
                                                                      ),
                                                                'N/A',
                                                              ),
                                                            ),
                                                            focusNode: _model
                                                                .nAnimalFocusNode7,
                                                            autofocus: true,
                                                            readOnly: true,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: 'Lote',
                                                              hintStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        color: Color(
                                                                            0xFFBEBEBE),
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0x00E0E3E7),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0x004B39EF),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              errorBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              focusedErrorBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFFF1F1F1),
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
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
                                                            validator: _model
                                                                .nAnimalTextController7Validator
                                                                .asValidator(
                                                                    context),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Raça',
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
                                                  Container(
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                                .nAnimalTextController8 ??=
                                                            TextEditingController(
                                                          text: () {
                                                            if (valueOrDefault<
                                                                        String>(
                                                                      containerBuscarRebanhoRowList
                                                                          .firstOrNull
                                                                          ?.raca,
                                                                      'N/A',
                                                                    ) ==
                                                                    null ||
                                                                valueOrDefault<
                                                                        String>(
                                                                      containerBuscarRebanhoRowList
                                                                          .firstOrNull
                                                                          ?.raca,
                                                                      'N/A',
                                                                    ) ==
                                                                    '') {
                                                              return 'N/A';
                                                            } else if (valueOrDefault<
                                                                    String>(
                                                                  containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.raca,
                                                                  'N/A',
                                                                ) ==
                                                                'null') {
                                                              return 'N/A';
                                                            } else {
                                                              return valueOrDefault<
                                                                  String>(
                                                                containerBuscarRebanhoRowList
                                                                    .firstOrNull
                                                                    ?.raca,
                                                                'N/A',
                                                              );
                                                            }
                                                          }(),
                                                        ),
                                                        focusNode: _model
                                                            .nAnimalFocusNode8,
                                                        autofocus: true,
                                                        readOnly: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'Raça',
                                                          hintStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: Color(
                                                                        0xFFBEBEBE),
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
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00E0E3E7),
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x004B39EF),
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
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
                                                                        8.0),
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
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Color(0xFFF1F1F1),
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
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
                                                        validator: _model
                                                            .nAnimalTextController8Validator
                                                            .asValidator(
                                                                context),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
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
                                                    Text(
                                                      'Data de entrada no lote',
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 56.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF1F1F1),
                                                        borderRadius:
                                                            BorderRadius.only(
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
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                          .nAnimalTextController9 ??=
                                                                      TextEditingController(
                                                                    text: valueOrDefault<
                                                                        String>(
                                                                      dateTimeFormat(
                                                                        "d/M/y",
                                                                        functions.converterParaData(containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataEntradaLote),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      ),
                                                                      'N/A',
                                                                    ),
                                                                  ),
                                                                  focusNode: _model
                                                                      .nAnimalFocusNode9,
                                                                  autofocus:
                                                                      true,
                                                                  readOnly:
                                                                      true,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'Data de entrada',
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          color:
                                                                              Color(0xFFBEBEBE),
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                        ),
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0x00E0E3E7),
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0x004B39EF),
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    contentPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                      ),
                                                                  validator: _model
                                                                      .nAnimalTextController9Validator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 8.0)),
                                                ),
                                              ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
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
                                                          'Matriz',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: Color(
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
                                                              BoxDecoration(
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
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                if ((containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz !=
                                                                            null &&
                                                                        containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz !=
                                                                            '') &&
                                                                    (containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.numeroMatriz !=
                                                                        'null'))
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.nAnimalTextController10 ??=
                                                                                TextEditingController(
                                                                          text:
                                                                              '${valueOrDefault<String>(
                                                                            valueOrDefault<String>(
                                                                                      containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz,
                                                                                      'S/N',
                                                                                    ) ==
                                                                                    'null'
                                                                                ? 'S/N'
                                                                                : valueOrDefault<String>(
                                                                                    containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz,
                                                                                    'S/N',
                                                                                  ),
                                                                            'S/N',
                                                                          )} - ${valueOrDefault<String>(
                                                                            valueOrDefault<String>(
                                                                                      containerBuscarRebanhoRowList.firstOrNull?.nomeMatriz,
                                                                                      'N/A',
                                                                                    ) ==
                                                                                    'null'
                                                                                ? 'S/N'
                                                                                : valueOrDefault<String>(
                                                                                    containerBuscarRebanhoRowList.firstOrNull?.nomeMatriz,
                                                                                    'N/A',
                                                                                  ),
                                                                            'S/N',
                                                                          )} - ${valueOrDefault<String>(
                                                                            () {
                                                                              if (valueOrDefault<String>(
                                                                                    containerBuscarRebanhoRowList.firstOrNull?.dataNascMatriz,
                                                                                    'N/A',
                                                                                  ) ==
                                                                                  'null') {
                                                                                return 'N/A';
                                                                              } else if (valueOrDefault<String>(
                                                                                        containerBuscarRebanhoRowList.firstOrNull?.dataNascMatriz,
                                                                                        'N/A',
                                                                                      ) ==
                                                                                      null ||
                                                                                  valueOrDefault<String>(
                                                                                        containerBuscarRebanhoRowList.firstOrNull?.dataNascMatriz,
                                                                                        'N/A',
                                                                                      ) ==
                                                                                      '') {
                                                                                return 'N/A';
                                                                              } else {
                                                                                return dateTimeFormat(
                                                                                  "d/M/y",
                                                                                  functions.converterParaData(valueOrDefault<String>(
                                                                                    containerBuscarRebanhoRowList.firstOrNull?.dataNascMatriz,
                                                                                    'N/A',
                                                                                  )),
                                                                                  locale: FFLocalizations.of(context).languageCode,
                                                                                );
                                                                              }
                                                                            }(),
                                                                            'N/A',
                                                                          )}',
                                                                        ),
                                                                        focusNode:
                                                                            _model.nAnimalFocusNode10,
                                                                        autofocus:
                                                                            true,
                                                                        readOnly:
                                                                            true,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              '${valueOrDefault<String>(
                                                                            containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz,
                                                                            'S/N',
                                                                          )} - ${valueOrDefault<String>(
                                                                            containerBuscarRebanhoRowList.firstOrNull?.nomeMatriz,
                                                                            'N/A',
                                                                          )} - ${valueOrDefault<String>(
                                                                            containerBuscarRebanhoRowList.firstOrNull?.dataNascMatriz,
                                                                            'N/A',
                                                                          )}',
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFFBEBEBE),
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00E0E3E7),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x004B39EF),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          errorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                                                                              8.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        validator: _model
                                                                            .nAnimalTextController10Validator
                                                                            .asValidator(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if ((containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz !=
                                                                            null &&
                                                                        containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz !=
                                                                            '') &&
                                                                    (containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.numeroMatriz !=
                                                                        'null'))
                                                                  Builder(
                                                                    builder:
                                                                        (context) =>
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
                                                                        if ((containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz != null && containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz != '') &&
                                                                            (containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz !=
                                                                                'null')) {
                                                                          FFAppState().crias =
                                                                              [];
                                                                          safeSetState(
                                                                              () {});
                                                                          _model.criasFemea = await SQLiteManager
                                                                              .instance
                                                                              .buscarCriasRebanhoMatriz(
                                                                            idRebanho:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.idRebanho,
                                                                          );
                                                                          if (_model.criasFemea != null &&
                                                                              (_model.criasFemea)!.isNotEmpty) {
                                                                            while (_model.indexCrias <
                                                                                _model.criasFemea!.length) {
                                                                              FFAppState().addToCrias(AnimaisStruct(
                                                                                idRebanho: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.idRebanho,
                                                                                sexo: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.sexo,
                                                                                numeroAnimal: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.numeroAnimal,
                                                                                nome: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.nome,
                                                                                dataNascimento: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.dataNascimento,
                                                                                categoria: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.categoria,
                                                                                raca: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.raca,
                                                                                loteNome: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.loteNome,
                                                                                rebanhoIdMatriz: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.rebanhoIdMatriz,
                                                                                rebanhoIdReprodutor: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.rebanhoIdReprodutor,
                                                                                numeroMatriz: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.numeroMatriz,
                                                                                nomeMatriz: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.nomeMatriz,
                                                                                dataNascMatriz: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.dataNascMatriz,
                                                                                racaMatriz: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.racaMatriz,
                                                                                numeroReprodutor: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.numeroReprodutor,
                                                                                nomeReprodutor: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.nomeReprodutor,
                                                                                dataNascReprodutor: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.dataNascReprodutor,
                                                                                racaReprodutor: _model.criasFemea?.elementAtOrNull(_model.indexCrias)?.racaReprodutor,
                                                                              ));
                                                                              safeSetState(() {});
                                                                              _model.indexCrias = _model.indexCrias + 1;
                                                                              safeSetState(() {});
                                                                            }
                                                                            _model.indexCrias =
                                                                                0;
                                                                            safeSetState(() {});
                                                                          }
                                                                          _model.matrizRebanho = await SQLiteManager
                                                                              .instance
                                                                              .buscarRebanhoNum(
                                                                            numeroAnimal:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.numeroMatriz,
                                                                            nome:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.nomeMatriz,
                                                                            dataNascimento:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.dataNascMatriz,
                                                                            raca:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.racaMatriz,
                                                                          );
                                                                          _model.histPesagensMatriz = await SQLiteManager
                                                                              .instance
                                                                              .buscaHistPesagens(
                                                                            idRebanho:
                                                                                _model.matrizRebanho?.firstOrNull?.idRebanho,
                                                                          );
                                                                          FFAppState().histPesagens =
                                                                              [];
                                                                          safeSetState(
                                                                              () {});
                                                                          if (_model.histPesagensMatriz != null &&
                                                                              (_model.histPesagensMatriz)!.isNotEmpty) {
                                                                            while (_model.indexPesagens <
                                                                                _model.histPesagensMatriz!.length) {
                                                                              FFAppState().addToHistPesagens(HistoricoPesagensStruct(
                                                                                idRebanho: _model.histPesagensMatriz?.elementAtOrNull(_model.indexPesagens)?.idRebanho,
                                                                                dataPesagem: _model.histPesagensMatriz?.elementAtOrNull(_model.indexPesagens)?.dataPesagem,
                                                                                tipo: _model.histPesagensMatriz?.elementAtOrNull(_model.indexPesagens)?.tipo,
                                                                                deletado: _model.histPesagensMatriz?.elementAtOrNull(_model.indexPesagens)?.deletado,
                                                                                createdAt: _model.histPesagensMatriz?.elementAtOrNull(_model.indexPesagens)?.createdAt,
                                                                                id: _model.histPesagensMatriz?.elementAtOrNull(_model.indexPesagens)?.id,
                                                                                peso: _model.histPesagensMatriz?.elementAtOrNull(_model.indexPesagens)?.peso,
                                                                              ));
                                                                              safeSetState(() {});
                                                                              _model.indexPesagens = _model.indexPesagens + 1;
                                                                              safeSetState(() {});
                                                                            }
                                                                            _model.indexPesagens =
                                                                                0;
                                                                            safeSetState(() {});
                                                                          }
                                                                          _model.propriedades = await SQLiteManager
                                                                              .instance
                                                                              .listarPropriedades(
                                                                            userID:
                                                                                currentUserUid,
                                                                          );
                                                                          _model.lotes = await SQLiteManager
                                                                              .instance
                                                                              .buscarLotes(
                                                                            idPropriedade: functions.converterLista(_model.propriedades
                                                                                ?.map((e) => valueOrDefault<String>(
                                                                                      e.idPropriedade,
                                                                                      '.',
                                                                                    ))
                                                                                .toList()
                                                                                ?.toList()),
                                                                          );
                                                                          FFAppState().rebanhoLotesSelecionar =
                                                                              [];
                                                                          safeSetState(
                                                                              () {});
                                                                          if (_model.lotes!.length >
                                                                              0) {
                                                                            while (_model.index <
                                                                                _model.lotes!.length) {
                                                                              FFAppState().addToRebanhoLotesSelecionar(LocalLotesStruct(
                                                                                idLote: _model.lotes?.elementAtOrNull(_model.index)?.idLote,
                                                                                nome: _model.lotes?.elementAtOrNull(_model.index)?.nome,
                                                                              ));
                                                                              safeSetState(() {});
                                                                              _model.index = _model.index + 1;
                                                                              safeSetState(() {});
                                                                            }
                                                                          }
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
                                                                                alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                child: ViewRebanhoWidget(
                                                                                  idRebanho: _model.matrizRebanho!.firstOrNull!.idRebanho!,
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        } else {
                                                                          await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                content: Text('Nenhuma matriz associada a este animal'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext),
                                                                                    child: Text('Ok'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        }

                                                                        safeSetState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .open_in_new,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiary,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                  Container(
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
                                                          'Reprodutor',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: Color(
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
                                                              BoxDecoration(
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
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8.0,
                                                                        0.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                if ((containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor !=
                                                                            null &&
                                                                        containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor !=
                                                                            '') &&
                                                                    (containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.numeroReprodutor !=
                                                                        'null'))
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _model.nAnimalTextController11 ??=
                                                                                TextEditingController(
                                                                          text: '${valueOrDefault<String>(
                                                                            valueOrDefault<String>(
                                                                                      containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor,
                                                                                      'S/N',
                                                                                    ) ==
                                                                                    'null'
                                                                                ? 'S/N'
                                                                                : valueOrDefault<String>(
                                                                                    containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor,
                                                                                    'S/N',
                                                                                  ),
                                                                            'S/N',
                                                                          )} - ${valueOrDefault<String>(
                                                                                containerBuscarRebanhoRowList.firstOrNull?.nomeReprodutor,
                                                                                'S/N',
                                                                              ) == 'null' ? 'N/A' : valueOrDefault<String>(
                                                                              containerBuscarRebanhoRowList.firstOrNull?.nomeReprodutor,
                                                                              'S/N',
                                                                            )} - ${valueOrDefault<String>(
                                                                                containerBuscarRebanhoRowList.firstOrNull?.dataNascReprodutor,
                                                                                'N/A',
                                                                              ) == 'null' ? 'N/A' : dateTimeFormat(
                                                                              "d/M/y",
                                                                              functions.converterParaData(valueOrDefault<String>(
                                                                                containerBuscarRebanhoRowList.firstOrNull?.dataNascReprodutor,
                                                                                'N/A',
                                                                              )),
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            )}',
                                                                        ),
                                                                        focusNode:
                                                                            _model.nAnimalFocusNode11,
                                                                        autofocus:
                                                                            true,
                                                                        readOnly:
                                                                            true,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              '${valueOrDefault<String>(
                                                                            containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor,
                                                                            'S/N',
                                                                          )} - ${valueOrDefault<String>(
                                                                            containerBuscarRebanhoRowList.firstOrNull?.nomeReprodutor,
                                                                            'S/N',
                                                                          )} - ${valueOrDefault<String>(
                                                                            containerBuscarRebanhoRowList.firstOrNull?.dataNascReprodutor,
                                                                            'N/A',
                                                                          )}',
                                                                          hintStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFFBEBEBE),
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x00E0E3E7),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0x004B39EF),
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          errorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).error,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                                                                              8.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        validator: _model
                                                                            .nAnimalTextController11Validator
                                                                            .asValidator(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if ((containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor !=
                                                                            null &&
                                                                        containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor !=
                                                                            '') &&
                                                                    (containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.numeroReprodutor !=
                                                                        'null'))
                                                                  Builder(
                                                                    builder:
                                                                        (context) =>
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
                                                                        if ((containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor != null && containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor != '') &&
                                                                            (containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor !=
                                                                                'null')) {
                                                                          FFAppState().crias =
                                                                              [];
                                                                          safeSetState(
                                                                              () {});
                                                                          _model.criasMacho = await SQLiteManager
                                                                              .instance
                                                                              .buscarCriasRebanhoReprodutor(
                                                                            idRebanho:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.idRebanho,
                                                                          );
                                                                          if (_model.criasMacho != null &&
                                                                              (_model.criasMacho)!.isNotEmpty) {
                                                                            while (_model.indexCrias <
                                                                                _model.criasMacho!.length) {
                                                                              FFAppState().addToCrias(AnimaisStruct(
                                                                                idRebanho: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.idRebanho,
                                                                                sexo: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.sexo,
                                                                                numeroAnimal: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.numeroAnimal,
                                                                                nome: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.nome,
                                                                                dataNascimento: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.dataNascimento,
                                                                                categoria: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.categoria,
                                                                                raca: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.raca,
                                                                                loteNome: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.loteNome,
                                                                                rebanhoIdMatriz: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.rebanhoIdMatriz,
                                                                                rebanhoIdReprodutor: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.rebanhoIdReprodutor,
                                                                                numeroMatriz: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.numeroMatriz,
                                                                                nomeMatriz: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.nomeMatriz,
                                                                                dataNascMatriz: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.dataNascMatriz,
                                                                                racaMatriz: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.racaMatriz,
                                                                                numeroReprodutor: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.numeroReprodutor,
                                                                                nomeReprodutor: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.nomeReprodutor,
                                                                                dataNascReprodutor: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.dataNascReprodutor,
                                                                                racaReprodutor: _model.criasMacho?.elementAtOrNull(_model.indexCrias)?.racaReprodutor,
                                                                              ));
                                                                              safeSetState(() {});
                                                                              _model.indexCrias = _model.indexCrias + 1;
                                                                              safeSetState(() {});
                                                                            }
                                                                            _model.indexCrias =
                                                                                0;
                                                                            safeSetState(() {});
                                                                          }
                                                                          _model.reprodutorRebanho = await SQLiteManager
                                                                              .instance
                                                                              .buscarRebanhoNum(
                                                                            numeroAnimal:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.numeroReprodutor,
                                                                            nome:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.nomeReprodutor,
                                                                            dataNascimento:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.dataNascReprodutor,
                                                                            raca:
                                                                                containerBuscarRebanhoRowList.firstOrNull?.racaReprodutor,
                                                                          );
                                                                          _model.histPesagensReprodutor = await SQLiteManager
                                                                              .instance
                                                                              .buscaHistPesagens(
                                                                            idRebanho:
                                                                                _model.reprodutorRebanho?.firstOrNull?.idRebanho,
                                                                          );
                                                                          FFAppState().histPesagens =
                                                                              [];
                                                                          safeSetState(
                                                                              () {});
                                                                          if (_model.histPesagensReprodutor != null &&
                                                                              (_model.histPesagensReprodutor)!.isNotEmpty) {
                                                                            while (_model.indexPesagens <
                                                                                _model.histPesagensReprodutor!.length) {
                                                                              FFAppState().addToHistPesagens(HistoricoPesagensStruct(
                                                                                idRebanho: _model.histPesagensReprodutor?.elementAtOrNull(_model.indexPesagens)?.idRebanho,
                                                                                dataPesagem: _model.histPesagensReprodutor?.elementAtOrNull(_model.indexPesagens)?.dataPesagem,
                                                                                tipo: _model.histPesagensReprodutor?.elementAtOrNull(_model.indexPesagens)?.tipo,
                                                                                deletado: _model.histPesagensReprodutor?.elementAtOrNull(_model.indexPesagens)?.deletado,
                                                                                createdAt: _model.histPesagensReprodutor?.elementAtOrNull(_model.indexPesagens)?.createdAt,
                                                                                id: _model.histPesagensReprodutor?.elementAtOrNull(_model.indexPesagens)?.id,
                                                                                peso: _model.histPesagensReprodutor?.elementAtOrNull(_model.indexPesagens)?.peso,
                                                                              ));
                                                                              safeSetState(() {});
                                                                              _model.indexPesagens = _model.indexPesagens + 1;
                                                                              safeSetState(() {});
                                                                            }
                                                                            _model.indexPesagens =
                                                                                0;
                                                                            safeSetState(() {});
                                                                          }
                                                                          _model.propriedades2 = await SQLiteManager
                                                                              .instance
                                                                              .listarPropriedades(
                                                                            userID:
                                                                                currentUserUid,
                                                                          );
                                                                          _model.lotes2 = await SQLiteManager
                                                                              .instance
                                                                              .buscarLotes(
                                                                            idPropriedade:
                                                                                functions.converterLista(_model.propriedades2?.map((e) => e.idPropriedade).withoutNulls.toList()?.toList()),
                                                                          );
                                                                          FFAppState().rebanhoLotesSelecionar =
                                                                              [];
                                                                          safeSetState(
                                                                              () {});
                                                                          if (_model.lotes2!.length >
                                                                              0) {
                                                                            while (_model.index <
                                                                                _model.lotes2!.length) {
                                                                              FFAppState().addToRebanhoLotesSelecionar(LocalLotesStruct(
                                                                                idLote: _model.lotes2?.elementAtOrNull(_model.index)?.idLote,
                                                                                nome: _model.lotes2?.elementAtOrNull(_model.index)?.nome,
                                                                              ));
                                                                              safeSetState(() {});
                                                                              _model.index = _model.index + 1;
                                                                              safeSetState(() {});
                                                                            }
                                                                          }
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
                                                                                alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                child: ViewRebanhoWidget(
                                                                                  idRebanho: _model.reprodutorRebanho!.firstOrNull!.idRebanho!,
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        } else {
                                                                          await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (alertDialogContext) {
                                                                              return AlertDialog(
                                                                                content: Text('Nenhum reprodutor associado a este animal'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(alertDialogContext),
                                                                                    child: Text('Ok'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        }

                                                                        safeSetState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .open_in_new,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .tertiary,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ].divide(
                                                    SizedBox(height: 24.0)),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
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
                                                          'Desmama',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
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
                                                              BoxDecoration(
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
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model.nAnimalTextController12 ??=
                                                                              TextEditingController(
                                                                        text: valueOrDefault<
                                                                            String>(
                                                                          dateTimeFormat(
                                                                            "d/M/y",
                                                                            functions.converterParaData(containerBuscarRebanhoRowList.firstOrNull?.dataDesmama),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'N/A',
                                                                        ),
                                                                      ),
                                                                      focusNode:
                                                                          _model
                                                                              .nAnimalFocusNode12,
                                                                      autofocus:
                                                                          true,
                                                                      readOnly:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Desmama',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: Color(0xFFBEBEBE),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00E0E3E7),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x004B39EF),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        errorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      validator: _model
                                                                          .nAnimalTextController12Validator
                                                                          .asValidator(
                                                                              context),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
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
                                                          'Peso desmama',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
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
                                                              BoxDecoration(
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
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model.nAnimalTextController13 ??=
                                                                              TextEditingController(
                                                                        text: valueOrDefault<
                                                                            String>(
                                                                          containerBuscarRebanhoRowList
                                                                              .firstOrNull
                                                                              ?.pesoDesmama
                                                                              ?.toString(),
                                                                          'N/A',
                                                                        ),
                                                                      ),
                                                                      focusNode:
                                                                          _model
                                                                              .nAnimalFocusNode13,
                                                                      autofocus:
                                                                          true,
                                                                      readOnly:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Peso desmama',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: Color(0xFFBEBEBE),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00E0E3E7),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x004B39EF),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        errorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      validator: _model
                                                                          .nAnimalTextController13Validator
                                                                          .asValidator(
                                                                              context),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 24.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
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
                                                          'Última pesagem',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
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
                                                              BoxDecoration(
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
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model.nAnimalOlocoTextController ??=
                                                                              TextEditingController(
                                                                        text: valueOrDefault<
                                                                            String>(
                                                                          dateTimeFormat(
                                                                            "d/M/y",
                                                                            functions.converterParaData(containerBuscarRebanhoRowList.firstOrNull?.dataUltimaPesagem),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          'N/A',
                                                                        ),
                                                                      ),
                                                                      focusNode:
                                                                          _model
                                                                              .nAnimalOlocoFocusNode,
                                                                      autofocus:
                                                                          true,
                                                                      readOnly:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Última pesagem',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: Color(0xFFBEBEBE),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00E0E3E7),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x004B39EF),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        errorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      validator: _model
                                                                          .nAnimalOlocoTextControllerValidator
                                                                          .asValidator(
                                                                              context),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
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
                                                          'Peso atual',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
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
                                                              BoxDecoration(
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
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _model.nAnimalTextController14 ??=
                                                                              TextEditingController(
                                                                        text: valueOrDefault<
                                                                            String>(
                                                                          containerBuscarRebanhoRowList
                                                                              .firstOrNull
                                                                              ?.pesoAtual
                                                                              ?.toString(),
                                                                          'N/A',
                                                                        ),
                                                                      ),
                                                                      focusNode:
                                                                          _model
                                                                              .nAnimalFocusNode14,
                                                                      autofocus:
                                                                          true,
                                                                      readOnly:
                                                                          true,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Peso atual',
                                                                        hintStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              color: Color(0xFFBEBEBE),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                            ),
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00E0E3E7),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x004B39EF),
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        errorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                      validator: _model
                                                                          .nAnimalTextController14Validator
                                                                          .asValidator(
                                                                              context),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 24.0)),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Status',
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
                                                Container(
                                                  width: double.infinity,
                                                  height: 56.0,
                                                  decoration: BoxDecoration(
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
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      8.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                TextFormField(
                                                              controller: _model
                                                                      .nAnimalTextController15 ??=
                                                                  TextEditingController(
                                                                text:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.statusRebanho,
                                                                  'N/A',
                                                                ),
                                                              ),
                                                              focusNode: _model
                                                                  .nAnimalFocusNode15,
                                                              autofocus: true,
                                                              readOnly: true,
                                                              obscureText:
                                                                  false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'Status',
                                                                hintStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      color: Color(
                                                                          0xFFBEBEBE),
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
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0x00E0E3E7),
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0x004B39EF),
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                errorBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedErrorBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                                    width: 2.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
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
                                                                            .w600,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                              validator: _model
                                                                  .nAnimalTextController15Validator
                                                                  .asValidator(
                                                                      context),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 8.0)),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Anotações',
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
                                                Container(
                                                  width: double.infinity,
                                                  height: 104.0,
                                                  decoration: BoxDecoration(
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
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller: _model
                                                              .anotacoesTextController ??=
                                                          TextEditingController(
                                                        text: valueOrDefault<
                                                                    String>(
                                                                  containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.anotacoes,
                                                                  'N/A',
                                                                ) ==
                                                                'null'
                                                            ? 'N/A'
                                                            : valueOrDefault<
                                                                String>(
                                                                containerBuscarRebanhoRowList
                                                                    .firstOrNull
                                                                    ?.anotacoes,
                                                                'N/A',
                                                              ),
                                                      ),
                                                      focusNode: _model
                                                          .anotacoesFocusNode,
                                                      autofocus: false,
                                                      readOnly: true,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: Color(
                                                                      0xFFBEBEBE),
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
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0x00E0E3E7),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0x004B39EF),
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
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
                                                                      8.0),
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
                                                                      8.0),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                              ].divide(SizedBox(height: 8.0)),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 24.0),
                                              child: Row(
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
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    24.0,
                                                                    0.0,
                                                                    24.0,
                                                                    0.0),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        color:
                                                            Color(0x001E7A4C),
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmallFamily,
                                                                  color: Color(
                                                                      0xFF1E7A4C),
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
                                                                          .titleSmallIsCustom,
                                                                ),
                                                        elevation: 0.0,
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xFF1E7A4C),
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Builder(
                                                      builder: (context) =>
                                                          FFButtonWidget(
                                                        onPressed: ((containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.tipo ==
                                                                    'Sêmen') &&
                                                                (containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.tipo ==
                                                                    'Nascimento'))
                                                            ? null
                                                            : () async {
                                                                _model.matrizSelecionada =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .buscarRebanho(
                                                                  idRebanho: containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.rebanhoIdMatriz,
                                                                );
                                                                _model.reprodutorSelecionado =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .buscarRebanho(
                                                                  idRebanho: containerBuscarRebanhoRowList
                                                                      .firstOrNull
                                                                      ?.rebanhoIdReprodutor,
                                                                );
                                                                FFAppState()
                                                                    .updateRebanhoSelecionadoStruct(
                                                                  (e) => e
                                                                    ..idPropriedade =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.idPropriedade
                                                                    ..numeroAnimal =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.numeroAnimal
                                                                    ..chip = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.chip
                                                                    ..codRegistro =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.codRegistro
                                                                    ..nome = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.nome
                                                                    ..sexo = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.sexo
                                                                    ..categoria =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.categoria
                                                                    ..dataNascimento =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataNascimento
                                                                    ..pesoNascimento =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.pesoNascimento
                                                                    ..porte = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.porte
                                                                    ..raca = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.raca
                                                                    ..loteId = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.loteID
                                                                    ..dataEntradaLote =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataEntradaLote
                                                                    ..rebanhoIdMatriz =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.rebanhoIdMatriz
                                                                    ..rebanhoIdReprodutor =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.rebanhoIdReprodutor
                                                                    ..dataDesmama =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataDesmama
                                                                    ..pesoDesmama =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.pesoDesmama
                                                                    ..pesoAtual =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.pesoAtual
                                                                    ..status = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.statusRebanho
                                                                    ..origem = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.origem
                                                                    ..anotacoes =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.anotacoes
                                                                    ..idRebanho =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.idRebanho
                                                                    ..tipo = containerBuscarRebanhoRowList
                                                                        .firstOrNull
                                                                        ?.tipo
                                                                    ..dataAcao =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataAcao
                                                                    ..valorCompra =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.valorCompra
                                                                    ..dataUltimaPesagem =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataUltimaPesagem
                                                                    ..loteNome =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.loteNome
                                                                    ..movimentacaoentrada =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.movimentacaoEntrada
                                                                    ..dataVenda =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataVenda
                                                                    ..valorVenda =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.valorVenda
                                                                    ..numeroMatriz =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.numeroMatriz
                                                                    ..nomeMatriz =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.nomeMatriz
                                                                    ..dataNascMatriz =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataNascMatriz
                                                                    ..racaMatriz =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.racaMatriz
                                                                    ..numeroReprodutor =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.numeroReprodutor
                                                                    ..nomeReprodutor =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.nomeReprodutor
                                                                    ..dataNascReprodutor =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataNascReprodutor
                                                                    ..racaReprodutor =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.racaReprodutor
                                                                    ..movimentacaosaida =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.movimentacaoSaida
                                                                    ..datamorte =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.dataMorte
                                                                    ..motivoMorte =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.motivoMorte
                                                                    ..categoriaMatriz =
                                                                        containerBuscarRebanhoRowList
                                                                            .firstOrNull
                                                                            ?.categoriaMatriz,
                                                                );
                                                                FFAppState()
                                                                        .matrizSelecionada =
                                                                    AnimalSelecionadoStruct(
                                                                  numAnimal: _model
                                                                      .matrizSelecionada
                                                                      ?.firstOrNull
                                                                      ?.numeroAnimal,
                                                                  nomeAnimal: _model
                                                                      .matrizSelecionada
                                                                      ?.firstOrNull
                                                                      ?.nome,
                                                                  dataNascAnimal: _model
                                                                      .matrizSelecionada
                                                                      ?.firstOrNull
                                                                      ?.dataNascimento,
                                                                  racaAnimal: _model
                                                                      .matrizSelecionada
                                                                      ?.firstOrNull
                                                                      ?.raca,
                                                                  categoria: _model
                                                                      .matrizSelecionada
                                                                      ?.firstOrNull
                                                                      ?.categoria,
                                                                );
                                                                FFAppState()
                                                                        .reprodutorSelecionado =
                                                                    AnimalSelecionadoStruct(
                                                                  numAnimal: _model
                                                                      .reprodutorSelecionado
                                                                      ?.firstOrNull
                                                                      ?.numeroAnimal,
                                                                  nomeAnimal: _model
                                                                      .reprodutorSelecionado
                                                                      ?.firstOrNull
                                                                      ?.nome,
                                                                  dataNascAnimal: _model
                                                                      .reprodutorSelecionado
                                                                      ?.firstOrNull
                                                                      ?.dataNascimento,
                                                                  racaAnimal: _model
                                                                      .reprodutorSelecionado
                                                                      ?.firstOrNull
                                                                      ?.raca,
                                                                  categoria: _model
                                                                      .reprodutorSelecionado
                                                                      ?.firstOrNull
                                                                      ?.categoria,
                                                                );
                                                                safeSetState(
                                                                    () {});
                                                                _model.propriedadesView =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .listarPropriedades(
                                                                  userID:
                                                                      currentUserUid,
                                                                );
                                                                _model.lotesRebView =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .buscarLotes(
                                                                  idPropriedade:
                                                                      FFAppState()
                                                                          .propriedadeSelecionada
                                                                          .idPropriedade,
                                                                );
                                                                FFAppState()
                                                                    .rebanhoLotesSelecionar = [];
                                                                safeSetState(
                                                                    () {});
                                                                if (_model
                                                                        .lotesRebView!
                                                                        .length >
                                                                    0) {
                                                                  while (_model
                                                                          .index <
                                                                      _model
                                                                          .lotesRebView!
                                                                          .length) {
                                                                    FFAppState()
                                                                        .addToRebanhoLotesSelecionar(
                                                                            LocalLotesStruct(
                                                                      idLote: _model
                                                                          .lotesRebView
                                                                          ?.elementAtOrNull(
                                                                              _model.index)
                                                                          ?.idLote,
                                                                      nome: _model
                                                                          .lotesRebView
                                                                          ?.elementAtOrNull(
                                                                              _model.index)
                                                                          ?.nome,
                                                                    ));
                                                                    safeSetState(
                                                                        () {});
                                                                    _model.index =
                                                                        _model.index +
                                                                            1;
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                }
                                                                final navigator =
                                                                  Navigator.of(
                                                                    context);
                                                                navigator.pop();
                                                                await Future.delayed(
                                                                  Duration
                                                                    .zero);
                                                                await showDialog(
                                                                  barrierColor:
                                                                      Colors
                                                                          .transparent,
                                                                  context:
                                                                    navigator
                                                                      .context,
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
                                                                      alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0)
                                                                          .resolve(
                                                                            Directionality.of(navigator.context)),
                                                                      child:
                                                                          EditRebanhoWidget(),
                                                                    );
                                                                  },
                                                                );

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                        text: 'Editar',
                                                        icon: Icon(
                                                          Icons.edit_sharp,
                                                          size: 24.0,
                                                        ),
                                                        options:
                                                            FFButtonOptions(
                                                          width: 155.0,
                                                          height: 56.0,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      24.0,
                                                                      0.0,
                                                                      24.0,
                                                                      0.0),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          color:
                                                              Color(0xFF28A365),
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
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          disabledColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .accent3,
                                                          disabledTextColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .tertiary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 16.0)),
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 24.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 14.0, 0.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            final animais = FFAppState()
                                                .crias
                                                .where((e) =>
                                                    e.idRebanho !=
                                                    containerBuscarRebanhoRowList
                                                        .firstOrNull?.idRebanho)
                                                .toList();
                                            if (animais.isEmpty) {
                                              return Center(
                                                child: Container(
                                                  height: 250.0,
                                                  child: EmptyCriasWidget(),
                                                ),
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
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 24.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Builder(
                                                          builder: (context) =>
                                                              Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        24.0,
                                                                        0.0,
                                                                        24.0,
                                                                        24.0),
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
                                                                _model.matriz =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .buscarRebanho(
                                                                  idRebanho:
                                                                      animaisItem
                                                                          .rebanhoIdMatriz,
                                                                );
                                                                if (_model
                                                                            .matriz
                                                                            ?.firstOrNull
                                                                            ?.nome !=
                                                                        null &&
                                                                    _model
                                                                            .matriz
                                                                            ?.firstOrNull
                                                                            ?.nome !=
                                                                        '') {
                                                                  FFAppState()
                                                                          .matrizNome =
                                                                      _model
                                                                          .matriz!
                                                                          .firstOrNull!
                                                                          .nome!;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                                _model.reprodutorNome =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .buscarRebanho(
                                                                  idRebanho:
                                                                      animaisItem
                                                                          .rebanhoIdReprodutor,
                                                                );
                                                                if (_model
                                                                            .reprodutorNome
                                                                            ?.firstOrNull
                                                                            ?.nome !=
                                                                        null &&
                                                                    _model
                                                                            .reprodutorNome
                                                                            ?.firstOrNull
                                                                            ?.nome !=
                                                                        '') {
                                                                  FFAppState()
                                                                          .reprodutorNome =
                                                                      _model
                                                                          .reprodutorNome!
                                                                          .firstOrNull!
                                                                          .nome!;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                                FFAppState()
                                                                        .criaSelecionada =
                                                                    animaisItem
                                                                        .idRebanho;
                                                                safeSetState(
                                                                    () {});
                                                                _model.crias2Femea =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .buscarCriasRebanhoMatriz(
                                                                  idRebanho:
                                                                      animaisItem
                                                                          .idRebanho,
                                                                );
                                                                if (_model.crias2Femea !=
                                                                        null &&
                                                                    (_model.crias2Femea)!
                                                                        .isNotEmpty) {
                                                                  while (_model
                                                                          .indexCrias <
                                                                      _model
                                                                          .crias2Femea!
                                                                          .length) {
                                                                    FFAppState()
                                                                        .addToCrias2(
                                                                            AnimaisStruct(
                                                                      idRebanho: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.idRebanho,
                                                                      sexo: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.sexo,
                                                                      numeroAnimal: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.numeroAnimal,
                                                                      nome: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.nome,
                                                                      dataNascimento: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.dataNascimento,
                                                                      categoria: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.categoria,
                                                                      raca: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.raca,
                                                                      loteNome: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.loteNome,
                                                                      rebanhoIdMatriz: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.rebanhoIdMatriz,
                                                                      rebanhoIdReprodutor: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.rebanhoIdReprodutor,
                                                                      numeroMatriz: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.numeroMatriz,
                                                                      nomeMatriz: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.nomeMatriz,
                                                                      dataNascMatriz: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.dataNascMatriz,
                                                                      racaMatriz: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.racaMatriz,
                                                                      numeroReprodutor: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.numeroReprodutor,
                                                                      nomeReprodutor: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.nomeReprodutor,
                                                                      dataNascReprodutor: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.dataNascReprodutor,
                                                                      racaReprodutor: _model
                                                                          .crias2Femea
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.racaReprodutor,
                                                                    ));
                                                                    safeSetState(
                                                                        () {});
                                                                    _model.indexCrias =
                                                                        _model.indexCrias +
                                                                            1;
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                  _model.indexCrias =
                                                                      0;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                                _model.crias2Macho =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .buscarCriasRebanhoReprodutor(
                                                                  idRebanho:
                                                                      animaisItem
                                                                          .idRebanho,
                                                                );
                                                                if (_model.crias2Macho !=
                                                                        null &&
                                                                    (_model.crias2Macho)!
                                                                        .isNotEmpty) {
                                                                  while (_model
                                                                          .indexCrias <
                                                                      _model
                                                                          .crias2Macho!
                                                                          .length) {
                                                                    FFAppState()
                                                                        .addToCrias2(
                                                                            AnimaisStruct(
                                                                      idRebanho: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.idRebanho,
                                                                      sexo: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.sexo,
                                                                      numeroAnimal: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.numeroAnimal,
                                                                      nome: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.nome,
                                                                      dataNascimento: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.dataNascimento,
                                                                      categoria: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.categoria,
                                                                      raca: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.raca,
                                                                      loteNome: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.loteNome,
                                                                      rebanhoIdMatriz: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.rebanhoIdMatriz,
                                                                      rebanhoIdReprodutor: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.rebanhoIdReprodutor,
                                                                      numeroMatriz: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.numeroMatriz,
                                                                      nomeMatriz: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.nomeMatriz,
                                                                      dataNascMatriz: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.dataNascMatriz,
                                                                      racaMatriz: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.racaMatriz,
                                                                      numeroReprodutor: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.numeroReprodutor,
                                                                      nomeReprodutor: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.nomeReprodutor,
                                                                      dataNascReprodutor: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.dataNascReprodutor,
                                                                      racaReprodutor: _model
                                                                          .crias2Macho
                                                                          ?.elementAtOrNull(
                                                                              _model.indexCrias)
                                                                          ?.racaReprodutor,
                                                                    ));
                                                                    safeSetState(
                                                                        () {});
                                                                    _model.indexCrias =
                                                                        _model.indexCrias +
                                                                            1;
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                  _model.indexCrias =
                                                                      0;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                                _model.histPesagens2 =
                                                                    await SQLiteManager
                                                                        .instance
                                                                        .buscaHistPesagens(
                                                                  idRebanho:
                                                                      animaisItem
                                                                          .idRebanho,
                                                                );
                                                                if (_model.histPesagens2 !=
                                                                        null &&
                                                                    (_model.histPesagens2)!
                                                                        .isNotEmpty) {
                                                                  FFAppState()
                                                                      .histPesagens = [];
                                                                  safeSetState(
                                                                      () {});
                                                                  while (_model
                                                                          .indexPesagens <
                                                                      _model
                                                                          .histPesagens2!
                                                                          .length) {
                                                                    FFAppState()
                                                                        .addToHistPesagens(
                                                                            HistoricoPesagensStruct(
                                                                      idRebanho: _model
                                                                          .histPesagens2
                                                                          ?.elementAtOrNull(
                                                                              _model.indexPesagens)
                                                                          ?.idRebanho,
                                                                      dataPesagem: _model
                                                                          .histPesagens2
                                                                          ?.elementAtOrNull(
                                                                              _model.indexPesagens)
                                                                          ?.dataPesagem,
                                                                      tipo: _model
                                                                          .histPesagens2
                                                                          ?.elementAtOrNull(
                                                                              _model.indexPesagens)
                                                                          ?.tipo,
                                                                      deletado: _model
                                                                          .histPesagens2
                                                                          ?.elementAtOrNull(
                                                                              _model.indexPesagens)
                                                                          ?.deletado,
                                                                      createdAt: _model
                                                                          .histPesagens2
                                                                          ?.elementAtOrNull(
                                                                              _model.indexPesagens)
                                                                          ?.createdAt,
                                                                      peso: _model
                                                                          .histPesagens2
                                                                          ?.elementAtOrNull(
                                                                              _model.indexPesagens)
                                                                          ?.peso,
                                                                    ));
                                                                    safeSetState(
                                                                        () {});
                                                                    _model.indexPesagens =
                                                                        _model.indexPesagens +
                                                                            1;
                                                                    safeSetState(
                                                                        () {});
                                                                  }
                                                                  _model.indexPesagens =
                                                                      0;
                                                                  safeSetState(
                                                                      () {});
                                                                }
                                                                FFAppState()
                                                                    .crias = [];
                                                                safeSetState(
                                                                    () {});
                                                                FFAppState()
                                                                        .crias =
                                                                    FFAppState()
                                                                        .crias2
                                                                        .toList()
                                                                        .cast<
                                                                            AnimaisStruct>();
                                                                safeSetState(
                                                                    () {});
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
                                                                          EdgeInsets
                                                                              .zero,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0)
                                                                          .resolve(
                                                                              Directionality.of(context)),
                                                                      child:
                                                                          ViewRebanhoWidget(
                                                                        idRebanho:
                                                                            FFAppState().criaSelecionada,
                                                                      ),
                                                                    );
                                                                  },
                                                                );

                                                                safeSetState(
                                                                    () {});
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
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
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
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: Image.network(
                                                                                valueOrDefault<String>(
                                                                                  animaisItem.sexo == 'Macho' ? 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-lida-ki7iwq/assets/ywgq178m8pi0/Sexomac.png' : 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-lida-ki7iwq/assets/xmhjphz13izf/Sexofemea.png',
                                                                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-lida-ki7iwq/assets/ywgq178m8pi0/Sexomac.png',
                                                                                ),
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                          '${animaisItem.numeroAnimal} • ${animaisItem.nome} • ${dateTimeFormat(
                                                                            "d/M/y",
                                                                            functions.converterParaData(animaisItem.dataNascimento),
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          )}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFF474747),
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                        ),
                                                                        Text(
                                                                          '${animaisItem.categoria} • ${valueOrDefault<String>(
                                                                            animaisItem.raca,
                                                                            'Sem raça',
                                                                          )}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: Color(0xFF5F5F5F),
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.normal,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children:
                                                                              [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: Image.asset(
                                                                                'assets/images/Lotes4343434.png',
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'Lote ${valueOrDefault<String>(
                                                                                animaisItem.loteNome == 'null'
                                                                                    ? 'S/L'
                                                                                    : valueOrDefault<String>(
                                                                                        animaisItem.loteNome,
                                                                                        'S/L',
                                                                                      ),
                                                                                'S/L',
                                                                              )}',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: Color(0xFF5F5F5F),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ].divide(SizedBox(width: 4.0)),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              height: 2.0)),
                                                                    ),
                                                                  ),
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/Arrowterert.png',
                                                                      width:
                                                                          24.0,
                                                                      height:
                                                                          24.0,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          thickness: 1.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
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
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  24.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Histórico das pesagens',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                              fontSize: 17.0,
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
                                                    Flexible(
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                                                    keyOf: (e) =>
                                                                        functions
                                                                            .converterParaData(e.dataPesagem)!,
                                                                    desc: true)
                                                                .toList();
                                                            if (pesagem
                                                                .isEmpty) {
                                                              return Center(
                                                                child:
                                                                    EmptyPesagemWidget(),
                                                              );
                                                            }

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount: pesagem
                                                                  .length,
                                                              itemBuilder: (context,
                                                                  pesagemIndex) {
                                                                final pesagemItem =
                                                                    pesagem[
                                                                        pesagemIndex];
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
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            24.0,
                                                                            12.0,
                                                                            24.0,
                                                                            12.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  '${valueOrDefault<String>(
                                                                                    pesagemItem.peso.toString(),
                                                                                    '0',
                                                                                  )} KG',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                        color: Color(0xFF474747),
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
                                                                                        color: Color(0xFF5F5F5F),
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                      ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            if (pesagemItem.tipo ==
                                                                                'Nascimento')
                                                                              Container(
                                                                                width: 100.0,
                                                                                height: 24.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: Color(0xFFB1CC29),
                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                ),
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Text(
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
                                                                            if (pesagemItem.tipo ==
                                                                                'Desmama')
                                                                              Container(
                                                                                width: 100.0,
                                                                                height: 24.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: Color(0xFFB1CC29),
                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                ),
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Text(
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
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                var confirmDialogResponse = await showDialog<bool>(
                                                                                      context: context,
                                                                                      builder: (alertDialogContext) {
                                                                                        return AlertDialog(
                                                                                          title: Text('Deletar pesagem'),
                                                                                          content: Text('Tem certeza que deseja deletar esta pesagem ?'),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                              child: Text('Não'),
                                                                                            ),
                                                                                            TextButton(
                                                                                              onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                              child: Text('Sim'),
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
                                                                                  if (!(FFAppState().dataDadosNaoSyncProp == null)) {
                                                                                    FFAppState().dataDadosNaoSyncProp = getCurrentTimestamp;
                                                                                    safeSetState(() {});
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: FaIcon(
                                                                                FontAwesomeIcons.trashAlt,
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                size: 16.0,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(
                                                                        height:
                                                                            1.0,
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
                                                      SizedBox(height: 8.0)),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      24.0, 24.0, 24.0, 24.0),
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
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child: AddPesagemWidget(
                                                          idRebanho: widget!
                                                              .idRebanho!,
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                text: 'Adicionar pesagem',
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 24.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 48.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconAlignment:
                                                      IconAlignment.start,
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF28A365),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
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
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmallIsCustom,
                                                          ),
                                                  elevation: 0.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                              wrapWithModel(
                                model: _model.reproducoesViewRebanhoModel,
                                updateCallback: () => safeSetState(() {}),
                                child: ReproducoesViewRebanhoWidget(
                                  numAnimal: containerBuscarRebanhoRowList
                                      .firstOrNull?.numeroAnimal,
                                  createdAt: containerBuscarRebanhoRowList
                                      .firstOrNull!.createdAt!,
                                ),
                              ),
                              FutureBuilder<List<BuscarSanidadesRebanhoRow>>(
                                future: SQLiteManager.instance
                                    .buscarSanidadesRebanho(
                                  idRebanho: widget!.idRebanho,
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
                                  final containerBuscarSanidadesRebanhoRowList =
                                      snapshot.data!;

                                  return Container(
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: Builder(
                                            builder: (context) {
                                              final sanidades =
                                                  containerBuscarSanidadesRebanhoRowList
                                                      .where((e) =>
                                                          e.deletado == 'NAO')
                                                      .toList()
                                                      .sortedList(
                                                          keyOf: (e) =>
                                                              e.createdAt!,
                                                          desc: true)
                                                      .toList();
                                              if (sanidades.isEmpty) {
                                                return Center(
                                                  child: Container(
                                                    height: 200.0,
                                                    child:
                                                        EmptySanidadeWidget(),
                                                  ),
                                                );
                                              }

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: sanidades.length,
                                                itemBuilder:
                                                    (context, sanidadesIndex) {
                                                  final sanidadesItem =
                                                      sanidades[sanidadesIndex];
                                                  return Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  24.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Builder(
                                                                  builder:
                                                                      (context) =>
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
                                                                      FFAppState()
                                                                              .sanidadeSelecionada =
                                                                          SanidadeStruct(
                                                                        idPropriedade:
                                                                            sanidadesItem.idPropriedade,
                                                                        idRebanho:
                                                                            sanidadesItem.idRebanho,
                                                                        dataSanidade:
                                                                            sanidadesItem.dataSanidade,
                                                                        idLote:
                                                                            sanidadesItem.idLote,
                                                                        porcentagemLote:
                                                                            sanidadesItem.porcentagemLote,
                                                                        idSanidade:
                                                                            sanidadesItem.idSanidade,
                                                                        updatedAt:
                                                                            sanidadesItem.updatedAt,
                                                                        deletado:
                                                                            sanidadesItem.deletado,
                                                                        vacinacao:
                                                                            sanidadesItem.vacinacao,
                                                                        vacOutros:
                                                                            sanidadesItem.vacinacaoOutros,
                                                                        vacObs:
                                                                            sanidadesItem.vacinacaoObs,
                                                                        antiparasitario:
                                                                            sanidadesItem.antiparasitario,
                                                                        antiOutros:
                                                                            sanidadesItem.antiparasitarioOutros,
                                                                        antiObs:
                                                                            sanidadesItem.antiparasitarioObs,
                                                                        tratamento:
                                                                            sanidadesItem.tratamento,
                                                                        tratOutros:
                                                                            sanidadesItem.tratamentoOutros,
                                                                        tratObs:
                                                                            sanidadesItem.tratamentoObs,
                                                                        protocoloReprodutivo:
                                                                            sanidadesItem.protocoloReprodutivo,
                                                                        reproOutros:
                                                                            sanidadesItem.protocoloReprodutivoOutros,
                                                                        reproObs:
                                                                            sanidadesItem.protocoloReprodutivoObs,
                                                                        createdAt:
                                                                            sanidadesItem.createdAt,
                                                                      );
                                                                      safeSetState(
                                                                          () {});
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
                                                                            elevation:
                                                                                0,
                                                                            insetPadding:
                                                                                EdgeInsets.zero,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                            child:
                                                                                EditSanidadeAnimalWidget(),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
                                                                        if ((sanidadesItem.vacinacao == null || sanidadesItem.vacinacao == '') &&
                                                                            ((sanidadesItem.vacinacao != 'null') &&
                                                                                (sanidadesItem.vacinacao != null && sanidadesItem.vacinacao != '')))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
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
                                                                                        color: Color(0xFF474747),
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
                                                                                            alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Color(0xFFB1CC29),
                                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                                              ),
                                                                                              child: Align(
                                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
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
                                                                                        }).divide(SizedBox(width: 8.0)),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ].divide(SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.antiparasitario == null || sanidadesItem.antiparasitario == '') &&
                                                                            ((sanidadesItem.antiparasitario != 'null') &&
                                                                                (sanidadesItem.antiparasitario != null && sanidadesItem.antiparasitario != '')))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
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
                                                                                        color: Color(0xFF474747),
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
                                                                                            alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Color(0xFFB1CC29),
                                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                                              ),
                                                                                              child: Align(
                                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
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
                                                                                        }).divide(SizedBox(width: 8.0)),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ].divide(SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if (((sanidadesItem.protocoloReprodutivo == null || sanidadesItem.protocoloReprodutivo == '') &&
                                                                                ((sanidadesItem.protocoloReprodutivo != 'null') && (sanidadesItem.protocoloReprodutivo != null && sanidadesItem.protocoloReprodutivo != ''))) &&
                                                                            responsiveVisibility(
                                                                              context: context,
                                                                              phone: false,
                                                                            ))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
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
                                                                                        color: Color(0xFF474747),
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
                                                                                            alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Color(0xFFB1CC29),
                                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                                              ),
                                                                                              child: Align(
                                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
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
                                                                                        }).divide(SizedBox(width: 8.0)),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ].divide(SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.tratamento == null || sanidadesItem.tratamento == '') &&
                                                                            ((sanidadesItem.tratamento != 'null') &&
                                                                                (sanidadesItem.tratamento != null && sanidadesItem.tratamento != '')))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
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
                                                                                        color: Color(0xFF474747),
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
                                                                                            alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                            child: Container(
                                                                                              height: 23.0,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Color(0xFFB1CC29),
                                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                                              ),
                                                                                              child: Align(
                                                                                                alignment: AlignmentDirectional(0.0, 0.0),
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
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
                                                                                        }).divide(SizedBox(width: 8.0)),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ].divide(SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.protocoloReprodutivo == null || sanidadesItem.protocoloReprodutivo == '') &&
                                                                            ((sanidadesItem.protocoloReprodutivo != 'null') &&
                                                                                (sanidadesItem.protocoloReprodutivo != null && sanidadesItem.protocoloReprodutivo != '')))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
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
                                                                                        color: Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                        child: Container(
                                                                                          height: 23.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Color(0xFFB1CC29),
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  sanidadesItem.protocoloReprodutivo,
                                                                                                  'N/A',
                                                                                                ),
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
                                                                                      ),
                                                                                    ].divide(SizedBox(width: 8.0)),
                                                                                  ),
                                                                                ),
                                                                              ].divide(SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.protocoloD0 !=
                                                                                'null') ||
                                                                            (sanidadesItem.protocoloD0 == null ||
                                                                                sanidadesItem.protocoloD0 == ''))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Protocolo D0:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                        child: Container(
                                                                                          height: 23.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Color(0xFFB1CC29),
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  sanidadesItem.protocoloD0,
                                                                                                  'N/A',
                                                                                                ),
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
                                                                                      ),
                                                                                    ].divide(SizedBox(width: 8.0)),
                                                                                  ),
                                                                                ),
                                                                              ].divide(SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if ((sanidadesItem.protocoloRetirada !=
                                                                                'null') ||
                                                                            (sanidadesItem.protocoloRetirada == null ||
                                                                                sanidadesItem.protocoloRetirada == ''))
                                                                          SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Protocolo retirada:',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        font: GoogleFonts.plusJakartaSans(
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                        ),
                                                                                        color: Color(0xFF474747),
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                        child: Container(
                                                                                          height: 23.0,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Color(0xFFB1CC29),
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                          ),
                                                                                          child: Align(
                                                                                            alignment: AlignmentDirectional(0.0, 0.0),
                                                                                            child: Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                                                              child: Text(
                                                                                                valueOrDefault<String>(
                                                                                                  sanidadesItem.protocoloRetirada,
                                                                                                  'N/A',
                                                                                                ),
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
                                                                                      ),
                                                                                    ].divide(SizedBox(width: 8.0)),
                                                                                  ),
                                                                                ),
                                                                              ].divide(SizedBox(width: 3.0)),
                                                                            ),
                                                                          ),
                                                                        if (responsiveVisibility(
                                                                          context:
                                                                              context,
                                                                          phone:
                                                                              false,
                                                                        ))
                                                                          Text(
                                                                            dateTimeFormat(
                                                                              "d/M/y",
                                                                              functions.converterParaData(sanidadesItem.dataSanidade),
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                ),
                                                                          ),
                                                                      ].divide(SizedBox(
                                                                              height: 8.0)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: Color(
                                                                    0xFF5F5F5F),
                                                                size: 24.0,
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 8.0)),
                                                          ),
                                                        ),
                                                        Divider(
                                                          thickness: 1.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ].divide(SizedBox(height: 24.0)),
            ),
          ),
        );
      },
    );
  }
}
