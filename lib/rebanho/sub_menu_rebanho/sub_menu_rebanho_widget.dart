import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rebanho/add_rebanho/add_rebanho_widget.dart';
import '/rebanho/add_rebanho_nascimento/add_rebanho_nascimento_widget.dart';
import '/rebanho/add_rebanho_semen/add_rebanho_semen_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sub_menu_rebanho_model.dart';
export 'sub_menu_rebanho_model.dart';

class SubMenuRebanhoWidget extends StatefulWidget {
  const SubMenuRebanhoWidget({super.key});

  @override
  State<SubMenuRebanhoWidget> createState() => _SubMenuRebanhoWidgetState();
}

class _SubMenuRebanhoWidgetState extends State<SubMenuRebanhoWidget> {
  late SubMenuRebanhoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubMenuRebanhoModel());

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
      elevation: 3.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.0),
          bottomRight: Radius.circular(6.0),
          topLeft: Radius.circular(6.0),
          topRight: Radius.circular(6.0),
        ),
      ),
      child: Container(
        width: 300.0,
        height: 197.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6.0),
            bottomRight: Radius.circular(6.0),
            topLeft: Radius.circular(6.0),
            topRight: Radius.circular(6.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 56.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Builder(
                  builder: (context) => InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (FFAppState().propriedadeSelecionada.idPropriedade !=
                          '') {
                        _model.propriedadesNasc =
                            await SQLiteManager.instance.listarPropriedades(
                          userID: currentUserUid,
                        );
                        _model.lotesRebNasc =
                            await SQLiteManager.instance.buscarLotes(
                          idPropriedade:
                              FFAppState().propriedadeSelecionada.idPropriedade,
                        );
                        FFAppState().rebanhoLotesSelecionar = [];
                        _model.index = 0;
                        safeSetState(() {});
                        if (_model.lotesRebNasc!.isNotEmpty) {
                          while (_model.index < _model.lotesRebNasc!.length) {
                            FFAppState()
                                .addToRebanhoLotesSelecionar(LocalLotesStruct(
                              idLote: _model.lotesRebNasc
                                  ?.elementAtOrNull(_model.index)
                                  ?.idLote,
                              nome: _model.lotesRebNasc
                                  ?.elementAtOrNull(_model.index)
                                  ?.nome,
                            ));
                            safeSetState(() {});
                            _model.index = _model.index + 1;
                            safeSetState(() {});
                          }
                        }
                        FFAppState().matrizSelecionada =
                            AnimalSelecionadoStruct.fromSerializableMap(
                                jsonDecode('{}'));
                        FFAppState().reprodutorSelecionado =
                            AnimalSelecionadoStruct.fromSerializableMap(
                                jsonDecode('{}'));
                        safeSetState(() {});
                        await showDialog(
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: const AlignmentDirectional(0.0, 0.0)
                                  .resolve(Directionality.of(context)),
                              child: const AddRebanhoNascimentoWidget(),
                            );
                          },
                        );
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: const Text('Selecionar propriedade'),
                              content: const Text(
                                  'Para adicionar um animal nascimento, selecione uma propriedade primeiro.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      safeSetState(() {});
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Color(0xFF2F2F2F),
                          size: 24.0,
                        ),
                        Text(
                          'Nascimento',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ].divide(const SizedBox(width: 8.0)),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 56.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Builder(
                  builder: (context) => InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (FFAppState().propriedadeSelecionada.idPropriedade !=
                          '') {
                        _model.propriedadessReb =
                            await SQLiteManager.instance.listarPropriedades(
                          userID: currentUserUid,
                        );
                        _model.lotesReb =
                            await SQLiteManager.instance.buscarLotes(
                          idPropriedade:
                              FFAppState().propriedadeSelecionada.idPropriedade,
                        );
                        FFAppState().rebanhoLotesSelecionar = [];
                        _model.index = 0;
                        safeSetState(() {});
                        if (_model.lotesReb!.isNotEmpty) {
                          while (_model.index < _model.lotesReb!.length) {
                            FFAppState()
                                .addToRebanhoLotesSelecionar(LocalLotesStruct(
                              idLote: _model.lotesReb
                                  ?.elementAtOrNull(_model.index)
                                  ?.idLote,
                              nome: _model.lotesReb
                                  ?.elementAtOrNull(_model.index)
                                  ?.nome,
                            ));
                            safeSetState(() {});
                            _model.index = _model.index + 1;
                            safeSetState(() {});
                          }
                        }
                        FFAppState().matrizSelecionada =
                            AnimalSelecionadoStruct.fromSerializableMap(
                                jsonDecode('{}'));
                        FFAppState().reprodutorSelecionado =
                            AnimalSelecionadoStruct.fromSerializableMap(
                                jsonDecode('{}'));
                        safeSetState(() {});
                        await showDialog(
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: const AlignmentDirectional(0.0, 0.0)
                                  .resolve(Directionality.of(context)),
                              child: const AddRebanhoWidget(),
                            );
                          },
                        );
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: const Text('Selecionar propriedade'),
                              content: const Text(
                                  'Para adicionar um animal, selecione uma propriedade primeiro.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      safeSetState(() {});
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Color(0xFF2F2F2F),
                          size: 24.0,
                        ),
                        Text(
                          'Animal',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ].divide(const SizedBox(width: 8.0)),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 56.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Builder(
                  builder: (context) => InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (FFAppState().propriedadeSelecionada.idPropriedade !=
                          '') {
                        await showDialog(
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: const AlignmentDirectional(0.0, 0.0)
                                  .resolve(Directionality.of(context)),
                              child: const AddRebanhoSemenWidget(),
                            );
                          },
                        );
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: const Text('Selecionar propriedade'),
                              content: const Text(
                                  'Para adicionar um sêmen, selecione uma propriedade primeiro.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Color(0xFF2F2F2F),
                          size: 24.0,
                        ),
                        Text(
                          'Sêmen',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ].divide(const SizedBox(width: 8.0)),
                    ),
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
