import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bastao_tag_parser.dart';

/// Situação atual da conexão com o bastão de leitura.
enum BastaoStatus {
  /// O aparelho não possui hardware Bluetooth Low Energy.
  indisponivel,

  /// Bluetooth desligado no aparelho.
  desligado,

  /// Permissão de Bluetooth negada pelo usuário.
  semPermissao,

  desconectado,
  procurando,
  conectando,
  conectado,
}

/// Conexão BLE com o bastão de leitura de brincos eletrônicos (Allflex AWR250).
///
/// O bastão precisa estar configurado em modo BLE — no modo HID ele se comporta
/// como um teclado e o sistema operacional não permite que o app se conecte.
class BastaoReaderService {
  BastaoReaderService._();

  static final BastaoReaderService instance = BastaoReaderService._();

  /// Nordic UART Service, usado pelos bastões da linha Agrident/Allflex.
  static final Guid _nusService = Guid('6e400001-b5a3-f393-e0a9-e50e24dcca9e');
  static final Guid _nusTxCharacteristic =
      Guid('6e400003-b5a3-f393-e0a9-e50e24dcca9e');

  static const String _prefsRemoteId = 'ff_bastaoRemoteId';
  static const String _prefsNome = 'ff_bastaoNome';

  /// Palavras que identificam um bastão nos resultados da busca.
  static const List<String> palavrasChaveBastao = [
    'awr',
    'agrident',
    'allflex',
    'apr',
    'bastao',
    'bastão',
  ];

  static const Duration _timeoutBusca = Duration(seconds: 15);
  static const Duration _debounceLinhaIncompleta = Duration(milliseconds: 400);

  final ValueNotifier<BastaoStatus> status =
      ValueNotifier<BastaoStatus>(BastaoStatus.desconectado);
  final ValueNotifier<String?> erro = ValueNotifier<String?>(null);
  final ValueNotifier<String?> ultimaLeitura = ValueNotifier<String?>(null);

  final StreamController<String> _leiturasController =
      StreamController<String>.broadcast();
  final BastaoTagParser _parser = BastaoTagParser();

  final List<StreamSubscription<dynamic>> _assinaturasDispositivo = [];
  StreamSubscription<BluetoothAdapterState>? _assinaturaAdaptador;
  Timer? _timerLinhaIncompleta;

  BluetoothDevice? _dispositivo;
  String? _nomeDispositivo;
  bool _inicializado = false;

  /// Códigos lidos pelo bastão, já normalizados.
  Stream<String> get leituras => _leiturasController.stream;

  /// Resultados da busca por dispositivos BLE próximos.
  Stream<List<ScanResult>> get resultadosBusca => FlutterBluePlus.scanResults;

  BluetoothDevice? get dispositivo => _dispositivo;

  String? get nomeDispositivo => _nomeDispositivo;

  bool get conectado => status.value == BastaoStatus.conectado;

  /// `true` quando o nome do dispositivo indica se tratar de um bastão.
  static bool pareceBastao(String nome) {
    final alvo = nome.toLowerCase();
    return palavrasChaveBastao.any(alvo.contains);
  }

  /// Prepara o monitoramento do adaptador Bluetooth. Pode ser chamado várias
  /// vezes — só tem efeito na primeira.
  Future<void> inicializar() async {
    if (_inicializado) {
      return;
    }
    _inicializado = true;

    if (await FlutterBluePlus.isSupported == false) {
      status.value = BastaoStatus.indisponivel;
      return;
    }

    _assinaturaAdaptador =
        FlutterBluePlus.adapterState.listen(_aoMudarEstadoDoAdaptador);
  }

  void _aoMudarEstadoDoAdaptador(BluetoothAdapterState estado) {
    switch (estado) {
      case BluetoothAdapterState.on:
        if (status.value == BastaoStatus.desligado ||
            status.value == BastaoStatus.semPermissao) {
          status.value = BastaoStatus.desconectado;
        }
        break;
      case BluetoothAdapterState.off:
      case BluetoothAdapterState.turningOff:
        _limparConexao();
        status.value = BastaoStatus.desligado;
        break;
      case BluetoothAdapterState.unauthorized:
        _limparConexao();
        status.value = BastaoStatus.semPermissao;
        break;
      case BluetoothAdapterState.unavailable:
        _limparConexao();
        status.value = BastaoStatus.indisponivel;
        break;
      default:
        break;
    }
  }

  /// Liga o Bluetooth (somente Android — no iOS quem controla é o usuário).
  Future<void> ligarBluetooth() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    try {
      await FlutterBluePlus.turnOn();
    } catch (e) {
      erro.value = 'Não foi possível ligar o Bluetooth.';
      if (kDebugMode) {
        print('[bastao] turnOn falhou: $e');
      }
    }
  }

  /// Procura dispositivos BLE próximos por [_timeoutBusca].
  Future<void> iniciarBusca() async {
    await inicializar();
    if (status.value == BastaoStatus.indisponivel) {
      return;
    }
    erro.value = null;

    try {
      await _aguardarAdaptadorLigado();
      status.value = BastaoStatus.procurando;
      await FlutterBluePlus.startScan(timeout: _timeoutBusca);
      await FlutterBluePlus.isScanning.where((rodando) => !rodando).first;
    } catch (e) {
      erro.value = _mensagemDeErro(e);
      if (kDebugMode) {
        print('[bastao] busca falhou: $e');
      }
    } finally {
      if (status.value == BastaoStatus.procurando) {
        status.value = BastaoStatus.desconectado;
      }
    }
  }

  Future<void> pararBusca() async {
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }
    if (status.value == BastaoStatus.procurando) {
      status.value = BastaoStatus.desconectado;
    }
  }

  /// Conecta ao bastão e passa a escutar as leituras.
  Future<bool> conectar(
    BluetoothDevice alvo, {
    Duration timeout = const Duration(seconds: 35),
  }) async {
    await inicializar();
    erro.value = null;

    await pararBusca();
    await _limparConexao();

    status.value = BastaoStatus.conectando;
    _dispositivo = alvo;
    _nomeDispositivo = alvo.platformName.isNotEmpty
        ? alvo.platformName
        : (alvo.advName.isNotEmpty ? alvo.advName : alvo.remoteId.str);

    try {
      await _aguardarAdaptadorLigado();
      await alvo.connect(timeout: timeout);

      final assinaturaConexao = alvo.connectionState.listen((estado) {
        if (estado == BluetoothConnectionState.disconnected &&
            _dispositivo?.remoteId == alvo.remoteId) {
          status.value = BastaoStatus.desconectado;
        }
      });
      _assinaturasDispositivo.add(assinaturaConexao);
      alvo.cancelWhenDisconnected(assinaturaConexao, delayed: true, next: true);

      final assinou = await _assinarNotificacoes(alvo);
      if (!assinou) {
        erro.value = 'O dispositivo não expõe um canal de leitura. '
            'Verifique se o bastão está no modo BLE (e não HID).';
        await desconectar();
        return false;
      }

      status.value = BastaoStatus.conectado;
      await _salvarDispositivo(alvo, _nomeDispositivo);
      return true;
    } catch (e) {
      erro.value = _mensagemDeErro(e);
      if (kDebugMode) {
        print('[bastao] conexão falhou: $e');
      }
      await _limparConexao();
      status.value = BastaoStatus.desconectado;
      return false;
    }
  }

  /// Reconecta ao último bastão usado, se houver um salvo.
  ///
  /// Usa um tempo de espera curto porque roda em segundo plano, ao abrir as
  /// telas que têm campo de chip.
  Future<bool> reconectarUltimoBastao({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    if (conectado || status.value == BastaoStatus.conectando) {
      return conectado;
    }
    final prefs = await SharedPreferences.getInstance();
    final remoteId = prefs.getString(_prefsRemoteId);
    if (remoteId == null || remoteId.isEmpty) {
      return false;
    }
    try {
      return await conectar(
        BluetoothDevice.fromId(remoteId),
        timeout: timeout,
      );
    } catch (e) {
      // O identificador salvo pode ter sido gerado em outra plataforma.
      await esquecerDispositivo();
      if (kDebugMode) {
        print('[bastao] reconexão falhou: $e');
      }
      return false;
    }
  }

  /// Nome do último bastão pareado, para exibir na interface.
  Future<String?> nomeUltimoBastao() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsNome);
  }

  Future<void> desconectar() async {
    final alvo = _dispositivo;
    await _limparConexao();
    try {
      await alvo?.disconnect();
    } catch (e) {
      if (kDebugMode) {
        print('[bastao] desconexão falhou: $e');
      }
    }
    status.value = BastaoStatus.desconectado;
  }

  Future<void> esquecerDispositivo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsRemoteId);
    await prefs.remove(_prefsNome);
  }

  Future<bool> _assinarNotificacoes(BluetoothDevice alvo) async {
    final servicos = await alvo.discoverServices();

    final preferidas = <BluetoothCharacteristic>[];
    final alternativas = <BluetoothCharacteristic>[];

    for (final servico in servicos) {
      for (final caracteristica in servico.characteristics) {
        if (!caracteristica.properties.notify &&
            !caracteristica.properties.indicate) {
          continue;
        }
        if (servico.serviceUuid == _nusService &&
            caracteristica.characteristicUuid == _nusTxCharacteristic) {
          preferidas.add(caracteristica);
        } else {
          alternativas.add(caracteristica);
        }
      }
    }

    // Se o bastão expõe o Nordic UART Service, basta escutá-lo. Caso contrário
    // escutamos todas as características notificáveis e deixamos o parser
    // descartar o que não for um código de brinco.
    final escolhidas = preferidas.isNotEmpty ? preferidas : alternativas;
    if (escolhidas.isEmpty) {
      return false;
    }

    var assinouAlguma = false;
    for (final caracteristica in escolhidas) {
      try {
        final assinatura =
            caracteristica.onValueReceived.listen(_aoReceberPacote);
        _assinaturasDispositivo.add(assinatura);
        alvo.cancelWhenDisconnected(assinatura);
        await caracteristica.setNotifyValue(true);
        assinouAlguma = true;
      } catch (e) {
        if (kDebugMode) {
          print('[bastao] não foi possível assinar '
              '${caracteristica.characteristicUuid}: $e');
        }
      }
    }
    return assinouAlguma;
  }

  void _aoReceberPacote(List<int> bytes) {
    for (final codigo in _parser.processarPacote(bytes)) {
      _emitirLeitura(codigo);
    }

    // Alguns firmwares não enviam o terminador de linha. Se o fluxo parar com
    // conteúdo pendente, tratamos o que sobrou como uma leitura completa.
    _timerLinhaIncompleta?.cancel();
    if (_parser.pendente.isNotEmpty) {
      _timerLinhaIncompleta = Timer(_debounceLinhaIncompleta, () {
        final codigo = _parser.descarregarPendente();
        if (codigo != null) {
          _emitirLeitura(codigo);
        }
      });
    }
  }

  void _emitirLeitura(String codigo) {
    ultimaLeitura.value = codigo;
    if (!_leiturasController.isClosed) {
      _leiturasController.add(codigo);
    }
  }

  Future<void> _aguardarAdaptadorLigado() async {
    if (FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on) {
      return;
    }
    await FlutterBluePlus.adapterState
        .where((estado) => estado == BluetoothAdapterState.on)
        .first
        .timeout(const Duration(seconds: 10));
  }

  Future<void> _salvarDispositivo(BluetoothDevice alvo, String? nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsRemoteId, alvo.remoteId.str);
    await prefs.setString(_prefsNome, nome ?? alvo.remoteId.str);
  }

  Future<void> _limparConexao() async {
    _timerLinhaIncompleta?.cancel();
    _timerLinhaIncompleta = null;
    _parser.limpar();
    for (final assinatura in _assinaturasDispositivo) {
      await assinatura.cancel();
    }
    _assinaturasDispositivo.clear();
  }

  String _mensagemDeErro(Object e) {
    final texto = e.toString().toLowerCase();
    if (texto.contains('permission')) {
      return 'Permissão de Bluetooth negada. Autorize o inLida nas '
          'configurações do aparelho.';
    }
    if (texto.contains('location')) {
      return 'Ative a localização do aparelho para procurar dispositivos '
          'Bluetooth.';
    }
    if (texto.contains('timeout') || texto.contains('timed out')) {
      return 'Não foi possível falar com o bastão. Verifique se ele está '
          'ligado e por perto.';
    }
    return 'Falha na comunicação Bluetooth. Tente novamente.';
  }

  @visibleForTesting
  Future<void> encerrar() async {
    await _limparConexao();
    await _assinaturaAdaptador?.cancel();
    _assinaturaAdaptador = null;
    _inicializado = false;
  }
}
