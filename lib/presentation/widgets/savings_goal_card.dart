import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/constants/dimens.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/savings_goal.dart';
import '../../providers/settings_provider.dart';
import 'category_icon.dart';

class SavingsGoalCard extends ConsumerWidget {
  final SavingsGoal goal;
  final VoidCallback onContribute;

  const SavingsGoalCard({
    super.key,
    required this.goal,
    required this.onContribute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final l10n = context.l10n;
    final ratio = goal.targetAmount <= 0
        ? 0.0
        : (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final color = AppColors.fromHex(goal.colorHex);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CategoryIcon(iconName: goal.iconName, colorHex: goal.colorHex),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(goal.name, style: theme.textTheme.bodyLarge),
                ),
                if (goal.isCompleted)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.income.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(Dimens.chipRadius),
                    ),
                    child: Text(l10n.goalCompleted,
                        style: const TextStyle(
                            color: AppColors.income,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ratio),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: theme.dividerColor,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.goalSavedOf(
                      CurrencyFormatter.format(goal.currentAmount, settings),
                      CurrencyFormatter.format(goal.targetAmount, settings)),
                  style: theme.textTheme.bodySmall,
                ),
                Text('${(ratio * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            if (goal.targetDate != null && !goal.isCompleted) ...[
              const SizedBox(height: 4),
              Text(_daysRemaining(goal.targetDate!, l10n),
                  style: theme.textTheme.bodySmall),
            ],
            if (!goal.isCompleted) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: onContribute,
                  child: Text(l10n.goalContribute),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _daysRemaining(DateTime target, AppLocalizations l10n) {
    final now = DateTime.now();
    final days = DateTime(target.year, target.month, target.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (days < 0) return l10n.goalOverdue;
    if (days == 0) return l10n.goalDueToday;
    return l10n.goalDaysLeft(days);
  }
}
