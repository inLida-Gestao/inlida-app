import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Espelha a cláusula de `performBuscarReproducoesRebanho`
/// (lib/backend/sqlite/queries/read.dart), que é montada por interpolação.
///
/// Regra, igual à da web (`inlida-web/lib/pg_rebanho/pg_rebanho_view/`):
/// fêmea vê as reproduções em que é MATRIZ; macho vê as em que é REPRODUTOR.
Future<List<Map<String, Object?>>> _reproducoesDaFicha(
  Database database,
  String idRebanho,
) {
  final sexo =
      "(SELECT sexo FROM local_rebanho WHERE idRebanho = '$idRebanho' LIMIT 1)";
  final prop =
      "(SELECT idPropriedade FROM local_rebanho WHERE idRebanho = '$idRebanho' LIMIT 1)";
  return database.rawQuery('''
SELECT lr.* FROM local_reproducao lr
WHERE CASE WHEN $sexo = 'Macho'
           THEN lr.id_rebanho_reprodutor = '$idRebanho'
           ELSE lr.id_rebanho_matriz = '$idRebanho'
      END
AND ($prop IS NULL OR lr.id_propriedade = $prop)
AND COALESCE(lr.deletado, 'NAO') != 'SIM'
ORDER BY lr.id_reproducao ASC
''');
}

void main() {
  late Database database;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute('''
CREATE TABLE local_rebanho (
  idRebanho TEXT PRIMARY KEY,
  idPropriedade TEXT,
  numeroAnimal TEXT,
  sexo TEXT,
  deletado TEXT
)
''');
    await database.execute('''
CREATE TABLE local_reproducao (
  id_reproducao TEXT PRIMARY KEY,
  id_propriedade TEXT,
  id_rebanho_matriz TEXT,
  id_rebanho_reprodutor TEXT,
  deletado TEXT
)
''');
  });

  tearDown(() => database.close());

  Future<void> animal(String id, String sexo,
          {String propriedade = 'prop-1'}) =>
      database.insert('local_rebanho', {
        'idRebanho': id,
        'idPropriedade': propriedade,
        'numeroAnimal': id,
        'sexo': sexo,
        'deletado': 'NAO',
      });

  Future<void> reproducao(
    String id, {
    required String matriz,
    String? reprodutor,
    String propriedade = 'prop-1',
    String deletado = 'NAO',
  }) =>
      database.insert('local_reproducao', {
        'id_reproducao': id,
        'id_propriedade': propriedade,
        'id_rebanho_matriz': matriz,
        'id_rebanho_reprodutor': reprodutor,
        'deletado': deletado,
      });

  Future<List<String?>> ids(String idRebanho) async =>
      (await _reproducoesDaFicha(database, idRebanho))
          .map((r) => r['id_reproducao'] as String?)
          .toList();

  test('fêmea vê só as reproduções em que é matriz', () async {
    await animal('vaca', 'Fêmea');
    await animal('touro', 'Macho');
    await reproducao('r1', matriz: 'vaca', reprodutor: 'touro');
    await reproducao('r2', matriz: 'vaca', reprodutor: 'touro');
    // Reprodução de outra matriz — não é dela.
    await animal('outra', 'Fêmea');
    await reproducao('r3', matriz: 'outra', reprodutor: 'touro');

    expect(await ids('vaca'), ['r1', 'r2']);
  });

  test('macho vê só as reproduções em que é reprodutor', () async {
    await animal('touro', 'Macho');
    await animal('vaca1', 'Fêmea');
    await animal('vaca2', 'Fêmea');
    await reproducao('r1', matriz: 'vaca1', reprodutor: 'touro');
    await reproducao('r2', matriz: 'vaca2', reprodutor: 'touro');
    // Anomalia de dado: macho registrado como matriz. Não deve aparecer.
    await reproducao('r3', matriz: 'touro', reprodutor: 'outro');

    expect(await ids('touro'), ['r1', 'r2']);
  });

  test('regressão FAZ BARREIRINHO: fêmea usada como reprodutor', () async {
    // Amandha (nº 02, Fêmea) tinha 1 reprodução própria e figurava como
    // reprodutor em 88 de outras matrizes. O `OR` antigo exibia as 88.
    await animal('amandha', 'Fêmea');
    await reproducao('propria', matriz: 'amandha', reprodutor: 'touro');
    for (var i = 0; i < 88; i++) {
      await animal('m$i', 'Fêmea');
      await reproducao('alheia$i', matriz: 'm$i', reprodutor: 'amandha');
    }

    expect(await ids('amandha'), ['propria']);
  });

  test('não traz reprodução de outra propriedade', () async {
    await animal('vaca', 'Fêmea', propriedade: 'prop-1');
    await reproducao('dela', matriz: 'vaca', propriedade: 'prop-1');
    await reproducao('outra_prop', matriz: 'vaca', propriedade: 'prop-2');

    expect(await ids('vaca'), ['dela']);
  });

  test('animal sem sexo cai em matriz', () async {
    await animal('sem_sexo', '');
    await reproducao('como_matriz', matriz: 'sem_sexo');
    await reproducao('como_reprodutor', matriz: 'outra', reprodutor: 'sem_sexo');

    expect(await ids('sem_sexo'), ['como_matriz']);
  });

  test('animal inexistente não quebra e cai em matriz sem filtro de propriedade',
      () async {
    await reproducao('orfa', matriz: 'fantasma', propriedade: 'prop-9');

    expect(await ids('fantasma'), ['orfa']);
  });

  test('reprodução deletada não aparece', () async {
    await animal('vaca', 'Fêmea');
    await reproducao('viva', matriz: 'vaca');
    await reproducao('morta', matriz: 'vaca', deletado: 'SIM');

    expect(await ids('vaca'), ['viva']);
  });
}
