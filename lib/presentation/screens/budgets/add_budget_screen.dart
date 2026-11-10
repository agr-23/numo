import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/amount_input.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/budget.dart';
import '../../../data/models/category.dart';
import '../../../providers/budgets_provider.dart';
import '../../../providers/categories_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/amount_field.dart';
import '../../widgets/category_icon.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  Category? _category;
  final _limitCtrl = TextEditingController();
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    _month = ref.read(budgetMonthProvider);
  }

  @override
  void dispose() {
    _limitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories =
        ref.watch(categoriesByTypeProvider(CategoryType.expense));

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo presupuesto')),
      body: ListView(
        padding: const EdgeInsets.all(Dimens.screenPaddingH),
        children: [
          Text('Categoría', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final c in categories)
                GestureDetector(
                  onTap: () => setState(() => _category = c),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _category?.id == c.id
                                ? AppColors.accent
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: CategoryIcon(
                            iconName: c.iconName, colorHex: c.colorHex),
                      ),
                      SizedBox(
                        width: 64,
                        child: Text(c.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: Dimens.sectionGap),
          AmountField(controller: _limitCtrl, label: 'Monto límite'),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mes'),
            subtitle: Text(DateFormatter.monthYear(_month)),
            trailing: const Icon(Icons.calendar_month),
            onTap: _pickMonth,
          ),
          const SizedBox(height: Dimens.sectionGap),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: _save,
            child: const Text('Guardar presupuesto'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _month,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      helpText: 'Selecciona un mes',
    );
    if (picked != null) {
      setState(() => _month = DateTime(picked.year, picked.month));
    }
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(budgetRepositoryProvider);
    if (_category == null) {
      messenger
          .showSnackBar(const SnackBar(content: Text('Selecciona una categoría')));
      return;
    }
    final limit = AmountInput.of(ref.read(settingsProvider).currency)
        .parse(_limitCtrl.text);
    if (limit <= 0) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Ingresa un monto mayor a 0')));
      return;
    }

    final existing = await repo.findForCategoryMonth(
        _category!.id, _month.month, _month.year);
    if (existing != null) {
      if (!mounted) return;
      final replace = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Ya existe un presupuesto'),
          content: Text(
              'Ya tienes un presupuesto para "${_category!.name}" en ${DateFormatter.monthYear(_month)}. ¿Reemplazarlo?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Reemplazar')),
          ],
        ),
      );
      if (replace != true) return;
    }

    final budget = (existing ?? Budget())
      ..limitAmount = limit
      ..month = _month.month
      ..year = _month.year;

    await repo.upsert(budget, _category!.id);
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    // Asegura que la pantalla de presupuestos muestre el mes guardado.
    ref.read(budgetMonthProvider.notifier).state = _month;
    context.pop();
  }
}
