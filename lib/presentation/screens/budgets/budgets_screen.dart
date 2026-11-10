import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/transaction.dart';
import '../../../providers/budgets_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../widgets/budget_card.dart';
import '../../widgets/budget_progress_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/transaction_item.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final month = ref.watch(budgetMonthProvider);
    final views = ref.watch(budgetViewsProvider);
    final summary = ref.watch(budgetSummaryProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Presupuestos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-budget'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Selector de mes
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.screenPaddingH, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(ref, -1),
                ),
                Text(DateFormatter.monthYear(month),
                    style: theme.textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeMonth(ref, 1),
                ),
              ],
            ),
          ),
          Expanded(
            child: views.isEmpty
                ? EmptyState(
                    icon: Icons.pie_chart_outline,
                    message: 'Sin presupuestos para este mes',
                    actionLabel: 'Crear presupuesto',
                    onAction: () => context.push('/add-budget'),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                        Dimens.screenPaddingH, 4, Dimens.screenPaddingH, 96),
                    children: [
                      _summaryCard(theme, summary, settings),
                      const SizedBox(height: Dimens.sectionGap),
                      for (final v in views)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: Dimens.itemGap),
                          child: Dismissible(
                            key: ValueKey('budget-${v.budget.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColors.expense,
                                borderRadius:
                                    BorderRadius.circular(Dimens.cardRadius),
                              ),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (_) =>
                                _confirmDelete(context, v.category?.name ?? ''),
                            onDismissed: (_) async {
                              await ref
                                  .read(budgetRepositoryProvider)
                                  .delete(v.budget.id);
                              HapticFeedback.mediumImpact();
                            },
                            child: BudgetCard(
                              view: v,
                              onTap: () =>
                                  _showCategoryTransactions(context, ref, v),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _changeMonth(WidgetRef ref, int delta) {
    final current = ref.read(budgetMonthProvider);
    ref.read(budgetMonthProvider.notifier).state =
        DateTime(current.year, current.month + delta);
  }

  Widget _summaryCard(
      ThemeData theme, BudgetSummary summary, AppSettings settings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow('Total presupuestado',
              CurrencyFormatter.format(summary.total, settings)),
          const SizedBox(height: 6),
          _summaryRow(
              'Gastado', CurrencyFormatter.format(summary.spent, settings)),
          const SizedBox(height: 6),
          _summaryRow('Disponible',
              CurrencyFormatter.format(summary.available, settings),
              highlight: true),
          const SizedBox(height: 14),
          BudgetProgressBar(spent: summary.spent, limit: summary.total),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
        Text(value,
            style: TextStyle(
                color: highlight ? AppColors.accent : Colors.white,
                fontSize: highlight ? 18 : 15,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String name) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar presupuesto'),
        content: Text('¿Eliminar el presupuesto de "$name"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    return result ?? false;
  }

  void _showCategoryTransactions(
      BuildContext context, WidgetRef ref, BudgetView view) {
    final all = ref.read(transactionsProvider).valueOrNull ?? const [];
    final month = ref.read(budgetMonthProvider);
    final items = all
        .where((t) =>
            t.type == TransactionType.expense &&
            t.category.value?.id == view.category?.id &&
            t.date.year == month.year &&
            t.date.month == month.month)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(Dimens.screenPaddingH),
          children: [
            Text('${view.category?.name ?? 'Categoría'} · ${DateFormatter.monthYear(month)}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: EmptyState(
                    icon: Icons.receipt_long,
                    message: 'Sin gastos en esta categoría'),
              )
            else
              ...items.map((t) => TransactionItem(transaction: t)),
          ],
        ),
      ),
    );
  }
}
