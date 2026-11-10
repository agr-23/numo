import 'package:isar/isar.dart';

part 'category.g.dart';

enum CategoryType { expense, income, both }

@collection
class Category {
  Id id = Isar.autoIncrement;
  late String name;
  late String iconName;
  late String colorHex;

  @Enumerated(EnumType.name)
  late CategoryType type;

  late bool isCustom;
  late int sortOrder;
}
