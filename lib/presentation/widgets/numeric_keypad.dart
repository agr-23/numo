import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_text_styles.dart';

/// Teclado numérico custom de 12 botones (1-9, ., 0, ⌫).
class NumericKeypad extends StatelessWidget {
  final bool showDecimal;

  /// Cómo se muestra la tecla decimal (',' en COP/EUR, '.' en USD).
  /// Siempre emite '.' a [onDigit].
  final String decimalLabel;
  final void Function(String digit) onDigit;
  final VoidCallback onBackspace;
  final Color accentColor;

  const NumericKeypad({
    super.key,
    required this.showDecimal,
    this.decimalLabel = '.',
    required this.onDigit,
    required this.onBackspace,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1', '2', '3', //
      '4', '5', '6', //
      '7', '8', '9', //
      showDecimal ? decimalLabel : '', '0', '⌫', //
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.9,
      children: keys.map((k) => _key(context, k)).toList(),
    );
  }

  Widget _key(BuildContext context, String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    final isBackspace = label == '⌫';
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        HapticFeedback.selectionClick();
        if (isBackspace) {
          onBackspace();
        } else {
          onDigit(label == decimalLabel ? '.' : label);
        }
      },
      child: Center(
        child: isBackspace
            ? Icon(Icons.backspace_outlined, color: accentColor)
            : Text(label, style: AppTextStyles.keypadDigit),
      ),
    );
  }
}
