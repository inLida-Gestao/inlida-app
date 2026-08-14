import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:in_lida/backend/sqlite/queries/read.dart';
import 'package:in_lida/backend/sqlite/queries/update.dart';

/// Reproduz a detecção de pendências de sincronização de reprodução:
/// `confirmarPartoAutomatico` grava `updated_at` e marca
/// `FFAppState().dataDadosNaoSyncRepro`; o `putUpdtReproducao` depois busca
/// as pendências via `performBuscarReproducaoUPDT(datePUT: marcador)`.
///
/// Se a linha atualizada NÃO for encontrada aqui, o upload retorna
/// "Nada para enviar" => allSuccess=true => o marcador é limpo pelo
/// SyncEngine e a alteração é perdida para sempre.
String _fmtLocalSqlite(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';

void main() {
  late Database database;

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
  parida TEXT,
  data_parto TEXT
)
''');
  });

  tearDown(() => database.close());

  Future<void> inserirReproducaoAntiga({
    required String idReproducao,
    required String createdAt,
    required String updatedAt,
  }) {
    return database.insert('local_reproducao', {
      'id_reproducao': idReproducao,
      'tipo_reproducao': 'Inseminação',
      'id_propriedade': 'prop-1',
      'id_rebanho_matriz': 'matriz-1',
      'data_inseminacao': '2025-08-15',
      'deletado': 'NAO',
      'parida': 'NAO',
      'created_at': createdAt,
      'updated_at': updatedAt,
    });
  }

  group('detecção de pendência após confirmarPartoAutomatico', () {
    test(
        'reprodução antiga vinda do PULL (updated_at com timezone) é detectada '
        'após confirmar parto', () async {
      // Formato gravado pelo PULL: `batchInsertLocalReproducao` só converte
      // `created_at`; `updated_at` fica cru como veio do Supabase (com offset).
      await inserirReproducaoAntiga(
        idReproducao: 'r-antiga',
        createdAt: '2025-08-15T10:00:00.000',
        updatedAt: '2025-08-15T13:00:00+00:00',
      );

      // `confirmarPartoAutomatico`: marcador é capturado ANTES do UPDATE.
      final marcador = DateTime.now();
      await performConfirmarPartoReproducao(
        database,
        idReproducao: 'r-antiga',
        dataParto: '2026-06-01',
        statusReproducao: 'Prenhez',
        updatedAt: _fmtLocalSqlite(DateTime.now()),
      );

      final pendentes = await performBuscarReproducaoUPDT(
        database,
        datePUT: _fmtLocalSqlite(marcador),
      );

      expect(
        pendentes.map((r) => r.idReproducao),
        contains('r-antiga'),
        reason: 'A reprodução com parto confirmado precisa ser detectada como '
            'pendente, senão o upload reporta "nada para enviar" e o '
            'SyncEngine limpa o marcador, perdendo a alteração.',
      );
    });

    test('a linha não entra no PUT (INSERT), apenas no UPDATE', () async {
      await inserirReproducaoAntiga(
        idReproducao: 'r-antiga',
        createdAt: '2025-08-15T10:00:00.000',
        updatedAt: '2025-08-15T13:00:00+00:00',
      );

      final marcador = DateTime.now();
      await performConfirmarPartoReproducao(
        database,
        idReproducao: 'r-antiga',
        dataParto: '2026-06-01',
        statusReproducao: 'Prenhez',
        updatedAt: _fmtLocalSqlite(DateTime.now()),
      );

      final novos = await performBuscarReproducaoPUT(
        database,
        datePUT: _fmtLocalSqlite(marcador),
      );

      expect(novos, isEmpty,
          reason: 'Reprodução antiga não pode ser reenviada como INSERT.');
    });

    test('confirmarParto grava as 4 colunas esperadas', () async {
      await inserirReproducaoAntiga(
        idReproducao: 'r-antiga',
        createdAt: '2025-08-15T10:00:00.000',
        updatedAt: '2025-08-15T13:00:00+00:00',
      );

      await performConfirmarPartoReproducao(
        database,
        idReproducao: 'r-antiga',
        dataParto: '2026-06-01',
        statusReproducao: 'Prenhez',
        updatedAt: _fmtLocalSqlite(DateTime.now()),
      );

      final row = (await database.query('local_reproducao',
              where: 'id_reproducao = ?', whereArgs: ['r-antiga']))
          .single;
      expect(row['parida'], 'SIM');
      expect(row['data_parto'], '2026-06-01');
      expect(row['status_reproducao'], 'Prenhez');
    });
  });
}
