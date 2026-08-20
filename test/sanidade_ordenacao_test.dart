import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:in_lida/backend/utils/rebanho_natural_sort.dart';

/// Espelha as cláusulas ORDER BY de `_buscaSanidadeOrdenacaoClause`
/// (lib/backend/sqlite/queries/read.dart), que é privada.
///
/// O ponto central destes testes é que a ordenação acontece no SQL, antes de
/// LIMIT/OFFSET — ordenar a página no cliente daria resultado errado, já que a
/// aba Sanidade pagina de 20 em 20 sobre milhares de registros.
const _dataOuNulo = "CASE WHEN lower(trim(COALESCE(ls.data_sanidade, ''))) "
    "IN ('', 'null') THEN NULL ELSE trim(ls.data_sanidade) END";

const _loteNome = "COALESCE("
    "NULLIF(TRIM(COALESCE(ll.nome, '')), ''), "
    "NULLIF(TRIM(COALESCE(lr.loteNome, '')), ''))";

const _ordenacoes = <String, String>{
  // Padrão (ordenacaoTipo vazio) = mesma cláusula de 'data', com direção DESC.
  '': '''
CASE WHEN $_dataOuNulo IS NULL THEN 1 ELSE 0 END,
  $_dataOuNulo DESC,
  ls.created_at DESC,
  ls.id_sanidade ASC''',
  // 'data' explícito em ordem crescente.
  'data': '''
CASE WHEN $_dataOuNulo IS NULL THEN 1 ELSE 0 END,
  $_dataOuNulo ASC,
  ls.created_at ASC,
  ls.id_sanidade ASC''',
  'numero': '''
CASE WHEN lr.numeroAnimal IS NULL OR TRIM(lr.numeroAnimal) = '' OR lr.numeroAnimal = 'null' THEN 1 ELSE 0 END,
  CASE WHEN lr.numeroAnimalSortKey IS NULL OR lr.numeroAnimalSortKey = '' THEN 1 ELSE 0 END,
  lr.numeroAnimalSortKey ASC,
  ls.id_sanidade ASC''',
  'lote': '''
CASE WHEN $_loteNome IS NULL OR lower($_loteNome) = 'null' THEN 1 ELSE 0 END,
  $_loteNome COLLATE NOCASE ASC,
  ls.id_sanidade ASC''',
};

Future<List<Map<String, Object?>>> _buscaSanidades(
  Database database, {
  required String ordenacaoTipo,
  required int limit,
  required int offset,
}) {
  final orderBy = _ordenacoes[ordenacaoTipo]!;
  return database.rawQuery('''
SELECT ls.id_sanidade, ls.data_sanidade, lr.numeroAnimal, $_loteNome AS lote
FROM local_sanidade ls
LEFT JOIN local_rebanho lr ON ls.id_rebanho = lr.idRebanho
LEFT JOIN local_lotes ll ON ls.id_lote = ll.id_lote
WHERE ls.id_propriedade = 'property-1'
AND COALESCE(ls.deletado, 'NAO') != 'SIM'
ORDER BY $orderBy
LIMIT ? OFFSET ?
''', [limit, offset]);
}

/// Concatena todas as páginas de [pageSize], como o usuário faria clicando no
/// paginador, e devolve a coluna [campo] na ordem final.
Future<List<Object?>> _todasAsPaginas(
  Database database, {
  required String ordenacaoTipo,
  required String campo,
  int pageSize = 3,
}) async {
  final valores = <Object?>[];
  for (var offset = 0;; offset += pageSize) {
    final pagina = await _buscaSanidades(
      database,
      ordenacaoTipo: ordenacaoTipo,
      limit: pageSize,
      offset: offset,
    );
    if (pagina.isEmpty) break;
    valores.addAll(pagina.map((row) => row[campo]));
    if (pagina.length < pageSize) break;
  }
  return valores;
}

void main() {
  late Database database;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute('''
CREATE TABLE local_sanidade (
  id_sanidade TEXT PRIMARY KEY,
  id_propriedade TEXT,
  id_rebanho TEXT,
  id_lote TEXT,
  data_sanidade TEXT,
  deletado TEXT,
  created_at TEXT
)
''');
    await database.execute('''
CREATE TABLE local_rebanho (
  idRebanho TEXT PRIMARY KEY,
  numeroAnimal TEXT,
  numeroAnimalSortKey TEXT,
  loteNome TEXT
)
''');
    await database.execute('''
CREATE TABLE local_lotes (
  id_lote TEXT PRIMARY KEY,
  nome TEXT
)
''');
  });

  tearDown(() => database.close());

  Future<void> inserirAnimal(
    String id, {
    String? numero,
    String? loteNome,
  }) =>
      database.insert('local_rebanho', {
        'idRebanho': id,
        'numeroAnimal': numero,
        'numeroAnimalSortKey':
            numero == null ? null : buildRebanhoNumeroSortKey(numero),
        'loteNome': loteNome,
      });

  Future<void> inserirSanidade(
    String id, {
    String? idRebanho,
    String? idLote,
    String? data,
    String deletado = 'NAO',
    String createdAt = '2020-01-01T00:00:00',
  }) =>
      database.insert('local_sanidade', {
        'id_sanidade': id,
        'id_propriedade': 'property-1',
        'id_rebanho': idRebanho,
        'id_lote': idLote,
        'data_sanidade': data,
        'deletado': deletado,
        'created_at': createdAt,
      });

  test('ordena por data do evento globalmente, atravessando as páginas',
      () async {
    // Datas fora de ordem e com created_at inverso à data do evento — é
    // exatamente o caso que o ORDER BY created_at padrão exibe errado.
    const datas = <String, String>{
      's1': '2026-06-23',
      's2': '2024-05-06',
      's3': '2026-04-27',
      's4': '2025-12-31',
      's5': '2026-01-01',
      's6': '2024-05-07',
      's7': '2026-06-22',
    };
    var created = 0;
    for (final entry in datas.entries) {
      await inserirSanidade(
        entry.key,
        data: entry.value,
        createdAt: '2026-08-${(20 - created++).toString().padLeft(2, '0')}',
      );
    }
    // Sem data e com o literal 'null' que o INSERT legado grava como texto.
    await inserirSanidade('s8', data: '');
    await inserirSanidade('s9', data: 'null');
    await inserirSanidade('s10');
    // Deletado nunca aparece.
    await inserirSanidade('s11', data: '2026-07-01', deletado: 'SIM');

    final ordenadas =
        await _todasAsPaginas(database, ordenacaoTipo: 'data', campo: 'id_sanidade');

    expect(ordenadas, [
      's2', // 2024-05-06
      's6', // 2024-05-07
      's4', // 2025-12-31
      's5', // 2026-01-01
      's3', // 2026-04-27
      's7', // 2026-06-22
      's1', // 2026-06-23
      // vazios no fim, desempatados por id_sanidade
      's10',
      's8',
      's9',
    ]);
  });

  test('ordena por número do animal com sort natural e sem-número no fim',
      () async {
    const numeros = ['1', '10', '100', '13', '2', '02', '9', '20', 'A2', 'A10'];
    for (var i = 0; i < numeros.length; i++) {
      final id = 'a${i.toString().padLeft(2, '0')}';
      await inserirAnimal(id, numero: numeros[i]);
      await inserirSanidade('s$id', idRebanho: id, data: '2026-01-01');
    }
    // Animal com número vazio: buildRebanhoNumeroSortKey('') devolve '2', que
    // NÃO é vazio — sem a primeira guarda do CASE isto subiria na ordenação.
    await inserirAnimal('a90', numero: '');
    await inserirSanidade('sa90', idRebanho: 'a90', data: '2026-01-01');
    // Sanidade cujo LEFT JOIN não casa com nenhum animal.
    await inserirSanidade('sa91', idRebanho: 'inexistente', data: '2026-01-01');

    final ordenadas = await _todasAsPaginas(
      database,
      ordenacaoTipo: 'numero',
      campo: 'numeroAnimal',
    );

    expect(ordenadas, [
      '1',
      '2',
      '02',
      '9',
      '10',
      '13',
      '20',
      '100',
      'A2',
      'A10',
      // sem número / sem animal no fim
      '',
      null,
    ]);
  });

  test('ordena por lote usando o da sanidade e caindo no do animal', () async {
    await database.insert('local_lotes', {'id_lote': 'l1', 'nome': 'Bezerras'});
    await database.insert('local_lotes', {'id_lote': 'l2', 'nome': 'ALPHA'});

    // Sanidade com lote próprio -> usa local_lotes.nome, ignorando o loteNome
    // do animal. O mesmo animal também tem uma sanidade sem lote (s6), que
    // cai no loteNome dele — os dois caminhos convivem para o mesmo an1.
    await inserirAnimal('an1', numero: '1', loteNome: 'Zulu');
    await inserirSanidade('s1', idRebanho: 'an1', idLote: 'l1');
    await inserirSanidade('s2', idRebanho: 'an1', idLote: 'l2');
    await inserirSanidade('s6', idRebanho: 'an1');
    // Sanidade sem lote -> cai no lote atual do animal (é o que o card mostra)
    await inserirAnimal('an2', numero: '2', loteNome: 'Meio');
    await inserirSanidade('s3', idRebanho: 'an2');
    // Nenhum dos dois -> fim da lista
    await inserirAnimal('an3', numero: '3');
    await inserirSanidade('s4', idRebanho: 'an3');
    await inserirSanidade('s5', idRebanho: 'an3', idLote: '');

    final ordenadas =
        await _todasAsPaginas(database, ordenacaoTipo: 'lote', campo: 'lote');

    expect(ordenadas, [
      'ALPHA', // COLLATE NOCASE: maiúsculas não vão para o topo
      'Bezerras',
      'Meio', // veio do loteNome do animal (an2)
      'Zulu', // an1 sem lote na sanidade -> cai no loteNome dele
      null,
      null,
    ]);
  });

  test('padrão ordena por data do evento, não por data de lançamento',
      () async {
    // created_at inverso à data do evento: é o caso real em que o antigo
    // padrão (created_at DESC) escondia as sanidades mais recentes.
    await inserirSanidade('s1',
        data: '2026-04-27', createdAt: '2026-06-23T19:00:00');
    await inserirSanidade('s2',
        data: '2026-06-23', createdAt: '2026-04-27T08:00:00');
    await inserirSanidade('s3',
        data: '2026-01-15', createdAt: '2026-08-01T08:00:00');
    await inserirSanidade('s4', data: '');

    final ordenadas =
        await _todasAsPaginas(database, ordenacaoTipo: '', campo: 'id_sanidade');

    // s2 primeiro: é o evento mais recente, apesar de ter sido lançado antes
    // de todos os outros. Sem data vai para o fim.
    expect(ordenadas, ['s2', 's1', 's3', 's4']);
  });

  test('padrão desempata a mesma data pelo lançamento mais novo', () async {
    await inserirSanidade('s1',
        data: '2026-05-10', createdAt: '2026-05-10T08:00:00');
    await inserirSanidade('s2',
        data: '2026-05-10', createdAt: '2026-05-12T08:00:00');
    await inserirSanidade('s3',
        data: '2026-05-10', createdAt: '2026-05-11T08:00:00');

    final ordenadas =
        await _todasAsPaginas(database, ordenacaoTipo: '', campo: 'id_sanidade');

    expect(ordenadas, ['s2', 's3', 's1']);
  });

  test('a paginação não repete nem perde registros', () async {
    for (var i = 0; i < 10; i++) {
      // Datas empatadas: o desempate por id_sanidade é o que mantém as
      // páginas estáveis entre LIMIT/OFFSET.
      await inserirSanidade('s${i.toString().padLeft(2, '0')}',
          data: '2026-01-01');
    }

    final ids =
        await _todasAsPaginas(database, ordenacaoTipo: 'data', campo: 'id_sanidade');

    expect(ids.length, 10);
    expect(ids.toSet().length, 10);
    expect(ids, List.generate(10, (i) => 's${i.toString().padLeft(2, '0')}'));
  });
}
