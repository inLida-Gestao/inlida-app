import 'package:flutter/services.dart';

/// Formatter para campos de peso (kg) com 2 casas decimais.
///
/// O usuário digita SOMENTE dígitos — o formatter:
/// - Remove qualquer caractere não-numérico digitado/colado.
/// - Trata os dois últimos dígitos como decimais (centavos do kg).
/// - Insere a vírgula automaticamente.
/// - Remove zeros à esquerda mantendo o "0,XX" para valores < 1 kg.
///
/// Exemplos de digitação → exibição:
///   "1"       → "0,01"
///   "12"      → "0,12"
///   "123"     → "1,23"
///   "12345"   → "123,45"
///   "1234567" → "12.345,67"
class PesoInputFormatter extends TextInputFormatter {
  final bool useThousandsSeparator;

  const PesoInputFormatter({this.useThousandsSeparator = true});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    // Limita a 8 dígitos (até 999.999,99 kg).
    final clamped =
        digits.length > 8 ? digits.substring(digits.length - 8) : digits;
    final formatted = formatDigits(clamped, useThousandsSeparator);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Formata uma string de dígitos no padrão "X.XXX,YY".
  /// Exposta para reutilização por [formatPesoInicial].
  static String formatDigits(String digits, bool thousands) {
    final padded = digits.padLeft(3, '0');
    final intPartRaw = padded.substring(0, padded.length - 2);
    final decPart = padded.substring(padded.length - 2);

    var intPart = intPartRaw.replaceFirst(RegExp(r'^0+'), '');
    if (intPart.isEmpty) intPart = '0';

    if (thousands && intPart.length > 3) {
      intPart = _withThousands(intPart);
    }
    return '$intPart,$decPart';
  }

  static String _withThousands(String s) {
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final remaining = s.length - i;
      buf.write(s[i]);
      if (remaining > 1 && remaining % 3 == 1) buf.write('.');
    }
    return buf.toString();
  }
}

/// Converte um peso (double) em string formatada para preencher o controller
/// inicial de um campo que usa [PesoInputFormatter].
///
/// `null` ou 0 → string vazia.
/// 12.5 → "12,50"
String formatPesoInicial(double? value) {
  if (value == null || value == 0.0) return '';
  final cents = (value * 100).round().abs();
  return PesoInputFormatter.formatDigits(cents.toString(), true);
}

/// Faz o parse seguro de um campo formatado pelo [PesoInputFormatter].
/// Remove separadores de milhar (".") e converte vírgula decimal em ponto.
/// Retorna null se vazio ou inválido.
double? parsePesoFormatado(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final normalized = trimmed.replaceAll('.', '').replaceAll(',', '.');
  return double.tryParse(normalized);
}
