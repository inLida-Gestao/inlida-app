import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Bubble Group Code

class BubbleGroup {
  static String getBaseUrl() =>
      'https://inlida.bubbleapps.io/version-test/api/1.1/wf';
  static Map<String, String> headers = {};
  static IconesimgsCall iconesimgsCall = IconesimgsCall();
}

class IconesimgsCall {
  Future<ApiCallResponse> call({
    String? corSelecionada = '',
  }) async {
    final baseUrl = BubbleGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'iconesimgs',
      apiUrl: '$baseUrl/icones_imgs',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'cor_selecionada': corSelecionada,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? icones(dynamic response) => getJsonField(
        response,
        r'''$.Icones''',
        true,
      ) as List?;
  List<String>? imagem(dynamic response) => (getJsonField(
        response,
        r'''$.Icones[:].imagem''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

/// End Bubble Group Code

/// Start Supabase Functions Group Code

class SupabaseFunctionsGroup {
  static String getBaseUrl() =>
      'https://eqrtgsqnxxnfjjzlxpuj.supabase.co/rest/v1/rpc';
  static Map<String, String> headers = {
    'apikey':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
  };
  static BuscarRebanhosCall buscarRebanhosCall = BuscarRebanhosCall();
  static BuscarReproducoesCall buscarReproducoesCall = BuscarReproducoesCall();
  static BuscarSanidadesCall buscarSanidadesCall = BuscarSanidadesCall();
  static BuscarPesagensCall buscarPesagensCall = BuscarPesagensCall();
  static QTDRebanhosCall qTDRebanhosCall = QTDRebanhosCall();
  static QTDPesagensPropriedadeCall qTDPesagensPropriedadeCall =
      QTDPesagensPropriedadeCall();
  static QTDPesagensCall qTDPesagensCall = QTDPesagensCall();
  static QTDReproducoesCall qTDReproducoesCall = QTDReproducoesCall();
  static QTDSanidadeCall qTDSanidadeCall = QTDSanidadeCall();
  static BuscarPropriedadesUserCall buscarPropriedadesUserCall =
      BuscarPropriedadesUserCall();
  // Incremental sync calls
  static BuscarRebanhosIncCall buscarRebanhosIncCall = BuscarRebanhosIncCall();
  static BuscarReproducoesIncCall buscarReproducoesIncCall =
      BuscarReproducoesIncCall();
  static BuscarSanidadesIncCall buscarSanidadesIncCall =
      BuscarSanidadesIncCall();
  static QTDRebanhosIncCall qTDRebanhosIncCall = QTDRebanhosIncCall();
  static QTDReproducoesIncCall qTDReproducoesIncCall =
      QTDReproducoesIncCall();
  static QTDSanidadeIncCall qTDSanidadeIncCall = QTDSanidadeIncCall();
  static BuscarPropriedadesUserIncCall buscarPropriedadesUserIncCall =
      BuscarPropriedadesUserIncCall();
}

class BuscarRebanhosCall {
  Future<ApiCallResponse> call({
    List<String>? pIdPropriedadeList,
    int? pLimite = 999,
    int? pOffset = 0,
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdPropriedade = _serializeList(pIdPropriedadeList);

    final ffApiRequestBody = '''
{
  "p_id_propriedade": [
    $pIdPropriedade
  ],
  "p_limite": $pLimite,
  "p_offset": $pOffset
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Rebanhos',
      apiUrl: '$baseUrl/rebanho_propriedade_mobile',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscarReproducoesCall {
  Future<ApiCallResponse> call({
    List<String>? pIdPropriedadeList,
    int? pLimite = 999,
    int? pOffset = 0,
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdPropriedade = _serializeList(pIdPropriedadeList);

    final ffApiRequestBody = '''
{
  "p_id_propriedade": [
    $pIdPropriedade
  ],
  "p_limite": $pLimite,
  "p_offset": $pOffset
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Reproducoes',
      apiUrl: '$baseUrl/reproducao_mobile',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscarSanidadesCall {
  Future<ApiCallResponse> call({
    List<String>? pIdPropriedadeList,
    int? pLimite = 999,
    int? pOffset = 0,
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdPropriedade = _serializeList(pIdPropriedadeList);

    final ffApiRequestBody = '''
{
  "p_id_propriedade": [
    $pIdPropriedade
  ],
  "p_limite": $pLimite,
  "p_offset": $pOffset
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Sanidades',
      apiUrl: '$baseUrl/sanidade_mobile',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscarPesagensCall {
  Future<ApiCallResponse> call({
    List<String>? pIdPropriedadeList,
    int? pLimite = 999,
    int? pOffset = 0,
  }) async {
    final baseUrl =
        SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '');
    final propertyFilter = _serializeInFilter(pIdPropriedadeList);

    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Pesagens',
      apiUrl: '$baseUrl/historico_pesagens',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {
        'select': '*',
        'id_propriedade': 'in.$propertyFilter',
        'order': 'id.asc',
        'limit': pLimite,
        'offset': pOffset,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class QTDRebanhosCall {
  Future<ApiCallResponse> call({
    List<String>? pIdsPropriedadesList,
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdsPropriedades = _serializeList(pIdsPropriedadesList);

    final ffApiRequestBody = '''
{
  "p_ids_propriedades": [
    $pIdsPropriedades
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'QTD Rebanhos',
      apiUrl: '$baseUrl/contar_rebanho_prop_mob',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class QTDPesagensPropriedadeCall {
  Future<ApiCallResponse> call({
    List<String>? pIdsPropriedadesList,
  }) async {
    final baseUrl =
        SupabaseFunctionsGroup.getBaseUrl().replaceFirst('/rpc', '');
    final propertyFilter = _serializeInFilter(pIdsPropriedadesList);

    return ApiManager.instance.makeApiCall(
      callName: 'QTD Pesagens Propriedade',
      apiUrl: '$baseUrl/historico_pesagens',
      callType: ApiCallType.GET,
      headers: {
        'Prefer': 'count=exact',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {
        'select': 'id',
        'id_propriedade': 'in.$propertyFilter',
        'limit': 1,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class QTDPesagensCall {
  Future<ApiCallResponse> call({
    List<String>? pIdsRebanhosList,
    String? pTimestamp = '',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdsRebanhos = _serializeList(pIdsRebanhosList);

    final ffApiRequestBody = '''
{
  "p_ids_rebanhos": [
    $pIdsRebanhos
  ],
  "p_timestamp": "${escapeStringForJson(pTimestamp)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'QTD Pesagens',
      apiUrl: '$baseUrl/contar_pesagens_mob',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class QTDReproducoesCall {
  Future<ApiCallResponse> call({
    List<String>? pIdsPropriedadesList,
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdsPropriedades = _serializeList(pIdsPropriedadesList);

    final ffApiRequestBody = '''
{
  "p_ids_propriedades": [
    $pIdsPropriedades
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'QTD Reproducoes',
      apiUrl: '$baseUrl/contar_repro_prop_mob',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class QTDSanidadeCall {
  Future<ApiCallResponse> call({
    List<String>? pIdsPropriedadesList,
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdsPropriedades = _serializeList(pIdsPropriedadesList);

    final ffApiRequestBody = '''
{
  "p_ids_propriedades": [
    $pIdsPropriedades
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'QTD Sanidade',
      apiUrl: '$baseUrl/contar_sanidade_prop_mob',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscarPropriedadesUserCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Propriedades User',
      apiUrl: '$baseUrl/propriedades_by_user',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Supabase Functions Group Code

/// Incremental Sync API Calls

class BuscarRebanhosIncCall {
  Future<ApiCallResponse> call({
    List<String>? pIdPropriedadeList,
    int? pLimite = 999,
    int? pOffset = 0,
    String? pUpdatedAfter = '1970-01-01T00:00:00',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdPropriedade = _serializeList(pIdPropriedadeList);
    final ffApiRequestBody = '''
{
  "p_id_propriedade": [$pIdPropriedade],
  "p_limite": $pLimite,
  "p_offset": $pOffset,
  "p_updated_after": "${escapeStringForJson(pUpdatedAfter)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Rebanhos Inc',
      apiUrl: '$baseUrl/rebanho_propriedade_mobile_inc',
      callType: ApiCallType.POST,
      headers: SupabaseFunctionsGroup.headers,
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscarReproducoesIncCall {
  Future<ApiCallResponse> call({
    List<String>? pIdPropriedadeList,
    int? pLimite = 999,
    int? pOffset = 0,
    String? pUpdatedAfter = '1970-01-01T00:00:00',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdPropriedade = _serializeList(pIdPropriedadeList);
    final ffApiRequestBody = '''
{
  "p_id_propriedade": [$pIdPropriedade],
  "p_limite": $pLimite,
  "p_offset": $pOffset,
  "p_updated_after": "${escapeStringForJson(pUpdatedAfter)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Reproducoes Inc',
      apiUrl: '$baseUrl/reproducao_mobile_inc',
      callType: ApiCallType.POST,
      headers: SupabaseFunctionsGroup.headers,
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscarSanidadesIncCall {
  Future<ApiCallResponse> call({
    List<String>? pIdPropriedadeList,
    int? pLimite = 999,
    int? pOffset = 0,
    String? pUpdatedAfter = '1970-01-01T00:00:00',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdPropriedade = _serializeList(pIdPropriedadeList);
    final ffApiRequestBody = '''
{
  "p_id_propriedade": [$pIdPropriedade],
  "p_limite": $pLimite,
  "p_offset": $pOffset,
  "p_updated_after": "${escapeStringForJson(pUpdatedAfter)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Sanidades Inc',
      apiUrl: '$baseUrl/sanidade_mobile_inc',
      callType: ApiCallType.POST,
      headers: SupabaseFunctionsGroup.headers,
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class QTDRebanhosIncCall {
  Future<ApiCallResponse> call({
    List<String>? pIdsPropriedadesList,
    String? pUpdatedAfter = '1970-01-01T00:00:00',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdsPropriedades = _serializeList(pIdsPropriedadesList);
    final ffApiRequestBody = '''
{
  "p_ids_propriedades": [$pIdsPropriedades],
  "p_updated_after": "${escapeStringForJson(pUpdatedAfter)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'QTD Rebanhos Inc',
      apiUrl: '$baseUrl/contar_rebanho_prop_mob_inc',
      callType: ApiCallType.POST,
      headers: SupabaseFunctionsGroup.headers,
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class QTDReproducoesIncCall {
  Future<ApiCallResponse> call({
    List<String>? pIdsPropriedadesList,
    String? pUpdatedAfter = '1970-01-01T00:00:00',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdsPropriedades = _serializeList(pIdsPropriedadesList);
    final ffApiRequestBody = '''
{
  "p_ids_propriedades": [$pIdsPropriedades],
  "p_updated_after": "${escapeStringForJson(pUpdatedAfter)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'QTD Reproducoes Inc',
      apiUrl: '$baseUrl/contar_reproducao_prop_mob_inc',
      callType: ApiCallType.POST,
      headers: SupabaseFunctionsGroup.headers,
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class QTDSanidadeIncCall {
  Future<ApiCallResponse> call({
    List<String>? pIdsPropriedadesList,
    String? pUpdatedAfter = '1970-01-01T00:00:00',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final pIdsPropriedades = _serializeList(pIdsPropriedadesList);
    final ffApiRequestBody = '''
{
  "p_ids_propriedades": [$pIdsPropriedades],
  "p_updated_after": "${escapeStringForJson(pUpdatedAfter)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'QTD Sanidade Inc',
      apiUrl: '$baseUrl/contar_sanidade_prop_mob_inc',
      callType: ApiCallType.POST,
      headers: SupabaseFunctionsGroup.headers,
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscarPropriedadesUserIncCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? pUpdatedAfter = '1970-01-01T00:00:00',
  }) async {
    final baseUrl = SupabaseFunctionsGroup.getBaseUrl();
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_updated_after": "${escapeStringForJson(pUpdatedAfter)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Buscar Propriedades User Inc',
      apiUrl: '$baseUrl/propriedades_by_user_inc',
      callType: ApiCallType.POST,
      headers: SupabaseFunctionsGroup.headers,
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Incremental Sync API Calls

class CidadesCall {
  static Future<ApiCallResponse> call({
    String? idUF = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Cidades',
      apiUrl:
          'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$idUF/distritos',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'idUF': idUF,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? cidade(dynamic response) => (getJsonField(
        response,
        r'''$[:].nome''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class DeleteUserCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": "${escapeStringForJson(userId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Delete user',
      apiUrl:
          'https://eqrtgsqnxxnfjjzlxpuj.supabase.co/rest/v1/rpc/delete_user',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscaCidadesCall {
  static Future<ApiCallResponse> call({
    int? inicio,
    int? fim,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Busca Cidades',
      apiUrl:
          'https://eqrtgsqnxxnfjjzlxpuj.supabase.co/rest/v1/cidades?select=*',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxcnRnc3FueHhuZmpqemx4cHVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMjkwNjgsImV4cCI6MjA2MjgwNTA2OH0.OIpsBOdszJWSjFeeZeNTu4WQySocdJIygMWpYRYc-tM',
        'Range': '$inicio-$fim',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? uf(dynamic response) => (getJsonField(
        response,
        r'''$[:].UF''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? cidade(dynamic response) => (getJsonField(
        response,
        r'''$[:].cidade''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeInFilter(List? list) {
  final values = (list ?? <String>[])
      .whereType<String>()
      .where((e) => e.isNotEmpty)
      .toList();
  return '(${values.join(',')})';
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
