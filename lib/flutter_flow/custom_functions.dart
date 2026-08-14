import 'dart:convert';

double? convertIntToDouble(int? valor) {
  // crie uma function que converta um valor inteiro em double
  return valor?.toDouble();
}

String? converterListaParaJSON(List<String>? lista) {
  // gere uma funcao que converte um lista de string para um json
  if (lista == null) return null; // Retorna null se a lista for nula
  return jsonEncode(lista); // Converte a lista para JSON
}

String imgPathToString(String icone) {
  // gere uma funcao que converta um tipo string para imagePath
  return icone; // Assuming images are stored in assets/images directory
}

String stringToImgPath(String icone) {
  // gere uma funcao que converta um tipo string para imagePath
  return icone; // Assuming images are stored in assets/images and have a .png extension
}

DateTime converterTimestamp(String data) {
  // gere uma função que converte uma string do formato yyyy-MM-dd HH:mm:ss para datetime
  return DateTime.parse(data);
}

List<String> converterJSONparaLista(String json) {
  // gere uma funcao que converta string que esta no formato json para uma lista de strings
  try {
    final decoded = jsonDecode(json);
    if (decoded is List) {
      return List<String>.from(decoded.map((e) => e.toString()));
    }
    // Se decodificou mas não é lista, retorna como item único
    return [decoded.toString()];
  } catch (e) {
    // Se falhar o jsonDecode, tenta recuperar dados de formato Dart List.toString()
    // Ex: "[Antitetânica, Botulismo]" (sem aspas JSON)
    final trimmed = json.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      final inner = trimmed.substring(1, trimmed.length - 1).trim();
      if (inner.isEmpty) return [];
      return inner
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    // Último recurso: retorna o valor como item único se não estiver vazio
    if (trimmed.isNotEmpty) return [trimmed];
    return [];
  }
}

String addRegistroToJsonString(
  String registro,
  String jsonString,
) {
  // Se vazio ou [], cria novo array com o registro
  if (jsonString == '' || jsonString == '[]') {
    return '["$registro"]';
  }

  // Verifica se já existe
  if (jsonString.contains('"$registro"')) {
    return jsonString; // Retorna sem modificar
  }

  // Remove o ] do final e adiciona o novo registro
  String semFinal = jsonString.substring(0, jsonString.length - 1);

  // Se tem só [, adiciona sem vírgula
  if (semFinal == '[') {
    return '["$registro"]';
  }

  // Adiciona vírgula e o novo registro
  return '$semFinal,"$registro"]';
}

DateTime remover3hs(DateTime date) {
  // gere uma funcao  que recebe um variavel datetime e remova 3 horas desta variavel datetime
  return date.subtract(const Duration(hours: 3));
}

DateTime? converterParaData(String? data) {
  // gere uma função que recebe uma data como string que esta no formato yyyy-MM-dd e converta para data
  if (data == null || data == 'null') return null; // Verifica se a data é nula
  try {
    return DateTime.parse(data); // Converte a string para DateTime
  } catch (e) {
    return null; // Retorna nulo em caso de erro
  }
}

/// Normaliza um valor de data opcional vindo do SQLite/FlutterFlow.
///
/// Retorna `null` quando o campo não foi informado (`null`, string vazia,
/// literal `'null'`) ou quando a string não representa uma data válida.
/// Usado para evitar que campos de data vazios sejam confundidos com um
/// valor "sentinela" (ex.: data de partida do sêmen sendo preenchida
/// automaticamente com uma data default ao sincronizar).
String? normalizarDataOpcional(String? data) {
  if (data == null) return null;
  final trimmed = data.trim();
  if (trimmed.isEmpty || trimmed == 'null') return null;
  final parsed = DateTime.tryParse(trimmed);
  if (parsed == null) return null;
  return trimmed;
}

String? converterLista(List<String>? lista) {
  if (lista == null || lista.isEmpty) {
    return '';
  }
  return lista.map((item) => "'$item'").join(', ');
}

double pesoMedio(List<double> listaPesos) {
  // gere uma função que recebe uma lista de valores e calcula o valor médio destes valores
  if (listaPesos.isEmpty) return 0.0; // Retorna 0 se a lista estiver vazia
  double soma = listaPesos.reduce((a, b) => a + b); // Soma todos os pesos
  return double.parse(
      (soma / listaPesos.length).toStringAsFixed(2)); // Calcula a média
}

DateTime hojeMenos30() {
  return DateTime.now().subtract(const Duration(days: 30));
}

DateTime hojeMais30() {
  // ajuste essa função para somar 30 dias return DateTime.now().subtract(Duration(days: 30));
  return DateTime.now().add(const Duration(days: 30));
}

DateTime hojeMenos60() {
  return DateTime.now().subtract(const Duration(days: 60));
}

DateTime hojeMais60() {
  return DateTime.now().add(const Duration(days: 60));
}

DateTime hojeMenos90() {
  return DateTime.now().subtract(const Duration(days: 90));
}

DateTime hojeMais90() {
  return DateTime.now().add(const Duration(days: 90));
}

DateTime dataMais295(DateTime data) {
  // ajuste a function a seguir para que possa ser passado uma data e adicionar 295 dias  return DateTime.now().add(Duration(days: 295));
  return data.add(const Duration(days: 295));
}

bool permitePrevisaoParto(String? diagnostico) {
  final diagnosticoNormalizado = diagnostico?.trim();
  return diagnosticoNormalizado == null ||
      diagnosticoNormalizado.isEmpty ||
      diagnosticoNormalizado == 'Não diagnosticado' ||
      diagnosticoNormalizado == 'Prenhez';
}

bool partoConfirmado(String? parida) {
  return parida?.trim().toLowerCase() == 'sim';
}

String normalizarParida(bool confirmado) {
  return confirmado ? 'SIM' : 'NAO';
}

bool temDataParto(String? dataParto) {
  final valor = dataParto?.trim().toLowerCase();
  if (valor == null || valor.isEmpty || valor == '-' || valor == 'null') {
    return false;
  }

  final data = converterParaData(dataParto);
  if (data == null) return false;

  final partes = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(valor);
  if (partes == null) return true;

  return data.year == int.parse(partes.group(1)!) &&
      data.month == int.parse(partes.group(2)!) &&
      data.day == int.parse(partes.group(3)!);
}

bool exibirPartoConfirmado(String? parida, String? dataParto) {
  return partoConfirmado(parida) || temDataParto(dataParto);
}

bool temReprodutorSelecionado(String? idRebanho) {
  final id = idRebanho?.trim().toLowerCase();
  return id != null && id.isNotEmpty && id != 'null' && id != '-';
}

bool temMatrizSelecionada(String? idRebanho) {
  final id = idRebanho?.trim().toLowerCase();
  return id != null && id.isNotEmpty && id != 'null' && id != '-';
}

bool? ultimos30Dias(DateTime? data) {
  // crie uma funcão que recebe uma data e verifica se esta data esta contida dentro dos ultimos 30 dias até o dia atual e retorna verdadeiro ou falso
  if (data == null) return null;
  DateTime now = DateTime.now();
  DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));
  return data.isAfter(thirtyDaysAgo) && data.isBefore(now);
}

int calcDeslocamento(
  int pageNum,
  int limit,
) {
  return (pageNum - 1) * limit;
}

double soma(List<double> valores) {
  // gere uma funcao para realizar a soma de uma lista de valores e retornar o resultado caso a lista esteja vazia retornar 0
  if (valores.isEmpty) {
    return 0.0; // Retorna 0 se a lista estiver vazia
  }
  return valores.reduce((a, b) => a + b); // Soma os valores da lista
}

int diasEntreDatas(
  DateTime data1,
  DateTime data2,
) {
  // gere uma custom fuction que calcule a quantidade de dias entre uma data e outra
  return data2.difference(data1).inDays;
}
