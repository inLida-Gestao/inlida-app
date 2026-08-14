import 'package:flutter_test/flutter_test.dart';

import 'package:in_lida/backend/utils/sync_client_timestamp.dart';

/// Blinda o cálculo do `client_updated_at` enviado ao Supabase.
///
/// Este é o campo que o trigger `prevent_stale_rebanho_update` (migração 012)
/// usa para ordenar edições concorrentes. Se ele voltar a ser enviado como
/// horário local naive, o Postgres interpreta como UTC e o guard passa a
/// recusar em silêncio todo UPDATE de animal já sincronizado — que foi
/// exatamente o incidente de produção de 11/08/2026 (67 registros travados e
/// um lote de 60 animais subindo com 59).
void main() {
  group('resolveClientUpdatedAtUtc — correção de fuso', () {
    test('string naive do SQLite e tratada como LOCAL e convertida para UTC',
        () {
      // Formato exato gravado em local_rebanho.sync_updated_at.
      const naiveLocal = '2026-08-11 16:14:32';
      final resultado = resolveClientUpdatedAtUtc([naiveLocal]);

      final esperado = DateTime(2026, 8, 11, 16, 14, 32).toUtc();
      expect(DateTime.parse(resultado), esperado);
    });

    test('resultado SEMPRE carrega marcador de UTC (nunca naive)', () {
      final resultado = resolveClientUpdatedAtUtc(['2026-08-11 16:14:32']);

      // Sem o 'Z' o Postgres interpretaria como UTC um horario local -> bug.
      expect(resultado.endsWith('Z'), isTrue,
          reason: 'client_updated_at precisa ir com fuso explicito');
      expect(DateTime.parse(resultado).isUtc, isTrue);
    });

    test('nao desloca valores que ja vem com fuso explicito', () {
      const comFuso = '2026-08-11T19:14:32.000Z';
      final resultado = resolveClientUpdatedAtUtc([comFuso]);

      expect(DateTime.parse(resultado), DateTime.parse(comFuso));
    });

    test('offset +00:00 e normalizado sem deslocamento extra', () {
      const comOffset = '2026-08-11T19:14:32+00:00';
      final resultado = resolveClientUpdatedAtUtc([comOffset]);

      expect(DateTime.parse(resultado), DateTime.parse(comOffset).toUtc());
    });
  });

  group('resolveClientUpdatedAtUtc — ordem e fallbacks', () {
    test('usa o primeiro candidato valido (sync_updated_at tem prioridade)',
        () {
      final resultado = resolveClientUpdatedAtUtc([
        '2026-08-11 16:14:32', // sync_updated_at
        '2026-01-01 00:00:00', // updated_at (mais antigo, deve ser ignorado)
      ]);

      expect(DateTime.parse(resultado), DateTime(2026, 8, 11, 16, 14, 32).toUtc());
    });

    test('pula candidatos nulos, vazios e a string literal "null"', () {
      final resultado = resolveClientUpdatedAtUtc([
        null,
        '',
        '   ',
        'null',
        'NULL',
        '2026-08-11 16:14:32',
      ]);

      expect(DateTime.parse(resultado), DateTime(2026, 8, 11, 16, 14, 32).toUtc());
    });

    test('pula candidatos impossiveis de parsear', () {
      final resultado = resolveClientUpdatedAtUtc([
        'data invalida',
        '2026-08-11 16:14:32',
      ]);

      expect(DateTime.parse(resultado), DateTime(2026, 8, 11, 16, 14, 32).toUtc());
    });

    test('sem nenhum candidato valido cai para o "agora" em UTC', () {
      final agora = DateTime(2026, 8, 11, 16, 14, 32);
      final resultado = resolveClientUpdatedAtUtc(
        [null, '', 'null'],
        now: agora,
      );

      expect(DateTime.parse(resultado), agora.toUtc());
    });

    test('lista totalmente vazia ainda produz um timestamp valido', () {
      final agora = DateTime(2026, 8, 11, 16, 14, 32);
      final resultado = resolveClientUpdatedAtUtc(const [], now: agora);

      // Nunca pode ser vazio: payload sem marcador perde a protecao do guard.
      expect(resultado, isNotEmpty);
      expect(DateTime.parse(resultado), agora.toUtc());
    });
  });

  group('resolveClientUpdatedAtUtc — regressao do incidente 11/08/2026', () {
    test('edicao local mais nova gera client_updated_at MAIOR que o remoto',
        () {
      // Cenario real: o animal foi sincronizado as 15:47 UTC e o usuario
      // editou de novo as 16:14 no horario local (BRT = UTC-3).
      final remotoNoServidor = DateTime.utc(2026, 8, 11, 15, 47, 15);
      final edicaoLocal = DateTime(2026, 8, 11, 16, 14, 32); // relogio do device

      final enviado = DateTime.parse(
        resolveClientUpdatedAtUtc([
          '2026-08-11 16:14:32',
        ]),
      );

      // Antes da correcao o app mandava "16:14:32" naive, o Postgres lia como
      // 16:14 UTC... o que ainda seria maior. O bug real aparecia quando o
      // remoto era NOW() e o local ficava 3h atras. Aqui garantimos a
      // propriedade que importa: o instante enviado corresponde ao relogio do
      // dispositivo, entao uma edicao posterior sempre supera o valor gravado.
      expect(enviado.isAfter(remotoNoServidor), isTrue,
          reason: 'edicao feita depois do ultimo sync nao pode parecer stale');
      expect(enviado, edicaoLocal.toUtc());
    });

    test('edicao local realmente antiga continua sendo detectada como stale',
        () {
      // O guard precisa continuar funcionando de verdade: uma edicao feita
      // ANTES do que o servidor ja tem deve parecer stale.
      final remotoNoServidor = DateTime.utc(2026, 8, 11, 15, 47, 15);
      final enviado = DateTime.parse(
        resolveClientUpdatedAtUtc(['2026-08-10 09:00:00']),
      );

      expect(enviado.isBefore(remotoNoServidor), isTrue);
    });
  });
}
