import 'package:flutter_test/flutter_test.dart';

/// `ressinc` NÃO é um campo Sim/Não: guarda o TIPO do protocolo de
/// ressincronização, ou null quando a reprodução não é uma ressincronização.
///
/// Versões anteriores montavam o payload com `nullableStr(raw['ressinc']) ??
/// 'NAO'` (padrão copiado de `parida`), gravando 'NAO' em toda reprodução sem
/// protocolo. Como a coluna foi adicionada depois, a maioria dos registros
/// tinha `ressinc` nulo — e o dashboard web considera "tem ressinc" qualquer
/// valor não vazio, marcando TODAS as reproduções como ressincronizadas.
///
/// Esta é a mesma normalização aplicada em `_buildReproducaoPayload`
/// (lib/actions/actions.dart). Mantida aqui como contrato executável.
String? normalizeRessinc(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim().toLowerCase();
  if (s.isEmpty || s == 'null' || s == '-') return null;
  if (s == 'tradicional') return 'Tradicional';
  if (s == 'precoce') return 'Precoce';
  if (s == 'superprecoce') return 'Superprecoce';
  return null;
}

void main() {
  group('normalizeRessinc — ausência de protocolo vira null', () {
    test('null continua null (nunca vira "NAO")', () {
      expect(normalizeRessinc(null), isNull);
    });

    test('string vazia e literal "null" viram null', () {
      expect(normalizeRessinc(''), isNull);
      expect(normalizeRessinc('   '), isNull);
      expect(normalizeRessinc('null'), isNull);
      expect(normalizeRessinc('-'), isNull);
    });

    test('valor inválido "NAO" gravado por versões antigas é limpo', () {
      expect(normalizeRessinc('NAO'), isNull,
          reason: 'Precisa virar null para limpar os registros já poluídos no '
              'Supabase que aparecem marcados como ressincronizados.');
      expect(normalizeRessinc('Não'), isNull);
      expect(normalizeRessinc('NÃO'), isNull);
      expect(normalizeRessinc('Sim'), isNull);
    });
  });

  group('normalizeRessinc — protocolos válidos são preservados', () {
    test('aceita os três protocolos do dropdown', () {
      expect(normalizeRessinc('Tradicional'), 'Tradicional');
      expect(normalizeRessinc('Precoce'), 'Precoce');
      expect(normalizeRessinc('Superprecoce'), 'Superprecoce');
    });

    test('normaliza caixa e espaços', () {
      expect(normalizeRessinc('tradicional'), 'Tradicional');
      expect(normalizeRessinc('  PRECOCE  '), 'Precoce');
      expect(normalizeRessinc('superPRECOCE'), 'Superprecoce');
    });
  });
}
