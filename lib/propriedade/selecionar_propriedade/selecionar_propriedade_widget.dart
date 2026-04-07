import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/propriedade/selecao_propriedade/selecao_propriedade_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selecionar_propriedade_model.dart';
export 'selecionar_propriedade_model.dart';

class SelecionarPropriedadeWidget extends StatefulWidget {
  const SelecionarPropriedadeWidget({
    super.key,
    this.onPropriedadeChanged,
  });

  final Future Function()? onPropriedadeChanged;

  @override
  State<SelecionarPropriedadeWidget> createState() =>
      _SelecionarPropriedadeWidgetState();
}

class _SelecionarPropriedadeWidgetState
    extends State<SelecionarPropriedadeWidget> {
  late SelecionarPropriedadeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelecionarPropriedadeModel());

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
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            enableDrag: false,
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: const SelecaoPropriedadeWidget(),
              );
            },
          ).then((value) async {
            if (widget.onPropriedadeChanged != null) {
              await widget.onPropriedadeChanged!();
            }
            safeSetState(() {});
          });
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(100.0),
              bottomRight: Radius.circular(100.0),
              topLeft: Radius.circular(100.0),
              topRight: Radius.circular(100.0),
            ),
            border: Border.all(
              color: const Color(0xFFBEBEBE),
              width: 2.0,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x00FFFFFF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100.0),
                bottomRight: Radius.circular(100.0),
                topLeft: Radius.circular(100.0),
                topRight: Radius.circular(100.0),
              ),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primaryBackground,
                width: 2.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(100.0),
                        bottomRight: Radius.circular(100.0),
                        topLeft: Radius.circular(100.0),
                        topRight: Radius.circular(100.0),
                      ),
                      border: Border.all(
                        color: const Color(0x00FFFFFF),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 0.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-lida-ki7iwq/assets/zdkcvi82omdl/mdi_farm6556.png',
                              width: 23.0,
                              height: 24.0,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              valueOrDefault<String>(
                                FFAppState().propriedadeSelecionada.nome,
                                'Nenhuma propriedade selecionada.',
                              ).maybeHandleOverflow(
                                maxChars: 32,
                                replacement: '…',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ].divide(const SizedBox(width: 8.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                  child: Icon(
                    Icons.arrow_drop_down_sharp,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                ),
              ].divide(const SizedBox(width: 8.0)),
            ),
          ),
        ),
      ),
    );
  }
}
