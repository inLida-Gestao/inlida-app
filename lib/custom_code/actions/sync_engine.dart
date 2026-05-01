// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// (none)
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

/// B3 — SyncEngine: orquestrador único de sincronização.
///
/// Substitui a lógica duplicada entre `auto_sync.dart` (reconexão) e
/// `navegacao_widget.dart` (botão manual). Garante que NUNCA roda mais
/// de um sync simultâneo (mutex via `_active`), expõe progresso via
/// stream e centraliza watchdogs/timeouts.
///
/// Como usar:
/// ```dart
/// final result = await SyncEngine.instance.run(
///   context,
///   trigger: SyncTrigger.manual,
///   onProgress: (p) => setState(() { /* atualizar UI */ }),
/// );
/// if (!result.allSuccess) { /* mostrar snackbar de aviso */ }
/// ```
///
/// Para cancelar (de qualquer lugar):
/// ```dart
/// SyncEngine.instance.cancel();
/// ```
enum SyncTrigger { manual, autoReconnect, boot }

class SyncProgress {
  final int percent;
  final String label;
  const SyncProgress(this.percent, this.label);
}

class SyncResult {
  final bool propOk;
  final bool rebanhoOk;
  final bool lotesOk;
  final bool reproOk;
  final bool sanidadeOk;
  final bool cancelled;
  final bool skipped; // sync já em andamento ou intervalo mínimo

  const SyncResult({
    this.propOk = true,
    this.rebanhoOk = true,
    this.lotesOk = true,
    this.reproOk = true,
    this.sanidadeOk = true,
    this.cancelled = false,
    this.skipped = false,
  });

  bool get allSuccess =>
      propOk && rebanhoOk && lotesOk && reproOk && sanidadeOk && !cancelled;
}

/// Tempo máximo de PUSH por módulo antes de abortar (watchdog individual).
const _pushModuleTimeout = Duration(seconds: 90);

/// Tempo máximo de PULL por módulo antes de abortar.
const _pullModuleTimeout = Duration(seconds: 120);

/// Tempo máximo TOTAL de uma sessão de sync (watchdog global).
const _totalBudget = Duration(minutes: 3);

/// Intervalo mínimo entre AUTO-syncs consecutivos (60s).
/// Não se aplica a sync manual.
const _minAutoInterval = Duration(seconds: 60);

class SyncEngine {
  SyncEngine._();
  static final SyncEngine instance = SyncEngine._();

  bool _active = false;
  final _progressController = StreamController<SyncProgress>.broadcast();

  Stream<SyncProgress> get progress => _progressController.stream;
  bool get isActive => _active;

  /// Solicita cancelamento cooperativo. Os loops dentro de actions.dart
  /// verificam `FFAppState.syncCancelRequested` e abortam.
  void cancel() {
    if (!_active) return;
    debugPrint('[SYNC][engine] Cancel solicitado.');
    FFAppState().syncCancelRequested = true;
  }

  /// Executa um sync completo (PUSH → PULL).
  ///
  /// Retorna [SyncResult]. Se outro sync estiver em andamento ou se o
  /// trigger for `autoReconnect` e o intervalo mínimo não foi atingido,
  /// retorna `skipped=true` sem rodar nada.
  Future<SyncResult> run(
    BuildContext context, {
    required SyncTrigger trigger,
    void Function(SyncProgress)? onProgress,
  }) async {
    if (_active) {
      debugPrint('[SYNC][engine] Sync já ativo — ignorando trigger=$trigger.');
      return const SyncResult(skipped: true);
    }

    if (trigger == SyncTrigger.autoReconnect) {
      final last = FFAppState().lastAutoSync;
      if (last != null && DateTime.now().difference(last) < _minAutoInterval) {
        debugPrint(
            '[SYNC][engine] Intervalo mínimo de auto-sync não atingido.');
        return const SyncResult(skipped: true);
      }
    }

    _active = true;
    final state = FFAppState();
    state.isSyncing = true;
    state.syncCancelRequested = false;
    state.lastSyncHeartbeat = DateTime.now();
    if (trigger == SyncTrigger.autoReconnect) {
      state.lastAutoSync = DateTime.now();
    }

    void emit(int p, String l) {
      final progress = SyncProgress(p, l);
      state.syncProgressPercent = p;
      state.syncProgressLabel = l;
      action_blocks.SyncTelemetry.log(
        flow: 'engine',
        message: 'Progresso $p% - $l',
      );
      onProgress?.call(progress);
      if (!_progressController.isClosed) _progressController.add(progress);
    }

    final stopwatch = Stopwatch()..start();
    Timer? watchdog;
    var result = const SyncResult();

    try {
      // Watchdog global: garante liberar isSyncing mesmo em deadlock.
      watchdog = Timer(_totalBudget, () {
        debugPrint(
            '[SYNC][engine][watchdog] ${_totalBudget.inSeconds}s excedidos — '
            'forçando cancelamento.');
        state.syncCancelRequested = true;
      });

      result = await _runInternal(context, trigger, emit);

      emit(100, result.cancelled ? 'Cancelado' : 'Concluído!');
      // Limpa flags dos módulos que tiveram PUSH bem-sucedido.
      // (Cancel intencional NÃO limpa — usuário pode tentar de novo.)
      if (!result.cancelled) {
        if (result.propOk) state.dataDadosNaoSyncProp = null;
        if (result.rebanhoOk) state.dataDadosNaoSyncRebanho = null;
        if (result.lotesOk) state.dataDadosNaoSyncLotes = null;
        if (result.reproOk) state.dataDadosNaoSyncRepro = null;
        if (result.sanidadeOk) state.dataDadosNaoSyncSanidade = null;
      }
      state.ultimaSincronizacao = getCurrentTimestamp;
    } catch (e, s) {
      debugPrint('[SYNC][engine] ERRO geral: $e\n$s');
      result = const SyncResult(
        propOk: false,
        rebanhoOk: false,
        lotesOk: false,
        reproOk: false,
        sanidadeOk: false,
      );
    } finally {
      watchdog?.cancel();
      // Pequeno delay para o usuário ver "Concluído!" na UI.
      await Future.delayed(const Duration(milliseconds: 1200));
      state.syncProgressPercent = -1;
      state.syncProgressLabel = '';
      state.isSyncing = false;
      _active = false;
      stopwatch.stop();
      debugPrint(
          '[SYNC][engine] Finalizado em ${stopwatch.elapsedMilliseconds}ms '
          '(trigger=$trigger, allSuccess=${result.allSuccess}, '
          'cancelled=${result.cancelled}).');
    }
    return result;
  }

  Future<SyncResult> _runInternal(
    BuildContext context,
    SyncTrigger trigger,
    void Function(int, String) emit,
  ) async {
    final state = FFAppState();
    final hasPendingProp = state.dataDadosNaoSyncProp != null;
    final hasPendingRebanho = state.dataDadosNaoSyncRebanho != null;
    final hasPendingLotes = state.dataDadosNaoSyncLotes != null;
    final hasPendingRepro = state.dataDadosNaoSyncRepro != null;
    final hasPendingSanidade = state.dataDadosNaoSyncSanidade != null;
    final hasAnyPending = hasPendingProp ||
        hasPendingRebanho ||
        hasPendingLotes ||
        hasPendingRepro ||
        hasPendingSanidade;

    debugPrint('[SYNC][engine] Pendentes: prop=$hasPendingProp, '
        'rebanhos=$hasPendingRebanho, lotes=$hasPendingLotes, '
        'repro=$hasPendingRepro, sanidade=$hasPendingSanidade.');

    // ───── PUSH phase ─────
    var propOk = true;
    var rebanhoOk = true;
    var lotesOk = true;
    var reproOk = true;
    var sanidadeOk = true;

    if (hasAnyPending) {
      emit(5, 'Enviando dados...');
    }

    if (hasPendingProp) {
      emit(8, 'Enviando propriedades...');
      propOk = await _guard(
        () => action_blocks.putUpdtPropriedades(context),
        'PUSH propriedades',
        _pushModuleTimeout,
        false,
      );
    }
    if (state.syncCancelRequested) return const SyncResult(cancelled: true);

    // PUSH sequencial. Em bases antigas pós-update, rodar rebanho/lotes/repro
    // em paralelo concentrava SQLite + rede + serialização no mesmo momento e
    // podia levar o SO a encerrar o app exatamente em 15%.
    if (hasPendingRebanho) {
      emit(15, 'Enviando rebanhos...');
      rebanhoOk = await _guard(
        () => action_blocks.putUpdtRebanhos(context),
        'PUSH rebanhos',
        _pushModuleTimeout,
        false,
      );
      if (state.syncCancelRequested) {
        return SyncResult(
          cancelled: true,
          propOk: propOk,
          rebanhoOk: rebanhoOk,
        );
      }
    }
    if (hasPendingLotes) {
      emit(20, 'Enviando lotes...');
      lotesOk = await _guard(
        () => action_blocks.putUpdtLotes(context),
        'PUSH lotes',
        _pushModuleTimeout,
        false,
      );
      if (state.syncCancelRequested) {
        return SyncResult(
          cancelled: true,
          propOk: propOk,
          rebanhoOk: rebanhoOk,
        );
      }
    }
    if (hasPendingRepro) {
      emit(25, 'Enviando reprodução...');
      reproOk = await _guard(
        () => action_blocks.putUpdtReproducao(context),
        'PUSH reproducao',
        _pushModuleTimeout,
        false,
      );
      if (state.syncCancelRequested) {
        return SyncResult(
          cancelled: true,
          propOk: propOk,
          rebanhoOk: rebanhoOk,
          lotesOk: lotesOk,
        );
      }
    }
    if (state.syncCancelRequested) return const SyncResult(cancelled: true);

    if (hasPendingSanidade) {
      emit(30, 'Enviando sanidades...');
      sanidadeOk = await _guard(
        () => action_blocks.putUpdtSanidades(context),
        'PUSH sanidade',
        _pushModuleTimeout,
        false,
      );
    }
    if (state.syncCancelRequested) {
      return SyncResult(
        cancelled: true,
        propOk: propOk,
        rebanhoOk: rebanhoOk,
        lotesOk: lotesOk,
        reproOk: reproOk,
        sanidadeOk: sanidadeOk,
      );
    }

    // ───── PULL phase ─────
    // PULL apenas para módulos cujo PUSH não falhou (evita sobrescrever
    // dados locais com versão remota desatualizada).
    emit(35, 'Baixando propriedades...');
    if (propOk) {
      await _guard(
        () => action_blocks.refreshPropriedades(context),
        'PULL propriedades',
        _pullModuleTimeout,
        null,
      );
    }
    if (state.syncCancelRequested) {
      return SyncResult(
        cancelled: true,
        propOk: propOk,
        rebanhoOk: rebanhoOk,
        lotesOk: lotesOk,
        reproOk: reproOk,
        sanidadeOk: sanidadeOk,
      );
    }

    emit(45, 'Baixando lotes...');
    if (lotesOk) {
      await _guard(
        () => action_blocks.refreshLotes(context),
        'PULL lotes',
        _pullModuleTimeout,
        null,
      );
    }

    emit(55, 'Baixando dados...');
    final pullFutures = <Future>[];
    if (rebanhoOk) {
      pullFutures.add(_guard(
        () => action_blocks.refreshRebanhoOtimizada(context),
        'PULL rebanho',
        _pullModuleTimeout,
        null,
      ));
    }
    if (reproOk) {
      pullFutures.add(_guard(
        () => action_blocks.refreshReproducaoOtimizada(context),
        'PULL reproducao',
        _pullModuleTimeout,
        null,
      ));
    }
    if (sanidadeOk) {
      pullFutures.add(_guard(
        () => action_blocks.refresSanidadeOtimizada(context),
        'PULL sanidade',
        _pullModuleTimeout,
        null,
      ));
    }
    if (pullFutures.isNotEmpty) {
      await Future.wait(pullFutures).catchError((e) {
        debugPrint('[SYNC][engine] Erro no PULL paralelo: $e');
        return <void>[];
      });
    }
    if (state.syncCancelRequested) {
      return SyncResult(
        cancelled: true,
        propOk: propOk,
        rebanhoOk: rebanhoOk,
        lotesOk: lotesOk,
        reproOk: reproOk,
        sanidadeOk: sanidadeOk,
      );
    }

    emit(85, 'Baixando pesagens...');
    await _guard(
      () => action_blocks.refreshPesagens(context),
      'PULL pesagens',
      _pullModuleTimeout,
      null,
    );

    emit(95, 'Finalizando...');
    try {
      await action_blocks.countLotesCadastrados(context);
    } catch (e) {
      debugPrint('[SYNC][engine] Erro em countLotesCadastrados: $e');
    }

    return SyncResult(
      propOk: propOk,
      rebanhoOk: rebanhoOk,
      lotesOk: lotesOk,
      reproOk: reproOk,
      sanidadeOk: sanidadeOk,
    );
  }

  /// Envolve [task] em timeout. Em caso de erro/timeout/cancel, loga e
  /// retorna [fallback]. Não relança — `_runInternal` controla o fluxo.
  Future<T> _guard<T>(
    Future<T> Function() task,
    String label,
    Duration timeout,
    T fallback,
  ) async {
    final cancelCompleter = Completer<T>();
    final cancelTimer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (FFAppState().syncCancelRequested && !cancelCompleter.isCompleted) {
        debugPrint(
            '[SYNC][engine][watchdog] $label cancelado cooperativamente.');
        cancelCompleter.complete(fallback);
        t.cancel();
      }
    });
    try {
      return await Future.any<T>([
        task().timeout(timeout, onTimeout: () {
          debugPrint(
              '[SYNC][engine][watchdog] $label estourou após ${timeout.inSeconds}s.');
          throw TimeoutException('$label timeout');
        }),
        cancelCompleter.future,
      ]);
    } on TimeoutException {
      return fallback;
    } catch (e, s) {
      debugPrint('[SYNC][engine][watchdog] $label falhou: $e\n$s');
      return fallback;
    } finally {
      cancelTimer.cancel();
    }
  }
}

/// Wrapper retro-compatível usado pelo listener de connectivity em
/// `home_page_widget`. Equivalente a `SyncEngine.instance.run(trigger=auto)`.
Future<void> performAutoSync(BuildContext context) async {
  final state = FFAppState();

  // Verificar se há algo para sincronizar — auto-sync NÃO faz PULL puro
  // (isso continua sendo responsabilidade do home_page initial load).
  final hasPending = state.dataDadosNaoSyncProp != null ||
      state.dataDadosNaoSyncRebanho != null ||
      state.dataDadosNaoSyncLotes != null ||
      state.dataDadosNaoSyncRepro != null ||
      state.dataDadosNaoSyncSanidade != null;
  if (!hasPending) {
    debugPrint('[SYNC][auto] Nenhum dado pendente para auto-sync.');
    return;
  }

  await SyncEngine.instance.run(context, trigger: SyncTrigger.autoReconnect);
}

/// Wrapper conveniente para o botão manual de sync.
/// Auth/access checks devem ser feitas FORA — esta função apenas roda o
/// ciclo de sincronização.
Future<SyncResult> performManualSync(
  BuildContext context, {
  void Function(SyncProgress)? onProgress,
}) async {
  return SyncEngine.instance.run(
    context,
    trigger: SyncTrigger.manual,
    onProgress: onProgress,
  );
}
