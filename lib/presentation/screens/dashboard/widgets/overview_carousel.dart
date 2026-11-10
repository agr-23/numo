import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/app_settings.dart';
import '../../../../providers/accounts_provider.dart';
import '../../../../providers/overview_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../providers/transactions_provider.dart';

/// Carrusel deslizable del dashboard: vistazo rápido a balance neto,
/// dinero total, deudas y metas.
class OverviewCarousel extends ConsumerStatefulWidget {
  const OverviewCarousel({super.key});

  @override
  ConsumerState<OverviewCarousel> createState() => _OverviewCarouselState();
}

class _OverviewCarouselState extends ConsumerState<OverviewCarousel> {
  static const _pageCount = 4;
  static const _height = 176.0;

  final _controller = PageController(viewportFraction: 0.93);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    String fmt(double v) => CurrencyFormatter.format(v, settings);
    final l10n = context.l10n;

    final pages = <Widget>[
      _netPage(settings, fmt, l10n),
      _moneyPage(settings, fmt, l10n),
      _debtPage(settings, fmt, l10n),
      _goalsPage(settings, fmt, l10n),
    ];
    assert(pages.length == _pageCount);

    return Column(
      children: [
        SizedBox(
          // Crece con el tamaño de letra del sistema para no desbordar.
          height: _height *
              (MediaQuery.textScalerOf(context).scale(14) / 14).clamp(1.0, 1.6),
          child: PageView(
            controller: _controller,
            padEnds: false,
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              for (final p in pages)
                Padding(padding: const EdgeInsets.only(right: 10), child: p),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _pageCount; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _page == i ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _page == i
                      ? AppColors.accent
                      : Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // 1. Balance neto: efectivo + banco − deuda, con flujo del mes.
  Widget _netPage(
      AppSettings settings, String Function(double) fmt, AppLocalizations l10n) {
    final net = ref.watch(netBalanceProvider);
    final month = ref.watch(currentMonthSummaryProvider);
    return _OverviewCard(
      label: l10n.ovNetBalance,
      icon: Icons.account_balance_wallet_outlined,
      amount: net,
      settings: settings,
      stats: [
        _Stat(Icons.arrow_upward, AppColors.income, fmt(month.income),
            l10n.ovMonthIncome),
        _Stat(Icons.arrow_downward, AppColors.expense, fmt(month.expense),
            l10n.ovMonthExpense),
      ],
    );
  }

  // 2. Dinero total: cuentas + metas.
  Widget _moneyPage(
      AppSettings settings, String Function(double) fmt, AppLocalizations l10n) {
    final money = ref.watch(moneyOverviewProvider);
    return _OverviewCard(
      label: l10n.ovTotalMoney,
      icon: Icons.paid_outlined,
      amount: money.total,
      settings: settings,
      stats: [
        _Stat(Icons.account_balance_outlined, Colors.white,
            fmt(money.inAccounts), l10n.ovInAccounts),
        _Stat(Icons.savings_outlined, AppColors.accent, fmt(money.inGoals),
            l10n.ovInGoals),
      ],
    );
  }

  // 3. Deudas de tarjetas de crédito.
  Widget _debtPage(
      AppSettings settings, String Function(double) fmt, AppLocalizations l10n) {
    final debt = ref.watch(debtOverviewProvider);
    final hasCards = debt.cardCount > 0;
    return _OverviewCard(
      label: l10n.ovDebts,
      icon: Icons.credit_card,
      amount: debt.debt,
      amountColor: debt.debt > 0 ? AppColors.expense : Colors.white,
      settings: settings,
      onTap: () => context.go('/home/accounts'),
      message: hasCards ? null : l10n.ovNoCards,
      stats: [
        if (debt.available != null)
          _Stat(Icons.check_circle_outline, AppColors.income,
              fmt(debt.available!), l10n.ovAvailableCredit),
        if (debt.nextPayment != null)
          _Stat(
            Icons.event_outlined,
            AppColors.accent,
            DateFormatter.shortDay(debt.nextPayment!),
            l10n.ovPaymentOf(debt.nextPaymentCard ?? ''),
          ),
      ],
    );
  }

  // 4. Metas de ahorro.
  Widget _goalsPage(
      AppSettings settings, String Function(double) fmt, AppLocalizations l10n) {
    final goals = ref.watch(goalsOverviewProvider);
    return _OverviewCard(
      label: l10n.ovSavedInGoals,
      icon: Icons.savings_outlined,
      amount: goals.saved,
      settings: settings,
      onTap: () => context.push('/savings-goals'),
      message: goals.count == 0 ? l10n.ovCreateFirstGoal : null,
      progress: goals.count == 0 ? null : goals.progress,
      stats: [
        _Stat(Icons.flag_outlined, AppColors.accent, fmt(goals.target),
            l10n.ovGoalTarget((goals.progress * 100).toStringAsFixed(0))),
        _Stat(Icons.emoji_events_outlined, AppColors.income,
            l10n.amountOf('${goals.completed}', '${goals.count}'),
            l10n.ovCompleted),
      ],
    );
  }
}

class _Stat {
  final IconData icon;
  final Color color;
  final String value;
  final String caption;
  const _Stat(this.icon, this.color, this.value, this.caption);
}

class _OverviewCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final double amount;
  final Color amountColor;
  final AppSettings settings;
  final List<_Stat> stats;
  final String? message;
  final double? progress;
  final VoidCallback? onTap;

  const _OverviewCard({
    required this.label,
    required this.icon,
    required this.amount,
    required this.settings,
    required this.stats,
    this.amountColor = Colors.white,
    this.message,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Colors.white.withValues(alpha: 0.7);
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(label,
                        style: TextStyle(color: muted, fontSize: 13)),
                  ),
                  Icon(icon, color: muted, size: 18),
                ],
              ),
              const SizedBox(height: 6),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: amount),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (_, value, __) => FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    CurrencyFormatter.format(value, settings),
                    style: TextStyle(
                      color: amountColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.accent),
                  ),
                ),
              ],
              const Spacer(),
              if (message != null)
                Text(message!, style: TextStyle(color: muted, fontSize: 13))
              else
                Row(
                  children: [
                    for (var i = 0; i < stats.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      Flexible(child: _stat(stats[i])),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(_Stat s) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(s.icon, color: s.color, size: 18),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: s.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              Text(s.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
