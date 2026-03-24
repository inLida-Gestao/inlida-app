import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';
import 'queries/update.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

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
      performListarRebanhos(
        _database,
        idPropriedade: idPropriedade,
      );

  Future<List<BuscarRebanhoRow>> buscarRebanho({
    String? idRebanho,
  }) =>
      performBuscarRebanho(
        _database,
        idRebanho: idRebanho,
      );

  Future<List<BuscarRebanhoUPDATEDRow>> buscarRebanhoUPDATED({
    String? data,
  }) =>
      performBuscarRebanhoUPDATED(
        _database,
        data: data,
      );

  Future<List<BuscarRebanhoPUTRow>> buscarRebanhoPUT({
    String? data,
  }) =>
      performBuscarRebanhoPUT(
        _database,
        data: data,
      );

  Future<List<QTDAnimaisPropriedadeRow>> qTDAnimaisPropriedade({
    String? idPropriedade,
  }) =>
      performQTDAnimaisPropriedade(
        _database,
        idPropriedade: idPropriedade,
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

  Future<List<BuscaHistPesagensPUTRow>> buscaHistPesagensPUT({
    String? data,
  }) =>
      performBuscaHistPesagensPUT(
        _database,
        data: data,
      );

  Future<List<BuscaHistPesagensUPDTRow>> buscaHistPesagensUPDT() =>
      performBuscaHistPesagensUPDT(
        _database,
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
  }) =>
      performBuscarLotePUT(
        _database,
        datePUT: datePUT,
      );

  Future<List<BuscarLoteUPDTRow>> buscarLoteUPDT({
    String? dateUPDT,
  }) =>
      performBuscarLoteUPDT(
        _database,
        dateUPDT: dateUPDT,
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
    String? statusReb,
  }) =>
      performBuscaRebanhoPaginada(
        _database,
        idPropriedade: idPropriedade,
        limitReb: limitReb,
        offsetReb: offsetReb,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        statusReb: statusReb,
      );

  Future<List<QTDAnimaisTotalPropriedadeRow>> qTDAnimaisTotalPropriedade({
    String? idPropriedade,
  }) =>
      performQTDAnimaisTotalPropriedade(
        _database,
        idPropriedade: idPropriedade,
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
  }) =>
      performBuscaRebanhoPaginadaPesquisa(
        _database,
        idPropriedade: idPropriedade,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        loteId: loteId,
        pesquisa: pesquisa,
        statusReb: statusReb,
      );

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

  Future<List<BuscarAnimaisDoLoteRow>> buscarAnimaisDoLote({
    String? loteid,
  }) =>
      performBuscarAnimaisDoLote(
        _database,
        loteid: loteid,
      );

  Future<List<RebanhoPagOrdNumCresRow>> rebanhoPagOrdNumCres({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? statusReb,
  }) =>
      performRebanhoPagOrdNumCres(
        _database,
        idPropriedade: idPropriedade,
        limitReb: limitReb,
        offsetReb: offsetReb,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        statusReb: statusReb,
      );

  Future<List<RebanhoPagOrdNumDescRow>> rebanhoPagOrdNumDesc({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? statusReb,
  }) =>
      performRebanhoPagOrdNumDesc(
        _database,
        idPropriedade: idPropriedade,
        limitReb: limitReb,
        offsetReb: offsetReb,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        statusReb: statusReb,
      );

  Future<List<RebanhoPagOrdNomCresRow>> rebanhoPagOrdNomCres({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? statusReb,
  }) =>
      performRebanhoPagOrdNomCres(
        _database,
        idPropriedade: idPropriedade,
        limitReb: limitReb,
        offsetReb: offsetReb,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        statusReb: statusReb,
      );

  Future<List<RebanhoPagOrdNomDescRow>> rebanhoPagOrdNomDesc({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? statusReb,
  }) =>
      performRebanhoPagOrdNomDesc(
        _database,
        idPropriedade: idPropriedade,
        limitReb: limitReb,
        offsetReb: offsetReb,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        statusReb: statusReb,
      );

  Future<List<RebanhoPagOrdDataCresRow>> rebanhoPagOrdDataCres({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? statusReb,
  }) =>
      performRebanhoPagOrdDataCres(
        _database,
        idPropriedade: idPropriedade,
        limitReb: limitReb,
        offsetReb: offsetReb,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        statusReb: statusReb,
      );

  Future<List<RebanhoPagOrdDataDescRow>> rebanhoPagOrdDataDesc({
    String? idPropriedade,
    int? limitReb,
    int? offsetReb,
    String? sexo,
    String? categoria,
    String? raca,
    String? origem,
    String? statusReb,
  }) =>
      performRebanhoPagOrdDataDesc(
        _database,
        idPropriedade: idPropriedade,
        limitReb: limitReb,
        offsetReb: offsetReb,
        sexo: sexo,
        categoria: categoria,
        raca: raca,
        origem: origem,
        statusReb: statusReb,
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
  }) =>
      performInsertRebanho(
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
  }) =>
      performInsertRebanhoNascimento(
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
    String? idRebanho,
    String? dataPesagem,
    String? tipo,
    double? peso,
    String? deletado,
    String? createdat,
    String? idPropriedade,
  }) async {
    await performAddPesagem(
      _database,
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

  Future<void> _syncUltimaPesagemNoRebanho(String? idRebanho) async {
    if (idRebanho == null || idRebanho.isEmpty) {
      return;
    }

    final ultimaPesagem = await _database.rawQuery('''
SELECT peso, dataPesagem
FROM local_historico_pesagens
WHERE idRebanho = '$idRebanho'
AND deletado = 'NAO'
ORDER BY date(dataPesagem) DESC, datetime(created_at, 'localtime') DESC, id DESC
LIMIT 1
''');

    if (ultimaPesagem.isEmpty) {
      await performUPDTPesoRebanho(
        _database,
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

    await performUPDTPesoRebanho(
      _database,
      peso: peso,
      data: dataPesagem,
      idRebanho: idRebanho,
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
    double? pesoAtual,
    String? statusRebanho,
    String? origem,
    String? anotacoes,
    String? dataAcao,
    double? valorCompra,
    String? dataUltimaPesagem,
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
  }) =>
      performUPDTRebanho(
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
        pesoAtual: pesoAtual,
        statusRebanho: statusRebanho,
        origem: origem,
        anotacoes: anotacoes,
        dataAcao: dataAcao,
        valorCompra: valorCompra,
        dataUltimaPesagem: dataUltimaPesagem,
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
    String? idAnimais,
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
        idAnimais: idAnimais,
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
    String? idAnimais,
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
        idAnimais: idAnimais,
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
    String? idLote,
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
      performUPDTReproducao(
        _database,
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
        updatedAt: updatedAt,
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

  Future deleteAllReproducao() => performDeleteAllReproducao(
        _database,
      );

  Future insertSanidadeAnimal({
    String? idPropriedade,
    String? idRebanho,
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
    String? protocolod0,
    String? protocoloretirada,
    String? protocoloiatf,
  }) =>
      performInsertSanidadeAnimal(
        _database,
        idPropriedade: idPropriedade,
        idRebanho: idRebanho,
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

  Future uPDTLoteRebanho({
    String? idAnimais,
    String? updatedat,
    String? idLote,
  }) =>
      performUPDTLoteRebanho(
        _database,
        idAnimais: idAnimais,
        updatedat: updatedat,
        idLote: idLote,
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
    String? idLote,
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
      performUPDTReproducaoMonta(
        _database,
        tipoReproducao: tipoReproducao,
        scoreCorporal: scoreCorporal,
        dataPartidaSemen: dataPartidaSemen,
        partidaSemen: partidaSemen,
        previsaoParto: previsaoParto,
        idLote: idLote,
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
