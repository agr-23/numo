import '../../data/models/pocket.dart';

/// Cálculos de bolsillos, sin base de datos (fáciles de probar).
class PocketMath {
  PocketMath._();

  /// yyyymm de una fecha (202611).
  static int monthKey(DateTime d) => d.year * 100 + d.month;

  static int _nextMonthKey(int key) {
    final y = key ~/ 100, m = key % 100;
    return m == 12 ? (y + 1) * 100 + 1 : key + 1;
  }

  /// Lo que falta para la meta (nunca negativo).
  static double remaining(Pocket p) =>
      (p.targetAmount - p.savedAmount).clamp(0, double.infinity).toDouble();

  /// Meses completos o parciales hasta [due], contando el actual (mín. 1).
  static int monthsUntil(DateTime due, DateTime now) {
    final months = (due.year - now.year) * 12 + (due.month - now.month);
    return months < 1 ? 1 : months;
  }

  /// Cuánto apartar este mes.
  /// - Anual / meta con fecha: lo que falta repartido en los meses que quedan.
  /// - Mensual: lo que falta para completar el mes.
  /// - Meta sin fecha: null (no hay ritmo que sugerir).
  static double? suggestedMonthly(Pocket p, DateTime now) {
    final left = remaining(p);
    if (left <= 0) return 0;
    switch (p.kind) {
      case PocketKind.monthly:
        return left;
      case PocketKind.yearly:
      case PocketKind.goal:
        if (p.dueDate == null) return null;
        return _friendly(left / monthsUntil(p.dueDate!, now));
    }
  }

  /// Redondea hacia arriba a una cifra fácil de recordar: a miles desde
  /// 10.000 (255.715 → 256.000); a la unidad por debajo.
  static double _friendly(double v) {
    if (v >= 10000) return (v / 1000).ceilToDouble() * 1000;
    return v.ceilToDouble();
  }

  /// ¿El vencimiento está cerca (4 meses o menos)?
  static bool isDueSoon(Pocket p, DateTime now) =>
      p.dueDate != null && monthsUntil(p.dueDate!, now) <= 4;

  /// Reparte [amount] entre [pockets] en proporción a lo que le falta a
  /// cada uno. Si a ninguno le falta nada, reparte según su meta.
  /// Devuelve id → monto. La suma es exactamente [amount].
  static Map<int, double> distribute(List<Pocket> pockets, double amount) {
    if (pockets.isEmpty || amount <= 0) return {};
    var weights = {for (final p in pockets) p.id: remaining(p)};
    if (weights.values.every((w) => w <= 0)) {
      weights = {for (final p in pockets) p.id: p.targetAmount};
    }
    final total = weights.values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) {
      final each = amount / pockets.length;
      return {for (final p in pockets) p.id: each};
    }
    final result = <int, double>{};
    var assigned = 0.0;
    final ids = weights.keys.toList();
    for (var i = 0; i < ids.length; i++) {
      final id = ids[i];
      final share = i == ids.length - 1
          ? amount - assigned
          : (amount * weights[id]! / total).roundToDouble();
      result[id] = share;
      assigned += share;
    }
    return result;
  }

  /// Aplica las recargas mensuales y el paso de año de los anuales que
  /// correspondan a [now]. Devuelve true si cambió algo.
  static bool roll(Pocket p, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    var changed = false;
    if (p.kind == PocketKind.monthly) {
      final current = monthKey(now);
      var last = p.lastRefillMonth;
      if (last == null) {
        p.lastRefillMonth = current;
        return true;
      }
      // Como mucho 24 meses, para no desbordar si la app pasó años cerrada.
      var guard = 0;
      while (last! < current && guard < 24) {
        last = _nextMonthKey(last);
        p.savedAmount += p.targetAmount;
        guard++;
        changed = true;
      }
      p.lastRefillMonth = current;
    } else if (p.kind == PocketKind.yearly && p.dueDate != null) {
      var due = p.dueDate!;
      while (due.isBefore(today)) {
        due = DateTime(due.year + 1, due.month, due.day);
        changed = true;
      }
      p.dueDate = due;
    }
    return changed;
  }

  /// Dinero apartado por cuenta (solo saldos positivos).
  static Map<int, double> setAsideByAccount(Iterable<Pocket> pockets) {
    final map = <int, double>{};
    for (final p in pockets) {
      if (p.accountId == null || p.savedAmount <= 0) continue;
      map[p.accountId!] = (map[p.accountId!] ?? 0) + p.savedAmount;
    }
    return map;
  }
}
