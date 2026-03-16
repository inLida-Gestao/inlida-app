import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

import '/backend/schema/structs/index.dart';

import '/backend/supabase/supabase.dart';
import '/backend/sqlite/queries/sqlite_row.dart';
import '/backend/sqlite/queries/read.dart';
import '../../flutter_flow/lat_lng.dart';
import '../../flutter_flow/place.dart';
import '../../flutter_flow/uploaded_file.dart';

/// SERIALIZATION HELPERS

String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final startStr = dateTimeRange.start.millisecondsSinceEpoch.toString();
  final endStr = dateTimeRange.end.millisecondsSinceEpoch.toString();
  return '$startStr|$endStr';
}

String placeToString(FFPlace place) => jsonEncode({
      'latLng': place.latLng.serialize(),
      'name': place.name,
      'address': place.address,
      'city': place.city,
      'state': place.state,
      'country': place.country,
      'zipCode': place.zipCode,
    });

String uploadedFileToString(FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

String? serializeParam(
  dynamic param,
  ParamType paramType, {
  bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, isList: false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.int:
        data = param.toString();
      case ParamType.double:
        data = param.toString();
      case ParamType.String:
        data = param;
      case ParamType.bool:
        data = param ? 'true' : 'false';
      case ParamType.DateTime:
        data = (param as DateTime).millisecondsSinceEpoch.toString();
      case ParamType.DateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.LatLng:
        data = (param as LatLng).serialize();
      case ParamType.Color:
        data = (param as Color).toCssString();
      case ParamType.FFPlace:
        data = placeToString(param as FFPlace);
      case ParamType.FFUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.JSON:
        data = json.encode(param);

      case ParamType.DataStruct:
        data = param is BaseStruct ? param.serialize() : null;

      case ParamType.SupabaseRow:
        return json.encode((param as SupabaseDataRow).data);

      case ParamType.SqliteRow:
        return json.encode((param as SqliteRow).data);

      default:
        data = null;
    }
    return data;
  } catch (e) {
    print('Error serializing parameter: $e');
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  return DateTimeRange(
    start: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.first)),
    end: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.last)),
  );
}

LatLng? latLngFromString(String? latLngStr) {
  final pieces = latLngStr?.split(',');
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

FFPlace placeFromString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'latLng': serializedData.containsKey('latLng')
        ? latLngFromString(serializedData['latLng'] as String)
        : const LatLng(0.0, 0.0),
    'name': serializedData['name'] ?? '',
    'address': serializedData['address'] ?? '',
    'city': serializedData['city'] ?? '',
    'state': serializedData['state'] ?? '',
    'country': serializedData['country'] ?? '',
    'zipCode': serializedData['zipCode'] ?? '',
  };
  return FFPlace(
    latLng: data['latLng'] as LatLng,
    name: data['name'] as String,
    address: data['address'] as String,
    city: data['city'] as String,
    state: data['state'] as String,
    country: data['country'] as String,
    zipCode: data['zipCode'] as String,
  );
}

FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,

  DataStruct,
  SupabaseRow,
  SqliteRow,
  CustomClass,
  CustomEnum,
}

dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList, {
  StructBuilder<T>? structBuilder,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .whereType<String>()
          .map((p) => p as String)
          .map((p) => deserializeParam<T>(
                p,
                paramType,
                false,
                structBuilder: structBuilder,
              ))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == 'true';
      case ParamType.DateTime:
        final milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.LatLng:
        return latLngFromString(param);
      case ParamType.Color:
        return fromCssColor(param);
      case ParamType.FFPlace:
        return placeFromString(param);
      case ParamType.FFUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);

      case ParamType.SupabaseRow:
        final data = json.decode(param) as Map<String, dynamic>;
        switch (T) {
          case ViewReproducaoDetalhadaRow:
            return ViewReproducaoDetalhadaRow(data);
          case CidadesRow:
            return CidadesRow(data);
          case ViewRebanhoSanidadeRow:
            return ViewRebanhoSanidadeRow(data);
          case SanidadeRow:
            return SanidadeRow(data);
          case ReproducaoChangeTrackerRow:
            return ReproducaoChangeTrackerRow(data);
          case DeathsPreDesmamaRow:
            return DeathsPreDesmamaRow(data);
          case RebanhoRow:
            return RebanhoRow(data);
          case LotesChangeTrackerRow:
            return LotesChangeTrackerRow(data);
          case OcorrenciasRow:
            return OcorrenciasRow(data);
          case PatrociniosRow:
            return PatrociniosRow(data);
          case AdministradoresRow:
            return AdministradoresRow(data);
          case RebanhoChangeTrackerRow:
            return RebanhoChangeTrackerRow(data);
          case HistoricoPesagensChangeTrackerRow:
            return HistoricoPesagensChangeTrackerRow(data);
          case ViewLotesComQtdRebanhosRow:
            return ViewLotesComQtdRebanhosRow(data);
          case ReproducaoRow:
            return ReproducaoRow(data);
          case LotesRow:
            return LotesRow(data);
          case PropriedadesChangeTrackerRow:
            return PropriedadesChangeTrackerRow(data);
          case PagamentosRow:
            return PagamentosRow(data);
          case PastagemRow:
            return PastagemRow(data);
          case PropriedadesRow:
            return PropriedadesRow(data);
          case AssinaturasRow:
            return AssinaturasRow(data);
          case TesteRow:
            return TesteRow(data);
          case AnunciosRow:
            return AnunciosRow(data);
          case UsersRow:
            return UsersRow(data);
          case PiqueteRow:
            return PiqueteRow(data);
          case UsersPropriedadesRow:
            return UsersPropriedadesRow(data);
          case SanidadeChangeTrackerRow:
            return SanidadeChangeTrackerRow(data);
          case HistoricoPesagensRow:
            return HistoricoPesagensRow(data);
          default:
            return null;
        }

      case ParamType.DataStruct:
        final data = json.decode(param) as Map<String, dynamic>? ?? {};
        return structBuilder != null ? structBuilder(data) : null;

      case ParamType.SqliteRow:
        final data = json.decode(param) as Map<String, dynamic>;
        switch (T) {
          case LocalCidadesRow:
            return LocalCidadesRow(data);
          case ListarPropriedadesRow:
            return ListarPropriedadesRow(data);
          case BuscaPropriedadesPUTRow:
            return BuscaPropriedadesPUTRow(data);
          case BuscaPropriedadeRow:
            return BuscaPropriedadeRow(data);
          case BuscaUsersPeloIDRow:
            return BuscaUsersPeloIDRow(data);
          case BuscaUsuarioPorEmailRow:
            return BuscaUsuarioPorEmailRow(data);
          case BuscaPropriedadesUPDATEDRow:
            return BuscaPropriedadesUPDATEDRow(data);
          case BuscaUsersPropriedadesRow:
            return BuscaUsersPropriedadesRow(data);
          case ListarRebanhosRow:
            return ListarRebanhosRow(data);
          case BuscarRebanhoRow:
            return BuscarRebanhoRow(data);
          case BuscarRebanhoUPDATEDRow:
            return BuscarRebanhoUPDATEDRow(data);
          case BuscarRebanhoPUTRow:
            return BuscarRebanhoPUTRow(data);
          case QTDAnimaisPropriedadeRow:
            return QTDAnimaisPropriedadeRow(data);
          case QTDDeAnimaisGeralRow:
            return QTDDeAnimaisGeralRow(data);
          case BuscarCriasRebanhoMatrizRow:
            return BuscarCriasRebanhoMatrizRow(data);
          case BuscaHistPesagensRow:
            return BuscaHistPesagensRow(data);
          case BuscaHistPesagensPUTRow:
            return BuscaHistPesagensPUTRow(data);
          case BuscaHistPesagensUPDTRow:
            return BuscaHistPesagensUPDTRow(data);
          case ListarRebanhosProgenereRow:
            return ListarRebanhosProgenereRow(data);
          case ListarLotesRow:
            return ListarLotesRow(data);
          case LotesAtivoRow:
            return LotesAtivoRow(data);
          case LotesInativosRow:
            return LotesInativosRow(data);
          case AnimaisNoLoteRow:
            return AnimaisNoLoteRow(data);
          case BuscarLoteRow:
            return BuscarLoteRow(data);
          case BuscarRebanhoLoteRow:
            return BuscarRebanhoLoteRow(data);
          case BuscarLotePUTRow:
            return BuscarLotePUTRow(data);
          case BuscarLoteUPDTRow:
            return BuscarLoteUPDTRow(data);
          case CountLotesCadastradosRow:
            return CountLotesCadastradosRow(data);
          case ListarReproducoesRow:
            return ListarReproducoesRow(data);
          case BuscarLotesRow:
            return BuscarLotesRow(data);
          case QTDReproducoesRow:
            return QTDReproducoesRow(data);
          case QTDInseminacaoRow:
            return QTDInseminacaoRow(data);
          case QTDMontaNaturalRow:
            return QTDMontaNaturalRow(data);
          case BuscarReproducaoRow:
            return BuscarReproducaoRow(data);
          case BuscarReproducaoPUTRow:
            return BuscarReproducaoPUTRow(data);
          case BuscarReproducaoUPDTRow:
            return BuscarReproducaoUPDTRow(data);
          case ListarSanidadesRow:
            return ListarSanidadesRow(data);
          case BuscarSanidadePUTRow:
            return BuscarSanidadePUTRow(data);
          case BuscarSanidadeUPDTRow:
            return BuscarSanidadeUPDTRow(data);
          case BuscarReproducoesRebanhoRow:
            return BuscarReproducoesRebanhoRow(data);
          case BuscarSanidadesRebanhoRow:
            return BuscarSanidadesRebanhoRow(data);
          case BuscaRebanhoPaginadaRow:
            return BuscaRebanhoPaginadaRow(data);
          case QTDAnimaisTotalPropriedadeRow:
            return QTDAnimaisTotalPropriedadeRow(data);
          case BuscarCriasRebanhoReprodutorRow:
            return BuscarCriasRebanhoReprodutorRow(data);
          case BuscarRebanhoReproducaoLoteRow:
            return BuscarRebanhoReproducaoLoteRow(data);
          case ListarReproducoesPaginadaRow:
            return ListarReproducoesPaginadaRow(data);
          case CountAnimaisLoteRow:
            return CountAnimaisLoteRow(data);
          case BuscarRebanhoNumRow:
            return BuscarRebanhoNumRow(data);
          case BuscaRebanhoPaginadaPesquisaRow:
            return BuscaRebanhoPaginadaPesquisaRow(data);
          case ListarReproducoesPesqRow:
            return ListarReproducoesPesqRow(data);
          case BuscaSanidadesPesqRow:
            return BuscaSanidadesPesqRow(data);
          case BuscaSanidadesPaginadaRow:
            return BuscaSanidadesPaginadaRow(data);
          case QTDSanidadesRow:
            return QTDSanidadesRow(data);
          case BuscaUserLogadoRow:
            return BuscaUserLogadoRow(data);
          case QtdAnimaisNoLoteRow:
            return QtdAnimaisNoLoteRow(data);
          case BuscarAnimaisDoLoteRow:
            return BuscarAnimaisDoLoteRow(data);
          case RebanhoPagOrdNumCresRow:
            return RebanhoPagOrdNumCresRow(data);
          case RebanhoPagOrdNumDescRow:
            return RebanhoPagOrdNumDescRow(data);
          case RebanhoPagOrdNomCresRow:
            return RebanhoPagOrdNomCresRow(data);
          case RebanhoPagOrdNomDescRow:
            return RebanhoPagOrdNomDescRow(data);
          case RebanhoPagOrdDataCresRow:
            return RebanhoPagOrdDataCresRow(data);
          case RebanhoPagOrdDataDescRow:
            return RebanhoPagOrdDataDescRow(data);
          case ListarPropriedadesCrescNomeRow:
            return ListarPropriedadesCrescNomeRow(data);
          case ListarPropriedadesDecNomeRow:
            return ListarPropriedadesDecNomeRow(data);
          case BuscaRebanhoPopupRow:
            return BuscaRebanhoPopupRow(data);
          case RebanhoPopupSPRow:
            return RebanhoPopupSPRow(data);
          case ListaInseminadoresRow:
            return ListaInseminadoresRow(data);
          default:
            return null;
        }

      default:
        return null;
    }
  } catch (e) {
    print('Error deserializing parameter: $e');
    return null;
  }
}
