import 'rebanho_natural_sort.dart';

/// Sorts animals shown in the lote animal-selection lists (add/edit lote).
///
/// [tipo] is one of `''`, `'numero'` or `'nascimento'`. [direcao] is one of
/// `''`, `'crescente'` or `'decrescente'`. When [tipo] is empty (no sorting
/// selected), falls back to the previous behavior of ordering by
/// [createdAtOf] descending (most recently created first).
///
/// Empty/null values for the selected field are always placed last,
/// regardless of [direcao].
List<T> sortAnimaisLote<T>(
  List<T> items, {
  required String? Function(T item) numeroOf,
  required String? Function(T item) nascimentoOf,
  String? Function(T item)? createdAtOf,
  required String tipo,
  required String direcao,
}) {
  final result = List<T>.from(items);

  if (tipo != 'numero' && tipo != 'nascimento') {
    result.sort((a, b) {
      final createdA = createdAtOf?.call(a) ?? '';
      final createdB = createdAtOf?.call(b) ?? '';
      return createdB.compareTo(createdA);
    });
    return result;
  }

  final desc = direcao == 'decrescente';

  String? rawValueOf(T item) {
    final value = tipo == 'numero' ? numeroOf(item) : nascimentoOf(item);
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
      return null;
    }
    return trimmed;
  }

  String sortKeyOf(T item) {
    final raw = rawValueOf(item);
    if (raw == null) return '';
    return tipo == 'numero' ? buildRebanhoNumeroSortKey(raw) : raw;
  }

  result.sort((a, b) {
    final rawA = rawValueOf(a);
    final rawB = rawValueOf(b);

    // Empty values always go last, regardless of direction.
    if (rawA == null && rawB == null) return 0;
    if (rawA == null) return 1;
    if (rawB == null) return -1;

    final keyA = sortKeyOf(a);
    final keyB = sortKeyOf(b);
    final comparison = keyA.compareTo(keyB);
    return desc ? -comparison : comparison;
  });

  return result;
}
