import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/amount_input.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/savings_goal.dart';
import '../../../providers/savings_goals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/amount_field.dart';
import '../../widgets/picker_fields.dart';

class AddSavingsGoalScreen extends ConsumerStatefulWidget {
  const AddSavingsGoalScreen({super.key});

  @override
  ConsumerState<AddSavingsGoalScreen> createState() =>
      _AddSavingsGoalScreenState();
}

class _AddSavingsGoalScreenState extends ConsumerState<AddSavingsGoalScreen> {
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _initialCtrl = TextEditingController();
  DateTime? _targetDate;
  String _colorHex = AppColors.toHex(AppColors.palette.first);
  String _iconName = AppIcons.pickerIcons.first;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    _initialCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.goalNew)),
      body: ListView(
        padding: const EdgeInsets.all(Dimens.screenPaddingH),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
                labelText: l10n.name, hintText: l10n.goalNameHint),
          ),
          const SizedBox(height: 16),
          AmountField(controller: _targetCtrl, label: l10n.goalTarget),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.goalDeadlineOptional),
            subtitle: Text(_targetDate == null
                ? l10n.goalNoDate
                : DateFormatter.longDay(_targetDate!)),
            trailing: _targetDate == null
                ? const Icon(Icons.calendar_today_outlined)
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _targetDate = null),
                  ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _targetDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _targetDate = picked);
            },
          ),
          const SizedBox(height: 16),
          Text(l10n.color, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ColorPickerRow(
            selectedHex: _colorHex,
            onSelected: (hex) => setState(() => _colorHex = hex),
          ),
          const SizedBox(height: 16),
          Text(l10n.icon, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          IconPickerGrid(
            selectedIcon: _iconName,
            onSelected: (name) => setState(() => _iconName = name),
          ),
          const SizedBox(height: 16),
          AmountField(
              controller: _initialCtrl,
              label: l10n.goalInitialOptional),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: _save,
            child: Text(l10n.goalCreate),
          ),
        ],
      ),
    );
  }

  double _parse(String s) =>
      AmountInput.of(ref.read(settingsProvider).currency).parse(s);

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.goalNameMissing)));
      return;
    }
    final target = _parse(_targetCtrl.text);
    if (target <= 0) {
      messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.goalTargetMissing)));
      return;
    }
    final initial = _parse(_initialCtrl.text);

    final goal = SavingsGoal()
      ..name = name
      ..targetAmount = target
      ..currentAmount = initial
      ..targetDate = _targetDate
      ..colorHex = _colorHex
      ..iconName = _iconName
      ..isCompleted = initial >= target
      ..createdAt = DateTime.now();

    await ref.read(savingsGoalRepositoryProvider).add(goal);
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    context.pop();
  }
}
