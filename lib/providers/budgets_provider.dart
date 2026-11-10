import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/budget.dart';
import '../data/models/category.dart';
import '../data/models/transaction.dart';
import '../data/repositories/budget_repository.dart';
import 'transactions_provider.dart';

final budgetRepositoryProvider =
    Provider<BudgetRepository>((ref) => BudgetRepository());

/// Mes seleccionado en la pantalla de presupuestos.
final budgetMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

/// Todos los presupuestos (con categoría cargada).
final budgetsProvider = StreamProvider<List<Budget>>((ref) {
  return ref.watch(budgetRepositoryProvider).watchAll();
});

/// Presupuesto + gasto real calculado en tiempo real.
@immutable
class BudgetView {
  final Budget budget;
  final Category? category;
  final double spent;

  const BudgetView({
    required this.budget,
    required this.category,
    required this.spent,
  });

  double get limit => budget.limitAmount;
  double get progress => limit <= 0 ? 0 : (spent / limit);
  double get remaining => limit - spent;
  bool get isNearLimit => progress > 0.8 && progress <= 1.0;
  bool get isExceeded => progress > 1.0;
}

/// Vistas de presupuesto para el mes seleccionado, con gasto calculado.
final budgetViewsProvider = Provider<List<BudgetView>>((ref) {
  final month = ref.watch(budgetMonthProvider);
  final budgets = ref.watch(budgetsProvider).valueOrNull ?? const [];
  final txs = ref.watch(transactionsProvider).valueOrNull ?? const [];

  final monthBudgets = budgets
      .where((b) => b.month == month.month && b.year == month.year)
      .toList();

  return [
    for (final b in monthBudgets)
      BudgetView(
        budget: b,
        category: b.category.value,
        spent: _spentFor(txs, b.category.value?.id, month),
      ),
  ];
});

double _spentFor(List<Transaction> txs, int? categoryId, DateTime month) {
  if (categoryId == null) return 0;
  var sum = 0.0;
  for (final t in txs) {
    if (t.type != TransactionType.expense) continue;
    if (t.date.year != month.year || t.date.month != month.month) continue;
    if (t.category.value?.id == categoryId) sum += t.amount;
  }
  return sum;
}

/// Resumen mensual de presupuestos (total, gastado, disponible).
class BudgetSummary {
  final double total;
  final double spent;
  const BudgetSummary(this.total, this.spent);
  double get available => total - spent;
  double get progress => total <= 0 ? 0 : spent / total;
}

final budgetSummaryProvider = Provider<BudgetSummary>((ref) {
  final views = ref.watch(budgetViewsProvider);
  var total = 0.0;
  var spent = 0.0;
  for (final v in views) {
    total += v.limit;
    spent += v.spent;
  }
  return BudgetSummary(total, spent);
});
