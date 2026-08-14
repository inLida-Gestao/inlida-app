import 'dart:convert';

/// Interpreta o fluxo de bytes enviado pelo bastão de leitura (AWR250) e
/// extrai os códigos de brinco eletrônico (ISO 11784/11785).
///
/// O bastão envia cada leitura em ASCII terminada por CR e/ou LF. Como o BLE
/// entrega os dados em pacotes que podem quebrar no meio de uma linha, o parser
/// mantém um buffer do trecho incompleto entre as chamadas.
class BastaoTagParser {
  BastaoTagParser({this.maxBufferChars = 512});

  /// Limite do buffer de trecho incompleto. Evita crescimento indefinido caso
  /// o dispositivo envie um fluxo contínuo sem terminador de linha.
  final int maxBufferChars;

  static final RegExp _quebraDeLinha = RegExp(r'[\r\n]');
  static final RegExp _separadorDeCampo = RegExp(r'[,;\t|]');
  static final RegExp _naoDigito = RegExp(r'[^0-9]');

  String _pendente = '';

  /// Trecho ainda não terminado por CR/LF.
  String get pendente => _pendente;

  /// Processa um pacote recebido do dispositivo e devolve os códigos completos.
  List<String> processarPacote(List<int> bytes) {
    if (bytes.isEmpty) {
      return const [];
    }
    _pendente += latin1.decode(bytes, allowInvalid: true);
    if (_pendente.length > maxBufferChars) {
      _pendente = _pendente.substring(_pendente.length - maxBufferChars);
    }

    final partes = _pendente.split(_quebraDeLinha);
    _pendente = partes.removeLast();

    final codigos = <String>[];
    for (final parte in partes) {
      final codigo = normalizarLinha(parte);
      if (codigo != null) {
        codigos.add(codigo);
      }
    }
    return codigos;
  }

  /// Consome o trecho pendente como se fosse uma linha completa.
  ///
  /// Usado quando o dispositivo para de enviar dados sem mandar o terminador.
  String? descarregarPendente() {
    if (_pendente.isEmpty) {
      return null;
    }
    final resto = _pendente;
    _pendente = '';
    return normalizarLinha(resto);
  }

  void limpar() => _pendente = '';

  /// Extrai o código de uma linha recebida do bastão.
  ///
  /// Aceita variações como `982000123456789`, `982 000123456789`,
  /// `0982000123456789` (com o bit de animal) e linhas com campos extras
  /// separados por vírgula, ponto e vírgula, tabulação ou barra vertical.
  /// Retorna `null` quando a linha não contém um código válido.
  static String? normalizarLinha(String linha) {
    final texto = linha.trim();
    if (texto.isEmpty) {
      return null;
    }
    for (final campo in texto.split(_separadorDeCampo)) {
      final codigo = _extrairCampo(campo);
      if (codigo != null) {
        return codigo;
      }
    }
    return null;
  }

  static String? _extrairCampo(String campo) {
    final digitos = campo.replaceAll(_naoDigito, '');
    if (digitos.length == 16 && digitos.startsWith('0')) {
      return digitos.substring(1);
    }
    if (digitos.length == 15) {
      return digitos;
    }
    return null;
  }
}
