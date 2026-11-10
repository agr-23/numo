import 'package:isar/isar.dart';

import '../models/savings_goal.dart';
import '../services/isar_service.dart';

class SavingsGoalRepository {
  Isar get _isar => IsarService.instance.isar;

  Stream<List<SavingsGoal>> watchAll() {
    return _isar.savingsGoals
        .where()
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  Future<void> add(SavingsGoal goal) {
    return _isar.writeTxn(() => _isar.savingsGoals.put(goal));
  }

  Future<void> delete(int id) {
    return _isar.writeTxn(() => _isar.savingsGoals.delete(id));
  }

  /// Aporta [amount] a la meta. Devuelve true si quedó completada con
  /// este aporte (transición de no-completada a completada).
  Future<bool> contribute(int id, double amount) async {
    var justCompleted = false;
    await _isar.writeTxn(() async {
      final goal = await _isar.savingsGoals.get(id);
      if (goal == null) return;
      final wasCompleted = goal.isCompleted;
      goal.currentAmount += amount;
      if (goal.currentAmount >= goal.targetAmount) {
        goal.isCompleted = true;
      }
      justCompleted = !wasCompleted && goal.isCompleted;
      await _isar.savingsGoals.put(goal);
    });
    return justCompleted;
  }
}
