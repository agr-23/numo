import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/amount_input.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/account.dart';
import '../../../data/models/category.dart';
import '../../../data/models/transaction.dart';
import '../../../providers/accounts_provider.dart';
import '../../../providers/categories_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../widgets/category_icon.dart';
import '../../widgets/numeric_keypad.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  /// Si se pasa, la pantalla edita esa transacción.
  final int? editId;

  /// Modo inicial: si true, abre directamente en Transferencia.
  final bool startAsTransfer;

  /// Cuenta destino preseleccionada (ej. "Pagar tarjeta").
  final int? initialToAccountId;

  const AddTransactionScreen({
    super.key,
    this.editId,
    this.startAsTransfer = false,
    this.initialToAccountId,
  });

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  TransactionType _type = TransactionType.expense;
  String _amountStr = '';
  Category? _category;
  Account? _account;
  Account? _toAccount;
  DateTime _date = DateTime.now();
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _titleEditedByUser = false;

  bool _isRecurring = false;
  String _frequency = 'monthly';
  DateTime? _recurrenceEnd;

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.startAsTransfer) _type = TransactionType.transfer;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadForEdit() async {
    final tx = await ref
        .read(transactionRepositoryProvider)
        .getById(widget.editId!);
    if (tx == null || !mounted) return;
    setState(() {
      _type = tx.type;
      _amountStr = _stripTrailingZeros(tx.amount);
      _category = tx.category.value;
      _account = tx.account.value;
      _toAccount = tx.toAccount.value;
      _date = tx.date;
      _titleCtrl.text = tx.title;
      _noteCtrl.text = tx.note ?? '';
      _titleEditedByUser = true;
      _isRecurring = tx.isRecurring;
      _frequency = tx.recurrenceFrequency ?? 'monthly';
      _recurrenceEnd = tx.recurrenceEndDate;
    });
  }

  String _stripTrailingZeros(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toString();
  }

  double get _amount => double.tryParse(_amountStr) ?? 0;

  Color get _accentColor {
    switch (_type) {
      case TransactionType.expense:
        return AppColors.expense;
      case TransactionType.income:
        return AppColors.income;
      case TransactionType.transfer:
        return AppColors.transfer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    if (widget.editId != null && !_loaded) {
      _loaded = true;
      _loadForEdit();
    }

    final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
    _pickDefaultAccounts(accounts);
    final amountRules = AmountInput.of(settings.currency);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _tabs(),
            const SizedBox(height: 8),
            _amountDisplay(settings.currencySymbol,
                settings.currencySymbolBefore, amountRules),
            const SizedBox(height: 4),
            NumericKeypad(
              showDecimal: settings.currencyDecimals > 0,
              decimalLabel: amountRules.decimalSep,
              accentColor: _accentColor,
              onDigit: _onDigit,
              onBackspace: _onBackspace,
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    Dimens.screenPaddingH, 16, Dimens.screenPaddingH, 16),
                child: _type == TransactionType.transfer
                    ? _transferFields(accounts)
                    : _normalFields(accounts),
              ),
            ),
            _saveBar(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              widget.editId != null ? context.l10n.addTxEdit : context.l10n.addTxNew,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    if (widget.editId != null && _type == TransactionType.transfer) {
      return const SizedBox.shrink();
    }
    Widget tab(String label, TransactionType type) {
      final selected = _type == type;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _type = type;
              if (type != TransactionType.expense &&
                  type != TransactionType.income) {
                _category = null;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? _accentColor : Colors.transparent,
                  width: 2.5,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: selected
                        ? _accentColor
                        : Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ),
        ),
      );
    }

    // En edición no permitimos cambiar a transferencia ni desde ella.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.screenPaddingH),
      child: Row(
        children: [
          tab(context.l10n.expense, TransactionType.expense),
          tab(context.l10n.income, TransactionType.income),
          if (widget.editId == null)
            tab(context.l10n.transfer, TransactionType.transfer),
        ],
      ),
    );
  }

  /// Cuentas por defecto. Origen = primera activa; si se abrió con un
  /// destino (pagar tarjeta), el origen es la primera cuenta que no sea
  /// tarjeta ni el destino.
  void _pickDefaultAccounts(List<Account> accounts) {
    if (accounts.isEmpty) return;
    final targetId = widget.initialToAccountId;
    if (targetId != null && _toAccount == null) {
      for (final a in accounts) {
        if (a.id == targetId) _toAccount = a;
      }
    }
    if (_account == null) {
      final candidates =
          accounts.where((a) => a.id != _toAccount?.id).toList();
      if (targetId != null) {
        _account = candidates.firstWhere((a) => !a.isCredit,
            orElse: () => candidates.isNotEmpty ? candidates.first : accounts.first);
      } else {
        _account = accounts.first;
      }
    }
  }

  Widget _amountDisplay(String symbol, bool before, AmountInput rules) {
    final formatted = rules.groupRaw(_amountStr);
    final text = before ? '$symbol $formatted' : '$formatted $symbol';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: FittedBox(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: _accentColor,
          ),
        ),
      ),
    );
  }

  void _onDigit(String d) {
    setState(() {
      if (d == '.') {
        if (!_amountStr.contains('.')) {
          _amountStr = _amountStr.isEmpty ? '0.' : '$_amountStr.';
        }
        return;
      }
      // Limita a 2 decimales tras el punto.
      if (_amountStr.contains('.')) {
        final dec = _amountStr.split('.')[1];
        if (dec.length >= 2) return;
      }
      if (!_amountStr.contains('.') && _amountStr.length >= 13) return;
      if (_amountStr == '0') {
        _amountStr = d;
      } else {
        _amountStr += d;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amountStr.isNotEmpty) {
        _amountStr = _amountStr.substring(0, _amountStr.length - 1);
      }
    });
  }

  // -------- Campos para gasto / ingreso --------
  Widget _normalFields(List<Account> accounts) {
    final type = _type == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    final categories = ref.watch(categoriesByTypeProvider(type));
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.category, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final c = categories[i];
              final selected = _category?.id == c.id;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _category = c;
                    if (!_titleEditedByUser) {
                      _titleCtrl.text = categoryLabel(c, l10n);
                    }
                  });
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? _accentColor : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: CategoryIcon(iconName: c.iconName, colorHex: c.colorHex),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 64,
                      child: Text(
                        categoryLabel(c, l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _titleCtrl,
          onChanged: (_) => _titleEditedByUser = true,
          decoration: InputDecoration(
              labelText: l10n.title, hintText: l10n.addTxTitleHint),
        ),
        const SizedBox(height: 12),
        _accountDropdown(accounts, _account, (a) => setState(() => _account = a),
            label: l10n.account),
        const SizedBox(height: 12),
        _dateField(),
        const SizedBox(height: 12),
        TextField(
          controller: _noteCtrl,
          maxLines: 2,
          decoration: InputDecoration(labelText: l10n.noteOptional),
        ),
        const SizedBox(height: 16),
        _recurringSection(),
      ],
    );
  }

  // -------- Campos para transferencia --------
  Widget _transferFields(List<Account> accounts) {
    _toAccount ??= accounts.length > 1
        ? accounts.firstWhere((a) => a.id != _account?.id,
            orElse: () => accounts.last)
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _accountDropdown(accounts, _account, (a) => setState(() => _account = a),
            label: context.l10n.addTxFromAccount),
        const SizedBox(height: 12),
        _accountDropdown(
          accounts.where((a) => a.id != _account?.id).toList(),
          _toAccount,
          (a) => setState(() => _toAccount = a),
          label: context.l10n.addTxToAccount,
        ),
        const SizedBox(height: 12),
        _dateField(),
        const SizedBox(height: 12),
        TextField(
          controller: _noteCtrl,
          maxLines: 2,
          decoration: InputDecoration(labelText: context.l10n.noteOptional),
        ),
      ],
    );
  }

  Widget _accountDropdown(
    List<Account> accounts,
    Account? value,
    ValueChanged<Account?> onChanged, {
    required String label,
  }) {
    final items = accounts;
    final safeValue =
        items.any((a) => a.id == value?.id) ? value : null;
    final available = safeValue?.available;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        helperText: available == null
            ? null
            : context.l10n.addTxAvailableCredit(
                CurrencyFormatter.format(available, ref.read(settingsProvider))),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Account>(
          isExpanded: true,
          value: safeValue,
          hint: Text(context.l10n.addTxPickAccount),
          items: [
            for (final a in items)
              DropdownMenuItem(value: a, child: Text(a.name)),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dateField() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: DateTime(2015),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => _date = picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: context.l10n.date),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormatter.longDay(_date)),
            const Icon(Icons.calendar_today_outlined, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _recurringSection() {
    final l10n = context.l10n;
    final freqs = {
      'daily': l10n.freqDaily,
      'weekly': l10n.freqWeekly,
      'monthly': l10n.freqMonthly,
      'yearly': l10n.freqYearly,
    };
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(Dimens.chipRadius),
      ),
      child: Column(
        children: [
          SwitchListTile(
            value: _isRecurring,
            activeThumbColor: _accentColor,
            title: Text(l10n.addTxRecurring),
            secondary: const Icon(Icons.repeat),
            onChanged: (v) => setState(() => _isRecurring = v),
          ),
          if (_isRecurring) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final entry in freqs.entries)
                    ChoiceChip(
                      label: Text(entry.value),
                      selected: _frequency == entry.key,
                      onSelected: (_) => setState(() => _frequency = entry.key),
                    ),
                ],
              ),
            ),
            ListTile(
              title: Text(l10n.addTxEndsOn),
              subtitle: Text(_recurrenceEnd == null
                  ? l10n.addTxNoEnd
                  : DateFormatter.longDay(_recurrenceEnd!)),
              trailing: _recurrenceEnd == null
                  ? const Icon(Icons.add)
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _recurrenceEnd = null),
                    ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _recurrenceEnd ?? _date,
                  firstDate: _date,
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _recurrenceEnd = picked);
              },
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _saveBar() {
    final label = switch (_type) {
      TransactionType.expense => context.l10n.addTxSaveExpense,
      TransactionType.income => context.l10n.addTxSaveIncome,
      TransactionType.transfer => context.l10n.addTxDoTransfer,
    };
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimens.screenPaddingH, 8,
            Dimens.screenPaddingH, 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.chipRadius),
              ),
            ),
            onPressed: _save,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(transactionRepositoryProvider);
    final l10n = context.l10n;

    if (_amount <= 0) {
      _showError(messenger, l10n.amountMustBePositive);
      return;
    }
    if (_account == null) {
      _showError(messenger, l10n.selectAccount);
      return;
    }

    if (_type == TransactionType.transfer) {
      if (_toAccount == null || _toAccount!.id == _account!.id) {
        _showError(messenger, l10n.addTxDifferentDestination);
        return;
      }
    } else {
      if (_category == null) {
        _showError(messenger, l10n.selectCategory);
        return;
      }
      if (_titleCtrl.text.trim().isEmpty) {
        _showError(messenger, l10n.addTxWriteTitle);
        return;
      }
      if (!await _confirmOverLimit()) return;
      if (!mounted) return;
    }

    final isTransfer = _type == TransactionType.transfer;
    final tx = Transaction()
      ..title = isTransfer
          ? (_noteCtrl.text.trim().isEmpty ? l10n.transfer : _noteCtrl.text.trim())
          : _titleCtrl.text.trim()
      ..amount = _amount
      ..type = _type
      ..date = _date
      ..note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim()
      ..isRecurring = !isTransfer && _isRecurring
      ..recurrenceFrequency = (!isTransfer && _isRecurring) ? _frequency : null
      ..recurrenceEndDate = (!isTransfer && _isRecurring) ? _recurrenceEnd : null
      ..nextRecurrenceDate = (!isTransfer && _isRecurring)
          ? _nextDate(_date, _frequency)
          : null;

    if (widget.editId != null) {
      tx.id = widget.editId!;
      await repo.update(
        tx,
        accountId: _account!.id,
        categoryId: isTransfer ? null : _category?.id,
        toAccountId: isTransfer ? _toAccount?.id : null,
      );
    } else {
      await repo.add(
        tx,
        accountId: _account!.id,
        categoryId: isTransfer ? null : _category?.id,
        toAccountId: isTransfer ? _toAccount?.id : null,
      );
    }

    HapticFeedback.mediumImpact();
    if (!mounted) return;

    final word = switch (_type) {
      TransactionType.expense => l10n.addTxSavedExpense,
      TransactionType.income => l10n.addTxSavedIncome,
      TransactionType.transfer => l10n.addTxSavedTransfer,
    };
    context.pop();

    final createdId = tx.id;
    messenger.showSnackBar(
      SnackBar(
        content: Text(word),
        duration: const Duration(seconds: 5),
        action: widget.editId == null
            ? SnackBarAction(
                label: l10n.undo,
                textColor: AppColors.accent,
                onPressed: () => repo.delete(createdId),
              )
            : null,
      ),
    );
  }

  /// Si el gasto nuevo supera el cupo disponible de la tarjeta, pide
  /// confirmación. Devuelve true si se puede guardar.
  Future<bool> _confirmOverLimit() async {
    final available = _account?.available;
    if (widget.editId != null ||
        _type != TransactionType.expense ||
        available == null ||
        _amount <= available) {
      return true;
    }
    final settings = ref.read(settingsProvider);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.addTxOverLimitTitle),
        content: Text(ctx.l10n.addTxOverLimitBody(
            _account!.name, CurrencyFormatter.format(available, settings))),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(ctx.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(ctx.l10n.addTxSaveAnyway)),
        ],
      ),
    );
    return ok ?? false;
  }

  void _showError(ScaffoldMessengerState messenger, String msg) {
    HapticFeedback.heavyImpact();
    messenger.showSnackBar(SnackBar(content: Text(msg)));
  }

  static DateTime _nextDate(DateTime from, String frequency) {
    switch (frequency) {
      case 'daily':
        return from.add(const Duration(days: 1));
      case 'weekly':
        return from.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(from.year, from.month + 1, from.day);
      case 'yearly':
        return DateTime(from.year + 1, from.month, from.day);
      default:
        return from;
    }
  }
}
