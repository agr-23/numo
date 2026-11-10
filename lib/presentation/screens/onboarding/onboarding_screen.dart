import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/currencies.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/amount_input.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/account.dart';
import '../../../data/models/app_settings.dart';
import '../../../providers/accounts_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/amount_field.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // Páginas: 0 bienvenida · 1-2 presentación · 3 moneda · 4 primera cuenta.
  static const _pageCount = 5;
  static const _currencyPage = 3;
  static const _accountPage = 4;

  final _pageCtrl = PageController();
  int _page = 0;

  final _nameCtrl = TextEditingController();
  final _balanceCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();
  AccountType _accountType = AccountType.cash;
  CurrencyOption _currency = kCurrencies.first;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _balanceCtrl.dispose();
    _limitCtrl.dispose();
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (_page < _pageCount - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final messenger = ScaffoldMessenger.of(context);
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(context.l10n.onbAccountNameMissing)),
      );
      _pageCtrl.jumpToPage(_accountPage);
      return;
    }
    final rules = AmountInput.of(_currency.code);
    final isCredit = _accountType == AccountType.credit;
    final limit = rules.parse(_limitCtrl.text);

    final account = Account()
      ..name = name
      ..type = _accountType
      ..balance = rules.parse(_balanceCtrl.text)
      ..creditLimit = isCredit && limit > 0 ? limit : null
      ..colorHex = AppColors.toHex(AppColors.palette.first)
      ..iconName = isCredit ? 'credit_card' : AppIcons.accountIcons.first
      ..createdAt = DateTime.now()
      ..isActive = true;

    await ref.read(accountRepositoryProvider).add(account);
    await ref.read(settingsProvider.notifier).setCurrency(_currency);
    await ref.read(settingsProvider.notifier).completeOnboarding();
    unawaited(HapticFeedback.mediumImpact());
    if (!mounted) return;
    context.go('/home/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedOpacity(
                opacity: _page < _currencyPage ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: TextButton(
                  onPressed: _page < _currencyPage
                      ? () => _pageCtrl.animateToPage(
                          _currencyPage,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        )
                      : null,
                  child: Text(l10n.onbSkip),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _stepWelcome(),
                  _stepIntro(
                    icon: Icons.bolt,
                    title: l10n.onbFastTitle,
                    points: [
                      (Icons.dialpad, l10n.onbFast1),
                      (Icons.repeat, l10n.onbFast2),
                      (Icons.swap_horiz, l10n.onbFast3),
                    ],
                  ),
                  _stepIntro(
                    icon: Icons.insights,
                    title: l10n.onbControlTitle,
                    points: [
                      (Icons.pie_chart_outline, l10n.onbControl1),
                      (Icons.credit_card, l10n.onbControl2),
                      (Icons.savings_outlined, l10n.onbControl3),
                      (Icons.lock_outline, l10n.onbControl4),
                    ],
                  ),
                  _stepCurrency(),
                  _stepAccount(),
                ],
              ),
            ),
            _dots(),
            Padding(
              padding: const EdgeInsets.all(Dimens.screenPaddingH),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(switch (_page) {
                    0 => l10n.onbStart,
                    _accountPage => l10n.onbFinish,
                    _ => l10n.continueLabel,
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _pageCount; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _page == i ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _page == i
                  ? context.palette.ink
                  : Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }

  Widget _stepWelcome() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Dimens.screenPaddingH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: context.palette.ink,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(
                'N',
                style: TextStyle(
                  color: context.palette.onInk,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            context.l10n.onbWelcomeTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.onbWelcomeBody,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 32),
          Text(context.l10n.onbLanguage, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'es', label: Text(context.l10n.languageEs)),
              ButtonSegment(value: 'en', label: Text(context.l10n.languageEn)),
            ],
            selected: {Localizations.localeOf(context).languageCode},
            showSelectedIcon: false,
            onSelectionChanged: (s) =>
                ref.read(settingsProvider.notifier).setLanguage(s.first),
          ),
        ],
      ),
    );
  }

  Widget _stepIntro({
    required IconData icon,
    required String title,
    required List<(IconData, String)> points,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Dimens.screenPaddingH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.palette.ink.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: context.palette.ink, size: 38),
          ),
          const SizedBox(height: 24),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 20),
          for (final (pIcon, text) in points)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Icon(
                    pIcon,
                    size: 22,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _stepAccount() {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(Dimens.screenPaddingH),
      children: [
        const SizedBox(height: 24),
        Text(context.l10n.onbAccountTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 24),
        TextField(
          controller: _nameCtrl,
          decoration: InputDecoration(
            labelText: context.l10n.name,
            hintText: context.l10n.onbAccountHint,
          ),
        ),
        const SizedBox(height: 20),
        Text(context.l10n.type, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _typeChip(context.l10n.accountTypeCash, AccountType.cash),
            _typeChip(context.l10n.accountTypeBank, AccountType.bank),
            _typeChip(context.l10n.accountTypeCredit, AccountType.credit),
          ],
        ),
        const SizedBox(height: 20),
        if (_accountType == AccountType.credit) ...[
          AmountField(
            controller: _limitCtrl,
            currency: _currency,
            label: context.l10n.onbLimitOptional,
          ),
          const SizedBox(height: 16),
          AmountField(
            controller: _balanceCtrl,
            currency: _currency,
            label: context.l10n.onbDebtOptional,
            helper: context.l10n.onbDatesLater,
          ),
        ] else
          AmountField(
            controller: _balanceCtrl,
            currency: _currency,
            label: context.l10n.onbBalanceOptional,
          ),
      ],
    );
  }

  Widget _typeChip(String label, AccountType type) {
    return ChoiceChip(
      label: Text(label),
      selected: _accountType == type,
      onSelected: (_) => setState(() => _accountType = type),
    );
  }

  Widget _stepCurrency() {
    final theme = Theme.of(context);
    final previewSettings = AppSettings()
      ..currency = _currency.code
      ..currencySymbol = _currency.symbol
      ..currencySymbolBefore = _currency.symbolBefore
      ..currencyDecimals = _currency.decimals;

    return ListView(
      padding: const EdgeInsets.all(Dimens.screenPaddingH),
      children: [
        const SizedBox(height: 24),
        Text(context.l10n.onbCurrencyTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(Dimens.cardPadding),
          decoration: BoxDecoration(
            color: context.palette.ink,
            borderRadius: BorderRadius.circular(Dimens.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.onbCurrencyPreview,
                style: TextStyle(
                  color: context.palette.onInk.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(1250000, previewSettings),
                style: TextStyle(
                  color: context.palette.onInk,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final c in kCurrencies)
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => setState(() => _currency = c),
            leading: Text(c.symbol, style: theme.textTheme.titleMedium),
            title: Text('${c.code} — ${currencyName(c.code, context.l10n)}'),
            trailing: _currency.code == c.code
                ? Icon(Icons.check_circle, color: context.palette.ink)
                : Icon(Icons.circle_outlined, color: context.palette.inkHint),
          ),
      ],
    );
  }
}
