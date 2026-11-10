import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/transaction.dart';
import 'transactions_provider.dart';

/// Estado de filtros de la lista de movimientos.
class TransactionFilter {
  final TransactionType? type; // null = todos
  final Set<int> categoryIds;
  final Set<int> accountIds;
  final DateTimeRange? dateRange;
  final String query;

  const TransactionFilter({
    this.type,
    this.categoryIds = const {},
    this.accountIds = const {},
    this.dateRange,
    this.query = '',
  });

  /// ¿Hay filtros activos? (la búsqueda no cuenta para el badge)
  bool get hasActiveFilters =>
      type != null ||
      categoryIds.isNotEmpty ||
      accountIds.isNotEmpty ||
      dateRange != null;

  TransactionFilter copyWith({
    TransactionType? type,
    bool clearType = false,
    Set<int>? categoryIds,
    Set<int>? accountIds,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
    String? query,
  }) {
    return TransactionFilter(
      type: clearType ? null : (type ?? this.type),
      categoryIds: categoryIds ?? this.categoryIds,
      accountIds: accountIds ?? this.accountIds,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      query: query ?? this.query,
    );
  }
}

class TransactionFilterNotifier extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => const TransactionFilter();

  void setType(TransactionType? type) =>
      state = state.copyWith(type: type, clearType: type == null);

  void toggleCategory(int id) {
    final next = {...state.categoryIds};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = state.copyWith(categoryIds: next);
  }

  void toggleAccount(int id) {
    final next = {...state.accountIds};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = state.copyWith(accountIds: next);
  }

  void setDateRange(DateTimeRange? range) =>
      state = state.copyWith(dateRange: range, clearDateRange: range == null);

  void setQuery(String q) => state = state.copyWith(query: q);

  void clearFilters() =>
      state = TransactionFilter(query: state.query);
}

final transactionFilterProvider =
    NotifierProvider<TransactionFilterNotifier, TransactionFilter>(
        TransactionFilterNotifier.new);

/// Lista de movimientos tras aplicar filtros y búsqueda.
final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final all = ref.watch(transactionsProvider).valueOrNull ?? const [];
  final f = ref.watch(transactionFilterProvider);

  return all.where((t) {
    if (f.type != null && t.type != f.type) return false;
    if (f.categoryIds.isNotEmpty) {
      final cid = t.category.value?.id;
      if (cid == null || !f.categoryIds.contains(cid)) return false;
    }
    if (f.accountIds.isNotEmpty) {
      final aid = t.account.value?.id;
      final toId = t.toAccount.value?.id;
      if (!(aid != null && f.accountIds.contains(aid)) &&
          !(toId != null && f.accountIds.contains(toId))) {
        return false;
      }
    }
    if (f.dateRange != null) {
      final d = DateTime(t.date.year, t.date.month, t.date.day);
      final start = DateTime(f.dateRange!.start.year, f.dateRange!.start.month,
          f.dateRange!.start.day);
      final end = DateTime(
          f.dateRange!.end.year, f.dateRange!.end.month, f.dateRange!.end.day);
      if (d.isBefore(start) || d.isAfter(end)) return false;
    }
    if (f.query.trim().isNotEmpty) {
      final q = f.query.trim().toLowerCase();
      final inTitle = t.title.toLowerCase().contains(q);
      final inNote = (t.note ?? '').toLowerCase().contains(q);
      final inCat = (t.category.value?.name ?? '').toLowerCase().contains(q);
      if (!inTitle && !inNote && !inCat) return false;
    }
    return true;
  }).toList();
});

/// Agrupa transacciones por día (ya vienen ordenadas desc).
class DayGroup {
  final DateTime day;
  final List<Transaction> items;
  const DayGroup(this.day, this.items);

  /// Neto del día: ingresos − gastos (transferencias no cuentan).
  double get net {
    var sum = 0.0;
    for (final t in items) {
      if (t.type == TransactionType.income) sum += t.amount;
      if (t.type == TransactionType.expense) sum -= t.amount;
    }
    return sum;
  }
}

List<DayGroup> groupByDay(List<Transaction> txs) {
  final groups = <String, List<Transaction>>{};
  final order = <String>[];
  for (final t in txs) {
    final key =
        '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}';
    final list = groups.putIfAbsent(key, () {
      order.add(key);
      return <Transaction>[];
    });
    list.add(t);
  }
  return [
    for (final key in order)
      DayGroup(
        DateTime(
          int.parse(key.split('-')[0]),
          int.parse(key.split('-')[1]),
          int.parse(key.split('-')[2]),
        ),
        groups[key]!,
      ),
  ];
}
