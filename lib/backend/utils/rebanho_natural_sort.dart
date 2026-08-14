/// Builds an ASCII-only key that sorts animal identifiers naturally in SQLite.
///
/// Numeric runs are compared by their normalized length and digits, so values
/// such as 2, 13 and 100 sort numerically while identifiers such as A2 and A10
/// keep their natural order. Empty values are placed after non-empty values.
String buildRebanhoNumeroSortKey(String? value) {
  final normalized = (value ?? '').trim().toUpperCase();
  if (normalized.isEmpty) return '2';

  final codeUnits = normalized.codeUnits;
  final tokens = <String>[];
  var index = 0;

  while (index < codeUnits.length) {
    final isDigit = _isAsciiDigit(codeUnits[index]);
    final start = index;
    while (index < codeUnits.length &&
        _isAsciiDigit(codeUnits[index]) == isDigit) {
      index++;
    }

    final chunk = String.fromCharCodes(codeUnits.sublist(start, index));
    if (isDigit) {
      final digits = chunk.replaceFirst(RegExp(r'^0+'), '');
      final normalizedDigits = digits.isEmpty ? '0' : digits;
      tokens.add(
        '0${normalizedDigits.length.toString().padLeft(12, '0')}'
        '$normalizedDigits',
      );
    } else {
      final encoded = codeUnits
          .sublist(start, index)
          .map((unit) => unit.toRadixString(16).padLeft(4, '0'))
          .join();
      tokens.add(
        '1${chunk.length.toString().padLeft(12, '0')}$encoded',
      );
    }
  }

  return tokens.join();
}

bool _isAsciiDigit(int codeUnit) => codeUnit >= 48 && codeUnit <= 57;
