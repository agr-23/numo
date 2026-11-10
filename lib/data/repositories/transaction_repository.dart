import 'package:isar/isar.dart';

import '../models/account.dart';
import '../models/category.dart';
import '../models/pocket.dart';
import '../models/transaction.dart';
import '../services/isar_service.dart';

class TransactionRepository {
  Isar get _isar => IsarService.instance.isar;

  /// Carga los IsarLinks de cada transacción de forma síncrona.
  List<Transaction> _withLinks(List<Transaction> list) {
    for (final t in list) {
      t.category.loadSync();
      t.account.loadSync();
      t.toAccount.loadSync();
    }
    return list;
  }

  Stream<List<Transaction>> watchAll() {
    return _isar.transactions
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true)
        .map(_withLinks);
  }

  Future<List<Transaction>> getPage({
    required int offset,
    int limit = 30,
  }) async {
    final list = await _isar.transactions
        .where()
        .sortByDateDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
    return _withLinks(list);
  }

  Future<Transaction?> getById(int id) async {
    final t = await _isar.transactions.get(id);
    if (t != null) _withLinks([t]);
    return t;
  }

  /// Crea una transacción, fija sus relaciones y ajusta los saldos.
  Future<int> add(
    Transaction tx, {
    required int accountId,
    int? categoryId,
    int? toAccountId,
  }) async {
    late int id;
    await _isar.writeTxn(() async {
      id = await _isar.transactions.put(tx);
      tx.account.value = await _isar.accounts.get(accountId);
      if (categoryId != null) {
        tx.category.value = await _isar.categorys.get(categoryId);
      }
      if (toAccountId != null) {
        tx.toAccount.value = await _isar.accounts.get(toAccountId);
      }
      await tx.account.save();
      await tx.category.save();
      await tx.toAccount.save();
      await _applyBalances(tx, reverse: false);
    });
    return id;
  }

  /// Actualiza una transacción: revierte el efecto anterior y aplica el nuevo.
  Future<void> update(
    Transaction tx, {
    required int accountId,
    int? categoryId,
    int? toAccountId,
  }) async {
    await _isar.writeTxn(() async {
      final old = await _isar.transactions.get(tx.id);
      if (old != null) {
        old.account.loadSync();
        old.toAccount.loadSync();
        await _applyBalances(old, reverse: true);
      }
      await _isar.transactions.put(tx);
      tx.account.value = await _isar.accounts.get(accountId);
      tx.category.value =
          categoryId != null ? await _isar.categorys.get(categoryId) : null;
      tx.toAccount.value =
          toAccountId != null ? await _isar.accounts.get(toAccountId) : null;
      await tx.account.save();
      await tx.category.save();
      await tx.toAccount.save();
      await _applyBalances(tx, reverse: false);
    });
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      final tx = await _isar.transactions.get(id);
      if (tx == null) return;
      tx.account.loadSync();
      tx.toAccount.loadSync();
      await _applyBalances(tx, reverse: true);
      await _isar.transactions.delete(id);
    });
  }

  /// Ajusta los saldos de las cuentas afectadas por [tx].
  /// Debe ejecutarse dentro de un writeTxn.
  Future<void> _applyBalances(Transaction tx, {required bool reverse}) async {
    final sign = reverse ? -1.0 : 1.0;

    // Un gasto pagado desde un bolsillo usa lo apartado: el bolsillo baja.
    if (tx.type == TransactionType.expense && tx.pocketId != null) {
      final pocket = await _isar.pockets.get(tx.pocketId!);
      if (pocket != null) {
        pocket.savedAmount -= sign * tx.amount;
        await _isar.pockets.put(pocket);
      }
    }

    final source = tx.account.value;
    if (source == null) return;

    if (tx.type == TransactionType.transfer) {
      final dest = tx.toAccount.value;
      source.balance += sign * _delta(source.type, tx.type, tx.amount, isSource: true);
      await _isar.accounts.put(source);
      if (dest != null) {
        dest.balance += sign * _delta(dest.type, tx.type, tx.amount, isSource: false);
        await _isar.accounts.put(dest);
      }
    } else {
      source.balance += sign * _delta(source.type, tx.type, tx.amount, isSource: true);
      await _isar.accounts.put(source);
    }
  }

  /// Delta a sumar al saldo almacenado de una cuenta. Para crédito, el
  /// saldo representa deuda (positivo = debe).
  static double _delta(
    AccountType type,
    TransactionType txType,
    double amount, {
    required bool isSource,
  }) {
    switch (txType) {
      case TransactionType.expense:
        return type == AccountType.credit ? amount : -amount;
      case TransactionType.income:
        return type == AccountType.credit ? -amount : amount;
      case TransactionType.transfer:
        if (isSource) {
          return type == AccountType.credit ? amount : -amount;
        }
        return type == AccountType.credit ? -amount : amount;
    }
  }
}
