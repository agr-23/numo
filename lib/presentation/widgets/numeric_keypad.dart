import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/numo_palette.dart';

/// Teclado numérico de 12 teclas: 1-9, decimal (o 000), 0 y borrar.
class NumericKeypad extends StatelessWidget {
  final bool showDecimal;

  /// Cómo se muestra la tecla decimal (',' en COP/EUR, '.' en USD).
  /// Siempre emite '.' a [onDigit].
  final String decimalLabel;
  final void Function(String digit) onDigit;
  final VoidCallback onBackspace;

  const NumericKeypad({
    super.key,
    required this.showDecimal,
    this.decimalLabel = '.',
    required this.onDigit,
    required this.onBackspace,
  });

  static const _backspace = 'del';

  @override
  Widget build(BuildContext context) {
    // Sin decimales (COP, CLP) la tecla libre se usa para "000", que
    // acelera escribir montos grandes.
    final keys = [
      '1', '2', '3', //
      '4', '5', '6', //
      '7', '8', '9', //
      showDecimal ? decimalLabel : '000', '0', _backspace, //
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      childAspectRatio: 2.3,
      children: [for (final k in keys) _key(context, k)],
    );
  }

  Widget _key(BuildContext context, String label) {
    final p = context.palette;
    final isBackspace = label == _backspace;
    return Material(
      color: p.surfaceMuted,
      borderRadius: BorderRadius.circular(Dimens.chipRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.chipRadius),
        onTap: () {
          HapticFeedback.selectionClick();
          if (isBackspace) {
            onBackspace();
          } else if (label == '000') {
            for (var i = 0; i < 3; i++) {
              onDigit('0');
            }
          } else {
            onDigit(label == decimalLabel ? '.' : label);
          }
        },
        child: Center(
          child: isBackspace
              ? Icon(Icons.backspace_outlined, color: p.ink, size: 22)
              : Text(label,
                  style: AppTextStyles.keypadDigit.copyWith(color: p.ink)),
        ),
      ),
    );
  }
}
