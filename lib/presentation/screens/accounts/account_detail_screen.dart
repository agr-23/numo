import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/numo_palette.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/account.dart';
import '../../../data/models/app_settings.dart';
import '../../../providers/accounts_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../widgets/budget_progress_bar.dart';
import '../../widgets/category_icon.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/transaction_item.dart';
import 'widgets/add_account_sheet.dart';

class AccountDetailScreen extends ConsumerWidget {
  final int accountId;
  const AccountDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final account = ref.watch(accountByIdProvider(accountId)).valueOrNull;
    final txs = ref.watch(transactionsByAccountProvider(accountId));
    final settings = ref.watch(settingsProvider);
    final l10n = context.l10n;

    if (account == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.account)),
        body: EmptyState(icon: Icons.error_outline, message: l10n.accNotFound),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.accEdit,
            onPressed: () => AddAccountSheet.show(context, account: account),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Dimens.screenPaddingH, 8, Dimens.screenPaddingH, 24),
        children: [
          if (account.isCredit)
            _CreditSummary(account: account, settings: settings)
          else
            _BalanceSummary(account: account, settings: settings),
          const SizedBox(height: Dimens.sectionGap),
          Text(l10n.txTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          if (txs.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: EmptyState(
                  icon: Icons.receipt_long, message: l10n.accNoTransactions),
            )
          else
            ...txs.map(
              (t) => TransactionItem(
                transaction: t,
                onTap: () => context.push('/edit-transaction/${t.id}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  final Account account;
  final AppSettings settings;
  const _BalanceSummary({required this.account, required this.settings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.cardPadding),
        child: Row(
          children: [
            CategoryIcon(
              iconName: account.iconName,
              colorHex: account.colorHex,
              size: 52,
            ),
            const SizedBox(width: Dimens.cardPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.accBalanceAvailable,
                      style: theme.textTheme.bodySmall),
                  Text(
                    CurrencyFormatter.format(account.balance, settings),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: account.balance < 0 ? context.palette.expense : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Resumen de tarjeta: disponible, deuda, cupo, fechas y botón de pago.
class _CreditSummary extends StatelessWidget {
  final Account account;
  final AppSettings settings;
  const _CreditSummary({required this.account, required this.settings});

  String _fmt(double v) => CurrencyFormatter.format(v, settings);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final available = account.available;
    final statement = account.nextStatementDate;
    final payment = account.nextPaymentDate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CategoryIcon(
                  iconName: account.iconName,
                  colorHex: account.colorHex,
                  size: 52,
                ),
                const SizedBox(width: Dimens.cardPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(available != null ? l10n.accCreditAvailable : l10n.accCurrentDebt,
                          style: theme.textTheme.bodySmall),
                      Text(
                        _fmt(available ?? account.balance),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: available == null || available < 0
                              ? context.palette.expense
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (account.creditLimit != null) ...[
              const SizedBox(height: 16),
              BudgetProgressBar(
                  spent: account.balance, limit: account.creditLimit!),
              const SizedBox(height: 12),
              _row(theme, l10n.debt, _fmt(account.balance),
                  color: context.palette.expense),
              _row(theme, l10n.accCreditLimit, _fmt(account.creditLimit!)),
            ],
            const Divider(height: 24),
            _row(
              theme,
              l10n.accStatementDate,
              statement == null ? l10n.accNotSet : _dateLabel(statement, l10n),
            ),
            _row(
              theme,
              l10n.accPaymentDue,
              payment == null ? l10n.accNotSet : _dateLabel(payment, l10n),
              color: payment != null && _daysUntil(payment) <= 3
                  ? context.palette.warning
                  : null,
            ),
            if (statement == null || payment == null || account.creditLimit == null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.accCompleteHint,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.payments_outlined),
                label: Text(l10n.accPayCard),
                onPressed: () =>
                    context.push('/add-transfer?to=${account.id}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(
            value,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  static int _daysUntil(DateTime d) {
    final now = DateTime.now();
    return d.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  static String _dateLabel(DateTime d, AppLocalizations l10n) {
    final days = _daysUntil(d);
    final when = switch (days) {
      0 => l10n.todayLower,
      1 => l10n.tomorrow,
      _ => l10n.inDays(days),
    };
    return '${DateFormatter.shortDay(d)} · $when';
  }
}
