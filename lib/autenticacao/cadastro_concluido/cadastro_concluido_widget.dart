import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';

class CadastroConcluidoWidget extends StatelessWidget {
  const CadastroConcluidoWidget({super.key});

  static String routeName = 'CadastroConcluido';
  static String routePath = '/cadastroConcluido';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              // Fundo com image e blur – mesma estética da TelaInicio
              ClipRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0x5014181B),
                    ),
                  ),
                ),
              ),
              // Conteúdo
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/97dce0f07389cc398f28f16e7ec6bfcc333e86ba.png',
                        width: 82.0,
                        height: 66.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    // Ícone de sucesso
                    Center(
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 44.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    // Título
                    Center(
                      child: Text(
                        'Obrigado pelo seu cadastro!',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              fontSize: 26.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Mensagem
                    Center(
                      child: Text(
                        'Em breve nossa equipe comercial entrará em contato com você para formalizar a proposta, dar andamento à assinatura do contrato e ao início do projeto.\n\nAguarde — será um prazer ter você na inLida!',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground
                                  .withOpacity(0.85),
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                    const Spacer(),
                    // Botão
                    FFButtonWidget(
                      onPressed: () {
                        context.goNamed(TelaInicioWidget.routeName);
                      },
                      text: 'Voltar ao início',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 47.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding: EdgeInsets.zero,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .titleSmallFamily,
                              color: Colors.white,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleSmallIsCustom,
                            ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
