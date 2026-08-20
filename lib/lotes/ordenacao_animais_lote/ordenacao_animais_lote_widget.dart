import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ordenacao_animais_lote_model.dart';
export 'ordenacao_animais_lote_model.dart';

/// Bottom sheet to choose the sort order for the animal-selection lists in
/// the add/edit lote screens (número do animal / data de nascimento).
///
/// Uses its own state (`FFAppState().ordenacaoLoteAnimais` /
/// `ordenacaoLoteAnimaisTipo`), independent from the Rebanho screen's sort
/// state.
class OrdenacaoAnimaisLoteWidget extends StatefulWidget {
  const OrdenacaoAnimaisLoteWidget({super.key});

  @override
  State<OrdenacaoAnimaisLoteWidget> createState() =>
      _OrdenacaoAnimaisLoteWidgetState();
}

class _OrdenacaoAnimaisLoteWidgetState
    extends State<OrdenacaoAnimaisLoteWidget> {
  late OrdenacaoAnimaisLoteModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdenacaoAnimaisLoteModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget _buildOption(String tipo, String label) {
    final isSelected = FFAppState().ordenacaoLoteAnimaisTipo == tipo;
    return Container(
      width: double.infinity,
      height: 74.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: isSelected
              ? FlutterFlowTheme.of(context).secondary
              : const Color(0x00000000),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (isSelected) {
                  FFAppState().ordenacaoLoteAnimaisTipo = '';
                  FFAppState().ordenacaoLoteAnimais = '';
                } else {
                  FFAppState().ordenacaoLoteAnimaisTipo = tipo;
                  if (FFAppState().ordenacaoLoteAnimais == '') {
                    FFAppState().ordenacaoLoteAnimais = 'crescente';
                  }
                }
                safeSetState(() {});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  isSelected
                      ? 'assets/images/Radio_button78.png'
                      : 'assets/images/Radio_button.png',
                  width: 24.0,
                  height: 24.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: const Color(0xFF474747),
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                  ),
            ),
          ].divide(const SizedBox(width: 10.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: const AlignmentDirectional(0.0, 1.0),
      child: Material(
        color: Colors.transparent,
        elevation: 5.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    25.0, 25.0, 25.0, 25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40.0),
                    Text(
                      'Ordenar',
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
                        FFAppState().ordenacaoLoteAnimais = '';
                        FFAppState().ordenacaoLoteAnimaisTipo = '';
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
              const Divider(
                thickness: 1.0,
                color: Color(0xFFBEBEBE),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 16.0, 16.0, 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ordenar  por...',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
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
                        if (FFAppState().ordenacaoLoteAnimais == 'crescente') {
                          FFAppState().ordenacaoLoteAnimais = 'decrescente';
                        } else if (FFAppState().ordenacaoLoteAnimais ==
                            'decrescente') {
                          FFAppState().ordenacaoLoteAnimais = 'crescente';
                        } else {
                          FFAppState().ordenacaoLoteAnimais = 'crescente';
                        }
                        safeSetState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            FFAppState().ordenacaoLoteAnimais == ''
                                ? FlutterFlowTheme.of(context)
                                    .secondaryBackground
                                : const Color(0xFFD6F5E5),
                            FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(
                            color: valueOrDefault<Color>(
                              FFAppState().ordenacaoLoteAnimais == ''
                                  ? FlutterFlowTheme.of(context).accent3
                                  : FlutterFlowTheme.of(context).secondary,
                              FlutterFlowTheme.of(context).accent3,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                valueOrDefault<String>(
                                  () {
                                    if (FFAppState().ordenacaoLoteAnimais ==
                                        'crescente') {
                                      return 'Ordem crescente';
                                    } else if (FFAppState()
                                            .ordenacaoLoteAnimais ==
                                        'decrescente') {
                                      return 'Ordem decrescente';
                                    } else {
                                      return 'Sem ordenação';
                                    }
                                  }(),
                                  'Sem ordenação',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: valueOrDefault<Color>(
                                        FFAppState().ordenacaoLoteAnimais == ''
                                            ? FlutterFlowTheme.of(context)
                                                .accent3
                                            : FlutterFlowTheme.of(context)
                                                .secondary,
                                        FlutterFlowTheme.of(context).accent3,
                                      ),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                              if (FFAppState().ordenacaoLoteAnimais ==
                                  'crescente')
                                Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 24.0,
                                ),
                              if (FFAppState().ordenacaoLoteAnimais ==
                                  'decrescente')
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 24.0,
                                ),
                            ].divide(const SizedBox(width: 8.0)),
                          ),
                        ),
                      ),
                    ),
                    _buildOption('numero', 'Número do animal'),
                    _buildOption('nascimento', 'Data de nascimento'),
                  ].divide(const SizedBox(height: 16.0)),
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: Color(0xFFBEBEBE),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    24.0, 16.0, 24.0, 16.0),
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
      ),
    );
  }
}
