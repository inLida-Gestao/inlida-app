import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/app_state.dart';
import '/backend/bluetooth/bastao_reader_service.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/bastao_conectar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Uma leitura feita com o bastão e o animal correspondente, quando existe.
class _LeituraBastao {
  _LeituraBastao(this.chip);

  final String chip;
  Map<String, Object?>? animal;
  bool resolvendo = true;

  bool get encontrado => animal != null;
}

/// Leitura em sequência de vários brincos com o bastão.
///
/// Serve para conferir animais no curral: cada brinco lido é comparado com o
/// rebanho local da propriedade selecionada, mostrando quem já está cadastrado
/// e quem não está.
class LeituraLoteBastaoWidget extends StatefulWidget {
  const LeituraLoteBastaoWidget({super.key});

  static Future<void> abrir(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: const LeituraLoteBastaoWidget(),
      ),
    );
  }

  @override
  State<LeituraLoteBastaoWidget> createState() =>
      _LeituraLoteBastaoWidgetState();
}

class _LeituraLoteBastaoWidgetState extends State<LeituraLoteBastaoWidget> {
  final BastaoReaderService _bastao = BastaoReaderService.instance;
  final List<_LeituraBastao> _leituras = [];

  StreamSubscription<String>? _assinatura;

  @override
  void initState() {
    super.initState();
    _bastao.inicializar();
    _assinatura = _bastao.leituras.listen(_registrarLeitura);
  }

  @override
  void dispose() {
    _assinatura?.cancel();
    super.dispose();
  }

  Future<void> _registrarLeitura(String chip) async {
    if (!mounted) {
      return;
    }
    if (_leituras.any((leitura) => leitura.chip == chip)) {
      HapticFeedback.lightImpact();
      _avisar('Brinco $chip já foi lido.');
      return;
    }

    final leitura = _LeituraBastao(chip);
    setState(() => _leituras.insert(0, leitura));
    HapticFeedback.mediumImpact();

    final animal = await SQLiteManager.instance.buscarRebanhoPorChip(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
      chip: chip,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      leitura.animal = animal;
      leitura.resolvendo = false;
    });
  }

  void _avisar(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensagem), duration: const Duration(seconds: 2)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final encontrados = _leituras.where((l) => l.encontrado).length;
    final naoCadastrados =
        _leituras.where((l) => !l.resolvendo && !l.encontrado).length;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.9,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Leitura em lote',
                      style: theme.headlineSmall.override(
                        fontFamily: theme.headlineSmallFamily,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: !theme.headlineSmallIsCustom,
                      ),
                    ),
                  ),
                  if (_leituras.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(_leituras.clear),
                      child: Text(
                        'Limpar',
                        style: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.error,
                          useGoogleFonts: !theme.bodySmallIsCustom,
                        ),
                      ),
                    ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: theme.primary, size: 24.0),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              _resumo(theme, encontrados, naoCadastrados),
              const SizedBox(height: 12.0),
              _avisoConexao(theme),
              Expanded(child: _lista(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resumo(
    FlutterFlowTheme theme,
    int encontrados,
    int naoCadastrados,
  ) {
    return Text(
      '${_leituras.length} lidos • $encontrados no rebanho • '
      '$naoCadastrados não cadastrados',
      style: theme.bodySmall.override(
        fontFamily: theme.bodySmallFamily,
        color: theme.secondaryText,
        useGoogleFonts: !theme.bodySmallIsCustom,
      ),
    );
  }

  Widget _avisoConexao(FlutterFlowTheme theme) {
    return ValueListenableBuilder<BastaoStatus>(
      valueListenable: _bastao.status,
      builder: (context, status, _) {
        if (status == BastaoStatus.conectado) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Icon(Icons.bluetooth_disabled,
                    color: theme.warning, size: 24.0),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    'Bastão desconectado.',
                    style: theme.bodySmall.override(
                      fontFamily: theme.bodySmallFamily,
                      useGoogleFonts: !theme.bodySmallIsCustom,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => BastaoConectarWidget.abrir(context),
                  child: Text(
                    'Conectar',
                    style: theme.bodySmall.override(
                      fontFamily: theme.bodySmallFamily,
                      color: theme.primary,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: !theme.bodySmallIsCustom,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _lista(FlutterFlowTheme theme) {
    if (_leituras.isEmpty) {
      return Center(
        child: Text(
          'Aponte o bastão para os brincos.\nAs leituras aparecem aqui.',
          textAlign: TextAlign.center,
          style: theme.bodyMedium.override(
            fontFamily: theme.bodyMediumFamily,
            color: theme.secondaryText,
            useGoogleFonts: !theme.bodyMediumIsCustom,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _leituras.length,
      separatorBuilder: (_, __) => Divider(height: 1.0, color: theme.alternate),
      itemBuilder: (context, index) {
        final leitura = _leituras[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: _icone(theme, leitura),
          title: Text(
            leitura.chip,
            style: theme.bodyMedium.override(
              fontFamily: theme.bodyMediumFamily,
              fontWeight: FontWeight.w600,
              useGoogleFonts: !theme.bodyMediumIsCustom,
            ),
          ),
          subtitle: Text(
            _descricao(leitura),
            style: theme.bodySmall.override(
              fontFamily: theme.bodySmallFamily,
              color: leitura.resolvendo || leitura.encontrado
                  ? theme.secondaryText
                  : theme.error,
              useGoogleFonts: !theme.bodySmallIsCustom,
            ),
          ),
          trailing: IconButton(
            tooltip: 'Remover leitura',
            icon: Icon(Icons.delete_outline, color: theme.secondaryText),
            onPressed: () => setState(() => _leituras.remove(leitura)),
          ),
        );
      },
    );
  }

  Widget _icone(FlutterFlowTheme theme, _LeituraBastao leitura) {
    if (leitura.resolvendo) {
      return SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: theme.primary,
        ),
      );
    }
    return Icon(
      leitura.encontrado ? Icons.check_circle : Icons.help_outline,
      color: leitura.encontrado ? theme.primary : theme.error,
      size: 24.0,
    );
  }

  String _descricao(_LeituraBastao leitura) {
    if (leitura.resolvendo) {
      return 'Consultando o rebanho...';
    }
    final animal = leitura.animal;
    if (animal == null) {
      return 'Não cadastrado nesta propriedade';
    }
    final partes = <String>[
      if ((animal['numeroAnimal'] as String?)?.isNotEmpty ?? false)
        'Nº ${animal['numeroAnimal']}',
      if ((animal['nome'] as String?)?.isNotEmpty ?? false)
        animal['nome'] as String,
      if ((animal['loteNome'] as String?)?.isNotEmpty ?? false)
        'Lote ${animal['loteNome']}',
    ];
    return partes.isEmpty ? 'Animal cadastrado' : partes.join(' • ');
  }
}
