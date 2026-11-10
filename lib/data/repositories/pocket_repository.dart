import 'package:isar/isar.dart';

import '../../core/utils/pocket_math.dart';
import '../models/pocket.dart';
import '../models/savings_group.dart';
import '../services/isar_service.dart';

/// Grupos de ahorro y sus bolsillos.
class PocketRepository {
  Isar get _isar => IsarService.instance.isar;

  Stream<List<SavingsGroup>> watchGroups() => _isar.savingsGroups
      .where()
      .sortBySortOrder()
      .watch(fireImmediately: true);

  Stream<List<Pocket>> watchPockets() =>
      _isar.pockets.where().sortBySortOrder().watch(fireImmediately: true);

  Future<int> _nextGroupOrder() async =>
      ((await _isar.savingsGroups.where().sortBySortOrderDesc().findFirst())
                  ?.sortOrder ??
              -1) +
      1;

  Future<int> _nextPocketOrder(int groupId) async {
    final last = await _isar.pockets
        .filter()
        .groupIdEqualTo(groupId)
        .sortBySortOrderDesc()
        .findFirst();
    return (last?.sortOrder ?? -1) + 1;
  }

  Future<int> saveGroup(SavingsGroup group) async {
    if (group.id == Isar.autoIncrement) {
      group
        ..sortOrder = await _nextGroupOrder()
        ..createdAt = DateTime.now();
    }
    return _isar.writeTxn(() => _isar.savingsGroups.put(group));
  }

  /// Borra el grupo y sus bolsillos. Lo apartado vuelve a estar disponible
  /// en sus cuentas (no hay que mover saldos: nunca salió de ellas).
  Future<void> deleteGroup(int id) async {
    await _isar.writeTxn(() async {
      await _isar.pockets.filter().groupIdEqualTo(id).deleteAll();
      await _isar.savingsGroups.delete(id);
    });
  }

  Future<int> savePocket(Pocket pocket) async {
    if (pocket.id == Isar.autoIncrement) {
      pocket
        ..sortOrder = await _nextPocketOrder(pocket.groupId)
        ..createdAt = DateTime.now()
        ..lastRefillMonth = PocketMath.monthKey(DateTime.now());
    }
    _updateCompleted(pocket);
    return _isar.writeTxn(() => _isar.pockets.put(pocket));
  }

  Future<void> deletePocket(int id) =>
      _isar.writeTxn(() => _isar.pockets.delete(id));

  void _updateCompleted(Pocket p) {
    p.isCompleted = p.kind == PocketKind.goal &&
        p.targetAmount > 0 &&
        p.savedAmount >= p.targetAmount;
  }

  /// Aparta [amount] en el bolsillo desde [accountId]. Devuelve true si una
  /// meta quedó completa con este aporte.
  Future<bool> contribute(int pocketId, double amount, int? accountId) async {
    var justCompleted = false;
    await _isar.writeTxn(() async {
      final p = await _isar.pockets.get(pocketId);
      if (p == null) return;
      final was = p.isCompleted;
      p.savedAmount += amount;
      if (accountId != null) p.accountId = accountId;
      _updateCompleted(p);
      justCompleted = !was && p.isCompleted;
      await _isar.pockets.put(p);
    });
    return justCompleted;
  }

  /// Devuelve [amount] del bolsillo a su cuenta (vuelve a ser disponible).
  Future<void> withdraw(int pocketId, double amount) async {
    await _isar.writeTxn(() async {
      final p = await _isar.pockets.get(pocketId);
      if (p == null) return;
      p.savedAmount -= amount;
      if (p.savedAmount < 0) p.savedAmount = 0;
      _updateCompleted(p);
      await _isar.pockets.put(p);
    });
  }

  /// Reparte un aporte entre varios bolsillos según lo que le falta a cada
  /// uno. Devuelve true si alguna meta quedó completa.
  Future<bool> distribute(
      List<Pocket> pockets, double amount, int? accountId) async {
    final shares = PocketMath.distribute(pockets, amount);
    var anyCompleted = false;
    await _isar.writeTxn(() async {
      for (final entry in shares.entries) {
        final p = await _isar.pockets.get(entry.key);
        if (p == null || entry.value <= 0) continue;
        final was = p.isCompleted;
        p.savedAmount += entry.value;
        if (accountId != null && (p.accountId == null || p.savedAmount == entry.value)) {
          p.accountId = accountId;
        }
        _updateCompleted(p);
        anyCompleted |= !was && p.isCompleted;
        await _isar.pockets.put(p);
      }
    });
    return anyCompleted;
  }

  /// Recargas mensuales y vencimientos anuales. Se ejecuta al abrir la app.
  static Future<void> rollAll(Isar isar, DateTime now) async {
    final pockets = await isar.pockets.where().findAll();
    final changed = pockets.where((p) => PocketMath.roll(p, now)).toList();
    if (changed.isEmpty) return;
    await isar.writeTxn(() => isar.pockets.putAll(changed));
  }
}
