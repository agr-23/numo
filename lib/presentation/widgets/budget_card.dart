import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/dimens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/budgets_provider.dart';
import '../../providers/settings_provider.dart';
import 'budget_progress_bar.dart';
import 'category_icon.dart';

class BudgetCard extends ConsumerWidget {
  final BudgetView view;
  final VoidCallback? onTap;

  const BudgetCard({super.key, required this.view, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final cat = view.category;

    Color borderColor = theme.dividerColor;
    if (view.isExceeded) {
      borderColor = AppColors.expense;
    } else if (view.isNearLimit) {
      borderColor = AppColors.warning;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        side: BorderSide(
          color: borderColor,
          width: view.isExceeded || view.isNearLimit ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CategoryIcon(
                    iconName: cat?.iconName ?? 'category',
                    colorHex: cat?.colorHex ?? '#9CA3AF',
                    size: 38,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(cat?.name ?? 'Categoría',
                        style: theme.textTheme.bodyLarge),
                  ),
                  if (view.isExceeded)
                    _badge('Excedido', AppColors.expense)
                  else if (view.isNearLimit)
                    _badge('Cerca del límite', AppColors.warning),
                ],
              ),
              const SizedBox(height: 12),
              BudgetProgressBar(spent: view.spent, limit: view.limit),
              const SizedBox(height: 8),
              Text(
                'Gastado ${CurrencyFormatter.format(view.spent, settings)} de ${CurrencyFormatter.format(view.limit, settings)}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Dimens.chipRadius),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
