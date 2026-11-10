import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../providers/budgets_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../widgets/budget_progress_bar.dart';
import '../../../widgets/category_icon.dart';

/// Tira horizontal de presupuestos del mes actual en el dashboard.
class BudgetsStrip extends ConsumerWidget {
  const BudgetsStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final views = ref.watch(budgetViewsProvider);
    final settings = ref.watch(settingsProvider);
    final l10n = context.l10n;

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: views.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          if (i == views.length) {
            return _AddBudgetCard(onTap: () => context.push('/add-budget'));
          }
          final v = views[i];
          Color border = Theme.of(context).dividerColor;
          String? badge;
          if (v.isExceeded) {
            border = AppColors.expense;
            badge = l10n.budExceeded;
          } else if (v.isNearLimit) {
            border = AppColors.warning;
            badge = l10n.budNearLimit;
          }
          return InkWell(
            onTap: () => context.push('/budgets'),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CategoryIcon(
                        iconName: v.category?.iconName ?? 'category',
                        colorHex: v.category?.colorHex ?? '#9CA3AF',
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          v.category == null ? '—' : categoryLabel(v.category, l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  BudgetProgressBar(spent: v.spent, limit: v.limit),
                  const SizedBox(height: 6),
                  Text(
                    badge ??
                        l10n.amountOf(CurrencyFormatter.format(v.spent, settings),
                            CurrencyFormatter.format(v.limit, settings)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: badge != null ? border : null,
                          fontWeight:
                              badge != null ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddBudgetCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddBudgetCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: AppColors.accent),
            const SizedBox(height: 4),
            Text(context.l10n.budShort, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
