import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

  const PesoInputFormatter({this.useThousandsSeparator = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Se o usuário (ou IME) digitou mais de um separador (',' ou '.'),
    // NÃO limpamos automaticamente — a entrada é ambígua e a limpeza
    // silenciosa pode trocar o número (ex.: "50,,5" -> "5,05" em vez
    // de "50,50"). Preservamos o texto sujo para que
    // sanitizePesoControllersBeforeSave bloqueie o save com diálogo.
    final separadores = RegExp(r'[.,]').allMatches(newValue.text).length;
    if (separadores > 1) {
      return newValue;
    }

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
  return PesoInputFormatter.formatDigits(cents.toString(), false);
}

/// Faz o parse seguro de um campo de peso, tolerando QUALQUER formato que
/// possa vir do teclado (mesmo se o [PesoInputFormatter] for ignorado por
/// algum IME exótico em release):
///
///   "12,5"      → 12.5
///   "12.5"      → 12.5    (ponto tratado como decimal)
///   "12.345,67" → 12345.67
///   "12,345.67" → 12345.67
///   "1,2,3"     → 12.3    (último separador é o decimal)
///   "abc"       → null
///
/// Regra: o ÚLTIMO `.` ou `,` é o separador decimal. Os anteriores
/// (separadores de milhar) são removidos. Caracteres não-numéricos e não
/// separadores são descartados.
double? parsePesoFormatado(String? raw) {
  if (raw == null) return null;
  var s = raw.trim().replaceAll(RegExp(r'[^0-9.,]'), '');
  if (s.isEmpty) return null;

  final lastSep = s.lastIndexOf(RegExp(r'[.,]'));
  String intPart;
  String decPart;
  if (lastSep < 0) {
    intPart = s;
    decPart = '';
  } else {
    intPart = s.substring(0, lastSep).replaceAll(RegExp(r'[.,]'), '');
    decPart = s.substring(lastSep + 1).replaceAll(RegExp(r'[.,]'), '');
  }
  if (intPart.isEmpty) intPart = '0';
  final normalized = decPart.isEmpty ? intPart : '$intPart.$decPart';
  return double.tryParse(normalized);
}

/// Normaliza o texto de um controller de peso aplicando a formatação
/// canônica. Use ANTES de salvar para garantir que mesmo se o formatter
/// não foi acionado (IME exótico), o valor lido será consistente.
///
/// Retorna o double parseado (pode ser null se o campo está vazio/inválido).
double? normalizePesoController(TextEditingController? c) {
  if (c == null) return null;
  final v = parsePesoFormatado(c.text);
  c.text = formatPesoInicial(v);
  return v;
}

/// Sanitiza uma lista de controllers de peso ANTES de salvar.
///
/// - Reescreve cada controller no formato canônico `X,YY`.
/// - Se algum controller tinha mais de 1 separador (`,` ou `.`) na entrada
///   original (ex.: `45,,5` ou `50..8`), é considerado entrada ambígua:
///   mostra um **AlertDialog modal** avisando o usuário, atualiza o campo
///   com o valor corrigido e retorna `false` — o save NÃO prossegue.
///   Usuário precisa fechar o diálogo, conferir o valor sugerido e clicar
///   Salvar novamente.
/// - Em caso normal, retorna `true`.
///
/// Por que diálogo e não SnackBar: o SnackBar pode ficar escondido pelo
/// teclado virtual, fazendo o usuário pensar que nada aconteceu.
///
/// Use no início do `onPressed` de cada botão Salvar:
///
/// ```dart
/// if (!await sanitizePesoControllersBeforeSave(context, [
///   _model.pesoNascimentoTextController,
///   _model.pesoAtualTextController,
/// ])) return;
/// ```
Future<bool> sanitizePesoControllersBeforeSave(
  BuildContext context,
  List<TextEditingController?> controllers,
) async {
  final entradasAmbiguas = <MapEntry<String, String>>[];

  for (final c in controllers) {
    if (c == null) continue;
    final original = c.text;
    if (original.trim().isEmpty) continue;

    final separadores = RegExp(r'[.,]').allMatches(original).length;
    final parsed = parsePesoFormatado(original);
    final corrigido = formatPesoInicial(parsed);
    if (corrigido != original) {
      c.text = corrigido;
    }

    if (separadores > 1) {
      entradasAmbiguas.add(MapEntry(
        original,
        corrigido.isEmpty ? '0,00' : corrigido,
      ));
    }
  }

  if (entradasAmbiguas.isEmpty) return true;

  // Fecha o teclado para o diálogo aparecer com clareza.
  FocusManager.instance.primaryFocus?.unfocus();

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) {
      return AlertDialog(
        title: const Text('Peso inválido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Você digitou um peso com mais de uma vírgula ou ponto:'),
            const SizedBox(height: 12),
            for (final e in entradasAmbiguas)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '"${e.key}"  →  sugestão: "${e.value}"',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Ajustamos automaticamente o(s) campo(s) com a sugestão. '
              'Por favor, confira o valor e clique em Salvar novamente.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Entendi'),
          ),
        ],
      );
    },
  );
  return false;
}

/// Controller customizado que SEMPRE força o formato canônico de peso no
/// setter `value`. É a defesa definitiva contra IMEs que bypassam
/// `inputFormatters` (Samsung Keyboard, Gboard com predição, autofill,
/// scribe, voice input).
///
/// Use no lugar de `TextEditingController()` em campos de peso:
///   _model.pesoController ??= PesoTextEditingController();
///   _model.pesoController ??= PesoTextEditingController(text: '12,50');
class PesoTextEditingController extends TextEditingController {
  PesoTextEditingController({String? text}) : super() {
    if (text != null && text.isNotEmpty) {
      value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  set value(TextEditingValue newValue) {
    final raw = newValue.text;
    // ignore: avoid_print
    debugPrint('[PesoCtrl] set value <- "$raw"');

    // Se o usuário digitou mais de um separador (ex.: "45,,5", "50..8",
    // "1,5,5"), NÃO limpamos automaticamente — o valor é ambíguo e a
    // limpeza silenciosa pode trocar o número (ex.: "45,,5" -> "4,55"
    // em vez de "45,50"). Preservamos a entrada para que
    // sanitizePesoControllersBeforeSave bloqueie o save com diálogo.
    final separadores = RegExp(r'[.,]').allMatches(raw).length;
    if (separadores > 1) {
      if (raw == super.value.text && newValue.selection == super.value.selection) {
        return;
      }
      super.value = newValue.copyWith(composing: TextRange.empty);
      return;
    }

    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      if (super.value.text.isEmpty) {
        super.value = newValue.copyWith(composing: TextRange.empty);
        return;
      }
      super.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
        composing: TextRange.empty,
      );
      return;
    }

    final clamped =
        digits.length > 8 ? digits.substring(digits.length - 8) : digits;
    final formatted = PesoInputFormatter.formatDigits(clamped, false);

    final next = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
      composing: TextRange.empty,
    );
    if (next.text == super.value.text &&
        next.selection == super.value.selection) {
      return;
    }
    super.value = next;
  }
}

/// Garante que [existing] seja um [PesoTextEditingController]. Se não for,
/// cria um novo preservando o texto. Use em initState quando o controller
/// pode já estar criado por um modelo legado.
PesoTextEditingController ensurePesoController(
    TextEditingController? existing) {
  if (existing is PesoTextEditingController) return existing;
  final c = PesoTextEditingController();
  if (existing != null && existing.text.isNotEmpty) {
    c.value = TextEditingValue(
      text: existing.text,
      selection: TextSelection.collapsed(offset: existing.text.length),
    );
  }
  return c;
}
