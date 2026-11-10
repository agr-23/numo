import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/amount_input.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/account.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/category.dart';
import '../../../data/models/transaction.dart';
import '../../../providers/accounts_provider.dart';
import '../../../providers/categories_provider.dart';
import '../../../providers/savings_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../widgets/category_icon.dart';
import '../../widgets/numeric_keypad.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  /// Si se pasa, la pantalla edita esa transacción.
  final int? editId;

  /// Abre directamente en Transferencia.
  final bool startAsTransfer;

  /// Abre directamente en Ingreso.
  final bool startAsIncome;

  /// Cuenta destino preseleccionada (ej. "Pagar tarjeta").
  final int? initialToAccountId;

  const AddTransactionScreen({
    super.key,
    this.editId,
    this.startAsTransfer = false,
    this.startAsIncome = false,
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
  String _title = '';
  String _note = '';
  bool _titleEditedByUser = false;

  /// Bolsillo desde el que se paga el gasto (opcional).
  int? _pocketId;

  bool _isRecurring = false;
  String _frequency = 'monthly';
  DateTime? _recurrenceEnd;

  bool _loaded = false;

  bool get _isTransfer => _type == TransactionType.transfer;
  double get _amount => double.tryParse(_amountStr) ?? 0;

  @override
  void initState() {
    super.initState();
    if (widget.startAsTransfer) _type = TransactionType.transfer;
    if (widget.startAsIncome) _type = TransactionType.income;
  }

  Future<void> _loadForEdit() async {
    final tx =
        await ref.read(transactionRepositoryProvider).getById(widget.editId!);
    if (tx == null || !mounted) return;
    setState(() {
      _type = tx.type;
      _amountStr = _stripTrailingZeros(tx.amount);
      _category = tx.category.value;
      _account = tx.account.value;
      _toAccount = tx.toAccount.value;
      _date = tx.date;
      _title = tx.title;
      _note = tx.note ?? '';
      _titleEditedByUser = true;
      _isRecurring = tx.isRecurring;
      _frequency = tx.recurrenceFrequency ?? 'monthly';
      _recurrenceEnd = tx.recurrenceEndDate;
      _pocketId = tx.pocketId;
    });
  }

  String _stripTrailingZeros(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toString();
  }

  /// Color del monto y de la pestaña activa según el tipo.
  Color _typeColor(NumoPalette p) => switch (_type) {
        TransactionType.expense => p.expense,
        TransactionType.income => p.income,
        TransactionType.transfer => p.ink,
      };

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
      final candidates = accounts.where((a) => a.id != _toAccount?.id).toList();
      _account = targetId != null && candidates.isNotEmpty
          ? candidates.firstWhere((a) => !a.isCredit,
              orElse: () => candidates.first)
          : accounts.first;
    }
    if (_isTransfer && _toAccount == null && accounts.length > 1) {
      _toAccount = accounts.firstWhere((a) => a.id != _account?.id);
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
    final rules = AmountInput.of(settings.currency);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Dimens.screenPaddingH, 4, Dimens.screenPaddingH, 16),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 8),
              _typeSelector(),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _amountBox(settings, rules),
                      const SizedBox(height: 12),
                      if (!_isTransfer) ...[
                        _categoryChips(),
                        const SizedBox(height: 12),
                      ],
                      _fields(accounts, settings),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              NumericKeypad(
                showDecimal: settings.currencyDecimals > 0,
                decimalLabel: rules.decimalSep,
                onDigit: _onDigit,
                onBackspace: _onBackspace,
              ),
              const SizedBox(height: 12),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final p = context.palette;
    final l10n = context.l10n;
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.cancel,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.pop(),
            style: IconButton.styleFrom(padding: EdgeInsets.zero),
          ),
          Expanded(
            child: Text(
              widget.editId != null ? l10n.addTxEdit : l10n.addTxNew,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(color: p.ink),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  /// Gasto / Ingreso / Transferir. Al editar no se puede cambiar a
  /// transferencia ni desde ella (cambiaría las cuentas afectadas).
  Widget _typeSelector() {
    final p = context.palette;
    final l10n = context.l10n;
    final editing = widget.editId != null;
    if (editing && _isTransfer) return const SizedBox.shrink();

    final options = [
      (TransactionType.expense, l10n.expense),
      (TransactionType.income, l10n.income),
      if (!editing) (TransactionType.transfer, l10n.addTxDoTransfer),
    ];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: p.surfaceMuted,
        borderRadius: BorderRadius.circular(Dimens.chipRadius),
      ),
      child: Row(
        children: [
          for (final (type, label) in options)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _type = type;
                    _category = null;
                    if (!_titleEditedByUser) _title = '';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _type == type ? p.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: _type == type
                        ? [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 3,
                                offset: const Offset(0, 1))
                          ]
                        : null,
                  ),
                  child: Text(
                    label,
                    style: AppTextStyles.labelFrom(13).copyWith(
                        color: _type == type ? _typeColor(p) : p.inkMuted),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _amountBox(AppSettings settings, AmountInput rules) {
    final p = context.palette;
    final l10n = context.l10n;
    final formatted = rules.groupRaw(_amountStr);
    final symbol = settings.currencySymbol;
    final text = settings.currencySymbolBefore
        ? '$symbol$formatted'
        : '$formatted $symbol';
    final question = switch (_type) {
      TransactionType.expense => l10n.addTxHowMuchExpense,
      TransactionType.income => l10n.addTxHowMuchIncome,
      TransactionType.transfer => l10n.addTxHowMuchTransfer,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
      ),
      child: Column(
        children: [
          Text(question,
              style: AppTextStyles.captionStrong.copyWith(color: p.inkMuted)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(text,
                style: AppTextStyles.amountInput
                    .copyWith(color: _amountStr.isEmpty ? p.inkHint : _typeColor(p))),
          ),
        ],
      ),
    );
  }

  Widget _categoryChips() {
    final p = context.palette;
    final l10n = context.l10n;
    final kind = _type == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    final categories = ref.watch(categoriesByTypeProvider(kind));

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = categories[i];
          final selected = _category?.id == c.id;
          final name = categoryLabel(c, l10n);
          return Semantics(
            selected: selected,
            button: true,
            child: Material(
              color: selected ? p.ink : p.surface,
              shape: StadiumBorder(
                  side: BorderSide(color: selected ? p.ink : p.borderStrong)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _category = c;
                    if (!_titleEditedByUser) _title = name;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected
                              ? p.onInk.withValues(alpha: 0.14)
                              : p.surfaceSubtle,
                        ),
                        child: Icon(
                          AppIcons.resolve(c.iconName),
                          size: 16,
                          color: selected ? p.onInk : p.ink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(name,
                          style: AppTextStyles.labelFrom(13).copyWith(
                              fontWeight: FontWeight.w500,
                              color: selected ? p.onInk : p.ink)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Lista de campos: cuenta(s), fecha, repetir, título y nota.
  Widget _fields(List<Account> accounts, AppSettings settings) {
    final p = context.palette;
    final l10n = context.l10n;

    final rows = <_FieldRow>[
      if (_isTransfer) ...[
        _FieldRow(
          icon: Icons.account_balance_wallet_outlined,
          label: l10n.addTxFrom,
          value: _account?.name ?? l10n.addTxPickAccount,
          onTap: () => _pickAccount(accounts, from: true),
        ),
        _FieldRow(
          icon: Icons.login_rounded,
          label: l10n.addTxTo,
          value: _toAccount?.name ?? l10n.addTxPickAccount,
          onTap: () => _pickAccount(
              accounts.where((a) => a.id != _account?.id).toList(),
              from: false),
        ),
      ] else
        _FieldRow(
          icon: Icons.account_balance_wallet_outlined,
          label: l10n.account,
          value: _account?.name ?? l10n.addTxPickAccount,
          hint: _account?.available == null
              ? null
              : l10n.addTxAvailableCredit(
                  CurrencyFormatter.format(_account!.available!, settings)),
          onTap: () => _pickAccount(accounts, from: true),
        ),
      _FieldRow(
        icon: Icons.calendar_today_outlined,
        label: l10n.date,
        value: _isToday(_date) ? l10n.today : DateFormatter.longDay(_date),
        onTap: _pickDate,
      ),
      if (_type == TransactionType.expense) _pocketRow(settings),
      if (!_isTransfer) ...[
        _FieldRow(
          icon: Icons.repeat_rounded,
          label: l10n.addTxRepeat,
          value: _repeatLabel(l10n),
          onTap: _pickRepeat,
        ),
        _FieldRow(
          icon: Icons.short_text_rounded,
          label: l10n.title,
          value: _title.isEmpty ? l10n.addTxAdd : _title,
          muted: _title.isEmpty,
          onTap: () => _editText(l10n.title, _title, l10n.addTxTitleHint,
              (v) => setState(() {
                    _title = v;
                    _titleEditedByUser = v.isNotEmpty;
                  })),
        ),
      ],
      _FieldRow(
        icon: Icons.notes_rounded,
        label: l10n.note,
        value: _note.isEmpty ? l10n.addTxAdd : _note,
        muted: _note.isEmpty,
        onTap: () =>
            _editText(l10n.note, _note, '', (v) => setState(() => _note = v)),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            _FieldRowView(row: rows[i], divider: i < rows.length - 1),
        ],
      ),
    );
  }

  _FieldRow _pocketRow(AppSettings settings) {
    final l10n = context.l10n;
    final pockets = ref.watch(pocketsProvider).valueOrNull ?? const [];
    final pocket = pockets.where((x) => x.id == _pocketId).firstOrNull;
    return _FieldRow(
      icon: Icons.savings_outlined,
      label: l10n.svPayFromPocket,
      value: pocket?.name ?? l10n.svNoneOption,
      muted: pocket == null,
      hint: pocket == null
          ? null
          : l10n.svPocketBalance(
              CurrencyFormatter.format(pocket.savedAmount, settings)),
      onTap: _pickPocket,
    );
  }

  Future<void> _pickPocket() async {
    final l10n = context.l10n;
    final settings = ref.read(settingsProvider);
    final groups = ref.read(groupViewsProvider);
    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheet).size.height * 0.7),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            children: [
              ListTile(
                title: Text(l10n.svNoneOption),
                trailing: _pocketId == null
                    ? Icon(Icons.check_rounded, color: sheet.palette.ink)
                    : null,
                onTap: () => Navigator.of(sheet).pop(-1),
              ),
              for (final g in groups)
                for (final pk in g.pockets)
                  ListTile(
                    leading: Icon(AppIcons.resolve(pk.iconName)),
                    title: Text(pk.name),
                    subtitle: Text(
                        '${g.group.name}, ${l10n.svPocketBalance(CurrencyFormatter.format(pk.savedAmount, settings))}'),
                    trailing: pk.id == _pocketId
                        ? Icon(Icons.check_rounded, color: sheet.palette.ink)
                        : null,
                    onTap: () => Navigator.of(sheet).pop(pk.id),
                  ),
            ],
          ),
        ),
      ),
    );
    if (picked == null) return;
    setState(() => _pocketId = picked == -1 ? null : picked);
  }

  bool _isToday(DateTime d) {
    final n = DateTime.now();
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }

  String _frequencyLabel(String f, AppLocalizations l10n) => switch (f) {
        'daily' => l10n.freqDaily,
        'weekly' => l10n.freqWeekly,
        'yearly' => l10n.freqYearly,
        _ => l10n.freqMonthly,
      };

  String _repeatLabel(AppLocalizations l10n) {
    if (!_isRecurring) return l10n.addTxRepeatNever;
    final f = _frequencyLabel(_frequency, l10n);
    if (_recurrenceEnd == null) return f;
    return l10n.addTxRepeatUntil(f, DateFormatter.shortDay(_recurrenceEnd!));
  }

  Widget _saveButton() {
    final l10n = context.l10n;
    final label = switch (_type) {
      TransactionType.expense => l10n.addTxSaveExpense,
      TransactionType.income => l10n.addTxSaveIncome,
      TransactionType.transfer => l10n.addTxDoTransfer,
    };
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _save,
        icon: const Icon(Icons.check_rounded, size: 18),
        label: Text(label),
      ),
    );
  }

  // ---------------- Selectores ----------------

  Future<void> _pickAccount(List<Account> accounts, {required bool from}) async {
    final settings = ref.read(settingsProvider);
    final l10n = context.l10n;
    final current = from ? _account : _toAccount;
    final picked = await showModalBottomSheet<Account>(
      context: context,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          children: [
            for (final a in accounts)
              ListTile(
                leading: CategoryIcon(iconName: a.iconName),
                title: Text(a.name),
                subtitle: Text(a.available != null
                    ? l10n.addTxAvailableCredit(
                        CurrencyFormatter.format(a.available!, settings))
                    : l10n.accBalanceShort(
                        CurrencyFormatter.format(a.balance, settings))),
                trailing: a.id == current?.id
                    ? Icon(Icons.check_rounded, color: sheet.palette.ink)
                    : null,
                onTap: () => Navigator.of(sheet).pop(a),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    setState(() {
      if (from) {
        _account = picked;
        if (_toAccount?.id == picked.id) _toAccount = null;
      } else {
        _toAccount = picked;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickRepeat() async {
    final l10n = context.l10n;
    const freqs = ['daily', 'weekly', 'monthly', 'yearly'];
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheet) => StatefulBuilder(
        builder: (sheet, setSheet) {
          void update(VoidCallback fn) {
            setState(fn);
            setSheet(() {});
          }

          final check = Icon(Icons.check_rounded, color: sheet.palette.ink);
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              children: [
                ListTile(
                  title: Text(l10n.addTxRepeatNever),
                  trailing: _isRecurring ? null : check,
                  onTap: () {
                    update(() => _isRecurring = false);
                    Navigator.of(sheet).pop();
                  },
                ),
                for (final f in freqs)
                  ListTile(
                    title: Text(_frequencyLabel(f, l10n)),
                    trailing: _isRecurring && _frequency == f ? check : null,
                    onTap: () => update(() {
                      _isRecurring = true;
                      _frequency = f;
                    }),
                  ),
                if (_isRecurring)
                  ListTile(
                    leading: const Icon(Icons.event_busy_outlined),
                    title: Text(l10n.addTxEndsOn),
                    subtitle: Text(_recurrenceEnd == null
                        ? l10n.addTxNoEnd
                        : DateFormatter.longDay(_recurrenceEnd!)),
                    trailing: _recurrenceEnd == null
                        ? null
                        : IconButton(
                            tooltip: l10n.clear,
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () => update(() => _recurrenceEnd = null),
                          ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: sheet,
                        initialDate: _recurrenceEnd ?? _date,
                        firstDate: _date,
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) update(() => _recurrenceEnd = picked);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _editText(String label, String initial, String hint,
      ValueChanged<String> onSaved) async {
    final ctrl = TextEditingController(text: initial);
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => Padding(
        padding: EdgeInsets.fromLTRB(Dimens.screenPaddingH, 0,
            Dimens.screenPaddingH, MediaQuery.of(sheet).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  labelText: label, hintText: hint.isEmpty ? null : hint),
              onSubmitted: (v) => Navigator.of(sheet).pop(v.trim()),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(sheet).pop(ctrl.text.trim()),
                child: Text(sheet.l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    if (result != null) onSaved(result);
  }

  // ---------------- Teclado ----------------

  void _onDigit(String d) {
    setState(() {
      if (d == '.') {
        if (!_amountStr.contains('.')) {
          _amountStr = _amountStr.isEmpty ? '0.' : '$_amountStr.';
        }
        return;
      }
      // Hasta 2 decimales y 13 dígitos enteros.
      if (_amountStr.contains('.')) {
        if (_amountStr.split('.')[1].length >= 2) return;
      } else if (_amountStr.length >= 13) {
        return;
      }
      _amountStr = _amountStr == '0' ? d : _amountStr + d;
    });
  }

  void _onBackspace() {
    if (_amountStr.isEmpty) return;
    setState(() => _amountStr = _amountStr.substring(0, _amountStr.length - 1));
  }

  // ---------------- Guardar ----------------

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(transactionRepositoryProvider);
    final l10n = context.l10n;

    if (_amount <= 0) return _showError(messenger, l10n.amountMustBePositive);
    if (_account == null) return _showError(messenger, l10n.selectAccount);

    if (_isTransfer) {
      if (_toAccount == null || _toAccount!.id == _account!.id) {
        return _showError(messenger, l10n.addTxDifferentDestination);
      }
    } else {
      if (_category == null) return _showError(messenger, l10n.selectCategory);
      if (!await _confirmOverLimit()) return;
      if (!mounted) return;
    }

    final recurring = !_isTransfer && _isRecurring;
    final note = _note.trim();
    final title = _isTransfer
        ? (note.isEmpty ? l10n.transfer : note)
        : (_title.trim().isEmpty
            ? categoryLabel(_category, l10n)
            : _title.trim());

    final tx = Transaction()
      ..title = title
      ..amount = _amount
      ..type = _type
      ..date = _date
      ..note = note.isEmpty ? null : note
      ..isRecurring = recurring
      ..recurrenceFrequency = recurring ? _frequency : null
      ..recurrenceEndDate = recurring ? _recurrenceEnd : null
      ..nextRecurrenceDate = recurring ? _nextDate(_date, _frequency) : null
      ..pocketId = _type == TransactionType.expense ? _pocketId : null;

    final categoryId = _isTransfer ? null : _category?.id;
    final toAccountId = _isTransfer ? _toAccount?.id : null;
    if (widget.editId != null) {
      tx.id = widget.editId!;
      await repo.update(tx,
          accountId: _account!.id,
          categoryId: categoryId,
          toAccountId: toAccountId);
    } else {
      await repo.add(tx,
          accountId: _account!.id,
          categoryId: categoryId,
          toAccountId: toAccountId);
    }

    HapticFeedback.mediumImpact();
    if (!mounted) return;

    final done = switch (_type) {
      TransactionType.expense => l10n.addTxSavedExpense,
      TransactionType.income => l10n.addTxSavedIncome,
      TransactionType.transfer => l10n.addTxSavedTransfer,
    };
    context.pop();
    final createdId = tx.id;
    messenger.showSnackBar(SnackBar(
      content: Text(done),
      duration: const Duration(seconds: 5),
      action: widget.editId == null
          ? SnackBarAction(
              label: l10n.undo, onPressed: () => repo.delete(createdId))
          : null,
    ));
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

class _FieldRow {
  final IconData icon;
  final String label;
  final String value;
  final String? hint;
  final bool muted;
  final VoidCallback onTap;
  const _FieldRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.hint,
    this.muted = false,
  });
}

class _FieldRowView extends StatelessWidget {
  final _FieldRow row;
  final bool divider;
  const _FieldRowView({required this.row, required this.divider});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return InkWell(
      onTap: row.onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: divider ? Border(bottom: BorderSide(color: p.track)) : null,
        ),
        child: Row(
          children: [
            Icon(row.icon, size: 18, color: p.inkMuted),
            const SizedBox(width: 12),
            Text(row.label,
                style: AppTextStyles.bodyMedium.copyWith(color: p.inkMuted)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(row.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.rowTitle
                          .copyWith(color: row.muted ? p.inkHint : p.ink)),
                  if (row.hint != null)
                    Text(row.hint!,
                        style: AppTextStyles.caption.copyWith(color: p.inkMuted)),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 18, color: p.inkHint),
          ],
        ),
      ),
    );
  }
}
