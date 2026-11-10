import 'package:isar/isar.dart';

import '../models/budget.dart';
import '../models/category.dart';
import '../services/isar_service.dart';

class BudgetRepository {
  Isar get _isar => IsarService.instance.isar;

  List<Budget> _withLinks(List<Budget> list) {
    for (final b in list) {
      b.category.loadSync();
    }
    return list;
  }

  Stream<List<Budget>> watchAll() {
    return _isar.budgets
        .where()
        .watch(fireImmediately: true)
        .map(_withLinks);
  }

  Future<Budget?> findForCategoryMonth(
      int categoryId, int month, int year) async {
    final candidates = await _isar.budgets
        .filter()
        .monthEqualTo(month)
        .and()
        .yearEqualTo(year)
        .findAll();
    _withLinks(candidates);
    for (final b in candidates) {
      if (b.category.value?.id == categoryId) return b;
    }
    return null;
  }

  Future<void> upsert(Budget budget, int categoryId) async {
    await _isar.writeTxn(() async {
      await _isar.budgets.put(budget);
      budget.category.value = await _isar.categorys.get(categoryId);
      await budget.category.save();
    });
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.budgets.delete(id));
  }
}
