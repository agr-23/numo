import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart' show Isar;

import '../../../../core/constants/dimens.dart';
import '../../../../core/constants/savings_templates.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/numo_palette.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/account.dart';
import '../../../../data/models/pocket.dart';
import '../../../../providers/accounts_provider.dart';
import '../../../../providers/savings_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../widgets/amount_field.dart';
import '../../../widgets/picker_fields.dart';

/// Crear o editar un bolsillo. Con [seed] llega precargado desde una
/// plantilla (ej. "SOAT", anual).
class PocketSheet extends ConsumerStatefulWidget {
  final int groupId;
  final Pocket? pocket;
  final PocketSeed? seed;

  const PocketSheet._({required this.groupId, this.pocket, this.seed});

  static Future<void> show(
    BuildContext context, {
    required int groupId,
    Pocket? pocket,
    PocketSeed? seed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: PocketSheet._(groupId: groupId, pocket: pocket, seed: seed),
      ),
    );
  }

  @override
  ConsumerState<PocketSheet> createState() => _PocketSheetState();
}

class _PocketSheetState extends ConsumerState<PocketSheet> {
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  PocketKind _kind = PocketKind.monthly;
  DateTime? _due;
  int? _accountId;
  String _icon = 'savings';
  bool _seeded = false;

  bool get _isEdit => widget.pocket != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pocket;
    final rules = AmountInput.of(ref.read(settingsProvider).currency);
    if (p != null) {
      _nameCtrl.text = p.name;
      _amountCtrl.text = rules.format(p.targetAmount);
      _kind = p.kind;
      _due = p.dueDate;
      _accountId = p.accountId;
      _icon = p.iconName;
    } else if (widget.seed != null) {
      _kind = widget.seed!.kind;
      _icon = widget.seed!.iconName;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // El nombre de la plantilla depende del idioma (necesita contexto).
    if (!_seeded && widget.seed != null && widget.pocket == null) {
      _seeded = true;
      _nameCtrl.text = widget.seed!.label(context.l10n);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final accounts = (ref.watch(accountsProvider).valueOrNull ?? const [])
        .where((a) => !a.isCredit)
        .toList();
    _accountId ??= accounts.isNotEmpty ? accounts.first.id : null;
    final account = accounts.where((a) => a.id == _accountId).firstOrNull;

    final amountLabel = switch (_kind) {
      PocketKind.goal => l10n.goalTarget,
      PocketKind.monthly => l10n.svAmountMonthly,
      PocketKind.yearly => l10n.svAmountYearly,
    };

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Dimens.screenPaddingH,
          0,
          Dimens.screenPaddingH,
          24,
        ),
        children: [
          Text(
            _isEdit ? l10n.svEditPocket : l10n.svNewPocket,
            style: AppTextStyles.headline.copyWith(color: p.ink),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.name),
          ),
          const SizedBox(height: 16),
          SegmentedButton<PocketKind>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: PocketKind.monthly,
                label: Text(l10n.svKindMonthly),
              ),
              ButtonSegment(
                value: PocketKind.yearly,
                label: Text(l10n.svKindYearly),
              ),
              ButtonSegment(
                value: PocketKind.goal,
                label: Text(l10n.svKindGoal),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
          const SizedBox(height: 16),
          AmountField(controller: _amountCtrl, label: amountLabel),
          if (_kind != PocketKind.monthly) ...[
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(
                _kind == PocketKind.yearly
                    ? l10n.svNextDue
                    : l10n.goalDeadlineOptional,
              ),
              subtitle: Text(
                _due == null ? l10n.svPickDate : DateFormatter.longDay(_due!),
              ),
              trailing: _due == null || _kind == PocketKind.yearly
                  ? const Icon(Icons.chevron_right_rounded)
                  : IconButton(
                      tooltip: l10n.clear,
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () => setState(() => _due = null),
                    ),
              onTap: _pickDate,
            ),
          ],
          if (accounts.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.svFromAccount,
              style: AppTextStyles.section.copyWith(color: p.ink),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final a in accounts)
                  ChoiceChip(
                    label: Text(a.name),
                    selected: a.id == _accountId,
                    // Con dinero apartado no se cambia de cuenta.
                    onSelected: (widget.pocket?.savedAmount ?? 0) > 0
                        ? null
                        : (_) => setState(() => _accountId = a.id),
                  ),
              ],
            ),
            if (account != null) ...[
              const SizedBox(height: 6),
              Text(
                l10n.svSetAsideNote(account.name),
                style: AppTextStyles.caption.copyWith(color: p.inkMuted),
              ),
            ],
          ],
          const SizedBox(height: 16),
          Text(l10n.icon, style: AppTextStyles.section.copyWith(color: p.ink)),
          const SizedBox(height: 8),
          IconPickerGrid(
            selectedIcon: _icon,
            onSelected: (v) => setState(() => _icon = v),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            child: Text(_isEdit ? l10n.accSaveChanges : l10n.svAddPocket),
          ),
          if (_isEdit) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _delete(
                CurrencyFormatter.format(widget.pocket!.savedAmount, settings),
              ),
              style: TextButton.styleFrom(foregroundColor: p.expense),
              child: Text(l10n.svDeletePocket),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due ?? DateTime(now.year, now.month + 3, now.day),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final rules = AmountInput.of(ref.read(settingsProvider).currency);
    final name = _nameCtrl.text.trim();
    final amount = rules.parse(_amountCtrl.text);
    String? error;
    if (name.isEmpty) {
      error = l10n.writeName;
    } else if (amount <= 0) {
      error = l10n.amountMustBePositive;
    } else if (_kind == PocketKind.yearly && _due == null) {
      error = l10n.svDueRequired;
    }
    if (error != null) {
      unawaited(HapticFeedback.heavyImpact());
      messenger.showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final pocket = (widget.pocket ?? (Pocket()..id = Isar.autoIncrement))
      ..groupId = widget.groupId
      ..name = name
      ..iconName = _icon
      ..kind = _kind
      ..targetAmount = amount
      ..dueDate = _kind == PocketKind.monthly ? null : _due
      ..accountId = _accountId;
    if (widget.pocket == null) pocket.savedAmount = 0;
    await ref.read(pocketRepositoryProvider).savePocket(pocket);
    unawaited(HapticFeedback.mediumImpact());
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete(String savedText) async {
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.svDeletePocket),
        content: Text(ctx.l10n.svDeletePocketBody(savedText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(pocketRepositoryProvider).deletePocket(widget.pocket!.id);
    navigator.pop();
  }
}
