import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/constants/savings_templates.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/pocket_math.dart';
import '../../../data/models/pocket.dart';
import '../../../providers/savings_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/budget_progress_bar.dart';
import 'widgets/group_sheet.dart';
import 'widgets/money_sheet.dart';
import 'widgets/pocket_sheet.dart';

/// Detalle de un grupo: total, bolsillos por tipo y acciones.
class GroupScreen extends ConsumerStatefulWidget {
  final int groupId;
  const GroupScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _celebrateIf(bool? completed) {
    if (completed == true) {
      HapticFeedback.heavyImpact();
      _confetti.play();
    }
  }

  Future<void> _contributeAny(GroupView view) async {
    if (view.pockets.length == 1) {
      _celebrateIf(await MoneySheet.contribute(context, view.pockets.first));
      return;
    }
    final pocket = await showModalBottomSheet<Pocket>(
      context: context,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          children: [
            for (final p in view.pockets)
              ListTile(
                leading: Icon(AppIcons.resolve(p.iconName)),
                title: Text(p.name),
                onTap: () => Navigator.of(sheet).pop(p),
              ),
          ],
        ),
      ),
    );
    if (pocket != null && mounted) {
      _celebrateIf(await MoneySheet.contribute(context, pocket));
    }
  }

  Future<void> _pocketActions(Pocket pocket) async {
    final l10n = context.l10n;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_rounded),
              title: Text(l10n.goalContribute),
              onTap: () => Navigator.of(sheet).pop('add'),
            ),
            if (pocket.savedAmount > 0)
              ListTile(
                leading: const Icon(Icons.remove_rounded),
                title: Text(l10n.svWithdraw),
                onTap: () => Navigator.of(sheet).pop('withdraw'),
              ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.svEditPocket),
              onTap: () => Navigator.of(sheet).pop('edit'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case 'add':
        _celebrateIf(await MoneySheet.contribute(context, pocket));
      case 'withdraw':
        await MoneySheet.withdraw(context, pocket);
      case 'edit':
        await PocketSheet.show(context, groupId: pocket.groupId, pocket: pocket);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final view = ref.watch(groupViewProvider(widget.groupId));
    String fmt(double v) => CurrencyFormatter.format(v, settings);

    if (view == null) {
      return Scaffold(appBar: AppBar());
    }

    final template = templateByKey(view.group.templateKey);
    final existing = view.pockets.map((x) => x.name.toLowerCase()).toSet();
    final suggestions = template == null
        ? const <PocketSeed>[]
        : template.pockets
            .where((s) => !existing.contains(s.label(l10n).toLowerCase()))
            .toList();

    final sections = [
      (PocketKind.monthly, l10n.svSectionMonthly),
      (PocketKind.yearly, l10n.svSectionYearly),
      (PocketKind.goal, l10n.svSectionGoals),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(view.group.name),
        actions: [
          IconButton(
            tooltip: l10n.svEditGroup,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => GroupSheet.show(context, group: view.group),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(
                Dimens.screenPaddingH, 8, Dimens.screenPaddingH, 32),
            children: [
              Text(l10n.svSetAside,
                  style: AppTextStyles.caption
                      .copyWith(fontSize: 13, color: p.inkMuted)),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(fmt(view.saved),
                    style: AppTextStyles.amountHero.copyWith(color: p.ink)),
              ),
              Text(l10n.svOfPockets(fmt(view.target), view.pockets.length),
                  style: AppTextStyles.caption
                      .copyWith(fontSize: 13, color: p.inkMuted)),
              const SizedBox(height: 12),
              BudgetProgressBar(
                  spent: view.saved, limit: view.target, color: p.ink),
              if (view.pockets.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _contributeAny(view),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(l10n.goalContribute),
                        style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            textStyle: AppTextStyles.labelFrom(14)),
                      ),
                    ),
                    if (view.pockets.length > 1) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async => _celebrateIf(
                              await MoneySheet.distribute(context, view)),
                          child: Text(l10n.svDistribute),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              for (final (kind, title) in sections)
                if (view.ofKind(kind).isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Text(title,
                      style: AppTextStyles.section.copyWith(color: p.ink)),
                  const SizedBox(height: 4),
                  for (final pocket in view.ofKind(kind))
                    _PocketRow(
                      pocket: pocket,
                      fmt: fmt,
                      onTap: () => _pocketActions(pocket),
                    ),
                  if (kind == PocketKind.monthly) ...[
                    const SizedBox(height: 6),
                    Text(l10n.svMonthlyNote,
                        style: AppTextStyles.caption.copyWith(color: p.inkMuted)),
                  ],
                ],
              if (suggestions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(l10n.svSuggestions,
                    style: AppTextStyles.section.copyWith(color: p.ink)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in suggestions)
                      ActionChip(
                        avatar: Icon(AppIcons.resolve(s.iconName), size: 16),
                        label: Text(s.label(l10n)),
                        onPressed: () => PocketSheet.show(context,
                            groupId: view.group.id, seed: s),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () =>
                    PocketSheet.show(context, groupId: view.group.id),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.svAddPocket),
                style: TextButton.styleFrom(
                    textStyle: AppTextStyles.labelFrom(15)),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirection: math.pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 8,
              gravity: 0.2,
              colors: AppColors.palette,
            ),
          ),
        ],
      ),
    );
  }
}

class _PocketRow extends StatelessWidget {
  final Pocket pocket;
  final String Function(double) fmt;
  final VoidCallback onTap;
  const _PocketRow(
      {required this.pocket, required this.fmt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final suggestion = PocketMath.suggestedMonthly(pocket, DateTime.now());
    String? due;
    var dueColor = p.inkMuted;
    if (pocket.dueDate != null) {
      final date = DateFormatter.shortDay(pocket.dueDate!);
      if (suggestion != null && suggestion > 0) {
        due = l10n.svDueSuggest(date, fmt(suggestion));
        if (PocketMath.isDueSoon(pocket, DateTime.now())) dueColor = p.expense;
      } else {
        due = l10n.svDueOn(date);
      }
    }
    final negative = pocket.savedAmount < 0;
    final barColor =
        negative || dueColor == p.expense ? p.expense : p.ink;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: p.track))),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration:
                  BoxDecoration(color: p.surfaceSubtle, shape: BoxShape.circle),
              child: Icon(AppIcons.resolve(pocket.iconName),
                  size: 17, color: p.ink),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(pocket.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                AppTextStyles.rowTitle.copyWith(color: p.ink)),
                      ),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: fmt(pocket.savedAmount),
                            style: AppTextStyles.rowAmount.copyWith(
                                color: negative ? p.expense : p.ink),
                          ),
                          TextSpan(
                            text: ' / ${fmt(pocket.targetAmount)}',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: p.inkMuted),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  BudgetProgressBar(
                    spent: pocket.savedAmount.clamp(0, double.infinity),
                    limit: pocket.targetAmount,
                    height: 4,
                    color: barColor,
                  ),
                  if (due != null) ...[
                    const SizedBox(height: 4),
                    Text(due,
                        style: AppTextStyles.caption.copyWith(color: dueColor)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
