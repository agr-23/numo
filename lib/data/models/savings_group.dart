import 'package:isar/isar.dart';

part 'savings_group.g.dart';

/// Grupo de ahorro (ej. "Carro"). Su total es la suma de sus bolsillos.
@collection
class SavingsGroup {
  Id id = Isar.autoIncrement;
  late String name;
  late String iconName;
  late String colorHex;
  late int sortOrder;
  late DateTime createdAt;

  /// Plantilla con la que se creó ('car', 'home'…) para sugerir bolsillos.
  String? templateKey;
}
