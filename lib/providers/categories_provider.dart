import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../data/models/category.dart';
import '../data/repositories/category_repository.dart';
import '../data/services/isar_service.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(),
);

/// Todas las categorías ordenadas por sortOrder.
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final isar = IsarService.instance.isar;
  return isar.categorys.where().sortBySortOrder().watch(fireImmediately: true);
});

/// Categorías filtradas por tipo de transacción (gasto/ingreso).
final categoriesByTypeProvider = Provider.family<List<Category>, CategoryType>((
  ref,
  type,
) {
  final all = ref.watch(categoriesProvider).valueOrNull ?? const [];
  return all
      .where((c) => c.type == type || c.type == CategoryType.both)
      .toList();
});
