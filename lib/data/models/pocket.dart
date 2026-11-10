import 'package:isar/isar.dart';

part 'pocket.g.dart';

/// Cómo se comporta un bolsillo.
enum PocketKind {
  /// Meta única (viaje, fondo de emergencia). Puede tener fecha límite.
  goal,

  /// Gasto de cada mes (gasolina, peajes). Se recarga el día 1 con
  /// [Pocket.targetAmount]; lo que no se gasta pasa al mes siguiente.
  monthly,

  /// Pago anual con vencimiento (SOAT, impuesto). Cuando vence, la fecha
  /// pasa al año siguiente.
  yearly,
}

/// Bolsillo dentro de un [SavingsGroup].
///
/// El dinero de un bolsillo se APARTA de una cuenta real ([accountId]):
/// sigue en la cuenta, pero deja de contar como disponible para gastar.
/// Los bolsillos migrados de las metas antiguas no tienen cuenta.
@collection
class Pocket {
  Id id = Isar.autoIncrement;

  @Index()
  late int groupId;

  late String name;
  late String iconName;

  @Enumerated(EnumType.name)
  late PocketKind kind;

  /// Meta: total a reunir. Mensual: monto de cada mes. Anual: monto anual.
  late double targetAmount;

  /// Lo apartado hoy. Puede quedar negativo si se gastó más de lo apartado.
  late double savedAmount;

  /// Meta: fecha límite opcional. Anual: próximo vencimiento.
  DateTime? dueDate;

  /// Cuenta de donde se aparta el dinero.
  int? accountId;

  /// Mensual: último mes recargado, como yyyymm (202611).
  int? lastRefillMonth;

  late bool isCompleted;
  late int sortOrder;
  late DateTime createdAt;
}
