import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/flutter_flow/custom_functions.dart' as functions;

void main() {
  group('normalizarDataOpcional', () {
    test('retorna null quando o campo não foi informado', () {
      expect(functions.normalizarDataOpcional(null), isNull);
      expect(functions.normalizarDataOpcional(''), isNull);
      expect(functions.normalizarDataOpcional('   '), isNull);
    });

    test('retorna null para o literal "null" (bug histórico de interpolação)',
        () {
      expect(functions.normalizarDataOpcional('null'), isNull);
    });

    test('retorna null quando a string não é uma data válida', () {
      expect(functions.normalizarDataOpcional('não é uma data'), isNull);
    });

    test('preserva uma data válida', () {
      expect(functions.normalizarDataOpcional('2024-05-10'), '2024-05-10');
    });
  });
}
