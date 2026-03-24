import 'package:sqflite/sqflite.dart';

/// BEGIN INSERTPROPRIEDADE
Future performInsertPropriedade(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_propriedades (userID, usersID, rebanhosID, anotacoes, areaAgricultura, areaBenfeitoria, areaPastagem, areaReserva, 
areaTotal, cidade, estado, icone, idPropriedade, atividades, nome, updated_at, created_at, deletado) 
VALUES ('$userID', '$usersID', '$rebanhosID', '$anotacoes', $areaAgricultura, $areaBenfeitoria, $areaPastagem, 
$areaReserva, $areaTotal,'$cidade', '$estado', '$icone', '$idPropriedade', '$atividades', '$nome', 
'$updatedat', '$createdat', '$deletado')
''';
  return database.rawQuery(query);
}

/// END INSERTPROPRIEDADE

/// BEGIN DELETAR TODAS PROPRIEDADES
Future performDeletarTodasPropriedades(
  Database database,
) {
  const query = '''
Delete from local_propriedades;
''';
  return database.rawQuery(query);
}

/// END DELETAR TODAS PROPRIEDADES

/// BEGIN DELETE PROP
Future performDeleteProp(
  Database database, {
  String? idPropriedade,
}) {
  final query = '''
delete from local_propriedades
where idPropriedade = '$idPropriedade'
''';
  return database.rawQuery(query);
}

/// END DELETE PROP

/// BEGIN UPDATE PROPRIEDADE
Future performUpdatePropriedade(
  Database database, {
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
}) {
  final query = '''
UPDATE local_propriedades
SET nome = '$nome', estado = '$estado', cidade = '$cidade', areaAgricultura = $areaAgricultura, 
areaBenfeitoria = $areaBenfeitoria, areaPastagem = $areaPastagem, areaReserva = $areaReserva, 
areaTotal = $areaTotal, icone = '$icone', atividades = '$atividades', anotacoes = '$anotacoes', 
usersID = '$usersID', updated_at = '$updatedat'
WHERE idPropriedade = '$idPropriedade'
''';
  return database.rawQuery(query);
}

/// END UPDATE PROPRIEDADE

/// BEGIN ADD USER NA PROPRIEDADE
Future performAddUserNaPropriedade(
  Database database, {
  String? usersID,
  String? idPropriedade,
  String? updatedat,
}) {
  final query = '''
UPDATE local_propriedades
SET usersID = '$usersID', updated_at = '$updatedat'
WHERE idPropriedade = '$idPropriedade'
''';
  return database.rawQuery(query);
}

/// END ADD USER NA PROPRIEDADE

/// BEGIN INSERIR USER NA PROPRIEDADE
Future performInserirUserNaPropriedade(
  Database database, {
  String? userID,
  String? nome,
  String? email,
  String? foto,
  String? permissao,
  String? idPropriedade,
  String? deletado,
}) {
  final query = '''
INSERT INTO local_usuarios_propriedade (user_id, nome, email, foto, permissao, idPropriedade, deletado)
VALUES ('$userID', '$nome', '$email', '$foto', '$permissao', '$idPropriedade', '$deletado')
''';
  return database.rawQuery(query);
}

/// END INSERIR USER NA PROPRIEDADE

/// BEGIN UPDT FUNCAO USER LOCAL
Future performUPDTFuncaoUserLocal(
  Database database, {
  String? permissao,
  String? userID,
}) {
  final query = '''
UPDATE local_users_propriedades
SET permissao = '$permissao'
where user_id = '$userID'
''';
  return database.rawQuery(query);
}

/// END UPDT FUNCAO USER LOCAL

/// BEGIN INSERTREBANHO
Future performInsertRebanho(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_rebanho (
    idPropriedade,
    numeroAnimal,
    chip,
    codRegistro,
    nome,
    sexo,
    categoria,
    dataNascimento,
    pesoNascimento,
    porte,
    raca,
    loteID,
    dataEntradaLote,
    dataDesmama,
    pesoDesmama,
    pesoAtual,
    statusRebanho,
    origem,
    anotacoes,
    idRebanho,
    deletado,
    created_at,
    updated_at,
    loteNome,
    tipo,
    dataAcao,
    valorCompra,
    dataUltimaPesagem,
    nomeConcat,
    dataVenda,
    valorVenda,
    movimentacao_entrada,
    numeroMatriz,
    nomeMatriz,
    dataNascMatriz,
    racaMatriz,
    numeroReprodutor,
    nomeReprodutor,
    dataNascReprodutor,
    racaReprodutor,
    movimentacao_saida,
    data_morte,
    motivo_morte,
    categoria_matriz,
    rebanhoIdMatriz,
    rebanhoIdReprodutor
) VALUES (
    '$idPropriedade',
    '$numeroAnimal',
    '$chip',
    '$codRegistro',
    '$nome',
    '$sexo',
    '$categoria',
    '$dataNascimento',
    $pesoNascimento,
    '$porte',
    '$raca',
    '$loteID',
    '$dataEntradaLote',
    '$dataDesmama',
    $pesoDesmama,
    $pesoAtual,
    '$statusRebanho',
    '$origem',
    '$anotacoes',
    '$idRebanho',
    '$deletado',
    '$createdat',
    '$updatedat',
    '$loteNome',
    '$tipo',
    '$dataAcao',
    $valorCompra,
    '$dataUltimaPesagem',
    '$nomeConcat',
    '$dataVenda',
    $valorVenda,
    '$movimentacaoentrada',
    '$numeroMatriz',
    '$nomeMatriz',
    '$dataNascMatriz',
    '$racaMatriz',
    '$numeroReprodutor',
    '$nomeReprodutor',
    '$dataNascReprodutor',
    '$racaReprodutor',
    '$movimentacaosaida',
    '$datamorte',
    '$motivomorte',
    '$categoriamatriz',
    '$rebanhoIdMatriz',
    '$rebanhoIdReprodutor'
);
''';
  return database.rawQuery(query);
}

/// END INSERTREBANHO

/// BEGIN DELETAR TODOS REBANHOS
Future performDeletarTodosRebanhos(
  Database database,
) {
  const query = '''
delete from local_rebanho
''';
  return database.rawQuery(query);
}

/// END DELETAR TODOS REBANHOS

/// BEGIN ADD REBANHO NA PROPRIEDADE
Future performAddRebanhoNaPropriedade(
  Database database, {
  String? rebanhosID,
  String? updatedat,
  String? idPropriedade,
}) {
  final query = '''
UPDATE local_propriedades
SET rebanhosID = '$rebanhosID', updated_at = '$updatedat'
WHERE idPropriedade = '$idPropriedade'
''';
  return database.rawQuery(query);
}

/// END ADD REBANHO NA PROPRIEDADE

/// BEGIN INSERTREBANHO NASCIMENTO
Future performInsertRebanhoNascimento(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_rebanho (
    idPropriedade,
    numeroAnimal,
    chip,
    codRegistro,
    nome,
    sexo,
    categoria,
    dataNascimento,
    pesoNascimento,
    porte,
    raca,
    origem,
    dataEntradaLote,
    statusRebanho,
    anotacoes,
    idRebanho,
    deletado,
    created_at,
    updated_at,
    tipo,
    loteNome,
    loteID,
    dataVenda,
    valorVenda,
    numeroMatriz,
    nomeMatriz,
    dataNascMatriz,
    racaMatriz,
    numeroReprodutor,
    nomeReprodutor,
    dataNascReprodutor,
    racaReprodutor,
    movimentacao_saida,
    data_morte,
    motivo_morte,
    categoria_matriz,
    rebanhoIdMatriz,
    rebanhoIdReprodutor
) VALUES (
    '$idPropriedade',
    '$numeroAnimal',
    '$chip',
    '$codRegistro',
    '$nome',
    '$sexo',
    '$categoria',
    '$dataNascimento',
    $pesoNascimento,
    '$porte',
    '$raca',
    'Nascimento',
    '$dataEntradaLote',
    '$statusRebanho',
    '$anotacoes',
    '$idRebanho',
    '$deletado',
    '$createdat',
    '$updatedat',
    '$tipo',
    '$loteNome',
    '$loteID',
    '$dataVenda',
    $valorVenda,
    '$numeroMatriz',
    '$nomeMatriz',
    '$dataNascMatriz',
    '$racaMatriz',
    '$numeroReprodutor',
    '$nomeReprodutor',
    '$dataNascReprodutor',
    '$racaReprodutor',
    '$movimentacaosaida',
    '$datamorte',
    '$motivomorte',
    '$categoriamatriz',
    '$rebanhoIdMatriz',
    '$rebanhoIdReprodutor'
);
''';
  return database.rawQuery(query);
}

/// END INSERTREBANHO NASCIMENTO

/// BEGIN INSERTREBANHO SEMEN
Future performInsertRebanhoSemen(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_rebanho (
    idPropriedade,
    numeroAnimal,
    codRegistro,
    nome,
    raca,
    sexo,
    categoria,
    anotacoes,
    idRebanho,
    deletado,
    created_at,
    updated_at,
    tipo,
    nomeConcat,
    statusRebanho
) VALUES (
    '$idPropriedade',
    '$numeroAnimal',
    '$codRegistro',
    '$nome',
    '$raca',
    '$sexo',
    '$categoria',
    '$anotacoes',
    '$idRebanho',
    '$deletado',
    '$createdat',
    '$updatedat',
    '$tipo',
    '$nomeConcat',
    '$statusRebanho'
);
''';
  return database.rawQuery(query);
}

/// END INSERTREBANHO SEMEN

/// BEGIN ADD PESAGEM
Future performAddPesagem(
  Database database, {
  String? idRebanho,
  String? dataPesagem,
  String? tipo,
  double? peso,
  String? deletado,
  String? createdat,
  String? idPropriedade,
}) {
  final query = '''
INSERT INTO local_historico_pesagens (idRebanho, dataPesagem, tipo, peso, deletado, created_at, id_propriedade)
VALUES ('$idRebanho', '$dataPesagem', '$tipo', $peso, '$deletado', '$createdat', '$idPropriedade')
''';
  return database.rawQuery(query);
}

/// END ADD PESAGEM

/// BEGIN UPDT PESO REBANHO
Future performUPDTPesoRebanho(
  Database database, {
  double? peso,
  String? data,
  String? idRebanho,
}) {
  final query = '''
UPDATE local_rebanho
SET pesoAtual = $peso, dataUltimaPesagem = '$data'
WHERE idRebanho = '$idRebanho'
''';
  return database.rawQuery(query);
}

/// END UPDT PESO REBANHO

/// BEGIN UPDT REBANHO
Future performUPDTRebanho(
  Database database, {
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
}) {
  const query = '''
UPDATE local_rebanho
SET numeroAnimal = ?, chip = ?, codRegistro = ?, nome = ?, sexo = ?,
categoria = ?, dataNascimento = ?, pesoNascimento = ?, porte = ?,
raca = ?, dataEntradaLote = ?,
dataDesmama = ?, pesoDesmama = ?, pesoAtual = ?, statusRebanho = ?,
origem = ?, anotacoes = ?, dataAcao = ?, valorCompra = ?, 
dataUltimaPesagem = ?, nomeConcat = ?, updated_at = ?, 
loteNome = ?, loteID = ?, movimentacao_entrada = ?, dataVenda = ?,
valorVenda = ?, numeroMatriz = ?, nomeMatriz = ?, dataNascMatriz = ?,
racaMatriz = ?, numeroReprodutor = ?, nomeReprodutor = ?, dataNascReprodutor = ?,
racaReprodutor = ?, movimentacao_saida = ?, data_morte = ?, motivo_morte = ?,
categoria_matriz = ?, rebanhoIdMatriz = ?, rebanhoIdReprodutor = ?
WHERE idRebanho = ?
''';
  return database.rawUpdate(query, [
    numeroAnimal,
    chip,
    codRegistro,
    nome,
    sexo,
    categoria,
    dataNascimento,
    pesoNascimento,
    porte,
    raca,
    dataEntradaLote,
    dataDesmama,
    pesoDesmama,
    pesoAtual,
    statusRebanho,
    origem,
    anotacoes,
    dataAcao,
    valorCompra,
    dataUltimaPesagem,
    nomeConcat,
    updatedat,
    loteNome,
    loteID,
    movimentacaoentrada,
    dataVenda,
    valorVenda,
    numeroMatriz,
    nomeMatriz,
    dataNascMatriz,
    racaMatriz,
    numeroReprodutor,
    nomeReprodutor,
    dataNascReprodutor,
    racaReprodutor,
    movimentacaosaida,
    datamorte,
    motivomorte,
    categoriamatriz,
    rebanhoIdMatriz,
    rebanhoIdReprodutor,
    idRebanho,
  ]);
}

/// END UPDT REBANHO

/// BEGIN DELETE PESAGEM
Future performDeletePesagem(
  Database database, {
  String? idRebanho,
  int? idPesagem,
}) {
  final query = '''
UPDATE local_historico_pesagens
SET deletado = 'SIM'
WHERE idRebanho = '$idRebanho'
AND id = $idPesagem
''';
  return database.rawQuery(query);
}

/// END DELETE PESAGEM

/// BEGIN DELETAR TODAS PESAGENS
Future performDeletarTodasPesagens(
  Database database,
) {
  const query = '''
DELETE FROM local_historico_pesagens
''';
  return database.rawQuery(query);
}

/// END DELETAR TODAS PESAGENS

/// BEGIN UPDT REBANHOCOPY
Future performUPDTRebanhoCopy(
  Database database, {
  String? numeroAnimal,
  String? idRebanho,
}) {
  final query = '''
UPDATE local_rebanho
SET numeroAnimal = '$numeroAnimal'
WHERE = '$idRebanho'
''';
  return database.rawQuery(query);
}

/// END UPDT REBANHOCOPY

/// BEGIN INSERT LOTE
Future performInsertLote(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_lotes (id_propriedade, id_animais, nome, anotacoes, ativo,
motivo, data_motivo, id_lote, deletado, created_at, updated_at, valorVenda)
VALUES ('$idPropriedade', '$idAnimais', '$nome', '$anotacoes', '$ativo', '$motivo', '$dataMotivo', 
'$idLote', '$deletado', '$createdat', '$updatedat', $valorVenda)
''';
  return database.rawQuery(query);
}

/// END INSERT LOTE

/// BEGIN UPDT REBANHO LOTE
Future performUPDTRebanhoLote(
  Database database, {
  String? loteNome,
  String? loteID,
  String? updatedat,
  String? idRebanho,
  String? dataEntradaLote,
}) {
  final query = '''
UPDATE local_rebanho
SET loteID = '$loteID', loteNome = '$loteNome', updated_at = '$updatedat', dataEntradaLote = '$dataEntradaLote'
WHERE idRebanho = '$idRebanho'
''';
  return database.rawQuery(query);
}

/// END UPDT REBANHO LOTE

/// BEGIN DELETE ALL LOTES
Future performDeleteAllLotes(
  Database database,
) {
  const query = '''
DELETE FROM local_lotes
''';
  return database.rawQuery(query);
}

/// END DELETE ALL LOTES

/// BEGIN UPDT LOTE
Future performUPDTLote(
  Database database, {
  String? idAnimais,
  String? nome,
  String? anotacoes,
  String? ativo,
  String? motivo,
  String? dataMotivo,
  String? updatedat,
  String? idLote,
  double? valorVenda,
}) {
  final query = '''
UPDATE local_lotes
SET id_animais = '$idAnimais', nome = '$nome', anotacoes = '$anotacoes', ativo = '$ativo', motivo = '$motivo',
data_motivo = '{dataMotivo}', updated_at = '$updatedat', valorVenda = $valorVenda
WHERE id_lote = '$idLote'
''';
  return database.rawQuery(query);
}

/// END UPDT LOTE

/// BEGIN INSERT REPRODUCAO
Future performInsertReproducao(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_reproducao (
    id_propriedade, 
    tipo_reproducao, 
    score_corporal, 
    data_inseminacao, 
    data_partida_semen, 
    partida_semen, 
    previsao_parto, 
    id_lote, 
    data_inicial, 
    data_final, 
    inseminador, 
    anotacoes, 
    id_reproducao, 
    deletado, 
    created_at, 
    updated_at, 
    categoria, 
    numMatriz, 
    nomeMatriz, 
    nascimentoMatriz, 
    numReprodutor, 
    nomeReprodutor, 
    nascimentoReprodutor, 
    loteNome,
    status_reproducao,
    data_status,
    racaMatriz,
    racaReprodutor,
    chipReprodutor,
    chipMatriz,
    ressinc,
    parida,
    data_parto,
    id_rebanho_matriz,
    id_rebanho_reprodutor,
    gnrh,
    cio
) VALUES (
    '$idPropriedade',
    '$tipoReproducao',
    $scoreCorporal,
    '$dataInseminacao',
    '$dataPartidaSemen',
    $partidaSemen,
    '$previsaoParto',
    '$idLote',
    '$dataInicial',
    '$dataFinal',
    '$inseminador',
    '$anotacoes',
    '$idReproducao',
    '$deletado',
    '$createdAt',
    '$updatedAt',
    '$categoria',
    '$numMatriz',
    '$nomeMatriz',
    '$nascimentoMatriz',
    '$numReprodutor',
    '$nomeReprodutor',
    '$nascimentoReprodutor',
    '$loteNome',
    '$statusReproducao',
    '$dataStatus',
    '$racaMatriz',
    '$racaReprodutor',
    '$chipReprodutor',
    '$chipMatriz',
    '$ressinc',
    '$parida',
    '$dataParto',
    '$idrebanhomatriz',
    '$idrebanhoreprodutor',
    '$gnrh',
    '$cio'
)
''';
  return database.rawQuery(query);
}

/// END INSERT REPRODUCAO

/// BEGIN DELETE REPRODUCAO REB
Future performDeleteReproducaoReb(
  Database database, {
  String? idReproducao,
  String? updatedat,
}) {
  final query = '''
UPDATE local_reproducao
SET deletado = 'SIM', updated_at = '$updatedat'
WHERE id_reproducao = '$idReproducao'
''';
  return database.rawQuery(query);
}

/// END DELETE REPRODUCAO REB

/// BEGIN UPDT REPRODUCAO
Future performUPDTReproducao(
  Database database, {
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
}) {
  final query = '''
UPDATE local_reproducao SET
    tipo_reproducao = '$tipoReproducao',
    score_corporal = $scoreCorporal,
    data_inseminacao = '$dataInseminacao',
    data_partida_semen = '$dataPartidaSemen',
    partida_semen = $partidaSemen,
    previsao_parto = '$previsaoParto',
    id_lote = '$idLote',
    data_inicial = '$dataInicial',
    data_final = '$dataFinal',
    inseminador = '$inseminador',
    anotacoes = '$anotacoes',
    deletado = '$deletado',
    updated_at = '$updatedAt',
    numMatriz = '$numMatriz',
    nomeMatriz = '$nomeMatriz',
    nascimentoMatriz = '$nascimentoMatriz',
    numReprodutor = '$numReprodutor',
    nomeReprodutor = '$nomeReprodutor',
    nascimentoReprodutor = '$nascimentoReprodutor',
    loteNome = '$loteNome',
    status_reproducao = '$statusReproducao',
    data_status = '$dataStatus',
    racaMatriz = '$racaMatriz',
    racaReprodutor = '$racaReprodutor',
    chipReprodutor = '$chipReprodutor',
    chipMatriz = '$chipMatriz',
    ressinc = '$ressinc',
    parida = '$parida',
    data_parto = '$dataParto',
    id_rebanho_matriz = '$idrebanhomatriz',
    id_rebanho_reprodutor = '$idrebanhoreprodutor',
    gnrh = '$gnrh',
    cio = '$cio'
WHERE id_reproducao = '$idReproducao'
''';
  return database.rawQuery(query);
}

/// END UPDT REPRODUCAO

/// BEGIN DELETE ALL REPRODUCAO
Future performDeleteAllReproducao(
  Database database,
) {
  const query = '''
delete from local_reproducao
''';
  return database.rawQuery(query);
}

/// END DELETE ALL REPRODUCAO

/// BEGIN INSERTSANIDADEANIMAL
Future performInsertSanidadeAnimal(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_sanidade (
    id_propriedade,
    id_rebanho,
    data_sanidade,
    id_sanidade,
    updated_at,
    deletado,
    vacinacao,
    vacinacao_outros,
    vacinacao_obs,
    antiparasitario,
    antiparasitario_outros,
    antiparasitario_obs,
    tratamento,
    tratamento_outros,
    tratamento_obs,
    protocolo_reprodutivo,
    protocolo_reprodutivo_outros,
    protocolo_reprodutivo_obs,
    created_at,
    protocolo_d0,
    protocolo_retirada,
    protocolo_iatf
) VALUES (
    '$idPropriedade',
    '$idRebanho', 
    '$dataSanidade',
    '$idSanidade',
    '$updatedat', 
    '$deletado', 
    '$vacinacao',
    '$vacinacaoOutros',
    '$vacinacaoObs',
    '$antiparasitario',
    '$antiparasitarioOutros',
    '$antiparasitarioObs',
    '$tratamento',
    '$tratamentoOutros',
    '$tratamentoObs',
    '$protocoloReprodutivo',
    '$protocoloreprodutivoOutros',
    '$protocoloreprodutivoObs',
    '$createdat',
    '$protocolod0',
    '$protocoloretirada',
    '$protocoloiatf'
);
''';
  return database.rawQuery(query);
}

/// END INSERTSANIDADEANIMAL

/// BEGIN DELETE SANIDADE
Future performDeleteSanidade(
  Database database, {
  String? idSanidade,
  String? updatedat,
}) {
  final query = '''
UPDATE local_sanidade
SET deletado = 'SIM', updated_at = '$updatedat'
WHERE id_sanidade = '$idSanidade'
''';
  return database.rawQuery(query);
}

/// END DELETE SANIDADE

/// BEGIN INSERTSANIDADELOTE
Future performInsertSanidadeLote(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_sanidade (
    id_propriedade,
    data_sanidade,
    id_lote,
    porcentagem_lote,
    id_sanidade,
    updated_at,
    deletado,
    vacinacao,
    vacinacao_outros,
    vacinacao_obs,
    antiparasitario,
    antiparasitario_outros,
    antiparasitario_obs,
    tratamento,
    tratamento_outros,
    tratamento_obs,
    protocolo_reprodutivo,
    protocolo_reprodutivo_outros,
    protocolo_reprodutivo_obs,
    created_at
) VALUES (
    '$idPropriedade', 
    '$dataSanidade',
    '$idLote',
    $porcentagemLote,
    '$idSanidade',
    '$updatedat', 
    '$deletado', 
    '$vacinacao',
    '$vacinacaoOutros',
    '$vacinacaoObs',
    '$antiparasitario',
    '$antiparasitarioOutros',
    '$antiparasitarioObs',
    '$tratamento',
    '$tratamentoOutros',
    '$tratamentoObs',
    '$protocoloReprodutivo',
    '$protocoloreprodutivoOutros',
    '$protocoloreprodutivoObs',
    '$createdat'
);
''';
  return database.rawQuery(query);
}

/// END INSERTSANIDADELOTE

/// BEGIN UPDT SANIDADE ANIMAL
Future performUPDTSanidadeAnimal(
  Database database, {
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
}) {
  final query = '''
UPDATE local_sanidade
 SET  data_sanidade = '$dataSanidade',
    updated_at = '$updatedat',
    vacinacao = '$vacinacao',
    vacinacao_outros = '$vacinacaoOutros',
    vacinacao_obs = '$vacinacaoObs',
    antiparasitario = '$antiparasitario',
    antiparasitario_outros = '$antiparasitarioOutros',
    antiparasitario_obs = '$antiparasitarioObs',
    tratamento = '$tratamento',
    tratamento_outros = '$tratamentoOutros',
    tratamento_obs = '$tratamentoObs',
    protocolo_reprodutivo = '$protocoloReprodutivo',
    protocolo_reprodutivo_outros = '$protocoloreprodutivoOutros',
    protocolo_reprodutivo_obs = '$protocoloreprodutivoObs',
    protocolo_d0 = '$protocolod0',
    protocolo_retirada = '$protocoloretirada',
    protocolo_iatf = '$protocoloiatf'
 WHERE id_sanidade = '$idSanidade'
''';
  return database.rawQuery(query);
}

/// END UPDT SANIDADE ANIMAL

/// BEGIN DELETE ALL SANIDADES
Future performDeleteAllSanidades(
  Database database,
) {
  const query = '''
DELETE FROM local_sanidade
''';
  return database.rawQuery(query);
}

/// END DELETE ALL SANIDADES

/// BEGIN UPDT SANIDADE LOTE
Future performUPDTSanidadeLote(
  Database database, {
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
}) {
  final query = '''
UPDATE local_sanidade
 SET  data_sanidade = '$dataSanidade',
 porcentagem_lote = $porcentagemLote,
    updated_at = '$updatedat',
    vacinacao = '$vacinacao',
    vacinacao_outros = '$vacinacaoOutros',
    vacinacao_obs = '$vacinacaoObs',
    antiparasitario = '$antiparasitario',
    antiparasitario_outros = '$antiparasitarioOutros',
    antiparasitario_obs = '$antiparasitarioObs',
    tratamento = '$tratamento',
    tratamento_outros = '$tratamentoOutros',
    tratamento_obs = '$tratamentoObs',
    protocolo_reprodutivo = '$protocoloReprodutivo',
    protocolo_reprodutivo_outros = '$protocoloreprodutivoOutros',
    protocolo_reprodutivo_obs = '$protocoloreprodutivoObs'
 WHERE id_sanidade = '$idSanidade'
''';
  return database.rawQuery(query);
}

/// END UPDT SANIDADE LOTE

/// BEGIN INSERT SANIDADE SYNC
Future performInsertSanidadeSync(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_sanidade (
    id_propriedade,
    id_rebanho,
    data_sanidade,
    id_lote,
    porcentagem_lote,
    id_sanidade,
    updated_at,
    deletado,
    vacinacao,
    vacinacao_outros,
    vacinacao_obs,
    antiparasitario,
    antiparasitario_outros,
    antiparasitario_obs,
    tratamento,
    tratamento_outros,
    tratamento_obs,
    protocolo_reprodutivo,
    protocolo_reprodutivo_outros,
    protocolo_reprodutivo_obs,
    created_at
) VALUES (
    '$idPropriedade', 
    '$idRebanho',
    '$dataSanidade',
    '$idLote',
    $porcentagemLote,
    '$idSanidade',
    '$updatedat', 
    '$deletado', 
    '$vacinacao',
    '$vacinacaoOutros',
    '$vacinacaoObs',
    '$antiparasitario',
    '$antiparasitarioOutros',
    '$antiparasitarioObs',
    '$tratamento',
    '$tratamentoOutros',
    '$tratamentoObs',
    '$protocoloReprodutivo',
    '$protocoloreprodutivoOutros',
    '$protocoloreprodutivoObs',
    '$createdat'
);
''';
  return database.rawQuery(query);
}

/// END INSERT SANIDADE SYNC

/// BEGIN DELETE REBANHO
Future performDeleteRebanho(
  Database database, {
  String? idRebanho,
  String? updatedat,
}) {
  final query = '''
UPDATE local_rebanho
SET deletado = 'SIM', updated_at = '$updatedat'
where idRebanho = '$idRebanho'
''';
  return database.rawQuery(query);
}

/// END DELETE REBANHO

/// BEGIN UPDT LOTEREBANHO
Future performUPDTLoteRebanho(
  Database database, {
  String? idAnimais,
  String? updatedat,
  String? idLote,
}) {
  final query = '''
UPDATE local_lotes
SET id_animais = '$idAnimais', updated_at = '$updatedat'
WHERE id_lote = '$idLote'
''';
  return database.rawQuery(query);
}

/// END UPDT LOTEREBANHO

/// BEGIN DELETAR LOTE
Future performDeletarLote(
  Database database, {
  String? idLote,
}) {
  final query = '''
DELETE FROM local_lotes
WHERE id_lote = '$idLote'
''';
  return database.rawQuery(query);
}

/// END DELETAR LOTE

/// BEGIN DELETE PROPRIEDADE
Future performDeletePropriedade(
  Database database, {
  String? idPropriedade,
  String? updatedat,
}) {
  final query = '''
UPDATE local_propriedades
SET deletado = 'SIM', updated_at = '$updatedat'
where idPropriedade = '$idPropriedade'
''';
  return database.rawQuery(query);
}

/// END DELETE PROPRIEDADE

/// BEGIN DELETE LOTE
Future performDeleteLote(
  Database database, {
  String? idLote,
  String? updatedat,
}) {
  final query = '''
UPDATE local_lotes
SET deletado = 'SIM', updated_at = '$updatedat'
WHERE id_lote = '$idLote'
''';
  return database.rawQuery(query);
}

/// END DELETE LOTE

/// BEGIN APAGAR REB LOCAL
Future performApagarRebLocal(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
DELETE FROM local_rebanho
WHERE idRebanho = '$idRebanho'
''';
  return database.rawQuery(query);
}

/// END APAGAR REB LOCAL

/// BEGIN APAGAR PESAGEM LOCAL
Future performApagarPesagemLocal(
  Database database, {
  String? idRebanho,
}) {
  final query = '''
DELETE FROM local_historico_pesagens
WHERE idRebanho = '$idRebanho'
''';
  return database.rawQuery(query);
}

/// END APAGAR PESAGEM LOCAL

/// BEGIN APAGAR REPRO LOCAL
Future performApagarReproLocal(
  Database database, {
  String? idRepro,
}) {
  final query = '''
DELETE FROM local_reproducao
WHERE id_reproducao = '$idRepro'
''';
  return database.rawQuery(query);
}

/// END APAGAR REPRO LOCAL

/// BEGIN INSERT REPRODUCAO MONTA
Future performInsertReproducaoMonta(
  Database database, {
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
}) {
  final query = '''
INSERT INTO local_reproducao (
    id_propriedade, 
    tipo_reproducao, 
    score_corporal, 
    data_inseminacao,
    previsao_parto,
    id_lote, 
    data_inicial, 
    data_final, 
    anotacoes, 
    id_reproducao, 
    deletado, 
    created_at, 
    updated_at, 
    categoria, 
    numMatriz, 
    nomeMatriz, 
    nascimentoMatriz, 
    numReprodutor, 
    nomeReprodutor, 
    nascimentoReprodutor, 
    loteNome,
    status_reproducao,
    data_status,
    racaMatriz,
    racaReprodutor,
    chipReprodutor,
    chipMatriz,
    ressinc,
    parida,
    data_parto,
    id_rebanho_matriz,
    id_rebanho_reprodutor,
    gnrh,
    cio
) VALUES (
    '$idPropriedade',
    '$tipoReproducao',
    $scoreCorporal,
    '$datainseminacao',
    '$previsaoParto',
    '$idLote',
    '$dataInicial',
    '$dataFinal',
    '$anotacoes',
    '$idReproducao',
    '$deletado',
    '$createdAt',
    '$updatedAt',
    '$categoria',
    '$numMatriz',
    '$nomeMatriz',
    '$nascimentoMatriz',
    '$numReprodutor',
    '$nomeReprodutor',
    '$nascimentoReprodutor',
    '$loteNome',
    '$statusReproducao',
    '$dataStatus',
    '$racaMatriz',
    '$racaReprodutor',
    '$chipReprodutor',
    '$chipMatriz',
    '$ressinc',
    '$parida',
    '$dataParto',
    '$idrebanhomatriz',
    '$idrebanhoreprodutor',
    '$gnrh',
    '$cio'
)
''';
  return database.rawQuery(query);
}

/// END INSERT REPRODUCAO MONTA

/// BEGIN DELETE REPRO
Future performDeleteRepro(
  Database database, {
  String? id,
}) {
  final query = '''
DELETE FROM local_reproducao
where id_reproducao = '$id'
''';
  return database.rawQuery(query);
}

/// END DELETE REPRO

/// BEGIN UPDT REBANHO LOTE VENDA
Future performUPDTRebanhoLoteVenda(
  Database database, {
  String? loteNome,
  String? loteID,
  String? updatedat,
  String? idRebanho,
  String? dataEntradaLote,
  String? dataVenda,
  double? valorVenda,
}) {
  final query = '''
UPDATE local_rebanho
SET loteID = '$loteID', loteNome = '$loteNome', updated_at = '$updatedat', dataEntradaLote = '$dataEntradaLote',
dataVenda = '$dataVenda', valorVenda = $valorVenda, statusRebanho = 'Vendido'
WHERE idRebanho = '$idRebanho'
''';
  return database.rawQuery(query);
}

/// END UPDT REBANHO LOTE VENDA

/// BEGIN UPDT REPRODUCAOMONTA
Future performUPDTReproducaoMonta(
  Database database, {
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
}) {
  final query = '''
UPDATE local_reproducao SET
    tipo_reproducao = '$tipoReproducao',
    score_corporal = $scoreCorporal,
    data_partida_semen = '$dataPartidaSemen',
    partida_semen = $partidaSemen,
    previsao_parto = '$previsaoParto',
    id_lote = '$idLote',
    data_inicial = '$dataInicial',
    data_final = '$dataFinal',
    anotacoes = '$anotacoes',
    deletado = '$deletado',
    updated_at = '$updatedAt',
    numMatriz = '$numMatriz',
    nomeMatriz = '$nomeMatriz',
    nascimentoMatriz = '$nascimentoMatriz',
    numReprodutor = '$numReprodutor',
    nomeReprodutor = '$nomeReprodutor',
    nascimentoReprodutor = '$nascimentoReprodutor',
    loteNome = '$loteNome',
    status_reproducao = '$statusReproducao',
    data_status = '$dataStatus',
    racaMatriz = '$racaMatriz',
    racaReprodutor = '$racaReprodutor',
    chipReprodutor = '$chipReprodutor',
    chipMatriz = '$chipMatriz',
    ressinc = '$ressinc',
    parida = '$parida',
    data_parto = '$dataParto',
    id_rebanho_matriz = '$idrebanhomatriz',
    id_rebanho_reprodutor = '$idrebanhoreprodutor',
    gnrh = '$gnrh',
    cio = '$cio'
WHERE id_reproducao = '$idReproducao'
''';
  return database.rawQuery(query);
}

/// END UPDT REPRODUCAOMONTA

/// BEGIN UPDATE PROP
Future performUpdateProp(
  Database database, {
  String? idPropriedade,
  String? atividades,
}) {
  final query = '''
UPDATE local_propriedades
SET atividades = '$atividades'
WHERE idPropriedade = '$idPropriedade'
''';
  return database.rawQuery(query);
}

/// END UPDATE PROP

/// BEGIN DELETE ALL REPRODUCAOCOPY
Future performDeleteAllReproducaoCopy(
  Database database, {
  String? id,
}) {
  final query = '''
delete from local_reproducao
where id_reproducao = '$id'
''';
  return database.rawQuery(query);
}

/// END DELETE ALL REPRODUCAOCOPY
