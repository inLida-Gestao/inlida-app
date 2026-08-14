import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:in_lida/backend/utils/rebanho_natural_sort.dart';

void main() {
  late Database database;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute('''
CREATE TABLE local_rebanho (
  idRebanho TEXT PRIMARY KEY,
  idPropriedade TEXT,
  tipo TEXT,
  numeroAnimal TEXT,
  numeroAnimalSortKey TEXT,
  chip TEXT,
  nome TEXT,
  sexo TEXT,
  categoria TEXT,
  dataNascimento TEXT,
  raca TEXT,
  loteID TEXT,
  loteNome TEXT,
  origem TEXT,
  statusRebanho TEXT,
  deletado TEXT,
  created_at TEXT
)
''');
  });

  tearDown(() => database.close());

  test('gera chaves naturais sem converter números para int', () {
    final key2 = buildRebanhoNumeroSortKey('2');
    final key13 = buildRebanhoNumeroSortKey('13');
    final key100 = buildRebanhoNumeroSortKey('100');
    final keyA2 = buildRebanhoNumeroSortKey('A2');
    final keyA10 = buildRebanhoNumeroSortKey('a10');
    final veryLargeKey = buildRebanhoNumeroSortKey(
      '999999999999999999999999999999',
    );

    expect(key2.compareTo(key13), lessThan(0));
    expect(key13.compareTo(key100), lessThan(0));
    expect(key100.compareTo(keyA2), lessThan(0));
    expect(keyA2.compareTo(keyA10), lessThan(0));
    expect(keyA2, buildRebanhoNumeroSortKey(' a02 '));
    expect(buildRebanhoNumeroSortKey(null).compareTo(keyA10), greaterThan(0));
    expect(veryLargeKey, isNotEmpty);
  });

  test('ordena globalmente antes do limite e do offset', () async {
    const numbers = [
      '1',
      '10',
      '100',
      '13',
      '2',
      '02',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '11',
      '12',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      'A2',
      'A10',
      '',
    ];

    for (var index = 0; index < numbers.length; index++) {
      final number = numbers[index];
      await database.insert('local_rebanho', {
        'idRebanho': 'animal-${index.toString().padLeft(2, '0')}',
        'idPropriedade': 'property-1',
        'numeroAnimal': number,
        'numeroAnimalSortKey': buildRebanhoNumeroSortKey(number),
        'deletado': 'NAO',
      });
    }

    final firstPage = await _queryRebanhoByNumero(
      database,
      limit: 20,
      offset: 0,
    );
    final secondPage = await _queryRebanhoByNumero(
      database,
      limit: 20,
      offset: 20,
    );

    final orderedNumbers = [
      ...firstPage.map((row) => row['numeroAnimal'] as String?),
      ...secondPage.map((row) => row['numeroAnimal'] as String?),
    ];

    expect(orderedNumbers, [
      '1',
      '2',
      '02',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '100',
      'A2',
      'A10',
      '',
    ]);
    expect(firstPage.length, 20);
    expect(secondPage.length, 5);

    final popupRows = await _queryRebanhoByNumero(
      database,
      limit: numbers.length,
      offset: 0,
    );
    expect(
      popupRows.map((row) => row['numeroAnimal'] as String?).toList(),
      orderedNumbers,
    );
  });
}

Future<List<Map<String, Object?>>> _queryRebanhoByNumero(
  Database database, {
  required int limit,
  required int offset,
}) {
  return database.rawQuery('''
SELECT idRebanho, numeroAnimal
FROM local_rebanho
WHERE idPropriedade = 'property-1'
AND deletado = 'NAO'
ORDER BY
  CASE WHEN numeroAnimal IS NULL OR TRIM(numeroAnimal) = '' OR numeroAnimal = 'null' THEN 1 ELSE 0 END,
  CASE WHEN numeroAnimalSortKey IS NULL OR numeroAnimalSortKey = '' THEN 1 ELSE 0 END,
  numeroAnimalSortKey ASC,
  LENGTH(TRIM(numeroAnimal)) ASC,
  TRIM(numeroAnimal) COLLATE NOCASE ASC,
  idRebanho ASC
LIMIT ? OFFSET ?
''', [limit, offset]);
}
