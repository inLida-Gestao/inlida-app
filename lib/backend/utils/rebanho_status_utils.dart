const String defaultRebanhoStatus = 'Na propriedade';

const List<String> validRebanhoStatus = [
  'Sêmen',
  'Vendido',
  defaultRebanhoStatus,
  'Fora da propriedade',
  'Morto',
  'Movimentação',
];

String normalizeRebanhoStatus(String? status) {
  final normalized = status?.trim();
  if (normalized == null || normalized.isEmpty || normalized == 'Inativo') {
    return defaultRebanhoStatus;
  }
  return normalized;
}

List<String> sanitizeRebanhoStatusOptions(List<String>? statuses) {
  final allowed = validRebanhoStatus.toSet();
  final sanitized = <String>[];

  for (final status in statuses ?? validRebanhoStatus) {
    if (allowed.contains(status) && !sanitized.contains(status)) {
      sanitized.add(status);
    }
  }

  for (final status in validRebanhoStatus) {
    if (!sanitized.contains(status)) {
      sanitized.add(status);
    }
  }

  return sanitized;
}
