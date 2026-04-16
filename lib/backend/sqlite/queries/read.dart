import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

String _escapeSqlValue(String value) => value.replaceAll("'", "''");

String _buildSqlMultiValueCondition(String column, String? rawValue) {
  final values = (rawValue ?? '')
      .split('|')
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList();

  if (values.isEmpty) {
    return '1=1';
  }

  if (values.length == 1) {
    return "$column = '${_escapeSqlValue(values.first)}'";
  }

  final serializedValues =
      values.map((value) => "'${_escapeSqlValue(value)}'").join(', ');
  return '$column IN ($serializedValues)';
}

/// BEGIN LOCALCIDADES
Future<List<LocalCidadesRow>> performLocalCidades(
  Database database, {
  String? uf,
}) {
  final query = '''
select id,cidade from local_cidades
where uf =  '$uf'
order by cidade ASC;
''';
  return _readQuery(database, query, (d) => LocalCidadesRow(d));
}

class LocalCidadesRow extends SqliteRow {
  LocalCidadesRow(super.data);

  String get cidade => data['cidade'] as String;
  int? get id => data['id'] as int?;
}

/// END LOCALCIDADES

/// BEGIN LISTARPROPRIEDADES
Future<List<ListarPropriedadesRow>> performListarPropriedades(
  Database database, {
  String? userID,
}) {
  final query = '''
SELECT * FROM local_propriedades 
WHERE 1=1
AND (userID = '$userID' OR usersID LIKE '%$userID%') 
AND deletado = 'NAO'
ORDER BY created_at DESC
''';
  return _readQuery(database, query, (d) => ListarPropriedadesRow(d));
}

class ListarPropriedadesRow extends SqliteRow {
  ListarPropriedadesRow(super.data);

  int? get id => data['id'] as int?;
  String? get userID => data['userID'] as String?;
  String? get usersID => data['usersID'] as String?;
  String? get rebanhosID => data['rebanhosID'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  int? get areaAgricultura => data['areaAgricultura'] as int?;
  int? get areaBenfeitoria => data['areaBenfeitoria'] as int?;
  int? get areaPastagem => data['areaPastagem'] as int?;
  int? get areaReserva => data['areaReserva'] as int?;
  int? get areaTotal => data['areaTotal'] as int?;
  String? get cidade => data['cidade'] as String?;
  String? get estado => data['estado'] as String?;
  String? get icone => data['icone'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get atividades => data['atividades'] as String?;
  String? get nome => data['nome'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get deletado => data['deletado'] as String?;
}

/// END LISTARPROPRIEDADES

/// BEGIN BUSCA PROPRIEDADES PUT
Future<List<BuscaPropriedadesPUTRow>> performBuscaPropriedadesPUT(
  Database database, {
  String? datePUT,
}) {
  final query = '''
SELECT * FROM local_propriedades
WHERE datetime(created_at, 'localtime') >= datetime('$datePUT', 'localtime')
''';
  return _readQuery(database, query, (d) => BuscaPropriedadesPUTRow(d));
}

class BuscaPropriedadesPUTRow extends SqliteRow {
  BuscaPropriedadesPUTRow(super.data);

  String? get userID => data['userID'] as String?;
  String? get usersID => data['usersID'] as String?;
  String? get rebanhosID => data['rebanhosID'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  int? get areaAgricultura => data['areaAgricultura'] as int?;
  int? get areaBenfeitoria => data['areaBenfeitoria'] as int?;
  int? get areaPastagem => data['areaPastagem'] as int?;
  int? get areaReserva => data['areaReserva'] as int?;
  int? get areaTotal => data['areaTotal'] as int?;
  String? get cidade => data['cidade'] as String?;
  String? get estado => data['estado'] as String?;
  String? get icone => data['icone'] as String?;
  String get idPropriedade => data['idPropriedade'] as String;
  String? get atividades => data['atividades'] as String?;
  String? get nome => data['nome'] as String?;
}

/// END BUSCA PROPRIEDADES PUT

/// BEGIN BUSCA PROPRIEDADE
Future<List<BuscaPropriedadeRow>> performBuscaPropriedade(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_propriedades
WHERE idPropriedade = '$idPropriedade'
''';
  return _readQuery(database, query, (d) => BuscaPropriedadeRow(d));
}

class BuscaPropriedadeRow extends SqliteRow {
  BuscaPropriedadeRow(super.data);

  String? get userID => data['userID'] as String?;
  String? get usersID => data['usersID'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  int? get areaAgricultura => data['areaAgricultura'] as int?;
  int? get areaBenfeitoria => data['areaBenfeitoria'] as int?;
  int? get areaPastagem => data['areaPastagem'] as int?;
  int? get areaReserva => data['areaReserva'] as int?;
  int? get areaTotal => data['areaTotal'] as int?;
  String? get cidade => data['cidade'] as String?;
  String? get estado => data['estado'] as String?;
  String? get icone => data['icone'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get atividades => data['atividades'] as String?;
  String? get nome => data['nome'] as String?;
}

/// END BUSCA PROPRIEDADE

/// BEGIN BUSCA USERS PELO ID
Future<List<BuscaUsersPeloIDRow>> performBuscaUsersPeloID(
  Database database, {
  String? userID,
}) {
  final query = '''
SELECT * FROM local_users
WHERE userID = '$userID'
''';
  return _readQuery(database, query, (d) => BuscaUsersPeloIDRow(d));
}

class BuscaUsersPeloIDRow extends SqliteRow {
  BuscaUsersPeloIDRow(super.data);

  String? get userID => data['userID'] as String?;
  String? get nome => data['nome'] as String?;
  String? get email => data['email'] as String?;
  String? get foto => data['foto'] as String?;
  String? get telefone => data['telefone'] as String?;
  String? get permissao => data['permissao'] as String?;
}

/// END BUSCA USERS PELO ID

/// BEGIN BUSCA USUARIO POR EMAIL
Future<List<BuscaUsuarioPorEmailRow>> performBuscaUsuarioPorEmail(
  Database database, {
  String? email,
}) {
  final query = '''
SELECT * FROM local_users
WHERE excluido = 0
AND email = '$email'
''';
  return _readQuery(database, query, (d) => BuscaUsuarioPorEmailRow(d));
}

class BuscaUsuarioPorEmailRow extends SqliteRow {
  BuscaUsuarioPorEmailRow(super.data);

  String? get userID => data['userID'] as String?;
  String? get nome => data['nome'] as String?;
  String? get email => data['email'] as String?;
  String? get foto => data['foto'] as String?;
  String? get telefone => data['telefone'] as String?;
  String? get permissao => data['permissao'] as String?;
}

/// END BUSCA USUARIO POR EMAIL

/// BEGIN BUSCA PROPRIEDADES UPDATED
Future<List<BuscaPropriedadesUPDATEDRow>> performBuscaPropriedadesUPDATED(
  Database database, {
  String? dateUPT,
}) {
  final query = '''
SELECT * FROM local_propriedades
WHERE datetime(updated_at, 'localtime') >= datetime('$dateUPT', 'localtime')
''';
  return _readQuery(database, query, (d) => BuscaPropriedadesUPDATEDRow(d));
}

class BuscaPropriedadesUPDATEDRow extends SqliteRow {
  BuscaPropriedadesUPDATEDRow(super.data);

  String? get userID => data['userID'] as String?;
  String? get usersID => data['usersID'] as String?;
  String? get rebanhosID => data['rebanhosID'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  int? get areaAgricultura => data['areaAgricultura'] as int?;
  int? get areaBenfeitoria => data['areaBenfeitoria'] as int?;
  int? get areaPastagem => data['areaPastagem'] as int?;
  int? get areaReserva => data['areaReserva'] as int?;
  int? get areaTotal => data['areaTotal'] as int?;
  String? get cidade => data['cidade'] as String?;
  String? get estado => data['estado'] as String?;
  String? get icone => data['icone'] as String?;
  String get idPropriedade => data['idPropriedade'] as String;
  String? get atividades => data['atividades'] as String?;
  String? get nome => data['nome'] as String?;
  String? get updatedat => data['updatedat'] as String?;
}

/// END BUSCA PROPRIEDADES UPDATED

/// BEGIN BUSCA USERS PROPRIEDADES
Future<List<BuscaUsersPropriedadesRow>> performBuscaUsersPropriedades(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_usuarios_propriedade
where idPropriedade = '$idPropriedade'
''';
  return _readQuery(database, query, (d) => BuscaUsersPropriedadesRow(d));
}

class BuscaUsersPropriedadesRow extends SqliteRow {
  BuscaUsersPropriedadesRow(super.data);

  String? get nome => data['nome'] as String?;
  String? get email => data['email'] as String?;
  String? get userId => data['user_id'] as String?;
  String? get foto => data['foto'] as String?;
  String? get permissao => data['permissao'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
}

/// END BUSCA USERS PROPRIEDADES

/// BEGIN LISTARREBANHOS
Future<List<ListarRebanhosRow>> performListarRebanhos(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
''';
  return _readQuery(database, query, (d) => ListarRebanhosRow(d));
}

class ListarRebanhosRow extends SqliteRow {
  ListarRebanhosRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get dataVenda => data['dataVenda'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
  String? get movimentacaoEntrada => data['movimentacao_entrada'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get movimentacaoSaida => data['movimentacao_saida'] as String?;
  String? get dataMorte => data['data_morte'] as String?;
}

/// END LISTARREBANHOS

/// BEGIN BUSCAR REBANHO
Future<List<BuscarRebanhoRow>> performBuscarRebanho(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE idRebanho = '$idRebanho'

''';
  return _readQuery(database, query, (d) => BuscarRebanhoRow(d));
}

class BuscarRebanhoRow extends SqliteRow {
  BuscarRebanhoRow(super.data);

  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get dataVenda => data['dataVenda'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get movimentacaoEntrada => data['movimentacao_entrada'] as String?;
  String? get movimentacaoSaida => data['movimentacao_saida'] as String?;
  String? get dataMorte => data['data_morte'] as String?;
  String? get motivoMorte => data['motivo_morte'] as String?;
  String? get categoriaMatriz => data['categoria_matriz'] as String?;
}

/// END BUSCAR REBANHO

/// BEGIN BUSCAR REBANHO UPDATED
Future<List<BuscarRebanhoUPDATEDRow>> performBuscarRebanhoUPDATED(
  Database database, {
  String? data,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE datetime(updated_at, 'localtime') >= datetime('$data', 'localtime')

''';
  return _readQuery(database, query, (d) => BuscarRebanhoUPDATEDRow(d));
}

class BuscarRebanhoUPDATEDRow extends SqliteRow {
  BuscarRebanhoUPDATEDRow(super.data);

  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get dataVenda => data['dataVenda'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get movimentacaoEntrada => data['movimentacao_entrada'] as String?;
  String? get movimentacaoSaida => data['movimentacao_saida'] as String?;
  String? get dataMorte => data['data_morte'] as String?;
}

/// END BUSCAR REBANHO UPDATED

/// BEGIN BUSCAR REBANHO PUT
Future<List<BuscarRebanhoPUTRow>> performBuscarRebanhoPUT(
  Database database, {
  String? data,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE datetime(created_at, 'localtime') >= datetime('$data', 'localtime')

''';
  return _readQuery(database, query, (d) => BuscarRebanhoPUTRow(d));
}

class BuscarRebanhoPUTRow extends SqliteRow {
  BuscarRebanhoPUTRow(super.data);

  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get dataVenda => data['dataVenda'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get movimentacaoEntrada => data['movimentacao_entrada'] as String?;
  String? get movimentacaoSaida => data['movimentacao_saida'] as String?;
  String? get dataMorte => data['data_morte'] as String?;
  String? get motivoMorte => data['motivo_morte'] as String?;
  String? get categoriaMatriz => data['categoria_matriz'] as String?;
}

/// END BUSCAR REBANHO PUT

/// BEGIN QTD ANIMAIS PROPRIEDADE
Future<List<QTDAnimaisPropriedadeRow>> performQTDAnimaisPropriedade(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND statusRebanho = 'Na propriedade'
''';
  return _readQuery(database, query, (d) => QTDAnimaisPropriedadeRow(d));
}

class QTDAnimaisPropriedadeRow extends SqliteRow {
  QTDAnimaisPropriedadeRow(super.data);

  int? get id => data['id'] as int?;
}

/// END QTD ANIMAIS PROPRIEDADE

/// BEGIN QTD DE ANIMAIS GERAL
Future<List<QTDDeAnimaisGeralRow>> performQTDDeAnimaisGeral(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade in ($idPropriedade)
''';
  return _readQuery(database, query, (d) => QTDDeAnimaisGeralRow(d));
}

class QTDDeAnimaisGeralRow extends SqliteRow {
  QTDDeAnimaisGeralRow(super.data);

  String? get id => data['id'] as String?;
}

/// END QTD DE ANIMAIS GERAL

/// BEGIN BUSCAR CRIAS REBANHO MATRIZ
Future<List<BuscarCriasRebanhoMatrizRow>> performBuscarCriasRebanhoMatriz(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE rebanhoIdMatriz = '$idRebanho' 
AND deletado = 'NAO'

''';
  return _readQuery(database, query, (d) => BuscarCriasRebanhoMatrizRow(d));
}

class BuscarCriasRebanhoMatrizRow extends SqliteRow {
  BuscarCriasRebanhoMatrizRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  String? get raca => data['raca'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END BUSCAR CRIAS REBANHO MATRIZ

/// BEGIN BUSCA HIST PESAGENS
Future<List<BuscaHistPesagensRow>> performBuscaHistPesagens(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
SELECT * FROM local_historico_pesagens
WHERE idRebanho = '$idRebanho'
AND (deletado = 'NAO' OR deletado IS NULL OR deletado = '')
''';
  return _readQuery(database, query, (d) => BuscaHistPesagensRow(d));
}

class BuscaHistPesagensRow extends SqliteRow {
  BuscaHistPesagensRow(super.data);

  String? get idRebanho => data['idRebanho'] as String?;
  String? get dataPesagem => data['dataPesagem'] as String?;
  String? get tipo => data['tipo'] as String?;
  double? get peso {
    final v = data['peso'];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  int? get id => data['id'] as int?;
  String? get idPropriedade => data['id_propriedade'] as String?;
}

/// END BUSCA HIST PESAGENS

/// BEGIN BUSCA HIST PESAGENS PUT
Future<List<BuscaHistPesagensPUTRow>> performBuscaHistPesagensPUT(
  Database database, {
  String? data,
}) {
  final query = '''
SELECT * FROM local_historico_pesagens
WHERE datetime(created_at, 'localtime') >= datetime('$data', 'localtime')
''';
  return _readQuery(database, query, (d) => BuscaHistPesagensPUTRow(d));
}

class BuscaHistPesagensPUTRow extends SqliteRow {
  BuscaHistPesagensPUTRow(super.data);

  String? get idRebanho => data['idRebanho'] as String?;
  String? get dataPesagem => data['dataPesagem'] as String?;
  String? get tipo => data['tipo'] as String?;
  double? get peso {
    final v = data['peso'];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  int? get id => data['id'] as int?;
  String? get idPropriedade => data['id_propriedade'] as String?;
}

/// END BUSCA HIST PESAGENS PUT

/// BEGIN BUSCA HIST PESAGENS UPDT
Future<List<BuscaHistPesagensUPDTRow>> performBuscaHistPesagensUPDT(
  Database database,
) {
  const query = '''
SELECT * FROM local_historico_pesagens
WHERE deletado = 'SIM'
''';
  return _readQuery(database, query, (d) => BuscaHistPesagensUPDTRow(d));
}

class BuscaHistPesagensUPDTRow extends SqliteRow {
  BuscaHistPesagensUPDTRow(super.data);

  String? get idRebanho => data['idRebanho'] as String?;
  String? get dataPesagem => data['dataPesagem'] as String?;
  String? get tipo => data['tipo'] as String?;
  double? get peso {
    final v = data['peso'];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  int? get id => data['id'] as int?;
  String? get idPropriedade => data['id_propriedade'] as String?;
}

/// END BUSCA HIST PESAGENS UPDT

/// BEGIN LISTARREBANHOS PROGENERE
Future<List<ListarRebanhosProgenereRow>> performListarRebanhosProgenere(
  Database database, {
  String? idPropriedade,
  String? idRebanho,
  int? limitReb,
  int? offsetReb,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND idRebanho <> '$idRebanho'
LIMIT $limitReb OFFSET $offsetReb
''';
  return _readQuery(database, query, (d) => ListarRebanhosProgenereRow(d));
}

class ListarRebanhosProgenereRow extends SqliteRow {
  ListarRebanhosProgenereRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
}

/// END LISTARREBANHOS PROGENERE

/// BEGIN LISTARLOTES
Future<List<ListarLotesRow>> performListarLotes(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_lotes
WHERE id_propriedade = '$idPropriedade'
AND deletado = 'NAO'
ORDER BY created_at DESC
''';
  return _readQuery(database, query, (d) => ListarLotesRow(d));
}

class ListarLotesRow extends SqliteRow {
  ListarLotesRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idAnimais => data['id_animais'] as String?;
  String? get nome => data['nome'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get ativo => data['ativo'] as String?;
  String? get dataEntradaPiquete => data['data_entrada_piquete'] as String?;
  String? get dataSaidaPiquete => data['data_saida_piquete'] as String?;
  String? get motivo => data['motivo'] as String?;
  String? get dataMotivo => data['data_motivo'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
}

/// END LISTARLOTES

/// BEGIN LOTES ATIVO
Future<List<LotesAtivoRow>> performLotesAtivo(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_lotes
WHERE ativo = 'Ativo'
AND id_propriedade = '$idPropriedade'
''';
  return _readQuery(database, query, (d) => LotesAtivoRow(d));
}

class LotesAtivoRow extends SqliteRow {
  LotesAtivoRow(super.data);

  int? get id => data['id'] as int?;
}

/// END LOTES ATIVO

/// BEGIN LOTES INATIVOS
Future<List<LotesInativosRow>> performLotesInativos(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_lotes
WHERE ativo = 'Inativo'
AND id_propriedade = '$idPropriedade'
''';
  return _readQuery(database, query, (d) => LotesInativosRow(d));
}

class LotesInativosRow extends SqliteRow {
  LotesInativosRow(super.data);

  int? get id => data['id'] as int?;
}

/// END LOTES INATIVOS

/// BEGIN ANIMAIS NO LOTE
Future<List<AnimaisNoLoteRow>> performAnimaisNoLote(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE loteNome <> 'null'
AND idPropriedade = '$idPropriedade'
''';
  return _readQuery(database, query, (d) => AnimaisNoLoteRow(d));
}

class AnimaisNoLoteRow extends SqliteRow {
  AnimaisNoLoteRow(super.data);

  String? get id => data['id'] as String?;
}

/// END ANIMAIS NO LOTE

/// BEGIN BUSCAR LOTE
Future<List<BuscarLoteRow>> performBuscarLote(
  Database database, {
  String? idLote,
}) {
  final query = '''
SELECT * FROM local_lotes
WHERE id_lote = '$idLote'
''';
  return _readQuery(database, query, (d) => BuscarLoteRow(d));
}

class BuscarLoteRow extends SqliteRow {
  BuscarLoteRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idAnimais => data['id_animais'] as String?;
  String? get nome => data['nome'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get ativo => data['ativo'] as String?;
  String? get dataEntradaPiquete => data['data_entrada_piquete'] as String?;
  String? get dataSaidaPiquete => data['data_saida_piquete'] as String?;
  String? get motivo => data['motivo'] as String?;
  String? get dataMotivo => data['data_motivo'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
}

/// END BUSCAR LOTE

/// BEGIN BUSCAR REBANHO LOTE
Future<List<BuscarRebanhoLoteRow>> performBuscarRebanhoLote(
  Database database, {
  String? idLote,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE loteID = '$idLote'
AND deletado = 'NAO'

''';
  return _readQuery(database, query, (d) => BuscarRebanhoLoteRow(d));
}

class BuscarRebanhoLoteRow extends SqliteRow {
  BuscarRebanhoLoteRow(super.data);

  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
}

/// END BUSCAR REBANHO LOTE

/// BEGIN BUSCAR LOTE PUT
Future<List<BuscarLotePUTRow>> performBuscarLotePUT(
  Database database, {
  String? datePUT,
}) {
  final query = '''
SELECT * FROM local_lotes
WHERE datetime(created_at, 'localtime') >= datetime('$datePUT', 'localtime')

''';
  return _readQuery(database, query, (d) => BuscarLotePUTRow(d));
}

class BuscarLotePUTRow extends SqliteRow {
  BuscarLotePUTRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idAnimais => data['id_animais'] as String?;
  String? get nome => data['nome'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get ativo => data['ativo'] as String?;
  String? get dataEntradaPiquete => data['data_entrada_piquete'] as String?;
  String? get dataSaidaPiquete => data['data_saida_piquete'] as String?;
  String? get motivo => data['motivo'] as String?;
  String? get dataMotivo => data['data_motivo'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
}

/// END BUSCAR LOTE PUT

/// BEGIN BUSCAR LOTE UPDT
Future<List<BuscarLoteUPDTRow>> performBuscarLoteUPDT(
  Database database, {
  String? dateUPDT,
}) {
  final query = '''
SELECT * FROM local_lotes
WHERE datetime(updated_at, 'localtime') >= datetime('$dateUPDT', 'localtime')

''';
  return _readQuery(database, query, (d) => BuscarLoteUPDTRow(d));
}

class BuscarLoteUPDTRow extends SqliteRow {
  BuscarLoteUPDTRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idAnimais => data['id_animais'] as String?;
  String? get nome => data['nome'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get ativo => data['ativo'] as String?;
  String? get dataEntradaPiquete => data['data_entrada_piquete'] as String?;
  String? get dataSaidaPiquete => data['data_saida_piquete'] as String?;
  String? get motivo => data['motivo'] as String?;
  String? get dataMotivo => data['data_motivo'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
}

/// END BUSCAR LOTE UPDT

/// BEGIN COUNT LOTES CADASTRADOS
Future<List<CountLotesCadastradosRow>> performCountLotesCadastrados(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_lotes
WHERE id_propriedade = '$idPropriedade'
''';
  return _readQuery(database, query, (d) => CountLotesCadastradosRow(d));
}

class CountLotesCadastradosRow extends SqliteRow {
  CountLotesCadastradosRow(super.data);

  int? get id => data['id'] as int?;
}

/// END COUNT LOTES CADASTRADOS

/// BEGIN LISTARREPRODUCOES
Future<List<ListarReproducoesRow>> performListarReproducoes(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_reproducao
WHERE id_propriedade = '$idPropriedade'
''';
  return _readQuery(database, query, (d) => ListarReproducoesRow(d));
}

class ListarReproducoesRow extends SqliteRow {
  ListarReproducoesRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get tipoReproducao => data['tipo_reproducao'] as String?;
  String? get idRebanhoMatriz => data['id_rebanho_matriz'] as String?;
  int? get scoreCorporal => data['score_corporal'] as int?;
  String? get idRebanhoReprodutor => data['id_rebanho_reprodutor'] as String?;
  String? get dataInseminacao => data['data_inseminacao'] as String?;
  String? get dataPartidaSemen => data['data_partida_semen'] as String?;
  int? get partidaSemen => data['partida_semen'] as int?;
  String? get previsaoParto => data['previsao_parto'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get dataInicial => data['data_inicial'] as String?;
  String? get dataFinal => data['data_final'] as String?;
  String? get statusReproducao => data['status_reproducao'] as String?;
  String? get inseminador => data['inseminador'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idReproducao => data['id_reproducao'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get numMatriz => data['numMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get nascimentoMatriz => data['nascimentoMatriz'] as String?;
  String? get numReprodutor => data['numReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get nascimentoReprodutor => data['nascimentoReprodutor'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataStatus => data['data_status'] as String?;
  String? get ressinc => data['ressinc'] as String?;
  String? get gnrh => data['gnrh'] as String?;
  String? get cio => data['cio'] as String?;
}

/// END LISTARREPRODUCOES

/// BEGIN BUSCAR LOTES
Future<List<BuscarLotesRow>> performBuscarLotes(
  Database database, {
  String? idPropriedade,
}) {
  // Support both single ID and comma-separated list from converterLista
  final safeId =
      idPropriedade?.contains(',') == true ? idPropriedade : "'$idPropriedade'";
  final query = '''
SELECT * FROM local_lotes
WHERE ativo = 'Ativo'
AND id_propriedade IN ($safeId)
''';
  return _readQuery(database, query, (d) => BuscarLotesRow(d));
}

class BuscarLotesRow extends SqliteRow {
  BuscarLotesRow(super.data);

  String? get idLote => data['id_lote'] as String?;
  String? get nome => data['nome'] as String?;
  String? get idAnimais => data['id_animais'] as String?;
}

/// END BUSCAR LOTES

/// BEGIN QTD REPRODUCOES
Future<List<QTDReproducoesRow>> performQTDReproducoes(
  Database database, {
  String? idPropriedade,
  String? tipoRepro,
  String? inseminador,
  String? loteNome,
  String? dataRepro,
  String? dataReproFim,
  String? dataPrev,
  String? dataPrevFim,
  String? categoriaFiltro,
}) {
  final tipoRepro0 = tipoRepro ?? '';
  final inseminador0 = inseminador ?? '';
  final loteNome0 = loteNome ?? '';
  final dataRepro0 = dataRepro ?? '';
  final dataReproFim0 = dataReproFim ?? '';
  final dataPrev0 = dataPrev ?? '';
  final dataPrevFim0 = dataPrevFim ?? '';
  final categoriaFiltro0 = categoriaFiltro ?? '';
  final query = '''
SELECT * FROM local_reproducao
WHERE id_propriedade = '$idPropriedade'
AND ('$tipoRepro0' = '' OR tipo_reproducao = '$tipoRepro0' COLLATE NOCASE)
AND ('$inseminador0' = '' OR inseminador = '$inseminador0')
AND ('$loteNome0' = '' OR loteNome = '$loteNome0')
AND ('$dataRepro0' = '' OR date(data_inseminacao) >= date('$dataRepro0'))
AND ('$dataReproFim0' = '' OR date(data_inseminacao) <= date('$dataReproFim0'))
AND ('$dataPrev0' = '' OR date(previsao_parto) >= date('$dataPrev0'))
AND ('$dataPrevFim0' = '' OR date(previsao_parto) <= date('$dataPrevFim0'))
AND ('$categoriaFiltro0' = '' OR categoria IN (${categoriaFiltro0.split(',').where((e) => e.isNotEmpty).map((e) => "'${e.trim()}'").join(',')}))
AND deletado = 'NAO'


''';
  return _readQuery(database, query, (d) => QTDReproducoesRow(d));
}

class QTDReproducoesRow extends SqliteRow {
  QTDReproducoesRow(super.data);

  String? get id => data['id'] as String?;
}

/// END QTD REPRODUCOES

/// BEGIN QTD INSEMINACAO
Future<List<QTDInseminacaoRow>> performQTDInseminacao(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_reproducao
WHERE id_propriedade = '$idPropriedade'
AND tipo_reproducao = 'Inseminação' COLLATE NOCASE
AND deletado = 'NAO'

''';
  return _readQuery(database, query, (d) => QTDInseminacaoRow(d));
}

class QTDInseminacaoRow extends SqliteRow {
  QTDInseminacaoRow(super.data);

  String? get id => data['id'] as String?;
}

/// END QTD INSEMINACAO

/// BEGIN QTD MONTA NATURAL
Future<List<QTDMontaNaturalRow>> performQTDMontaNatural(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_reproducao
WHERE id_propriedade = '$idPropriedade'
AND tipo_reproducao = 'Monta Natural' COLLATE NOCASE
AND deletado = 'NAO'

''';
  return _readQuery(database, query, (d) => QTDMontaNaturalRow(d));
}

class QTDMontaNaturalRow extends SqliteRow {
  QTDMontaNaturalRow(super.data);

  String? get id => data['id'] as String?;
}

/// END QTD MONTA NATURAL

/// BEGIN BUSCAR REPRODUCAO
Future<List<BuscarReproducaoRow>> performBuscarReproducao(
  Database database, {
  String? idReproducao,
}) {
  final query = '''
SELECT * FROM local_reproducao
WHERE id_reproducao = '$idReproducao'
''';
  return _readQuery(database, query, (d) => BuscarReproducaoRow(d));
}

class BuscarReproducaoRow extends SqliteRow {
  BuscarReproducaoRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get tipoReproducao => data['tipo_reproducao'] as String?;
  String? get idRebanhoMatriz => data['id_rebanho_matriz'] as String?;
  double? get scoreCorporal => data['score_corporal'] as double?;
  String? get idRebanhoReprodutor => data['id_rebanho_reprodutor'] as String?;
  String? get dataInseminacao => data['data_inseminacao'] as String?;
  String? get dataPartidaSemen => data['data_partida_semen'] as String?;
  int? get partidaSemen => data['partida_semen'] as int?;
  String? get previsaoParto => data['previsao_parto'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get dataInicial => data['data_inicial'] as String?;
  String? get dataFinal => data['data_final'] as String?;
  String? get statusReproducao => data['status_reproducao'] as String?;
  String? get inseminador => data['inseminador'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idReproducao => data['id_reproducao'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get numMatriz => data['numMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get nascimentoMatriz => data['nascimentoMatriz'] as String?;
  String? get numReprodutor => data['numReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get nascimentoReprodutor => data['nascimentoReprodutor'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataStatus => data['data_status'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get chipReprodutor => data['chipReprodutor'] as String?;
  String? get chipMatriz => data['chipMatriz'] as String?;
  String? get ressinc => data['ressinc'] as String?;
  String? get parida => data['parida'] as String?;
  String? get dataParto => data['data_parto'] as String?;
  String? get gnrh => data['gnrh'] as String?;
  String? get cio => data['cio'] as String?;
}

/// END BUSCAR REPRODUCAO

/// BEGIN BUSCAR REPRODUCAO PUT
Future<List<BuscarReproducaoPUTRow>> performBuscarReproducaoPUT(
  Database database, {
  String? datePUT,
}) {
  final query = '''
SELECT * FROM local_reproducao
WHERE datetime(created_at, 'localtime') >= datetime('$datePUT', 'localtime')
''';
  return _readQuery(database, query, (d) => BuscarReproducaoPUTRow(d));
}

class BuscarReproducaoPUTRow extends SqliteRow {
  BuscarReproducaoPUTRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get tipoReproducao => data['tipo_reproducao'] as String?;
  String? get idRebanhoMatriz => data['id_rebanho_matriz'] as String?;
  double? get scoreCorporal => data['score_corporal'] as double?;
  String? get idRebanhoReprodutor => data['id_rebanho_reprodutor'] as String?;
  String? get dataInseminacao => data['data_inseminacao'] as String?;
  String? get dataPartidaSemen => data['data_partida_semen'] as String?;
  int? get partidaSemen => data['partida_semen'] as int?;
  String? get previsaoParto => data['previsao_parto'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get dataInicial => data['data_inicial'] as String?;
  String? get dataFinal => data['data_final'] as String?;
  String? get statusReproducao => data['status_reproducao'] as String?;
  String? get inseminador => data['inseminador'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idReproducao => data['id_reproducao'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get numMatriz => data['numMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get nascimentoMatriz => data['nascimentoMatriz'] as String?;
  String? get numReprodutor => data['numReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get nascimentoReprodutor => data['nascimentoReprodutor'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataStatus => data['data_status'] as String?;
  String? get chipReprodutor => data['chipReprodutor'] as String?;
  String? get chipMatriz => data['chipMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get ressinc => data['ressinc'] as String?;
  String? get parida => data['parida'] as String?;
  String? get dataParto => data['data_parto'] as String?;
  String? get gnrh => data['gnrh'] as String?;
  String? get cio => data['cio'] as String?;
}

/// END BUSCAR REPRODUCAO PUT

/// BEGIN BUSCAR REPRODUCAO UPDT
Future<List<BuscarReproducaoUPDTRow>> performBuscarReproducaoUPDT(
  Database database, {
  String? datePUT,
}) {
  final query = '''
SELECT * FROM local_reproducao
WHERE datetime(updated_at, 'localtime') >= datetime('$datePUT', 'localtime')

''';
  return _readQuery(database, query, (d) => BuscarReproducaoUPDTRow(d));
}

class BuscarReproducaoUPDTRow extends SqliteRow {
  BuscarReproducaoUPDTRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get tipoReproducao => data['tipo_reproducao'] as String?;
  String? get idRebanhoMatriz => data['id_rebanho_matriz'] as String?;
  double? get scoreCorporal => data['score_corporal'] as double?;
  String? get idRebanhoReprodutor => data['id_rebanho_reprodutor'] as String?;
  String? get dataInseminacao => data['data_inseminacao'] as String?;
  String? get dataPartidaSemen => data['data_partida_semen'] as String?;
  int? get partidaSemen => data['partida_semen'] as int?;
  String? get previsaoParto => data['previsao_parto'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get dataInicial => data['data_inicial'] as String?;
  String? get dataFinal => data['data_final'] as String?;
  String? get statusReproducao => data['status_reproducao'] as String?;
  String? get inseminador => data['inseminador'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idReproducao => data['id_reproducao'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get numMatriz => data['numMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get nascimentoMatriz => data['nascimentoMatriz'] as String?;
  String? get numReprodutor => data['numReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get nascimentoReprodutor => data['nascimentoReprodutor'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataStatus => data['data_status'] as String?;
  String? get chipReprodutor => data['chipReprodutor'] as String?;
  String? get chipMatriz => data['chipMatriz'] as String?;
  String? get ressinc => data['ressinc'] as String?;
  String? get parida => data['parida'] as String?;
  String? get dataParto => data['data_parto'] as String?;
  String? get gnrh => data['gnrh'] as String?;
  String? get cio => data['cio'] as String?;
}

/// END BUSCAR REPRODUCAO UPDT

/// BEGIN LISTARSANIDADES
Future<List<ListarSanidadesRow>> performListarSanidades(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_sanidade
WHERE id_propriedade = '$idPropriedade'
AND deletado = 'NAO'
''';
  return _readQuery(database, query, (d) => ListarSanidadesRow(d));
}

class ListarSanidadesRow extends SqliteRow {
  ListarSanidadesRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idRebanho => data['id_rebanho'] as String?;
  String? get dataSanidade => data['data_sanidade'] as String?;
  String? get vacinacao => data['vacinacao'] as String?;
  String? get vacinacaoOutros => data['vacinacao_outros'] as String?;
  String? get vacinacaoObs => data['vacinacao_obs'] as String?;
  String? get antiparasitario => data['antiparasitario'] as String?;
  String? get antiparasitarioOutros =>
      data['antiparasitario_outros'] as String?;
  String? get antiparasitarioObs => data['antiparasitario_obs'] as String?;
  String? get tratamento => data['tratamento'] as String?;
  String? get tratamentoOutros => data['tratamento_outros'] as String?;
  String? get tratamentoObs => data['tratamento_obs'] as String?;
  String? get protocoloReprodutivo => data['protocolo_reprodutivo'] as String?;
  String? get protocoloReprodutivoOutros =>
      data['protocolo_reprodutivo_outros'] as String?;
  String? get protocoloReprodutivoObs =>
      data['protocolo_reprodutivo_obs'] as String?;
  String? get idLote => data['id_lote'] as String?;
  double? get porcentagemLote => data['porcentagem_lote'] as double?;
  String? get idSanidade => data['id_sanidade'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
}

/// END LISTARSANIDADES

/// BEGIN BUSCAR SANIDADE PUT
Future<List<BuscarSanidadePUTRow>> performBuscarSanidadePUT(
  Database database, {
  String? datePUT,
}) {
  final query = '''
SELECT * FROM local_sanidade
WHERE datetime(created_at, 'localtime') >= datetime('$datePUT', 'localtime')
''';
  return _readQuery(database, query, (d) => BuscarSanidadePUTRow(d));
}

class BuscarSanidadePUTRow extends SqliteRow {
  BuscarSanidadePUTRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idRebanho => data['id_rebanho'] as String?;
  String? get dataSanidade => data['data_sanidade'] as String?;
  String? get vacinacao => data['vacinacao'] as String?;
  String? get vacinacaoOutros => data['vacinacao_outros'] as String?;
  String? get vacinacaoObs => data['vacinacao_obs'] as String?;
  String? get antiparasitario => data['antiparasitario'] as String?;
  String? get antiparasitarioOutros =>
      data['antiparasitario_outros'] as String?;
  String? get antiparasitarioObs => data['antiparasitario_obs'] as String?;
  String? get tratamento => data['tratamento'] as String?;
  String? get tratamentoOutros => data['tratamento_outros'] as String?;
  String? get tratamentoObs => data['tratamento_obs'] as String?;
  String? get protocoloReprodutivo => data['protocolo_reprodutivo'] as String?;
  String? get protocoloReprodutivoOutros =>
      data['protocolo_reprodutivo_outros'] as String?;
  String? get protocoloReprodutivoObs =>
      data['protocolo_reprodutivo_obs'] as String?;
  String? get idLote => data['id_lote'] as String?;
  double? get porcentagemLote => data['porcentagem_lote'] as double?;
  String? get idSanidade => data['id_sanidade'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get protocoloD0 => data['protocolo_d0'] as String?;
  String? get protocoloRetirada => data['protocolo_retirada'] as String?;
  String? get protocoloIatf => data['protocolo_iatf'] as String?;
}

/// END BUSCAR SANIDADE PUT

/// BEGIN BUSCAR SANIDADE UPDT
Future<List<BuscarSanidadeUPDTRow>> performBuscarSanidadeUPDT(
  Database database, {
  String? dateUPDT,
}) {
  final query = '''
SELECT * FROM local_sanidade
WHERE datetime(updated_at, 'localtime') >= datetime('$dateUPDT', 'localtime')
''';
  return _readQuery(database, query, (d) => BuscarSanidadeUPDTRow(d));
}

class BuscarSanidadeUPDTRow extends SqliteRow {
  BuscarSanidadeUPDTRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idRebanho => data['id_rebanho'] as String?;
  String? get dataSanidade => data['data_sanidade'] as String?;
  String? get vacinacao => data['vacinacao'] as String?;
  String? get vacinacaoOutros => data['vacinacao_outros'] as String?;
  String? get vacinacaoObs => data['vacinacao_obs'] as String?;
  String? get antiparasitario => data['antiparasitario'] as String?;
  String? get antiparasitarioOutros =>
      data['antiparasitario_outros'] as String?;
  String? get antiparasitarioObs => data['antiparasitario_obs'] as String?;
  String? get tratamento => data['tratamento'] as String?;
  String? get tratamentoOutros => data['tratamento_outros'] as String?;
  String? get tratamentoObs => data['tratamento_obs'] as String?;
  String? get protocoloReprodutivo => data['protocolo_reprodutivo'] as String?;
  String? get protocoloReprodutivoOutros =>
      data['protocolo_reprodutivo_outros'] as String?;
  String? get protocoloReprodutivoObs =>
      data['protocolo_reprodutivo_obs'] as String?;
  String? get idLote => data['id_lote'] as String?;
  double? get porcentagemLote => data['porcentagem_lote'] as double?;
  String? get idSanidade => data['id_sanidade'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get protocoloD0 => data['protocolo_d0'] as String?;
  String? get protocoloRetirada => data['protocolo_retirada'] as String?;
  String? get protocoloIatf => data['protocolo_iatf'] as String?;
}

/// END BUSCAR SANIDADE UPDT

/// BEGIN BUSCAR REPRODUCOES REBANHO
Future<List<BuscarReproducoesRebanhoRow>> performBuscarReproducoesRebanho(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
SELECT * FROM local_reproducao
WHERE (id_rebanho_matriz = '$idRebanho' OR id_rebanho_reprodutor = '$idRebanho')
AND deletado = 'NAO'
''';
  return _readQuery(database, query, (d) => BuscarReproducoesRebanhoRow(d));
}

class BuscarReproducoesRebanhoRow extends SqliteRow {
  BuscarReproducoesRebanhoRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get tipoReproducao => data['tipo_reproducao'] as String?;
  String? get idRebanhoMatriz => data['id_rebanho_matriz'] as String?;
  int? get scoreCorporal => data['score_corporal'] as int?;
  String? get idRebanhoReprodutor => data['id_rebanho_reprodutor'] as String?;
  String? get dataInseminacao => data['data_inseminacao'] as String?;
  String? get dataPartidaSemen => data['data_partida_semen'] as String?;
  int? get partidaSemen => data['partida_semen'] as int?;
  String? get previsaoParto => data['previsao_parto'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get dataInicial => data['data_inicial'] as String?;
  String? get dataFinal => data['data_final'] as String?;
  String? get statusReproducao => data['status_reproducao'] as String?;
  String? get inseminador => data['inseminador'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idReproducao => data['id_reproducao'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get numMatriz => data['numMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get nascimentoMatriz => data['nascimentoMatriz'] as String?;
  String? get numReprodutor => data['numReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get nascimentoReprodutor => data['nascimentoReprodutor'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataStatus => data['data_status'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get ressinc => data['ressinc'] as String?;
  String? get parida => data['parida'] as String?;
  String? get dataParto => data['data_parto'] as String?;
  String? get gnrh => data['gnrh'] as String?;
  String? get cio => data['cio'] as String?;
}

/// END BUSCAR REPRODUCOES REBANHO

/// BEGIN BUSCAR SANIDADES REBANHO
Future<List<BuscarSanidadesRebanhoRow>> performBuscarSanidadesRebanho(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
SELECT * FROM local_sanidade
WHERE id_rebanho = '$idRebanho'
''';
  return _readQuery(database, query, (d) => BuscarSanidadesRebanhoRow(d));
}

class BuscarSanidadesRebanhoRow extends SqliteRow {
  BuscarSanidadesRebanhoRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idRebanho => data['id_rebanho'] as String?;
  String? get dataSanidade => data['data_sanidade'] as String?;
  String? get vacinacao => data['vacinacao'] as String?;
  String? get vacinacaoOutros => data['vacinacao_outros'] as String?;
  String? get vacinacaoObs => data['vacinacao_obs'] as String?;
  String? get antiparasitario => data['antiparasitario'] as String?;
  String? get antiparasitarioOutros =>
      data['antiparasitario_outros'] as String?;
  String? get antiparasitarioObs => data['antiparasitario_obs'] as String?;
  String? get tratamento => data['tratamento'] as String?;
  String? get tratamentoOutros => data['tratamento_outros'] as String?;
  String? get tratamentoObs => data['tratamento_obs'] as String?;
  String? get protocoloReprodutivo => data['protocolo_reprodutivo'] as String?;
  String? get protocoloReprodutivoOutros =>
      data['protocolo_reprodutivo_outros'] as String?;
  String? get protocoloReprodutivoObs =>
      data['protocolo_reprodutivo_obs'] as String?;
  String? get idLote => data['id_lote'] as String?;
  double? get porcentagemLote => data['porcentagem_lote'] as double?;
  String? get idSanidade => data['id_sanidade'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get protocoloD0 => data['protocolo_d0'] as String?;
  String? get protocoloRetirada => data['protocolo_retirada'] as String?;
  String? get protocoloIatf => data['protocolo_iatf'] as String?;
}

/// END BUSCAR SANIDADES REBANHO

/// BEGIN BUSCA REBANHO PAGINADA
Future<List<BuscaRebanhoPaginadaRow>> performBuscaRebanhoPaginada(
  Database database, {
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
}) {
  final dataNascInicioValue = dataNascInicio ?? '';
  final dataNascFimValue = dataNascFim ?? '';
  final statusCondition =
      _buildSqlMultiValueCondition('statusRebanho', statusReb);
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND ('$sexo' = '' OR sexo = '$sexo')
AND ('$categoria' = '' OR categoria = '$categoria')
AND ('$raca' = '' OR raca = '$raca')
AND ('$origem' = '' OR origem = '$origem')
AND ('$loteId' = '' OR loteID = '$loteId')
AND ('$dataNascInicioValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento >= '$dataNascInicioValue'))
AND ('$dataNascFimValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento <= '$dataNascFimValue'))
AND $statusCondition
AND deletado = 'NAO'
ORDER BY created_at DESC
LIMIT $limitReb OFFSET $offsetReb

''';
  return _readQuery(database, query, (d) => BuscaRebanhoPaginadaRow(d));
}

class BuscaRebanhoPaginadaRow extends SqliteRow {
  BuscaRebanhoPaginadaRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END BUSCA REBANHO PAGINADA

/// BEGIN QTD ANIMAIS TOTAL PROPRIEDADE
Future<List<QTDAnimaisTotalPropriedadeRow>> performQTDAnimaisTotalPropriedade(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'

''';
  return _readQuery(database, query, (d) => QTDAnimaisTotalPropriedadeRow(d));
}

class QTDAnimaisTotalPropriedadeRow extends SqliteRow {
  QTDAnimaisTotalPropriedadeRow(super.data);

  int? get id => data['id'] as int?;
}

/// END QTD ANIMAIS TOTAL PROPRIEDADE

/// BEGIN BUSCAR CRIAS REBANHO REPRODUTOR
Future<List<BuscarCriasRebanhoReprodutorRow>>
    performBuscarCriasRebanhoReprodutor(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE rebanhoIdReprodutor = '$idRebanho' 
AND deletado = 'NAO'

''';
  return _readQuery(database, query, (d) => BuscarCriasRebanhoReprodutorRow(d));
}

class BuscarCriasRebanhoReprodutorRow extends SqliteRow {
  BuscarCriasRebanhoReprodutorRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  String? get raca => data['raca'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END BUSCAR CRIAS REBANHO REPRODUTOR

/// BEGIN BUSCAR REBANHO REPRODUCAO LOTE
Future<List<BuscarRebanhoReproducaoLoteRow>> performBuscarRebanhoReproducaoLote(
  Database database, {
  String? loteID,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE loteID = '$loteID'
AND sexo = 'Fêmea'

''';
  return _readQuery(database, query, (d) => BuscarRebanhoReproducaoLoteRow(d));
}

class BuscarRebanhoReproducaoLoteRow extends SqliteRow {
  BuscarRebanhoReproducaoLoteRow(super.data);

  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get dataVenda => data['dataVenda'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get movimentacaoEntrada => data['movimentacao_entrada'] as String?;
  String? get movimentacaoSaida => data['movimentacao_saida'] as String?;
  String? get dataMorte => data['data_morte'] as String?;
}

/// END BUSCAR REBANHO REPRODUCAO LOTE

/// BEGIN LISTARREPRODUCOES PAGINADA
Future<List<ListarReproducoesPaginadaRow>> performListarReproducoesPaginada(
  Database database, {
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
}) {
  final query = '''
SELECT * FROM local_reproducao
WHERE id_propriedade = '$idPropriedade'
AND ('$tipoRepro' = '' OR tipo_reproducao = '$tipoRepro' COLLATE NOCASE)
AND ('$inseminador' = '' OR inseminador = '$inseminador')
AND ('$loteNome' = '' OR loteNome = '$loteNome')
AND ('$dataRepro' = '' OR date(data_inseminacao) >= date('$dataRepro'))
AND ('$dataReproFim' = '' OR date(data_inseminacao) <= date('$dataReproFim'))
AND ('$dataPrev' = '' OR date(previsao_parto) >= date('$dataPrev'))
AND ('$dataPrevFim' = '' OR date(previsao_parto) <= date('$dataPrevFim'))
AND ('$categoriaFiltro' = '' OR categoria IN (${(categoriaFiltro ?? '').split(',').where((e) => e.isNotEmpty).map((e) => "'${e.trim()}'").join(',')}))
AND deletado = 'NAO'
ORDER BY created_at DESC
LIMIT $limitRep OFFSET $offsetRep

''';
  return _readQuery(database, query, (d) => ListarReproducoesPaginadaRow(d));
}

class ListarReproducoesPaginadaRow extends SqliteRow {
  ListarReproducoesPaginadaRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get tipoReproducao => data['tipo_reproducao'] as String?;
  String? get idRebanhoMatriz => data['id_rebanho_matriz'] as String?;
  int? get scoreCorporal => data['score_corporal'] as int?;
  String? get idRebanhoReprodutor => data['id_rebanho_reprodutor'] as String?;
  String? get dataInseminacao => data['data_inseminacao'] as String?;
  String? get dataPartidaSemen => data['data_partida_semen'] as String?;
  int? get partidaSemen => data['partida_semen'] as int?;
  String? get previsaoParto => data['previsao_parto'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get dataInicial => data['data_inicial'] as String?;
  String? get dataFinal => data['data_final'] as String?;
  String? get statusReproducao => data['status_reproducao'] as String?;
  String? get inseminador => data['inseminador'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idReproducao => data['id_reproducao'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get numMatriz => data['numMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get nascimentoMatriz => data['nascimentoMatriz'] as String?;
  String? get numReprodutor => data['numReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get nascimentoReprodutor => data['nascimentoReprodutor'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataStatus => data['data_status'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get ressinc => data['ressinc'] as String?;
  String? get parida => data['parida'] as String?;
  String? get dataParto => data['data_parto'] as String?;
  String? get gnrh => data['gnrh'] as String?;
  String? get cio => data['cio'] as String?;
}

/// END LISTARREPRODUCOES PAGINADA

/// BEGIN COUNT ANIMAIS LOTE
Future<List<CountAnimaisLoteRow>> performCountAnimaisLote(
  Database database, {
  String? loteNome,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE loteNome = '$loteNome'
''';
  return _readQuery(database, query, (d) => CountAnimaisLoteRow(d));
}

class CountAnimaisLoteRow extends SqliteRow {
  CountAnimaisLoteRow(super.data);

  int? get id => data['id'] as int?;
}

/// END COUNT ANIMAIS LOTE

/// BEGIN BUSCAR REBANHO NUM
Future<List<BuscarRebanhoNumRow>> performBuscarRebanhoNum(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE idRebanho = '$idRebanho'
''';
  return _readQuery(database, query, (d) => BuscarRebanhoNumRow(d));
}

class BuscarRebanhoNumRow extends SqliteRow {
  BuscarRebanhoNumRow(super.data);

  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get dataVenda => data['dataVenda'] as String?;
  double? get valorVenda => data['valorVenda'] as double?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get movimentacaoEntrada => data['movimentacao_entrada'] as String?;
  String? get movimentacaoSaida => data['movimentacao_saida'] as String?;
  String? get dataMorte => data['data_morte'] as String?;
}

/// END BUSCAR REBANHO NUM

/// BEGIN BUSCA REBANHO PAGINADA PESQUISA
Future<List<BuscaRebanhoPaginadaPesquisaRow>>
    performBuscaRebanhoPaginadaPesquisa(
  Database database, {
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
}) {
  final dataNascInicioValue = dataNascInicio ?? '';
  final dataNascFimValue = dataNascFim ?? '';
  final statusCondition =
      _buildSqlMultiValueCondition('statusRebanho', statusReb);
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND ('$sexo' = '' OR sexo = '$sexo')
AND ('$categoria' = '' OR categoria = '$categoria')
AND ('$raca' = '' OR raca = '$raca')
AND ('$origem' = '' OR origem = '$origem')
AND ('$loteId' = '' OR loteID = '$loteId')
AND ('$pesquisa' = '' OR numeroAnimal LIKE '%$pesquisa%' OR nome LIKE '%$pesquisa%' 
OR chip LIKE '%$pesquisa%')
AND ('$dataNascInicioValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento >= '$dataNascInicioValue'))
AND ('$dataNascFimValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento <= '$dataNascFimValue'))
AND $statusCondition
AND deletado = 'NAO'
ORDER BY created_at DESC
LIMIT 100

''';
  return _readQuery(database, query, (d) => BuscaRebanhoPaginadaPesquisaRow(d));
}

class BuscaRebanhoPaginadaPesquisaRow extends SqliteRow {
  BuscaRebanhoPaginadaPesquisaRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END BUSCA REBANHO PAGINADA PESQUISA

/// BEGIN LISTARREPRODUCOES PESQ
Future<List<ListarReproducoesPesqRow>> performListarReproducoesPesq(
  Database database, {
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
}) {
  final query = '''
SELECT * FROM local_reproducao a
WHERE a.id_propriedade = '$idPropriedade'
AND ('$tipoRepro' = '' OR a.tipo_reproducao = '$tipoRepro' COLLATE NOCASE)
AND ('$inseminador' = '' OR a.inseminador = '$inseminador')
AND ('$loteNome' = '' OR a.loteNome = '$loteNome')
AND ('$pesquisa' = '' OR a.numMatriz LIKE '%$pesquisa%' OR a.nomeMatriz LIKE '%$pesquisa%' OR 
a.numReprodutor LIKE '%$pesquisa%' OR a.nomeReprodutor LIKE '%$pesquisa%' OR 
a.chipMatriz LIKE '%$pesquisa%' OR a.chipReprodutor LIKE '%$pesquisa%')
AND ('$dataRepro' = '' OR date(data_inseminacao) >= date('$dataRepro'))
AND ('$dataReproFim' = '' OR date(data_inseminacao) <= date('$dataReproFim'))
AND ('$dataPrev' = '' OR date(previsao_parto) >= date('$dataPrev'))
AND ('$dataPrevFim' = '' OR date(previsao_parto) <= date('$dataPrevFim'))
AND ('$categoriaFiltro' = '' OR a.categoria IN (${(categoriaFiltro ?? '').split(',').where((e) => e.isNotEmpty).map((e) => "'${e.trim()}'").join(',')}))
AND deletado = 'NAO'
ORDER BY created_at DESC
--LIMIT 100

''';
  return _readQuery(database, query, (d) => ListarReproducoesPesqRow(d));
}

class ListarReproducoesPesqRow extends SqliteRow {
  ListarReproducoesPesqRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get tipoReproducao => data['tipo_reproducao'] as String?;
  String? get idRebanhoMatriz => data['id_rebanho_matriz'] as String?;
  int? get scoreCorporal => data['score_corporal'] as int?;
  String? get idRebanhoReprodutor => data['id_rebanho_reprodutor'] as String?;
  String? get dataInseminacao => data['data_inseminacao'] as String?;
  String? get dataPartidaSemen => data['data_partida_semen'] as String?;
  int? get partidaSemen => data['partida_semen'] as int?;
  String? get previsaoParto => data['previsao_parto'] as String?;
  String? get idLote => data['id_lote'] as String?;
  String? get dataInicial => data['data_inicial'] as String?;
  String? get dataFinal => data['data_final'] as String?;
  String? get statusReproducao => data['status_reproducao'] as String?;
  String? get inseminador => data['inseminador'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idReproducao => data['id_reproducao'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get numMatriz => data['numMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get nascimentoMatriz => data['nascimentoMatriz'] as String?;
  String? get numReprodutor => data['numReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get nascimentoReprodutor => data['nascimentoReprodutor'] as String?;
  String? get loteNome => data['loteNome'] as String?;
  String? get dataStatus => data['data_status'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
  String? get ressinc => data['ressinc'] as String?;
  String? get parida => data['parida'] as String?;
  String? get dataParto => data['data_parto'] as String?;
  String? get gnrh => data['gnrh'] as String?;
  String? get cio => data['cio'] as String?;
}

/// END LISTARREPRODUCOES PESQ

/// BEGIN BUSCA SANIDADES PESQ
Future<List<BuscaSanidadesPesqRow>> performBuscaSanidadesPesq(
  Database database, {
  String? idPropriedade,
  String? pesquisa,
  String? vacinas,
  String? antiparasitario,
  String? tratamentos,
  String? protocolo,
  String? idRebanho,
  String? idLote,
  String? dataSanidade,
}) {
  final query = '''
SELECT ls.* 
FROM local_sanidade ls
LEFT JOIN local_rebanho lr ON ls.id_rebanho = lr.idRebanho
WHERE ls.id_propriedade = '$idPropriedade'
AND ('$idLote' = '' OR ls.id_lote = '$idLote')
AND ('$pesquisa' = '' OR 
     ls.vacinacao LIKE '%$pesquisa%' OR 
     ls.antiparasitario LIKE '%$pesquisa%' OR 
     ls.tratamento LIKE '%$pesquisa%' OR 
     ls.protocolo_reprodutivo LIKE '%$pesquisa%' OR
     lr.numeroAnimal LIKE '%$pesquisa%' OR
     lr.nome LIKE '%$pesquisa%')
AND ('$vacinas' = '' OR ls.vacinacao LIKE '%$vacinas%')
AND ('$antiparasitario' = '' OR ls.antiparasitario LIKE '%$antiparasitario%')
AND ('$tratamentos' = '' OR ls.tratamento LIKE '%$tratamentos%')
AND ('$protocolo' = '' OR ls.protocolo_reprodutivo LIKE '%$protocolo%')
AND ('$idRebanho' = '' OR ls.id_rebanho = '$idRebanho')
AND ('$dataSanidade' = '' OR ls.data_sanidade >= '$dataSanidade')
AND ls.deletado = 'NAO'
ORDER BY ls.created_at DESC
''';
  return _readQuery(database, query, (d) => BuscaSanidadesPesqRow(d));
}

class BuscaSanidadesPesqRow extends SqliteRow {
  BuscaSanidadesPesqRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idRebanho => data['id_rebanho'] as String?;
  String? get dataSanidade => data['data_sanidade'] as String?;
  String? get vacinacao => data['vacinacao'] as String?;
  String? get vacinacaoOutros => data['vacinacao_outros'] as String?;
  String? get vacinacaoObs => data['vacinacao_obs'] as String?;
  String? get antiparasitario => data['antiparasitario'] as String?;
  String? get antiparasitarioOutros =>
      data['antiparasitario_outros'] as String?;
  String? get antiparasitarioObs => data['antiparasitario_obs'] as String?;
  String? get tratamento => data['tratamento'] as String?;
  String? get tratamentoOutros => data['tratamento_outros'] as String?;
  String? get tratamentoObs => data['tratamento_obs'] as String?;
  String? get protocoloReprodutivo => data['protocolo_reprodutivo'] as String?;
  String? get protocoloReprodutivoOutros =>
      data['protocolo_reprodutivo_outros'] as String?;
  String? get protocoloReprodutivoObs =>
      data['protocolo_reprodutivo_obs'] as String?;
  String? get idLote => data['id_lote'] as String?;
  double? get porcentagemLote => data['porcentagem_lote'] as double?;
  String? get idSanidade => data['id_sanidade'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get protocoloD0 => data['protocolo_d0'] as String?;
  String? get protocoloRetirada => data['protocolo_retirada'] as String?;
  String? get protocoloIatf => data['protocolo_iatf'] as String?;
}

/// END BUSCA SANIDADES PESQ

/// BEGIN BUSCA SANIDADES PAGINADA
Future<List<BuscaSanidadesPaginadaRow>> performBuscaSanidadesPaginada(
  Database database, {
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
}) {
  final query = '''
SELECT * FROM local_sanidade
WHERE id_propriedade = '$idPropriedade'
AND ('$idLote' = '' OR id_lote = '$idLote')
AND ('$vacinas' = ''OR vacinacao LIKE '%$vacinas%')
AND ('$antiparasitario' = '' OR antiparasitario LIKE '%$antiparasitario%')
AND ('$tratamentos' = ''OR tratamento LIKE '%$tratamentos%')
AND ('$protocolo' = '' OR protocolo_reprodutivo LIKE '%$protocolo%')
AND ('$idRebanho' = '' OR id_rebanho = '$idRebanho')
AND ('$dataSanidade' = '' OR data_sanidade >= '$dataSanidade')
AND deletado = 'NAO'
ORDER BY created_at DESC
LIMIT $limitRows OFFSET $offsetRows
''';
  return _readQuery(database, query, (d) => BuscaSanidadesPaginadaRow(d));
}

class BuscaSanidadesPaginadaRow extends SqliteRow {
  BuscaSanidadesPaginadaRow(super.data);

  String? get idPropriedade => data['id_propriedade'] as String?;
  String? get idRebanho => data['id_rebanho'] as String?;
  String? get dataSanidade => data['data_sanidade'] as String?;
  String? get vacinacao => data['vacinacao'] as String?;
  String? get vacinacaoOutros => data['vacinacao_outros'] as String?;
  String? get vacinacaoObs => data['vacinacao_obs'] as String?;
  String? get antiparasitario => data['antiparasitario'] as String?;
  String? get antiparasitarioOutros =>
      data['antiparasitario_outros'] as String?;
  String? get antiparasitarioObs => data['antiparasitario_obs'] as String?;
  String? get tratamento => data['tratamento'] as String?;
  String? get tratamentoOutros => data['tratamento_outros'] as String?;
  String? get tratamentoObs => data['tratamento_obs'] as String?;
  String? get protocoloReprodutivo => data['protocolo_reprodutivo'] as String?;
  String? get protocoloReprodutivoOutros =>
      data['protocolo_reprodutivo_outros'] as String?;
  String? get protocoloReprodutivoObs =>
      data['protocolo_reprodutivo_obs'] as String?;
  String? get idLote => data['id_lote'] as String?;
  double? get porcentagemLote => data['porcentagem_lote'] as double?;
  String? get idSanidade => data['id_sanidade'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get protocoloD0 => data['protocolo_d0'] as String?;
  String? get protocoloRetirada => data['protocolo_retirada'] as String?;
  String? get protocoloIatf => data['protocolo_iatf'] as String?;
}

/// END BUSCA SANIDADES PAGINADA

/// BEGIN QTD SANIDADES
Future<List<QTDSanidadesRow>> performQTDSanidades(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_sanidade
WHERE id_propriedade = '$idPropriedade'
AND deletado = 'NAO'
''';
  return _readQuery(database, query, (d) => QTDSanidadesRow(d));
}

class QTDSanidadesRow extends SqliteRow {
  QTDSanidadesRow(super.data);

  int? get id => data['id'] as int?;
}

/// END QTD SANIDADES

/// BEGIN BUSCA USER LOGADO
Future<List<BuscaUserLogadoRow>> performBuscaUserLogado(
  Database database, {
  String? email,
}) {
  final query = '''
SELECT * FROM local_users
WHERE email = '$email'
''';
  return _readQuery(database, query, (d) => BuscaUserLogadoRow(d));
}

class BuscaUserLogadoRow extends SqliteRow {
  BuscaUserLogadoRow(super.data);

  String? get userID => data['userID'] as String?;
  String? get nome => data['nome'] as String?;
  String? get email => data['email'] as String?;
  int? get termos => data['termos'] as int?;
  String? get foto => data['foto'] as String?;
  String? get telefone => data['telefone'] as String?;
  int? get excluido => data['excluido'] as int?;
  String? get permissao => data['permissao'] as String?;
}

/// END BUSCA USER LOGADO

/// BEGIN QTD ANIMAIS NO LOTE
Future<List<QtdAnimaisNoLoteRow>> performQtdAnimaisNoLote(
  Database database, {
  String? loteID,
}) {
  final query = '''
select count(*) as qtd_animais from local_rebanho
where loteID = '$loteID'
''';
  return _readQuery(database, query, (d) => QtdAnimaisNoLoteRow(d));
}

class QtdAnimaisNoLoteRow extends SqliteRow {
  QtdAnimaisNoLoteRow(super.data);

  int? get qtdAnimais => data['qtd_animais'] as int?;
}

/// END QTD ANIMAIS NO LOTE

/// BEGIN BUSCAR ANIMAIS DO LOTE
Future<List<BuscarAnimaisDoLoteRow>> performBuscarAnimaisDoLote(
  Database database, {
  String? loteid,
}) {
  final query = '''
select * from local_rebanho
where loteID = '$loteid'
''';
  return _readQuery(database, query, (d) => BuscarAnimaisDoLoteRow(d));
}

class BuscarAnimaisDoLoteRow extends SqliteRow {
  BuscarAnimaisDoLoteRow(super.data);

  String? get idRebanho => data['idRebanho'] as String?;
}

/// END BUSCAR ANIMAIS DO LOTE

/// BEGIN REBANHO PAG ORD NUM CRES
Future<List<RebanhoPagOrdNumCresRow>> performRebanhoPagOrdNumCres(
  Database database, {
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
}) {
  final dataNascInicioValue = dataNascInicio ?? '';
  final dataNascFimValue = dataNascFim ?? '';
  final statusCondition =
      _buildSqlMultiValueCondition('statusRebanho', statusReb);
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND ('$sexo' = '' OR sexo = '$sexo')
AND ('$categoria' = '' OR categoria = '$categoria')
AND ('$raca' = '' OR raca = '$raca')
AND ('$origem' = '' OR origem = '$origem')
AND ('$loteId' = '' OR loteID = '$loteId')
AND ('$dataNascInicioValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento >= '$dataNascInicioValue'))
AND ('$dataNascFimValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento <= '$dataNascFimValue'))
AND $statusCondition
AND deletado = 'NAO'
ORDER BY numeroAnimal ASC
LIMIT $limitReb OFFSET $offsetReb

''';
  return _readQuery(database, query, (d) => RebanhoPagOrdNumCresRow(d));
}

class RebanhoPagOrdNumCresRow extends SqliteRow {
  RebanhoPagOrdNumCresRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END REBANHO PAG ORD NUM CRES

/// BEGIN REBANHO PAG ORD NUM DESC
Future<List<RebanhoPagOrdNumDescRow>> performRebanhoPagOrdNumDesc(
  Database database, {
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
}) {
  final dataNascInicioValue = dataNascInicio ?? '';
  final dataNascFimValue = dataNascFim ?? '';
  final statusCondition =
      _buildSqlMultiValueCondition('statusRebanho', statusReb);
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND ('$sexo' = '' OR sexo = '$sexo')
AND ('$categoria' = '' OR categoria = '$categoria')
AND ('$raca' = '' OR raca = '$raca')
AND ('$origem' = '' OR origem = '$origem')
AND ('$loteId' = '' OR loteID = '$loteId')
AND ('$dataNascInicioValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento >= '$dataNascInicioValue'))
AND ('$dataNascFimValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento <= '$dataNascFimValue'))
AND $statusCondition
AND deletado = 'NAO'
ORDER BY numeroAnimal DESC
LIMIT $limitReb OFFSET $offsetReb

''';
  return _readQuery(database, query, (d) => RebanhoPagOrdNumDescRow(d));
}

class RebanhoPagOrdNumDescRow extends SqliteRow {
  RebanhoPagOrdNumDescRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END REBANHO PAG ORD NUM DESC

/// BEGIN REBANHO PAG ORD NOM CRES
Future<List<RebanhoPagOrdNomCresRow>> performRebanhoPagOrdNomCres(
  Database database, {
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
}) {
  final dataNascInicioValue = dataNascInicio ?? '';
  final dataNascFimValue = dataNascFim ?? '';
  final statusCondition =
      _buildSqlMultiValueCondition('statusRebanho', statusReb);
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND ('$sexo' = '' OR sexo = '$sexo')
AND ('$categoria' = '' OR categoria = '$categoria')
AND ('$raca' = '' OR raca = '$raca')
AND ('$origem' = '' OR origem = '$origem')
AND ('$loteId' = '' OR loteID = '$loteId')
AND ('$dataNascInicioValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento >= '$dataNascInicioValue'))
AND ('$dataNascFimValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento <= '$dataNascFimValue'))
AND $statusCondition
AND deletado = 'NAO'
ORDER BY nome ASC
LIMIT $limitReb OFFSET $offsetReb

''';
  return _readQuery(database, query, (d) => RebanhoPagOrdNomCresRow(d));
}

class RebanhoPagOrdNomCresRow extends SqliteRow {
  RebanhoPagOrdNomCresRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END REBANHO PAG ORD NOM CRES

/// BEGIN REBANHO PAG ORD NOM DESC
Future<List<RebanhoPagOrdNomDescRow>> performRebanhoPagOrdNomDesc(
  Database database, {
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
}) {
  final dataNascInicioValue = dataNascInicio ?? '';
  final dataNascFimValue = dataNascFim ?? '';
  final statusCondition =
      _buildSqlMultiValueCondition('statusRebanho', statusReb);
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND ('$sexo' = '' OR sexo = '$sexo')
AND ('$categoria' = '' OR categoria = '$categoria')
AND ('$raca' = '' OR raca = '$raca')
AND ('$origem' = '' OR origem = '$origem')
AND ('$loteId' = '' OR loteID = '$loteId')
AND ('$dataNascInicioValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento >= '$dataNascInicioValue'))
AND ('$dataNascFimValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento <= '$dataNascFimValue'))
AND $statusCondition
AND deletado = 'NAO'
ORDER BY nome DESC
LIMIT $limitReb OFFSET $offsetReb

''';
  return _readQuery(database, query, (d) => RebanhoPagOrdNomDescRow(d));
}

class RebanhoPagOrdNomDescRow extends SqliteRow {
  RebanhoPagOrdNomDescRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END REBANHO PAG ORD NOM DESC

/// BEGIN REBANHO PAG ORD DATA CRES
Future<List<RebanhoPagOrdDataCresRow>> performRebanhoPagOrdDataCres(
  Database database, {
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
}) {
  final dataNascInicioValue = dataNascInicio ?? '';
  final dataNascFimValue = dataNascFim ?? '';
  final statusCondition =
      _buildSqlMultiValueCondition('statusRebanho', statusReb);
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND ('$sexo' = '' OR sexo = '$sexo')
AND ('$categoria' = '' OR categoria = '$categoria')
AND ('$raca' = '' OR raca = '$raca')
AND ('$origem' = '' OR origem = '$origem')
AND ('$loteId' = '' OR loteID = '$loteId')
AND ('$dataNascInicioValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento >= '$dataNascInicioValue'))
AND ('$dataNascFimValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento <= '$dataNascFimValue'))
AND $statusCondition
AND deletado = 'NAO'
ORDER BY 
  CASE WHEN dataNascimento IS NULL OR dataNascimento = '' OR dataNascimento = 'null' THEN 1 ELSE 0 END,
  dataNascimento ASC
LIMIT $limitReb OFFSET $offsetReb

''';
  return _readQuery(database, query, (d) => RebanhoPagOrdDataCresRow(d));
}

class RebanhoPagOrdDataCresRow extends SqliteRow {
  RebanhoPagOrdDataCresRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END REBANHO PAG ORD DATA CRES

/// BEGIN REBANHO PAG ORD DATA DESC
Future<List<RebanhoPagOrdDataDescRow>> performRebanhoPagOrdDataDesc(
  Database database, {
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
}) {
  final dataNascInicioValue = dataNascInicio ?? '';
  final dataNascFimValue = dataNascFim ?? '';
  final statusCondition =
      _buildSqlMultiValueCondition('statusRebanho', statusReb);
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND ('$sexo' = '' OR sexo = '$sexo')
AND ('$categoria' = '' OR categoria = '$categoria')
AND ('$raca' = '' OR raca = '$raca')
AND ('$origem' = '' OR origem = '$origem')
AND ('$loteId' = '' OR loteID = '$loteId')
AND ('$dataNascInicioValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento >= '$dataNascInicioValue'))
AND ('$dataNascFimValue' = '' OR (dataNascimento IS NOT NULL AND dataNascimento != '' AND dataNascimento != 'null' AND dataNascimento <= '$dataNascFimValue'))
AND $statusCondition
AND deletado = 'NAO'
ORDER BY 
  CASE WHEN dataNascimento IS NULL OR dataNascimento = '' OR dataNascimento = 'null' THEN 1 ELSE 0 END,
  dataNascimento DESC
LIMIT $limitReb OFFSET $offsetReb

''';
  return _readQuery(database, query, (d) => RebanhoPagOrdDataDescRow(d));
}

class RebanhoPagOrdDataDescRow extends SqliteRow {
  RebanhoPagOrdDataDescRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END REBANHO PAG ORD DATA DESC

/// BEGIN LISTARPROPRIEDADES CRESC NOME
Future<List<ListarPropriedadesCrescNomeRow>> performListarPropriedadesCrescNome(
  Database database, {
  String? userID,
}) {
  final query = '''
SELECT * FROM local_propriedades 
WHERE 1=1
AND (userID = '$userID' OR usersID LIKE '%$userID%') 
AND deletado = 'NAO' 
ORDER BY nome ASC;
''';
  return _readQuery(database, query, (d) => ListarPropriedadesCrescNomeRow(d));
}

class ListarPropriedadesCrescNomeRow extends SqliteRow {
  ListarPropriedadesCrescNomeRow(super.data);

  int? get id => data['id'] as int?;
  String? get userID => data['userID'] as String?;
  String? get usersID => data['usersID'] as String?;
  String? get rebanhosID => data['rebanhosID'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  int? get areaAgricultura => data['areaAgricultura'] as int?;
  int? get areaBenfeitoria => data['areaBenfeitoria'] as int?;
  int? get areaPastagem => data['areaPastagem'] as int?;
  int? get areaReserva => data['areaReserva'] as int?;
  int? get areaTotal => data['areaTotal'] as int?;
  String? get cidade => data['cidade'] as String?;
  String? get estado => data['estado'] as String?;
  String? get icone => data['icone'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get atividades => data['atividades'] as String?;
  String? get nome => data['nome'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get deletado => data['deletado'] as String?;
}

/// END LISTARPROPRIEDADES CRESC NOME

/// BEGIN LISTARPROPRIEDADES DEC NOME
Future<List<ListarPropriedadesDecNomeRow>> performListarPropriedadesDecNome(
  Database database, {
  String? userID,
}) {
  final query = '''
SELECT * FROM local_propriedades 
WHERE 1=1
AND (userID = '$userID' OR usersID LIKE '%$userID%') 
AND deletado = 'NAO' 
ORDER BY nome DESC;
''';
  return _readQuery(database, query, (d) => ListarPropriedadesDecNomeRow(d));
}

class ListarPropriedadesDecNomeRow extends SqliteRow {
  ListarPropriedadesDecNomeRow(super.data);

  int? get id => data['id'] as int?;
  String? get userID => data['userID'] as String?;
  String? get usersID => data['usersID'] as String?;
  String? get rebanhosID => data['rebanhosID'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  int? get areaAgricultura => data['areaAgricultura'] as int?;
  int? get areaBenfeitoria => data['areaBenfeitoria'] as int?;
  int? get areaPastagem => data['areaPastagem'] as int?;
  int? get areaReserva => data['areaReserva'] as int?;
  int? get areaTotal => data['areaTotal'] as int?;
  String? get cidade => data['cidade'] as String?;
  String? get estado => data['estado'] as String?;
  String? get icone => data['icone'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  String? get atividades => data['atividades'] as String?;
  String? get nome => data['nome'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get deletado => data['deletado'] as String?;
}

/// END LISTARPROPRIEDADES DEC NOME

/// BEGIN BUSCA REBANHO POPUP
Future<List<BuscaRebanhoPopupRow>> performBuscaRebanhoPopup(
  Database database, {
  String? idPropriedade,
  String? pesquisa,
  String? sexo,
  String? statusRebanho,
  String? categoria,
  String? categoriaExcluir,
  String? excludeIdRebanho,
  int limit = 30,
}) {
  final conditions = StringBuffer();
  conditions.write("idPropriedade = '$idPropriedade' AND deletado = 'NAO'");

  if (pesquisa != null && pesquisa.isNotEmpty) {
    conditions.write(
        " AND (numeroAnimal LIKE '$pesquisa%' OR nome LIKE '$pesquisa%' OR chip LIKE '$pesquisa%')");
  }
  if (sexo != null && sexo.isNotEmpty) {
    conditions.write(" AND sexo = '$sexo'");
  }
  if (statusRebanho != null && statusRebanho.isNotEmpty) {
    conditions.write(" AND statusRebanho = '$statusRebanho'");
  }
  if (categoria != null && categoria.isNotEmpty) {
    conditions.write(" AND categoria = '$categoria'");
  }
  if (categoriaExcluir != null && categoriaExcluir.isNotEmpty) {
    conditions.write(" AND categoria != '$categoriaExcluir'");
  }
  if (excludeIdRebanho != null && excludeIdRebanho.isNotEmpty) {
    conditions.write(" AND idRebanho != '$excludeIdRebanho'");
  }

  final query = '''
SELECT idRebanho, numeroAnimal, nome, dataNascimento, raca, chip, categoria, sexo, statusRebanho, loteNome
FROM local_rebanho
WHERE ${conditions.toString()}
ORDER BY numeroAnimal ASC
LIMIT $limit
''';
  return _readQuery(database, query, (d) => BuscaRebanhoPopupRow(d));
}

class BuscaRebanhoPopupRow extends SqliteRow {
  BuscaRebanhoPopupRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END BUSCA REBANHO POPUP

/// BEGIN REBANHO POPUP SP
Future<List<RebanhoPopupSPRow>> performRebanhoPopupSP(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
SELECT * FROM local_rebanho
WHERE idPropriedade = '$idPropriedade'
AND deletado = 'NAO'
LIMIT 30

''';
  return _readQuery(database, query, (d) => RebanhoPopupSPRow(d));
}

class RebanhoPopupSPRow extends SqliteRow {
  RebanhoPopupSPRow(super.data);

  String? get numeroAnimal => data['numeroAnimal'] as String?;
  String? get chip => data['chip'] as String?;
  String? get codRegistro => data['codRegistro'] as String?;
  String? get nome => data['nome'] as String?;
  String? get sexo => data['sexo'] as String?;
  String? get categoria => data['categoria'] as String?;
  String? get dataNascimento => data['dataNascimento'] as String?;
  double? get pesoNascimento => data['pesoNascimento'] as double?;
  String? get porte => data['porte'] as String?;
  String? get raca => data['raca'] as String?;
  String? get loteID => data['loteID'] as String?;
  String? get dataEntradaLote => data['dataEntradaLote'] as String?;
  String? get rebanhoIdMatriz => data['rebanhoIdMatriz'] as String?;
  String? get rebanhoIdReprodutor => data['rebanhoIdReprodutor'] as String?;
  String? get dataDesmama => data['dataDesmama'] as String?;
  double? get pesoDesmama => data['pesoDesmama'] as double?;
  double? get pesoAtual => data['pesoAtual'] as double?;
  String? get statusRebanho => data['statusRebanho'] as String?;
  String? get origem => data['origem'] as String?;
  String? get anotacoes => data['anotacoes'] as String?;
  String? get idRebanho => data['idRebanho'] as String?;
  String? get deletado => data['deletado'] as String?;
  String? get createdAt => data['created_at'] as String?;
  String? get updatedAt => data['updated_at'] as String?;
  int? get id => data['id'] as int?;
  String? get loteNome => data['loteNome'] as String?;
  String? get tipo => data['tipo'] as String?;
  String? get dataAcao => data['dataAcao'] as String?;
  String? get nomeConcat => data['nomeConcat'] as String?;
  String? get idPropriedade => data['idPropriedade'] as String?;
  double? get valorCompra => data['valorCompra'] as double?;
  String? get dataUltimaPesagem => data['dataUltimaPesagem'] as String?;
  String? get numeroMatriz => data['numeroMatriz'] as String?;
  String? get nomeMatriz => data['nomeMatriz'] as String?;
  String? get dataNascMatriz => data['dataNascMatriz'] as String?;
  String? get racaMatriz => data['racaMatriz'] as String?;
  String? get numeroReprodutor => data['numeroReprodutor'] as String?;
  String? get nomeReprodutor => data['nomeReprodutor'] as String?;
  String? get dataNascReprodutor => data['dataNascReprodutor'] as String?;
  String? get racaReprodutor => data['racaReprodutor'] as String?;
}

/// END REBANHO POPUP SP

/// BEGIN LISTA INSEMINADORES
Future<List<ListaInseminadoresRow>> performListaInseminadores(
  Database database, {
  String? propriedade,
}) {
  final query = '''
select distinct(inseminador) from local_reproducao
where id_propriedade = '$propriedade'
order by inseminador desc
''';
  return _readQuery(database, query, (d) => ListaInseminadoresRow(d));
}

class ListaInseminadoresRow extends SqliteRow {
  ListaInseminadoresRow(super.data);

  String? get inseminador => data['inseminador'] as String?;
}

/// END LISTA INSEMINADORES
