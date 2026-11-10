import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/transaction.dart';
import '../data/repositories/transaction_repository.dart';

final transactionRepositoryProvider =
    Provider<TransactionRepository>((ref) => TransactionRepository());

/// Todas las transacciones ordenadas por fecha (desc), con links cargados.
final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

/// Resumen de ingresos/gastos de un mes concreto.
class MonthSummary {
  final double income;
  final double expense;
  const MonthSummary({required this.income, required this.expense});

  double get net => income - expense;
}

/// Resumen del mes actual (ingresos y gastos, sin contar transferencias).
final currentMonthSummaryProvider = Provider<MonthSummary>((ref) {
  final txs = ref.watch(transactionsProvider).valueOrNull ?? const [];
  final now = DateTime.now();
  var income = 0.0;
  var expense = 0.0;
  for (final t in txs) {
    if (t.date.year != now.year || t.date.month != now.month) continue;
    if (t.type == TransactionType.income) income += t.amount;
    if (t.type == TransactionType.expense) expense += t.amount;
  }
  return MonthSummary(income: income, expense: expense);
});

/// Los últimos N movimientos (dashboard).
final recentTransactionsProvider =
    Provider.family<List<Transaction>, int>((ref, count) {
  final txs = ref.watch(transactionsProvider).valueOrNull ?? const [];
  return txs.take(count).toList();
});

/// Movimientos asociados a una cuenta (como origen o destino).
final transactionsByAccountProvider =
    Provider.family<List<Transaction>, int>((ref, accountId) {
  final txs = ref.watch(transactionsProvider).valueOrNull ?? const [];
  return txs
      .where((t) =>
          t.account.value?.id == accountId ||
          t.toAccount.value?.id == accountId)
      .toList();
});
