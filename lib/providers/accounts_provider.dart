import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/account.dart';
import '../data/repositories/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(),
);

/// Cuentas activas (las archivadas se excluyen).
final accountsProvider = StreamProvider<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchActive();
});

/// Todas las cuentas, incluidas archivadas.
final allAccountsProvider = StreamProvider<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
});

/// Una cuenta concreta (para AccountDetailScreen).
final accountByIdProvider = StreamProvider.family<Account?, int>((ref, id) {
  return ref.watch(accountRepositoryProvider).watchById(id);
});

/// Saldo neto total: efectivo + banco − deuda.
final netBalanceProvider = Provider<double>((ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
  return AccountRepository.netBalance(accounts);
});
