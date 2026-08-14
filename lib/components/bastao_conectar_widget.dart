import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '/backend/bluetooth/bastao_reader_service.dart';
import '/components/saiba_mais_b_t_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/rebanho/leitura_lote_bastao/leitura_lote_bastao_widget.dart';

/// Painel de conexão com o bastão de leitura de brincos eletrônicos.
///
/// Uso:
/// ```dart
/// await BastaoConectarWidget.abrir(context);
/// ```
class BastaoConectarWidget extends StatefulWidget {
  const BastaoConectarWidget({super.key});

  /// Abre o painel como bottom sheet e devolve `true` se saiu conectado.
  static Future<bool> abrir(BuildContext context) async {
    final resultado = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: const BastaoConectarWidget(),
      ),
    );
    return resultado ?? BastaoReaderService.instance.conectado;
  }

  @override
  State<BastaoConectarWidget> createState() => _BastaoConectarWidgetState();
}

class _BastaoConectarWidgetState extends State<BastaoConectarWidget> {
  final BastaoReaderService _bastao = BastaoReaderService.instance;

  String? _ultimoBastaoSalvo;

  @override
  void initState() {
    super.initState();
    _bastao.inicializar();
    _bastao.nomeUltimoBastao().then((nome) {
      if (mounted) {
        setState(() => _ultimoBastaoSalvo = nome);
      }
    });
  }

  @override
  void dispose() {
    _bastao.pararBusca();
    super.dispose();
  }

  Future<void> _conectar(BluetoothDevice dispositivo) async {
    final conectou = await _bastao.conectar(dispositivo);
    if (conectou && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cabecalho(theme),
              const SizedBox(height: 16.0),
              ValueListenableBuilder<BastaoStatus>(
                valueListenable: _bastao.status,
                builder: (context, status, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _painelStatus(theme, status),
                    const SizedBox(height: 16.0),
                    _acoes(theme, status),
                    if (status == BastaoStatus.conectado) ...[
                      const SizedBox(height: 16.0),
                      _ultimaLeitura(theme),
                      const SizedBox(height: 12.0),
                      SizedBox(
                        width: double.infinity,
                        child: _botao(
                          theme,
                          rotulo: 'Ler vários brincos',
                          destaque: false,
                          onTap: () => LeituraLoteBastaoWidget.abrir(context),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 8.0),
                      Flexible(child: _listaDispositivos(theme, status)),
                    ],
                  ],
                ),
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _bastao.erro,
                builder: (context, erro, _) => erro == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          erro,
                          style: theme.bodySmall.override(
                            fontFamily: theme.bodySmallFamily,
                            color: theme.error,
                            useGoogleFonts: !theme.bodySmallIsCustom,
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

  Widget _cabecalho(FlutterFlowTheme theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Bastão de leitura',
            style: theme.headlineSmall.override(
              fontFamily: theme.headlineSmallFamily,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              useGoogleFonts: !theme.headlineSmallIsCustom,
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
    );
  }

  Widget _painelStatus(FlutterFlowTheme theme, BastaoStatus status) {
    final (icone, cor, titulo, descricao) = switch (status) {
      BastaoStatus.indisponivel => (
          Icons.bluetooth_disabled,
          theme.error,
          'Bluetooth indisponível',
          'Este aparelho não tem suporte a Bluetooth Low Energy.',
        ),
      BastaoStatus.desligado => (
          Icons.bluetooth_disabled,
          theme.warning,
          'Bluetooth desligado',
          'Ligue o Bluetooth para procurar o bastão.',
        ),
      BastaoStatus.semPermissao => (
          Icons.lock_outline,
          theme.warning,
          'Permissão negada',
          'Autorize o inLida a usar o Bluetooth nas configurações do aparelho.',
        ),
      BastaoStatus.procurando => (
          Icons.bluetooth_searching,
          theme.primary,
          'Procurando dispositivos...',
          'Mantenha o bastão ligado e por perto.',
        ),
      BastaoStatus.conectando => (
          Icons.bluetooth_searching,
          theme.primary,
          'Conectando...',
          'Aguarde o pareamento com o bastão.',
        ),
      BastaoStatus.conectado => (
          Icons.bluetooth_connected,
          theme.primary,
          _bastao.nomeDispositivo ?? 'Bastão conectado',
          'Aponte o bastão para o brinco e faça a leitura.',
        ),
      BastaoStatus.desconectado => (
          Icons.bluetooth,
          theme.secondaryText,
          'Nenhum bastão conectado',
          _ultimoBastaoSalvo != null
              ? 'Último bastão usado: $_ultimoBastaoSalvo'
              : 'Procure o bastão para conectar.',
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icone, color: cor, size: 28.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: theme.bodyMedium.override(
                    fontFamily: theme.bodyMediumFamily,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: !theme.bodyMediumIsCustom,
                  ),
                ),
                Text(
                  descricao,
                  style: theme.bodySmall.override(
                    fontFamily: theme.bodySmallFamily,
                    color: theme.secondaryText,
                    useGoogleFonts: !theme.bodySmallIsCustom,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _acoes(FlutterFlowTheme theme, BastaoStatus status) {
    if (status == BastaoStatus.indisponivel) {
      return _linkSaibaMais(theme);
    }

    final Widget botaoPrincipal;
    if (status == BastaoStatus.desligado) {
      botaoPrincipal = _botao(
        theme,
        rotulo: 'Ligar Bluetooth',
        onTap: _bastao.ligarBluetooth,
      );
    } else if (status == BastaoStatus.conectado) {
      botaoPrincipal = _botao(
        theme,
        rotulo: 'Desconectar',
        destaque: false,
        onTap: () async {
          await _bastao.desconectar();
          await _bastao.esquecerDispositivo();
          if (mounted) {
            setState(() => _ultimoBastaoSalvo = null);
          }
        },
      );
    } else if (status == BastaoStatus.procurando) {
      botaoPrincipal = _botao(
        theme,
        rotulo: 'Parar busca',
        destaque: false,
        onTap: _bastao.pararBusca,
      );
    } else {
      botaoPrincipal = _botao(
        theme,
        rotulo: 'Procurar bastão',
        onTap: _bastao.iniciarBusca,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: double.infinity, child: botaoPrincipal),
        const SizedBox(height: 12.0),
        _linkSaibaMais(theme),
      ],
    );
  }

  Widget _linkSaibaMais(FlutterFlowTheme theme) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        context: context,
        builder: (context) => Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const SaibaMaisBTWidget(),
        ),
      ),
      child: Text(
        'Como configurar o bastão',
        style: theme.bodySmall.override(
          fontFamily: theme.bodySmallFamily,
          color: theme.primary,
          fontWeight: FontWeight.w600,
          useGoogleFonts: !theme.bodySmallIsCustom,
        ),
      ),
    );
  }

  Widget _botao(
    FlutterFlowTheme theme, {
    required String rotulo,
    required Future<void> Function() onTap,
    bool destaque = true,
  }) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: destaque ? theme.primary : theme.primaryBackground,
        foregroundColor: destaque ? Colors.white : theme.primaryText,
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        rotulo,
        style: theme.bodyMedium.override(
          fontFamily: theme.bodyMediumFamily,
          color: destaque ? Colors.white : theme.primaryText,
          fontWeight: FontWeight.w600,
          useGoogleFonts: !theme.bodyMediumIsCustom,
        ),
      ),
    );
  }

  Widget _ultimaLeitura(FlutterFlowTheme theme) {
    return ValueListenableBuilder<String?>(
      valueListenable: _bastao.ultimaLeitura,
      builder: (context, leitura, _) => Text(
        leitura == null ? 'Nenhuma leitura ainda.' : 'Última leitura: $leitura',
        style: theme.bodySmall.override(
          fontFamily: theme.bodySmallFamily,
          color: theme.secondaryText,
          useGoogleFonts: !theme.bodySmallIsCustom,
        ),
      ),
    );
  }

  Widget _listaDispositivos(FlutterFlowTheme theme, BastaoStatus status) {
    return StreamBuilder<List<ScanResult>>(
      stream: _bastao.resultadosBusca,
      initialData: const [],
      builder: (context, snapshot) {
        final encontrados = _ordenar(snapshot.data ?? const []);
        if (encontrados.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              status == BastaoStatus.procurando
                  ? 'Procurando...'
                  : 'Nenhum dispositivo encontrado.',
              style: theme.bodySmall.override(
                fontFamily: theme.bodySmallFamily,
                color: theme.secondaryText,
                useGoogleFonts: !theme.bodySmallIsCustom,
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: encontrados.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1.0, color: theme.alternate),
          itemBuilder: (context, index) {
            final resultado = encontrados[index];
            final nome = _nomeDe(resultado);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                BastaoReaderService.pareceBastao(nome)
                    ? Icons.sensors
                    : Icons.bluetooth,
                color: BastaoReaderService.pareceBastao(nome)
                    ? theme.primary
                    : theme.secondaryText,
              ),
              title: Text(
                nome,
                style: theme.bodyMedium.override(
                  fontFamily: theme.bodyMediumFamily,
                  useGoogleFonts: !theme.bodyMediumIsCustom,
                ),
              ),
              subtitle: Text(
                resultado.device.remoteId.str,
                style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.secondaryText,
                  useGoogleFonts: !theme.bodySmallIsCustom,
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: theme.secondaryText),
              onTap: () => _conectar(resultado.device),
            );
          },
        );
      },
    );
  }

  static String _nomeDe(ScanResult resultado) {
    if (resultado.device.platformName.isNotEmpty) {
      return resultado.device.platformName;
    }
    if (resultado.advertisementData.advName.isNotEmpty) {
      return resultado.advertisementData.advName;
    }
    return 'Dispositivo sem nome';
  }

  /// Mostra apenas dispositivos identificáveis, com os prováveis bastões no topo.
  static List<ScanResult> _ordenar(List<ScanResult> resultados) {
    final comNome = resultados
        .where((r) =>
            r.device.platformName.isNotEmpty ||
            r.advertisementData.advName.isNotEmpty)
        .toList();
    comNome.sort((a, b) {
      final aBastao = BastaoReaderService.pareceBastao(_nomeDe(a));
      final bBastao = BastaoReaderService.pareceBastao(_nomeDe(b));
      if (aBastao != bBastao) {
        return aBastao ? -1 : 1;
      }
      return b.rssi.compareTo(a.rssi);
    });
    return comNome;
  }
}

/// Ícone de acesso rápido ao painel de conexão do bastão.
///
/// Fica verde quando o bastão está conectado e cinza quando não está.
class BastaoConectarIconButton extends StatefulWidget {
  const BastaoConectarIconButton({
    super.key,
    this.size = 28.0,
    this.corDesconectado,
  });

  final double size;

  /// Cor do ícone quando não há bastão conectado. Por padrão usa o texto
  /// secundário do tema.
  final Color? corDesconectado;

  @override
  State<BastaoConectarIconButton> createState() =>
      _BastaoConectarIconButtonState();
}

class _BastaoConectarIconButtonState extends State<BastaoConectarIconButton> {
  @override
  void initState() {
    super.initState();
    BastaoReaderService.instance.inicializar();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return ValueListenableBuilder<BastaoStatus>(
      valueListenable: BastaoReaderService.instance.status,
      builder: (context, status, _) {
        final conectado = status == BastaoStatus.conectado;
        return IconButton(
          tooltip:
              conectado ? 'Bastão conectado' : 'Conectar bastão de leitura',
          onPressed: () => BastaoConectarWidget.abrir(context),
          icon: Icon(
            conectado ? Icons.sensors : Icons.sensors_off,
            size: widget.size,
            color: conectado
                ? theme.primary
                : (widget.corDesconectado ?? theme.secondaryText),
          ),
        );
      },
    );
  }
}
