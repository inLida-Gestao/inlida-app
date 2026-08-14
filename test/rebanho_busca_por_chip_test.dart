import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:in_lida/backend/sqlite/queries/read.dart';
import 'package:in_lida/backend/utils/rebanho_status_utils.dart';

const String kPropriedade = 'prop-1';

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
  nome TEXT,
  sexo TEXT,
  categoria TEXT,
  raca TEXT,
  loteNome TEXT,
  chip TEXT,
  statusRebanho TEXT,
  deletado TEXT
)
''');
  });

  tearDown(() => database.close());

  Future<void> inserir({
    required String idRebanho,
    required String chip,
    String status = defaultRebanhoStatus,
    String deletado = 'NAO',
    String idPropriedade = kPropriedade,
  }) {
    return database.insert('local_rebanho', {
      'idRebanho': idRebanho,
      'idPropriedade': idPropriedade,
      'chip': chip,
      'statusRebanho': status,
      'deletado': deletado,
      'numeroAnimal': '001',
      'nome': 'Animal $idRebanho',
    });
  }

  Future<String?> buscar(String chip, {String? status}) async {
    final row = await performBuscarRebanhoPorChip(
      database,
      idPropriedade: kPropriedade,
      chip: chip,
      statusRebanho: status,
    );
    return row?['idRebanho'] as String?;
  }

  test('sem filtro de status encontra animal de qualquer status', () async {
    await inserir(idRebanho: 'a1', chip: '982000123', status: 'Vendido');

    expect(await buscar('982000123'), 'a1');
  });

  test('com filtro só encontra animal "Na propriedade"', () async {
    await inserir(idRebanho: 'a1', chip: '982000123', status: 'Vendido');

    expect(await buscar('982000123', status: defaultRebanhoStatus), isNull);
  });

  test('com filtro encontra o animal ativo na propriedade', () async {
    await inserir(idRebanho: 'a1', chip: '982000123');

    expect(await buscar('982000123', status: defaultRebanhoStatus), 'a1');
  });

  test('ignora animais deletados mesmo com o status correto', () async {
    await inserir(idRebanho: 'a1', chip: '982000123', deletado: 'SIM');

    expect(await buscar('982000123', status: defaultRebanhoStatus), isNull);
  });

  test('normaliza espaços, pontos e hífens do chip gravado', () async {
    await inserir(idRebanho: 'a1', chip: '982.000-123 ');

    expect(await buscar('982000123', status: defaultRebanhoStatus), 'a1');
  });

  test('não vaza animais de outra propriedade', () async {
    await inserir(
      idRebanho: 'a1',
      chip: '982000123',
      idPropriedade: 'prop-2',
    );

    expect(await buscar('982000123', status: defaultRebanhoStatus), isNull);
  });

  test('retorna null para chip vazio', () async {
    await inserir(idRebanho: 'a1', chip: '982000123');

    expect(await buscar('   ', status: defaultRebanhoStatus), isNull);
  });
}
