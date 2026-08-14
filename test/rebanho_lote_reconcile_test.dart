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
  loteID TEXT,
  loteNome TEXT,
  dataEntradaLote TEXT,
  updated_at TEXT,
  dataVenda TEXT,
  valorVenda REAL,
  statusRebanho TEXT,
  sync_lote_dirty INTEGER NOT NULL DEFAULT 0,
  sync_dirty INTEGER NOT NULL DEFAULT 0,
  sync_op TEXT,
  sync_updated_at TEXT
)
''');
  });

  tearDown(() => database.close());

  test('reconcilia lote e nao remove animal transferido durante a edicao',
      () async {
    await database.insert('local_rebanho', {
      'idRebanho': 'aplicar',
      'loteID': null,
      'loteNome': null,
      'statusRebanho': 'Ativo',
    });
    await database.insert('local_rebanho', {
      'idRebanho': 'remover',
      'loteID': 'lote-atual',
      'loteNome': 'Lote atual',
      'statusRebanho': 'Ativo',
    });
    await database.insert('local_rebanho', {
      'idRebanho': 'transferido',
      'loteID': 'outro-lote',
      'loteNome': 'Outro lote',
      'statusRebanho': 'Ativo',
    });

    await performReconcileRebanhoLote(
      database,
      appliedIds: ['aplicar'],
      removedIds: ['remover', 'transferido'],
      loteNome: 'Lote novo',
      loteID: 'lote-atual',
      updatedat: '2026-01-01 10:00:00',
      dataEntradaLote: '2026-01-01 10:00:00',
      vendido: false,
    );

    final rows = await database.query(
      'local_rebanho',
      orderBy: 'idRebanho ASC',
    );
    expect(rows[0]['loteID'], 'lote-atual');
    expect(rows[0]['sync_lote_dirty'], 1);
    expect(rows[1]['loteID'], isNull);
    expect(rows[2]['loteID'], 'outro-lote');
  });

  test('venda preserva o vinculo do animal com o lote', () async {
    await database.insert('local_rebanho', {
      'idRebanho': 'vendido',
      'loteID': 'lote-atual',
      'loteNome': 'Lote atual',
      'statusRebanho': 'Ativo',
    });

    await performReconcileRebanhoLote(
      database,
      appliedIds: ['vendido'],
      removedIds: const [],
      loteNome: 'Lote atual',
      loteID: 'lote-atual',
      updatedat: '2026-01-01 10:00:00',
      dataEntradaLote: '2026-01-01 10:00:00',
      vendido: true,
      dataVenda: '2026-01-02',
      valorVenda: 1500,
    );

    final row = (await database.query('local_rebanho')).single;
    expect(row['loteID'], 'lote-atual');
    expect(row['statusRebanho'], 'Vendido');
    expect(row['dataVenda'], '2026-01-02');
    expect(row['sync_lote_dirty'], 1);
  });

  test(
      'reporta appliedMissing/removedMissing quando o UPDATE nao afeta nenhuma linha',
      () async {
    await database.insert('local_rebanho', {
      'idRebanho': 'existente',
      'loteID': null,
      'loteNome': null,
      'statusRebanho': 'Ativo',
    });
    await database.insert('local_rebanho', {
      'idRebanho': 'ja-transferido',
      'loteID': 'outro-lote',
      'loteNome': 'Outro lote',
      'statusRebanho': 'Ativo',
    });

    final result = await performReconcileRebanhoLote(
      database,
      // 'inexistente' não existe na tabela local — o UPDATE não afeta
      // nenhuma linha (ex.: animal removido entre a seleção na UI e a
      // gravação).
      appliedIds: ['existente', 'inexistente'],
      // 'ja-transferido' está em outro lote — a cláusula `AND loteID = ?`
      // não casa, então a remoção não afeta nenhuma linha (perda silenciosa
      // que motivou esta melhoria).
      removedIds: ['ja-transferido'],
      loteNome: 'Lote novo',
      loteID: 'lote-atual',
      updatedat: '2026-01-01 10:00:00',
      dataEntradaLote: '2026-01-01 10:00:00',
      vendido: false,
    );

    expect(result.hasMissing, isTrue);
    expect(result.appliedMissing, ['inexistente']);
    expect(result.removedMissing, ['ja-transferido']);
  });

  test('nao reporta missing quando todos os UPDATEs afetam alguma linha',
      () async {
    await database.insert('local_rebanho', {
      'idRebanho': 'a',
      'loteID': null,
      'loteNome': null,
      'statusRebanho': 'Ativo',
    });
    await database.insert('local_rebanho', {
      'idRebanho': 'b',
      'loteID': 'lote-atual',
      'loteNome': 'Lote atual',
      'statusRebanho': 'Ativo',
    });

    final result = await performReconcileRebanhoLote(
      database,
      appliedIds: ['a'],
      removedIds: ['b'],
      loteNome: 'Lote novo',
      loteID: 'lote-atual',
      updatedat: '2026-01-01 10:00:00',
      dataEntradaLote: '2026-01-01 10:00:00',
      vendido: false,
    );

    expect(result.hasMissing, isFalse);
    expect(result.appliedMissing, isEmpty);
    expect(result.removedMissing, isEmpty);
  });
}
