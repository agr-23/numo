import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/numo_palette.dart';
import '../../../../core/utils/amount_input.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/pocket_math.dart';
import '../../../../data/models/account.dart';
import '../../../../data/models/pocket.dart';
import '../../../../providers/accounts_provider.dart';
import '../../../../providers/savings_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../widgets/numeric_keypad.dart';

enum MoneyMode { contribute, withdraw, distribute }

/// Hoja para aportar a un bolsillo, retirar de él o repartir un aporte
/// entre los bolsillos de un grupo. Devuelve true si una meta se completó.
class MoneySheet extends ConsumerStatefulWidget {
  final MoneyMode mode;
  final Pocket? pocket;
  final GroupView? group;

  const MoneySheet._({required this.mode, this.pocket, this.group});

  static Future<bool?> contribute(BuildContext context, Pocket pocket) =>
      _show(context, MoneySheet._(mode: MoneyMode.contribute, pocket: pocket));

  static Future<bool?> withdraw(BuildContext context, Pocket pocket) =>
      _show(context, MoneySheet._(mode: MoneyMode.withdraw, pocket: pocket));

  static Future<bool?> distribute(BuildContext context, GroupView group) =>
      _show(context, MoneySheet._(mode: MoneyMode.distribute, group: group));

  static Future<bool?> _show(BuildContext context, MoneySheet sheet) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FractionallySizedBox(heightFactor: 0.88, child: sheet),
    );
  }

  @override
  ConsumerState<MoneySheet> createState() => _MoneySheetState();
}

class _MoneySheetState extends ConsumerState<MoneySheet> {
  String _amountStr = '';
  int? _accountId;
  bool _initialized = false;

  double get _amount => double.tryParse(_amountStr) ?? 0;

  List<Pocket> get _targets =>
      widget.pocket != null ? [widget.pocket!] : widget.group!.pockets;

  /// Monto sugerido y "completar", según el modo.
  (double? suggested, double? fill) _shortcuts() {
    final now = DateTime.now();
    if (widget.mode == MoneyMode.withdraw) {
      final saved = widget.pocket!.savedAmount;
      return (null, saved > 0 ? saved : null);
    }
    var suggested = 0.0, fill = 0.0;
    var anySuggestion = false;
    for (final p in _targets) {
      final s = PocketMath.suggestedMonthly(p, now);
      if (s != null && s > 0) {
        suggested += s;
        anySuggestion = true;
      }
      fill += PocketMath.remaining(p);
    }
    return (anySuggestion ? suggested : null, fill > 0 ? fill : null);
  }

  void _init(List<Account> accounts) {
    if (_initialized || accounts.isEmpty) return;
    _initialized = true;
    final pocketAccount = widget.pocket?.accountId;
    final eligible = accounts.where((a) => !a.isCredit).toList();
    _accountId = pocketAccount ??
        (eligible.isNotEmpty ? eligible.first.id : null);
    final (suggested, _) = _shortcuts();
    if (suggested != null && widget.mode != MoneyMode.withdraw) {
      _amountStr = suggested.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final rules = AmountInput.of(settings.currency);
    final accounts = (ref.watch(accountsProvider).valueOrNull ?? const [])
        .where((a) => !a.isCredit)
        .toList();
    final setAside = ref.watch(setAsideByAccountProvider);
    _init(accounts);
    String fmt(double v) => CurrencyFormatter.format(v, settings);

    final pocket = widget.pocket;
    final title = switch (widget.mode) {
      MoneyMode.contribute => l10n.svContributeTo(pocket!.name),
      MoneyMode.withdraw => l10n.svWithdrawTitle(pocket!.name),
      MoneyMode.distribute => l10n.svDistributeTitle(widget.group!.group.name),
    };
    final saved = _targets.fold<double>(0, (s, x) => s + x.savedAmount);
    final target = _targets.fold<double>(0, (s, x) => s + x.targetAmount);
    final (suggested, fill) = _shortcuts();
    final account = accounts.where((a) => a.id == _accountId).firstOrNull;
    final accountLocked = pocket != null &&
        pocket.accountId != null &&
        pocket.savedAmount > 0;

    final formatted = rules.groupRaw(_amountStr);
    final amountText = settings.currencySymbolBefore
        ? '${settings.currencySymbol}$formatted'
        : '$formatted ${settings.currencySymbol}';

    final buttonLabel = widget.mode == MoneyMode.withdraw
        ? l10n.svWithdrawButton(fmt(_amount))
        : l10n.svContributeButton(fmt(_amount));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimens.screenPaddingH, 0, Dimens.screenPaddingH, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(color: p.surfaceSubtle, shape: BoxShape.circle),
                child: Icon(
                    AppIcons.resolve(pocket?.iconName ??
                        widget.group!.group.iconName),
                    size: 19,
                    color: p.ink),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.title.copyWith(fontSize: 17, color: p.ink)),
                    Text(
                      widget.mode == MoneyMode.distribute
                          ? l10n.svDistributeNote
                          : l10n.svProgress(fmt(saved), fmt(target)),
                      style: AppTextStyles.caption
                          .copyWith(fontSize: 13, color: p.inkMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(amountText,
                style: AppTextStyles.amountInput.copyWith(
                    fontSize: 52,
                    color: _amountStr.isEmpty ? p.inkHint : p.ink)),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (suggested != null)
                _chip(l10n.svSuggested(fmt(suggested)), suggested),
              if (fill != null)
                _chip(
                    widget.mode == MoneyMode.withdraw
                        ? fmt(fill)
                        : l10n.svFill(fmt(fill)),
                    fill),
            ],
          ),
          if (widget.mode != MoneyMode.withdraw && accounts.isNotEmpty) ...[
            const SizedBox(height: 16),
            Material(
              color: p.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.cardRadius),
                side: BorderSide(color: p.border),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(Dimens.cardRadius),
                onTap: accountLocked
                    ? null
                    : () => _pickAccount(accounts, setAside, fmt),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_outlined,
                          size: 18, color: p.inkMuted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.svFromAccount,
                                style: AppTextStyles.caption
                                    .copyWith(color: p.inkMuted)),
                            Text(
                              account == null
                                  ? l10n.svNoAccount
                                  : '${account.name}, ${l10n.available.toLowerCase()} ${fmt(account.balance - (setAside[account.id] ?? 0))}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.rowTitle
                                  .copyWith(fontWeight: FontWeight.w600, color: p.ink),
                            ),
                          ],
                        ),
                      ),
                      if (!accountLocked)
                        Icon(Icons.chevron_right_rounded, color: p.inkHint),
                    ],
                  ),
                ),
              ),
            ),
            if (account != null) ...[
              const SizedBox(height: 8),
              Text(l10n.svSetAsideNote(account.name),
                  style: AppTextStyles.caption.copyWith(color: p.inkMuted)),
            ],
          ],
          if (widget.mode == MoneyMode.withdraw) ...[
            const SizedBox(height: 12),
            Text(l10n.svWithdrawNote,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: p.inkMuted)),
          ],
          const Spacer(),
          NumericKeypad(
            showDecimal: settings.currencyDecimals > 0,
            decimalLabel: rules.decimalSep,
            onDigit: _onDigit,
            onBackspace: () => setState(() {
              if (_amountStr.isNotEmpty) {
                _amountStr = _amountStr.substring(0, _amountStr.length - 1);
              }
            }),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _amount > 0 ? _submit : null,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, double value) {
    final selected = (double.tryParse(_amountStr) ?? -1) == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _amountStr = value.toStringAsFixed(
          value == value.roundToDouble() ? 0 : 2)),
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
      if (_amountStr.contains('.')) {
        if (_amountStr.split('.')[1].length >= 2) return;
      } else if (_amountStr.length >= 13) {
        return;
      }
      _amountStr = _amountStr == '0' ? d : _amountStr + d;
    });
  }

  Future<void> _pickAccount(List<Account> accounts, Map<int, double> setAside,
      String Function(double) fmt) async {
    final l10n = context.l10n;
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          children: [
            for (final a in accounts)
              ListTile(
                leading: Icon(AppIcons.resolve(a.iconName)),
                title: Text(a.name),
                subtitle: Text(
                    '${l10n.accSpendable}: ${fmt(a.balance - (setAside[a.id] ?? 0))}'),
                trailing: a.id == _accountId
                    ? Icon(Icons.check_rounded, color: sheet.palette.ink)
                    : null,
                onTap: () => Navigator.of(sheet).pop(a.id),
              ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _accountId = picked);
  }

  Future<void> _submit() async {
    final repo = ref.read(pocketRepositoryProvider);
    final navigator = Navigator.of(context);
    var completed = false;
    switch (widget.mode) {
      case MoneyMode.contribute:
        completed =
            await repo.contribute(widget.pocket!.id, _amount, _accountId);
      case MoneyMode.withdraw:
        await repo.withdraw(widget.pocket!.id, _amount);
      case MoneyMode.distribute:
        completed =
            await repo.distribute(widget.group!.pockets, _amount, _accountId);
    }
    HapticFeedback.mediumImpact();
    navigator.pop(completed);
  }
}
