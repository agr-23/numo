import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_info.dart';
import '../../../core/constants/currencies.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../core/utils/pin_hasher.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/services/export_service.dart';
import '../../../data/services/isar_service.dart';
import '../../../providers/capture_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/pin_pad.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.setTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _header(theme, l10n.setSecurity),
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline),
            title: Text(l10n.setPin),
            value: settings.pinEnabled,
            activeThumbColor: context.palette.ink,
            onChanged: (v) => _togglePin(context, ref, settings, v),
          ),
          if (settings.pinEnabled)
            ListTile(
              leading: const Icon(Icons.pin_outlined),
              title: Text(l10n.setChangePin),
              onTap: () => _changePin(context, ref),
            ),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: Text(l10n.setBiometric),
            subtitle: settings.pinEnabled
                ? null
                : Text(l10n.setBiometricNeedsPin),
            value: settings.biometricEnabled,
            activeThumbColor: context.palette.ink,
            onChanged: settings.pinEnabled ? notifier.setBiometric : null,
          ),

          _header(theme, l10n.setAppearance),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.screenPaddingH,
              vertical: 8,
            ),
            child: SegmentedButton<AppTheme>(
              segments: [
                ButtonSegment(
                  value: AppTheme.light,
                  label: Text(l10n.setThemeLight),
                ),
                ButtonSegment(
                  value: AppTheme.dark,
                  label: Text(l10n.setThemeDark),
                ),
                ButtonSegment(
                  value: AppTheme.system,
                  label: Text(l10n.setThemeAuto),
                ),
              ],
              selected: {settings.theme},
              onSelectionChanged: (s) => notifier.setTheme(s.first),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.setLanguage),
            subtitle: Text(_languageLabel(settings.languageCode, l10n)),
            onTap: () => _pickLanguage(context, ref, settings.languageCode),
          ),

          _header(theme, l10n.setFinance),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(l10n.setCurrency),
            subtitle: Text('${settings.currency} (${settings.currencySymbol})'),
            onTap: () => _pickCurrency(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(l10n.setMonthStart),
            subtitle: Text(l10n.dayN(settings.budgetStartDay)),
            onTap: () => _pickStartDay(context, ref, settings.budgetStartDay),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: Text(l10n.amTitle),
            subtitle: Text(l10n.amSettingsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/auto-movements'),
          ),

          _header(theme, l10n.categories),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(l10n.setManageCategories),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/categories'),
          ),

          _header(theme, l10n.setData),
          ListTile(
            leading: const Icon(Icons.ios_share),
            title: Text(l10n.setExport),
            subtitle: Text(l10n.setExportSubtitle),
            onTap: () => _export(context),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: context.palette.expense),
            title: Text(
              l10n.setDeleteAll,
              style: TextStyle(color: context.palette.expense),
            ),
            onTap: () => _deleteAll(context, ref),
          ),

          _header(theme, l10n.setAbout),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.appTagline),
            subtitle: Text(l10n.appVersion(kAppVersion)),
          ),
        ],
      ),
    );
  }

  Widget _header(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimens.screenPaddingH, 16, 0, 4),
      child: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _togglePin(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    bool enable,
  ) async {
    final notifier = ref.read(settingsProvider.notifier);
    if (enable) {
      final pin = await context.push<String>('/create-pin');
      if (pin != null) {
        await notifier.setPin(PinHasher.hash(pin));
      }
    } else {
      final ok = await _verifyPin(context, settings.pinHash);
      if (ok) await notifier.setPin(null);
    }
  }

  Future<void> _changePin(BuildContext context, WidgetRef ref) async {
    final pin = await context.push<String>('/create-pin');
    if (pin != null) {
      await ref.read(settingsProvider.notifier).setPin(PinHasher.hash(pin));
    }
  }

  Future<bool> _verifyPin(BuildContext context, String? storedHash) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: PinPad(
          title: context.l10n.confirmCurrentPin,
          onCompleted: (pin) async {
            final ok = PinHasher.verify(pin, storedHash);
            if (ok) Navigator.of(context).pop(true);
            return ok;
          },
        ),
      ),
    );
    return result ?? false;
  }

  Future<void> _pickCurrency(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.screenPaddingH),
        children: [
          for (final c in kCurrencies)
            ListTile(
              leading: Text(c.symbol),
              title: Text('${c.code} — ${currencyName(c.code, context.l10n)}'),
              onTap: () {
                ref.read(settingsProvider.notifier).setCurrency(c);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }

  String _languageLabel(String? code, AppLocalizations l10n) {
    switch (code) {
      case 'es':
        return l10n.languageEs;
      case 'en':
        return l10n.languageEn;
      default:
        return l10n.languageSystem;
    }
  }

  Future<void> _pickLanguage(
    BuildContext context,
    WidgetRef ref,
    String? current,
  ) async {
    final l10n = context.l10n;
    final options = <(String?, String)>[
      (null, l10n.languageSystem),
      ('es', l10n.languageEs),
      ('en', l10n.languageEn),
    ];
    await showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (code, label) in options)
              ListTile(
                title: Text(label),
                trailing: code == current
                    ? Icon(Icons.check, color: context.palette.ink)
                    : null,
                onTap: () {
                  ref.read(settingsProvider.notifier).setLanguage(code);
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickStartDay(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          for (var d = 1; d <= 28; d++)
            InkWell(
              onTap: () {
                ref.read(settingsProvider.notifier).setBudgetStartDay(d);
                Navigator.of(context).pop();
              },
              child: Center(
                child: CircleAvatar(
                  backgroundColor: d == current
                      ? context.palette.ink
                      : Colors.transparent,
                  child: Text(
                    '$d',
                    style: TextStyle(
                      color: d == current ? context.palette.onInk : null,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      await ExportService.exportTransactions(l10n);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.setExportFailed(e.toString()))),
      );
    }
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final step1 = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.setDeleteAll),
        content: Text(l10n.setDeleteAllBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.palette.expense,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.continueLabel),
          ),
        ],
      ),
    );
    if (step1 != true) return;
    if (!context.mounted) return;

    final controller = TextEditingController();
    final step2 = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.setFinalConfirm),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.setTypeToConfirm(l10n.setConfirmWord)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: l10n.setConfirmWord),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.palette.expense,
            ),
            onPressed: () => Navigator.of(
              context,
            ).pop(controller.text.trim().toUpperCase() == l10n.setConfirmWord),
            child: Text(l10n.setDeleteEverything),
          ),
        ],
      ),
    );
    controller.dispose();
    if (step2 == true) {
      await IsarService.instance.clearAll();
      await ref.read(captureServiceProvider).clear();
      messenger.showSnackBar(SnackBar(content: Text(l10n.setAllDeleted)));
    }
  }
}
