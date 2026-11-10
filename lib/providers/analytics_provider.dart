import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/date_formatter.dart';
import '../data/models/category.dart';
import '../data/models/transaction.dart';
import 'transactions_provider.dart';

enum AnalyticsPeriod { week, month, year, custom }

final analyticsPeriodProvider =
    StateProvider<AnalyticsPeriod>((ref) => AnalyticsPeriod.month);

final analyticsCustomRangeProvider =
    StateProvider<DateTimeRange?>((ref) => null);

/// Rango de fechas efectivo según el período seleccionado.
final analyticsRangeProvider = Provider<DateTimeRange>((ref) {
  final period = ref.watch(analyticsPeriodProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  switch (period) {
    case AnalyticsPeriod.week:
      final start = today.subtract(Duration(days: today.weekday - 1));
      return DateTimeRange(start: start, end: today);
    case AnalyticsPeriod.month:
      return DateTimeRange(start: DateTime(now.year, now.month, 1), end: today);
    case AnalyticsPeriod.year:
      return DateTimeRange(start: DateTime(now.year, 1, 1), end: today);
    case AnalyticsPeriod.custom:
      return ref.watch(analyticsCustomRangeProvider) ??
          DateTimeRange(start: DateTime(now.year, now.month, 1), end: today);
  }
});

class CategorySlice {
  final Category category; // el nombre visible se traduce en la UI
  final double amount;
  final double percent; // 0..1
  const CategorySlice(this.category, this.amount, this.percent);
  String get colorHex => category.colorHex;
}

class AnalyticsSummary {
  final double income;
  final double expense;
  final List<CategorySlice> slices; // gasto por categoría, desc
  const AnalyticsSummary({
    required this.income,
    required this.expense,
    required this.slices,
  });
  double get net => income - expense;
}

bool _inRange(DateTime d, DateTimeRange r) {
  final day = DateTime(d.year, d.month, d.day);
  final start = DateTime(r.start.year, r.start.month, r.start.day);
  final end = DateTime(r.end.year, r.end.month, r.end.day);
  return !day.isBefore(start) && !day.isAfter(end);
}

final analyticsSummaryProvider = Provider<AnalyticsSummary>((ref) {
  final range = ref.watch(analyticsRangeProvider);
  final txs = ref.watch(transactionsProvider).valueOrNull ?? const [];

  var income = 0.0;
  var expense = 0.0;
  final byCategory = <int, double>{};
  final catInfo = <int, Category>{};

  for (final t in txs) {
    if (!_inRange(t.date, range)) continue;
    if (t.type == TransactionType.income) {
      income += t.amount;
    } else if (t.type == TransactionType.expense) {
      expense += t.amount;
      final c = t.category.value;
      if (c != null) {
        byCategory[c.id] = (byCategory[c.id] ?? 0) + t.amount;
        catInfo[c.id] = c;
      }
    }
  }

  final slices = <CategorySlice>[
    for (final entry in byCategory.entries)
      CategorySlice(
        catInfo[entry.key]!,
        entry.value,
        expense <= 0 ? 0 : entry.value / expense,
      ),
  ]..sort((a, b) => b.amount.compareTo(a.amount));

  return AnalyticsSummary(income: income, expense: expense, slices: slices);
});

class PeriodBar {
  final String label;
  final double income;
  final double expense;
  const PeriodBar(this.label, this.income, this.expense);
}

/// Serie para el gráfico de barras: últimos 6 meses, o 6 semanas si el
/// período seleccionado es "Esta semana".
final analyticsSeriesProvider = Provider<List<PeriodBar>>((ref) {
  final period = ref.watch(analyticsPeriodProvider);
  final txs = ref.watch(transactionsProvider).valueOrNull ?? const [];
  final now = DateTime.now();

  if (period == AnalyticsPeriod.week) {
    final bars = <PeriodBar>[];
    final thisWeekStart =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    for (var i = 5; i >= 0; i--) {
      final start = thisWeekStart.subtract(Duration(days: 7 * i));
      final end = start.add(const Duration(days: 6));
      var income = 0.0;
      var expense = 0.0;
      for (final t in txs) {
        final d = DateTime(t.date.year, t.date.month, t.date.day);
        if (d.isBefore(start) || d.isAfter(end)) continue;
        if (t.type == TransactionType.income) income += t.amount;
        if (t.type == TransactionType.expense) expense += t.amount;
      }
      bars.add(PeriodBar(DateFormatter.shortDay(start), income, expense));
    }
    return bars;
  }

  final bars = <PeriodBar>[];
  for (var i = 5; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i, 1);
    var income = 0.0;
    var expense = 0.0;
    for (final t in txs) {
      if (t.date.year != month.year || t.date.month != month.month) continue;
      if (t.type == TransactionType.income) income += t.amount;
      if (t.type == TransactionType.expense) expense += t.amount;
    }
    bars.add(PeriodBar(DateFormatter.shortMonth(month), income, expense));
  }
  return bars;
});
