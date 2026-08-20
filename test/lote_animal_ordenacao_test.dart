import 'package:flutter_test/flutter_test.dart';

import 'package:in_lida/backend/utils/lote_animal_sort.dart';

class _Animal {
  const _Animal({this.numero, this.nascimento, this.createdAt});

  final String? numero;
  final String? nascimento;
  final String? createdAt;
}

void main() {
  test('ordena por número naturalmente (2 < 13 < 100, A2 < A10)', () {
    final animais = [
      const _Animal(numero: '100'),
      const _Animal(numero: '13'),
      const _Animal(numero: '2'),
      const _Animal(numero: 'A10'),
      const _Animal(numero: 'A2'),
    ];

    final sorted = sortAnimaisLote(
      animais,
      numeroOf: (e) => e.numero,
      nascimentoOf: (e) => e.nascimento,
      tipo: 'numero',
      direcao: 'crescente',
    );

    expect(
        sorted.map((e) => e.numero).toList(), ['2', '13', '100', 'A2', 'A10']);
  });

  test('ordem decrescente inverte a ordem numérica natural', () {
    final animais = [
      const _Animal(numero: '2'),
      const _Animal(numero: '13'),
      const _Animal(numero: '100'),
    ];

    final sorted = sortAnimaisLote(
      animais,
      numeroOf: (e) => e.numero,
      nascimentoOf: (e) => e.nascimento,
      tipo: 'numero',
      direcao: 'decrescente',
    );

    expect(sorted.map((e) => e.numero).toList(), ['100', '13', '2']);
  });

  test('animais sem número ficam por último em ambas as direções', () {
    final animais = [
      const _Animal(numero: null),
      const _Animal(numero: '5'),
      const _Animal(numero: ''),
      const _Animal(numero: '1'),
      const _Animal(numero: 'null'),
    ];

    final crescente = sortAnimaisLote(
      animais,
      numeroOf: (e) => e.numero,
      nascimentoOf: (e) => e.nascimento,
      tipo: 'numero',
      direcao: 'crescente',
    );
    final decrescente = sortAnimaisLote(
      animais,
      numeroOf: (e) => e.numero,
      nascimentoOf: (e) => e.nascimento,
      tipo: 'numero',
      direcao: 'decrescente',
    );

    expect(crescente.map((e) => e.numero).take(2).toList(), ['1', '5']);
    expect(decrescente.map((e) => e.numero).take(2).toList(), ['5', '1']);
    expect(
        crescente.skip(2).every(
            (e) => e.numero == null || e.numero == '' || e.numero == 'null'),
        isTrue);
    expect(
        decrescente.skip(2).every(
            (e) => e.numero == null || e.numero == '' || e.numero == 'null'),
        isTrue);
  });

  test('ordena por data de nascimento (ISO yyyy-MM-dd)', () {
    final animais = [
      const _Animal(nascimento: '2023-05-10'),
      const _Animal(nascimento: '2020-01-01'),
      const _Animal(nascimento: '2022-12-31'),
    ];

    final crescente = sortAnimaisLote(
      animais,
      numeroOf: (e) => e.numero,
      nascimentoOf: (e) => e.nascimento,
      tipo: 'nascimento',
      direcao: 'crescente',
    );
    final decrescente = sortAnimaisLote(
      animais,
      numeroOf: (e) => e.numero,
      nascimentoOf: (e) => e.nascimento,
      tipo: 'nascimento',
      direcao: 'decrescente',
    );

    expect(crescente.map((e) => e.nascimento).toList(),
        ['2020-01-01', '2022-12-31', '2023-05-10']);
    expect(decrescente.map((e) => e.nascimento).toList(),
        ['2023-05-10', '2022-12-31', '2020-01-01']);
  });

  test('sem ordenação, mantém comportamento anterior (createdAt desc)', () {
    final animais = [
      const _Animal(createdAt: '2024-01-01T00:00:00'),
      const _Animal(createdAt: '2024-03-01T00:00:00'),
      const _Animal(createdAt: '2024-02-01T00:00:00'),
    ];

    final sorted = sortAnimaisLote(
      animais,
      numeroOf: (e) => e.numero,
      nascimentoOf: (e) => e.nascimento,
      createdAtOf: (e) => e.createdAt,
      tipo: '',
      direcao: '',
    );

    expect(sorted.map((e) => e.createdAt).toList(), [
      '2024-03-01T00:00:00',
      '2024-02-01T00:00:00',
      '2024-01-01T00:00:00',
    ]);
  });
}
