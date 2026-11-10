import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/account.dart';
import 'accounts_provider.dart';
import 'savings_provider.dart';

/// Dinero total: lo que hay en efectivo y bancos. Lo apartado en
/// bolsillos sigue en esas cuentas, así que no se suma otra vez; solo se
/// suman los bolsillos sin cuenta (metas antiguas registradas aparte).
class MoneyOverview {
  final double inAccounts;
  final double setAside;
  final double outsideAccounts;
  const MoneyOverview(this.inAccounts, this.setAside, this.outsideAccounts);
  double get total => inAccounts + outsideAccounts;
}

final moneyOverviewProvider = Provider<MoneyOverview>((ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
  final setAside = ref.watch(setAsideByAccountProvider);
  final savings = ref.watch(savingsOverviewProvider);
  var inAccounts = 0.0, apartado = 0.0;
  for (final a in accounts) {
    if (a.isCredit) continue;
    inAccounts += a.balance;
    apartado += setAside[a.id] ?? 0;
  }
  return MoneyOverview(inAccounts, apartado, savings.savedOutsideAccounts);
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
    if (p != null &&
        c.balance > 0 &&
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
