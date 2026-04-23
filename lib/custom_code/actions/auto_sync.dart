// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

/// Intervalo mínimo entre auto-syncs (60 segundos).
const _minAutoSyncInterval = Duration(seconds: 60);

/// Tempo máximo de PUSH por módulo antes de abortar (watchdog individual).
const _pushModuleTimeout = Duration(seconds: 90);

/// Tempo máximo de PULL por módulo antes de abortar.
const _pullModuleTimeout = Duration(seconds: 120);

/// Tempo máximo TOTAL de uma sessão de auto-sync (watchdog global).
/// Se ultrapassar, o sync é abortado e o usuário pode tentar de novo.
const _autoSyncTotalBudget = Duration(minutes: 3);

/// Executa [future] com timeout; em caso de estouro loga e retorna [fallback].
Future<T> _guardModule<T>(
  Future<T> Function() future,
  String label,
  Duration timeout,
  T fallback,
) async {
  try {
    return await future().timeout(timeout, onTimeout: () {
      debugPrint(
          '[SYNC][auto][watchdog] $label estourou após ${timeout.inSeconds}s — abortando módulo.');
      throw TimeoutException('$label timeout');
    });
  } on TimeoutException {
    return fallback;
  } catch (e, s) {
    debugPrint('[SYNC][auto][watchdog] $label falhou: $e\n$s');
    return fallback;
  }
}

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

  // Watchdog global: garante que o flag isSyncing sempre é liberado.
  final globalStopwatch = Stopwatch()..start();
  Timer? watchdogTimer;
  watchdogTimer = Timer(_autoSyncTotalBudget, () {
    debugPrint(
        '[SYNC][auto][watchdog] Tempo total de ${_autoSyncTotalBudget.inSeconds}s excedido. Liberando flag isSyncing.');
    appState.isSyncing = false;
  });

  try {
    // PUSH fase: enviar dados pendentes (cada módulo com watchdog individual)
    var propOk = true;
    var rebanhoOk = true;
    var lotesOk = true;
    var reproOk = true;
    var sanidadeOk = true;

    if (hasPendingProp) {
      debugPrint('[SYNC][auto] PUSH propriedades...');
      propOk = await _guardModule(
        () => action_blocks.putUpdtPropriedades(context),
        'PUSH propriedades',
        _pushModuleTimeout,
        false,
      );
    }

    // PUSH paralelo com watchdog por módulo
    final futures = <Future<bool>>[];
    if (hasPendingRebanho) {
      futures.add(_guardModule(
        () => action_blocks.putUpdtRebanhos(context),
        'PUSH rebanhos',
        _pushModuleTimeout,
        false,
      ));
    }
    if (hasPendingLotes) {
      futures.add(_guardModule(
        () => action_blocks.putUpdtLotes(context),
        'PUSH lotes',
        _pushModuleTimeout,
        false,
      ));
    }
    if (hasPendingRepro) {
      futures.add(_guardModule(
        () => action_blocks.putUpdtReproducao(context),
        'PUSH reproducao',
        _pushModuleTimeout,
        false,
      ));
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
      sanidadeOk = await _guardModule(
        () => action_blocks.putUpdtSanidades(context),
        'PUSH sanidade',
        _pushModuleTimeout,
        false,
      );
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
    // (ou que não tinham dados pendentes). Cada PULL também com watchdog.
    final pullFutures = <Future>[];
    if (propOk && hasPendingProp || !hasPendingProp) {
      pullFutures.add(_guardModule(
        () => action_blocks.refreshPropriedades(context),
        'PULL propriedades',
        _pullModuleTimeout,
        null,
      ));
    }
    if (lotesOk && hasPendingLotes || !hasPendingLotes) {
      pullFutures.add(_guardModule(
        () => action_blocks.refreshLotes(context),
        'PULL lotes',
        _pullModuleTimeout,
        null,
      ));
    }
    if (rebanhoOk && hasPendingRebanho || !hasPendingRebanho) {
      pullFutures.add(_guardModule(
        () => action_blocks.refreshRebanhoOtimizada(context),
        'PULL rebanho',
        _pullModuleTimeout,
        null,
      ));
    }
    if (reproOk && hasPendingRepro || !hasPendingRepro) {
      pullFutures.add(_guardModule(
        () => action_blocks.refreshReproducaoOtimizada(context),
        'PULL reproducao',
        _pullModuleTimeout,
        null,
      ));
    }
    if (sanidadeOk && hasPendingSanidade || !hasPendingSanidade) {
      pullFutures.add(_guardModule(
        () => action_blocks.refresSanidadeOtimizada(context),
        'PULL sanidade',
        _pullModuleTimeout,
        null,
      ));
    }

    if (pullFutures.isNotEmpty) {
      await Future.wait(pullFutures).catchError((e) {
        debugPrint('[SYNC][auto] Erro no PULL: $e');
        return <void>[];
      });
    }

    // Pesagens separado, também com watchdog
    await _guardModule(
      () => action_blocks.refreshPesagens(context),
      'PULL pesagens',
      _pullModuleTimeout,
      null,
    );

    appState.ultimaSincronizacao = getCurrentTimestamp;
    debugPrint(
        '[SYNC][auto] Auto-sync concluída em ${globalStopwatch.elapsedMilliseconds}ms.');
  } catch (e, s) {
    debugPrint('[SYNC][auto] ERRO na auto-sync: $e\n$s');
  } finally {
    watchdogTimer?.cancel();
    appState.isSyncing = false;
    globalStopwatch.stop();
  }
}
