import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/account.dart';
import '../../../providers/accounts_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/transaction_item.dart';
import 'widgets/budgets_grid.dart';
import 'widgets/overview_carousel.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final l10n = context.l10n;
    final recent = ref.watch(recentTransactionsProvider(5));
    final hidden = ref.watch(hideAmountsProvider);

    const pad = EdgeInsets.symmetric(horizontal: Dimens.screenPaddingH);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Dimens.screenPaddingH, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormatter.greeting(DateTime.now(), l10n),
                      style: AppTextStyles.labelFrom(15)
                          .copyWith(fontWeight: FontWeight.w500, color: p.inkMuted),
                    ),
                  ),
                  IconButton(
                    tooltip: hidden ? l10n.dashShowAmounts : l10n.dashHideAmounts,
                    icon: Icon(hidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () =>
                        ref.read(hideAmountsProvider.notifier).state = !hidden,
                  ),
                  IconButton(
                    tooltip: l10n.setTitle,
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const OverviewCarousel(),
            const SizedBox(height: 24),
            const Padding(padding: pad, child: _QuickActions()),
            const SizedBox(height: Dimens.sectionGap),

            Padding(
              padding: pad,
              child: _SectionHeader(
                title: l10n.dashBudgets,
                action: l10n.seeAll,
                onAction: () => context.push('/budgets'),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(padding: pad, child: BudgetsGrid()),
            Padding(
              padding: pad,
              child: _LinkRow(
                icon: Icons.track_changes_rounded,
                label: l10n.ovSavings,
                onTap: () => context.push('/savings'),
              ),
            ),
            const SizedBox(height: Dimens.sectionGap),

            Padding(
              padding: pad,
              child: _SectionHeader(
                title: l10n.txTitle,
                action: l10n.seeAll,
                onAction: () => context.go('/home/transactions'),
              ),
            ),
            const SizedBox(height: 4),
            if (recent.isEmpty)
              EmptyState(icon: Icons.receipt_long, message: l10n.dashNoTransactions)
            else
              for (final t in recent)
                Padding(
                  padding: pad,
                  child: TransactionItem(
                    transaction: t,
                    onTap: () => context.push('/edit-transaction/${t.id}'),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

/// Gasto, Ingreso, Transferir y Pagar tarjeta.
class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
    // "Pagar" abre el pago de la tarjeta con más deuda.
    final cards = accounts.where((a) => a.isCredit).toList()
      ..sort((a, b) => b.balance.compareTo(a.balance));
    final Account? card = cards.isEmpty ? null : cards.first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionButton(
          icon: Icons.south_west_rounded,
          label: l10n.expense,
          onTap: () => context.push('/add-transaction'),
        ),
        _ActionButton(
          icon: Icons.north_east_rounded,
          label: l10n.income,
          onTap: () => context.push('/add-transaction?type=income'),
        ),
        _ActionButton(
          icon: Icons.swap_horiz_rounded,
          label: l10n.addTxDoTransfer,
          onTap: () => context.push('/add-transfer'),
        ),
        _ActionButton(
          icon: Icons.credit_card_rounded,
          label: l10n.actPay,
          onTap: () => card == null
              ? context.go('/home/accounts')
              : context.push('/add-transfer?to=${card.id}'),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.chipRadius),
        child: SizedBox(
          width: 76,
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: p.borderStrong),
                ),
                child: Icon(icon, size: 20, color: p.ink),
              ),
              const SizedBox(height: 8),
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionStrong.copyWith(color: p.ink)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onAction;
  const _SectionHeader(
      {required this.title, required this.action, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        Expanded(
            child: Text(title, style: AppTextStyles.section.copyWith(color: p.ink))),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: const Size(44, 36),
            textStyle: AppTextStyles.captionStrong.copyWith(fontSize: 13),
          ),
          child: Text(action),
        ),
      ],
    );
  }
}

/// Fila enlace con ícono violeta (p. ej. "Metas de ahorro").
class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _LinkRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: p.track)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: p.linkSoft, shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: p.link),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: AppTextStyles.rowTitle.copyWith(color: p.ink))),
            Icon(Icons.chevron_right_rounded, color: p.inkHint),
          ],
        ),
      ),
    );
  }
}
