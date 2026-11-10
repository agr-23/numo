import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/accounts_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/account_card.dart';
import '../../widgets/empty_state.dart';
import 'widgets/add_account_sheet.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
    final net = ref.watch(netBalanceProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis cuentas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar cuenta',
            onPressed: () => AddAccountSheet.show(context),
          ),
        ],
      ),
      body: accounts.isEmpty
          ? EmptyState(
              icon: Icons.account_balance_wallet,
              message: 'Aún no tienes cuentas',
              actionLabel: 'Crear cuenta',
              onAction: () => AddAccountSheet.show(context),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                  Dimens.screenPaddingH, 12, Dimens.screenPaddingH, 96),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Balance neto total',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(
                        CurrencyFormatter.format(net, settings),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimens.sectionGap),
                for (final a in accounts)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.itemGap),
                    child: Dismissible(
                      key: ValueKey('acc-${a.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius:
                              BorderRadius.circular(Dimens.cardRadius),
                        ),
                        child: const Icon(Icons.archive, color: Colors.white),
                      ),
                      confirmDismiss: (_) => _confirmArchive(context, a.name),
                      onDismissed: (_) async {
                        await ref
                            .read(accountRepositoryProvider)
                            .archive(a.id);
                        HapticFeedback.mediumImpact();
                      },
                      child: AccountCard(
                        account: a,
                        onTap: () => context.push('/account-detail/${a.id}'),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<bool> _confirmArchive(BuildContext context, String name) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Archivar cuenta'),
        content: Text(
            'La cuenta "$name" se archivará. Su historial se conserva, pero ya no aparecerá en las listas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Archivar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
