import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/default_categories.dart';
import '../models/account.dart';
import '../models/app_settings.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../models/pocket.dart';
import '../models/savings_goal.dart';
import '../models/savings_group.dart';
import '../models/transaction.dart';

/// Punto de acceso único a la base de datos Isar.
class IsarService {
  IsarService._(this.isar);

  final Isar isar;

  static IsarService? _instance;
  static IsarService get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('IsarService no inicializado. Llama a IsarService.init().');
    }
    return i;
  }

  /// Abre Isar, siembra datos por defecto y devuelve la instancia.
  static Future<IsarService> init() async {
    if (_instance != null) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        AccountSchema,
        CategorySchema,
        TransactionSchema,
        BudgetSchema,
        SavingsGoalSchema,
        AppSettingsSchema,
        SavingsGroupSchema,
        PocketSchema,
      ],
      directory: dir.path,
      name: 'numo',
    );

    final service = IsarService._(isar);
    await service._seed();
    await service._migrateGoalsToPockets();
    _instance = service;
    return service;
  }

  /// Siembra ajustes y categorías por defecto la primera vez.
  Future<void> _seed() async {
    final settings = await isar.appSettings.get(1);
    if (settings == null) {
      await isar.writeTxn(() async {
        await isar.appSettings.put(AppSettings.defaults());
      });
    }

    final categoryCount = await isar.categorys.count();
    if (categoryCount == 0) {
      await isar.writeTxn(() async {
        await isar.categorys.putAll(buildDefaultCategories());
      });
    } else {
      await _backfillCategoryKeys();
    }
  }

  /// Instalaciones anteriores a los idiomas: asigna la clave a las
  /// categorías predefinidas reconociéndolas por su nombre en español.
  Future<void> _backfillCategoryKeys() async {
    final predefined =
        await isar.categorys.filter().isCustomEqualTo(false).findAll();
    final missing = predefined.where((c) => c.key == null).toList();
    if (missing.isEmpty) return;
    final byName = {for (final s in kDefaultCategories) s.name: s.key};
    for (final c in missing) {
      c.key = byName[c.name];
    }
    await isar.writeTxn(() => isar.categorys.putAll(missing));
  }

  /// Las metas de ahorro antiguas pasan a ser grupos con un bolsillo de
  /// tipo meta, conservando lo ahorrado. Sin cuenta asociada: ese dinero
  /// se registró aparte de las cuentas, así que se sigue contando aparte.
  Future<void> _migrateGoalsToPockets() async {
    final goals = await isar.savingsGoals.where().findAll();
    if (goals.isEmpty) return;
    await isar.writeTxn(() async {
      var order = await isar.savingsGroups.count();
      for (final g in goals) {
        final group = SavingsGroup()
          ..name = g.name
          ..iconName = g.iconName
          ..colorHex = g.colorHex
          ..sortOrder = order++
          ..createdAt = g.createdAt;
        final groupId = await isar.savingsGroups.put(group);
        await isar.pockets.put(Pocket()
          ..groupId = groupId
          ..name = g.name
          ..iconName = g.iconName
          ..kind = PocketKind.goal
          ..targetAmount = g.targetAmount
          ..savedAmount = g.currentAmount
          ..dueDate = g.targetDate
          ..isCompleted = g.isCompleted
          ..sortOrder = 0
          ..createdAt = g.createdAt);
      }
      await isar.savingsGoals.clear();
    });
  }

  /// Borra todas las colecciones (usado por "Borrar todos los datos").
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.transactions.clear();
      await isar.accounts.clear();
      await isar.budgets.clear();
      await isar.savingsGoals.clear();
      await isar.savingsGroups.clear();
      await isar.pockets.clear();
      await isar.categorys.clear();
      // Mantenemos AppSettings; se reconstruyen categorías al reiniciar seed.
    });
    await _seed();
  }
}
