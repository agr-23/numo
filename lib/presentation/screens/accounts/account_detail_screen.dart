import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
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

    if (account == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cuenta')),
        body: const EmptyState(
            icon: Icons.error_outline, message: 'Cuenta no encontrada'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar cuenta',
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
          Text('Movimientos', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          if (txs.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: EmptyState(
                  icon: Icons.receipt_long,
                  message: 'Esta cuenta no tiene movimientos'),
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
                  Text('Saldo disponible', style: theme.textTheme.bodySmall),
                  Text(
                    CurrencyFormatter.format(account.balance, settings),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: account.balance < 0 ? AppColors.expense : null,
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
                      Text(available != null ? 'Cupo disponible' : 'Deuda actual',
                          style: theme.textTheme.bodySmall),
                      Text(
                        _fmt(available ?? account.balance),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: available == null || available < 0
                              ? AppColors.expense
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
              _row(theme, 'Deuda', _fmt(account.balance),
                  color: AppColors.expense),
              _row(theme, 'Cupo total', _fmt(account.creditLimit!)),
            ],
            const Divider(height: 24),
            _row(
              theme,
              'Fecha de corte',
              statement == null ? 'Sin configurar' : _dateLabel(statement),
            ),
            _row(
              theme,
              'Límite de pago',
              payment == null ? 'Sin configurar' : _dateLabel(payment),
              color: payment != null && _daysUntil(payment) <= 3
                  ? AppColors.warning
                  : null,
            ),
            if (statement == null || payment == null || account.creditLimit == null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Toca el lápiz de arriba para completar cupo y fechas.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.payments_outlined),
                label: const Text('Pagar tarjeta'),
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

  static String _dateLabel(DateTime d) {
    final days = _daysUntil(d);
    final when = switch (days) {
      0 => 'hoy',
      1 => 'mañana',
      _ => 'en $days días',
    };
    return '${DateFormatter.shortDay(d)} · $when';
  }
}
