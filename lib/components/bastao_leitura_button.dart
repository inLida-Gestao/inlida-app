import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/backend/bluetooth/bastao_reader_service.dart';
import '/components/bastao_conectar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Botão que conecta ao bastão de leitura e preenche um campo de texto com o
/// código do brinco lido.
///
/// Enquanto o botão estiver na tela e o bastão conectado, cada leitura é
/// escrita automaticamente em [controller]. Tocar no botão abre o painel de
/// conexão.
class BastaoLeituraButton extends StatefulWidget {
  const BastaoLeituraButton({
    super.key,
    required this.controller,
    this.aoLer,
    this.reconectarAutomaticamente = true,
  });

  /// Campo que recebe o código lido.
  final TextEditingController controller;

  /// Chamado depois de escrever o código no campo.
  final void Function(String codigo)? aoLer;

  /// Tenta religar ao último bastão usado assim que a tela abre.
  final bool reconectarAutomaticamente;

  @override
  State<BastaoLeituraButton> createState() => _BastaoLeituraButtonState();
}

class _BastaoLeituraButtonState extends State<BastaoLeituraButton> {
  final BastaoReaderService _bastao = BastaoReaderService.instance;
  StreamSubscription<String>? _assinatura;

  @override
  void initState() {
    super.initState();
    _bastao.inicializar();
    _assinatura = _bastao.leituras.listen(_aoLerCodigo);
    if (widget.reconectarAutomaticamente) {
      _bastao.reconectarUltimoBastao();
    }
  }

  @override
  void dispose() {
    _assinatura?.cancel();
    super.dispose();
  }

  void _aoLerCodigo(String codigo) {
    if (!mounted) {
      return;
    }
    widget.controller.value = TextEditingValue(
      text: codigo,
      selection: TextSelection.collapsed(offset: codigo.length),
    );
    HapticFeedback.mediumImpact();
    widget.aoLer?.call(codigo);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Chip lido: $codigo'),
          duration: const Duration(seconds: 2),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return ValueListenableBuilder<BastaoStatus>(
      valueListenable: _bastao.status,
      builder: (context, status, _) {
        final conectado = status == BastaoStatus.conectado;
        final ocupado = status == BastaoStatus.conectando ||
            status == BastaoStatus.procurando;

        return IconButton(
          tooltip: conectado
              ? 'Bastão conectado — aponte para o brinco'
              : 'Conectar bastão de leitura',
          onPressed: () => BastaoConectarWidget.abrir(context),
          icon: ocupado
              ? SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: theme.primary,
                  ),
                )
              : Icon(
                  conectado ? Icons.sensors : Icons.sensors_off,
                  color: conectado ? theme.primary : theme.secondaryText,
                  size: 24.0,
                ),
        );
      },
    );
  }
}
