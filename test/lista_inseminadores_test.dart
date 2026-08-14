import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/backend/sqlite/queries/read.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database database;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute('''
CREATE TABLE local_reproducao (
  id_propriedade TEXT,
  inseminador TEXT,
  deletado TEXT
)
''');
  });

  tearDown(() => database.close());

  test('lista somente inseminadores ativos da propriedade', () async {
    const propriedade = "fazenda d'agua";
    final registros = <Map<String, Object?>>[
      {
        'id_propriedade': propriedade,
        'inseminador': '  BRUNO  ',
        'deletado': 'NAO',
      },
      {
        'id_propriedade': propriedade,
        'inseminador': 'ana',
        'deletado': 'NAO',
      },
      {
        'id_propriedade': propriedade,
        'inseminador': 'ANA',
        'deletado': 'NAO',
      },
      {
        'id_propriedade': propriedade,
        'inseminador': 'CARLOS',
        'deletado': 'SIM',
      },
      {
        'id_propriedade': propriedade,
        'inseminador': null,
        'deletado': 'NAO',
      },
      {
        'id_propriedade': propriedade,
        'inseminador': '',
        'deletado': 'NAO',
      },
      {
        'id_propriedade': propriedade,
        'inseminador': '   ',
        'deletado': 'NAO',
      },
      {
        'id_propriedade': propriedade,
        'inseminador': 'null',
        'deletado': 'NAO',
      },
      {
        'id_propriedade': 'outra-propriedade',
        'inseminador': 'DANIEL',
        'deletado': 'NAO',
      },
    ];

    for (final registro in registros) {
      await database.insert('local_reproducao', registro);
    }

    final resultado = await performListaInseminadores(
      database,
      propriedade: propriedade,
    );

    expect(resultado.map((row) => row.inseminador).toList(), ['ANA', 'BRUNO']);
  });
}
