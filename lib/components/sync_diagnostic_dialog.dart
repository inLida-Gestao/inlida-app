import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/actions/actions.dart' as action_blocks;
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// B6 — Tela de diagnóstico de sincronização.
///
/// Exibe estado atual do sync (isSyncing, lastHeartbeat, lastAutoSync) e os
/// últimos 500 eventos de telemetria capturados em memória pelo
/// [action_blocks.SyncTelemetry]. Inclui botão "Cancelar sincronização" que
/// aciona o flag cooperativo (`FFAppState.syncCancelRequested`).
///
/// Como acionar a partir de qualquer lugar:
/// ```dart
/// SyncDiagnosticDialog.show(context);
/// ```
class SyncDiagnosticDialog extends StatefulWidget {
  const SyncDiagnosticDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const Dialog(
        insetPadding: EdgeInsets.all(16),
        child: SyncDiagnosticDialog(),
      ),
    );
  }

  @override
  State<SyncDiagnosticDialog> createState() => _SyncDiagnosticDialogState();
}

class _SyncDiagnosticDialogState extends State<SyncDiagnosticDialog> {
  late final Timer _refresher;

  @override
  void initState() {
    super.initState();
    // Atualiza a UI a cada 1s para refletir novos eventos do telemetria.
    _refresher = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refresher.cancel();
    super.dispose();
  }

  String _fmtTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  String _fmtDateTime(DateTime? dt) => dt?.toIso8601String() ?? '-';

  Future<Map<String, int?>> _collectLocalCounts() async {
    final tables = <String>[
      'local_propriedades',
      'local_lotes',
      'local_rebanho',
      'local_reproducao',
      'local_sanidade',
      'local_historico_pesagens',
      'sync_error_log',
    ];
    final result = <String, int?>{};
    for (final table in tables) {
      try {
        final rows = await SQLiteManager.instance.database
            .rawQuery('SELECT COUNT(*) AS qtd FROM $table');
        final value = rows.isNotEmpty ? rows.first['qtd'] : null;
        result[table] = value is int ? value : int.tryParse('$value');
      } catch (_) {
        result[table] = null;
      }
    }
    return result;
  }

  Future<String> _buildReport() async {
    final state = FFAppState();
    final events = action_blocks.SyncTelemetry.snapshot();
    final localCounts = await _collectLocalCounts();
    final buffer = StringBuffer()
      ..writeln('=== Diagnostico de sincronizacao inLida ===')
      ..writeln('gerado_em=${DateTime.now().toIso8601String()}')
      ..writeln('is_syncing=${state.isSyncing}')
      ..writeln('online=${state.isOnline}')
      ..writeln('cancel_requested=${state.syncCancelRequested}')
      ..writeln(
          'progress=${state.syncProgressPercent}% ${state.syncProgressLabel}')
      ..writeln('last_heartbeat=${_fmtDateTime(state.lastSyncHeartbeat)}')
      ..writeln('last_auto_sync=${_fmtDateTime(state.lastAutoSync)}')
      ..writeln(
          'ultima_sincronizacao=${_fmtDateTime(state.ultimaSincronizacao)}')
      ..writeln('marker_prop=${_fmtDateTime(state.dataDadosNaoSyncProp)}')
      ..writeln('marker_rebanho=${_fmtDateTime(state.dataDadosNaoSyncRebanho)}')
      ..writeln('marker_lotes=${_fmtDateTime(state.dataDadosNaoSyncLotes)}')
      ..writeln('marker_repro=${_fmtDateTime(state.dataDadosNaoSyncRepro)}')
      ..writeln(
          'marker_sanidade=${_fmtDateTime(state.dataDadosNaoSyncSanidade)}')
      ..writeln('')
      ..writeln('--- Contagens locais ---');
    for (final entry in localCounts.entries) {
      buffer.writeln('${entry.key}=${entry.value ?? "erro"}');
    }
    buffer
      ..writeln('')
      ..writeln('--- Eventos (${events.length}) ---');

    for (final e in events) {
      final elapsed = e.elapsedMs != null ? ' ${e.elapsedMs}ms' : '';
      final level = e.isError ? 'ERRO' : 'INFO';
      buffer.writeln(
          '${e.timestamp.toIso8601String()} [$level][${e.flow}]$elapsed ${e.message}');
    }
    return buffer.toString();
  }

  Future<void> _copyReport() async {
    await Clipboard.setData(ClipboardData(text: await _buildReport()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Relatório de sincronização copiado.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = FFAppState();
    final events = action_blocks.SyncTelemetry.snapshot().reversed.toList();
    final isSyncing = state.isSyncing;
    final cancelRequested = state.syncCancelRequested;
    final hb = state.lastSyncHeartbeat;
    final lastAuto = state.lastAutoSync;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.health_and_safety, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Diagnóstico de sincronização',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Fechar',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),
          _statusRow('Sincronizando agora?', isSyncing ? 'Sim' : 'Não',
              ok: !isSyncing),
          _statusRow(
            'Cancelamento solicitado?',
            cancelRequested ? 'Sim' : 'Não',
            ok: !cancelRequested,
          ),
          _statusRow(
            'Último heartbeat',
            hb != null
                ? '${_fmtTime(hb)} (${DateTime.now().difference(hb).inSeconds}s atrás)'
                : '—',
          ),
          _statusRow(
            'Último auto-sync',
            lastAuto != null
                ? '${_fmtTime(lastAuto)} (${DateTime.now().difference(lastAuto).inSeconds}s atrás)'
                : '—',
          ),
          _statusRow(
            'Progresso atual',
            state.syncProgressPercent >= 0
                ? '${state.syncProgressPercent}% - ${state.syncProgressLabel}'
                : '—',
          ),
          _statusRow('Online?', state.isOnline ? 'Sim' : 'Não',
              ok: state.isOnline),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copiar relatório para análise'),
            onPressed: _copyReport,
          ),
          const SizedBox(height: 8),
          if (isSyncing)
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text('Cancelar sincronização'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade900,
              ),
              onPressed: cancelRequested
                  ? null
                  : () {
                      FFAppState().syncCancelRequested = true;
                      setState(() {});
                    },
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Últimos eventos (${events.length})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copiar'),
                onPressed: _copyReport,
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Limpar'),
                onPressed: () {
                  action_blocks.SyncTelemetry.clear();
                  setState(() {});
                },
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: events.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nenhum evento registrado.',
                        textAlign: TextAlign.center),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: (ctx, i) {
                      final e = events[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200)),
                          color: e.isError ? Colors.red.shade50 : null,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                _fmtTime(e.timestamp),
                                style: const TextStyle(
                                    fontFamily: 'monospace', fontSize: 11),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              child: Text(
                                e.flow,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: e.isError
                                      ? Colors.red.shade700
                                      : Colors.blueGrey.shade700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                e.elapsedMs != null
                                    ? '${e.message} (${e.elapsedMs}ms)'
                                    : e.message,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: e.isError ? Colors.red.shade900 : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String label, String value, {bool? ok}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ok == null
                    ? null
                    : (ok ? Colors.green.shade700 : Colors.orange.shade800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
