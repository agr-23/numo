import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/dimens.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/numo_palette.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../providers/accounts_provider.dart';
import '../../../../providers/overview_provider.dart';
import '../../../../providers/savings_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../providers/transactions_provider.dart';

/// Oculta los montos del carrusel (para mostrar el teléfono sin exponerlos).
final hideAmountsProvider = StateProvider<bool>((ref) => false);

/// Carrusel deslizable del Inicio: balance neto (tarjeta protagonista en
/// tinta), dinero total, deudas y metas.
class OverviewCarousel extends ConsumerStatefulWidget {
  const OverviewCarousel({super.key});

  @override
  ConsumerState<OverviewCarousel> createState() => _OverviewCarouselState();
}

class _OverviewCarouselState extends ConsumerState<OverviewCarousel> {
  static const _pageCount = 4;
  static const _height = 156.0;

  final _controller = PageController(viewportFraction: 0.88);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final hidden = ref.watch(hideAmountsProvider);
    String fmt(double v) =>
        hidden ? '••••••' : CurrencyFormatter.format(v, settings);

    final net = ref.watch(netBalanceProvider);
    final month = ref.watch(currentMonthSummaryProvider);
    final money = ref.watch(moneyOverviewProvider);
    final debt = ref.watch(debtOverviewProvider);
    final savings = ref.watch(savingsOverviewProvider);

    final debtSub = debt.cardCount == 0
        ? l10n.ovNoCards
        : debt.nextPayment != null
        ? l10n.ovDebtNext(
            debt.nextPaymentCard ?? '',
            DateFormatter.shortDay(debt.nextPayment!),
          )
        : debt.available != null
        ? '${l10n.accCreditAvailable} ${fmt(debt.available!)}'
        : '';

    final pages = <Widget>[
      _HeroCard(
        label: l10n.ovNetBalance,
        caption: l10n.ovNetFormula,
        amount: fmt(net),
        income: l10n.ovIncomeArrow(fmt(month.income)),
        expense: l10n.ovExpenseArrow(fmt(month.expense)),
      ),
      _OutlineCard(
        label: l10n.ovTotalMoney,
        amount: fmt(money.total),
        sub: money.setAside > 0
            ? l10n.ovMoneySetAside(fmt(money.setAside))
            : l10n.ovNetFormula,
      ),
      _OutlineCard(
        label: l10n.ovDebts,
        amount: fmt(debt.debt),
        amountColor: debt.debt > 0 ? p.expense : null,
        sub: debtSub,
        onTap: () => context.go('/home/accounts'),
      ),
      _OutlineCard(
        label: l10n.ovSavings,
        amount: fmt(savings.saved),
        sub: savings.groupCount == 0
            ? l10n.svCreateFirst
            : l10n.ovGoalsSub(
                (savings.progress * 100).toStringAsFixed(0),
                fmt(savings.target),
              ),
        onTap: () => context.push('/savings'),
      ),
    ];

    final scale = (MediaQuery.textScalerOf(context).scale(14) / 14).clamp(
      1.0,
      1.6,
    );

    return Column(
      children: [
        SizedBox(
          height: _height * scale,
          child: Padding(
            padding: const EdgeInsets.only(left: Dimens.screenPaddingH),
            child: PageView(
              controller: _controller,
              padEnds: false,
              clipBehavior: Clip.none,
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                for (final page in pages)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: page,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _pageCount; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _page == i ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _page == i ? p.ink : p.borderStrong,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Tarjeta protagonista, en tinta (negra en claro, clara en oscuro).
class _HeroCard extends StatelessWidget {
  final String label;
  final String caption;
  final String amount;
  final String income;
  final String expense;

  const _HeroCard({
    required this.label,
    required this.caption,
    required this.amount,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final muted = p.onInk.withValues(alpha: 0.7);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: p.ink,
        borderRadius: BorderRadius.circular(Dimens.heroRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.captionStrong.copyWith(
                    fontSize: 13,
                    color: muted,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: AppTextStyles.amountHero.copyWith(color: p.onInk),
            ),
          ),
          const Spacer(),
          Wrap(
            spacing: 14,
            runSpacing: 2,
            children: [
              Text(
                income,
                style: AppTextStyles.captionStrong.copyWith(
                  fontSize: 13,
                  color: p.onInkIncome,
                ),
              ),
              Text(
                expense,
                style: AppTextStyles.captionStrong.copyWith(
                  fontSize: 13,
                  color: p.onInkExpense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Las demás vistas: tarjeta blanca con borde.
class _OutlineCard extends StatelessWidget {
  final String label;
  final String amount;
  final String sub;
  final Color? amountColor;
  final VoidCallback? onTap;

  const _OutlineCard({
    required this.label,
    required this.amount,
    required this.sub,
    this.amountColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.heroRadius),
        side: BorderSide(color: p.borderStrong),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.captionStrong.copyWith(
                  fontSize: 13,
                  color: p.inkMuted,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  amount,
                  style: AppTextStyles.amountHero.copyWith(
                    color: amountColor ?? p.ink,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                sub,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 13,
                  color: p.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
