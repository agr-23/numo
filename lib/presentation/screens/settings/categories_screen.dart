import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/category.dart';
import '../../../providers/categories_provider.dart';
import '../../widgets/category_icon.dart';
import '../../widgets/picker_fields.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final expense = categories.where((c) => c.type == CategoryType.expense).toList();
    final income = categories.where((c) => c.type == CategoryType.income).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categories)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCategory(context, ref),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Dimens.screenPaddingH, 8, Dimens.screenPaddingH, 96),
        children: [
          _sectionTitle(theme, l10n.expenses),
          ...expense.map((c) => _tile(context, ref, c)),
          const SizedBox(height: Dimens.sectionGap),
          _sectionTitle(theme, l10n.incomes),
          ...income.map((c) => _tile(context, ref, c)),
        ],
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: theme.textTheme.titleMedium),
    );
  }

  Widget _tile(BuildContext context, WidgetRef ref, Category c) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CategoryIcon(iconName: c.iconName, colorHex: c.colorHex, size: 40),
      title: Text(categoryLabel(c, context.l10n)),
      subtitle:
          Text(c.isCustom ? context.l10n.catCustom : context.l10n.catPredefined),
      trailing: c.isCustom
          ? IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.expense),
              onPressed: () async {
                final ok = await ref
                    .read(categoryRepositoryProvider)
                    .delete(c.id);
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.catCannotDelete)));
                }
              },
            )
          : null,
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddCategorySheet(),
    );
  }
}

class _AddCategorySheet extends ConsumerStatefulWidget {
  const _AddCategorySheet();

  @override
  ConsumerState<_AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends ConsumerState<_AddCategorySheet> {
  final _nameCtrl = TextEditingController();
  CategoryType _type = CategoryType.expense;
  String _colorHex = AppColors.toHex(AppColors.palette.first);
  String _iconName = 'more_horiz';

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (_, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(Dimens.screenPaddingH),
        children: [
          Text(l10n.catNew, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l10n.name),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text(l10n.expense),
                selected: _type == CategoryType.expense,
                onSelected: (_) =>
                    setState(() => _type = CategoryType.expense),
              ),
              ChoiceChip(
                label: Text(l10n.income),
                selected: _type == CategoryType.income,
                onSelected: (_) => setState(() => _type = CategoryType.income),
              ),
            ],
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
            icons: AppIcons.categoryIcons,
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: _save,
            child: Text(l10n.catCreate),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      messenger
          .showSnackBar(SnackBar(content: Text(context.l10n.writeName)));
      return;
    }
    final category = Category()
      ..name = name
      ..iconName = _iconName
      ..colorHex = _colorHex
      ..type = _type
      ..isCustom = true
      ..sortOrder = 0;
    await ref.read(categoryRepositoryProvider).add(category);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
