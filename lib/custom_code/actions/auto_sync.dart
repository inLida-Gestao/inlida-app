// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/auth/supabase_auth/auth_util.dart';

/// Intervalo mínimo entre auto-syncs (60 segundos).
const _minAutoSyncInterval = Duration(seconds: 60);

/// Executa auto-sync quando o usuário reconecta à internet.
/// Faz PUSH dos módulos com dados pendentes e PULL dos que estão limpos.
/// Respeita debounce e intervalo mínimo entre syncs.
Future<void> performAutoSync(BuildContext context) async {
  final appState = FFAppState();

  // Evitar sync duplo
  if (appState.isSyncing) {
    debugPrint('[SYNC][auto] Sync já em andamento. Ignorando auto-sync.');
    return;
  }

  // Verificar intervalo mínimo
  final lastSync = appState.lastAutoSync;
  if (lastSync != null &&
      DateTime.now().difference(lastSync) < _minAutoSyncInterval) {
    debugPrint('[SYNC][auto] Intervalo mínimo não atingido. Ignorando.');
    return;
  }

  // Verificar se há algo para sincronizar
  final hasPendingProp = appState.dataDadosNaoSyncProp != null;
  final hasPendingRebanho = appState.dataDadosNaoSyncRebanho != null;
  final hasPendingLotes = appState.dataDadosNaoSyncLotes != null;
  final hasPendingRepro = appState.dataDadosNaoSyncRepro != null;
  final hasPendingSanidade = appState.dataDadosNaoSyncSanidade != null;
  final hasPending = hasPendingProp ||
      hasPendingRebanho ||
      hasPendingLotes ||
      hasPendingRepro ||
      hasPendingSanidade;

  if (!hasPending) {
    debugPrint('[SYNC][auto] Nenhum dado pendente para auto-sync.');
    return;
  }

  debugPrint('[SYNC][auto] Iniciando auto-sync...');
  appState.isSyncing = true;
  appState.lastAutoSync = DateTime.now();

  try {
    // PUSH fase: enviar dados pendentes
    var propOk = true;
    var rebanhoOk = true;
    var lotesOk = true;
    var reproOk = true;
    var sanidadeOk = true;

    if (hasPendingProp) {
      debugPrint('[SYNC][auto] PUSH propriedades...');
      propOk = await action_blocks.putUpdtPropriedades(context);
    }

    // PUSH paralelo
    final futures = <Future<bool>>[];
    if (hasPendingRebanho) {
      futures.add(action_blocks.putUpdtRebanhos(context));
    }
    if (hasPendingLotes) {
      futures.add(action_blocks.putUpdtLotes(context));
    }
    if (hasPendingRepro) {
      futures.add(action_blocks.putUpdtReproducao(context));
    }
    if (futures.isNotEmpty) {
      final results = await Future.wait(futures);
      int i = 0;
      if (hasPendingRebanho) rebanhoOk = results[i++];
      if (hasPendingLotes) lotesOk = results[i++];
      if (hasPendingRepro) reproOk = results[i++];
    }

    if (hasPendingSanidade) {
      debugPrint('[SYNC][auto] PUSH sanidade...');
      sanidadeOk = await action_blocks.putUpdtSanidades(context);
    }

    // Limpar flags dos módulos que foram enviados com sucesso
    if (propOk && hasPendingProp) appState.dataDadosNaoSyncProp = null;
    if (rebanhoOk && hasPendingRebanho) {
      appState.dataDadosNaoSyncRebanho = null;
    }
    if (lotesOk && hasPendingLotes) appState.dataDadosNaoSyncLotes = null;
    if (reproOk && hasPendingRepro) appState.dataDadosNaoSyncRepro = null;
    if (sanidadeOk && hasPendingSanidade) {
      appState.dataDadosNaoSyncSanidade = null;
    }

    // PULL fase: baixar dados remotos APENAS para módulos cujo PUSH funcionou
    final pullFutures = <Future>[];
    if (propOk || !hasPendingProp) {
      pullFutures.add(action_blocks.refreshPropriedades(context));
    }
    if (lotesOk || !hasPendingLotes) {
      pullFutures.add(action_blocks.refreshLotes(context));
    }
    if (rebanhoOk || !hasPendingRebanho) {
      pullFutures.add(action_blocks.refreshRebanhoOtimizada(context));
    }
    if (reproOk || !hasPendingRepro) {
      pullFutures.add(action_blocks.refreshReproducaoOtimizada(context));
    }
    if (sanidadeOk || !hasPendingSanidade) {
      pullFutures.add(action_blocks.refresSanidadeOtimizada(context));
    }

    if (pullFutures.isNotEmpty) {
      await Future.wait(pullFutures).catchError((e) {
        debugPrint('[SYNC][auto] Erro no PULL: $e');
        return <void>[];
      });
    }

    // Pesagens separado
    try {
      await action_blocks.refreshPesagens(context);
    } catch (e) {
      debugPrint('[SYNC][auto] Erro refreshPesagens: $e');
    }

    appState.ultimaSincronizacao = getCurrentTimestamp;
    debugPrint('[SYNC][auto] Auto-sync concluída com sucesso.');
  } catch (e, s) {
    debugPrint('[SYNC][auto] ERRO na auto-sync: $e\n$s');
  } finally {
    appState.isSyncing = false;
  }
}
