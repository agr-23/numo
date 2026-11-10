import 'package:isar/isar.dart';

part 'account.g.dart';

enum AccountType { cash, bank, credit }

@collection
class Account {
  Id id = Isar.autoIncrement;
  late String name;

  @Enumerated(EnumType.name)
  late AccountType type;

  /// Para credit: balance representa la DEUDA (positivo = debe).
  /// Para cash/bank: balance es el saldo disponible.
  late double balance;

  late String colorHex;
  late String iconName;
  late DateTime createdAt;
  late bool isActive;

  // --- Solo tarjetas de crédito (null en efectivo/banco) ---

  /// Cupo total de la tarjeta.
  double? creditLimit;

  /// Día del mes en que corta la tarjeta (1-31).
  int? statementDay;

  /// Día del mes límite para pagar (1-31).
  int? paymentDueDay;
}

/// Cálculos derivados de una tarjeta de crédito. Van en una extensión para
/// que Isar no intente persistirlos.
extension CreditCardX on Account {
  bool get isCredit => type == AccountType.credit;

  /// Deuda actual (0 si no es tarjeta).
  double get debt => isCredit ? balance : 0;

  /// Cupo disponible = cupo total − deuda. Null si no hay cupo configurado.
  double? get available =>
      isCredit && creditLimit != null ? creditLimit! - balance : null;

  /// Fracción del cupo usada (0..1+). Null si no hay cupo configurado.
  double? get usage =>
      isCredit && (creditLimit ?? 0) > 0 ? balance / creditLimit! : null;

  /// Próxima fecha de corte a partir de hoy (incluido).
  DateTime? get nextStatementDate =>
      statementDay == null ? null : nextDayOfMonth(statementDay!);

  /// Próxima fecha límite de pago a partir de hoy (incluido).
  DateTime? get nextPaymentDate =>
      paymentDueDay == null ? null : nextDayOfMonth(paymentDueDay!);
}

/// Próxima fecha (hoy o después) que cae en el día [day] del mes. Si el mes
/// es más corto (ej. día 31 en febrero), usa su último día.
DateTime nextDayOfMonth(int day, {DateTime? from}) {
  final now = from ?? DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  DateTime inMonth(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }

  final thisMonth = inMonth(today.year, today.month);
  if (!thisMonth.isBefore(today)) return thisMonth;
  return inMonth(today.year, today.month + 1);
}
