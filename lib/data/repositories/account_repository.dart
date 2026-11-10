import 'package:isar/isar.dart';

import '../models/account.dart';
import '../services/isar_service.dart';

class AccountRepository {
  Isar get _isar => IsarService.instance.isar;

  Stream<List<Account>> watchActive() {
    return _isar.accounts
        .filter()
        .isActiveEqualTo(true)
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  Stream<List<Account>> watchAll() {
    return _isar.accounts.where().sortByCreatedAt().watch(
      fireImmediately: true,
    );
  }

  Future<List<Account>> getActive() {
    return _isar.accounts.filter().isActiveEqualTo(true).findAll();
  }

  Future<Account?> getById(int id) => _isar.accounts.get(id);

  Stream<Account?> watchById(int id) =>
      _isar.accounts.watchObject(id, fireImmediately: true);

  Future<int> add(Account account) {
    return _isar.writeTxn(() => _isar.accounts.put(account));
  }

  Future<void> update(Account account) {
    return _isar.writeTxn(() => _isar.accounts.put(account));
  }

  /// Archiva (no elimina) para preservar el historial.
  Future<void> archive(int id) async {
    await _isar.writeTxn(() async {
      final account = await _isar.accounts.get(id);
      if (account != null) {
        account.isActive = false;
        await _isar.accounts.put(account);
      }
    });
  }

  /// Saldo neto: efectivo + banco − deuda de crédito.
  static double netBalance(List<Account> accounts) {
    var net = 0.0;
    for (final a in accounts) {
      net += a.type == AccountType.credit ? -a.balance : a.balance;
    }
    return net;
  }
}
