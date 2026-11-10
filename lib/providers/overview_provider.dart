import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/account.dart';
import 'accounts_provider.dart';
import 'savings_goals_provider.dart';

/// Dinero total: saldo en efectivo/banco + lo ahorrado en metas.
class MoneyOverview {
  final double inAccounts;
  final double inGoals;
  const MoneyOverview(this.inAccounts, this.inGoals);
  double get total => inAccounts + inGoals;
}

final moneyOverviewProvider = Provider<MoneyOverview>((ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
  final goals = ref.watch(savingsGoalsProvider).valueOrNull ?? const [];
  var inAccounts = 0.0;
  for (final a in accounts) {
    if (!a.isCredit) inAccounts += a.balance;
  }
  var inGoals = 0.0;
  for (final g in goals) {
    inGoals += g.currentAmount;
  }
  return MoneyOverview(inAccounts, inGoals);
});

/// Resumen de tarjetas de crédito activas.
class DebtOverview {
  final int cardCount;
  final double debt;

  /// Suma del cupo disponible de las tarjetas que tienen cupo configurado.
  final double? available;

  /// Pago más cercano entre todas las tarjetas.
  final DateTime? nextPayment;
  final String? nextPaymentCard;

  const DebtOverview({
    required this.cardCount,
    required this.debt,
    required this.available,
    required this.nextPayment,
    required this.nextPaymentCard,
  });
}

final debtOverviewProvider = Provider<DebtOverview>((ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
  final cards = accounts.where((a) => a.isCredit).toList();

  var debt = 0.0;
  double? available;
  DateTime? nextPayment;
  String? nextPaymentCard;
  for (final c in cards) {
    debt += c.balance;
    final av = c.available;
    if (av != null) available = (available ?? 0) + av;
    final p = c.nextPaymentDate;
    // Solo interesa el pago si hay deuda que pagar.
    if (p != null && c.balance > 0 &&
        (nextPayment == null || p.isBefore(nextPayment))) {
      nextPayment = p;
      nextPaymentCard = c.name;
    }
  }
  return DebtOverview(
    cardCount: cards.length,
    debt: debt,
    available: available,
    nextPayment: nextPayment,
    nextPaymentCard: nextPaymentCard,
  );
});

/// Progreso agregado de las metas de ahorro.
class GoalsOverview {
  final int count;
  final int completed;
  final double saved;
  final double target;
  const GoalsOverview(this.count, this.completed, this.saved, this.target);
  double get progress => target <= 0 ? 0 : (saved / target).clamp(0.0, 1.0);
}

final goalsOverviewProvider = Provider<GoalsOverview>((ref) {
  final goals = ref.watch(savingsGoalsProvider).valueOrNull ?? const [];
  var saved = 0.0;
  var target = 0.0;
  var completed = 0;
  for (final g in goals) {
    saved += g.currentAmount;
    target += g.targetAmount;
    if (g.isCompleted) completed++;
  }
  return GoalsOverview(goals.length, completed, saved, target);
});
