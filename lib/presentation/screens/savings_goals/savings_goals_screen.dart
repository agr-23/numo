import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/savings_goal.dart';
import '../../../providers/savings_goals_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/savings_goal_card.dart';
import 'widgets/aportar_sheet.dart';

class SavingsGoalsScreen extends ConsumerStatefulWidget {
  const SavingsGoalsScreen({super.key});

  @override
  ConsumerState<SavingsGoalsScreen> createState() =>
      _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends ConsumerState<SavingsGoalsScreen> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _aportar(SavingsGoal goal) async {
    final completed = await AportarSheet.show(context, goal);
    if (completed == true) {
      HapticFeedback.heavyImpact();
      _confetti.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(sortedSavingsGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.goalTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-savings-goal'),
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          if (goals.isEmpty)
            EmptyState(
              icon: Icons.savings,
              message: context.l10n.goalNone,
              actionLabel: context.l10n.goalCreate,
              onAction: () => context.push('/add-savings-goal'),
            )
          else
            ListView(
              padding: const EdgeInsets.fromLTRB(
                  Dimens.screenPaddingH, 12, Dimens.screenPaddingH, 96),
              children: [
                for (final g in goals)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.itemGap),
                    child: SavingsGoalCard(
                      goal: g,
                      onContribute: () => _aportar(g),
                    ),
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
