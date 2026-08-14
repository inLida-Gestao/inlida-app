import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/backend/bluetooth/bastao_tag_parser.dart';

void main() {
  group('BastaoTagParser.normalizarLinha', () {
    test('aceita o código ISO de 15 dígitos', () {
      expect(
        BastaoTagParser.normalizarLinha('982000123456789'),
        '982000123456789',
      );
    });

    test('ignora espaços e separadores dentro do código', () {
      expect(
        BastaoTagParser.normalizarLinha('982 000123456789'),
        '982000123456789',
      );
      expect(
        BastaoTagParser.normalizarLinha('982_000123456789'),
        '982000123456789',
      );
    });

    test('remove o dígito de animal quando o código vem com 16 dígitos', () {
      expect(
        BastaoTagParser.normalizarLinha('0982000123456789'),
        '982000123456789',
      );
    });

    test('descarta código de 16 dígitos que não começa com zero', () {
      expect(BastaoTagParser.normalizarLinha('1982000123456789'), isNull);
    });

    test('ignora prefixos alfabéticos do firmware', () {
      expect(
        BastaoTagParser.normalizarLinha('LA982000123456789'),
        '982000123456789',
      );
    });

    test('extrai o código quando a linha traz campos extras', () {
      expect(
        BastaoTagParser.normalizarLinha('982000123456789,-45,HDX'),
        '982000123456789',
      );
      expect(
        BastaoTagParser.normalizarLinha('12\t982000123456789\t2026-07-31'),
        '982000123456789',
      );
    });

    test('rejeita linhas vazias, lixo e códigos de tamanho errado', () {
      expect(BastaoTagParser.normalizarLinha(''), isNull);
      expect(BastaoTagParser.normalizarLinha('   '), isNull);
      expect(BastaoTagParser.normalizarLinha('ERRO DE LEITURA'), isNull);
      expect(BastaoTagParser.normalizarLinha('98200012345'), isNull);
      expect(BastaoTagParser.normalizarLinha('98200012345678901234'), isNull);
    });
  });

  group('BastaoTagParser.processarPacote', () {
    late BastaoTagParser parser;

    setUp(() => parser = BastaoTagParser());

    List<int> bytes(String texto) => texto.codeUnits;

    test('emite o código quando a linha termina em CRLF', () {
      expect(
        parser.processarPacote(bytes('982000123456789\r\n')),
        ['982000123456789'],
      );
      expect(parser.pendente, isEmpty);
    });

    test('aguarda o restante quando o pacote quebra no meio da linha', () {
      expect(parser.processarPacote(bytes('9820001')), isEmpty);
      expect(parser.processarPacote(bytes('23456789')), isEmpty);
      expect(
        parser.processarPacote(bytes('\r\n')),
        ['982000123456789'],
      );
    });

    test('emite várias leituras entregues no mesmo pacote', () {
      expect(
        parser.processarPacote(
          bytes('982000123456789\r\n982000987654321\r\n'),
        ),
        ['982000123456789', '982000987654321'],
      );
    });

    test('mantém no buffer a linha ainda incompleta após uma completa', () {
      expect(
        parser.processarPacote(bytes('982000123456789\n98200098')),
        ['982000123456789'],
      );
      expect(parser.pendente, '98200098');
    });

    test('descarta linhas que não contêm código', () {
      expect(
        parser.processarPacote(bytes('READY\r\nERRO\r\n982000123456789\r\n')),
        ['982000123456789'],
      );
    });

    test('ignora pacote vazio', () {
      expect(parser.processarPacote(const []), isEmpty);
    });

    test('limita o tamanho do buffer de linha incompleta', () {
      final parserCurto = BastaoTagParser(maxBufferChars: 32);
      parserCurto.processarPacote(bytes('X' * 200));
      expect(parserCurto.pendente.length, 32);
    });

    test('descarregarPendente consome o trecho sem terminador', () {
      parser.processarPacote(bytes('982000123456789'));
      expect(parser.descarregarPendente(), '982000123456789');
      expect(parser.pendente, isEmpty);
      expect(parser.descarregarPendente(), isNull);
    });

    test('descarregarPendente devolve null quando o trecho não é código', () {
      parser.processarPacote(bytes('98200'));
      expect(parser.descarregarPendente(), isNull);
      expect(parser.pendente, isEmpty);
    });

    test('limpar descarta o trecho pendente', () {
      parser.processarPacote(bytes('98200012'));
      parser.limpar();
      expect(parser.pendente, isEmpty);
      expect(
        parser.processarPacote(bytes('982000123456789\r\n')),
        ['982000123456789'],
      );
    });
  });
}
