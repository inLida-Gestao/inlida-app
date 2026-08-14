import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:in_lida/backend/sqlite/queries/update.dart';

void main() {
  late Database database;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute('''
CREATE TABLE local_rebanho (
  idRebanho TEXT PRIMARY KEY,
  numeroAnimal TEXT,
  numeroAnimalSortKey TEXT,
  chip TEXT,
  codRegistro TEXT,
  nome TEXT,
  sexo TEXT,
  categoria TEXT,
  dataNascimento TEXT,
  pesoNascimento REAL,
  porte TEXT,
  raca TEXT,
  dataEntradaLote TEXT,
  dataDesmama TEXT,
  pesoDesmama REAL,
  statusRebanho TEXT,
  origem TEXT,
  anotacoes TEXT,
  dataAcao TEXT,
  valorCompra REAL,
  nomeConcat TEXT,
  updated_at TEXT,
  loteNome TEXT,
  loteID TEXT,
  movimentacao_entrada TEXT,
  dataVenda TEXT,
  valorVenda REAL,
  numeroMatriz TEXT,
  nomeMatriz TEXT,
  dataNascMatriz TEXT,
  racaMatriz TEXT,
  numeroReprodutor TEXT,
  nomeReprodutor TEXT,
  dataNascReprodutor TEXT,
  racaReprodutor TEXT,
  movimentacao_saida TEXT,
  data_morte TEXT,
  motivo_morte TEXT,
  categoria_matriz TEXT,
  rebanhoIdMatriz TEXT,
  rebanhoIdReprodutor TEXT,
  sync_lote_dirty INTEGER NOT NULL DEFAULT 0,
  sync_dirty INTEGER NOT NULL DEFAULT 0,
  sync_op TEXT,
  sync_updated_at TEXT
)
''');
    await database.insert('local_rebanho', {
      'idRebanho': 'animal-1',
      'numeroAnimal': '1',
      'statusRebanho': 'Na propriedade',
    });
  });

  tearDown(() => database.close());

  test('salva status Morto e marca o animal para sincronizacao', () async {
    final updated = await performUPDTRebanho(
      database,
      idRebanho: 'animal-1',
      numeroAnimal: '1',
      statusRebanho: 'Morto',
      datamorte: '2026-07-28',
      motivomorte: 'DOENÇA',
      updatedat: '2026-07-28 12:00:00',
    );

    expect(updated, 1);
    final row = (await database.query(
      'local_rebanho',
      where: 'idRebanho = ?',
      whereArgs: ['animal-1'],
    ))
        .single;

    expect(row['statusRebanho'], 'Morto');
    expect(row['data_morte'], '2026-07-28');
    expect(row['motivo_morte'], 'DOENÇA');
    expect(row['sync_dirty'], 1);
    expect(row['sync_op'], 'update');
  });
}
