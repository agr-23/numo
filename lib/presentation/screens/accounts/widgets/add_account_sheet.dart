import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../../data/models/account.dart';
import '../../../../providers/accounts_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../widgets/amount_field.dart';
import '../../../widgets/picker_fields.dart';

/// Crea una cuenta o, si se pasa [account], la edita.
class AddAccountSheet extends ConsumerStatefulWidget {
  final Account? account;
  const AddAccountSheet({super.key, this.account});

  static Future<void> show(BuildContext context, {Account? account}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddAccountSheet(account: account),
    );
  }

  @override
  ConsumerState<AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends ConsumerState<AddAccountSheet> {
  final _nameCtrl = TextEditingController();
  final _balanceCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();
  AccountType _type = AccountType.cash;
  String _colorHex = AppColors.toHex(AppColors.palette.first);
  String _iconName = AppIcons.accountIcons.first;
  int? _statementDay;
  int? _paymentDueDay;

  bool get _isEdit => widget.account != null;

  @override
  void initState() {
    super.initState();
    final a = widget.account;
    if (a != null) {
      final rules = AmountInput.of(ref.read(settingsProvider).currency);
      _nameCtrl.text = a.name;
      _type = a.type;
      _balanceCtrl.text = rules.format(a.balance);
      _limitCtrl.text = rules.format(a.creditLimit ?? 0);
      _colorHex = a.colorHex;
      _iconName = a.iconName;
      _statementDay = a.statementDay;
      _paymentDueDay = a.paymentDueDay;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _balanceCtrl.dispose();
    _limitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isCredit = _type == AccountType.credit;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(Dimens.screenPaddingH),
          children: [
            Text(_isEdit ? l10n.accEdit : l10n.accNew,
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                  labelText: l10n.name, hintText: l10n.accNameHint),
            ),
            const SizedBox(height: 16),
            Text(l10n.type, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _typeChip(l10n.accountTypeCash, AccountType.cash),
                _typeChip(l10n.accountTypeBank, AccountType.bank),
                _typeChip(l10n.accountTypeCredit, AccountType.credit),
              ],
            ),
            const SizedBox(height: 16),
            if (isCredit) ...[
              AmountField(
                controller: _limitCtrl,
                label: l10n.accCreditLimit,
                helper: l10n.accLimitHelper,
              ),
              const SizedBox(height: 16),
              AmountField(
                controller: _balanceCtrl,
                label: l10n.accCurrentDebt,
                helper: l10n.accDebtHelper,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _dayField(
                      label: l10n.accStatementDay,
                      value: _statementDay,
                      onChanged: (d) => setState(() => _statementDay = d),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dayField(
                      label: l10n.accPaymentDay,
                      value: _paymentDueDay,
                      onChanged: (d) => setState(() => _paymentDueDay = d),
                    ),
                  ),
                ],
              ),
            ] else
              AmountField(
                controller: _balanceCtrl,
                label: _isEdit ? l10n.accCurrentBalance : l10n.accInitialBalance,
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
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _save,
              child: Text(_isEdit ? l10n.accSaveChanges : l10n.accCreate),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String label, AccountType type) {
    return ChoiceChip(
      label: Text(label),
      selected: _type == type,
      onSelected: (_) => setState(() => _type = type),
    );
  }

  Widget _dayField({
    required String label,
    required int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      hint: const Text('—'),
      menuMaxHeight: 320,
      items: [
        for (var d = 1; d <= 31; d++)
          DropdownMenuItem(value: d, child: Text(context.l10n.dayN(d))),
      ],
      onChanged: onChanged,
    );
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final rules = AmountInput.of(ref.read(settingsProvider).currency);
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.accNameMissing)));
      return;
    }
    final isCredit = _type == AccountType.credit;
    final limit = rules.parse(_limitCtrl.text);
    if (isCredit && limit <= 0) {
      messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.accLimitMissing)));
      return;
    }

    final account = (widget.account ?? Account())
      ..name = name
      ..type = _type
      ..balance = rules.parse(_balanceCtrl.text)
      ..colorHex = _colorHex
      ..iconName = _iconName
      ..creditLimit = isCredit ? limit : null
      ..statementDay = isCredit ? _statementDay : null
      ..paymentDueDay = isCredit ? _paymentDueDay : null;
    if (!_isEdit) {
      account
        ..createdAt = DateTime.now()
        ..isActive = true;
    }

    final repo = ref.read(accountRepositoryProvider);
    _isEdit ? await repo.update(account) : await repo.add(account);
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
