import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ordernar_propriedades_model.dart';
export 'ordernar_propriedades_model.dart';

class OrdernarPropriedadesWidget extends StatefulWidget {
  const OrdernarPropriedadesWidget({super.key});

  @override
  State<OrdernarPropriedadesWidget> createState() =>
      _OrdernarPropriedadesWidgetState();
}

class _OrdernarPropriedadesWidgetState
    extends State<OrdernarPropriedadesWidget> {
  late OrdernarPropriedadesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdernarPropriedadesModel());

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
        height: 609.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      25.0, 25.0, 25.0, 25.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: const Color(0x0028A365),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Ordernar',
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
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().filtroTipoOrdenacao = '';
                            safeSetState(() {});
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Limpar',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                          color: valueOrDefault<Color>(
                                            (FFAppState()
                                                            .filtroPropAtividades !=
                                                        '') ||
                                                    (FFAppState()
                                                            .filtroPropCidades !=
                                                        '') ||
                                                    (FFAppState()
                                                            .filtroPropEstados !=
                                                        '') ||
                                                    (FFAppState()
                                                            .filtroNumeroAnimais >
                                                        0.0)
                                                ? FlutterFlowTheme.of(context)
                                                    .secondaryText
                                                : FlutterFlowTheme.of(context)
                                                    .accent4,
                                            const Color(0xFFBEBEBE),
                                          ),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
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
                ),
                const Divider(
                  thickness: 1.0,
                  color: Color(0xFFBEBEBE),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 20.0, 24.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ordernar por...',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: const Color(0xFF2F2F2F),
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (FFAppState().filtroOrdenacao == 'Crescente') {
                              FFAppState().filtroOrdenacao = 'Decrescente';
                              safeSetState(() {});
                            } else {
                              FFAppState().filtroOrdenacao = 'Crescente';
                              safeSetState(() {});
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).customColor7,
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).secondary,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    FFAppState().filtroOrdenacao == 'Crescente'
                                        ? 'Ordem crescente '
                                        : 'Ordem decrescente ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ),
                                if (FFAppState().filtroOrdenacao == 'Crescente')
                                  Icon(
                                    Icons.arrow_upward_sharp,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    size: 16.0,
                                  ),
                                if (FFAppState().filtroOrdenacao ==
                                    'Decrescente')
                                  Icon(
                                    Icons.arrow_downward_sharp,
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    size: 16.0,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().filtroTipoOrdenacao = 'Propriedade';
                            safeSetState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 74.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).customColor3,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FFAppState().filtroTipoOrdenacao ==
                                        'Propriedade'
                                    ? FlutterFlowTheme.of(context).secondary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (FFAppState().filtroTipoOrdenacao !=
                                      'Propriedade')
                                    Icon(
                                      Icons.radio_button_off,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                  if (FFAppState().filtroTipoOrdenacao ==
                                      'Propriedade')
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 24.0,
                                    ),
                                  Text(
                                    'Nome da propriedade',
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
                                ].divide(const SizedBox(width: 10.0)),
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
                            FFAppState().filtroTipoOrdenacao = 'Cidade';
                            safeSetState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 74.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).customColor3,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color:
                                    FFAppState().filtroTipoOrdenacao == 'Cidade'
                                        ? FlutterFlowTheme.of(context).secondary
                                        : Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (FFAppState().filtroTipoOrdenacao !=
                                      'Cidade')
                                    Icon(
                                      Icons.radio_button_off,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                  if (FFAppState().filtroTipoOrdenacao ==
                                      'Cidade')
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 24.0,
                                    ),
                                  Text(
                                    'Nome da cidade',
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
                                ].divide(const SizedBox(width: 10.0)),
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
                            FFAppState().filtroTipoOrdenacao = 'UF';
                            safeSetState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 74.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).customColor3,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FFAppState().filtroTipoOrdenacao == 'UF'
                                    ? FlutterFlowTheme.of(context).secondary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (FFAppState().filtroTipoOrdenacao != 'UF')
                                    Icon(
                                      Icons.radio_button_off,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                  if (FFAppState().filtroTipoOrdenacao == 'UF')
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 24.0,
                                    ),
                                  Text(
                                    'UF',
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
                                ].divide(const SizedBox(width: 10.0)),
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
                            FFAppState().filtroTipoOrdenacao = 'Atividades';
                            safeSetState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 74.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).customColor3,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FFAppState().filtroTipoOrdenacao ==
                                        'Atividades'
                                    ? FlutterFlowTheme.of(context).secondary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (FFAppState().filtroTipoOrdenacao !=
                                      'Atividades')
                                    Icon(
                                      Icons.radio_button_off,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                  if (FFAppState().filtroTipoOrdenacao ==
                                      'Atividades')
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 24.0,
                                    ),
                                  Text(
                                    'Atividades',
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
                                ].divide(const SizedBox(width: 10.0)),
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
                            FFAppState().filtroTipoOrdenacao = 'Animais';
                            safeSetState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 74.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).customColor3,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FFAppState().filtroTipoOrdenacao ==
                                        'Animais'
                                    ? FlutterFlowTheme.of(context).secondary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (FFAppState().filtroTipoOrdenacao !=
                                      'Animais')
                                    Icon(
                                      Icons.radio_button_off,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                  if (FFAppState().filtroTipoOrdenacao ==
                                      'Animais')
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 24.0,
                                    ),
                                  Text(
                                    'Número de animais',
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
                                ].divide(const SizedBox(width: 10.0)),
                              ),
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 16.0)),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  color: Color(0xFFBEBEBE),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 24.0, 24.0, 0.0),
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
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: const Color(0xFF28A365),
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleSmallFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleSmallIsCustom,
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
        ),
      ),
    );
  }
}
