import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/numo_palette.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/transaction.dart';
import '../../providers/settings_provider.dart';

/// Monto formateado según la moneda configurada.
///
/// En el diseño Nítido los gastos van en tinta (lo normal), los ingresos
/// en verde (la buena noticia) y las transferencias en tinta tenue.
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
    final p = context.palette;

    String text;
    if (showSign && type == TransactionType.income) {
      text = CurrencyFormatter.signed(amount, settings, isIncome: true);
    } else if (showSign && type == TransactionType.expense) {
      // Signo menos tipográfico (−) en vez del guion.
      text = '−${CurrencyFormatter.format(amount.abs(), settings)}';
    } else {
      text = CurrencyFormatter.format(amount, settings);
    }

    final color = switch (type) {
      TransactionType.income => p.income,
      TransactionType.transfer => p.inkMuted,
      _ => null,
    };
    final base = style ?? AppTextStyles.rowAmount.copyWith(color: p.ink);
    return Text(text, style: base.copyWith(color: color ?? base.color));
  }
}
