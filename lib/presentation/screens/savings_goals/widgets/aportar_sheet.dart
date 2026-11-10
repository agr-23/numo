import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../../data/models/savings_goal.dart';
import '../../../../providers/savings_goals_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../widgets/amount_field.dart';

/// Bottom sheet para aportar a una meta. Devuelve true si el aporte
/// completó la meta.
class AportarSheet extends ConsumerStatefulWidget {
  final SavingsGoal goal;
  const AportarSheet({super.key, required this.goal});

  static Future<bool?> show(BuildContext context, SavingsGoal goal) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AportarSheet(goal: goal),
      ),
    );
  }

  @override
  ConsumerState<AportarSheet> createState() => _AportarSheetState();
}

class _AportarSheetState extends ConsumerState<AportarSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Dimens.screenPaddingH),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.goalContributeQuestion(widget.goal.name),
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          AmountField(
              controller: _ctrl, label: context.l10n.amount, autofocus: true),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(Dimens.buttonHeight)),
            onPressed: _submit,
            child: Text(context.l10n.goalContribute),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final amount =
        AmountInput.of(ref.read(settingsProvider).currency).parse(_ctrl.text);
    if (amount <= 0) {
      messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.amountMustBePositive)));
      return;
    }
    final completed = await ref
        .read(savingsGoalRepositoryProvider)
        .contribute(widget.goal.id, amount);
    HapticFeedback.mediumImpact();
    navigator.pop(completed);
  }
}
