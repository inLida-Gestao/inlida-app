// Regras e orquestração para auto-confirmar o parto de uma reprodução ao
// cadastrar um animal do tipo Nascimento vinculado à matriz.
//
// Fluxo: ao selecionar a matriz (e já com a data de nascimento do bezerro
// informada), localizamos a reprodução (somente Inseminação) dessa matriz
// cuja concepção caiu na janela de gestação (275 a 305 dias antes do
// nascimento). Se encontrada e ainda não parida, usamos o reprodutor
// vinculado a ela para pré-preencher o reprodutor do bezerro. No Salvar,
// confirmamos o parto (parida/data_parto/status_reproducao) dessa mesma
// reprodução.
//
// Quando nenhuma inseminação é encontrada na janela padrão, mas existe
// alguma reprodução (Inseminação ou Monta Natural) na janela estendida (306
// a 350 dias antes do nascimento), a escolha deixa de ser automática: a tela
// deve exibir um popup para o usuário selecionar manualmente qual reprodução
// originou o nascimento.
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_util.dart';

/// Menor quantidade de dias de gestação considerada para localizar
/// automaticamente a reprodução que originou o nascimento.
const int kDiasGestacaoMin = 275;

/// Maior quantidade de dias de gestação considerada para localizar
/// automaticamente a reprodução que originou o nascimento.
const int kDiasGestacaoMax = 305;

/// Maior quantidade de dias de gestação considerada na janela estendida
/// (escolha manual do usuário via popup), quando nada é encontrado na janela
/// automática.
const int kDiasGestacaoEstendidoMax = 350;

/// Janela de datas (concepção) em que a reprodução deve ter ocorrido para
/// ser considerada automaticamente a origem de um nascimento em
/// [dataNascimento] (275 a 305 dias antes).
({DateTime inicio, DateTime fim}) janelaConcepcao(DateTime dataNascimento) {
  return (
    inicio: dataNascimento.subtract(const Duration(days: kDiasGestacaoMax)),
    fim: dataNascimento.subtract(const Duration(days: kDiasGestacaoMin)),
  );
}

/// Janela estendida de datas (concepção), usada apenas para oferecer opções
/// de escolha manual ao usuário quando nada é encontrado na janela
/// automática (306 a 350 dias antes de [dataNascimento]).
({DateTime inicio, DateTime fim}) janelaConcepcaoEstendida(
  DateTime dataNascimento,
) {
  return (
    inicio: dataNascimento
        .subtract(const Duration(days: kDiasGestacaoEstendidoMax)),
    fim: dataNascimento.subtract(const Duration(days: kDiasGestacaoMax + 1)),
  );
}

/// Dados mínimos de uma reprodução candidata a ser confirmada como a
/// origem do nascimento.
class CandidatoReproducao {
  const CandidatoReproducao({
    required this.idReproducao,
    required this.dataReferencia,
    required this.tipoReproducao,
    required this.parida,
    required this.dataParto,
    required this.statusReproducao,
    required this.idRebanhoReprodutor,
    required this.numReprodutor,
    required this.nomeReprodutor,
    required this.nascimentoReprodutor,
    required this.racaReprodutor,
    required this.chipReprodutor,
  });

  final String idReproducao;
  final DateTime dataReferencia;
  final String? tipoReproducao;
  final String? parida;
  final String? dataParto;
  final String? statusReproducao;
  final String? idRebanhoReprodutor;
  final String? numReprodutor;
  final String? nomeReprodutor;
  final String? nascimentoReprodutor;
  final String? racaReprodutor;
  final String? chipReprodutor;
}

/// Resultado da busca por reproduções candidatas a um nascimento: no máximo
/// uma automática (janela 275-305 dias, só Inseminação) ou, na ausência
/// dela, a lista de candidatas da janela estendida (306-350 dias,
/// Inseminação e Monta Natural) para escolha manual do usuário.
class ResultadoBuscaReproducao {
  const ResultadoBuscaReproducao({
    this.automatica,
    this.candidatosManuais = const [],
  });

  final CandidatoReproducao? automatica;
  final List<CandidatoReproducao> candidatosManuais;
}

/// Data de referência (concepção) de uma reprodução, de acordo com o tipo:
/// Inseminação usa `data_inseminacao`; Monta Natural usa `data_inicial` (o
/// início da cobertura, mais próximo da concepção), caindo para `data_final`
/// apenas se a data de início não estiver disponível.
DateTime? dataReferenciaReproducao(
  String? tipoReproducao,
  String? dataInseminacao,
  String? dataInicial,
  String? dataFinal,
) {
  final tipo = tipoReproducao?.trim().toLowerCase();
  if (tipo == 'inseminação' || tipo == 'inseminacao') {
    return functions.converterParaData(dataInseminacao);
  }
  if (tipo == 'monta natural') {
    return functions.converterParaData(dataInicial) ??
        functions.converterParaData(dataFinal);
  }
  return null;
}

/// Uma reprodução só é candidata a auto-confirmação se ainda não tiver o
/// parto confirmado manualmente (nunca sobrescrevemos um parto já dado).
bool reproducaoDisponivelParaParto(String? parida, String? dataParto) {
  return !functions.exibirPartoConfirmado(parida, dataParto);
}

/// Entre os candidatos disponíveis (não paridos), retorna o de data de
/// referência mais recente. `null` se nenhum candidato estiver disponível.
CandidatoReproducao? selecionarReproducaoParaParto(
  List<CandidatoReproducao> candidatos,
) {
  final disponiveis = candidatos
      .where((c) => reproducaoDisponivelParaParto(c.parida, c.dataParto))
      .toList();
  if (disponiveis.isEmpty) return null;

  disponiveis.sort((a, b) => b.dataReferencia.compareTo(a.dataReferencia));
  return disponiveis.first;
}

/// Converte as linhas retornadas pela query em [CandidatoReproducao],
/// descartando registros sem `id_reproducao` ou sem data de referência
/// reconhecível.
List<CandidatoReproducao> mapearCandidatos(
  List<BuscarReproducaoParaPartoRow> rows,
) {
  final candidatos = <CandidatoReproducao>[];
  for (final row in rows) {
    final idReproducao = row.idReproducao;
    if (idReproducao == null || idReproducao.isEmpty) continue;

    final dataReferencia = dataReferenciaReproducao(
      row.tipoReproducao,
      row.dataInseminacao,
      row.dataInicial,
      row.dataFinal,
    );
    if (dataReferencia == null) continue;

    candidatos.add(CandidatoReproducao(
      idReproducao: idReproducao,
      dataReferencia: dataReferencia,
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
    ));
  }
  return candidatos;
}

/// Busca no SQLite as reproduções da matriz que podem ter originado o
/// nascimento em [dataNascimento].
///
/// Primeiro tenta a janela automática (275-305 dias, somente Inseminação):
/// se houver candidata não parida, retorna-a em [ResultadoBuscaReproducao.
/// automatica] (a mais recente, em caso de empate) e não busca mais nada.
/// Caso contrário, busca a janela estendida (306-350 dias, Inseminação e
/// Monta Natural) e devolve todas as candidatas não paridas em
/// [ResultadoBuscaReproducao.candidatosManuais], para que o usuário escolha
/// manualmente (via popup) qual reprodução vincular ao nascimento.
Future<ResultadoBuscaReproducao> localizarReproducaoDaMatriz({
  required String? idPropriedade,
  required String? idRebanhoMatriz,
  required DateTime? dataNascimento,
}) async {
  if (idPropriedade == null ||
      idPropriedade.isEmpty ||
      !functions.temMatrizSelecionada(idRebanhoMatriz) ||
      dataNascimento == null) {
    return const ResultadoBuscaReproducao();
  }

  final janela = janelaConcepcao(dataNascimento);
  final rowsAutomatica = await SQLiteManager.instance.buscarReproducaoParaParto(
    idPropriedade: idPropriedade,
    idRebanhoMatriz: idRebanhoMatriz,
    dataInicio: dateTimeFormat('yyyy-MM-dd', janela.inicio),
    dataFim: dateTimeFormat('yyyy-MM-dd', janela.fim),
    incluirMontaNatural: false,
  );

  final candidatoAutomatico = selecionarReproducaoParaParto(
    mapearCandidatos(rowsAutomatica),
  );
  if (candidatoAutomatico != null) {
    return ResultadoBuscaReproducao(automatica: candidatoAutomatico);
  }

  final janelaEstendida = janelaConcepcaoEstendida(dataNascimento);
  final rowsEstendida = await SQLiteManager.instance.buscarReproducaoParaParto(
    idPropriedade: idPropriedade,
    idRebanhoMatriz: idRebanhoMatriz,
    dataInicio: dateTimeFormat('yyyy-MM-dd', janelaEstendida.inicio),
    dataFim: dateTimeFormat('yyyy-MM-dd', janelaEstendida.fim),
    incluirMontaNatural: true,
  );

  final candidatosManuais = mapearCandidatos(rowsEstendida)
      .where((c) => reproducaoDisponivelParaParto(c.parida, c.dataParto))
      .toList()
    ..sort((a, b) => b.dataReferencia.compareTo(a.dataReferencia));

  return ResultadoBuscaReproducao(candidatosManuais: candidatosManuais);
}

/// Confirma o parto da reprodução [idReproducao]: marca `parida = 'SIM'`,
/// grava `data_parto` (derivada de [dataNascimento]) e força
/// `status_reproducao = 'Prenhez'`. Também garante que exista um marcador de
/// pendência de sync para reprodução, pois o UPDATE precisa ser detectado
/// pelo próximo `putUpdtReproducao`.
Future<bool> confirmarPartoAutomatico({
  required String idReproducao,
  required DateTime dataNascimento,
  DateTime? dataDadosNaoSyncReproAtual,
  required void Function(DateTime) marcarPendenciaSyncRepro,
}) async {
  if (dataDadosNaoSyncReproAtual == null) {
    marcarPendenciaSyncRepro(getCurrentTimestamp);
  }

  await SQLiteManager.instance.confirmarPartoReproducao(
    idReproducao: idReproducao,
    dataParto: dateTimeFormat('yyyy-MM-dd', dataNascimento),
    statusReproducao: 'Prenhez',
    updatedAt: dateTimeFormat('yyyy-MM-dd HH:mm:ss', getCurrentTimestamp),
  );
  return true;
}
