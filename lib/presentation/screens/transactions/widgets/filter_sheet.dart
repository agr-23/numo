import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/theme/app_colors.dart';
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
              Text('Filtros', style: theme.textTheme.titleLarge),
              TextButton(
                onPressed: notifier.clearFilters,
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text('Tipo', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _typeChip(context, ref, 'Todos', null, filter.type),
              _typeChip(context, ref, 'Gastos', TransactionType.expense, filter.type),
              _typeChip(context, ref, 'Ingresos', TransactionType.income, filter.type),
              _typeChip(context, ref, 'Transferencias', TransactionType.transfer, filter.type),
            ],
          ),
          const SizedBox(height: Dimens.sectionGap),

          Text('Categoría', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in categories)
                FilterChip(
                  label: Text(c.name),
                  selected: filter.categoryIds.contains(c.id),
                  onSelected: (_) => notifier.toggleCategory(c.id),
                ),
            ],
          ),
          const SizedBox(height: Dimens.sectionGap),

          Text('Cuenta', style: theme.textTheme.titleMedium),
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

          Text('Rango de fechas', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(
              filter.dateRange == null
                  ? 'Cualquier fecha'
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
              child: const Text('Quitar rango'),
            ),
          const SizedBox(height: Dimens.sectionGap),

          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aplicar filtros'),
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
