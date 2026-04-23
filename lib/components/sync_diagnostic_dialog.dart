import 'dart:async';

import 'package:flutter/material.dart';

import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_util.dart';

/// B6 — Tela de diagnóstico de sincronização.
///
/// Exibe estado atual do sync (isSyncing, lastHeartbeat, lastAutoSync) e os
/// últimos 200 eventos de telemetria capturados em memória pelo
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
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
          _statusRow('Online?', state.isOnline ? 'Sim' : 'Não',
              ok: state.isOnline),
          const SizedBox(height: 12),
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
