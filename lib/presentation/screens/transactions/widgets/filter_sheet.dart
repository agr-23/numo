import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/transaction.dart';
import '../../../../providers/accounts_provider.dart';
import '../../../../providers/categories_provider.dart';
import '../../../../providers/transaction_filter_provider.dart';

/// Bottom sheet de filtros para la lista de movimientos.
class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(transactionFilterProvider);
    final notifier = ref.read(transactionFilterProvider.notifier);
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      builder: (_, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(Dimens.screenPaddingH),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.filters, style: theme.textTheme.titleLarge),
              TextButton(
                onPressed: notifier.clearFilters,
                child: Text(l10n.clear),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(l10n.type, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _typeChip(context, ref, l10n.all, null, filter.type),
              _typeChip(context, ref, l10n.expenses, TransactionType.expense, filter.type),
              _typeChip(context, ref, l10n.incomes, TransactionType.income, filter.type),
              _typeChip(context, ref, l10n.transfers, TransactionType.transfer, filter.type),
            ],
          ),
          const SizedBox(height: Dimens.sectionGap),

          Text(l10n.category, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in categories)
                FilterChip(
                  label: Text(categoryLabel(c, l10n)),
                  selected: filter.categoryIds.contains(c.id),
                  onSelected: (_) => notifier.toggleCategory(c.id),
                ),
            ],
          ),
          const SizedBox(height: Dimens.sectionGap),

          Text(l10n.account, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in accounts)
                FilterChip(
                  label: Text(a.name),
                  selected: filter.accountIds.contains(a.id),
                  onSelected: (_) => notifier.toggleAccount(a.id),
                ),
            ],
          ),
          const SizedBox(height: Dimens.sectionGap),

          Text(l10n.dateRange, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(
              filter.dateRange == null
                  ? l10n.anyDate
                  : '${DateFormatter.shortDay(filter.dateRange!.start)} — ${DateFormatter.shortDay(filter.dateRange!.end)}',
            ),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2015),
                lastDate: DateTime(2100),
                initialDateRange: filter.dateRange,
              );
              if (range != null) notifier.setDateRange(range);
            },
          ),
          if (filter.dateRange != null)
            TextButton(
              onPressed: () => notifier.setDateRange(null),
              child: Text(l10n.removeRange),
            ),
          const SizedBox(height: Dimens.sectionGap),

          FilledButton(
            style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(Dimens.buttonHeight)),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.applyFilters),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _typeChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    TransactionType? type,
    TransactionType? current,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: current == type,
      onSelected: (_) => ref.read(transactionFilterProvider.notifier).setType(type),
    );
  }
}
