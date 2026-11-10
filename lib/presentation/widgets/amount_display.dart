import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/transaction.dart';
import '../../providers/settings_provider.dart';

/// Muestra un monto formateado según la moneda configurada, con color y
/// signo opcional acorde al tipo de movimiento.
class AmountDisplay extends ConsumerWidget {
  final double amount;
  final TransactionType? type;
  final bool showSign;
  final TextStyle? style;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.type,
    this.showSign = false,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final color = _colorFor(type);

    String text;
    if (showSign && type != null) {
      switch (type!) {
        case TransactionType.income:
          text = CurrencyFormatter.signed(amount, settings, isIncome: true);
          break;
        case TransactionType.expense:
          text = CurrencyFormatter.signed(amount, settings, isIncome: false);
          break;
        case TransactionType.transfer:
          text = CurrencyFormatter.format(amount, settings);
          break;
      }
    } else {
      text = CurrencyFormatter.format(amount, settings);
    }

    final baseStyle = style ?? Theme.of(context).textTheme.bodyLarge!;
    return Text(
      text,
      style: baseStyle.copyWith(
        color: color ?? baseStyle.color,
        fontWeight: type != null ? FontWeight.w700 : baseStyle.fontWeight,
      ),
    );
  }

  Color? _colorFor(TransactionType? type) {
    switch (type) {
      case TransactionType.income:
        return AppColors.income;
      case TransactionType.expense:
        return AppColors.expense;
      case TransactionType.transfer:
        return AppColors.transfer;
      case null:
        return null;
    }
  }
}
