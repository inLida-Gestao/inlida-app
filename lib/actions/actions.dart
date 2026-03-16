import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';

void _syncLog(String flow, String message) {
  debugPrint('[SYNC][$flow] $message');
}

int _safeTotalFromApi(dynamic body) {
  if (body == null) return 0;
  if (body is num) return body.toInt();
  if (body is String) return int.tryParse(body.trim()) ?? 0;

  if (body is List && body.isNotEmpty) {
    return _safeTotalFromApi(body.first);
  }

  if (body is Map) {
    for (final key in const ['total', 'count', 'qtd', 'qtde', 'value']) {
      if (body.containsKey(key)) {
        return _safeTotalFromApi(body[key]);
      }
    }
  }

  return 0;
}

List<dynamic> _safeRecordsFromApi(dynamic body) {
  if (body is List) return List<dynamic>.from(body);
  if (body is Map && body['data'] is List) {
    return List<dynamic>.from(body['data'] as List);
  }
  return <dynamic>[];
}

List<String> _safePropertyIds(dynamic body) {
  if (body is! List) return <String>[];

  return body
      .map<PropriedadesStruct?>(PropriedadesStruct.maybeFromMap)
      .whereType<PropriedadesStruct>()
      .map((e) => e.idPropriedade)
      .whereType<String>()
      .where((e) => e.isNotEmpty)
      .toList();
}

/// Exibe um popup com a lista de registros que falharam durante a sincronização.
Future<void> _showSyncErrorsDialog(
  BuildContext context,
  String flowName,
  List<Map<String, String>> errors,
) async {
  if (errors.isEmpty) return;
  if (!context.mounted) return;

  try {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Erros na sincronização - $flowName',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${errors.length} registro(s) com erro:',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: errors.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final err = errors[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${err['id'] ?? '-'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            err['error'] ?? 'Erro desconhecido',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
    debugPrint('[SYNC] Não foi possível exibir popup de erros: $e');
  }
}

Future refreshPropriedades(BuildContext context) async {
  try {
    List<PropriedadesChangeTrackerRow>? lastChangeResult;
    ApiCallResponse? propriedade;

    try {
      lastChangeResult = await PropriedadesChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e) {
      _syncLog('propriedades', 'ERRO ao consultar change tracker: $e');
      lastChangeResult = [];
    }
    final remoteLastChange = lastChangeResult.firstOrNull?.lastChange;
    final localLastChange = FFAppState().propriedadesChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('propriedades',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');
    if (shouldSync) {
      await SQLiteManager.instance.deletarTodasPropriedades();
      propriedade =
          await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
        pUserId: currentUserUid,
      );

      final propriedadesList = ((propriedade.jsonBody ?? '')
              .toList()
              .map<PropriedadesStruct?>(PropriedadesStruct.maybeFromMap)
              .toList() as Iterable<PropriedadesStruct?>)
          .withoutNulls;

      // Converter para lista de maps para batch insert
      final records = <Map<String, dynamic>>[];
      for (final prop in propriedadesList) {
        records.add({
          'userID': prop.userID,
          'anotacoes': prop.anotacoes,
          'areaAgricultura': prop.areaAgricultura,
          'areaBenfeitoria': prop.areaBenfeitoria,
          'areaPastagem': prop.areaPastagem,
          'areaReserva': prop.areaReserva,
          'areaTotal': prop.areaTotal,
          'cidade': prop.cidade,
          'estado': prop.estado,
          'icone': prop.icone,
          'idPropriedade': prop.idPropriedade,
          'atividades': prop.atividades,
          'nome': prop.nome,
          'updated_at': dateTimeFormat(
            "yyyy-MM-dd HH:mm:ss",
            functions.remover3hs(functions.converterTimestamp(prop.updatedAt)),
            locale: FFLocalizations.of(context).languageCode,
          ),
          'created_at': dateTimeFormat(
            "yyyy-MM-dd  HH:mm:ss",
            functions.remover3hs(functions.converterTimestamp(prop.createdAt)),
            locale: FFLocalizations.of(context).languageCode,
          ),
          'usersID': prop.usersID,
          'rebanhosID': prop.rebanhosID,
          'deletado': prop.deletado,
        });
      }

      await actions.batchInsertLocalPropriedades(records);

      FFAppState().propriedadesChangeDateTime =
          remoteLastChange ?? DateTime.now();
      FFAppState().propriedadesIndex = 0;
      _syncLog('propriedades', 'Sincronização de propriedades concluída.');
    } else {
      _syncLog('propriedades', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog(
        'propriedades', 'ERRO FATAL na sincronização de propriedades: $e\n$s');
  }
}

Future putUpdtPropriedades(BuildContext context) async {
  try {
    List<BuscaPropriedadesPUTRow>? localPropriedades;
    List<BuscaPropriedadesUPDATEDRow>? localPropriedadesUPT;

    if (FFAppState().dataDadosNaoSyncProp != null) {
      localPropriedades = await SQLiteManager.instance.buscaPropriedadesPUT(
        datePUT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncProp,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localPropriedades!.isNotEmpty) {
        while (FFAppState().propriedadesIndex < localPropriedades.length) {
          await PropriedadesTable().insert({
            'userID': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.userID,
            'anotacoes': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.anotacoes,
            'areaAgricultura': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.areaAgricultura,
            'areaBenfeitoria': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.areaBenfeitoria,
            'areaPastagem': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.areaPastagem,
            'areaReserva': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.areaReserva,
            'areaTotal': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.areaTotal,
            'cidade': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.cidade,
            'estado': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.estado,
            'icone': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.icone,
            'idPropriedade': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.idPropriedade,
            'nome': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.nome,
            'usersID': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.usersID,
            'rebanhosID': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.rebanhosID,
            'atividades': localPropriedades
                .elementAtOrNull(FFAppState().propriedadesIndex)
                ?.atividades,
          });
          FFAppState().propriedadesIndex = FFAppState().propriedadesIndex + 1;
        }
      }
      FFAppState().propriedadesIndex = 0;
      localPropriedadesUPT =
          await SQLiteManager.instance.buscaPropriedadesUPDATED(
        dateUPT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncProp,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localPropriedadesUPT!.isNotEmpty) {
        while (FFAppState().propriedadesIndex < localPropriedadesUPT.length) {
          await PropriedadesTable().update(
            data: {
              'anotacoes': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.anotacoes,
              'areaAgricultura': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaAgricultura,
              'areaBenfeitoria': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaBenfeitoria,
              'areaPastagem': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaPastagem,
              'areaReserva': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaReserva,
              'areaTotal': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.areaTotal,
              'cidade': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.cidade,
              'estado': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.estado,
              'icone': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.icone,
              'atividades': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.atividades,
              'nome': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.nome,
              'usersID': localPropriedadesUPT
                  .elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.usersID,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'idPropriedade',
              localPropriedadesUPT
                  ?.elementAtOrNull(FFAppState().propriedadesIndex)
                  ?.idPropriedade,
            ),
          );
          FFAppState().propriedadesIndex = FFAppState().propriedadesIndex + 1;
        }
      }
      FFAppState().propriedadesIndex = 0;
    }
  } catch (e, s) {
    _syncLog('putUpdtPropriedades', 'ERRO no upload de propriedades: $e\n$s');
  }
}

Future buscaPropriedade(
  BuildContext context, {
  String? idPropriedade,
}) async {
  List<BuscaPropriedadeRow>? actBuscaPropriedade;
  bool? temNet;
  List<UsersPropriedadesRow>? usersProp;

  actBuscaPropriedade = await SQLiteManager.instance.buscaPropriedade(
    idPropriedade: idPropriedade,
  );
  FFAppState().updatePropriedadeBuscadaStruct(
    (e) => e
      ..nome = actBuscaPropriedade?.firstOrNull?.nome
      ..idPropriedade = idPropriedade
      ..usersID = actBuscaPropriedade?.firstOrNull?.usersID
      ..anotacoes = actBuscaPropriedade?.firstOrNull?.anotacoes
      ..areaAgricultura = actBuscaPropriedade?.firstOrNull?.areaAgricultura
      ..areaBenfeitoria = actBuscaPropriedade?.firstOrNull?.areaBenfeitoria
      ..areaPastagem = actBuscaPropriedade?.firstOrNull?.areaPastagem
      ..areaReserva = actBuscaPropriedade?.firstOrNull?.areaReserva
      ..areaTotal = actBuscaPropriedade?.firstOrNull?.areaTotal
      ..cidade = actBuscaPropriedade?.firstOrNull?.cidade
      ..estado = actBuscaPropriedade?.firstOrNull?.estado
      ..icone = actBuscaPropriedade?.firstOrNull?.icone
      ..atividades = actBuscaPropriedade?.firstOrNull?.atividades
      ..userID = actBuscaPropriedade?.firstOrNull?.userID,
  );
  temNet = await actions.checkInternetConnection();
  if (temNet == true) {
    FFAppState().usersPropriedade = [];
    usersProp = await UsersPropriedadesTable().queryRows(
      queryFn: (q) => q
          .eqOrNull(
            'idPropriedade',
            idPropriedade,
          )
          .eqOrNull(
            'deletado',
            'NAO',
          ),
    );
    while (FFAppState().usersPropIndex < usersProp.length) {
      FFAppState().addToUsersPropriedade(UsersPropriedadeStruct(
        userId: usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.userId,
        nome: usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.nome,
        email: usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.email,
        foto: usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.foto,
        permissao:
            usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.permissao,
        idPropriedade: usersProp
            .elementAtOrNull(FFAppState().usersPropIndex)
            ?.idPropriedade,
        deletado:
            usersProp.elementAtOrNull(FFAppState().usersPropIndex)?.deletado,
      ));
      FFAppState().usersPropIndex = FFAppState().usersPropIndex + 1;
    }
    FFAppState().usersPropIndex = 0;
  }
}

Future animaisRegistrados(BuildContext context) async {
  List<QTDAnimaisTotalPropriedadeRow>? qtdAnimais;

  qtdAnimais = await SQLiteManager.instance.qTDAnimaisTotalPropriedade(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );
  FFAppState().animaisRegistrados = valueOrDefault<int>(
    qtdAnimais.length,
    0,
  );
}

Future animaisPropriedade(BuildContext context) async {
  List<QTDAnimaisPropriedadeRow>? animais;

  animais = await SQLiteManager.instance.qTDAnimaisPropriedade(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );
  FFAppState().qtdAnimaisPropriedade = valueOrDefault<int>(
    animais.length,
    0,
  );
}

Future putUpdtRebanhos(BuildContext context) async {
  try {
    List<BuscarRebanhoPUTRow>? localRebanhos;
    List<RebanhoRow>? animalExiste;
    List<BuscarRebanhoUPDATEDRow>? localRebanhosUPDT;
    List<BuscaHistPesagensPUTRow>? localHistPesPUT;
    List<BuscaHistPesagensUPDTRow>? localPesagensUPDT;

    if (FFAppState().dataDadosNaoSyncRebanho != null) {
      localRebanhos = await SQLiteManager.instance.buscarRebanhoPUT(
        data: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncRebanho,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localRebanhos!.isNotEmpty) {
        FFAppState().rebanhosIndex = 0;
        while (FFAppState().rebanhosIndex < localRebanhos.length) {
          animalExiste = await RebanhoTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'idRebanho',
              localRebanhos
                  ?.elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.idRebanho,
            ),
          );
          if (!((animalExiste).isNotEmpty)) {
            await RebanhoTable().insert({
              'idPropriedade': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.idPropriedade,
              'numeroAnimal': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.numeroAnimal,
              'chip': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.chip,
              'codRegistro': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.codRegistro,
              'nome': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.nome,
              'sexo': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.sexo,
              'categoria': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.categoria,
              'dataNascimento': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataNascimento)),
              'pesoNascimento': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.pesoNascimento,
              'porte': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.porte,
              'raca': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.raca,
              'loteID': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.loteID,
              'dataEntradaLote': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataEntradaLote)),
              'rebanhoIdMatriz': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.rebanhoIdMatriz,
              'rebanhoIdReprodutor': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.rebanhoIdReprodutor,
              'dataDesmama': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataDesmama)),
              'pesoDesmama': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.pesoDesmama,
              'pesoAtual': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.pesoAtual,
              'status': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.statusRebanho,
              'origem': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.origem,
              'anotacoes': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.anotacoes,
              'idRebanho': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.idRebanho,
              'deletado': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.deletado,
              'loteNome': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.loteNome,
              'tipo': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.tipo,
              'dataAcao': supaSerialize<DateTime>(functions.converterParaData(
                  localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataAcao)),
              'valorCompra': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.valorCompra,
              'dataUltimaPesagem': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataUltimaPesagem)),
              'nomeConcat': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.nomeConcat,
              'dataVenda': supaSerialize<DateTime>(functions.converterParaData(
                  localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataVenda)),
              'valorVenda': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.valorVenda,
              'numeroMatriz': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.numeroMatriz,
              'nomeMatriz': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.nomeMatriz,
              'dataNascMatriz': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataNascMatriz)),
              'racaMatriz': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.racaMatriz,
              'numeroReprodutor': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.numeroReprodutor,
              'nomeReprodutor': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.nomeReprodutor,
              'dataNascReprodutor': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataNascReprodutor)),
              'racaReprodutor': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.racaReprodutor,
              'movimentacao_entrada': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.movimentacaoEntrada)),
              'movimentacao_saida': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.movimentacaoSaida)),
              'data_morte': supaSerialize<DateTime>(functions.converterParaData(
                  localRebanhos
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataMorte)),
              'motivo_morte': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.motivoMorte,
              'categoria_matriz': localRebanhos
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.categoriaMatriz,
            });
          }
          FFAppState().rebanhosIndex = FFAppState().rebanhosIndex + 1;
        }
      }
      FFAppState().rebanhosIndex = 0;
      localRebanhosUPDT = await SQLiteManager.instance.buscarRebanhoUPDATED(
        data: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncRebanho,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localRebanhosUPDT!.isNotEmpty) {
        while (FFAppState().rebanhosIndex < localRebanhosUPDT.length) {
          await RebanhoTable().update(
            data: {
              'numeroAnimal': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.numeroAnimal,
              'chip': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.chip,
              'codRegistro': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.codRegistro,
              'nome': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.nome,
              'sexo': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.sexo,
              'categoria': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.categoria,
              'dataNascimento': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataNascimento)),
              'pesoNascimento': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.pesoNascimento,
              'porte': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.porte,
              'raca': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.raca,
              'loteID': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.loteID,
              'dataEntradaLote': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataEntradaLote)),
              'rebanhoIdMatriz': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.rebanhoIdMatriz,
              'rebanhoIdReprodutor': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.rebanhoIdReprodutor,
              'dataDesmama': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataDesmama)),
              'pesoDesmama': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.pesoDesmama,
              'pesoAtual': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.pesoAtual,
              'status': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.statusRebanho,
              'origem': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.origem,
              'anotacoes': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.anotacoes,
              'deletado': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.deletado,
              'loteNome': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.loteNome,
              'tipo': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.tipo,
              'dataAcao': supaSerialize<DateTime>(functions.converterParaData(
                  localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataAcao)),
              'valorCompra': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.valorCompra,
              'dataUltimaPesagem': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataUltimaPesagem)),
              'nomeConcat': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.nomeConcat,
              'dataVenda': supaSerialize<DateTime>(functions.converterParaData(
                  localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataVenda)),
              'valorVenda': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.valorVenda,
              'numeroMatriz': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.numeroMatriz,
              'nomeMatriz': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.nomeMatriz,
              'dataNascMatriz': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataNascMatriz)),
              'racaMatriz': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.racaMatriz,
              'numeroReprodutor': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.numeroReprodutor,
              'nomeReprodutor': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.nomeReprodutor,
              'dataNascReprodutor': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataNascReprodutor)),
              'racaReprodutor': localRebanhosUPDT
                  .elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.racaReprodutor,
              'movimentacao_entrada': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.movimentacaoEntrada)),
              'movimentacao_saida': supaSerialize<DateTime>(
                  functions.converterParaData(localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.movimentacaoSaida)),
              'data_morte': supaSerialize<DateTime>(functions.converterParaData(
                  localRebanhosUPDT
                      .elementAtOrNull(FFAppState().rebanhosIndex)
                      ?.dataMorte)),
            },
            matchingRows: (rows) => rows.eqOrNull(
              'idRebanho',
              localRebanhosUPDT
                  ?.elementAtOrNull(FFAppState().rebanhosIndex)
                  ?.idRebanho,
            ),
          );
          FFAppState().rebanhosIndex = FFAppState().rebanhosIndex + 1;
        }
      }
      FFAppState().rebanhosIndex = 0;
      localHistPesPUT = await SQLiteManager.instance.buscaHistPesagensPUT(
        data: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncRebanho,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      FFAppState().pesagensIndex = 0;
      if (localHistPesPUT!.isNotEmpty) {
        while (FFAppState().pesagensIndex < localHistPesPUT.length) {
          await HistoricoPesagensTable().insert({
            'idRebanho': localHistPesPUT
                .elementAtOrNull(FFAppState().pesagensIndex)
                ?.idRebanho,
            'dataPesagem': supaSerialize<DateTime>(functions.converterParaData(
                localHistPesPUT
                    .elementAtOrNull(FFAppState().pesagensIndex)
                    ?.dataPesagem)),
            'tipo': localHistPesPUT
                .elementAtOrNull(FFAppState().pesagensIndex)
                ?.tipo,
            'peso': localHistPesPUT
                .elementAtOrNull(FFAppState().pesagensIndex)
                ?.peso,
            'deletado': localHistPesPUT
                .elementAtOrNull(FFAppState().pesagensIndex)
                ?.deletado,
          });
          FFAppState().pesagensIndex = FFAppState().pesagensIndex + 1;
        }
      }
      FFAppState().pesagensIndex = 0;
      localPesagensUPDT = await SQLiteManager.instance.buscaHistPesagensUPDT();
      if (localPesagensUPDT!.isNotEmpty) {
        while (FFAppState().pesagensIndex < localPesagensUPDT.length) {
          await HistoricoPesagensTable().update(
            data: {
              'deletado': localPesagensUPDT
                  .elementAtOrNull(FFAppState().pesagensIndex)
                  ?.deletado,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'id',
              localPesagensUPDT
                  ?.elementAtOrNull(FFAppState().pesagensIndex)
                  ?.id,
            ),
          );
          FFAppState().pesagensIndex = FFAppState().pesagensIndex + 1;
        }
      }
      FFAppState().pesagensIndex = 0;
    }
  } catch (e, s) {
    _syncLog('putUpdtRebanhos', 'ERRO no upload de rebanhos: $e\n$s');
  }
}

Future countLotesAtivoInativo(BuildContext context) async {
  List<LotesAtivoRow>? qtdAtivos;
  List<LotesInativosRow>? qtdInativos;
  List<AnimaisNoLoteRow>? qtdAnimaisLote;

  await Future.wait([
    Future(() async {
      qtdAtivos = await SQLiteManager.instance.lotesAtivo(
        idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
      );
      FFAppState().qtdLotesAtivos = valueOrDefault<int>(
        qtdAtivos?.length,
        0,
      );
    }),
    Future(() async {
      qtdInativos = await SQLiteManager.instance.lotesInativos(
        idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
      );
      FFAppState().qtdLotesInativos = valueOrDefault<int>(
        qtdInativos?.length,
        0,
      );
    }),
    Future(() async {
      qtdAnimaisLote = await SQLiteManager.instance.animaisNoLote(
        idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
      );
      FFAppState().qtdAnimaisLote = valueOrDefault<int>(
        qtdAnimaisLote?.length,
        0,
      );
    }),
  ]);
}

Future buscaRebanhosLote(
  BuildContext context, {
  String? idLote,
}) async {
  List<BuscarRebanhoLoteRow>? rebanhosLote;

  FFAppState().rebanhosLote = [];
  rebanhosLote = await SQLiteManager.instance.buscarRebanhoLote(
    idLote: idLote,
  );
  FFAppState().rebanhosIndex = 0;
  while (FFAppState().rebanhosIndex < rebanhosLote.length) {
    FFAppState().addToRebanhosLote(RebanhoStruct(
      idPropriedade: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.idPropriedade,
      numeroAnimal: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.numeroAnimal,
      chip: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.chip,
      codRegistro:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.codRegistro,
      nome: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.nome,
      sexo: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.sexo,
      categoria:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.categoria,
      dataNascimento: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.dataNascimento,
      pesoNascimento: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.pesoNascimento,
      porte: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.porte,
      raca: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.raca,
      loteId: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.loteID,
      dataEntradaLote: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.dataEntradaLote,
      rebanhoIdMatriz: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.rebanhoIdMatriz,
      rebanhoIdReprodutor: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.rebanhoIdReprodutor,
      dataDesmama:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.dataDesmama,
      pesoDesmama:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.pesoDesmama,
      pesoAtual:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.pesoAtual,
      status: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.statusRebanho,
      origem: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.origem,
      anotacoes:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.anotacoes,
      idRebanho:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.idRebanho,
      tipo: rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.tipo,
      dataAcao:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.dataAcao,
      valorCompra:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.valorCompra,
      dataUltimaPesagem: rebanhosLote
          .elementAtOrNull(FFAppState().rebanhosIndex)
          ?.dataUltimaPesagem,
      nomeConcat:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.nomeConcat,
      loteNome:
          rebanhosLote.elementAtOrNull(FFAppState().rebanhosIndex)?.loteNome,
    ));
    FFAppState().rebanhosIndex = FFAppState().rebanhosIndex + 1;
  }
}

Future refreshLotes(BuildContext context) async {
  try {
    List<LotesChangeTrackerRow>? lastChangeResult;
    ApiCallResponse? propriedades;
    List<LotesRow>? lotes;

    try {
      lastChangeResult = await LotesChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e) {
      _syncLog('lotes', 'ERRO ao consultar change tracker: $e');
      lastChangeResult = [];
    }
    final remoteLastChange = lastChangeResult.firstOrNull?.lastChange;
    final localLastChange = FFAppState().lotesChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('lotes',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');
    if (shouldSync) {
      await SQLiteManager.instance.deleteAllLotes();
      propriedades =
          await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
        pUserId: currentUserUid,
      );

      lotes = await LotesTable().queryRows(
        queryFn: (q) => q
            .inFilterOrNull(
              'id_propriedade',
              ((propriedades?.jsonBody ?? '')
                      .toList()
                      .map<PropriedadesStruct?>(PropriedadesStruct.maybeFromMap)
                      .toList() as Iterable<PropriedadesStruct?>)
                  .withoutNulls
                  .map((e) => e.idPropriedade)
                  .toList(),
            )
            .eqOrNull(
              'deletado',
              'NAO',
            ),
      );

      // Converter para lista de maps para batch insert
      final records = <Map<String, dynamic>>[];
      for (final lote in lotes) {
        records.add({
          'id_propriedade': lote.idPropriedade,
          'id_animais': lote.idAnimais,
          'nome': lote.nome,
          'anotacoes': lote.anotacoes,
          'ativo': lote.ativo,
          'motivo': lote.motivo,
          'data_motivo': lote.dataMotivo?.toString(),
          'id_lote': lote.idLote,
          'deletado': lote.deletado,
          'created_at': dateTimeFormat(
            "yyyy-MM-dd HH:mm:ss",
            functions.remover3hs(lote.createdAt),
            locale: FFLocalizations.of(context).languageCode,
          ),
          'updated_at': lote.updatedAt?.toString(),
          'valorVenda': lote.valorVenda,
        });
      }

      await actions.batchInsertLocalLotes(records);

      FFAppState().lotesChangeDateTime = remoteLastChange ?? DateTime.now();
      FFAppState().lotesIndex = 0;
      _syncLog('lotes', 'Sincronização de lotes concluída.');
    } else {
      _syncLog('lotes', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('lotes', 'ERRO FATAL na sincronização de lotes: $e\n$s');
  }
}

Future putUpdtLotes(BuildContext context) async {
  try {
    List<BuscarLotePUTRow>? localLotes;
    List<BuscarLoteUPDTRow>? localLotesUPT;

    if (FFAppState().dataDadosNaoSyncLotes != null) {
      localLotes = await SQLiteManager.instance.buscarLotePUT(
        datePUT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncLotes,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      FFAppState().lotesIndex = 0;
      if (localLotes!.isNotEmpty) {
        while (FFAppState().lotesIndex < localLotes.length) {
          await LotesTable().insert({
            'id_propriedade': localLotes
                .elementAtOrNull(FFAppState().lotesIndex)
                ?.idPropriedade,
            'id_animais':
                localLotes.elementAtOrNull(FFAppState().lotesIndex)?.idAnimais,
            'nome': localLotes.elementAtOrNull(FFAppState().lotesIndex)?.nome,
            'anotacoes':
                localLotes.elementAtOrNull(FFAppState().lotesIndex)?.anotacoes,
            'ativo': localLotes.elementAtOrNull(FFAppState().lotesIndex)?.ativo,
            'motivo':
                localLotes.elementAtOrNull(FFAppState().lotesIndex)?.motivo,
            'data_motivo': supaSerialize<DateTime>(functions.converterParaData(
                localLotes
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.dataMotivo)),
            'id_lote':
                localLotes.elementAtOrNull(FFAppState().lotesIndex)?.idLote,
            'deletado':
                localLotes.elementAtOrNull(FFAppState().lotesIndex)?.deletado,
            'data_entrada_piquete': supaSerialize<DateTime>(
                functions.converterParaData(localLotes
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.dataEntradaPiquete)),
            'data_saida_piquete': supaSerialize<DateTime>(
                functions.converterParaData(localLotes
                    .elementAtOrNull(FFAppState().lotesIndex)
                    ?.dataSaidaPiquete)),
            'valorVenda':
                localLotes.elementAtOrNull(FFAppState().lotesIndex)?.valorVenda,
          });
          FFAppState().lotesIndex = FFAppState().lotesIndex + 1;
        }
      }
      FFAppState().lotesIndex = 0;
      localLotesUPT = await SQLiteManager.instance.buscarLoteUPDT(
        dateUPDT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncLotes,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localLotesUPT!.isNotEmpty) {
        while (FFAppState().lotesIndex < localLotesUPT.length) {
          await LotesTable().update(
            data: {
              'id_propriedade': localLotesUPT
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.idPropriedade,
              'id_animais': localLotesUPT
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.idAnimais,
              'nome':
                  localLotesUPT.elementAtOrNull(FFAppState().lotesIndex)?.nome,
              'anotacoes': localLotesUPT
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.anotacoes,
              'ativo':
                  localLotesUPT.elementAtOrNull(FFAppState().lotesIndex)?.ativo,
              'motivo': localLotesUPT
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.motivo,
              'data_motivo': supaSerialize<DateTime>(
                  functions.converterParaData(localLotesUPT
                      .elementAtOrNull(FFAppState().lotesIndex)
                      ?.dataMotivo)),
              'id_lote': localLotesUPT
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.idLote,
              'deletado': localLotesUPT
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.deletado,
              'updated_at': supaSerialize<DateTime>(functions.converterParaData(
                  localLotesUPT
                      .elementAtOrNull(FFAppState().lotesIndex)
                      ?.updatedAt)),
              'data_entrada_piquete': supaSerialize<DateTime>(
                  functions.converterParaData(localLotesUPT
                      .elementAtOrNull(FFAppState().lotesIndex)
                      ?.dataEntradaPiquete)),
              'data_saida_piquete': supaSerialize<DateTime>(
                  functions.converterParaData(localLotesUPT
                      .elementAtOrNull(FFAppState().lotesIndex)
                      ?.dataSaidaPiquete)),
              'valorVenda': localLotesUPT
                  .elementAtOrNull(FFAppState().lotesIndex)
                  ?.valorVenda,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'id_lote',
              localLotesUPT?.elementAtOrNull(FFAppState().lotesIndex)?.idLote,
            ),
          );
          FFAppState().lotesIndex = FFAppState().lotesIndex + 1;
        }
      }
      FFAppState().lotesIndex = 0;
    }
  } catch (e, s) {
    _syncLog('putUpdtLotes', 'ERRO no upload de lotes: $e\n$s');
  }
}

Future countLotesCadastrados(BuildContext context) async {
  List<CountLotesCadastradosRow>? qtdLotes;

  qtdLotes = await SQLiteManager.instance.countLotesCadastrados(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );
  FFAppState().lotesCadastrados = valueOrDefault<int>(
    qtdLotes.length,
    0,
  );
}

Future qTDReproducoes(BuildContext context) async {
  final results = await Future.wait([
    SQLiteManager.instance.qTDReproducoes(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    ),
    SQLiteManager.instance.qTDInseminacao(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    ),
    SQLiteManager.instance.qTDMontaNatural(
      idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
    ),
  ]);
  FFAppState().countReproducoes = valueOrDefault<int>(
    results[0].length,
    0,
  );
  FFAppState().countInseminacoes = valueOrDefault<int>(
    results[1].length,
    0,
  );
  FFAppState().countMontaNatural = valueOrDefault<int>(
    results[2].length,
    0,
  );
}

Future putUpdtReproducao(BuildContext context) async {
  try {
    List<BuscarReproducaoPUTRow>? localReproducao;
    List<BuscarReproducaoUPDTRow>? localReproducaoUPDT;

    if (FFAppState().dataDadosNaoSyncRepro != null) {
      localReproducao = await SQLiteManager.instance.buscarReproducaoPUT(
        datePUT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncRepro,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      FFAppState().reproducaoIndex = 0;
      if (localReproducao!.isNotEmpty) {
        while (FFAppState().reproducaoIndex < localReproducao.length) {
          await ReproducaoTable().insert({
            'id_propriedade': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.idPropriedade,
            'tipo_reproducao': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.tipoReproducao,
            'score_corporal': valueOrDefault<double>(
              localReproducao
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.scoreCorporal,
              0.5,
            ),
            'data_inseminacao': supaSerialize<DateTime>(
                functions.converterParaData(localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.dataInseminacao)),
            'data_partida_semen': supaSerialize<DateTime>(localReproducao
                            .elementAtOrNull(FFAppState().reproducaoIndex)
                            ?.dataPartidaSemen !=
                        null &&
                    localReproducao
                            .elementAtOrNull(FFAppState().reproducaoIndex)
                            ?.dataPartidaSemen !=
                        ''
                ? functions.converterParaData(localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.dataPartidaSemen)
                : FFAppState().dateDefault),
            'partida_semen': valueOrDefault<int>(
              localReproducao
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.partidaSemen,
              1,
            ),
            'previsao_parto': supaSerialize<DateTime>(
                functions.converterParaData(localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.previsaoParto)),
            'id_lote': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.idLote,
            'data_inicial': supaSerialize<DateTime>(functions.converterParaData(
                localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.dataInicial)),
            'data_final': supaSerialize<DateTime>(functions.converterParaData(
                localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.dataFinal)),
            'status_reproducao': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.statusReproducao,
            'inseminador': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.inseminador,
            'anotacoes': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.anotacoes,
            'deletado': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.deletado,
            'updated_at': supaSerialize<DateTime>(functions.converterParaData(
                localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.updatedAt)),
            'categoria': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.categoria,
            'numMatriz': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.numMatriz,
            'nomeMatriz': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.nomeMatriz,
            'nascimentoMatriz': supaSerialize<DateTime>(
                functions.converterParaData(localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.nascimentoMatriz)),
            'numReprodutor': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.numReprodutor,
            'nomeReprodutor': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.nomeReprodutor,
            'nascimentoReprodutor': supaSerialize<DateTime>(
                functions.converterParaData(localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.nascimentoReprodutor)),
            'loteNome': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.loteNome,
            'data_status': supaSerialize<DateTime>(functions.converterParaData(
                localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.dataStatus)),
            'chipReprodutor': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.chipReprodutor,
            'chipMatriz': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.chipMatriz,
            'racaMatriz': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.racaMatriz,
            'racaReprodutor': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.racaReprodutor,
            'ressinc': valueOrDefault<String>(
              localReproducao
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.ressinc,
              'NAO',
            ),
            'parida': valueOrDefault<String>(
              localReproducao
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.parida,
              'NAO',
            ),
            'data_parto': supaSerialize<DateTime>(functions.converterParaData(
                localReproducao
                    .elementAtOrNull(FFAppState().reproducaoIndex)
                    ?.dataParto)),
            'gnrh': valueOrDefault<String>(
              localReproducao
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.gnrh,
              'Não',
            ),
            'cio': valueOrDefault<String>(
              localReproducao
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.cio,
              'Não',
            ),
            'id_rebanho_matriz': valueOrDefault<String>(
              localReproducao
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.idRebanhoMatriz,
              'Não',
            ),
            'id_rebanho_reprodutor': valueOrDefault<String>(
              localReproducao
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.idRebanhoReprodutor,
              'Não',
            ),
            'id_reproducao': localReproducao
                .elementAtOrNull(FFAppState().reproducaoIndex)
                ?.idReproducao,
          });
          FFAppState().reproducaoIndex = FFAppState().reproducaoIndex + 1;
        }
      }
      FFAppState().reproducaoIndex = 0;
      localReproducaoUPDT = await SQLiteManager.instance.buscarReproducaoUPDT(
        datePUT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncRepro,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localReproducaoUPDT!.isNotEmpty) {
        while (FFAppState().reproducaoIndex < localReproducaoUPDT.length) {
          await ReproducaoTable().update(
            data: {
              'tipo_reproducao': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.tipoReproducao,
              'id_rebanho_matriz': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.idRebanhoMatriz,
              'score_corporal': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.scoreCorporal,
              'id_rebanho_reprodutor': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.idRebanhoReprodutor,
              'data_inseminacao': supaSerialize<DateTime>(
                  functions.converterParaData(localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.dataInseminacao)),
              'data_partida_semen': supaSerialize<DateTime>(
                  functions.converterParaData(localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.dataPartidaSemen)),
              'partida_semen': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.partidaSemen,
              'previsao_parto': supaSerialize<DateTime>(
                  functions.converterParaData(localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.previsaoParto)),
              'id_lote': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.idLote,
              'data_inicial': supaSerialize<DateTime>(
                  functions.converterParaData(localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.dataInicial)),
              'data_final': supaSerialize<DateTime>(functions.converterParaData(
                  localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.dataFinal)),
              'inseminador': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.inseminador,
              'anotacoes': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.anotacoes,
              'deletado': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.deletado,
              'updated_at': supaSerialize<DateTime>(functions.converterParaData(
                  localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.updatedAt)),
              'categoria': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.categoria,
              'numMatriz': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.numMatriz,
              'nomeMatriz': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.nomeMatriz,
              'nascimentoMatriz': supaSerialize<DateTime>(
                  functions.converterParaData(localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.nascimentoMatriz)),
              'status_reproducao': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.statusReproducao,
              'numReprodutor': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.numReprodutor,
              'nomeReprodutor': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.nomeReprodutor,
              'nascimentoReprodutor': supaSerialize<DateTime>(
                  functions.converterParaData(localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.nascimentoReprodutor)),
              'loteNome': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.loteNome,
              'data_status': supaSerialize<DateTime>(
                  functions.converterParaData(localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.dataStatus)),
              'ressinc': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.ressinc,
              'chipReprodutor': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.chipReprodutor,
              'chipMatriz': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.chipMatriz,
              'parida': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.parida,
              'data_parto': supaSerialize<DateTime>(functions.converterParaData(
                  localReproducaoUPDT
                      .elementAtOrNull(FFAppState().reproducaoIndex)
                      ?.dataParto)),
              'gnrh': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.gnrh,
              'cio': localReproducaoUPDT
                  .elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.cio,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'id_reproducao',
              localReproducaoUPDT
                  ?.elementAtOrNull(FFAppState().reproducaoIndex)
                  ?.idReproducao,
            ),
          );
          FFAppState().reproducaoIndex = FFAppState().reproducaoIndex + 1;
        }
      }
      FFAppState().reproducaoIndex = 0;
    }
  } catch (e, s) {
    _syncLog('putUpdtReproducao', 'ERRO no upload de reprodução: $e\n$s');
  }
}

Future countSanidades(BuildContext context) async {
  List<ListarSanidadesRow>? listaSanidades;

  FFAppState().qtdVacinas = 0;
  FFAppState().qtdAntiparasitarios = 0;
  FFAppState().qtdTratamento = 0;
  FFAppState().qtdProtocoloReprodutivo = 0;

  listaSanidades = await SQLiteManager.instance.listarSanidades(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );

  final validRecords = listaSanidades
      .where((e) => e.idRebanho != null && e.idRebanho != '')
      .toList();

  for (final record in validRecords) {
    if (record.vacinacao != null && record.vacinacao != 'null') {
      FFAppState().qtdVacinas += valueOrDefault<int>(
        functions.converterJSONparaLista(record.vacinacao!).length,
        0,
      );
    }
    if (record.antiparasitario != null && record.antiparasitario != 'null') {
      FFAppState().qtdAntiparasitarios += valueOrDefault<int>(
        functions.converterJSONparaLista(record.antiparasitario!).length,
        0,
      );
    }
    if (record.tratamento != null && record.tratamento != 'null') {
      FFAppState().qtdTratamento += valueOrDefault<int>(
        functions.converterJSONparaLista(record.tratamento!).length,
        0,
      );
    }
    if (record.protocoloReprodutivo != null &&
        record.protocoloReprodutivo != 'null' &&
        record.protocoloReprodutivo != '') {
      FFAppState().qtdProtocoloReprodutivo += 1;
    }
  }
}

Future putUpdtSanidades(BuildContext context) async {
  try {
    List<BuscarSanidadePUTRow>? localSanidade;
    List<BuscarSanidadeUPDTRow>? localSanidadeUPDT;

    if (FFAppState().dataDadosNaoSyncSanidade != null) {
      localSanidade = await SQLiteManager.instance.buscarSanidadePUT(
        datePUT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncSanidade,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localSanidade!.isNotEmpty) {
        while (FFAppState().sanidadeIndex < localSanidade.length) {
          await SanidadeTable().insert({
            'id_propriedade': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.idPropriedade,
            'deletado': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.deletado,
            'updated_at': supaSerialize<DateTime>(functions.converterParaData(
                localSanidade
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.updatedAt)),
            'created_at': supaSerialize<DateTime>(functions.converterParaData(
                localSanidade
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.createdAt)),
            'id_rebanho': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.idRebanho,
            'data_sanidade': supaSerialize<DateTime>(
                functions.converterParaData(localSanidade
                    .elementAtOrNull(FFAppState().sanidadeIndex)
                    ?.dataSanidade)),
            'id_lote': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.idLote,
            'porcentagem_lote': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.porcentagemLote,
            'id_sanidade': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.idSanidade,
            'vacinacao': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.vacinacao,
            'vacinacao_outros': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.vacinacaoOutros,
            'vacinacao_obs': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.vacinacaoObs,
            'antiparasitario': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.antiparasitario,
            'antiparasitario_outros': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.antiparasitarioOutros,
            'antiparasitario_obs': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.antiparasitarioObs,
            'tratamento': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.tratamento,
            'tratamento_outros': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.tratamentoOutros,
            'tratamento_obs': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.tratamentoObs,
            'protocolo_reprodutivo': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.protocoloReprodutivo,
            'protocolo_reprodutivo_outros': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.protocoloReprodutivoOutros,
            'protocolo_reprodutivo_obs': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.protocoloReprodutivoObs,
            'protocolo_d0': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.protocoloD0,
            'protocolo_retirada': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.protocoloRetirada,
            'protocolo_iatf': localSanidade
                .elementAtOrNull(FFAppState().sanidadeIndex)
                ?.protocoloIatf,
          });
          FFAppState().sanidadeIndex = FFAppState().sanidadeIndex + 1;
        }
      }
      FFAppState().sanidadeIndex = 0;
      localSanidadeUPDT = await SQLiteManager.instance.buscarSanidadeUPDT(
        dateUPDT: dateTimeFormat(
          "yyyy-MM-dd HH:mm:ss",
          FFAppState().dataDadosNaoSyncSanidade,
          locale: FFLocalizations.of(context).languageCode,
        ),
      );
      if (localSanidadeUPDT!.isNotEmpty) {
        while (FFAppState().sanidadeIndex < localSanidadeUPDT.length) {
          await SanidadeTable().update(
            data: {
              'data_sanidade': supaSerialize<DateTime>(
                  functions.converterParaData(localSanidadeUPDT
                      .elementAtOrNull(FFAppState().sanidadeIndex)
                      ?.dataSanidade)),
              'porcentagem_lote': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.porcentagemLote,
              'updated_at': supaSerialize<DateTime>(functions.converterParaData(
                  localSanidadeUPDT
                      .elementAtOrNull(FFAppState().sanidadeIndex)
                      ?.updatedAt)),
              'deletado': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.deletado,
              'vacinacao': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.vacinacao,
              'vacinacao_outros': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.vacinacaoOutros,
              'vacinacao_obs': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.vacinacaoObs,
              'antiparasitario': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.antiparasitario,
              'antiparasitario_outros': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.antiparasitarioOutros,
              'antiparasitario_obs': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.antiparasitarioObs,
              'tratamento': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.tratamento,
              'tratamento_outros': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.tratamentoOutros,
              'tratamento_obs': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.tratamentoObs,
              'protocolo_reprodutivo': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloReprodutivo,
              'protocolo_reprodutivo_outros': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloReprodutivoOutros,
              'protocolo_reprodutivo_obs': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloReprodutivoObs,
              'protocolo_d0': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloD0,
              'protocolo_retirada': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloRetirada,
              'protocolo_iatf': localSanidadeUPDT
                  .elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.protocoloIatf,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'id_sanidade',
              localSanidadeUPDT
                  ?.elementAtOrNull(FFAppState().sanidadeIndex)
                  ?.idSanidade,
            ),
          );
          FFAppState().sanidadeIndex = FFAppState().sanidadeIndex + 1;
        }
      }
      FFAppState().sanidadeIndex = 0;
    }
  } catch (e, s) {
    _syncLog('putUpdtSanidades', 'ERRO no upload de sanidades: $e\n$s');
  }
}

Future qTDSanidades(BuildContext context) async {
  List<QTDSanidadesRow>? qtdSanidades;

  qtdSanidades = await SQLiteManager.instance.qTDSanidades(
    idPropriedade: FFAppState().propriedadeSelecionada.idPropriedade,
  );
  FFAppState().qtdSanidades = valueOrDefault<int>(
    qtdSanidades.length,
    0,
  );
}

Future refreshRebanhoOtimizada(BuildContext context) async {
  try {
    _syncLog('rebanho', 'Iniciando verificação do change tracker...');
    List<RebanhoChangeTrackerRow>? lastChangeResultt;
    ApiCallResponse? propriedadessO;
    ApiCallResponse? qtdRebanhosO;
    ApiCallResponse? rebanhosAPIO;

    try {
      lastChangeResultt = await RebanhoChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e, s) {
      _syncLog('rebanho', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResultt = [];
    }
    final remoteLastChange = lastChangeResultt.firstOrNull?.lastChange;
    final localLastChange = FFAppState().rebanhosChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('rebanho',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    if (shouldSync) {
      _syncLog('rebanho', 'Iniciando sincronização otimizada.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      FFAppState().indexRebPaginacao = 0;
      FFAppState().visibleProgressBar = true;
      FFAppState().update(() {});

      try {
        propriedadessO =
            await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
          pUserId: currentUserUid,
        );

        final propertyIds = _safePropertyIds(propriedadessO.jsonBody);
        _syncLog('rebanho',
            'Propriedades encontradas: ${propertyIds.length}. IDs: $propertyIds');

        if (propertyIds.isEmpty) {
          _syncLog(
              'rebanho', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        qtdRebanhosO = await SupabaseFunctionsGroup.qTDRebanhosCall.call(
          pIdsPropriedadesList: propertyIds,
        );
        _syncLog(
            'rebanho', 'Resposta qtdRebanhos raw: ${qtdRebanhosO.jsonBody}');

        final totalRebanhos = _safeTotalFromApi(qtdRebanhosO.jsonBody);
        FFAppState().totalRebanhos = totalRebanhos;
        _syncLog('rebanho', 'Total remoto informado: $totalRebanhos.');

        await SQLiteManager.instance.deletarTodosRebanhos();
        _syncLog('rebanho', 'Tabela local limpa. Iniciando paginação...');
        while (FFAppState().indexRebPaginacao < totalRebanhos) {
          final offsetAtual = FFAppState().indexRebPaginacao;
          try {
            rebanhosAPIO = await SupabaseFunctionsGroup.buscarRebanhosCall.call(
              pIdPropriedadeList: propertyIds,
              pLimite: 999,
              pOffset: offsetAtual,
            );

            final pageRecords = _safeRecordsFromApi(rebanhosAPIO.jsonBody);
            _syncLog('rebanho',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('rebanho',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              break;
            }

            final result = await actions.batchInsertLocalRebanho(pageRecords);
            final pageErrors =
                result['errors'] as List<Map<String, String>>? ?? [];
            if (pageErrors.isNotEmpty) {
              _syncLog('rebanho',
                  '${pageErrors.length} erro(s) ao inserir. offset=$offsetAtual.');
              syncErrors.addAll(pageErrors);
            }
            totalInserted += (result['inserted'] as int? ?? 0);
            _syncLog('rebanho',
                '${result['inserted']} registros inseridos nesta página.');

            FFAppState().indexRebPaginacao =
                FFAppState().indexRebPaginacao + pageRecords.length;
            if (pageRecords.length < 999) {
              _syncLog('rebanho',
                  'Última página detectada (tamanho < 999). Encerrando paginação.');
              break;
            }
          } catch (e, s) {
            _syncLog('rebanho',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            FFAppState().indexRebPaginacao =
                FFAppState().indexRebPaginacao + 999;
          }
        }

        try {
          await Future.wait([
            action_blocks.animaisRegistrados(context),
            action_blocks.animaisPropriedade(context),
          ]);
        } catch (e) {
          _syncLog('rebanho', 'Erro ao atualizar contadores: $e');
        }

        FFAppState().rebanhosIndex = 0;
        if (syncErrors.isNotEmpty) {
          syncOk = false;
          _syncLog(
              'rebanho', 'Total de erros acumulados: ${syncErrors.length}.');
        }
        if (totalInserted > 0 || syncErrors.isEmpty) {
          FFAppState().rebanhosChangeDateTime =
              remoteLastChange ?? DateTime.now();
        }
        if (syncOk) {
          _syncLog('rebanho',
              'Sincronização finalizada com sucesso. $totalInserted registros inseridos.');
        } else {
          _syncLog('rebanho',
              'Sincronização finalizada com erros. ${syncErrors.length} registro(s) falharam.');
        }
        await _showSyncErrorsDialog(context, 'Rebanho', syncErrors);
      } catch (e, s) {
        _syncLog('rebanho', 'ERRO FATAL na sincronização: $e\n$s');
      } finally {
        FFAppState().indexRebPaginacao = 0;
        FFAppState().visibleProgressBar = false;
        FFAppState().update(() {});
      }
    } else {
      _syncLog('rebanho', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('rebanho', 'EXCEÇÃO NÃO TRATADA: $e\n$s');
  }
}

Future refreshReproducaoOtimizada(BuildContext context) async {
  try {
    _syncLog('reproducao', 'Iniciando verificação do change tracker...');
    List<ReproducaoChangeTrackerRow>? lastChangeResultO;
    ApiCallResponse? propriedades;
    ApiCallResponse? qtdReproducoes;
    ApiCallResponse? reproducaoAPI;

    try {
      lastChangeResultO = await ReproducaoChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e, s) {
      _syncLog('reproducao', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResultO = [];
    }
    final remoteLastChange = lastChangeResultO.firstOrNull?.lastChange;
    final localLastChange = FFAppState().reproducaoChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('reproducao',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    if (shouldSync) {
      _syncLog('reproducao', 'Iniciando sincronização otimizada.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      FFAppState().indexReproPaginacao = 0;
      FFAppState().visibilidadeProgressBarRepro = true;
      FFAppState().update(() {});

      try {
        propriedades =
            await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
          pUserId: currentUserUid,
        );

        final propertyIds = _safePropertyIds(propriedades.jsonBody);
        _syncLog('reproducao',
            'Propriedades encontradas: ${propertyIds.length}. IDs: $propertyIds');

        if (propertyIds.isEmpty) {
          _syncLog(
              'reproducao', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        qtdReproducoes = await SupabaseFunctionsGroup.qTDReproducoesCall.call(
          pIdsPropriedadesList: propertyIds,
        );
        _syncLog('reproducao',
            'Resposta qtdReproducoes raw: ${qtdReproducoes.jsonBody}');

        final totalReproducoes = _safeTotalFromApi(qtdReproducoes.jsonBody);
        FFAppState().totalReproducoes = totalReproducoes;
        _syncLog('reproducao', 'Total remoto informado: $totalReproducoes.');

        await SQLiteManager.instance.deleteAllReproducao();
        _syncLog('reproducao', 'Tabela local limpa. Iniciando paginação...');
        while (FFAppState().indexReproPaginacao < totalReproducoes) {
          final offsetAtual = FFAppState().indexReproPaginacao;
          try {
            reproducaoAPI =
                await SupabaseFunctionsGroup.buscarReproducoesCall.call(
              pIdPropriedadeList: propertyIds,
              pLimite: 999,
              pOffset: offsetAtual,
            );

            final pageRecords = _safeRecordsFromApi(reproducaoAPI.jsonBody);
            _syncLog('reproducao',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('reproducao',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              break;
            }

            final result =
                await actions.batchInsertLocalReproducao(pageRecords);
            final pageErrors =
                result['errors'] as List<Map<String, String>>? ?? [];
            if (pageErrors.isNotEmpty) {
              _syncLog('reproducao',
                  '${pageErrors.length} erro(s) ao inserir. offset=$offsetAtual.');
              syncErrors.addAll(pageErrors);
            }
            totalInserted += (result['inserted'] as int? ?? 0);
            _syncLog('reproducao',
                '${result['inserted']} registros inseridos nesta página.');

            FFAppState().indexReproPaginacao =
                FFAppState().indexReproPaginacao + pageRecords.length;
            if (pageRecords.length < 999) {
              _syncLog('reproducao',
                  'Última página detectada (tamanho < 999). Encerrando paginação.');
              break;
            }
          } catch (e, s) {
            _syncLog('reproducao',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            FFAppState().indexReproPaginacao =
                FFAppState().indexReproPaginacao + 999;
          }
        }

        try {
          await action_blocks.qTDReproducoes(context);
        } catch (e) {
          _syncLog('reproducao', 'Erro ao atualizar contadores: $e');
        }
        if (syncErrors.isNotEmpty) {
          syncOk = false;
          _syncLog(
              'reproducao', 'Total de erros acumulados: ${syncErrors.length}.');
        }
        if (totalInserted > 0 || syncErrors.isEmpty) {
          FFAppState().reproducaoChangeDateTime =
              remoteLastChange ?? DateTime.now();
        }
        if (syncOk) {
          _syncLog('reproducao',
              'Sincronização finalizada com sucesso. $totalInserted registros inseridos.');
        } else {
          _syncLog('reproducao',
              'Sincronização finalizada com erros. ${syncErrors.length} registro(s) falharam.');
        }
        await _showSyncErrorsDialog(context, 'Reprodução', syncErrors);
      } catch (e, s) {
        _syncLog('reproducao', 'ERRO FATAL na sincronização: $e\n$s');
      } finally {
        FFAppState().indexReproPaginacao = 0;
        FFAppState().visibilidadeProgressBarRepro = false;
        FFAppState().update(() {});
      }
    } else {
      _syncLog('reproducao', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('reproducao', 'EXCEÇÃO NÃO TRATADA: $e\n$s');
  }
}

Future refreshPesagens(BuildContext context) async {
  try {
    _syncLog('pesagens', 'Iniciando verificação do change tracker...');
    List<HistoricoPesagensChangeTrackerRow>? lastChangeResultt;
    ApiCallResponse? propriedadessO;
    ApiCallResponse? qtdPesagens;
    ApiCallResponse? pesagensAPI;

    try {
      lastChangeResultt = await HistoricoPesagensChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e, s) {
      _syncLog('pesagens', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResultt = [];
    }
    final remoteLastChange = lastChangeResultt.firstOrNull?.lastChange;
    final localLastChange = FFAppState().pesagensChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('pesagens',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    if (shouldSync) {
      _syncLog('pesagens', 'Iniciando sincronização otimizada.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;

      try {
        propriedadessO =
            await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
          pUserId: currentUserUid,
        );

        final propertyIds = _safePropertyIds(propriedadessO.jsonBody);
        _syncLog('pesagens',
            'Propriedades encontradas: ${propertyIds.length}. IDs: $propertyIds');

        if (propertyIds.isEmpty) {
          _syncLog(
              'pesagens', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        qtdPesagens =
            await SupabaseFunctionsGroup.qTDPesagensPropriedadeCall.call(
          pIdsPropriedadesList: propertyIds,
        );
        _syncLog(
            'pesagens', 'Resposta qtdPesagens raw: ${qtdPesagens.jsonBody}');

        final totalPesagens = _safeTotalFromApi(qtdPesagens.jsonBody);
        FFAppState().totalPesagens = totalPesagens;
        FFAppState().indexPesagens = 0;
        _syncLog('pesagens', 'Total remoto informado: $totalPesagens.');

        await SQLiteManager.instance.deletarTodasPesagens();
        _syncLog('pesagens', 'Tabela local limpa. Iniciando paginação...');
        while (FFAppState().indexPesagens < totalPesagens) {
          final offsetAtual = FFAppState().indexPesagens;
          try {
            pesagensAPI = await SupabaseFunctionsGroup.buscarPesagensCall.call(
              pIdPropriedadeList: propertyIds,
              pLimite: 999,
              pOffset: offsetAtual,
            );

            final pageRecords = _safeRecordsFromApi(pesagensAPI.jsonBody);
            _syncLog('pesagens',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('pesagens',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              break;
            }

            final result = await actions.batchInsertLocalPesagens(pageRecords);
            final pageErrors =
                result['errors'] as List<Map<String, String>>? ?? [];
            if (pageErrors.isNotEmpty) {
              _syncLog('pesagens',
                  '${pageErrors.length} erro(s) ao inserir. offset=$offsetAtual.');
              syncErrors.addAll(pageErrors);
            }
            totalInserted += (result['inserted'] as int? ?? 0);
            _syncLog('pesagens',
                '${result['inserted']} registros inseridos nesta página.');

            FFAppState().indexPesagens =
                FFAppState().indexPesagens + pageRecords.length;
            if (pageRecords.length < 999) {
              _syncLog('pesagens',
                  'Última página detectada (tamanho < 999). Encerrando paginação.');
              break;
            }
          } catch (e, s) {
            _syncLog('pesagens',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            FFAppState().indexPesagens = FFAppState().indexPesagens + 999;
          }
        }

        if (syncErrors.isNotEmpty) {
          syncOk = false;
          _syncLog(
              'pesagens', 'Total de erros acumulados: ${syncErrors.length}.');
        }
        if (totalInserted > 0 || syncErrors.isEmpty) {
          FFAppState().pesagensChangeDateTime =
              remoteLastChange ?? DateTime.now();
        }
        if (syncOk) {
          _syncLog('pesagens',
              'Sincronização finalizada com sucesso. $totalInserted registros inseridos.');
        } else {
          _syncLog('pesagens',
              'Sincronização finalizada com erros. ${syncErrors.length} registro(s) falharam.');
        }
        await _showSyncErrorsDialog(context, 'Pesagens', syncErrors);
      } catch (e, s) {
        _syncLog('pesagens', 'ERRO FATAL na sincronização: $e\n$s');
      } finally {
        FFAppState().indexPesagens = 0;
      }
    } else {
      _syncLog('pesagens', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('pesagens', 'EXCEÇÃO NÃO TRATADA: $e\n$s');
  }
}

Future refresSanidadeOtimizada(BuildContext context) async {
  try {
    _syncLog('sanidade', 'Iniciando verificação do change tracker...');
    List<SanidadeChangeTrackerRow>? lastChangeResult;
    ApiCallResponse? propriedades;
    ApiCallResponse? qtdSanidades;
    ApiCallResponse? sanidadesAPI;

    try {
      lastChangeResult = await SanidadeChangeTrackerTable().queryRows(
        queryFn: (q) => q,
      );
    } catch (e, s) {
      _syncLog('sanidade', 'ERRO ao consultar change tracker: $e\n$s');
      lastChangeResult = [];
    }
    final remoteLastChange = lastChangeResult.firstOrNull?.lastChange;
    final localLastChange = FFAppState().sanidadeChangeDateTime;
    final shouldSync = remoteLastChange == null ||
        localLastChange == null ||
        remoteLastChange.isAfter(localLastChange);
    _syncLog('sanidade',
        'shouldSync=$shouldSync  remoteLastChange=$remoteLastChange  localLastChange=$localLastChange');

    if (shouldSync) {
      _syncLog('sanidade', 'Iniciando sincronização otimizada.');
      var syncOk = true;
      final List<Map<String, String>> syncErrors = [];
      int totalInserted = 0;
      FFAppState().sanidadeIndex = 0;
      FFAppState().indexSanidadePaginacao = 0;
      FFAppState().visbilidadeProgressBarSan = true;
      FFAppState().update(() {});

      try {
        propriedades =
            await SupabaseFunctionsGroup.buscarPropriedadesUserCall.call(
          pUserId: currentUserUid,
        );

        final propertyIds = _safePropertyIds(propriedades.jsonBody);
        _syncLog('sanidade',
            'Propriedades encontradas: ${propertyIds.length}. IDs: $propertyIds');

        if (propertyIds.isEmpty) {
          _syncLog(
              'sanidade', 'Nenhuma propriedade encontrada. Abortando sync.');
          return;
        }

        qtdSanidades = await SupabaseFunctionsGroup.qTDSanidadeCall.call(
          pIdsPropriedadesList: propertyIds,
        );
        _syncLog(
            'sanidade', 'Resposta qtdSanidades raw: ${qtdSanidades.jsonBody}');

        final totalSanidades = _safeTotalFromApi(qtdSanidades.jsonBody);
        FFAppState().totalSanidades = totalSanidades;
        _syncLog('sanidade', 'Total remoto informado: $totalSanidades.');

        await SQLiteManager.instance.deleteAllSanidades();
        _syncLog('sanidade', 'Tabela local limpa. Iniciando paginação...');
        while (FFAppState().indexSanidadePaginacao < totalSanidades) {
          final offsetAtual = FFAppState().indexSanidadePaginacao;
          try {
            sanidadesAPI =
                await SupabaseFunctionsGroup.buscarSanidadesCall.call(
              pIdPropriedadeList: propertyIds,
              pLimite: 999,
              pOffset: offsetAtual,
            );

            final pageRecords = _safeRecordsFromApi(sanidadesAPI.jsonBody);
            _syncLog('sanidade',
                'Página recebida. offset=$offsetAtual, tamanho=${pageRecords.length}.');
            if (pageRecords.isEmpty) {
              _syncLog('sanidade',
                  'Página vazia recebida antes do total esperado. Encerrando paginação.');
              break;
            }

            final result = await actions.batchInsertLocalSanidade(pageRecords);
            final pageErrors =
                result['errors'] as List<Map<String, String>>? ?? [];
            if (pageErrors.isNotEmpty) {
              _syncLog('sanidade',
                  '${pageErrors.length} erro(s) ao inserir. offset=$offsetAtual.');
              syncErrors.addAll(pageErrors);
            }
            totalInserted += (result['inserted'] as int? ?? 0);
            _syncLog('sanidade',
                '${result['inserted']} registros inseridos nesta página.');

            FFAppState().indexSanidadePaginacao =
                FFAppState().indexSanidadePaginacao + pageRecords.length;
            if (pageRecords.length < 999) {
              _syncLog('sanidade',
                  'Última página detectada (tamanho < 999). Encerrando paginação.');
              break;
            }
          } catch (e, s) {
            _syncLog('sanidade',
                'Erro ao processar página offset=$offsetAtual: $e\n$s');
            syncErrors.add({
              'id': 'página offset=$offsetAtual',
              'error': 'Erro na requisição ou processamento: $e',
            });
            FFAppState().indexSanidadePaginacao =
                FFAppState().indexSanidadePaginacao + 999;
          }
        }

        try {
          await action_blocks.qTDSanidades(context);
        } catch (e) {
          _syncLog('sanidade', 'Erro ao atualizar contadores: $e');
        }
        if (syncErrors.isNotEmpty) {
          syncOk = false;
          _syncLog(
              'sanidade', 'Total de erros acumulados: ${syncErrors.length}.');
        }
        if (totalInserted > 0 || syncErrors.isEmpty) {
          FFAppState().sanidadeChangeDateTime =
              remoteLastChange ?? DateTime.now();
        }
        if (syncOk) {
          _syncLog('sanidade',
              'Sincronização finalizada com sucesso. $totalInserted registros inseridos.');
        } else {
          _syncLog('sanidade',
              'Sincronização finalizada com erros. ${syncErrors.length} registro(s) falharam.');
        }
        await _showSyncErrorsDialog(context, 'Sanidade', syncErrors);
      } catch (e, s) {
        _syncLog('sanidade', 'ERRO FATAL na sincronização: $e\n$s');
      } finally {
        FFAppState().indexSanidadePaginacao = 0;
        FFAppState().visbilidadeProgressBarSan = false;
        FFAppState().update(() {});
      }
    } else {
      _syncLog('sanidade', 'Sem necessidade de sincronização.');
    }
  } catch (e, s) {
    _syncLog('sanidade', 'EXCEÇÃO NÃO TRATADA: $e\n$s');
  }
}
