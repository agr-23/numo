import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/numo_palette.dart';

/// Contenedor con la barra inferior: cuatro pestañas y, al centro, el botón
/// para registrar un movimiento.
class HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeShell({super.key, required this.navigationShell});

  void _goBranch(int index) {
    HapticFeedback.selectionClick();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final current = navigationShell.currentIndex;

    Widget tab(int index, IconData icon, IconData activeIcon, String label) =>
        _NavItem(
          icon: current == index ? activeIcon : icon,
          label: label,
          selected: current == index,
          onTap: () => _goBranch(index),
        );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: p.background,
          border: Border(top: BorderSide(color: p.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: Dimens.bottomNavHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tab(0, Icons.home_outlined, Icons.home_rounded, l10n.navHome),
                tab(
                  1,
                  Icons.receipt_long_outlined,
                  Icons.receipt_long,
                  l10n.navTransactions,
                ),
                Semantics(
                  button: true,
                  label: l10n.addTxNew,
                  child: Material(
                    color: p.ink,
                    borderRadius: BorderRadius.circular(22),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push('/add-transaction');
                      },
                      child: SizedBox(
                        width: 56,
                        height: 44,
                        child: Icon(
                          Icons.add_rounded,
                          color: p.onInk,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
                tab(
                  2,
                  Icons.pie_chart_outline_rounded,
                  Icons.pie_chart_rounded,
                  l10n.navAnalytics,
                ),
                tab(
                  3,
                  Icons.account_balance_wallet_outlined,
                  Icons.account_balance_wallet_rounded,
                  l10n.navAccounts,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = selected ? p.ink : p.inkHint;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.chipRadius),
        child: SizedBox(
          width: 70,
          height: 52,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
