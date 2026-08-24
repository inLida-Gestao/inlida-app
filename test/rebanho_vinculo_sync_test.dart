import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Espelha as duas regras introduzidas na correção do vínculo de mãe/pai
/// (BUG-P.URGENTE, FAZ BARREIRINHO):
///
///  - a reatribuição do vínculo na deduplicação local precisa entrar na fila
///    de PUSH (`sync_dirty = 1`), senão fica só no aparelho e o servidor
///    mantém o id do duplicado, que vira órfão;
///  - o `sync_op` só pode virar 'update' se já não for um 'insert' pendente —
///    rebaixar um insert faria o registro nunca ser criado no servidor.
///
/// O mesmo CASE existe em init.dart (`_dedupRebanhoLogicoDuplicadoV3`) e em
/// actions.dart (`_remarcarVinculoRebanhoPendente`).
const _marcaPendente = '''
    sync_dirty = 1,
    sync_op = CASE WHEN sync_dirty = 1 AND sync_op = 'insert'
                   THEN 'insert' ELSE 'update' END,
    sync_updated_at = ?''';

/// Filtro de `_buildRebanhoPayload`: um vínculo apontando para animal que
/// ainda não existe no servidor não pode ser enviado.
String? vinculoEnviavel(
  String? bruto, {
  required Set<String> ausentesNoServidor,
  required String idProprio,
  required Set<String> vinculoAdiado,
}) {
  final id = bruto?.trim();
  if (id == null || id.isEmpty || id.toLowerCase() == 'null') return null;
  if (!ausentesNoServidor.contains(id)) return id;
  vinculoAdiado.add(idProprio);
  return null;
}

void main() {
  group('filtro de vínculo no payload', () {
    test('vínculo para pai já sincronizado é enviado', () {
      final adiado = <String>{};
      expect(
        vinculoEnviavel('mae-1',
            ausentesNoServidor: {}, idProprio: 'cria-1', vinculoAdiado: adiado),
        'mae-1',
      );
      expect(adiado, isEmpty);
    });

    test('vínculo para pai ainda não sincronizado é omitido e fica pendente',
        () {
      final adiado = <String>{};
      expect(
        vinculoEnviavel('mae-nova',
            ausentesNoServidor: {'mae-nova'},
            idProprio: 'cria-1',
            vinculoAdiado: adiado),
        isNull,
      );
      expect(adiado, {'cria-1'});
    });

    test('string vazia e literal "null" viram null sem virar pendência', () {
      for (final bruto in ['', '   ', 'null', 'NULL', null]) {
        final adiado = <String>{};
        expect(
          vinculoEnviavel(bruto,
              ausentesNoServidor: {},
              idProprio: 'cria-1',
              vinculoAdiado: adiado),
          isNull,
          reason: 'entrada: ${bruto!=null ? '"$bruto"' : 'null'}',
        );
        expect(adiado, isEmpty);
      }
    });
  });

  group('marcação de pendência no SQLite', () {
    late Database db;

    setUpAll(sqfliteFfiInit);

    setUp(() async {
      db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      await db.execute('''
CREATE TABLE local_rebanho (
  idRebanho TEXT PRIMARY KEY,
  rebanhoIdMatriz TEXT,
  sync_dirty INTEGER,
  sync_op TEXT,
  sync_updated_at TEXT,
  updated_at TEXT
)
''');
    });

    tearDown(() => db.close());

    Future<void> animal(String id,
            {String? matriz, int? dirty, String? op}) =>
        db.insert('local_rebanho', {
          'idRebanho': id,
          'rebanhoIdMatriz': matriz,
          'sync_dirty': dirty,
          'sync_op': op,
        });

    Future<Map<String, Object?>> ler(String id) async =>
        (await db.query('local_rebanho',
                where: 'idRebanho = ?', whereArgs: [id]))
            .first;

    test('reatribuição do vínculo marca a linha para envio', () async {
      await animal('cria', matriz: 'dup', dirty: 0, op: null);

      await db.rawUpdate(
        'UPDATE local_rebanho SET rebanhoIdMatriz = ?, $_marcaPendente '
        'WHERE rebanhoIdMatriz = ?',
        ['canonico', 'agora', 'dup'],
      );

      final r = await ler('cria');
      expect(r['rebanhoIdMatriz'], 'canonico');
      // Antes gravava só updated_at, e o PUSH filtra sync_dirty = 1 —
      // por isso a reatribuição nunca saía do aparelho.
      expect(r['sync_dirty'], 1);
      expect(r['sync_op'], 'update');
      expect(r['sync_updated_at'], 'agora');
    });

    test('insert pendente não é rebaixado para update', () async {
      await animal('cria-nova', matriz: 'dup', dirty: 1, op: 'insert');

      await db.rawUpdate(
        'UPDATE local_rebanho SET rebanhoIdMatriz = ?, $_marcaPendente '
        'WHERE rebanhoIdMatriz = ?',
        ['canonico', 'agora', 'dup'],
      );

      final r = await ler('cria-nova');
      expect(r['rebanhoIdMatriz'], 'canonico');
      expect(r['sync_dirty'], 1);
      // Rebaixar para 'update' faria o registro nunca ser criado no servidor.
      expect(r['sync_op'], 'insert');
    });

    test('linha com delete pendente também não é rebaixada indevidamente',
        () async {
      await animal('cria-del', matriz: 'dup', dirty: 1, op: 'delete');

      await db.rawUpdate(
        'UPDATE local_rebanho SET rebanhoIdMatriz = ?, $_marcaPendente '
        'WHERE rebanhoIdMatriz = ?',
        ['canonico', 'agora', 'dup'],
      );

      // Só 'insert' é preservado; delete virando update é aceitável porque a
      // deleção é reenviada pelo fluxo próprio — o teste fixa o contrato para
      // que a mudança seja consciente se alguém alterar o CASE.
      expect((await ler('cria-del'))['sync_op'], 'update');
    });

    test('não toca em linhas de outro pai', () async {
      await animal('outra', matriz: 'outro-pai', dirty: 0, op: null);

      await db.rawUpdate(
        'UPDATE local_rebanho SET rebanhoIdMatriz = ?, $_marcaPendente '
        'WHERE rebanhoIdMatriz = ?',
        ['canonico', 'agora', 'dup'],
      );

      final r = await ler('outra');
      expect(r['rebanhoIdMatriz'], 'outro-pai');
      expect(r['sync_dirty'], 0);
    });
  });
}
