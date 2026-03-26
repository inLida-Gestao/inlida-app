import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'filtros_rebanho_model.dart';
export 'filtros_rebanho_model.dart';

class FiltrosRebanhoWidget extends StatefulWidget {
  const FiltrosRebanhoWidget({super.key});

  @override
  State<FiltrosRebanhoWidget> createState() => _FiltrosRebanhoWidgetState();
}

class _FiltrosRebanhoWidgetState extends State<FiltrosRebanhoWidget> {
  late FiltrosRebanhoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FiltrosRebanhoModel());

    _model.dropDownLoteValue = FFAppState().filtroLoteRebanho.isNotEmpty
        ? FFAppState().filtroLoteRebanho
        : null;

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

    return Material(
      color: Colors.transparent,
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.90,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(25.0, 25.0, 25.0, 25.0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/Icon_Button5656.png',
                          width: 40.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      'Filtrar',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                                color: const Color(0xFF2F2F2F),
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        FFAppState().filtrosAplicadosRebanho = [];
                        FFAppState().filtroOrigemRebanho = '';
                        FFAppState().filtroCategoriasRebanho = '';
                        FFAppState().filtroRaca = '';
                        FFAppState().filtroStatusRebanho = '';
                        FFAppState().filtroSexoRebanho = '';
                        FFAppState().filtroLoteRebanho = '';
                        FFAppState().filtroLoteRebanhoNome = '';
                        FFAppState().filtroStatusRebanhoList = [];
                        safeSetState(() {
                          _model.dropDownLoteValue = null;
                          _model.dropDownLoteValueController?.value = null;
                        });
                        safeSetState(() {});
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Limpar',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  color: const Color(0xFFBEBEBE),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFBEBEBE),
            ),
            Flexible(
              child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sexo',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: const Color(0xFF2F2F2F),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (FFAppState().filtroSexoRebanho ==
                                          'Macho') {
                                        FFAppState()
                                            .removeFromFiltrosAplicadosRebanho(
                                                FFAppState().filtroSexoRebanho);
                                        safeSetState(() {});
                                        FFAppState().filtroSexoRebanho = '';
                                        safeSetState(() {});
                                      } else {
                                        FFAppState()
                                            .removeFromFiltrosAplicadosRebanho(
                                                FFAppState().filtroSexoRebanho);
                                        safeSetState(() {});
                                        FFAppState().filtroSexoRebanho =
                                            'Macho';
                                        safeSetState(() {});
                                        FFAppState()
                                            .addToFiltrosAplicadosRebanho(
                                                FFAppState().filtroSexoRebanho);
                                        safeSetState(() {});
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(100.0),
                                        bottomRight: Radius.circular(100.0),
                                        topLeft: Radius.circular(100.0),
                                        topRight: Radius.circular(100.0),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              FFAppState().filtroSexoRebanho ==
                                                      'Macho'
                                                  ? FlutterFlowTheme.of(context)
                                                      .customColor7
                                                  : Colors.white,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(100.0),
                                            bottomRight: Radius.circular(100.0),
                                            topLeft: Radius.circular(100.0),
                                            topRight: Radius.circular(100.0),
                                          ),
                                          border: Border.all(
                                            color: FFAppState()
                                                        .filtroSexoRebanho ==
                                                    'Macho'
                                                ? FlutterFlowTheme.of(context)
                                                    .secondary
                                                : FlutterFlowTheme.of(context)
                                                    .customColor5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 4.0, 8.0, 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Macho',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color: FFAppState()
                                                                  .filtroSexoRebanho ==
                                                              'Macho'
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                              if (FFAppState()
                                                      .filtroSexoRebanho ==
                                                  'Macho')
                                                Icon(
                                                  Icons.close,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  size: 16.0,
                                                ),
                                            ].divide(
                                                const SizedBox(width: 8.0)),
                                          ),
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
                                      if (FFAppState().filtroSexoRebanho ==
                                          'Fêmea') {
                                        FFAppState()
                                            .removeFromFiltrosAplicadosRebanho(
                                                FFAppState().filtroSexoRebanho);
                                        safeSetState(() {});
                                        FFAppState().filtroSexoRebanho = '';
                                        safeSetState(() {});
                                      } else {
                                        FFAppState()
                                            .removeFromFiltrosAplicadosRebanho(
                                                FFAppState().filtroSexoRebanho);
                                        safeSetState(() {});
                                        FFAppState().filtroSexoRebanho =
                                            'Fêmea';
                                        safeSetState(() {});
                                        FFAppState()
                                            .addToFiltrosAplicadosRebanho(
                                                FFAppState().filtroSexoRebanho);
                                        safeSetState(() {});
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(100.0),
                                        bottomRight: Radius.circular(100.0),
                                        topLeft: Radius.circular(100.0),
                                        topRight: Radius.circular(100.0),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              FFAppState().filtroSexoRebanho ==
                                                      'Fêmea'
                                                  ? FlutterFlowTheme.of(context)
                                                      .customColor7
                                                  : Colors.white,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(100.0),
                                            bottomRight: Radius.circular(100.0),
                                            topLeft: Radius.circular(100.0),
                                            topRight: Radius.circular(100.0),
                                          ),
                                          border: Border.all(
                                            color: FFAppState()
                                                        .filtroSexoRebanho ==
                                                    'Fêmea'
                                                ? FlutterFlowTheme.of(context)
                                                    .secondary
                                                : FlutterFlowTheme.of(context)
                                                    .customColor5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 4.0, 8.0, 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Fêmea',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color: FFAppState()
                                                                  .filtroSexoRebanho ==
                                                              'Fêmea'
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                              if (FFAppState()
                                                      .filtroSexoRebanho ==
                                                  'Fêmea')
                                                Icon(
                                                  Icons.close,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  size: 16.0,
                                                ),
                                            ].divide(
                                                const SizedBox(width: 8.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ].divide(const SizedBox(width: 8.0)),
                              ),
                            ),
                          ],
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
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: const Color(0xFF2F2F2F),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                                Builder(
                                  builder: (context) {
                                    final status =
                                        FFAppState().statusRebanho.toList();

                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(status.length,
                                            (statusIndex) {
                                          final statusItem =
                                              status[statusIndex];
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (FFAppState()
                                                  .filtroStatusRebanhoList
                                                  .isNotEmpty) {
                                                if (FFAppState()
                                                    .filtroStatusRebanhoList
                                                    .contains(statusItem)) {
                                                  FFAppState()
                                                      .removeFromFiltrosAplicadosRebanho(
                                                          statusItem);
                                                  FFAppState()
                                                      .removeFromFiltroStatusRebanhoList(
                                                          statusItem);
                                                  safeSetState(() {});
                                                } else {
                                                  FFAppState()
                                                      .addToFiltrosAplicadosRebanho(
                                                          statusItem);
                                                  FFAppState()
                                                          .filtroStatusRebanho =
                                                      statusItem;
                                                  FFAppState()
                                                      .addToFiltroStatusRebanhoList(
                                                          statusItem);
                                                  safeSetState(() {});
                                                }
                                              } else {
                                                FFAppState()
                                                    .addToFiltrosAplicadosRebanho(
                                                        statusItem);
                                                FFAppState()
                                                        .filtroStatusRebanho =
                                                    statusItem;
                                                FFAppState()
                                                    .addToFiltroStatusRebanhoList(
                                                        statusItem);
                                                safeSetState(() {});
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(100.0),
                                                bottomRight:
                                                    Radius.circular(100.0),
                                                topLeft: Radius.circular(100.0),
                                                topRight:
                                                    Radius.circular(100.0),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FFAppState()
                                                          .filtroStatusRebanhoList
                                                          .contains(statusItem)
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .customColor7
                                                      : Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(100.0),
                                                    bottomRight:
                                                        Radius.circular(100.0),
                                                    topLeft:
                                                        Radius.circular(100.0),
                                                    topRight:
                                                        Radius.circular(100.0),
                                                  ),
                                                  border: Border.all(
                                                    color: FFAppState()
                                                            .filtroStatusRebanhoList
                                                            .contains(
                                                                statusItem)
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .secondary
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .customColor5,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          8.0, 4.0, 8.0, 4.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        statusItem,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FFAppState()
                                                                          .filtroStatusRebanhoList
                                                                          .contains(
                                                                              statusItem)
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                      if (FFAppState()
                                                          .filtroStatusRebanhoList
                                                          .contains(statusItem))
                                                        Icon(
                                                          Icons.close,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          size: 16.0,
                                                        ),
                                                    ].divide(const SizedBox(
                                                        width: 8.0)),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 24.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: const Color(0xFF2F2F2F),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              Builder(
                                builder: (context) {
                                  final status =
                                      FFAppState().statusRebanho.toList();

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(status.length,
                                          (statusIndex) {
                                        final statusItem = status[statusIndex];
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (FFAppState()
                                                .filtroStatusRebanhoList
                                                .contains(statusItem)) {
                                              FFAppState()
                                                  .removeFromFiltrosAplicadosRebanho(
                                                      statusItem);
                                              FFAppState()
                                                  .removeFromFiltroStatusRebanhoList(
                                                      statusItem);
                                            } else {
                                              FFAppState()
                                                  .addToFiltrosAplicadosRebanho(
                                                      statusItem);
                                              FFAppState()
                                                  .addToFiltroStatusRebanhoList(
                                                      statusItem);
                                            }

                                            FFAppState().filtroStatusRebanho =
                                                FFAppState()
                                                        .filtroStatusRebanhoList
                                                        .isEmpty
                                                    ? ''
                                                    : FFAppState()
                                                        .filtroStatusRebanhoList
                                                        .join('|');
                                            safeSetState(() {});
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(100.0),
                                              bottomRight:
                                                  Radius.circular(100.0),
                                              topLeft: Radius.circular(100.0),
                                              topRight: Radius.circular(100.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FFAppState()
                                                        .filtroStatusRebanhoList
                                                        .contains(statusItem)
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .customColor7
                                                    : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(100.0),
                                                  bottomRight:
                                                      Radius.circular(100.0),
                                                  topLeft:
                                                      Radius.circular(100.0),
                                                  topRight:
                                                      Radius.circular(100.0),
                                                ),
                                                border: Border.all(
                                                  color: FFAppState()
                                                          .filtroStatusRebanhoList
                                                          .contains(statusItem)
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .customColor5,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      statusItem,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FFAppState()
                                                                    .filtroStatusRebanhoList
                                                                    .contains(
                                                                        statusItem)
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    if (FFAppState()
                                                        .filtroStatusRebanhoList
                                                        .contains(statusItem))
                                                      Icon(
                                                        Icons.close,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 16.0,
                                                      ),
                                                  ].divide(const SizedBox(
                                                      width: 8.0)),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 24.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Categoria',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: const Color(0xFF2F2F2F),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              Builder(
                                builder: (context) {
                                  final categoria =
                                      FFAppState().categoriasRebanho.toList();

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(categoria.length,
                                          (categoriaIndex) {
                                        final categoriaItem =
                                            categoria[categoriaIndex];
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (FFAppState()
                                                    .filtroCategoriasRebanho !=
                                                '') {
                                              if (FFAppState()
                                                      .filtroCategoriasRebanho ==
                                                  categoriaItem) {
                                                FFAppState()
                                                    .removeFromFiltrosAplicadosRebanho(
                                                        FFAppState()
                                                            .filtroCategoriasRebanho);
                                                safeSetState(() {});
                                                FFAppState()
                                                    .filtroCategoriasRebanho = '';
                                                safeSetState(() {});
                                              } else {
                                                FFAppState()
                                                    .removeFromFiltrosAplicadosRebanho(
                                                        FFAppState()
                                                            .filtroCategoriasRebanho);
                                                safeSetState(() {});
                                                FFAppState()
                                                    .addToFiltrosAplicadosRebanho(
                                                        categoriaItem);
                                                FFAppState()
                                                        .filtroCategoriasRebanho =
                                                    categoriaItem;
                                                safeSetState(() {});
                                              }
                                            } else {
                                              FFAppState()
                                                  .addToFiltrosAplicadosRebanho(
                                                      categoriaItem);
                                              FFAppState()
                                                      .filtroCategoriasRebanho =
                                                  categoriaItem;
                                              safeSetState(() {});
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(100.0),
                                              bottomRight:
                                                  Radius.circular(100.0),
                                              topLeft: Radius.circular(100.0),
                                              topRight: Radius.circular(100.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FFAppState()
                                                            .filtroCategoriasRebanho ==
                                                        categoriaItem
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .customColor7
                                                    : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(100.0),
                                                  bottomRight:
                                                      Radius.circular(100.0),
                                                  topLeft:
                                                      Radius.circular(100.0),
                                                  topRight:
                                                      Radius.circular(100.0),
                                                ),
                                                border: Border.all(
                                                  color: FFAppState()
                                                              .filtroCategoriasRebanho ==
                                                          categoriaItem
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .customColor5,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      categoriaItem,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FFAppState()
                                                                        .filtroCategoriasRebanho ==
                                                                    categoriaItem
                                                                ? const Color(
                                                                    0xFF1E7A4C)
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    if (FFAppState()
                                                            .filtroCategoriasRebanho ==
                                                        categoriaItem)
                                                      Icon(
                                                        Icons.close,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 16.0,
                                                      ),
                                                  ].divide(const SizedBox(
                                                      width: 8.0)),
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
                            ],
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
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lote',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: const Color(0xFF2F2F2F),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(100.0),
                                          bottomRight: Radius.circular(100.0),
                                          topLeft: Radius.circular(100.0),
                                          topRight: Radius.circular(100.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(100.0),
                                              bottomRight:
                                                  Radius.circular(100.0),
                                              topLeft: Radius.circular(100.0),
                                              topRight: Radius.circular(100.0),
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFEDEDED),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 4.0, 8.0, 4.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Hello World',
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
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                                Icon(
                                                  Icons.close,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  size: 16.0,
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 8.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 24.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Raça',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: const Color(0xFF2F2F2F),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              Builder(
                                builder: (context) {
                                  final raca = FFAppState().raca.toList();

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(raca.length,
                                          (racaIndex) {
                                        final racaItem = raca[racaIndex];
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (FFAppState().filtroRaca != '') {
                                              if (FFAppState().filtroRaca ==
                                                  racaItem) {
                                                FFAppState()
                                                    .removeFromFiltrosAplicadosRebanho(
                                                        FFAppState()
                                                            .filtroRaca);
                                                safeSetState(() {});
                                                FFAppState().filtroRaca = '';
                                                safeSetState(() {});
                                              } else {
                                                FFAppState()
                                                    .removeFromFiltrosAplicadosRebanho(
                                                        FFAppState()
                                                            .filtroRaca);
                                                safeSetState(() {});
                                                FFAppState().filtroRaca =
                                                    racaItem;
                                                FFAppState()
                                                    .addToFiltrosAplicadosRebanho(
                                                        racaItem);
                                                safeSetState(() {});
                                              }
                                            } else {
                                              FFAppState().filtroRaca =
                                                  racaItem;
                                              FFAppState()
                                                  .addToFiltrosAplicadosRebanho(
                                                      racaItem);
                                              safeSetState(() {});
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(100.0),
                                              bottomRight:
                                                  Radius.circular(100.0),
                                              topLeft: Radius.circular(100.0),
                                              topRight: Radius.circular(100.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    FFAppState().filtroRaca ==
                                                            racaItem
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .customColor7
                                                        : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(100.0),
                                                  bottomRight:
                                                      Radius.circular(100.0),
                                                  topLeft:
                                                      Radius.circular(100.0),
                                                  topRight:
                                                      Radius.circular(100.0),
                                                ),
                                                border: Border.all(
                                                  color:
                                                      FFAppState().filtroRaca ==
                                                              racaItem
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .customColor5,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      racaItem,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FFAppState()
                                                                        .filtroRaca ==
                                                                    racaItem
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    if (racaItem ==
                                                        FFAppState().filtroRaca)
                                                      Icon(
                                                        Icons.close,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 16.0,
                                                      ),
                                                  ].divide(const SizedBox(
                                                      width: 8.0)),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 24.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Origem',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: const Color(0xFF2F2F2F),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              Builder(
                                builder: (context) {
                                  final origem =
                                      FFAppState().origemRebanho.toList();

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(origem.length,
                                          (origemIndex) {
                                        final origemItem = origem[origemIndex];
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (FFAppState()
                                                    .filtroOrigemRebanho ==
                                                origemItem) {
                                              if (FFAppState()
                                                      .filtroOrigemRebanho ==
                                                  origemItem) {
                                                FFAppState()
                                                    .removeFromFiltrosAplicadosRebanho(
                                                        FFAppState()
                                                            .filtroOrigemRebanho);
                                                safeSetState(() {});
                                                FFAppState()
                                                    .filtroOrigemRebanho = '';
                                                safeSetState(() {});
                                              } else {
                                                FFAppState()
                                                    .removeFromFiltrosAplicadosRebanho(
                                                        FFAppState()
                                                            .filtroOrigemRebanho);
                                                safeSetState(() {});
                                                FFAppState()
                                                    .addToFiltrosAplicadosRebanho(
                                                        origemItem);
                                                FFAppState()
                                                        .filtroOrigemRebanho =
                                                    origemItem;
                                                safeSetState(() {});
                                              }
                                            } else {
                                              FFAppState()
                                                  .addToFiltrosAplicadosRebanho(
                                                      origemItem);
                                              FFAppState().filtroOrigemRebanho =
                                                  origemItem;
                                              safeSetState(() {});
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(100.0),
                                              bottomRight:
                                                  Radius.circular(100.0),
                                              topLeft: Radius.circular(100.0),
                                              topRight: Radius.circular(100.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FFAppState()
                                                            .filtroOrigemRebanho ==
                                                        origemItem
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .customColor7
                                                    : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(100.0),
                                                  bottomRight:
                                                      Radius.circular(100.0),
                                                  topLeft:
                                                      Radius.circular(100.0),
                                                  topRight:
                                                      Radius.circular(100.0),
                                                ),
                                                border: Border.all(
                                                  color: FFAppState()
                                                              .filtroOrigemRebanho ==
                                                          origemItem
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .customColor5,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      origemItem,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FFAppState()
                                                                        .filtroOrigemRebanho ==
                                                                    origemItem
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                    if (origemItem ==
                                                        FFAppState()
                                                            .filtroOrigemRebanho)
                                                      Icon(
                                                        Icons.close,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        size: 16.0,
                                                      ),
                                                  ].divide(const SizedBox(
                                                      width: 8.0)),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 24.0, 0.0, 0.0),
                      child: FutureBuilder<List<ListarLotesRow>>(
                        future: SQLiteManager.instance.listarLotes(
                          idPropriedade:
                              FFAppState().propriedadeSelecionada.idPropriedade,
                        ),
                        builder: (context, snapshot) {
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
                          final lotesDisponiveis = snapshot.data!
                              .where((e) => e.idLote != null)
                              .toList();

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lote',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: const Color(0xFF2F2F2F),
                                          fontSize: 18.0,
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
                                      Expanded(
                                        child: FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropDownLoteValueController ??=
                                              FormFieldController<String>(
                                            _model.dropDownLoteValue,
                                          ),
                                          options: lotesDisponiveis
                                              .map((e) => e.idLote!)
                                              .toList(),
                                          optionLabels: lotesDisponiveis
                                              .map(
                                                  (e) => valueOrDefault<String>(
                                                        e.nome,
                                                        'Sem nome',
                                                      ))
                                              .toList(),
                                          onChanged: (value) async {
                                            final loteSelecionado =
                                                lotesDisponiveis
                                                    .where((e) =>
                                                        e.idLote == value)
                                                    .toList()
                                                    .firstOrNull;
                                            final nomeLoteSelecionado =
                                                loteSelecionado?.nome ?? '';

                                            if (FFAppState()
                                                .filtroLoteRebanhoNome
                                                .isNotEmpty) {
                                              FFAppState()
                                                  .removeFromFiltrosAplicadosRebanho(
                                                      FFAppState()
                                                          .filtroLoteRebanhoNome);
                                            }

                                            safeSetState(() {
                                              _model.dropDownLoteValue = value;
                                            });

                                            FFAppState().filtroLoteRebanho =
                                                value ?? '';
                                            FFAppState().filtroLoteRebanhoNome =
                                                nomeLoteSelecionado;

                                            if (nomeLoteSelecionado
                                                .isNotEmpty) {
                                              FFAppState()
                                                  .addToFiltrosAplicadosRebanho(
                                                      nomeLoteSelecionado);
                                            }

                                            safeSetState(() {});
                                          },
                                          width: double.infinity,
                                          height: 50.0,
                                          maxHeight: 300.0,
                                          searchHintText: 'Pesquisar',
                                          searchTextStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
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
                                          isSearchable: true,
                                          isMultiSelect: false,
                                        ),
                                      ),
                                      if (_model.dropDownLoteValue != null &&
                                          _model.dropDownLoteValue != '')
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (FFAppState()
                                                .filtroLoteRebanhoNome
                                                .isNotEmpty) {
                                              FFAppState()
                                                  .removeFromFiltrosAplicadosRebanho(
                                                      FFAppState()
                                                          .filtroLoteRebanhoNome);
                                            }
                                            FFAppState().filtroLoteRebanho = '';
                                            FFAppState().filtroLoteRebanhoNome =
                                                '';
                                            safeSetState(() {
                                              _model.dropDownLoteValue = null;
                                              _model.dropDownLoteValueController
                                                  ?.value = null;
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 24.0,
                                          ),
                                        ),
                                    ].divide(const SizedBox(width: 12.0)),
                                  ),
                                ].divide(const SizedBox(height: 8.0)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFBEBEBE),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 16.0),
              child: FFButtonWidget(
                onPressed: () async {
                  Navigator.pop(context);
                },
                text: 'Ver resultados',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 47.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: const Color(0xFF28A365),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleSmallFamily,
                        color: Colors.white,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).titleSmallIsCustom,
                      ),
                  elevation: 0.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
