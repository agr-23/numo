import 'package:isar/isar.dart';

import 'category.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;
  late double limitAmount;

  @Index(composite: [CompositeIndex('year')])
  late int month; // 1-12
  late int year;

  // spentAmount se calcula en tiempo real desde las transacciones.
  final category = IsarLink<Category>();
}
