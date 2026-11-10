import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/default_categories.dart';
import '../models/account.dart';
import '../models/app_settings.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../models/savings_goal.dart';
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
      ],
      directory: dir.path,
      name: 'numo',
    );

    final service = IsarService._(isar);
    await service._seed();
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
    }
  }

  /// Borra todas las colecciones (usado por "Borrar todos los datos").
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.transactions.clear();
      await isar.accounts.clear();
      await isar.budgets.clear();
      await isar.savingsGoals.clear();
      await isar.categorys.clear();
      // Mantenemos AppSettings; se reconstruyen categorías al reiniciar seed.
    });
    await _seed();
  }
}
