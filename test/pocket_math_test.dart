import 'package:flutter_test/flutter_test.dart';
import 'package:numo/core/utils/pocket_math.dart';
import 'package:numo/data/models/pocket.dart';

Pocket pocket({
  int id = 1,
  PocketKind kind = PocketKind.yearly,
  double target = 980000,
  double saved = 0,
  DateTime? due,
  int? accountId,
  int? lastRefill,
}) =>
    Pocket()
      ..id = id
      ..groupId = 1
      ..name = 'P$id'
      ..iconName = 'shield'
      ..kind = kind
      ..targetAmount = target
      ..savedAmount = saved
      ..dueDate = due
      ..accountId = accountId
      ..lastRefillMonth = lastRefill
      ..isCompleted = false
      ..sortOrder = 0
      ..createdAt = DateTime(2026);

void main() {
  final now = DateTime(2026, 11, 10);

  group('sugerencia mensual', () {
    test('anual: lo que falta entre los meses que quedan', () {
      // SOAT: faltan 560.000 y vence en marzo (4 meses) → 140.000/mes.
      final soat = pocket(saved: 420000, due: DateTime(2027, 3, 12));
      expect(PocketMath.suggestedMonthly(soat, now), 140000);
    });

    test('mensual: lo que falta para completar el mes', () {
      final fuel =
          pocket(kind: PocketKind.monthly, target: 400000, saved: 280000);
      expect(PocketMath.suggestedMonthly(fuel, now), 120000);
    });

    test('redondea a miles hacia arriba', () {
      // Impuesto: faltan 1.790.000 en 7 meses → 255.715 → 256.000.
      final tax = pocket(
          target: 1940000, saved: 150000, due: DateTime(2027, 6, 30));
      expect(PocketMath.suggestedMonthly(tax, now), 256000);
    });

    test('meta sin fecha no sugiere ritmo', () {
      expect(
          PocketMath.suggestedMonthly(pocket(kind: PocketKind.goal), now), null);
    });

    test('completo sugiere 0', () {
      expect(PocketMath.suggestedMonthly(pocket(saved: 980000, due: now), now),
          0);
    });
  });

  test('repartir: según lo que falta y suma exacta', () {
    final a = pocket(id: 1, target: 300000, saved: 0); // faltan 300.000
    final b = pocket(id: 2, target: 200000, saved: 100000); // faltan 100.000
    final shares = PocketMath.distribute([a, b], 100000);
    expect(shares[1], 75000);
    expect(shares[2], 25000);
    expect(shares.values.reduce((x, y) => x + y), 100000);
  });

  test('repartir: si todo está lleno, según la meta', () {
    final a = pocket(id: 1, target: 100, saved: 100);
    final b = pocket(id: 2, target: 300, saved: 300);
    final shares = PocketMath.distribute([a, b], 40);
    expect(shares[1], 10);
    expect(shares[2], 30);
  });

  group('recargas y vencimientos', () {
    test('mensual: recarga una vez por mes y acumula lo no gastado', () {
      final fuel = pocket(
          kind: PocketKind.monthly,
          target: 400000,
          saved: 50000,
          lastRefill: 202609);
      expect(PocketMath.roll(fuel, now), isTrue);
      // Octubre y noviembre: +400.000 cada uno, sobre los 50.000 que quedaban.
      expect(fuel.savedAmount, 850000);
      expect(fuel.lastRefillMonth, 202611);
      // Volver a abrir la app el mismo mes no recarga otra vez.
      expect(PocketMath.roll(fuel, now), isFalse);
      expect(fuel.savedAmount, 850000);
    });

    test('mensual: cruza el año', () {
      final p = pocket(
          kind: PocketKind.monthly, target: 10, saved: 0, lastRefill: 202612);
      PocketMath.roll(p, DateTime(2027, 1, 2));
      expect(p.savedAmount, 10);
      expect(p.lastRefillMonth, 202701);
    });

    test('anual: al vencer pasa al año siguiente', () {
      final soat = pocket(due: DateTime(2026, 3, 12));
      expect(PocketMath.roll(soat, now), isTrue);
      expect(soat.dueDate, DateTime(2027, 3, 12));
    });
  });

  test('apartado por cuenta ignora saldos negativos y sin cuenta', () {
    final map = PocketMath.setAsideByAccount([
      pocket(id: 1, saved: 100, accountId: 7),
      pocket(id: 2, saved: 50, accountId: 7),
      pocket(id: 3, saved: -20, accountId: 7),
      pocket(id: 4, saved: 999),
    ]);
    expect(map, {7: 150});
  });
}
