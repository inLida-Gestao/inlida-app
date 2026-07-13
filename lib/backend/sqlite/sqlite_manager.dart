import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';
import 'queries/update.dart';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  Future<List<T>> _timedRebanhoQuery<T>(
    String label,
    Future<List<T>> Function() query,
  ) async {
    if (!kDebugMode) {
      return query();
    }

    final stopwatch = Stopwatch()..start();
    final rows = await query();
    stopwatch.stop();
    debugPrint(
      '[SQLite][Rebanho] $label: ${rows.length} linhas em ${stopwatch.elapsedMilliseconds}ms',
    );
    return rows;
  }

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'inlida',
      'inlida_v51.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<LocalCidadesRow>> localCidades({
    String? uf,
  }) =>
      performLocalCidades(
        _database,
        uf: uf,
      );

  Future<List<ListarPropriedadesRow>> listarPropriedades({
    String? userID,
  }) =>
      performListarPropriedades(
        _database,
        userID: userID,
      );

  Future<List<BuscaPropriedadesPUTRow>> buscaPropriedadesPUT({
    String? datePUT,
  }) =>
      performBuscaPropriedadesPUT(
        _database,
        datePUT: datePUT,
      );

  Future<List<BuscaPropriedadeRow>> buscaPropriedade({
    String? idPropriedade,
  }) =>
      performBuscaPropriedade(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<BuscaUsersPeloIDRow>> buscaUsersPeloID({
    String? userID,
  }) =>
      performBuscaUsersPeloID(
        _database,
        userID: userID,
      );

  Future<List<BuscaUsuarioPorEmailRow>> buscaUsuarioPorEmail({
    String? email,
  }) =>
      performBuscaUsuarioPorEmail(
        _database,
        email: email,
      );

  Future<List<BuscaPropriedadesUPDATEDRow>> buscaPropriedadesUPDATED({
    String? dateUPT,
  }) =>
      performBuscaPropriedadesUPDATED(
        _database,
        dateUPT: dateUPT,
      );

  Future<List<BuscaUsersPropriedadesRow>> buscaUsersPropriedades({
    String? idPropriedade,
  }) =>
      performBuscaUsersPropriedades(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<ListarRebanhosRow>> listarRebanhos({
    String? idPropriedade,
  }) =>
      _timedRebanhoQuery(
        'listarRebanhos',
        () => performListarRebanhos(
          _database,
          idPropriedade: idPropriedade,
        ),
      );

  Future<List<BuscarRebanhoRow>> buscarRebanho({
    String? idRebanho,
  }) async {
    await _syncUltimaPesagemNoRebanho(idRebanho);
    return performBuscarRebanho(
      _database,
      idRebanho: idRebanho,
    );
  }

  Future<List<BuscarRebanhoUPDATEDRow>> buscarRebanhoUPDATED({
    String? data,
    String? userID,
  }) =>
      performBuscarRebanhoUPDATED(
        _database,
        data: data,
        userID: userID,
      );

  Future<List<BuscarRebanhoPUTRow>> buscarRebanhoPUT({
    String? data,
    String? userID,
  }) =>
      performBuscarRebanhoPUT(
        _database,
        data: data,
        userID: userID,
      );

  Future<bool> hasRebanhoDirtyLocalForUser({
    required String userID,
  }) async {
    if (userID.trim().isEmpty) return false;
    final rows = await _database.rawQuery('''
      SELECT 1
      FROM local_rebanho r
      WHERE r.sync_dirty = 1
        AND COALESCE(r.idRebanho, '') != ''
        AND EXISTS (
          SELECT 1
          FROM local_propriedades p
          WHERE p.idPropriedade = r.idPropriedade
            AND (p.userID = ? OR p.usersID LIKE ?)
            AND COALESCE(p.deletado, 'NAO') != 'SIM'
        )
      LIMIT 1
    ''', [userID, '%$userID%']);
    return rows.isNotEmpty;
  }

  Future<bool> hasLoteDirtyLocalForUser({
    required String userID,
  }) async {
    if (userID.trim().isEmpty) return false;
    try {
      final rows = await _database.rawQuery('''
        SELECT 1
        FROM local_lotes l
        WHERE l.sync_dirty = 1
          AND COALESCE(l.id_lote, '') != ''
          AND EXISTS (
            SELECT 1
            FROM local_propriedades p
            WHERE p.idPropriedade = l.id_propriedade
              AND (p.userID = ? OR p.usersID LIKE ?)
              AND COALESCE(p.deletado, 'NAO') != 'SIM'
          )
        LIMIT 1
      ''', [userID, '%$userID%']);
      return rows.isNotEmpty;
    } catch (e) {
      debugPrint('[SQLite] Erro ao consultar lotes pendentes de sync: $e');
      return false;
    }
  }

  Future<bool> hasLoteChangedAfterForUser({
    required String userID,
    required DateTime? changedAfter,
  }) async {
    if (userID.trim().isEmpty || changedAfter == null) return false;
    final marker =
        changedAfter.toIso8601String().substring(0, 19).replaceFirst('T', ' ');
    try {
      final rows = await _database.rawQuery('''
        SELECT 1
        FROM local_lotes l
        WHERE COALESCE(l.id_lote, '') != ''
          AND LOWER(COALESCE(l.id_lote, '')) != 'null'
          AND (l.sync_dirty IS NULL OR l.sync_dirty = 1)
          AND datetime(COALESCE(l.updated_at, l.created_at), 'localtime') >
              datetime(?, 'localtime')
          AND EXISTS (
            SELECT 1
            FROM local_propriedades p
            WHERE p.idPropriedade = l.id_propriedade
              AND (p.userID = ? OR p.usersID LIKE ?)
              AND COALESCE(p.deletado, 'NAO') != 'SIM'
          )
        LIMIT 1
      ''', [marker, userID, '%$userID%']);
      return rows.isNotEmpty;
    } catch (e) {
      debugPrint('[SQLite] Erro ao consultar lotes recentes de sync: $e');
      return false;
    }
  }

  Future<List<QTDAnimaisPropriedadeRow>> qTDAnimaisPropriedade({
    String? idPropriedade,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      performQTDAnimaisPropriedade(
        _database,
        idPropriedade: idPropriedade,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        loteId: loteId,
        statusReb: statusReb,
        dataNascInicio: dataNascInicio,
        dataNascFim: dataNascFim,
      );

  Future<List<QTDDeAnimaisGeralRow>> qTDDeAnimaisGeral({
    String? idPropriedade,
  }) =>
      performQTDDeAnimaisGeral(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<BuscarCriasRebanhoMatrizRow>> buscarCriasRebanhoMatriz({
    String? idRebanho,
  }) =>
      performBuscarCriasRebanhoMatriz(
        _database,
        idRebanho: idRebanho,
      );

  Future<List<BuscaHistPesagensRow>> buscaHistPesagens({
    String? idRebanho,
  }) =>
      performBuscaHistPesagens(
        _database,
        idRebanho: idRebanho,
      );

  Future<List<BuscaHistPesagensRow>> buscaHistPesagensPorRebanhos({
    List<String>? idRebanhos,
  }) =>
      performBuscaHistPesagensPorRebanhos(
        _database,
        idRebanhos: idRebanhos,
      );

  Future<List<BuscaHistPesagensPUTRow>> buscaHistPesagensPUT({
    String? data,
  }) =>
      performBuscaHistPesagensPUT(
        _database,
        data: data,
      );

  Future<List<BuscaHistPesagensUPDTRow>> buscaHistPesagensUPDT({
    String? data,
  }) =>
      performBuscaHistPesagensUPDT(
        _database,
        data: data,
      );

  Future<List<ListarRebanhosProgenereRow>> listarRebanhosProgenere({
    String? idPropriedade,
    String? idRebanho,
    int? limitReb,
    int? offsetReb,
  }) =>
      performListarRebanhosProgenere(
        _database,
        idPropriedade: idPropriedade,
        idRebanho: idRebanho,
        limitReb: limitReb,
        offsetReb: offsetReb,
      );

  Future<List<ListarLotesRow>> listarLotes({
    String? idPropriedade,
  }) =>
      performListarLotes(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<LotesAtivoRow>> lotesAtivo({
    String? idPropriedade,
  }) =>
      performLotesAtivo(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<LotesInativosRow>> lotesInativos({
    String? idPropriedade,
  }) =>
      performLotesInativos(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<AnimaisNoLoteRow>> animaisNoLote({
    String? idPropriedade,
  }) =>
      performAnimaisNoLote(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<BuscarLoteRow>> buscarLote({
    String? idLote,
  }) =>
      performBuscarLote(
        _database,
        idLote: idLote,
      );

  Future<List<BuscarRebanhoLoteRow>> buscarRebanhoLote({
    String? idLote,
  }) =>
      performBuscarRebanhoLote(
        _database,
        idLote: idLote,
      );

  Future<List<BuscarLotePUTRow>> buscarLotePUT({
    String? datePUT,
    String? userID,
  }) =>
      performBuscarLotePUT(
        _database,
        datePUT: datePUT,
        userID: userID,
      );

  Future<List<BuscarLoteUPDTRow>> buscarLoteUPDT({
    String? dateUPDT,
    String? userID,
  }) =>
      performBuscarLoteUPDT(
        _database,
        dateUPDT: dateUPDT,
        userID: userID,
      );

  Future<List<CountLotesCadastradosRow>> countLotesCadastrados({
    String? idPropriedade,
  }) =>
      performCountLotesCadastrados(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<ListarReproducoesRow>> listarReproducoes({
    String? idPropriedade,
  }) =>
      performListarReproducoes(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<BuscarLotesRow>> buscarLotes({
    String? idPropriedade,
  }) =>
      performBuscarLotes(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<QTDReproducoesRow>> qTDReproducoes({
    String? idPropriedade,
    String? tipoRepro,
    String? inseminador,
    String? loteNome,
    String? dataRepro,
    String? dataReproFim,
    String? dataPrev,
    String? dataPrevFim,
    String? categoriaFiltro,
    String? statusReproducaoFiltro,
  }) =>
      performQTDReproducoes(
        _database,
        idPropriedade: idPropriedade,
        tipoRepro: tipoRepro,
        inseminador: inseminador,
        loteNome: loteNome,
        dataRepro: dataRepro,
        dataReproFim: dataReproFim,
        dataPrev: dataPrev,
        dataPrevFim: dataPrevFim,
        categoriaFiltro: categoriaFiltro,
        statusReproducaoFiltro: statusReproducaoFiltro,
      );

  Future<List<QTDInseminacaoRow>> qTDInseminacao({
    String? idPropriedade,
  }) =>
      performQTDInseminacao(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<QTDMontaNaturalRow>> qTDMontaNatural({
    String? idPropriedade,
  }) =>
      performQTDMontaNatural(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<BuscarReproducaoRow>> buscarReproducao({
    String? idReproducao,
  }) =>
      performBuscarReproducao(
        _database,
        idReproducao: idReproducao,
      );

  Future<List<BuscarReproducaoPUTRow>> buscarReproducaoPUT({
    String? datePUT,
  }) =>
      performBuscarReproducaoPUT(
        _database,
        datePUT: datePUT,
      );

  Future<List<BuscarReproducaoUPDTRow>> buscarReproducaoUPDT({
    String? datePUT,
  }) =>
      performBuscarReproducaoUPDT(
        _database,
        datePUT: datePUT,
      );

  Future<List<ListarSanidadesRow>> listarSanidades({
    String? idPropriedade,
  }) =>
      performListarSanidades(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<BuscarSanidadePUTRow>> buscarSanidadePUT({
    String? datePUT,
  }) =>
      performBuscarSanidadePUT(
        _database,
        datePUT: datePUT,
      );

  Future<List<BuscarSanidadeUPDTRow>> buscarSanidadeUPDT({
    String? dateUPDT,
  }) =>
      performBuscarSanidadeUPDT(
        _database,
        dateUPDT: dateUPDT,
      );

  Future<List<BuscarReproducoesRebanhoRow>> buscarReproducoesRebanho({
    String? idRebanho,
  }) =>
      performBuscarReproducoesRebanho(
        _database,
        idRebanho: idRebanho,
      );

  Future<List<BuscarSanidadesRebanhoRow>> buscarSanidadesRebanho({
    String? idRebanho,
  }) =>
      performBuscarSanidadesRebanho(
        _database,
        idRebanho: idRebanho,
      );

  Future<List<BuscaRebanhoPaginadaRow>> buscaRebanhoPaginada({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      _timedRebanhoQuery(
        'buscaRebanhoPaginada',
        () => performBuscaRebanhoPaginada(
          _database,
          idPropriedade: idPropriedade,
          limitReb: limitReb,
          offsetReb: offsetReb,
          sexo: sexo,
          categoria: categoria,
          raca: raca,
          origem: origem,
          loteId: loteId,
          statusReb: statusReb,
          dataNascInicio: dataNascInicio,
          dataNascFim: dataNascFim,
        ),
      );

  Future<List<QTDAnimaisTotalPropriedadeRow>> qTDAnimaisTotalPropriedade({
    String? idPropriedade,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      performQTDAnimaisTotalPropriedade(
        _database,
        idPropriedade: idPropriedade,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        loteId: loteId,
        statusReb: statusReb,
        dataNascInicio: dataNascInicio,
        dataNascFim: dataNascFim,
      );

  Future<List<BuscarCriasRebanhoReprodutorRow>> buscarCriasRebanhoReprodutor({
    String? idRebanho,
  }) =>
      performBuscarCriasRebanhoReprodutor(
        _database,
        idRebanho: idRebanho,
      );

  Future<List<BuscarRebanhoReproducaoLoteRow>> buscarRebanhoReproducaoLote({
    String? loteID,
  }) =>
      performBuscarRebanhoReproducaoLote(
        _database,
        loteID: loteID,
      );

  Future<List<ListarReproducoesPaginadaRow>> listarReproducoesPaginada({
    String? idPropriedade,
    int? limitRep,
    String? offsetRep,
    String? tipoRepro,
    String? inseminador,
    String? loteNome,
    String? dataRepro,
    String? dataReproFim,
    String? dataPrev,
    String? dataPrevFim,
    String? dataHoje,
    String? categoriaFiltro,
    String? statusReproducaoFiltro,
  }) =>
      performListarReproducoesPaginada(
        _database,
        idPropriedade: idPropriedade,
        limitRep: limitRep,
        offsetRep: offsetRep,
        tipoRepro: tipoRepro,
        inseminador: inseminador,
        loteNome: loteNome,
        dataRepro: dataRepro,
        dataReproFim: dataReproFim,
        dataPrev: dataPrev,
        dataPrevFim: dataPrevFim,
        dataHoje: dataHoje,
        categoriaFiltro: categoriaFiltro,
        statusReproducaoFiltro: statusReproducaoFiltro,
      );

  Future<List<CountAnimaisLoteRow>> countAnimaisLote({
    String? loteNome,
  }) =>
      performCountAnimaisLote(
        _database,
        loteNome: loteNome,
      );

  Future<List<BuscarRebanhoNumRow>> buscarRebanhoNum({
    String? idRebanho,
  }) =>
      performBuscarRebanhoNum(
        _database,
        idRebanho: idRebanho,
      );

  Future<List<BuscaRebanhoPaginadaPesquisaRow>> buscaRebanhoPaginadaPesquisa({
    String? idPropriedade,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? pesquisa,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) async {
    return performBuscaRebanhoPaginadaPesquisa(
      _database,
      idPropriedade: idPropriedade,
      sexo: sexo,
      categoria: categoria,
      raca: raca,
      origem: origem,
      loteId: loteId,
      pesquisa: pesquisa,
      statusReb: statusReb,
      dataNascInicio: dataNascInicio,
      dataNascFim: dataNascFim,
    );
  }

  Future<List<ListarReproducoesPesqRow>> listarReproducoesPesq({
    String? idPropriedade,
    String? tipoRepro,
    String? inseminador,
    String? loteNome,
    String? pesquisa,
    String? dataRepro,
    String? dataReproFim,
    String? dataPrev,
    String? dataPrevFim,
    String? dataHoje,
    String? categoriaFiltro,
    String? statusReproducaoFiltro,
  }) =>
      performListarReproducoesPesq(
        _database,
        idPropriedade: idPropriedade,
        tipoRepro: tipoRepro,
        inseminador: inseminador,
        loteNome: loteNome,
        pesquisa: pesquisa,
        dataRepro: dataRepro,
        dataReproFim: dataReproFim,
        dataPrev: dataPrev,
        dataPrevFim: dataPrevFim,
        dataHoje: dataHoje,
        categoriaFiltro: categoriaFiltro,
        statusReproducaoFiltro: statusReproducaoFiltro,
      );

  Future<List<BuscaSanidadesPesqRow>> buscaSanidadesPesq({
    String? idPropriedade,
    String? pesquisa,
    String? vacinas,
    String? antiparasitario,
    String? tratamentos,
    String? protocolo,
    String? idRebanho,
    String? idLote,
    String? dataSanidade,
    String? dataSanidadeFim,
  }) =>
      performBuscaSanidadesPesq(
        _database,
        idPropriedade: idPropriedade,
        pesquisa: pesquisa,
        vacinas: vacinas,
        antiparasitario: antiparasitario,
        tratamentos: tratamentos,
        protocolo: protocolo,
        idRebanho: idRebanho,
        idLote: idLote,
        dataSanidade: dataSanidade,
        dataSanidadeFim: dataSanidadeFim,
      );

  Future<List<BuscaSanidadesPaginadaRow>> buscaSanidadesPaginada({
    String? idPropriedade,
    String? vacinas,
    String? antiparasitario,
    String? tratamentos,
    String? protocolo,
    String? idRebanho,
    String? idLote,
    String? dataSanidade,
    String? dataSanidadeFim,
    int? limitRows,
    int? offsetRows,
  }) =>
      performBuscaSanidadesPaginada(
        _database,
        idPropriedade: idPropriedade,
        vacinas: vacinas,
        antiparasitario: antiparasitario,
        tratamentos: tratamentos,
        protocolo: protocolo,
        idRebanho: idRebanho,
        idLote: idLote,
        dataSanidade: dataSanidade,
        dataSanidadeFim: dataSanidadeFim,
        limitRows: limitRows,
        offsetRows: offsetRows,
      );

  Future<List<QTDSanidadesRow>> qTDSanidades({
    String? idPropriedade,
  }) =>
      performQTDSanidades(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<BuscaUserLogadoRow>> buscaUserLogado({
    String? email,
  }) =>
      performBuscaUserLogado(
        _database,
        email: email,
      );

  Future<List<QtdAnimaisNoLoteRow>> qtdAnimaisNoLote({
    String? loteID,
  }) =>
      performQtdAnimaisNoLote(
        _database,
        loteID: loteID,
      );

  Future<List<QtdReproducoesNoLoteRow>> qtdReproducoesNoLote({
    String? loteID,
  }) =>
      performQtdReproducoesNoLote(
        _database,
        loteID: loteID,
      );

  Future<List<BuscarAnimaisDoLoteRow>> buscarAnimaisDoLote({
    String? loteid,
    String? idPropriedade,
  }) =>
      performBuscarAnimaisDoLote(
        _database,
        loteid: loteid,
        idPropriedade: idPropriedade,
      );

  Future<List<RebanhoPagOrdNumCresRow>> rebanhoPagOrdNumCres({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      _timedRebanhoQuery(
        'rebanhoPagOrdNumCres',
        () => performRebanhoPagOrdNumCres(
          _database,
          idPropriedade: idPropriedade,
          limitReb: limitReb,
          offsetReb: offsetReb,
          sexo: sexo,
          categoria: categoria,
          raca: raca,
          origem: origem,
          loteId: loteId,
          statusReb: statusReb,
          dataNascInicio: dataNascInicio,
          dataNascFim: dataNascFim,
        ),
      );

  Future<List<RebanhoPagOrdNumDescRow>> rebanhoPagOrdNumDesc({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      _timedRebanhoQuery(
        'rebanhoPagOrdNumDesc',
        () => performRebanhoPagOrdNumDesc(
          _database,
          idPropriedade: idPropriedade,
          limitReb: limitReb,
          offsetReb: offsetReb,
          sexo: sexo,
          categoria: categoria,
          raca: raca,
          origem: origem,
          loteId: loteId,
          statusReb: statusReb,
          dataNascInicio: dataNascInicio,
          dataNascFim: dataNascFim,
        ),
      );

  Future<List<RebanhoPagOrdNomCresRow>> rebanhoPagOrdNomCres({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      _timedRebanhoQuery(
        'rebanhoPagOrdNomCres',
        () => performRebanhoPagOrdNomCres(
          _database,
          idPropriedade: idPropriedade,
          limitReb: limitReb,
          offsetReb: offsetReb,
          sexo: sexo,
          categoria: categoria,
          raca: raca,
          origem: origem,
          loteId: loteId,
          statusReb: statusReb,
          dataNascInicio: dataNascInicio,
          dataNascFim: dataNascFim,
        ),
      );

  Future<List<RebanhoPagOrdNomDescRow>> rebanhoPagOrdNomDesc({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      _timedRebanhoQuery(
        'rebanhoPagOrdNomDesc',
        () => performRebanhoPagOrdNomDesc(
          _database,
          idPropriedade: idPropriedade,
          limitReb: limitReb,
          offsetReb: offsetReb,
          sexo: sexo,
          categoria: categoria,
          raca: raca,
          origem: origem,
          loteId: loteId,
          statusReb: statusReb,
          dataNascInicio: dataNascInicio,
          dataNascFim: dataNascFim,
        ),
      );

  Future<List<RebanhoPagOrdDataCresRow>> rebanhoPagOrdDataCres({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      _timedRebanhoQuery(
        'rebanhoPagOrdDataCres',
        () => performRebanhoPagOrdDataCres(
          _database,
          idPropriedade: idPropriedade,
          limitReb: limitReb,
          offsetReb: offsetReb,
          sexo: sexo,
          categoria: categoria,
          raca: raca,
          origem: origem,
          loteId: loteId,
          statusReb: statusReb,
          dataNascInicio: dataNascInicio,
          dataNascFim: dataNascFim,
        ),
      );

  Future<List<RebanhoPagOrdDataDescRow>> rebanhoPagOrdDataDesc({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? loteId,
    String? statusReb,
    String? dataNascInicio,
    String? dataNascFim,
  }) =>
      _timedRebanhoQuery(
        'rebanhoPagOrdDataDesc',
        () => performRebanhoPagOrdDataDesc(
          _database,
          idPropriedade: idPropriedade,
          limitReb: limitReb,
          offsetReb: offsetReb,
          sexo: sexo,
          categoria: categoria,
          raca: raca,
          origem: origem,
          loteId: loteId,
          statusReb: statusReb,
          dataNascInicio: dataNascInicio,
          dataNascFim: dataNascFim,
        ),
      );

  Future<List<ListarPropriedadesCrescNomeRow>> listarPropriedadesCrescNome({
    String? userID,
  }) =>
      performListarPropriedadesCrescNome(
        _database,
        userID: userID,
      );

  Future<List<ListarPropriedadesDecNomeRow>> listarPropriedadesDecNome({
    String? userID,
  }) =>
      performListarPropriedadesDecNome(
        _database,
        userID: userID,
      );

  Future<List<BuscaRebanhoPopupRow>> buscaRebanhoPopup({
    String? idPropriedade,
    String? pesquisa,
    String? sexo,
    String? statusRebanho,
    String? categoria,
    String? categoriaExcluir,
    String? excludeIdRebanho,
    int limit = 30,
  }) =>
      performBuscaRebanhoPopup(
        _database,
        idPropriedade: idPropriedade,
        pesquisa: pesquisa,
        sexo: sexo,
        statusRebanho: statusRebanho,
        categoria: categoria,
        categoriaExcluir: categoriaExcluir,
        excludeIdRebanho: excludeIdRebanho,
        limit: limit,
      );

  Future<List<RebanhoPopupSPRow>> rebanhoPopupSP({
    String? idPropriedade,
  }) =>
      performRebanhoPopupSP(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<ListaInseminadoresRow>> listaInseminadores({
    String? propriedade,
  }) =>
      performListaInseminadores(
        _database,
        propriedade: propriedade,
      );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  Future insertPropriedade({
    String? userID,
    String? anotacoes,
    int? areaAgricultura,
    int? areaBenfeitoria,
    int? areaPastagem,
    int? areaReserva,
    int? areaTotal,
    String? cidade,
    String? estado,
    String? icone,
    String? idPropriedade,
    String? atividades,
    String? nome,
    String? updatedat,
    String? createdat,
    String? usersID,
    String? rebanhosID,
    String? deletado,
  }) =>
      performInsertPropriedade(
        _database,
        userID: userID,
        anotacoes: anotacoes,
        areaAgricultura: areaAgricultura,
        areaBenfeitoria: areaBenfeitoria,
        areaPastagem: areaPastagem,
        areaReserva: areaReserva,
        areaTotal: areaTotal,
        cidade: cidade,
        estado: estado,
        icone: icone,
        idPropriedade: idPropriedade,
        atividades: atividades,
        nome: nome,
        updatedat: updatedat,
        createdat: createdat,
        usersID: usersID,
        rebanhosID: rebanhosID,
        deletado: deletado,
      );

  Future deletarTodasPropriedades() => performDeletarTodasPropriedades(
        _database,
      );

  Future deleteProp({
    String? idPropriedade,
  }) =>
      performDeleteProp(
        _database,
        idPropriedade: idPropriedade,
      );

  Future updatePropriedade({
    String? idPropriedade,
    String? nome,
    String? estado,
    String? cidade,
    int? areaAgricultura,
    int? areaBenfeitoria,
    int? areaPastagem,
    int? areaReserva,
    int? areaTotal,
    String? icone,
    String? atividades,
    String? anotacoes,
    String? usersID,
    String? updatedat,
  }) =>
      performUpdatePropriedade(
        _database,
        idPropriedade: idPropriedade,
        nome: nome,
        estado: estado,
        cidade: cidade,
        areaAgricultura: areaAgricultura,
        areaBenfeitoria: areaBenfeitoria,
        areaPastagem: areaPastagem,
        areaReserva: areaReserva,
        areaTotal: areaTotal,
        icone: icone,
        atividades: atividades,
        anotacoes: anotacoes,
        usersID: usersID,
        updatedat: updatedat,
      );

  Future addUserNaPropriedade({
    String? usersID,
    String? idPropriedade,
    String? updatedat,
  }) =>
      performAddUserNaPropriedade(
        _database,
        usersID: usersID,
        idPropriedade: idPropriedade,
        updatedat: updatedat,
      );

  Future inserirUserNaPropriedade({
    String? userID,
    String? nome,
    String? email,
    String? foto,
    String? permissao,
    String? idPropriedade,
    String? deletado,
  }) =>
      performInserirUserNaPropriedade(
        _database,
        userID: userID,
        nome: nome,
        email: email,
        foto: foto,
        permissao: permissao,
        idPropriedade: idPropriedade,
        deletado: deletado,
      );

  Future uPDTFuncaoUserLocal({
    String? permissao,
    String? userID,
  }) =>
      performUPDTFuncaoUserLocal(
        _database,
        permissao: permissao,
        userID: userID,
      );

  Future insertRebanho({
    String? idPropriedade,
    String? numeroAnimal,
    String? chip,
    String? codRegistro,
    String? nome,
    String? sexo,
    String? categoria,
    String? dataNascimento,
    double? pesoNascimento,
    String? porte,
    String? raca,
    String? dataEntradaLote,
    String? dataDesmama,
    double? pesoDesmama,
    double? pesoAtual,
    String? statusRebanho,
    String? origem,
    String? anotacoes,
    String? idRebanho,
    String? deletado,
    String? createdat,
    String? updatedat,
    String? tipo,
    String? dataAcao,
    double? valorCompra,
    String? dataUltimaPesagem,
    String? nomeConcat,
    String? loteID,
    String? loteNome,
    String? dataVenda,
    double? valorVenda,
    String? movimentacaoentrada,
    String? numeroMatriz,
    String? nomeMatriz,
    String? dataNascMatriz,
    String? racaMatriz,
    String? numeroReprodutor,
    String? nomeReprodutor,
    String? dataNascReprodutor,
    String? racaReprodutor,
    String? movimentacaosaida,
    String? datamorte,
    String? motivomorte,
    String? categoriamatriz,
    String? rebanhoIdMatriz,
    String? rebanhoIdReprodutor,
  }) async {
    await performInsertRebanho(
      _database,
      idPropriedade: idPropriedade,
      numeroAnimal: numeroAnimal,
      chip: chip,
      codRegistro: codRegistro,
      nome: nome,
      sexo: sexo,
      categoria: categoria,
      dataNascimento: dataNascimento,
      pesoNascimento: pesoNascimento,
      porte: porte,
      raca: raca,
      dataEntradaLote: dataEntradaLote,
      dataDesmama: dataDesmama,
      pesoDesmama: pesoDesmama,
      pesoAtual: pesoAtual,
      statusRebanho: statusRebanho,
      origem: origem,
      anotacoes: anotacoes,
      idRebanho: idRebanho,
      deletado: deletado,
      createdat: createdat,
      updatedat: updatedat,
      tipo: tipo,
      dataAcao: dataAcao,
      valorCompra: valorCompra,
      dataUltimaPesagem: dataUltimaPesagem,
      nomeConcat: nomeConcat,
      loteID: loteID,
      loteNome: loteNome,
      dataVenda: dataVenda,
      valorVenda: valorVenda,
      movimentacaoentrada: movimentacaoentrada,
      numeroMatriz: numeroMatriz,
      nomeMatriz: nomeMatriz,
      dataNascMatriz: dataNascMatriz,
      racaMatriz: racaMatriz,
      numeroReprodutor: numeroReprodutor,
      nomeReprodutor: nomeReprodutor,
      dataNascReprodutor: dataNascReprodutor,
      racaReprodutor: racaReprodutor,
      movimentacaosaida: movimentacaosaida,
      datamorte: datamorte,
      motivomorte: motivomorte,
      categoriamatriz: categoriamatriz,
      rebanhoIdMatriz: rebanhoIdMatriz,
      rebanhoIdReprodutor: rebanhoIdReprodutor,
    );
    await _upsertPesagemNascimentoSeInformada(
      idRebanho: idRebanho,
      dataNascimento: dataNascimento,
      pesoNascimento: pesoNascimento,
    );
  }

  Future deletarTodosRebanhos() => performDeletarTodosRebanhos(
        _database,
      );

  Future addRebanhoNaPropriedade({
    String? rebanhosID,
    String? updatedat,
    String? idPropriedade,
  }) =>
      performAddRebanhoNaPropriedade(
        _database,
        rebanhosID: rebanhosID,
        updatedat: updatedat,
        idPropriedade: idPropriedade,
      );

  Future insertRebanhoNascimento({
    String? idPropriedade,
    String? numeroAnimal,
    String? chip,
    String? codRegistro,
    String? nome,
    String? sexo,
    String? categoria,
    String? dataNascimento,
    double? pesoNascimento,
    String? porte,
    String? raca,
    String? dataEntradaLote,
    String? statusRebanho,
    String? anotacoes,
    String? idRebanho,
    String? deletado,
    String? createdat,
    String? updatedat,
    String? tipo,
    String? loteNome,
    String? loteID,
    String? dataVenda,
    double? valorVenda,
    String? numeroMatriz,
    String? nomeMatriz,
    String? dataNascMatriz,
    String? racaMatriz,
    String? numeroReprodutor,
    String? nomeReprodutor,
    String? dataNascReprodutor,
    String? racaReprodutor,
    String? movimentacaosaida,
    String? datamorte,
    String? motivomorte,
    String? categoriamatriz,
    String? rebanhoIdMatriz,
    String? rebanhoIdReprodutor,
  }) async {
    await performInsertRebanhoNascimento(
      _database,
      idPropriedade: idPropriedade,
      numeroAnimal: numeroAnimal,
      chip: chip,
      codRegistro: codRegistro,
      nome: nome,
      sexo: sexo,
      categoria: categoria,
      dataNascimento: dataNascimento,
      pesoNascimento: pesoNascimento,
      porte: porte,
      raca: raca,
      dataEntradaLote: dataEntradaLote,
      statusRebanho: statusRebanho,
      anotacoes: anotacoes,
      idRebanho: idRebanho,
      deletado: deletado,
      createdat: createdat,
      updatedat: updatedat,
      tipo: tipo,
      loteNome: loteNome,
      loteID: loteID,
      dataVenda: dataVenda,
      valorVenda: valorVenda,
      numeroMatriz: numeroMatriz,
      nomeMatriz: nomeMatriz,
      dataNascMatriz: dataNascMatriz,
      racaMatriz: racaMatriz,
      numeroReprodutor: numeroReprodutor,
      nomeReprodutor: nomeReprodutor,
      dataNascReprodutor: dataNascReprodutor,
      racaReprodutor: racaReprodutor,
      movimentacaosaida: movimentacaosaida,
      datamorte: datamorte,
      motivomorte: motivomorte,
      categoriamatriz: categoriamatriz,
      rebanhoIdMatriz: rebanhoIdMatriz,
      rebanhoIdReprodutor: rebanhoIdReprodutor,
    );
    await _upsertPesagemNascimentoSeInformada(
      idRebanho: idRebanho,
      dataNascimento: dataNascimento,
      pesoNascimento: pesoNascimento,
    );
  }

  Future insertRebanhoSemen({
    String? idPropriedade,
    String? numeroAnimal,
    String? codRegistro,
    String? nome,
    String? raca,
    String? anotacoes,
    String? idRebanho,
    String? deletado,
    String? createdat,
    String? updatedat,
    String? tipo,
    String? sexo,
    String? categoria,
    String? nomeConcat,
    String? statusRebanho,
  }) =>
      performInsertRebanhoSemen(
        _database,
        idPropriedade: idPropriedade,
        numeroAnimal: numeroAnimal,
        codRegistro: codRegistro,
        nome: nome,
        raca: raca,
        anotacoes: anotacoes,
        idRebanho: idRebanho,
        deletado: deletado,
        createdat: createdat,
        updatedat: updatedat,
        tipo: tipo,
        sexo: sexo,
        categoria: categoria,
        nomeConcat: nomeConcat,
        statusRebanho: statusRebanho,
      );

  Future<void> addPesagem({
    String? idPesagem,
    String? idRebanho,
    String? dataPesagem,
    String? tipo,
    double? peso,
    String? deletado,
    String? createdat,
    String? idPropriedade,
  }) async {
    final resolvedIdPesagem = idPesagem ?? 'uuid:${Uuid().v4()}';
    await performAddPesagem(
      _database,
      idPesagem: resolvedIdPesagem,
      idRebanho: idRebanho,
      dataPesagem: dataPesagem,
      tipo: tipo,
      peso: peso,
      deletado: deletado,
      createdat: createdat,
      idPropriedade: idPropriedade,
    );

    await _syncUltimaPesagemNoRebanho(idRebanho);
  }

  /// Updates peso (and optionally dataPesagem) of an existing pesagem record
  /// matching [idRebanho] + [tipo]. If no record exists, creates one.
  Future<void> updatePesagemByTipo({
    required String idRebanho,
    required String tipo,
    required double peso,
    String? dataPesagem,
  }) async {
    // Check if a record already exists
    final existing = await _database.rawQuery('''
SELECT id FROM local_historico_pesagens
WHERE idRebanho = ?
AND tipo = ?
AND COALESCE(deletado, 'NAO') != 'SIM'
LIMIT 1
''', [idRebanho, tipo]);

    if (existing.isNotEmpty) {
      final syncUpdatedAt = DateTime.now()
          .toIso8601String()
          .substring(0, 19)
          .replaceFirst('T', ' ');
      if (dataPesagem != null) {
        await _database.rawUpdate('''
UPDATE local_historico_pesagens
SET peso = ?, dataPesagem = ?, sync_dirty = 1, sync_op = 'upsert', sync_updated_at = ?
WHERE idRebanho = ?
AND tipo = ?
AND COALESCE(deletado, 'NAO') != 'SIM'
''', [peso, dataPesagem, syncUpdatedAt, idRebanho, tipo]);
      } else {
        await _database.rawUpdate('''
UPDATE local_historico_pesagens
SET peso = ?, sync_dirty = 1, sync_op = 'upsert', sync_updated_at = ?
WHERE idRebanho = ?
AND tipo = ?
AND COALESCE(deletado, 'NAO') != 'SIM'
''', [peso, syncUpdatedAt, idRebanho, tipo]);
      }
    } else {
      // No record exists — get idPropriedade from rebanho and insert
      final rebRows = await _database.rawQuery('''
SELECT idPropriedade FROM local_rebanho WHERE idRebanho = ? LIMIT 1
''', [idRebanho]);
      final idPropriedade =
          rebRows.isNotEmpty ? rebRows.first['idPropriedade'] as String? : null;
      final now = DateTime.now()
          .toIso8601String()
          .substring(0, 19)
          .replaceFirst('T', ' ');
      await performAddPesagem(
        _database,
        idPesagem: 'uuid:${Uuid().v4()}',
        idRebanho: idRebanho,
        dataPesagem:
            dataPesagem ?? DateTime.now().toIso8601String().substring(0, 10),
        tipo: tipo,
        peso: peso,
        deletado: 'NAO',
        createdat: now,
        idPropriedade: idPropriedade,
      );
    }
    await _syncUltimaPesagemNoRebanho(idRebanho);
  }

  Future<void> _upsertPesagemNascimentoSeInformada({
    String? idRebanho,
    String? dataNascimento,
    double? pesoNascimento,
  }) async {
    final normalizedIdRebanho = idRebanho?.trim() ?? '';
    final normalizedDataNascimento = dataNascimento?.trim() ?? '';
    final dataNascimentoValida = normalizedDataNascimento.isNotEmpty &&
        normalizedDataNascimento.toLowerCase() != 'null' &&
        normalizedDataNascimento != '-';

    if (normalizedIdRebanho.isEmpty ||
        !dataNascimentoValida ||
        pesoNascimento == null) {
      return;
    }

    await updatePesagemByTipo(
      idRebanho: normalizedIdRebanho,
      tipo: 'Nascimento',
      peso: pesoNascimento,
      dataPesagem: normalizedDataNascimento,
    );
  }

  Future<void> syncUltimaPesagemNoRebanho({
    String? idRebanho,
  }) async {
    await _syncUltimaPesagemNoRebanho(idRebanho);
  }

  Future<void> _syncUltimaPesagemNoRebanho(String? idRebanho) async {
    if (idRebanho == null || idRebanho.isEmpty) {
      return;
    }

    final ultimaPesagem = await _database.rawQuery('''
SELECT peso, dataPesagem
FROM local_historico_pesagens
WHERE idRebanho = ?
AND COALESCE(deletado, 'NAO') != 'SIM'
AND COALESCE(dataPesagem, '') != ''
ORDER BY date(dataPesagem) DESC,
         datetime(COALESCE(created_at, '1970-01-01'), 'localtime') DESC,
         id DESC
LIMIT 1
''', [idRebanho]);

    final rebanhoAtual = await _database.rawQuery('''
SELECT pesoAtual, dataUltimaPesagem
FROM local_rebanho
WHERE idRebanho = ?
LIMIT 1
''', [idRebanho]);

    if (ultimaPesagem.isEmpty) {
      final current = rebanhoAtual.firstOrNull;
      final currentPeso = current?['pesoAtual'];
      final currentData = current?['dataUltimaPesagem']?.toString() ?? '';
      if (currentPeso == null && currentData.isEmpty) {
        return;
      }

      await _updatePesoRebanhoCache(
        peso: null,
        data: '',
        idRebanho: idRebanho,
      );
      return;
    }

    final row = ultimaPesagem.first;
    final rawPeso = row['peso'];
    final double? peso = rawPeso is num
        ? rawPeso.toDouble()
        : rawPeso is String
            ? double.tryParse(rawPeso)
            : null;
    final dataPesagem = row['dataPesagem'] as String?;
    final current = rebanhoAtual.firstOrNull;
    final rawCurrentPeso = current?['pesoAtual'];
    final currentPeso = rawCurrentPeso is num
        ? rawCurrentPeso.toDouble()
        : rawCurrentPeso is String
            ? double.tryParse(rawCurrentPeso)
            : null;
    final currentData = current?['dataUltimaPesagem']?.toString() ?? '';
    final nextData = dataPesagem ?? '';

    if (currentPeso == peso && currentData == nextData) {
      return;
    }

    await _updatePesoRebanhoCache(
      peso: peso,
      data: dataPesagem,
      idRebanho: idRebanho,
    );
  }

  Future<void> _updatePesoRebanhoCache({
    double? peso,
    String? data,
    required String idRebanho,
  }) async {
    await _database.rawUpdate(
      '''
UPDATE local_rebanho
SET pesoAtual = ?,
    dataUltimaPesagem = ?
WHERE idRebanho = ?
''',
      [peso, data ?? '', idRebanho],
    );
  }

  Future uPDTPesoRebanho({
    double? peso,
    String? data,
    String? idRebanho,
  }) =>
      performUPDTPesoRebanho(
        _database,
        peso: peso,
        data: data,
        idRebanho: idRebanho,
      );

  Future uPDTRebanho({
    String? numeroAnimal,
    String? chip,
    String? codRegistro,
    String? nome,
    String? sexo,
    String? categoria,
    String? dataNascimento,
    double? pesoNascimento,
    String? porte,
    String? raca,
    String? dataEntradaLote,
    String? dataDesmama,
    double? pesoDesmama,
    String? statusRebanho,
    String? origem,
    String? anotacoes,
    String? dataAcao,
    double? valorCompra,
    String? nomeConcat,
    String? idRebanho,
    String? updatedat,
    String? loteNome,
    String? loteID,
    String? movimentacaoentrada,
    String? dataVenda,
    String? valorVenda,
    String? numeroMatriz,
    String? dataNascMatriz,
    String? racaMatriz,
    String? numeroReprodutor,
    String? nomeReprodutor,
    String? dataNascReprodutor,
    String? racaReprodutor,
    String? nomeMatriz,
    String? movimentacaosaida,
    String? datamorte,
    String? motivomorte,
    String? categoriamatriz,
    String? rebanhoIdMatriz,
    String? rebanhoIdReprodutor,
  }) async {
    await performUPDTRebanho(
      _database,
      numeroAnimal: numeroAnimal,
      chip: chip,
      codRegistro: codRegistro,
      nome: nome,
      sexo: sexo,
      categoria: categoria,
      dataNascimento: dataNascimento,
      pesoNascimento: pesoNascimento,
      porte: porte,
      raca: raca,
      dataEntradaLote: dataEntradaLote,
      dataDesmama: dataDesmama,
      pesoDesmama: pesoDesmama,
      statusRebanho: statusRebanho,
      origem: origem,
      anotacoes: anotacoes,
      dataAcao: dataAcao,
      valorCompra: valorCompra,
      nomeConcat: nomeConcat,
      idRebanho: idRebanho,
      updatedat: updatedat,
      loteNome: loteNome,
      loteID: loteID,
      movimentacaoentrada: movimentacaoentrada,
      dataVenda: dataVenda,
      valorVenda: valorVenda,
      numeroMatriz: numeroMatriz,
      dataNascMatriz: dataNascMatriz,
      racaMatriz: racaMatriz,
      numeroReprodutor: numeroReprodutor,
      nomeReprodutor: nomeReprodutor,
      dataNascReprodutor: dataNascReprodutor,
      racaReprodutor: racaReprodutor,
      nomeMatriz: nomeMatriz,
      movimentacaosaida: movimentacaosaida,
      datamorte: datamorte,
      motivomorte: motivomorte,
      categoriamatriz: categoriamatriz,
      rebanhoIdMatriz: rebanhoIdMatriz,
      rebanhoIdReprodutor: rebanhoIdReprodutor,
    );
    await _upsertPesagemNascimentoSeInformada(
      idRebanho: idRebanho,
      dataNascimento: dataNascimento,
      pesoNascimento: pesoNascimento,
    );
  }

  Future<void> deletePesagem({
    String? idRebanho,
    int? idPesagem,
  }) async {
    await performDeletePesagem(
      _database,
      idRebanho: idRebanho,
      idPesagem: idPesagem,
    );

    await _syncUltimaPesagemNoRebanho(idRebanho);
  }

  Future deletarTodasPesagens() => performDeletarTodasPesagens(
        _database,
      );

  Future uPDTRebanhoCopy({
    String? numeroAnimal,
    String? idRebanho,
  }) =>
      performUPDTRebanhoCopy(
        _database,
        numeroAnimal: numeroAnimal,
        idRebanho: idRebanho,
      );

  Future insertLote({
    String? idPropriedade,
    String? nome,
    String? anotacoes,
    String? ativo,
    String? motivo,
    String? dataMotivo,
    String? idLote,
    String? deletado,
    String? createdat,
    String? updatedat,
    double? valorVenda,
  }) =>
      performInsertLote(
        _database,
        idPropriedade: idPropriedade,
        nome: nome,
        anotacoes: anotacoes,
        ativo: ativo,
        motivo: motivo,
        dataMotivo: dataMotivo,
        idLote: idLote,
        deletado: deletado,
        createdat: createdat,
        updatedat: updatedat,
        valorVenda: valorVenda,
      );

  Future uPDTRebanhoLote({
    String? loteNome,
    String? loteID,
    String? updatedat,
    String? idRebanho,
    String? dataEntradaLote,
  }) =>
      performUPDTRebanhoLote(
        _database,
        loteNome: loteNome,
        loteID: loteID,
        updatedat: updatedat,
        idRebanho: idRebanho,
        dataEntradaLote: dataEntradaLote,
      );

  Future deleteAllLotes() => performDeleteAllLotes(
        _database,
      );

  Future uPDTLote({
    String? nome,
    String? anotacoes,
    String? ativo,
    String? motivo,
    String? dataMotivo,
    String? updatedat,
    String? idLote,
    double? valorVenda,
  }) =>
      performUPDTLote(
        _database,
        nome: nome,
        anotacoes: anotacoes,
        ativo: ativo,
        motivo: motivo,
        dataMotivo: dataMotivo,
        updatedat: updatedat,
        idLote: idLote,
        valorVenda: valorVenda,
      );

  Future insertReproducao({
    String? idPropriedade,
    String? tipoReproducao,
    double? scoreCorporal,
    String? dataInseminacao,
    String? dataPartidaSemen,
    int? partidaSemen,
    String? previsaoParto,
    String? idLote,
    String? dataInicial,
    String? dataFinal,
    String? inseminador,
    String? anotacoes,
    String? idReproducao,
    String? deletado,
    String? createdAt,
    String? updatedAt,
    String? categoria,
    String? numMatriz,
    String? nomeMatriz,
    String? nascimentoMatriz,
    String? numReprodutor,
    String? nomeReprodutor,
    String? nascimentoReprodutor,
    String? loteNome,
    String? statusReproducao,
    String? dataStatus,
    String? racaMatriz,
    String? racaReprodutor,
    String? chipReprodutor,
    String? chipMatriz,
    String? ressinc,
    String? parida,
    String? dataParto,
    String? idrebanhomatriz,
    String? idrebanhoreprodutor,
    String? gnrh,
    String? cio,
  }) =>
      performInsertReproducao(
        _database,
        idPropriedade: idPropriedade,
        tipoReproducao: tipoReproducao,
        scoreCorporal: scoreCorporal,
        dataInseminacao: dataInseminacao,
        dataPartidaSemen: dataPartidaSemen,
        partidaSemen: partidaSemen,
        previsaoParto: previsaoParto,
        idLote: idLote,
        dataInicial: dataInicial,
        dataFinal: dataFinal,
        inseminador: inseminador,
        anotacoes: anotacoes,
        idReproducao: idReproducao,
        deletado: deletado,
        createdAt: createdAt,
        updatedAt: updatedAt,
        categoria: categoria,
        numMatriz: numMatriz,
        nomeMatriz: nomeMatriz,
        nascimentoMatriz: nascimentoMatriz,
        numReprodutor: numReprodutor,
        nomeReprodutor: nomeReprodutor,
        nascimentoReprodutor: nascimentoReprodutor,
        loteNome: loteNome,
        statusReproducao: statusReproducao,
        dataStatus: dataStatus,
        racaMatriz: racaMatriz,
        racaReprodutor: racaReprodutor,
        chipReprodutor: chipReprodutor,
        chipMatriz: chipMatriz,
        ressinc: ressinc,
        parida: parida,
        dataParto: dataParto,
        idrebanhomatriz: idrebanhomatriz,
        idrebanhoreprodutor: idrebanhoreprodutor,
        gnrh: gnrh,
        cio: cio,
      );

  Future deleteReproducaoReb({
    String? idReproducao,
    String? updatedat,
  }) =>
      performDeleteReproducaoReb(
        _database,
        idReproducao: idReproducao,
        updatedat: updatedat,
      );

  Future uPDTReproducao({
    String? tipoReproducao,
    double? scoreCorporal,
    String? dataInseminacao,
    String? dataPartidaSemen,
    int? partidaSemen,
    String? previsaoParto,
    String? dataInicial,
    String? dataFinal,
    String? inseminador,
    String? anotacoes,
    String? idReproducao,
    String? deletado,
    String? updatedAt,
    String? numMatriz,
    String? nomeMatriz,
    String? nascimentoMatriz,
    String? numReprodutor,
    String? nomeReprodutor,
    String? nascimentoReprodutor,
    String? statusReproducao,
    String? dataStatus,
    String? racaMatriz,
    String? racaReprodutor,
    String? chipReprodutor,
    String? chipMatriz,
    String? ressinc,
    String? parida,
    String? dataParto,
    String? idrebanhomatriz,
    String? idrebanhoreprodutor,
    String? gnrh,
    String? cio,
  }) =>
      performUPDTReproducao(
        _database,
        tipoReproducao: tipoReproducao,
        scoreCorporal: scoreCorporal,
        dataInseminacao: dataInseminacao,
        dataPartidaSemen: dataPartidaSemen,
        partidaSemen: partidaSemen,
        previsaoParto: previsaoParto,
        dataInicial: dataInicial,
        dataFinal: dataFinal,
        inseminador: inseminador,
        anotacoes: anotacoes,
        idReproducao: idReproducao,
        deletado: deletado,
        updatedAt: updatedAt,
        numMatriz: numMatriz,
        nomeMatriz: nomeMatriz,
        nascimentoMatriz: nascimentoMatriz,
        numReprodutor: numReprodutor,
        nomeReprodutor: nomeReprodutor,
        nascimentoReprodutor: nascimentoReprodutor,
        statusReproducao: statusReproducao,
        dataStatus: dataStatus,
        racaMatriz: racaMatriz,
        racaReprodutor: racaReprodutor,
        chipReprodutor: chipReprodutor,
        chipMatriz: chipMatriz,
        ressinc: ressinc,
        parida: parida,
        dataParto: dataParto,
        idrebanhomatriz: idrebanhomatriz,
        idrebanhoreprodutor: idrebanhoreprodutor,
        gnrh: gnrh,
        cio: cio,
      );

  Future deleteAllReproducao() => performDeleteAllReproducao(
        _database,
      );

  Future insertSanidadeAnimal({
    String? idPropriedade,
    String? idRebanho,
    String? dataSanidade,
    String? idLote,
    double? porcentagemLote,
    String? idSanidade,
    String? updatedat,
    String? deletado,
    String? vacinacao,
    String? vacinacaoOutros,
    String? vacinacaoObs,
    String? antiparasitario,
    String? antiparasitarioOutros,
    String? antiparasitarioObs,
    String? tratamento,
    String? tratamentoOutros,
    String? tratamentoObs,
    String? protocoloReprodutivo,
    String? protocoloreprodutivoOutros,
    String? protocoloreprodutivoObs,
    String? createdat,
    String? protocolod0,
    String? protocoloretirada,
    String? protocoloiatf,
  }) =>
      performInsertSanidadeAnimal(
        _database,
        idPropriedade: idPropriedade,
        idRebanho: idRebanho,
        dataSanidade: dataSanidade,
        idLote: idLote,
        porcentagemLote: porcentagemLote,
        idSanidade: idSanidade,
        updatedat: updatedat,
        deletado: deletado,
        vacinacao: vacinacao,
        vacinacaoOutros: vacinacaoOutros,
        vacinacaoObs: vacinacaoObs,
        antiparasitario: antiparasitario,
        antiparasitarioOutros: antiparasitarioOutros,
        antiparasitarioObs: antiparasitarioObs,
        tratamento: tratamento,
        tratamentoOutros: tratamentoOutros,
        tratamentoObs: tratamentoObs,
        protocoloReprodutivo: protocoloReprodutivo,
        protocoloreprodutivoOutros: protocoloreprodutivoOutros,
        protocoloreprodutivoObs: protocoloreprodutivoObs,
        createdat: createdat,
        protocolod0: protocolod0,
        protocoloretirada: protocoloretirada,
        protocoloiatf: protocoloiatf,
      );

  Future deleteSanidade({
    String? idSanidade,
    String? updatedat,
  }) =>
      performDeleteSanidade(
        _database,
        idSanidade: idSanidade,
        updatedat: updatedat,
      );

  Future insertSanidadeLote({
    String? idPropriedade,
    String? dataSanidade,
    String? idSanidade,
    String? updatedat,
    String? deletado,
    String? vacinacao,
    String? vacinacaoOutros,
    String? vacinacaoObs,
    String? antiparasitario,
    String? antiparasitarioOutros,
    String? antiparasitarioObs,
    String? tratamento,
    String? tratamentoOutros,
    String? tratamentoObs,
    String? protocoloReprodutivo,
    String? protocoloreprodutivoOutros,
    String? protocoloreprodutivoObs,
    String? createdat,
    String? idLote,
    double? porcentagemLote,
  }) =>
      performInsertSanidadeLote(
        _database,
        idPropriedade: idPropriedade,
        dataSanidade: dataSanidade,
        idSanidade: idSanidade,
        updatedat: updatedat,
        deletado: deletado,
        vacinacao: vacinacao,
        vacinacaoOutros: vacinacaoOutros,
        vacinacaoObs: vacinacaoObs,
        antiparasitario: antiparasitario,
        antiparasitarioOutros: antiparasitarioOutros,
        antiparasitarioObs: antiparasitarioObs,
        tratamento: tratamento,
        tratamentoOutros: tratamentoOutros,
        tratamentoObs: tratamentoObs,
        protocoloReprodutivo: protocoloReprodutivo,
        protocoloreprodutivoOutros: protocoloreprodutivoOutros,
        protocoloreprodutivoObs: protocoloreprodutivoObs,
        createdat: createdat,
        idLote: idLote,
        porcentagemLote: porcentagemLote,
      );

  Future uPDTSanidadeAnimal({
    String? dataSanidade,
    String? idSanidade,
    String? updatedat,
    String? vacinacao,
    String? vacinacaoOutros,
    String? vacinacaoObs,
    String? antiparasitario,
    String? antiparasitarioOutros,
    String? antiparasitarioObs,
    String? tratamento,
    String? tratamentoOutros,
    String? tratamentoObs,
    String? protocoloReprodutivo,
    String? protocoloreprodutivoOutros,
    String? protocoloreprodutivoObs,
    String? protocolod0,
    String? protocoloretirada,
    String? protocoloiatf,
  }) =>
      performUPDTSanidadeAnimal(
        _database,
        dataSanidade: dataSanidade,
        idSanidade: idSanidade,
        updatedat: updatedat,
        vacinacao: vacinacao,
        vacinacaoOutros: vacinacaoOutros,
        vacinacaoObs: vacinacaoObs,
        antiparasitario: antiparasitario,
        antiparasitarioOutros: antiparasitarioOutros,
        antiparasitarioObs: antiparasitarioObs,
        tratamento: tratamento,
        tratamentoOutros: tratamentoOutros,
        tratamentoObs: tratamentoObs,
        protocoloReprodutivo: protocoloReprodutivo,
        protocoloreprodutivoOutros: protocoloreprodutivoOutros,
        protocoloreprodutivoObs: protocoloreprodutivoObs,
        protocolod0: protocolod0,
        protocoloretirada: protocoloretirada,
        protocoloiatf: protocoloiatf,
      );

  Future deleteAllSanidades() => performDeleteAllSanidades(
        _database,
      );

  Future uPDTSanidadeLote({
    String? dataSanidade,
    String? idSanidade,
    String? updatedat,
    String? vacinacao,
    String? vacinacaoOutros,
    String? vacinacaoObs,
    String? antiparasitario,
    String? antiparasitarioOutros,
    String? antiparasitarioObs,
    String? tratamento,
    String? tratamentoOutros,
    String? tratamentoObs,
    String? protocoloReprodutivo,
    String? protocoloreprodutivoOutros,
    String? protocoloreprodutivoObs,
    double? porcentagemLote,
  }) =>
      performUPDTSanidadeLote(
        _database,
        dataSanidade: dataSanidade,
        idSanidade: idSanidade,
        updatedat: updatedat,
        vacinacao: vacinacao,
        vacinacaoOutros: vacinacaoOutros,
        vacinacaoObs: vacinacaoObs,
        antiparasitario: antiparasitario,
        antiparasitarioOutros: antiparasitarioOutros,
        antiparasitarioObs: antiparasitarioObs,
        tratamento: tratamento,
        tratamentoOutros: tratamentoOutros,
        tratamentoObs: tratamentoObs,
        protocoloReprodutivo: protocoloReprodutivo,
        protocoloreprodutivoOutros: protocoloreprodutivoOutros,
        protocoloreprodutivoObs: protocoloreprodutivoObs,
        porcentagemLote: porcentagemLote,
      );

  Future insertSanidadeSync({
    String? idPropriedade,
    String? dataSanidade,
    String? idSanidade,
    String? updatedat,
    String? deletado,
    String? vacinacao,
    String? vacinacaoOutros,
    String? vacinacaoObs,
    String? antiparasitario,
    String? antiparasitarioOutros,
    String? antiparasitarioObs,
    String? tratamento,
    String? tratamentoOutros,
    String? tratamentoObs,
    String? protocoloReprodutivo,
    String? protocoloreprodutivoOutros,
    String? protocoloreprodutivoObs,
    String? createdat,
    String? idLote,
    double? porcentagemLote,
    String? idRebanho,
  }) =>
      performInsertSanidadeSync(
        _database,
        idPropriedade: idPropriedade,
        dataSanidade: dataSanidade,
        idSanidade: idSanidade,
        updatedat: updatedat,
        deletado: deletado,
        vacinacao: vacinacao,
        vacinacaoOutros: vacinacaoOutros,
        vacinacaoObs: vacinacaoObs,
        antiparasitario: antiparasitario,
        antiparasitarioOutros: antiparasitarioOutros,
        antiparasitarioObs: antiparasitarioObs,
        tratamento: tratamento,
        tratamentoOutros: tratamentoOutros,
        tratamentoObs: tratamentoObs,
        protocoloReprodutivo: protocoloReprodutivo,
        protocoloreprodutivoOutros: protocoloreprodutivoOutros,
        protocoloreprodutivoObs: protocoloreprodutivoObs,
        createdat: createdat,
        idLote: idLote,
        porcentagemLote: porcentagemLote,
        idRebanho: idRebanho,
      );

  Future deleteRebanho({
    String? idRebanho,
    String? updatedat,
  }) =>
      performDeleteRebanho(
        _database,
        idRebanho: idRebanho,
        updatedat: updatedat,
      );

  Future deletarLote({
    String? idLote,
  }) =>
      performDeletarLote(
        _database,
        idLote: idLote,
      );

  Future deletePropriedade({
    String? idPropriedade,
    String? updatedat,
  }) =>
      performDeletePropriedade(
        _database,
        idPropriedade: idPropriedade,
        updatedat: updatedat,
      );

  Future deleteLote({
    String? idLote,
    String? updatedat,
  }) =>
      performDeleteLote(
        _database,
        idLote: idLote,
        updatedat: updatedat,
      );

  Future apagarRebLocal({
    String? idRebanho,
  }) =>
      performApagarRebLocal(
        _database,
        idRebanho: idRebanho,
      );

  Future apagarPesagemLocal({
    String? idRebanho,
  }) =>
      performApagarPesagemLocal(
        _database,
        idRebanho: idRebanho,
      );

  Future apagarReproLocal({
    String? idRepro,
  }) =>
      performApagarReproLocal(
        _database,
        idRepro: idRepro,
      );

  Future insertReproducaoMonta({
    String? idPropriedade,
    String? tipoReproducao,
    double? scoreCorporal,
    String? idLote,
    String? dataInicial,
    String? dataFinal,
    String? anotacoes,
    String? idReproducao,
    String? deletado,
    String? createdAt,
    String? updatedAt,
    String? categoria,
    String? numMatriz,
    String? nomeMatriz,
    String? nascimentoMatriz,
    String? numReprodutor,
    String? nomeReprodutor,
    String? nascimentoReprodutor,
    String? loteNome,
    String? statusReproducao,
    String? dataStatus,
    String? racaMatriz,
    String? racaReprodutor,
    String? datainseminacao,
    String? chipReprodutor,
    String? chipMatriz,
    String? previsaoParto,
    String? ressinc,
    String? parida,
    String? dataParto,
    String? idrebanhomatriz,
    String? idrebanhoreprodutor,
    String? gnrh,
    String? cio,
  }) =>
      performInsertReproducaoMonta(
        _database,
        idPropriedade: idPropriedade,
        tipoReproducao: tipoReproducao,
        scoreCorporal: scoreCorporal,
        idLote: idLote,
        dataInicial: dataInicial,
        dataFinal: dataFinal,
        anotacoes: anotacoes,
        idReproducao: idReproducao,
        deletado: deletado,
        createdAt: createdAt,
        updatedAt: updatedAt,
        categoria: categoria,
        numMatriz: numMatriz,
        nomeMatriz: nomeMatriz,
        nascimentoMatriz: nascimentoMatriz,
        numReprodutor: numReprodutor,
        nomeReprodutor: nomeReprodutor,
        nascimentoReprodutor: nascimentoReprodutor,
        loteNome: loteNome,
        statusReproducao: statusReproducao,
        dataStatus: dataStatus,
        racaMatriz: racaMatriz,
        racaReprodutor: racaReprodutor,
        datainseminacao: datainseminacao,
        chipReprodutor: chipReprodutor,
        chipMatriz: chipMatriz,
        previsaoParto: previsaoParto,
        ressinc: ressinc,
        parida: parida,
        dataParto: dataParto,
        idrebanhomatriz: idrebanhomatriz,
        idrebanhoreprodutor: idrebanhoreprodutor,
        gnrh: gnrh,
        cio: cio,
      );

  Future deleteRepro({
    String? id,
  }) =>
      performDeleteRepro(
        _database,
        id: id,
      );

  Future uPDTRebanhoLoteVenda({
    String? loteNome,
    String? loteID,
    String? updatedat,
    String? idRebanho,
    String? dataEntradaLote,
    String? dataVenda,
    double? valorVenda,
  }) =>
      performUPDTRebanhoLoteVenda(
        _database,
        loteNome: loteNome,
        loteID: loteID,
        updatedat: updatedat,
        idRebanho: idRebanho,
        dataEntradaLote: dataEntradaLote,
        dataVenda: dataVenda,
        valorVenda: valorVenda,
      );

  Future uPDTReproducaoMonta({
    String? tipoReproducao,
    double? scoreCorporal,
    String? dataPartidaSemen,
    int? partidaSemen,
    String? previsaoParto,
    String? dataInicial,
    String? dataFinal,
    String? anotacoes,
    String? idReproducao,
    String? deletado,
    String? updatedAt,
    String? numMatriz,
    String? nomeMatriz,
    String? nascimentoMatriz,
    String? numReprodutor,
    String? nomeReprodutor,
    String? nascimentoReprodutor,
    String? statusReproducao,
    String? dataStatus,
    String? racaMatriz,
    String? racaReprodutor,
    String? chipReprodutor,
    String? chipMatriz,
    String? ressinc,
    String? parida,
    String? dataParto,
    String? idrebanhomatriz,
    String? idrebanhoreprodutor,
    String? gnrh,
    String? cio,
  }) =>
      performUPDTReproducaoMonta(
        _database,
        tipoReproducao: tipoReproducao,
        scoreCorporal: scoreCorporal,
        dataPartidaSemen: dataPartidaSemen,
        partidaSemen: partidaSemen,
        previsaoParto: previsaoParto,
        dataInicial: dataInicial,
        dataFinal: dataFinal,
        anotacoes: anotacoes,
        idReproducao: idReproducao,
        deletado: deletado,
        updatedAt: updatedAt,
        numMatriz: numMatriz,
        nomeMatriz: nomeMatriz,
        nascimentoMatriz: nascimentoMatriz,
        numReprodutor: numReprodutor,
        nomeReprodutor: nomeReprodutor,
        nascimentoReprodutor: nascimentoReprodutor,
        statusReproducao: statusReproducao,
        dataStatus: dataStatus,
        racaMatriz: racaMatriz,
        racaReprodutor: racaReprodutor,
        chipReprodutor: chipReprodutor,
        chipMatriz: chipMatriz,
        ressinc: ressinc,
        parida: parida,
        dataParto: dataParto,
        idrebanhomatriz: idrebanhomatriz,
        idrebanhoreprodutor: idrebanhoreprodutor,
        gnrh: gnrh,
        cio: cio,
      );

  Future updateProp({
    String? idPropriedade,
    String? atividades,
  }) =>
      performUpdateProp(
        _database,
        idPropriedade: idPropriedade,
        atividades: atividades,
      );

  Future deleteAllReproducaoCopy({
    String? id,
  }) =>
      performDeleteAllReproducaoCopy(
        _database,
        id: id,
      );

  /// END UPDATE QUERY CALLS
}
