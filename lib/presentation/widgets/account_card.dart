import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/numo_palette.dart';
import '../../core/l10n/l10n.dart';
import '../../core/constants/dimens.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/account.dart';
import '../../providers/settings_provider.dart';
import 'amount_display.dart';
import 'budget_progress_bar.dart';
import 'category_icon.dart';

class AccountCard extends ConsumerWidget {
  final Account account;
  final VoidCallback? onTap;

  const AccountCard({super.key, required this.account, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final available = account.available;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.cardPadding),
          child: Column(
            children: [
              Row(
                children: [
                  CategoryIcon(
                      iconName: account.iconName, colorHex: account.colorHex),
                  const SizedBox(width: Dimens.cardPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(account.name, style: theme.textTheme.bodyLarge),
                        Text(accountTypeLabel(account.type, l10n),
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (account.isCredit && available != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AmountDisplay(
                          amount: available,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: available < 0 ? context.palette.expense : null,
                          ),
                        ),
                        Text(l10n.available, style: theme.textTheme.bodySmall),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AmountDisplay(
                          amount: account.balance,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: account.isCredit || account.balance < 0
                                ? context.palette.expense
                                : theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        if (account.isCredit)
                          Text(l10n.debt,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: context.palette.expense)),
                      ],
                    ),
                ],
              ),
              if (account.isCredit && account.creditLimit != null) ...[
                const SizedBox(height: 12),
                BudgetProgressBar(
                    spent: account.balance, limit: account.creditLimit!),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.accDebtAmount(
                          CurrencyFormatter.format(account.balance, settings)),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: context.palette.expense),
                    ),
                    Text(
                      l10n.accLimitAmount(CurrencyFormatter.format(
                          account.creditLimit!, settings)),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
