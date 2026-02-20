import '../database.dart';

class DeathsPreDesmamaTable extends SupabaseTable<DeathsPreDesmamaRow> {
  @override
  String get tableName => 'deaths_pre_desmama';

  @override
  DeathsPreDesmamaRow createRow(Map<String, dynamic> data) =>
      DeathsPreDesmamaRow(data);
}

class DeathsPreDesmamaRow extends SupabaseDataRow {
  DeathsPreDesmamaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeathsPreDesmamaTable();

  int? get count => getField<int>('count');
  set count(int? value) => setField<int>('count', value);
}
