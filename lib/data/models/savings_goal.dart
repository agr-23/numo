import 'package:isar/isar.dart';

part 'savings_goal.g.dart';

@collection
class SavingsGoal {
  Id id = Isar.autoIncrement;
  late String name;
  late double targetAmount;
  late double currentAmount;
  DateTime? targetDate;
  late String colorHex;
  late String iconName;
  late bool isCompleted;
  late DateTime createdAt;
}
