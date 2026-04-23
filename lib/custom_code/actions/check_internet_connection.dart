// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:async';

Future<bool> checkInternetConnection() async {
  try {
    // Primeiro verifica conectividade
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Depois testa conexão real com a internet
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 5));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}

/// A6 warm-up: valida que o Supabase está alcançável ANTES de iniciar o sync.
///
/// Ao reconectar (especialmente transição WiFi↔Mobile em iOS), o DNS resolve
/// antes das rotas para o Supabase estarem utilizáveis. Sem esta checagem, a
/// primeira request do sync fica presa por minutos sem timeout efetivo.
///
/// Faz uma chamada HEAD/GET leve em `${supabaseUrl}/rest/v1/` com timeout
/// curto. Retorna true apenas se o servidor respondeu em tempo hábil.
Future<bool> pingSupabase({Duration timeout = const Duration(seconds: 5)}) async {
  try {
    final url = Supabase.instance.client.rest.url;
    final uri = Uri.parse(url);
    final client = HttpClient()
      ..connectionTimeout = timeout
      ..idleTimeout = timeout;
    try {
      final req = await client.getUrl(uri).timeout(timeout);
      req.followRedirects = false;
      final resp = await req.close().timeout(timeout);
      // Qualquer resposta HTTP (inclusive 401/404) indica que o servidor está
      // alcançável; apenas erros de rede/timeout devem falhar o warm-up.
      await resp.drain<void>();
      return resp.statusCode > 0;
    } finally {
      client.close(force: true);
    }
  } catch (e) {
    return false;
  }
}

/// Retorna um stream de mudanças de conectividade.
Stream<List<ConnectivityResult>> watchConnectivity() {
  return Connectivity().onConnectivityChanged.map((event) => [event]);
}

/// Verifica se os resultados de conectividade indicam que há conexão.
bool hasConnection(List<ConnectivityResult> results) {
  return results.isNotEmpty && !results.contains(ConnectivityResult.none);
}

