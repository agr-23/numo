import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../providers/accounts_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/transaction_item.dart';
import 'widgets/budgets_strip.dart';
import 'widgets/overview_carousel.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final net = ref.watch(netBalanceProvider);
    final recent = ref.watch(recentTransactionsProvider(5));
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Dimens.screenPaddingH, 12, Dimens.screenPaddingH, 96),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormatter.greeting(now),
                        style: theme.textTheme.titleMedium),
                    Text(DateFormatter.longDay(now),
                        style: theme.textTheme.bodySmall),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
            const SizedBox(height: Dimens.cardPadding),
            const OverviewCarousel(),
            const SizedBox(height: Dimens.sectionGap),

            // Presupuestos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Presupuestos', style: theme.textTheme.titleMedium),
                TextButton(
                  onPressed: () => context.push('/budgets'),
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const BudgetsStrip(),
            const SizedBox(height: Dimens.sectionGap),

            // Acceso a metas de ahorro
            Card(
              child: ListTile(
                leading: const Icon(Icons.savings, color: AppColors.accent),
                title: const Text('Metas de ahorro'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/savings-goals'),
              ),
            ),
            const SizedBox(height: Dimens.sectionGap),

            // Últimos movimientos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Últimos movimientos', style: theme.textTheme.titleMedium),
                TextButton(
                  onPressed: () => context.go('/home/transactions'),
                  child: const Text('Ver todos →'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (recent.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: EmptyState(
                  icon: Icons.receipt_long,
                  message: 'Aún no hay movimientos',
                ),
              )
            else
              ...recent.map(
                (t) => TransactionItem(
                  transaction: t,
                  onTap: () => context.push('/edit-transaction/${t.id}'),
                ),
              ),
            if (recent.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Balance neto: ${CurrencyFormatter.format(net, settings)}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
