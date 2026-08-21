import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Espelha a query de `performBuscaRebanhoPaginadaPesquisa`
/// (lib/backend/sqlite/queries/read.dart), que é montada por interpolação.
///
/// Regressões cobertas (BUG-APP.URGENTE, FAZENDA ANNA JÚLIA):
///  - havia retorno antecipado no primeiro match exato, então buscar "117"
///    escondia o "117 F" para sempre;
///  - todo caminho tinha cap fixo de 100, então um filtro com 132 animais
///    exibia 100.
String _condicao(String termo) {
  if (termo.isEmpty) return '1 = 1';
  return '''(numeroAnimal LIKE '%$termo%' ESCAPE '\\'
  OR nome COLLATE NOCASE LIKE '%$termo%' ESCAPE '\\'
  OR chip LIKE '%$termo%' ESCAPE '\\')''';
}

String _rank(String termo) {
  if (termo.isEmpty) return '';
  return '''CASE
    WHEN chip = '$termo' THEN 0
    WHEN numeroAnimal = '$termo' THEN 1
    WHEN chip LIKE '$termo%' ESCAPE '\\' THEN 2
    WHEN numeroAnimal LIKE '$termo%' ESCAPE '\\' THEN 3
    WHEN nome COLLATE NOCASE LIKE '$termo%' ESCAPE '\\' THEN 4
    ELSE 5
  END,
  ''';
}

Future<List<String>> _busca(
  Database db,
  String termo, {
  int? limit,
  int offset = 0,
}) async {
  final paginacao = limit == null ? '' : 'LIMIT $limit OFFSET $offset';
  final rows = await db.rawQuery('''
SELECT numeroAnimal
FROM local_rebanho
WHERE idPropriedade = 'prop-1'
AND deletado = 'NAO'
AND ${_condicao(termo)}
ORDER BY ${_rank(termo)}numeroAnimal ASC
$paginacao
''');
  return rows.map((r) => r['numeroAnimal'] as String).toList();
}

Future<int> _conta(Database db, String termo) async {
  final rows = await db.rawQuery('''
SELECT COUNT(*) AS total
FROM local_rebanho
WHERE idPropriedade = 'prop-1'
AND deletado = 'NAO'
AND ${_condicao(termo)}
''');
  return rows.first['total'] as int;
}

void main() {
  late Database db;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await db.execute('''
CREATE TABLE local_rebanho (
  idRebanho TEXT PRIMARY KEY,
  idPropriedade TEXT,
  numeroAnimal TEXT,
  nome TEXT,
  chip TEXT,
  deletado TEXT
)
''');
  });

  tearDown(() => db.close());

  var seq = 0;
  Future<void> animal(
    String numero, {
    String nome = '',
    String chip = '',
    String propriedade = 'prop-1',
    String deletado = 'NAO',
  }) =>
      db.insert('local_rebanho', {
        'idRebanho': 'a${(seq++).toString().padLeft(4, '0')}',
        'idPropriedade': propriedade,
        'numeroAnimal': numero,
        'nome': nome,
        'chip': chip,
        'deletado': deletado,
      });

  test('match exato não esconde os de prefixo (regressão do "117")', () async {
    await animal('117', nome: 'ROBERTO');
    await animal('117 F', nome: 'ROBERTO');
    await animal('117 AF', nome: 'ROBERTO');
    await animal('220', nome: 'OUTRO');

    // Antes: só ['117'], porque a função retornava no primeiro match exato.
    expect(await _busca(db, '117'), ['117', '117 AF', '117 F']);
  });

  test('exato vem primeiro, depois prefixo, depois o resto', () async {
    await animal('900', nome: 'zzz');       // exato no número -> rank 1
    await animal('9001', nome: 'zzz');      // prefixo no número -> rank 3
    await animal('X', nome: '900 NOME');    // prefixo no nome -> rank 4
    await animal('Y', nome: 'tem 900 no meio'); // só contém -> rank 5
    await animal('Z', chip: '900');         // exato no chip -> rank 0

    expect(await _busca(db, '900'), ['Z', '900', '9001', 'X', 'Y']);
  });

  test('paginação cobre tudo, sem repetir nem perder', () async {
    for (var i = 0; i < 132; i++) {
      await animal('n${i.toString().padLeft(3, '0')}', nome: 'ROBERTO');
    }

    expect(await _conta(db, 'ROBERTO'), 132);

    final vistos = <String>[];
    for (var offset = 0;; offset += 20) {
      final pagina = await _busca(db, 'ROBERTO', limit: 20, offset: offset);
      if (pagina.isEmpty) break;
      vistos.addAll(pagina);
    }

    // Antes: 100, por causa do cap fixo.
    expect(vistos.length, 132);
    expect(vistos.toSet().length, 132);
  });

  test('busca vazia (só ordenação ativa) também não é limitada', () async {
    for (var i = 0; i < 150; i++) {
      await animal('n${i.toString().padLeft(3, '0')}');
    }

    expect(await _conta(db, ''), 150);
    expect((await _busca(db, '')).length, 150);
  });

  test('respeita propriedade e deletado', () async {
    await animal('1', nome: 'ROBERTO');
    await animal('2', nome: 'ROBERTO', propriedade: 'prop-2');
    await animal('3', nome: 'ROBERTO', deletado: 'SIM');

    expect(await _busca(db, 'ROBERTO'), ['1']);
    expect(await _conta(db, 'ROBERTO'), 1);
  });

  test('termo com % e _ é escapado e não vira curinga', () async {
    await animal('50%', nome: 'com porcento');
    await animal('501', nome: 'sem porcento');

    // Sem ESCAPE, '%50%%' casaria com os dois.
    expect(await _busca(db, r'50\%'), ['50%']);
  });
}
