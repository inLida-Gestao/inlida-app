import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/backend/schema/structs/rebanho_struct.dart';
import 'package:in_lida/main.dart';
import 'package:in_lida/lotes/view_lote/view_lote_widget.dart';

void main() {
  test('MyApp can be constructed without initializing external services', () {
    expect(const MyApp(), isA<MyApp>());
  });

  test('resumo de categorias mantém todas as categorias em lote vazio', () {
    final resumo = buildLoteCategoriaResumo(const []);

    expect(resumo, hasLength(10));
    expect(resumo.every((item) => item.quantidade == 0), isTrue);
    expect(resumo.every((item) => item.proporcao == 0), isTrue);
    expect(resumo.first.categoria, 'Bezerra');
    expect(resumo.last.categoria, 'Vaca primípara');
  });

  test('resumo de categorias conta animais e calcula proporção do lote', () {
    final animais = [
      RebanhoStruct(categoria: 'Vaca Multipara'),
      RebanhoStruct(categoria: 'vaca multípara'),
      RebanhoStruct(categoria: 'Garrote'),
      RebanhoStruct(categoria: 'Touro'),
    ];

    final resumo = buildLoteCategoriaResumo(animais);
    final porCategoria = {
      for (final item in resumo) item.categoria: item,
    };

    expect(porCategoria['Vaca multípara']?.quantidade, 2);
    expect(porCategoria['Vaca multípara']?.proporcao, 0.5);
    expect(porCategoria['Garrote']?.quantidade, 1);
    expect(porCategoria['Garrote']?.proporcao, 0.25);
    expect(porCategoria['Touro']?.quantidade, 1);
    expect(porCategoria['Bezerro']?.quantidade, 0);
  });
}
