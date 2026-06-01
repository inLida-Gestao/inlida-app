import '/backend/schema/structs/index.dart';
import '/backend/sqlite/queries/read.dart';

List<LocalLotesStruct> buildRebanhoLoteOptions(List<BuscarLotesRow>? lotes) {
  final options = <LocalLotesStruct>[];

  for (final lote in lotes ?? const <BuscarLotesRow>[]) {
    final idLote = lote.idLote;
    if (idLote == null || idLote.isEmpty) {
      continue;
    }

    options.add(LocalLotesStruct(
      idLote: idLote,
      nome: lote.nome,
    ));
  }

  options.sort(
    (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
  );
  return options;
}

List<String> rebanhoLoteOptionValues(List<LocalLotesStruct> lotes) =>
    lotes.map((lote) => lote.idLote).toList();

List<String> rebanhoLoteOptionLabels(List<LocalLotesStruct> lotes) =>
    lotes.map((lote) => lote.nome).toList();

String? rebanhoLoteNomeById(
  List<LocalLotesStruct> lotes,
  String? idLote,
) {
  if (idLote == null || idLote.isEmpty) {
    return null;
  }

  for (final lote in lotes) {
    if (lote.idLote == idLote) {
      return lote.nome;
    }
  }

  return null;
}
