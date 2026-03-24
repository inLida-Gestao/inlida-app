// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

Future<bool> checkInternetConnection() async {
  try {
    // Primeiro verifica conectividade
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Depois testa conexão real com a internet
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
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
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
