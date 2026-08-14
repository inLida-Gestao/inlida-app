import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:in_lida/backend/sqlite/queries/read.dart';

/// Cobre o filtro e a ordenação por `dataUltimaPesagem` no módulo de rebanho.
///
/// A coluna guarda datas puras (`yyyy-MM-dd`) e tem três formas de "sem
/// pesagem": `NULL`, string vazia e o literal `'null'` deixado pelos INSERTs
/// legados — todas precisam ficar de fora quando o filtro está ativo.
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
  dataUltimaPesagem TEXT,
  raca TEXT,
  loteID TEXT,
  loteNome TEXT,
  origem TEXT,
  statusRebanho TEXT,
  deletado TEXT,
  created_at TEXT
)
''');

    const animais = <List<Object?>>[
      ['a-01', '2026-01-10'],
      ['a-02', '2026-02-20'],
      ['a-03', '2026-03-30'],
      ['a-04', null],
      ['a-05', ''],
      ['a-06', 'null'],
    ];

    for (var index = 0; index < animais.length; index++) {
      await database.insert('local_rebanho', {
        'idRebanho': animais[index][0],
        'idPropriedade': 'property-1',
        'numeroAnimal': '${index + 1}',
        'dataUltimaPesagem': animais[index][1],
        'statusRebanho': 'Na propriedade',
        'deletado': 'NAO',
        'created_at': '2026-01-0${index + 1}',
      });
    }
  });

  tearDown(() => database.close());

  Future<List<String>> buscar({
    String dataUltPesagemInicio = '',
    String dataUltPesagemFim = '',
  }) async {
    final rows = await performBuscaRebanhoPaginada(
      database,
      idPropriedade: 'property-1',
      limitReb: 100,
      offsetReb: 0,
      sexo: '',
      categoria: '',
      raca: '',
      origem: '',
      loteId: '',
      statusReb: '',
      dataNascInicio: '',
      dataNascFim: '',
      dataUltPesagemInicio: dataUltPesagemInicio,
      dataUltPesagemFim: dataUltPesagemFim,
    );
    return rows.map((row) => row.idRebanho!).toList()..sort();
  }

  Future<List<String?>> ordenar(String direcao) async {
    final rows = await performRebanhoPagOrdPesagem<Map<String, dynamic>>(
      database,
      (data) => data,
      idPropriedade: 'property-1',
      limitReb: 100,
      offsetReb: 0,
      sexo: '',
      categoria: '',
      raca: '',
      origem: '',
      loteId: '',
      statusReb: '',
      dataNascInicio: '',
      dataNascFim: '',
      dataUltPesagemInicio: '',
      dataUltPesagemFim: '',
      ordenacaoDirecao: direcao,
    );
    return rows.map((row) => row['idRebanho'] as String?).toList();
  }

  test('sem filtro retorna todos os animais, inclusive os nunca pesados',
      () async {
    expect(await buscar(), ['a-01', 'a-02', 'a-03', 'a-04', 'a-05', 'a-06']);
  });

  test('filtra pelo intervalo e inclui os limites', () async {
    expect(
      await buscar(
        dataUltPesagemInicio: '2026-01-10',
        dataUltPesagemFim: '2026-03-30',
      ),
      ['a-01', 'a-02', 'a-03'],
    );
    expect(
      await buscar(
        dataUltPesagemInicio: '2026-02-20',
        dataUltPesagemFim: '2026-02-20',
      ),
      ['a-02'],
    );
  });

  test('aceita apenas a data inicial ou apenas a data final', () async {
    expect(
      await buscar(dataUltPesagemInicio: '2026-02-20'),
      ['a-02', 'a-03'],
    );
    expect(
      await buscar(dataUltPesagemFim: '2026-02-20'),
      ['a-01', 'a-02'],
    );
  });

  test(
      'exclui NULL, string vazia e o literal "null" quando o filtro está ativo',
      () async {
    final resultado = await buscar(dataUltPesagemInicio: '1900-01-01');
    expect(resultado, ['a-01', 'a-02', 'a-03']);
    expect(resultado, isNot(contains('a-04')));
    expect(resultado, isNot(contains('a-05')));
    expect(resultado, isNot(contains('a-06')));
  });

  test('ordena crescente e decrescente mantendo os sem pesagem no fim',
      () async {
    expect(
      (await ordenar('crescente')).take(3).toList(),
      ['a-01', 'a-02', 'a-03'],
    );
    expect(
      (await ordenar('decrescente')).take(3).toList(),
      ['a-03', 'a-02', 'a-01'],
    );

    for (final direcao in ['crescente', 'decrescente']) {
      final semPesagem = (await ordenar(direcao)).skip(3).toList()..sort();
      expect(semPesagem, ['a-04', 'a-05', 'a-06'],
          reason: 'animais sem pesagem devem ficar no fim ($direcao)');
    }
  });

  test('direção não reconhecida cai no ascendente', () async {
    expect(await ordenar(''), await ordenar('crescente'));
  });
}
