import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/components/navegacao_widget.dart';
import '/components/navegar_bottom_widget.dart';
import '/components/pesquisa_geral_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/lotes/add_lote/add_lote_widget.dart';
import '/lotes/page_lotes/page_lotes_widget.dart';
import '/perfil/minha_conta/minha_conta_widget.dart';
import '/propriedade/add_propriedade/add_propriedade_widget.dart';
import '/propriedade/page_propriedades/page_propriedades_widget.dart';
import '/propriedade/selecionar_propriedade/selecionar_propriedade_widget.dart';
import '/rebanho/page_rebanho/page_rebanho_widget.dart';
import '/rebanho/sub_menu_rebanho/sub_menu_rebanho_widget.dart';
import '/reproducao/page_reproducoes/page_reproducoes_widget.dart';
import '/reproducao/popup_reproducao/popup_reproducao_widget.dart';
import '/sanidade/page_sanidade/page_sanidade_widget.dart';
import '/sanidade/popup_sanidade/popup_sanidade_widget.dart';
import 'dart:async';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Function() navigate = () {};
      _model.userLogadoON = await UsersTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'userID',
          currentUserUid,
        ),
      );
      FFAppState().userLogado = UserStruct(
        nome: _model.userLogadoON?.firstOrNull?.nome,
        email: _model.userLogadoON?.firstOrNull?.email,
        foto: _model.userLogadoON?.firstOrNull?.foto,
        telefone: _model.userLogadoON?.firstOrNull?.telefone,
        permissao: _model.userLogadoON?.firstOrNull?.permissao,
      );
      safeSetState(() {});
      if ((_model.userLogadoON?.firstOrNull?.acesso == 'Pago') ||
          (_model.userLogadoON?.firstOrNull?.acesso == 'Gratis')) {
        await Future.wait([
          Future(() async {
            if (FFAppState().firstRunUserEmail != currentUserEmail) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sincronização iniciada, os dados estão sendo baixados você pode continuar usando o app normalmente.',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                  ),
                  duration: const Duration(milliseconds: 6000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
              FFAppState().propriedadesChangeDateTime =
                  DateTime.fromMillisecondsSinceEpoch(1495616760000);
              FFAppState().rebanhosChangeDateTime =
                  DateTime.fromMillisecondsSinceEpoch(1528129140000);
              FFAppState().lotesChangeDateTime =
                  DateTime.fromMillisecondsSinceEpoch(1497268200000);
              FFAppState().reproducaoChangeDateTime =
                  DateTime.fromMillisecondsSinceEpoch(1497796620000);
              FFAppState().sanidadeChangeDateTime =
                  DateTime.fromMillisecondsSinceEpoch(1498343520000);
              FFAppState().pesagensChangeDateTime =
                  DateTime.fromMillisecondsSinceEpoch(1505578800000);
              FFAppState().animaisRegistrados = 0;
              FFAppState().countReproducoes = 0;
              FFAppState().countInseminacoes = 0;
              FFAppState().countMontaNatural = 0;
              FFAppState().qtdTratamento = 0;
              FFAppState().qtdAnimaisPropriedade = 0;
              FFAppState().qtdLotesAtivos = 0;
              FFAppState().qtdLotesInativos = 0;
              FFAppState().qtdAnimaisLote = 0;
              FFAppState().qtdSanidades = 0;
              FFAppState().qtdVacinas = 0;
              FFAppState().qtdProtocoloReprodutivo = 0;
              FFAppState().qtdAntiparasitarios = 0;
              FFAppState().lotesCadastrados = 0;
              safeSetState(() {});
              try {
                await action_blocks.refreshPropriedades(context);
              } catch (e) {
                debugPrint('[SYNC][propriedades] Erro na home: $e');
              }
              try {
                await action_blocks.refreshLotes(context);
              } catch (e) {
                debugPrint('[SYNC][lotes] Erro na home: $e');
              }
              try {
                await action_blocks.refreshRebanhoOtimizada(context);
              } catch (e) {
                debugPrint('[SYNC][rebanho] Erro na home: $e');
              }
              debugPrint(
                  '[SYNC][home] Iniciando refreshReproducaoOtimizada...');
              try {
                await action_blocks.refreshReproducaoOtimizada(context);
              } catch (e) {
                debugPrint('[SYNC][reproducao] Erro na home: $e');
              }
              debugPrint('[SYNC][home] Iniciando refreshPesagens...');
              try {
                await action_blocks.refreshPesagens(context);
              } catch (e) {
                debugPrint('[SYNC][pesagens] Erro na home: $e');
              }
              debugPrint('[SYNC][home] Iniciando refresSanidadeOtimizada...');
              try {
                await action_blocks.refresSanidadeOtimizada(context);
              } catch (e) {
                debugPrint('[SYNC][sanidade] Erro na home: $e');
              }
              debugPrint('[SYNC][home] Todas as syncs finalizadas.');
              FFAppState().firstRunUserEmail = currentUserEmail;
              FFAppState().ultimaSincronizacao = getCurrentTimestamp;
              safeSetState(() {});
            }
            await action_blocks.animaisRegistrados(context);
          }),
          Future(() async {
            // Monitoramento de conectividade baseado em stream
            try {
              _model.temNet = await actions.checkInternetConnection();
              FFAppState().isOnline = _model.temNet ?? false;
              safeSetState(() {});

              _model.connectivitySubscription =
                  actions.watchConnectivity().listen((results) async {
                try {
                  final hadConnection = _model.temNet ?? false;
                  final hasConn = actions.hasConnection(results);

                  if (hasConn) {
                    _model.temNet = await actions.checkInternetConnection();
                  } else {
                    _model.temNet = false;
                  }
                  FFAppState().isOnline = _model.temNet ?? false;
                  safeSetState(() {});

                  // Auto-sync quando reconecta: offline → online
                  if (!hadConnection && (_model.temNet == true)) {
                    debugPrint('[SYNC][auto] Conectividade restaurada. Aguardando debounce...');
                    await Future.delayed(const Duration(seconds: 5));
                    final stillOnline = await actions.checkInternetConnection();
                    if (stillOnline && context.mounted) {
                      await actions.performAutoSync(context);
                      safeSetState(() {});
                    }
                  }
                } catch (e) {
                  debugPrint('[CONNECTIVITY] Erro no listener: $e');
                }
              });
            } catch (e) {
              debugPrint('[CONNECTIVITY] Erro ao iniciar monitoramento: $e');
            }
          }),
          Future(() async {
            await action_blocks.animaisRegistrados(context);
            await action_blocks.animaisPropriedade(context);
            await action_blocks.countLotesCadastrados(context);
            _model.userLogado = await UsersTable().queryRows(
              queryFn: (q) => q.eqOrNull(
                'userID',
                currentUserUid,
              ),
            );
            FFAppState().updateUserLogadoStruct(
              (e) => e
                ..nome = _model.userLogado?.firstOrNull?.nome
                ..email = _model.userLogado?.firstOrNull?.email
                ..foto = _model.userLogado?.firstOrNull?.foto
                ..id = currentUserUid
                ..telefone = _model.userLogado?.firstOrNull?.telefone
                ..permissao = _model.userLogado?.firstOrNull?.permissao,
            );
            safeSetState(() {});
          }),
          Future(() async {
            await action_blocks.animaisRegistrados(context);
            await action_blocks.countLotesCadastrados(context);
            await action_blocks.animaisPropriedade(context);

            safeSetState(() {});
          }),
        ]);
        unawaited(
          () async {
            await action_blocks.animaisRegistrados(context);
          }(),
        );
        unawaited(
          () async {
            await action_blocks.animaisPropriedade(context);
          }(),
        );
        await action_blocks.countLotesCadastrados(context);
      } else {
        FFAppState().clearUserData();
        GoRouter.of(context).prepareAuthEvent();
        await authManager.signOut();
        GoRouter.of(context).clearRedirectLocation();

        navigate = () =>
            context.goNamedAuth(TelaInicioWidget.routeName, context.mounted);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Seu período de acesso grátis finalizou, assine um plano para continuar acessando.',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      }

      navigate();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        floatingActionButton: Visibility(
          visible: (FFAppState().navegacaoDashboard == 'propriedades') ||
              (FFAppState().navegacaoDashboard == 'rebanhos') ||
              (FFAppState().navegacaoDashboard == 'lotes') ||
              (FFAppState().navegacaoDashboard == 'reproducoes') ||
              (FFAppState().navegacaoDashboard == 'sanidade'),
          child: Builder(
            builder: (context) => Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
              child: FloatingActionButton(
                onPressed: () async {
                  if (FFAppState().navegacaoDashboard == 'propriedades') {
                    FFAppState().cidadeSelecionada = '';
                    safeSetState(() {});
                    await showDialog(
                      barrierColor: Colors.transparent,
                      barrierDismissible: false,
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: const AlignmentDirectional(0.0, 0.0)
                              .resolve(Directionality.of(context)),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(dialogContext).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: const AddPropriedadeWidget(),
                          ),
                        );
                      },
                    );
                  } else if (FFAppState().navegacaoDashboard == 'rebanhos') {
                    await showAlignedDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      isGlobal: false,
                      avoidOverflow: true,
                      targetAnchor: const AlignmentDirectional(1.0, -1.0)
                          .resolve(Directionality.of(context)),
                      followerAnchor: const AlignmentDirectional(1.0, 1.0)
                          .resolve(Directionality.of(context)),
                      builder: (dialogContext) {
                        return Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(dialogContext).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: const SubMenuRebanhoWidget(),
                          ),
                        );
                      },
                    );
                  } else if (FFAppState().navegacaoDashboard == 'lotes') {
                    await action_blocks.animaisPropriedade(context);
                    await showDialog(
                      barrierColor: Colors.transparent,
                      barrierDismissible: false,
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: const AlignmentDirectional(0.0, 0.0)
                              .resolve(Directionality.of(context)),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(dialogContext).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: const AddLoteWidget(),
                          ),
                        );
                      },
                    );
                    safeSetState(() {});
                  } else if (FFAppState().navegacaoDashboard == 'reproducoes') {
                    await showAlignedDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      isGlobal: false,
                      avoidOverflow: true,
                      targetAnchor: const AlignmentDirectional(1.0, -1.0)
                          .resolve(Directionality.of(context)),
                      followerAnchor: const AlignmentDirectional(1.0, 1.0)
                          .resolve(Directionality.of(context)),
                      builder: (dialogContext) {
                        return Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(dialogContext).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: const PopupReproducaoWidget(),
                          ),
                        );
                      },
                    );
                  } else if (FFAppState().navegacaoDashboard == 'sanidade') {
                    await showAlignedDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      isGlobal: false,
                      avoidOverflow: true,
                      targetAnchor: const AlignmentDirectional(1.0, -1.0)
                          .resolve(Directionality.of(context)),
                      followerAnchor: const AlignmentDirectional(1.0, 1.0)
                          .resolve(Directionality.of(context)),
                      builder: (dialogContext) {
                        return Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(dialogContext).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: const PopupSanidadeWidget(),
                          ),
                        );
                      },
                    );
                  }
                },
                backgroundColor: FlutterFlowTheme.of(context).primary,
                elevation: 8.0,
                child: Icon(
                  Icons.add_rounded,
                  color: FlutterFlowTheme.of(context).info,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          elevation: 16.0,
          child: wrapWithModel(
            model: _model.navegacaoModel,
            updateCallback: () => safeSetState(() {}),
            child: const NavegacaoWidget(),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                icon: Icon(
                                  Icons.menu,
                                  color:
                                      FlutterFlowTheme.of(context).customColor4,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                              Text(
                                () {
                                  if (FFAppState().navegacaoDashboard ==
                                      'propriedades') {
                                    return 'Propriedades';
                                  } else if (FFAppState().navegacaoDashboard ==
                                      'lotes') {
                                    return 'Lote';
                                  } else if (FFAppState().navegacaoDashboard ==
                                      'rebanhos') {
                                    return 'Rebanho';
                                  } else if (FFAppState().navegacaoDashboard ==
                                      'reproducoes') {
                                    return 'Reprodução';
                                  } else if (FFAppState().navegacaoDashboard ==
                                      'sanidade') {
                                    return 'Sanidade';
                                  } else if (FFAppState().navegacaoDashboard ==
                                      'piquetes') {
                                    return 'Piquete';
                                  } else if (FFAppState().navegacaoDashboard ==
                                      'pastagem') {
                                    return 'Pastagem';
                                  } else if (FFAppState().navegacaoDashboard ==
                                      'painel') {
                                    return 'Painel';
                                  } else if (FFAppState().navegacaoDashboard ==
                                      'minhaconta') {
                                    return 'Minha conta';
                                  } else {
                                    return 'Painel';
                                  }
                                }(),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .customColor4,
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
                        if (responsiveVisibility(
                          context: context,
                          phone: false,
                          tablet: false,
                          tabletLandscape: false,
                          desktop: false,
                        ))
                          Builder(
                            builder: (context) => FFButtonWidget(
                              onPressed: () async {
                                await showDialog(
                                  barrierColor: Colors.transparent,
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: const AlignmentDirectional(
                                              0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(dialogContext)
                                              .unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: const PesquisaGeralWidget(),
                                      ),
                                    );
                                  },
                                );
                              },
                              text: '',
                              icon: const Icon(
                                Icons.search,
                                size: 28.0,
                              ),
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                iconColor:
                                    FlutterFlowTheme.of(context).customColor4,
                                color: const Color(0x0028A365),
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
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).accent4,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Builder(
                    builder: (context) {
                      if (FFAppState().navegacaoDashboard == 'propriedades') {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: const BoxDecoration(),
                          child: wrapWithModel(
                            model: _model.pagePropriedadesModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const PagePropriedadesWidget(),
                          ),
                        );
                      } else if (FFAppState().navegacaoDashboard == 'painel') {
                        return Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            decoration: const BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                wrapWithModel(
                                  model: _model.selecionarPropriedadeModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: SelecionarPropriedadeWidget(
                                    onPropriedadeChanged: () async {
                                      await action_blocks
                                          .animaisPropriedade(context);
                                      await action_blocks
                                          .countLotesCadastrados(context);
                                      safeSetState(() {});
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 160.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF8F8F8),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 12.0, 12.0, 8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: SvgPicture.asset(
                                                  'assets/images/Lotes.svg',
                                                  width: 24.0,
                                                  height: 24.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Container(
                                                decoration:
                                                    const BoxDecoration(),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    FFAppState()
                                                        .lotesCadastrados
                                                        .toString(),
                                                    '0',
                                                  ),
                                                  maxLines: 1,
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            fontSize: 24.0,
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
                                              Text(
                                                'Lotes\ncadastrados',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          fontSize: 10.0,
                                                          letterSpacing: 0.0,
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
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 160.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF8F8F8),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 12.0, 12.0, 8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.asset(
                                                  'assets/images/Group_11_1.png',
                                                  width: 24.0,
                                                  height: 24.0,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Container(
                                                decoration:
                                                    const BoxDecoration(),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    FFAppState()
                                                        .qtdAnimaisPropriedade
                                                        .toString(),
                                                    '0',
                                                  ),
                                                  maxLines: 1,
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            fontSize: 24.0,
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
                                              Text(
                                                'Animais\ncadastrados',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          fontSize: 10.0,
                                                          letterSpacing: 0.0,
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
                                    ),
                                  ].divide(const SizedBox(width: 8.0)),
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
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .customColor5,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.insert_chart,
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            size: 48.0,
                                          ),
                                          Text(
                                            'Ver meus resultados',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ].divide(const SizedBox(width: 24.0)),
                                      ),
                                    ),
                                  ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: const NavegarBottomWidget(),
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  },
                                  text: 'Adicionar novo',
                                  icon: const Icon(
                                    Icons.add,
                                    size: 24.0,
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 48.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmallFamily,
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleSmallIsCustom,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 16.0, 0.0, 0.0),
                                  child: FutureBuilder<List<AnunciosRow>>(
                                    future: AnunciosTable().queryRows(
                                      queryFn: (q) => q,
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
                                      List<AnunciosRow>
                                          containerAnunciosRowList =
                                          snapshot.data!;

                                      return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                        child: Visibility(
                                          visible: ((containerAnunciosRowList
                                                      .isNotEmpty) &&
                                                  (_model.temNet == true)) &&
                                              responsiveVisibility(
                                                context: context,
                                                phone: false,
                                              ),
                                          child: Builder(
                                            builder: (context) {
                                              final varAnuncio =
                                                  containerAnunciosRowList
                                                      .toList();

                                              return SizedBox(
                                                width: double.infinity,
                                                height: 160.0,
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              24.0, 0.0, 0.0),
                                                      child: PageView.builder(
                                                        controller: _model
                                                                .pageViewController ??=
                                                            PageController(
                                                                initialPage: max(
                                                                    0,
                                                                    min(
                                                                        0,
                                                                        varAnuncio.length -
                                                                            1))),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            varAnuncio.length,
                                                        itemBuilder: (context,
                                                            varAnuncioIndex) {
                                                          final varAnuncioItem =
                                                              varAnuncio[
                                                                  varAnuncioIndex];
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  await launchURL(
                                                                      varAnuncioItem
                                                                          .link!);
                                                                },
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .network(
                                                                    varAnuncioItem
                                                                        .imagem!,
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        120.0,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, -1.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 16.0),
                                                        child: smooth_page_indicator
                                                            .SmoothPageIndicator(
                                                          controller: _model
                                                                  .pageViewController ??=
                                                              PageController(
                                                                  initialPage: max(
                                                                      0,
                                                                      min(
                                                                          0,
                                                                          varAnuncio.length -
                                                                              1))),
                                                          count:
                                                              varAnuncio.length,
                                                          axisDirection:
                                                              Axis.horizontal,
                                                          onDotClicked:
                                                              (i) async {
                                                            await _model
                                                                .pageViewController!
                                                                .animateToPage(
                                                              i,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              curve:
                                                                  Curves.ease,
                                                            );
                                                            safeSetState(() {});
                                                          },
                                                          effect:
                                                              smooth_page_indicator
                                                                  .SlideEffect(
                                                            spacing: 8.0,
                                                            radius: 8.0,
                                                            dotWidth: 8.0,
                                                            dotHeight: 8.0,
                                                            dotColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            activeDotColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            paintStyle:
                                                                PaintingStyle
                                                                    .stroke,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (responsiveVisibility(
                                  context: context,
                                  phone: false,
                                  tablet: false,
                                  tabletLandscape: false,
                                  desktop: false,
                                ))
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      FlutterFlowIconButton(
                                        borderRadius: 8.0,
                                        buttonSize: 40.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .primary,
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 24.0,
                                        ),
                                        onPressed: () {
                                          print('IconButton pressed ...');
                                        },
                                      ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          await SQLiteManager.instance
                                              .deletarTodosRebanhos();
                                        },
                                        text: 'delete',
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
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
                                      Text(
                                        valueOrDefault<String>(
                                          FFAppState()
                                              .rebanhosChangeDateTime
                                              ?.toString(),
                                          '...',
                                        ),
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
                                      FlutterFlowIconButton(
                                        borderRadius: 8.0,
                                        buttonSize: 40.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .primary,
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          FFAppState().visibleProgressBar =
                                              false;
                                          safeSetState(() {});
                                        },
                                      ),
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                if (responsiveVisibility(
                                  context: context,
                                  phone: false,
                                  tablet: false,
                                  tabletLandscape: false,
                                  desktop: false,
                                ))
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        valueOrDefault<String>(
                                          FFAppState()
                                              .indexRebPaginacao
                                              .toString(),
                                          '0',
                                        ),
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
                                      Text(
                                        valueOrDefault<String>(
                                          FFAppState()
                                              .indexCtrlRebanhos
                                              .toString(),
                                          '0',
                                        ),
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
                                    ].divide(const SizedBox(width: 8.0)),
                                  ),
                                if (responsiveVisibility(
                                  context: context,
                                  phone: false,
                                  tablet: false,
                                  tabletLandscape: false,
                                  desktop: false,
                                ))
                                  Text(
                                    valueOrDefault<String>(
                                      FFAppState().rebanhosIndex.toString(),
                                      '0',
                                    ),
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
                              ].divide(const SizedBox(height: 24.0)),
                            ),
                          ),
                        );
                      } else if (FFAppState().navegacaoDashboard ==
                          'rebanhos') {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: wrapWithModel(
                            model: _model.pageRebanhoModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const PageRebanhoWidget(),
                          ),
                        );
                      } else if (FFAppState().navegacaoDashboard == 'lotes') {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: wrapWithModel(
                            model: _model.pageLotesModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const PageLotesWidget(),
                          ),
                        );
                      } else if (FFAppState().navegacaoDashboard ==
                          'reproducoes') {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: wrapWithModel(
                            model: _model.pageReproducoesModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const PageReproducoesWidget(),
                          ),
                        );
                      } else if (FFAppState().navegacaoDashboard ==
                          'sanidade') {
                        return wrapWithModel(
                          model: _model.pageSanidadeModel,
                          updateCallback: () => safeSetState(() {}),
                          child: const PageSanidadeWidget(),
                        );
                      } else if (FFAppState().navegacaoDashboard ==
                          'minhaconta') {
                        return wrapWithModel(
                          model: _model.minhaContaModel,
                          updateCallback: () => safeSetState(() {}),
                          child: const MinhaContaWidget(),
                        );
                      } else {
                        return Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ].divide(const SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
