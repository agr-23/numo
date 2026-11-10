import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/constants/savings_templates.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/numo_palette.dart';
import '../../../../data/models/savings_group.dart';
import '../../../../providers/savings_provider.dart';
import '../../../widgets/picker_fields.dart';

/// Crear un grupo (con plantillas) o editarlo.
class GroupSheet extends ConsumerStatefulWidget {
  final SavingsGroup? group;
  const GroupSheet._({this.group});

  static Future<void> show(BuildContext context, {SavingsGroup? group}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
          heightFactor: 0.85, child: GroupSheet._(group: group)),
    );
  }

  @override
  ConsumerState<GroupSheet> createState() => _GroupSheetState();
}

class _GroupSheetState extends ConsumerState<GroupSheet> {
  final _nameCtrl = TextEditingController();
  String _icon = 'savings';
  String? _template;

  bool get _isEdit => widget.group != null;

  @override
  void initState() {
    super.initState();
    final g = widget.group;
    if (g != null) {
      _nameCtrl.text = g.name;
      _icon = g.iconName;
      _template = g.templateKey;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _applyTemplate(SavingsTemplate? t) {
    setState(() {
      _template = t?.key;
      if (t != null) {
        _icon = t.iconName;
        _nameCtrl.text = t.label(context.l10n);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
            Dimens.screenPaddingH, 0, Dimens.screenPaddingH, 24),
        children: [
          Text(_isEdit ? l10n.svEditGroup : l10n.svNewGroup,
              style: AppTextStyles.headline.copyWith(color: p.ink)),
          if (!_isEdit) ...[
            const SizedBox(height: 16),
            Text(l10n.svTemplates,
                style: AppTextStyles.section.copyWith(color: p.ink)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in kSavingsTemplates)
                  ChoiceChip(
                    label: Text(t.label(l10n)),
                    selected: _template == t.key,
                    onSelected: (_) => _applyTemplate(t),
                  ),
                ChoiceChip(
                  label: Text(l10n.tplCustom),
                  selected: _template == null,
                  onSelected: (_) => _applyTemplate(null),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.name),
          ),
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
            child: Text(_isEdit ? l10n.accSaveChanges : l10n.svCreateGroup),
          ),
          if (_isEdit) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _delete,
              style: TextButton.styleFrom(foregroundColor: p.expense),
              child: Text(l10n.svDeleteGroup),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.writeName)));
      return;
    }
    final router = GoRouter.of(context);
    final navigator = Navigator.of(context);
    final group = (widget.group ?? SavingsGroup())
      ..name = name
      ..iconName = _icon
      ..colorHex = widget.group?.colorHex ?? '#111114'
      ..templateKey = _template;
    final id = await ref.read(pocketRepositoryProvider).saveGroup(group);
    HapticFeedback.mediumImpact();
    navigator.pop();
    // Un grupo nuevo abre su detalle para agregar los bolsillos.
    if (!_isEdit) router.push('/savings-group/$id');
  }

  Future<void> _delete() async {
    final router = GoRouter.of(context);
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.svDeleteGroup),
        content: Text(ctx.l10n.svDeleteGroupBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(ctx.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(ctx.l10n.delete)),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(pocketRepositoryProvider).deleteGroup(widget.group!.id);
    navigator.pop();
    router.pop();
  }
}
