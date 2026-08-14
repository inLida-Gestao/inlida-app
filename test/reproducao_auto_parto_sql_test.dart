import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:in_lida/backend/sqlite/queries/read.dart';
import 'package:in_lida/backend/sqlite/queries/update.dart';
import 'package:in_lida/backend/utils/reproducao_parto_utils.dart';

const String kPropriedade = 'prop-1';
const String kMatriz = 'matriz-1';

String _fmt(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

void main() {
  late Database database;

  // Nascimento de referência usado em todos os cenários.
  final nascimento = DateTime(2026, 6, 1);
  final janela = janelaConcepcao(nascimento);

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute('''
CREATE TABLE local_reproducao (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_propriedade TEXT,
  tipo_reproducao TEXT,
  id_rebanho_matriz TEXT,
  id_rebanho_reprodutor TEXT,
  data_inseminacao TEXT,
  data_inicial TEXT,
  data_final TEXT,
  status_reproducao TEXT,
  id_reproducao TEXT,
  deletado TEXT,
  created_at TEXT,
  updated_at TEXT,
  numReprodutor TEXT,
  nomeReprodutor TEXT,
  nascimentoReprodutor TEXT,
  racaReprodutor TEXT,
  chipReprodutor TEXT,
  parida TEXT,
  data_parto TEXT
)
''');
  });

  tearDown(() => database.close());

  Future<void> inserir({
    required String idReproducao,
    String tipo = 'Inseminação',
    String? dataInseminacao,
    String? dataInicial,
    String? dataFinal,
    String idPropriedade = kPropriedade,
    String idRebanhoMatriz = kMatriz,
    String? idRebanhoReprodutor = 'reprodutor-1',
    String deletado = 'NAO',
    String? parida,
    String? dataParto,
  }) {
    return database.insert('local_reproducao', {
      'id_reproducao': idReproducao,
      'tipo_reproducao': tipo,
      'id_propriedade': idPropriedade,
      'id_rebanho_matriz': idRebanhoMatriz,
      'id_rebanho_reprodutor': idRebanhoReprodutor,
      'data_inseminacao': dataInseminacao,
      'data_inicial': dataInicial,
      'data_final': dataFinal,
      'deletado': deletado,
      'parida': parida,
      'data_parto': dataParto,
      'created_at': '2025-01-01 00:00:00',
      'updated_at': '2025-01-01 00:00:00',
    });
  }

  Future<List<String>> buscar() async {
    final rows = await performBuscarReproducaoParaParto(
      database,
      idPropriedade: kPropriedade,
      idRebanhoMatriz: kMatriz,
      dataInicio: _fmt(janela.inicio),
      dataFim: _fmt(janela.fim),
    );
    return rows.map((r) => r.idReproducao ?? '').toList();
  }

  group('janela de gestação na consulta SQL', () {
    test('encontra inseminação de 292 dias antes do nascimento', () async {
      await inserir(
        idReproducao: 'r292',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 292))),
      );

      expect(await buscar(), ['r292']);
    });

    test('inclui os limites de 275 e 305 dias', () async {
      await inserir(
        idReproducao: 'r275',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 275))),
      );
      await inserir(
        idReproducao: 'r305',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 305))),
      );

      expect((await buscar()).toSet(), {'r275', 'r305'});
    });

    test('exclui 274 e 306 dias', () async {
      await inserir(
        idReproducao: 'r274',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 274))),
      );
      await inserir(
        idReproducao: 'r306',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 306))),
      );

      expect(await buscar(), isEmpty);
    });

    test('aceita data_inseminacao com timestamp ISO', () async {
      final data = nascimento.subtract(const Duration(days: 292));
      await inserir(
        idReproducao: 'rIso',
        dataInseminacao: '${_fmt(data)}T00:00:00',
      );

      expect(await buscar(), ['rIso']);
    });

    test('monta natural com período sobrepondo a janela', () async {
      await inserir(
        idReproducao: 'rMonta',
        tipo: 'Monta Natural',
        dataInicial: _fmt(nascimento.subtract(const Duration(days: 310))),
        dataFinal: _fmt(nascimento.subtract(const Duration(days: 290))),
      );

      expect(await buscar(), ['rMonta']);
    });

    test('monta natural sem data_final usa data_inicial', () async {
      await inserir(
        idReproducao: 'rMontaAberta',
        tipo: 'Monta Natural',
        dataInicial: _fmt(nascimento.subtract(const Duration(days: 292))),
      );

      expect(await buscar(), ['rMontaAberta']);
    });

    test('monta natural com data_final literal "null" (legado)', () async {
      await inserir(
        idReproducao: 'rMontaLegado',
        tipo: 'Monta Natural',
        dataInicial: _fmt(nascimento.subtract(const Duration(days: 292))),
        dataFinal: 'null',
      );

      expect(await buscar(), ['rMontaLegado']);
    });

    test('ignora outra matriz, outra propriedade e deletados', () async {
      final data = _fmt(nascimento.subtract(const Duration(days: 292)));
      await inserir(
        idReproducao: 'rOutraMatriz',
        dataInseminacao: data,
        idRebanhoMatriz: 'matriz-2',
      );
      await inserir(
        idReproducao: 'rOutraProp',
        dataInseminacao: data,
        idPropriedade: 'prop-2',
      );
      await inserir(
        idReproducao: 'rDeletado',
        dataInseminacao: data,
        deletado: 'SIM',
      );

      expect(await buscar(), isEmpty);
    });

    test('aceita tipo gravado com caixa diferente', () async {
      await inserir(
        idReproducao: 'rCaixa',
        tipo: 'inseminação',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 292))),
      );

      expect(await buscar(), ['rCaixa']);
    });

    test('ignora inseminação com data literal "null" sem quebrar', () async {
      await inserir(idReproducao: 'rSemData', dataInseminacao: 'null');
      await inserir(idReproducao: 'rVazia', dataInseminacao: '');
      await inserir(
        idReproducao: 'rValida',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 292))),
      );

      expect(await buscar(), ['rValida']);
    });

    test('monta natural com data_inicial "null" usa data_final', () async {
      await inserir(
        idReproducao: 'rMontaSemInicio',
        tipo: 'Monta Natural',
        dataInicial: 'null',
        dataFinal: _fmt(nascimento.subtract(const Duration(days: 292))),
      );

      expect(await buscar(), ['rMontaSemInicio']);
    });

    test('retorna a reprodução mais recente primeiro', () async {
      await inserir(
        idReproducao: 'rAntiga',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 304))),
      );
      await inserir(
        idReproducao: 'rRecente',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 286))),
      );

      expect(await buscar(), ['rRecente', 'rAntiga']);
    });
  });

  group('incluirMontaNatural = false (janela automática)', () {
    test('exclui monta natural mesmo dentro da janela', () async {
      await inserir(
        idReproducao: 'rMontaExcluida',
        tipo: 'Monta Natural',
        dataInicial: _fmt(nascimento.subtract(const Duration(days: 300))),
        dataFinal: _fmt(nascimento.subtract(const Duration(days: 290))),
      );

      final rows = await performBuscarReproducaoParaParto(
        database,
        idPropriedade: kPropriedade,
        idRebanhoMatriz: kMatriz,
        dataInicio: _fmt(janela.inicio),
        dataFim: _fmt(janela.fim),
        incluirMontaNatural: false,
      );

      expect(rows, isEmpty);
    });

    test('mantém inseminação dentro da janela', () async {
      await inserir(
        idReproducao: 'rInsem',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 292))),
      );

      final rows = await performBuscarReproducaoParaParto(
        database,
        idPropriedade: kPropriedade,
        idRebanhoMatriz: kMatriz,
        dataInicio: _fmt(janela.inicio),
        dataFim: _fmt(janela.fim),
        incluirMontaNatural: false,
      );

      expect(rows.map((r) => r.idReproducao), ['rInsem']);
    });
  });

  group('janela estendida (306-350 dias)', () {
    final janelaEstendida = janelaConcepcaoEstendida(nascimento);

    test('encontra inseminação e monta natural nesse período', () async {
      await inserir(
        idReproducao: 'rInsemEstendida',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 320))),
      );
      await inserir(
        idReproducao: 'rMontaEstendida',
        tipo: 'Monta Natural',
        dataInicial: _fmt(nascimento.subtract(const Duration(days: 340))),
        dataFinal: _fmt(nascimento.subtract(const Duration(days: 330))),
      );

      final rows = await performBuscarReproducaoParaParto(
        database,
        idPropriedade: kPropriedade,
        idRebanhoMatriz: kMatriz,
        dataInicio: _fmt(janelaEstendida.inicio),
        dataFim: _fmt(janelaEstendida.fim),
        incluirMontaNatural: true,
      );

      expect(
        rows.map((r) => r.idReproducao).toSet(),
        {'rInsemEstendida', 'rMontaEstendida'},
      );
    });

    test('não retorna nada da janela automática (275-305)', () async {
      await inserir(
        idReproducao: 'rDentroJanelaAutomatica',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 290))),
      );

      final rows = await performBuscarReproducaoParaParto(
        database,
        idPropriedade: kPropriedade,
        idRebanhoMatriz: kMatriz,
        dataInicio: _fmt(janelaEstendida.inicio),
        dataFim: _fmt(janelaEstendida.fim),
        incluirMontaNatural: true,
      );

      expect(rows, isEmpty);
    });
  });

  group('seleção e confirmação', () {
    test('descarta reprodução já parida e mantém a disponível', () async {
      await inserir(
        idReproducao: 'rParida',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 286))),
        parida: 'SIM',
      );
      await inserir(
        idReproducao: 'rLivre',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 300))),
      );

      final rows = await performBuscarReproducaoParaParto(
        database,
        idPropriedade: kPropriedade,
        idRebanhoMatriz: kMatriz,
        dataInicio: _fmt(janela.inicio),
        dataFim: _fmt(janela.fim),
      );

      final candidatos = rows
          .map((row) => CandidatoReproducao(
                idReproducao: row.idReproducao!,
                dataReferencia: dataReferenciaReproducao(
                  row.tipoReproducao,
                  row.dataInseminacao,
                  row.dataInicial,
                  row.dataFinal,
                )!,
                tipoReproducao: row.tipoReproducao,
                parida: row.parida,
                dataParto: row.dataParto,
                statusReproducao: row.statusReproducao,
                idRebanhoReprodutor: row.idRebanhoReprodutor,
                numReprodutor: row.numReprodutor,
                nomeReprodutor: row.nomeReprodutor,
                nascimentoReprodutor: row.nascimentoReprodutor,
                racaReprodutor: row.racaReprodutor,
                chipReprodutor: row.chipReprodutor,
              ))
          .toList();

      expect(selecionarReproducaoParaParto(candidatos)?.idReproducao, 'rLivre');
    });

    test('UPDATE parcial só altera as 4 colunas do parto', () async {
      await inserir(
        idReproducao: 'rUpd',
        dataInseminacao: _fmt(nascimento.subtract(const Duration(days: 292))),
      );

      await performConfirmarPartoReproducao(
        database,
        idReproducao: 'rUpd',
        dataParto: _fmt(nascimento),
        statusReproducao: 'Prenhez',
        updatedAt: '2026-06-01 10:00:00',
      );

      final row = (await database.query(
        'local_reproducao',
        where: 'id_reproducao = ?',
        whereArgs: ['rUpd'],
      ))
          .single;

      expect(row['parida'], 'SIM');
      expect(row['data_parto'], _fmt(nascimento));
      expect(row['status_reproducao'], 'Prenhez');
      expect(row['updated_at'], '2026-06-01 10:00:00');
      // Colunas que não podem ter sido tocadas.
      expect(row['id_rebanho_reprodutor'], 'reprodutor-1');
      expect(
        row['data_inseminacao'],
        _fmt(nascimento.subtract(const Duration(days: 292))),
      );
      expect(row['created_at'], '2025-01-01 00:00:00');
    });
  });
}
