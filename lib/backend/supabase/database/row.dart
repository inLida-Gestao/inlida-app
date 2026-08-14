import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'database.dart';

abstract class SupabaseDataRow {
  SupabaseDataRow(this.data);

  SupabaseTable get table;
  Map<String, dynamic> data;

  String get tableName => table.tableName;

  T? getField<T>(String fieldName, [T? defaultValue]) =>
      _supaDeserialize<T>(data[fieldName]) ?? defaultValue;
  void setField<T>(String fieldName, T? value) =>
      data[fieldName] = supaSerialize<T>(value);
  List<T> getListField<T>(String fieldName) =>
      _supaDeserializeList<T>(data[fieldName]) ?? [];
  void setListField<T>(String fieldName, List<T>? value) =>
      data[fieldName] = supaSerializeList<T>(value);

  @override
  String toString() => '''
Table: $tableName
Row Data: {${data.isNotEmpty ? '\n' : ''}${data.entries.map((e) => '  (${e.value.runtimeType}) "${e.key}": ${e.value},\n').join('')}}''';

  @override
  int get hashCode => Object.hash(
        tableName,
        Object.hashAllUnordered(
          data.entries.map((e) => Object.hash(e.key, e.value)),
        ),
      );

  @override
  bool operator ==(Object other) =>
      other is SupabaseDataRow && mapEquals(other.data, data);
}

dynamic supaSerialize<T>(T? value) {
  if (value == null) {
    return null;
  }

  switch (T) {
    case DateTime:
      // NÃO converter para UTC aqui.
      //
      // Os campos de data do app (data_inseminacao, data_parto, data_inicial,
      // previsao_parto, dataNascimento, ...) nascem como data pura
      // ('yyyy-MM-dd') no SQLite e viram DateTime LOCAL à meia-noite. Serializar
      // como horário local naive ('2026-06-01T00:00:00.000', sem sufixo de
      // fuso) é a convenção usada por TODO o histórico já gravado no Supabase e
      // pelo dashboard web que agrupa por período.
      //
      // Converter para UTC antes de serializar (`.toUtc()`) desloca o instante
      // pelo offset do dispositivo (ex.: -03:00 => +3h) e faz os registros
      // NOVOS ficarem em uma convenção diferente dos ANTIGOS. Isso quebra os
      // gráficos por período (taxa de prenhez, taxa de natalidade, partos por
      // categoria), pois registros próximos da virada do dia caem no dia/mês
      // errado e passam a conviver com dados na convenção antiga.
      //
      // Qualquer normalização de fuso precisa ser uma migração coordenada
      // entre app, web e os dados já existentes — nunca uma mudança
      // unilateral no app.
      return (value as DateTime).toIso8601String();
    case PostgresTime:
      return (value as PostgresTime).toIso8601String();
    case LatLng:
      final latLng = (value as LatLng);
      return {'lat': latLng.latitude, 'lng': latLng.longitude};
    default:
      return value;
  }
}

List? supaSerializeList<T>(List<T>? value) =>
    value?.map((v) => supaSerialize<T>(v)).toList();

T? _supaDeserialize<T>(dynamic value) {
  if (value == null) {
    return null;
  }

  switch (T) {
    case int:
      return (value as num).round() as T?;
    case double:
      return (value as num).toDouble() as T?;
    case DateTime:
      return DateTime.tryParse(value as String)?.toLocal() as T?;
    case PostgresTime:
      return PostgresTime.tryParse(value as String) as T?;
    case LatLng:
      final latLng = value is Map ? value : json.decode(value) as Map;
      final lat = latLng['lat'] ?? latLng['latitude'];
      final lng = latLng['lng'] ?? latLng['longitude'];
      return lat is num && lng is num
          ? LatLng(lat.toDouble(), lng.toDouble()) as T?
          : null;
    default:
      return value as T;
  }
}

List<T>? _supaDeserializeList<T>(dynamic value) => value is List
    ? value
        .map((v) => _supaDeserialize<T>(v))
        .where((v) => v != null)
        .map((v) => v as T)
        .toList()
    : null;
