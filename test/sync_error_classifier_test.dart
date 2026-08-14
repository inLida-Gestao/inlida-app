import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import 'package:in_lida/custom_code/actions/sync_error_log.dart';

/// Testa `SyncErrorLog.classificarErro`, que traduz erros técnicos (código
/// Postgrest ou texto bruto) em código estável + causa provável + ação
/// sugerida em PT-BR para a tela "Erros de sincronização".
void main() {
  group('classificarErro — códigos PostgrestException', () {
    test('55006 (guard de stale) vira STALE_CONFLICT', () {
      const erro = PostgrestException(
        message: 'STALE_REBANHO_UPDATE idRebanho=abc, incoming...',
        code: '55006',
      );
      final c = SyncErrorLog.classificarErro(erro, erro.toString());
      expect(c.codigo, 'STALE_CONFLICT');
      expect(c.causaProvavel, contains('alterado em outro dispositivo'));
      expect(c.acaoSugerida, isNotEmpty);
    });

    test('23502 (not-null) vira CAMPO_OBRIGATORIO com nome do campo', () {
      const erro = PostgrestException(
        message: 'null value in column "numeroAnimal" violates not-null '
            'constraint',
        code: '23502',
      );
      final c = SyncErrorLog.classificarErro(erro, erro.message);
      expect(c.codigo, 'CAMPO_OBRIGATORIO');
      expect(c.campoProblema, 'numeroAnimal');
      expect(c.causaProvavel, contains('Número do animal'));
    });

    test('23503 (foreign key) vira FK_MISSING', () {
      const erro = PostgrestException(
        message: 'insert or update on table "rebanho" violates foreign key '
            'constraint "rebanho_loteid_fkey"\nKey (loteID)=(abc) is not '
            'present in table "lotes".',
        code: '23503',
      );
      final c = SyncErrorLog.classificarErro(erro, erro.message);
      expect(c.codigo, 'FK_MISSING');
      expect(c.campoProblema, 'loteID');
    });

    test('23505 (unique) vira DUPLICADO', () {
      const erro = PostgrestException(
        message: 'duplicate key value violates unique constraint '
            '"rebanho_pkey"\nKey (idRebanho)=(x) already exists.',
        code: '23505',
      );
      final c = SyncErrorLog.classificarErro(erro, erro.message);
      expect(c.codigo, 'DUPLICADO');
    });

    test('42501 (RLS) vira RLS_DENIED', () {
      const erro = PostgrestException(
        message: 'new row violates row-level security policy',
        code: '42501',
      );
      final c = SyncErrorLog.classificarErro(erro, erro.message);
      expect(c.codigo, 'RLS_DENIED');
    });

    test('PGRST301 (JWT expirado) vira SESSAO_EXPIRADA', () {
      const erro = PostgrestException(
        message: 'JWT expired',
        code: 'PGRST301',
      );
      final c = SyncErrorLog.classificarErro(erro, erro.message);
      expect(c.codigo, 'SESSAO_EXPIRADA');
    });
  });

  group('classificarErro — exceções internas do sync engine (por texto)', () {
    test('mensagem de stale do sync engine vira STALE_CONFLICT', () {
      const bruta = 'Update de rebanho stale recusado para idRebanho=abc. '
          'Outro dispositivo/o servidor atualizou este animal depois da sua '
          'edição local; sincronize novamente para reenviar com a versão '
          'mais recente.';
      final c = SyncErrorLog.classificarErro(Exception(bruta), bruta);
      expect(c.codigo, 'STALE_CONFLICT');
    });

    test('UPDATE sem linha afetada vira RLS_DENIED (conflito indeterminado)',
        () {
      const bruta = 'UPDATE de rebanho idRebanho=abc não afetou nenhuma '
          'linha (possível bloqueio de permissão/RLS ou remoção '
          'concorrente).';
      final c = SyncErrorLog.classificarErro(Exception(bruta), bruta);
      expect(c.codigo, 'RLS_DENIED');
    });
  });

  group('classificarErro — fallback por regex (sem PostgrestException)', () {
    test('timeout vira TIMEOUT', () {
      const bruta = 'TimeoutException after 0:00:20.000000: Future not '
          'completed';
      final c = SyncErrorLog.classificarErro(Exception(bruta), bruta);
      expect(c.codigo, 'TIMEOUT');
    });

    test('erro de rede vira SEM_CONEXAO', () {
      const bruta = 'SocketException: Failed host lookup';
      final c = SyncErrorLog.classificarErro(Exception(bruta), bruta);
      expect(c.codigo, 'SEM_CONEXAO');
    });

    test('mensagem desconhecida cai no fallback DESCONHECIDO', () {
      const bruta = 'algo totalmente inesperado aconteceu';
      final c = SyncErrorLog.classificarErro(Exception(bruta), bruta);
      expect(c.codigo, 'DESCONHECIDO');
      expect(c.acaoSugerida, isNotEmpty);
    });
  });
}
