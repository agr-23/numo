import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/numo_palette.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../providers/budgets_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../widgets/budget_progress_bar.dart';
import '../../../widgets/category_icon.dart';

/// Presupuestos del mes en dos columnas (hasta 4) en el Inicio.
class BudgetsGrid extends ConsumerWidget {
  const BudgetsGrid({super.key});

  static const _max = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final views = ref.watch(budgetViewsProvider).take(_max).toList();
    if (views.isEmpty) return const _CreateBudgetCard();

    return LayoutBuilder(builder: (context, constraints) {
      final width = (constraints.maxWidth - 10) / 2;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final v in views)
            SizedBox(width: width, child: _BudgetTile(view: v)),
        ],
      );
    });
  }
}

class _BudgetTile extends ConsumerWidget {
  final BudgetView view;
  const _BudgetTile({required this.view});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final alert = view.progress > 0.8;
    final label = view.isExceeded
        ? l10n.budExceeded
        : view.isNearLimit
            ? l10n.budNearLimit
            : l10n.amountOf(CurrencyFormatter.format(view.spent, settings),
                CurrencyFormatter.format(view.limit, settings));

    return Material(
      color: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        side: BorderSide(color: p.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/budgets'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CategoryIcon(
                      iconName: view.category?.iconName ?? 'more_horiz',
                      size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      categoryLabel(view.category, l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.rowTitle
                          .copyWith(fontSize: 13, color: p.ink),
                    ),
                  ),
                  Text(
                    '${(view.progress * 100).round()}%',
                    style: AppTextStyles.labelFrom(12)
                        .copyWith(color: alert ? p.expense : p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BudgetProgressBar(spent: view.spent, limit: view.limit),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption
                    .copyWith(color: alert ? p.expense : p.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateBudgetCard extends StatelessWidget {
  const _CreateBudgetCard();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return OutlinedButton.icon(
      onPressed: () => context.push('/add-budget'),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: Text(context.l10n.dashCreateBudget),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: p.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
        ),
      ),
    );
  }
}
