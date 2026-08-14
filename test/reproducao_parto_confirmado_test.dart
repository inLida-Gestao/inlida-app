import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/flutter_flow/custom_functions.dart' as functions;

void main() {
  group('parto confirmado', () {
    test('aceita variantes legadas de SIM', () {
      expect(functions.partoConfirmado('SIM'), isTrue);
      expect(functions.partoConfirmado('Sim'), isTrue);
      expect(functions.partoConfirmado(' sim '), isTrue);
      expect(functions.partoConfirmado('NAO'), isFalse);
      expect(functions.partoConfirmado(null), isFalse);
    });

    test('normaliza o contrato enviado ao banco', () {
      expect(functions.normalizarParida(true), 'SIM');
      expect(functions.normalizarParida(false), 'NAO');
    });

    test('reconhece data de parto valida para dados legados', () {
      expect(functions.temDataParto('2026-07-21'), isTrue);
      expect(functions.temDataParto('2026-02-30'), isFalse);
      expect(functions.temDataParto('-'), isFalse);
      expect(functions.temDataParto(null), isFalse);
      expect(functions.exibirPartoConfirmado('NAO', '2026-07-21'), isTrue);
      expect(functions.exibirPartoConfirmado('NAO', null), isFalse);
    });
  });

  group('reprodutor obrigatório', () {
    test('exige um identificador de rebanho válido', () {
      expect(functions.temReprodutorSelecionado('reprodutor-123'), isTrue);
      expect(functions.temReprodutorSelecionado('  reprodutor-123  '), isTrue);
      expect(functions.temReprodutorSelecionado(null), isFalse);
      expect(functions.temReprodutorSelecionado(''), isFalse);
      expect(functions.temReprodutorSelecionado('null'), isFalse);
      expect(functions.temReprodutorSelecionado('-'), isFalse);
    });
  });

  group('matriz obrigatória', () {
    test('exige um identificador de matriz válido', () {
      expect(functions.temMatrizSelecionada('matriz-123'), isTrue);
      expect(functions.temMatrizSelecionada('  matriz-123  '), isTrue);
      expect(functions.temMatrizSelecionada(null), isFalse);
      expect(functions.temMatrizSelecionada(''), isFalse);
      expect(functions.temMatrizSelecionada('null'), isFalse);
      expect(functions.temMatrizSelecionada('-'), isFalse);
    });
  });
}
