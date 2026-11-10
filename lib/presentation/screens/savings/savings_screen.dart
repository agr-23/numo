import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/pocket_math.dart';
import '../../../providers/savings_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/budget_progress_bar.dart';
import '../../widgets/empty_state.dart';
import 'widgets/group_sheet.dart';

/// Ahorros: total apartado y los grupos (Carro, Viaje…).
class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final views = ref.watch(groupViewsProvider);
    final overview = ref.watch(savingsOverviewProvider);
    String fmt(double v) => CurrencyFormatter.format(v, settings);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.svTitle),
        actions: [
          IconButton(
            tooltip: l10n.svNewGroup,
            icon: const Icon(Icons.add_rounded),
            onPressed: () => GroupSheet.show(context),
          ),
        ],
      ),
      body: views.isEmpty
          ? EmptyState(
              icon: Icons.savings_outlined,
              message: l10n.svEmpty,
              actionLabel: l10n.svCreateGroup,
              onAction: () => GroupSheet.show(context),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                  Dimens.screenPaddingH, 8, Dimens.screenPaddingH, 24),
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                  decoration: BoxDecoration(
                    color: p.ink,
                    borderRadius: BorderRadius.circular(Dimens.heroRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.svTotalSetAside,
                          style: AppTextStyles.captionStrong.copyWith(
                              fontSize: 13,
                              color: p.onInk.withValues(alpha: 0.7))),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(fmt(overview.saved),
                            style: AppTextStyles.amountHero
                                .copyWith(color: p.onInk)),
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.svOfTotal(fmt(overview.target), views.length),
                          style: AppTextStyles.caption.copyWith(
                              fontSize: 13,
                              color: p.onInk.withValues(alpha: 0.7))),
                      const SizedBox(height: 14),
                      BudgetProgressBar(
                        spent: overview.saved,
                        limit: overview.target,
                        color: p.onInk,
                        trackColor: p.onInk.withValues(alpha: 0.18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(l10n.svGroups,
                        style: AppTextStyles.section.copyWith(color: p.ink)),
                    const Spacer(),
                    Text(l10n.svTapGroup,
                        style: AppTextStyles.caption
                            .copyWith(fontSize: 13, color: p.inkMuted)),
                  ],
                ),
                const SizedBox(height: 10),
                for (final v in views) ...[
                  _GroupCard(view: v, fmt: fmt),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => GroupSheet.show(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.svCreateGroup),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(Dimens.buttonHeight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.cardRadius)),
                  ),
                ),
              ],
            ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupView view;
  final String Function(double) fmt;
  const _GroupCard({required this.view, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final urgent = view.mostUrgent;
    final (hint, hintColor) = urgent != null
        ? (
            l10n.svDueHint(urgent.name, DateFormatter.shortDay(urgent.dueDate!),
                fmt(PocketMath.remaining(urgent))),
            PocketMath.isDueSoon(urgent, DateTime.now()) ? p.expense : p.inkMuted
          )
        : view.allDone
            ? (l10n.svAllDone, p.income)
            : (null, p.inkMuted);

    return Material(
      color: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        side: BorderSide(color: p.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/savings-group/${view.group.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration:
                        BoxDecoration(color: p.linkSoft, shape: BoxShape.circle),
                    child: Icon(AppIcons.resolve(view.group.iconName),
                        size: 20, color: p.link),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(view.group.name,
                            style: AppTextStyles.labelFrom(15)
                                .copyWith(color: p.ink)),
                        Text(l10n.svPocketCount(view.pockets.length),
                            style: AppTextStyles.caption
                                .copyWith(color: p.inkMuted)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(fmt(view.saved),
                          style:
                              AppTextStyles.labelFrom(15).copyWith(color: p.ink)),
                      Text(l10n.svOfAmount(fmt(view.target)),
                          style: AppTextStyles.caption
                              .copyWith(color: p.inkMuted)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BudgetProgressBar(
                  spent: view.saved, limit: view.target, color: p.ink),
              if (hint != null) ...[
                const SizedBox(height: 10),
                Text(hint,
                    style: AppTextStyles.captionStrong.copyWith(color: hintColor)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
