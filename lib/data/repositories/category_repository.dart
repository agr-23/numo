import 'package:isar/isar.dart';

import '../models/category.dart';
import '../services/isar_service.dart';

class CategoryRepository {
  Isar get _isar => IsarService.instance.isar;

  Future<int> _nextSortOrder() async {
    final last = await _isar.categorys
        .where()
        .sortBySortOrderDesc()
        .findFirst();
    return (last?.sortOrder ?? -1) + 1;
  }

  Future<void> add(Category category) async {
    category.sortOrder = await _nextSortOrder();
    await _isar.writeTxn(() => _isar.categorys.put(category));
  }

  Future<void> update(Category category) {
    return _isar.writeTxn(() => _isar.categorys.put(category));
  }

  /// Elimina una categoría personalizada. Las predefinidas no se borran.
  Future<bool> delete(int id) async {
    final cat = await _isar.categorys.get(id);
    if (cat == null || !cat.isCustom) return false;
    await _isar.writeTxn(() => _isar.categorys.delete(id));
    return true;
  }
}
