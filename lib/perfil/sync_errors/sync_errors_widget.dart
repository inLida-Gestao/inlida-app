import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/custom_code/actions/sync_error_log.dart';

/// Tela de auditoria de erros de sincronização.
///
/// Lista os registros locais que falharam ao subir para o Supabase,
/// agrupados por módulo, com mensagem amigável + campo problemático.
/// Permite descartar (parar de tentar) ou tentar novamente.
class SyncErrorsWidget extends StatefulWidget {
  const SyncErrorsWidget({super.key});

  @override
  State<SyncErrorsWidget> createState() => _SyncErrorsWidgetState();
}

class _SyncErrorsWidgetState extends State<SyncErrorsWidget> {
  late Future<List<SyncErrorEntry>> _future;

  static const Map<String, String> _moduloLabel = {
    'reproducao': 'Reprodução',
    'rebanho': 'Rebanho',
    'lote': 'Lotes',
    'sanidade': 'Sanidade',
    'pesagem': 'Pesagens',
    'propriedade': 'Propriedades',
  };

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _future = SyncErrorLog.listarAtivos();
    });
  }

  Future<void> _descartar(SyncErrorEntry e) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Descartar erro?'),
        content: Text(
          'O registro "${e.registroDescricao ?? e.registroId ?? ''}" '
          'permanecerá no aparelho mas não será marcado como erro novamente. '
          'Para reenviar você precisará editar o registro.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await SyncErrorLog.descartar(e.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro descartado.')),
      );
      _reload();
    }
  }

  Future<void> _tentarNovamente(SyncErrorEntry e) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'O registro será reenviado na próxima sincronização. '
          'Toque no botão de sincronizar quando estiver pronto.',
        ),
      ),
    );
  }

  Future<void> _purgar() async {
    await SyncErrorLog.purgar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erros antigos limpos.')),
    );
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Erros de sincronização',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'purgar') _purgar();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'purgar',
                child: Text('Limpar erros antigos resolvidos'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<SyncErrorEntry>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final errors = snap.data ?? const <SyncErrorEntry>[];
          if (errors.isEmpty) {
            return _empty(context);
          }
          final byModulo = <String, List<SyncErrorEntry>>{};
          for (final e in errors) {
            byModulo.putIfAbsent(e.modulo, () => []).add(e);
          }
          final modulos = byModulo.keys.toList()..sort();
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _summaryCard(theme, errors.length, modulos.length),
                const SizedBox(height: 12),
                for (final m in modulos) ...[
                  _moduloHeader(theme, m, byModulo[m]!.length),
                  for (final e in byModulo[m]!) _errorTile(theme, e),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 72, color: theme.success),
            const SizedBox(height: 16),
            Text(
              'Nenhum erro de sincronização',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Todos os seus registros foram enviados ao servidor com sucesso.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: theme.secondaryText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(FlutterFlowTheme theme, int total, int mod) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.warning.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: theme.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$total registro(s) com erro em $mod módulo(s). '
              'Edite o registro para corrigir, ou descarte para parar de tentar.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moduloHeader(FlutterFlowTheme theme, String modulo, int n) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6, left: 4),
      child: Text(
        '${_moduloLabel[modulo] ?? modulo} ($n)',
        style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.secondaryText),
      ),
    );
  }

  Widget _errorTile(FlutterFlowTheme theme, SyncErrorEntry e) {
    final df = DateFormat('dd/MM/yyyy HH:mm');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.alternate),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding:
            const EdgeInsets.fromLTRB(14, 0, 14, 12),
        title: Text(
          e.registroDescricao ?? e.registroId ?? 'Registro sem identificação',
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (e.campoProblema != null)
                Text(
                  'Campo: ${e.campoLabel}',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: theme.error),
                ),
              Text(
                e.mensagemAmigavel ?? 'Erro ao enviar para o servidor.',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ],
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Operação: ${e.operacao} · Tentativas: ${e.tentativas}\n'
              'Primeira: ${df.format(e.primeiraOcorrencia)}\n'
              'Última: ${df.format(e.ultimaOcorrencia)}',
              style: GoogleFonts.poppins(
                  fontSize: 11, color: theme.secondaryText),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              e.mensagemErro,
              style: GoogleFonts.firaMono(fontSize: 10),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _descartar(e),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Descartar'),
                style: TextButton.styleFrom(foregroundColor: theme.error),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _tentarNovamente(e),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Tentar novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
