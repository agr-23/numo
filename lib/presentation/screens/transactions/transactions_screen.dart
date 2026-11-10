import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/transaction_filter_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/transaction_item.dart';
import 'widgets/filter_sheet.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  static const _pageSize = 30;
  final _scrollController = ScrollController();
  final _searchCtrl = TextEditingController();
  bool _searching = false;
  int _visible = _pageSize;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        setState(() => _visible += _pageSize);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = ref.watch(filteredTransactionsProvider);
    final hasFilters = ref.watch(transactionFilterProvider).hasActiveFilters;
    final visible = filtered.take(_visible).toList();
    final groups = groupByDay(visible);
    final l10n = context.l10n;
    final filtering = hasFilters || _searchCtrl.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.txSearch,
                  border: InputBorder.none,
                ),
                onChanged: (q) =>
                    ref.read(transactionFilterProvider.notifier).setQuery(q),
              )
            : Text(l10n.txTitle),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searching = !_searching;
                if (!_searching) {
                  _searchCtrl.clear();
                  ref.read(transactionFilterProvider.notifier).setQuery('');
                }
              });
            },
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => FilterSheet.show(context),
              ),
              if (hasFilters)
                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: context.palette.ink,
                  ),
                ),
            ],
          ),
        ],
      ),
      body: filtered.isEmpty
          ? EmptyState(
              icon: Icons.receipt_long,
              message: filtering ? l10n.txNoMatches : l10n.dashNoTransactions,
              actionLabel: filtering ? null : l10n.txAddFirst,
              onAction: filtering
                  ? null
                  : () => context.push('/add-transaction'),
            )
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(
                Dimens.screenPaddingH,
                8,
                Dimens.screenPaddingH,
                96,
              ),
              itemCount: groups.length,
              itemBuilder: (_, i) => _dayGroup(groups[i]),
            ),
    );
  }

  Widget _dayGroup(DayGroup group) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);
    final net = group.net;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormatter.groupHeader(group.day, context.l10n),
                style: theme.textTheme.titleMedium,
              ),
              Text(
                CurrencyFormatter.signed(net, settings, isIncome: net >= 0),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: net >= 0
                      ? context.palette.income
                      : context.palette.expense,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        for (final t in group.items) _dismissible(t),
        const Divider(height: 1),
      ],
    );
  }

  Widget _dismissible(Transaction t) {
    return Dismissible(
      key: ValueKey('tx-${t.id}'),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: context.palette.transfer,
          borderRadius: BorderRadius.circular(Dimens.chipRadius),
        ),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: context.palette.expense,
          borderRadius: BorderRadius.circular(Dimens.chipRadius),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          unawaited(context.push('/edit-transaction/${t.id}'));
          return false;
        }
        return true;
      },
      onDismissed: (_) => _deleteWithUndo(t),
      child: TransactionItem(
        transaction: t,
        onTap: () => context.push('/edit-transaction/${t.id}'),
      ),
    );
  }

  Future<void> _deleteWithUndo(Transaction t) async {
    final repo = ref.read(transactionRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    // Snapshot para poder restaurar.
    final snapshot = Transaction()
      ..title = t.title
      ..amount = t.amount
      ..type = t.type
      ..date = t.date
      ..note = t.note
      ..isRecurring = t.isRecurring
      ..recurrenceFrequency = t.recurrenceFrequency
      ..recurrenceEndDate = t.recurrenceEndDate
      ..nextRecurrenceDate = t.nextRecurrenceDate
      ..parentRecurringId = t.parentRecurringId
      ..pocketId = t.pocketId;
    final accountId = t.account.value?.id;
    final categoryId = t.category.value?.id;
    final toAccountId = t.toAccount.value?.id;

    await repo.delete(t.id);

    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.txDeleted),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () {
            if (accountId != null) {
              repo.add(
                snapshot,
                accountId: accountId,
                categoryId: categoryId,
                toAccountId: toAccountId,
              );
            }
          },
        ),
      ),
    );
  }
}
