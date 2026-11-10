import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/app_settings.dart';
import '../../../providers/analytics_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/empty_state.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _touchedSlice = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final period = ref.watch(analyticsPeriodProvider);
    final summary = ref.watch(analyticsSummaryProvider);
    final series = ref.watch(analyticsSeriesProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analíticas')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Dimens.screenPaddingH, 8, Dimens.screenPaddingH, 96),
        children: [
          _periodSelector(period),
          const SizedBox(height: Dimens.sectionGap),
          _metricCards(theme, summary, settings),
          const SizedBox(height: Dimens.sectionGap),
          Text('Gastos por categoría', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _donut(theme, summary, settings),
          const SizedBox(height: Dimens.sectionGap),
          Text(
            period == AnalyticsPeriod.week
                ? 'Ingresos y gastos (6 semanas)'
                : 'Ingresos y gastos (6 meses)',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _barChart(theme, series, settings),
          const SizedBox(height: Dimens.sectionGap),
          if (summary.slices.isNotEmpty) ...[
            Text('Ranking de categorías', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final s in summary.slices)
              _rankingRow(theme, s, settings),
          ],
        ],
      ),
    );
  }

  Widget _periodSelector(AnalyticsPeriod current) {
    Widget chip(String label, AnalyticsPeriod p) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: current == p,
          onSelected: (_) async {
            if (p == AnalyticsPeriod.custom) {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2015),
                lastDate: DateTime(2100),
              );
              if (range != null) {
                ref.read(analyticsCustomRangeProvider.notifier).state = range;
              } else {
                return;
              }
            }
            ref.read(analyticsPeriodProvider.notifier).state = p;
          },
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip('Esta semana', AnalyticsPeriod.week),
          chip('Este mes', AnalyticsPeriod.month),
          chip('Este año', AnalyticsPeriod.year),
          chip('Personalizado', AnalyticsPeriod.custom),
        ],
      ),
    );
  }

  Widget _metricCards(
      ThemeData theme, AnalyticsSummary summary, AppSettings settings) {
    Widget card(String label, double value, Color color) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(Dimens.cardRadius),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  CurrencyFormatter.format(value, settings),
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        card('Ingresos', summary.income, AppColors.income),
        const SizedBox(width: 8),
        card('Gastos', summary.expense, AppColors.expense),
        const SizedBox(width: 8),
        card('Balance', summary.net,
            summary.net >= 0 ? AppColors.income : AppColors.expense),
      ],
    );
  }

  Widget _donut(
      ThemeData theme, AnalyticsSummary summary, AppSettings settings) {
    if (summary.slices.isEmpty) {
      return const SizedBox(
        height: 200,
        child: EmptyState(
            icon: Icons.pie_chart_outline,
            message: 'Sin gastos en este período'),
      );
    }

    final centerText = _touchedSlice >= 0 && _touchedSlice < summary.slices.length
        ? summary.slices[_touchedSlice]
        : null;

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        _touchedSlice =
                            response?.touchedSection?.touchedSectionIndex ?? -1;
                      });
                    },
                  ),
                  sections: [
                    for (var i = 0; i < summary.slices.length; i++)
                      PieChartSectionData(
                        value: summary.slices[i].amount,
                        color: AppColors.fromHex(summary.slices[i].colorHex),
                        radius: _touchedSlice == i ? 32 : 26,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
              if (centerText != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(centerText.name,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center),
                    Text(
                      CurrencyFormatter.format(centerText.amount, settings),
                      style: theme.textTheme.titleMedium,
                    ),
                    Text('${(centerText.percent * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall),
                  ],
                )
              else
                Text('Total\n${CurrencyFormatter.format(summary.expense, settings)}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            for (final s in summary.slices)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.fromHex(s.colorHex),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('${s.name} ${(s.percent * 100).toStringAsFixed(0)}%',
                      style: theme.textTheme.bodySmall),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _barChart(
      ThemeData theme, List<PeriodBar> series, AppSettings settings) {
    final maxVal = series.fold<double>(
        0,
        (m, b) => [m, b.income, b.expense]
            .reduce((a, c) => a > c ? a : c));
    if (maxVal <= 0) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text('Sin datos para el gráfico',
              style: theme.textTheme.bodySmall),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxVal * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= series.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(series[i].label,
                        style: theme.textTheme.bodySmall),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  CurrencyFormatter.format(rod.toY, settings),
                  const TextStyle(color: Colors.white, fontSize: 11),
                );
              },
            ),
          ),
          barGroups: [
            for (var i = 0; i < series.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: series[i].income,
                    color: AppColors.income,
                    width: 7,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  BarChartRodData(
                    toY: series[i].expense,
                    color: AppColors.expense,
                    width: 7,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _rankingRow(
      ThemeData theme, CategorySlice s, AppSettings settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.fromHex(s.colorHex),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(s.name, style: theme.textTheme.bodyLarge)),
          Text('${(s.percent * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall),
          const SizedBox(width: 10),
          Text(CurrencyFormatter.format(s.amount, settings),
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
