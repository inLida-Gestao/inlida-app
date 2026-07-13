import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/flutter_flow/custom_functions.dart' as functions;

void main() {
  group('permitePrevisaoParto', () {
    test('permite estados sem diagnóstico ou com prenhez', () {
      expect(functions.permitePrevisaoParto(null), isTrue);
      expect(functions.permitePrevisaoParto(''), isTrue);
      expect(functions.permitePrevisaoParto('Não diagnosticado'), isTrue);
      expect(functions.permitePrevisaoParto('Prenhez'), isTrue);
    });

    test('bloqueia diagnósticos sem previsão de parto', () {
      expect(functions.permitePrevisaoParto('Absorção'), isFalse);
      expect(functions.permitePrevisaoParto('Aborto'), isFalse);
      expect(functions.permitePrevisaoParto('Natimorto'), isFalse);
      expect(functions.permitePrevisaoParto('Vazio'), isFalse);
    });

    test('normaliza espaços ao redor do diagnóstico', () {
      expect(functions.permitePrevisaoParto('  Prenhez  '), isTrue);
      expect(functions.permitePrevisaoParto('  Vazio  '), isFalse);
    });
  });
}
