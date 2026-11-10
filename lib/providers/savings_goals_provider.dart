import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/savings_goal.dart';
import '../data/repositories/savings_goal_repository.dart';

final savingsGoalRepositoryProvider =
    Provider<SavingsGoalRepository>((ref) => SavingsGoalRepository());

final savingsGoalsProvider = StreamProvider<List<SavingsGoal>>((ref) {
  return ref.watch(savingsGoalRepositoryProvider).watchAll();
});

/// Metas ordenadas: activas primero, completadas al final.
final sortedSavingsGoalsProvider = Provider<List<SavingsGoal>>((ref) {
  final goals = ref.watch(savingsGoalsProvider).valueOrNull ?? const [];
  final active = goals.where((g) => !g.isCompleted).toList();
  final completed = goals.where((g) => g.isCompleted).toList();
  return [...active, ...completed];
});
