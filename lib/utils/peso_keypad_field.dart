import 'package:flutter/material.dart';

import 'peso_input_formatter.dart';

/// Campo de peso baseado em keypad in-app (sem IME nativo).
///
/// Visualmente parece um TextFormField. Ao tocar, abre um BottomSheet
/// com display grande do peso atual e um grid de botões 0-9 + Limpar +
/// Backspace. Eliminamos completamente o IME do Android para evitar
/// bypass de formatters por teclados de fabricante (Samsung, Xiaomi etc).
///
/// O [controller] continua sendo a fonte de verdade — é nele que os
/// helpers de save (`_parsePeso`, `parsePesoFormatado`) leem o texto.
/// Mantemos `controller.text` sempre no formato canônico `X,YY` ou ''.
class PesoKeypadField extends StatefulWidget {
  const PesoKeypadField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  @override
  State<PesoKeypadField> createState() => _PesoKeypadFieldState();
}

class _PesoKeypadFieldState extends State<PesoKeypadField> {
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      if (mounted) setState(() {});
    };
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  Future<void> _openKeypad() async {
    if (!widget.enabled) return;
    // Inicializa buffer a partir do valor atual.
    final atual = parsePesoFormatado(widget.controller.text);
    var digits = '';
    if (atual != null && atual > 0) {
      digits = (atual * 100).round().abs().toString();
      // Remove zeros à esquerda excedentes (mantém pelo menos 1 dígito).
      digits = digits.replaceFirst(RegExp(r'^0+'), '');
      if (digits.isEmpty) digits = '0';
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _PesoKeypadSheet(
        initialDigits: digits,
        title: widget.hintText ?? 'Peso',
      ),
    );

    if (result != null) {
      // result vem como string de dígitos ('' = limpar).
      if (result.isEmpty) {
        widget.controller.text = '';
      } else {
        final value = int.parse(result) / 100.0;
        widget.controller.text = formatPesoInicial(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (state) {
        // Sempre mantém o FormField sincronizado com o controller para
        // que validate() use o texto atual.
        if (state.value != widget.controller.text) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(widget.controller.text);
          });
        }

        final isEmpty = widget.controller.text.isEmpty;
        final hasError = state.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _openKeypad,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: Color(0xFFBEBEBE),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F1F1),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFFBEBEBE), width: 2.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF1E7A4C), width: 2.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: hasError
                            ? Theme.of(context).colorScheme.error
                            : const Color(0xFFBEBEBE),
                        width: 2.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.dialpad,
                      color: Color(0xFF1E7A4C), size: 22),
                ),
                isEmpty: isEmpty,
                child: Text(
                  isEmpty ? '' : widget.controller.text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PesoKeypadSheet extends StatefulWidget {
  const _PesoKeypadSheet({
    required this.initialDigits,
    required this.title,
  });

  final String initialDigits;
  final String title;

  @override
  State<_PesoKeypadSheet> createState() => _PesoKeypadSheetState();
}

class _PesoKeypadSheetState extends State<_PesoKeypadSheet> {
  late String _digits;

  @override
  void initState() {
    super.initState();
    _digits = widget.initialDigits;
  }

  String get _formatado {
    if (_digits.isEmpty) return '0,00';
    return PesoInputFormatter.formatDigits(_digits, false);
  }

  void _appendDigit(String d) {
    setState(() {
      var next = _digits + d;
      next = next.replaceFirst(RegExp(r'^0+'), '');
      if (next.length > 8) {
        next = next.substring(next.length - 8);
      }
      _digits = next;
    });
  }

  void _backspace() {
    setState(() {
      if (_digits.isNotEmpty) {
        _digits = _digits.substring(0, _digits.length - 1);
      }
    });
  }

  void _clear() {
    setState(() {
      _digits = '';
    });
  }

  void _confirm() {
    Navigator.of(context).pop(_digits);
  }

  Widget _buildDigitButton(String d) {
    return _KeyButton(
      label: d,
      onTap: () => _appendDigit(d),
      color: const Color(0xFFEFEFEF),
      textColor: Colors.black,
      bold: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Display
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '$_formatado kg',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E7A4C),
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Grid 4x3
            _KeypadRow(children: [
              _buildDigitButton('1'),
              _buildDigitButton('2'),
              _buildDigitButton('3'),
            ]),
            _KeypadRow(children: [
              _buildDigitButton('4'),
              _buildDigitButton('5'),
              _buildDigitButton('6'),
            ]),
            _KeypadRow(children: [
              _buildDigitButton('7'),
              _buildDigitButton('8'),
              _buildDigitButton('9'),
            ]),
            _KeypadRow(children: [
              _KeyButton(
                label: 'Limpar',
                onTap: _clear,
                color: const Color(0xFFE0E0E0),
                textColor: Colors.black87,
                fontSize: 14,
              ),
              _buildDigitButton('0'),
              _KeyButton(
                icon: Icons.backspace_outlined,
                onTap: _backspace,
                color: const Color(0xFFE0E0E0),
                textColor: Colors.black87,
              ),
            ]),
            const SizedBox(height: 12),
            // Confirmar
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E7A4C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _confirm,
                child: const Text(
                  'Confirmar',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeypadRow extends StatelessWidget {
  const _KeypadRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: children[i]),
          ],
        ],
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    this.label,
    this.icon,
    required this.onTap,
    required this.color,
    required this.textColor,
    this.bold = false,
    this.fontSize = 22,
  });

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool bold;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: icon != null
                ? Icon(icon, color: textColor, size: 24)
                : Text(
                    label ?? '',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
