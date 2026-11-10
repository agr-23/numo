import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/currencies.dart';
import '../../core/utils/amount_input.dart';
import '../../providers/settings_provider.dart';

/// Campo de monto con separadores de miles en vivo y símbolo de la moneda.
/// Usa la moneda de los ajustes salvo que se pase [currency] (onboarding).
/// Para leer el valor: `AmountInput.of(code).parse(controller.text)`.
class AmountField extends ConsumerWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? helper;
  final CurrencyOption? currency;
  final bool autofocus;

  const AmountField({
    super.key,
    required this.controller,
    required this.label,
    this.hint = '0',
    this.helper,
    this.currency,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final option = currency ?? currencyByCode(settings.currency);
    final rules = AmountInput.of(option.code);

    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: TextInputType.numberWithOptions(
        decimal: rules.decimals > 0,
      ),
      inputFormatters: [rules.formatter],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helper,
        prefixText: option.symbolBefore ? '${option.symbol} ' : null,
        suffixText: option.symbolBefore ? null : ' ${option.symbol}',
      ),
    );
  }
}
