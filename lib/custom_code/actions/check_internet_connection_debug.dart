// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

Future<bool> checkInternetConnectionDebug() async {
  try {
    var connectivityResult = await Connectivity().checkConnectivity();

    // Debug: vamos ver o que está retornando
    print('🔍 Connectivity Result: $connectivityResult');
    print('🔍 Platform: ${Platform.operatingSystem}');

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('❌ Erro na verificação: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
