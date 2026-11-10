import 'package:flutter/material.dart';

import '../../core/constants/dimens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/numo_palette.dart';
import '../../data/models/transaction.dart';
import 'amount_display.dart';
import 'category_icon.dart';

/// Fila de un movimiento en las listas.
class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final isTransfer = transaction.type == TransactionType.transfer;
    final category = transaction.category.value;
    final account = transaction.account.value;

    final iconName = isTransfer
        ? 'payments'
        : (category?.iconName ?? 'more_horiz');
    // "Comida, con Bancolombia" / "Bancolombia → Visa Oro"
    final subtitle = isTransfer
        ? '${account?.name ?? '—'} → ${transaction.toAccount.value?.name ?? '—'}'
        : [
            categoryLabel(category, l10n),
            account?.name,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
    final isRecurring =
        transaction.isRecurring || transaction.parentRecurringId != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.chipRadius),
      child: SizedBox(
        height: Dimens.rowHeight,
        child: Row(
          children: [
            CategoryIcon(iconName: iconName),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          transaction.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.rowTitle.copyWith(color: p.ink),
                        ),
                      ),
                      if (isRecurring) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.repeat, size: 13, color: p.inkHint),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.note?.isNotEmpty == true
                        ? '$subtitle. ${transaction.note}'
                        : subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: p.inkMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimens.itemGap),
            AmountDisplay(
              amount: transaction.amount,
              type: transaction.type,
              showSign: !isTransfer,
            ),
          ],
        ),
      ),
    );
  }
}
