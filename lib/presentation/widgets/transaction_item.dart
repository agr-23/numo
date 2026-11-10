import 'package:flutter/material.dart';

import '../../core/constants/dimens.dart';
import '../../core/theme/app_colors.dart';
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
    final theme = Theme.of(context);
    final isTransfer = transaction.type == TransactionType.transfer;
    final category = transaction.category.value;
    final account = transaction.account.value;

    final iconName = isTransfer ? 'payments' : (category?.iconName ?? 'category');
    final colorHex =
        isTransfer ? '#3B82F6' : (category?.colorHex ?? '#9CA3AF');

    final subtitle = isTransfer
        ? '${account?.name ?? '—'} → ${transaction.toAccount.value?.name ?? '—'}'
        : [category?.name, account?.name]
            .where((e) => e != null && e.isNotEmpty)
            .join(' · ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.chipRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            CategoryIcon(iconName: iconName, colorHex: colorHex),
            const SizedBox(width: Dimens.cardPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          transaction.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      if (transaction.isRecurring ||
                          transaction.parentRecurringId != null) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.repeat,
                            size: 14, color: theme.textTheme.bodySmall?.color),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  if (transaction.note != null &&
                      transaction.note!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      transaction.note!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Dimens.itemGap),
            AmountDisplay(
              amount: transaction.amount,
              type: transaction.type,
              showSign: !isTransfer,
              style: isTransfer
                  ? theme.textTheme.bodyLarge
                      ?.copyWith(color: AppColors.transfer, fontWeight: FontWeight.w700)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
