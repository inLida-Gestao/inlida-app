import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/backend/utils/reproducao_parto_utils.dart';

void main() {
  group('janelaConcepcao', () {
    test('retorna exatamente -305 e -275 dias do nascimento', () {
      final nascimento = DateTime(2026, 1, 1);
      final janela = janelaConcepcao(nascimento);

      expect(janela.inicio,
          DateTime(2026, 1, 1).subtract(const Duration(days: 305)));
      expect(
          janela.fim, DateTime(2026, 1, 1).subtract(const Duration(days: 275)));
      expect(janela.fim.isAfter(janela.inicio), isTrue);
      expect(janela.fim.difference(janela.inicio).inDays, 30);
    });
  });

  group('janelaConcepcaoEstendida', () {
    test('retorna exatamente -350 e -306 dias do nascimento', () {
      final nascimento = DateTime(2026, 1, 1);
      final janela = janelaConcepcaoEstendida(nascimento);

      expect(janela.inicio,
          DateTime(2026, 1, 1).subtract(const Duration(days: 350)));
      expect(
          janela.fim, DateTime(2026, 1, 1).subtract(const Duration(days: 306)));
      expect(janela.fim.isAfter(janela.inicio), isTrue);
    });

    test('não se sobrepõe à janela automática', () {
      final nascimento = DateTime(2026, 1, 1);
      final janelaAutomatica = janelaConcepcao(nascimento);
      final janelaEstendida = janelaConcepcaoEstendida(nascimento);

      expect(janelaEstendida.fim.isBefore(janelaAutomatica.inicio), isTrue);
    });
  });

  group('dataReferenciaReproducao', () {
    test('Inseminação usa data_inseminacao', () {
      final data = dataReferenciaReproducao(
        'Inseminação',
        '2025-03-01',
        '2025-02-01',
        '2025-02-10',
      );
      expect(data, DateTime(2025, 3, 1));
    });

    test('Monta Natural usa data_inicial quando presente', () {
      final data = dataReferenciaReproducao(
        'Monta Natural',
        null,
        '2025-02-01',
        '2025-02-20',
      );
      expect(data, DateTime(2025, 2, 1));
    });

    test('Monta Natural cai para data_final quando data_inicial ausente', () {
      final data = dataReferenciaReproducao(
        'Monta Natural',
        null,
        null,
        '2025-02-20',
      );
      expect(data, DateTime(2025, 2, 20));
    });

    test('tipo desconhecido retorna null', () {
      final data = dataReferenciaReproducao('Outro', '2025-01-01', null, null);
      expect(data, isNull);
    });
  });

  group('reproducaoDisponivelParaParto', () {
    test('rejeita parida = SIM', () {
      expect(reproducaoDisponivelParaParto('SIM', null), isFalse);
    });

    test('rejeita quando já existe data_parto válida (dado legado)', () {
      expect(reproducaoDisponivelParaParto('NAO', '2025-07-01'), isFalse);
    });

    test('aceita quando não parida e sem data_parto', () {
      expect(reproducaoDisponivelParaParto('NAO', null), isTrue);
      expect(reproducaoDisponivelParaParto(null, null), isTrue);
    });
  });

  group('selecionarReproducaoParaParto', () {
    CandidatoReproducao candidato({
      required String id,
      required DateTime dataReferencia,
      String? parida,
      String? dataParto,
    }) =>
        CandidatoReproducao(
          idReproducao: id,
          dataReferencia: dataReferencia,
          tipoReproducao: 'Inseminação',
          parida: parida,
          dataParto: dataParto,
          statusReproducao: null,
          idRebanhoReprodutor: 'reprodutor-$id',
          numReprodutor: null,
          nomeReprodutor: null,
          nascimentoReprodutor: null,
          racaReprodutor: null,
          chipReprodutor: null,
        );

    test('retorna null para lista vazia', () {
      expect(selecionarReproducaoParaParto(const []), isNull);
    });

    test('ignora candidatos já paridos e retorna o disponível', () {
      final resultado = selecionarReproducaoParaParto([
        candidato(
          id: 'a',
          dataReferencia: DateTime(2025, 6, 1),
          parida: 'SIM',
        ),
        candidato(id: 'b', dataReferencia: DateTime(2025, 5, 1)),
      ]);
      expect(resultado?.idReproducao, 'b');
    });

    test('retorna null quando todos já estão paridos', () {
      final resultado = selecionarReproducaoParaParto([
        candidato(id: 'a', dataReferencia: DateTime(2025, 6, 1), parida: 'SIM'),
        candidato(
          id: 'b',
          dataReferencia: DateTime(2025, 5, 1),
          dataParto: '2025-05-10',
        ),
      ]);
      expect(resultado, isNull);
    });

    test('escolhe o mais recente entre os disponíveis', () {
      final resultado = selecionarReproducaoParaParto([
        candidato(id: 'antigo', dataReferencia: DateTime(2025, 1, 1)),
        candidato(id: 'recente', dataReferencia: DateTime(2025, 6, 1)),
        candidato(id: 'meio', dataReferencia: DateTime(2025, 3, 1)),
      ]);
      expect(resultado?.idReproducao, 'recente');
    });
  });
}
