import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../providers/capture_provider.dart';

/// Ajustes → Movimientos automáticos.
///
/// Iteración 1 (modo captura): explica qué hace Numo con los avisos, da
/// acceso a los ajustes del sistema y deja elegir las apps del banco.
class AutoMovementsScreen extends ConsumerStatefulWidget {
  const AutoMovementsScreen({super.key});

  @override
  ConsumerState<AutoMovementsScreen> createState() =>
      _AutoMovementsScreenState();
}

class _AutoMovementsScreenState extends ConsumerState<AutoMovementsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Al volver de los ajustes de Android, el acceso pudo cambiar.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref
        ..invalidate(captureAccessProvider)
        ..invalidate(capturedNoticesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;
    final theme = Theme.of(context);
    final access = ref.watch(captureAccessProvider).valueOrNull ?? false;
    final selected = ref.watch(selectedAppsProvider).valueOrNull ?? const {};
    final apps = ref.watch(installedAppsProvider).valueOrNull ?? const [];
    final notices = ref.watch(capturedNoticesProvider).valueOrNull ?? const [];

    final selectedLabels = [
      for (final a in apps)
        if (selected.contains(a.packageName)) a.label,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.amTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.screenPaddingH,
            ),
            child: Container(
              padding: const EdgeInsets.all(Dimens.cardPadding),
              decoration: BoxDecoration(
                color: p.surfaceMuted,
                borderRadius: BorderRadius.circular(Dimens.cardRadius),
              ),
              child: Text(l10n.amIntro, style: theme.textTheme.bodyMedium),
            ),
          ),

          _Header(l10n.amPrivacyTitle),
          _Point(Icons.apps_outlined, l10n.amPrivacyApps),
          _Point(Icons.password_outlined, l10n.amPrivacyCodes),
          _Point(Icons.wifi_off_outlined, l10n.amPrivacyOffline),
          _Point(Icons.auto_delete_outlined, l10n.amPrivacyRetention),

          _Header(l10n.amSetup),
          ListTile(
            leading: Icon(
              access ? Icons.check_circle : Icons.circle_outlined,
              color: access ? p.income : p.inkHint,
            ),
            title: Text(l10n.amAccess),
            subtitle: Text(access ? l10n.amAccessOn : l10n.amAccessOff),
            trailing: TextButton(
              onPressed: () => _openAccess(access),
              child: Text(access ? l10n.amAccessManage : l10n.amAccessEnable),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: Text(l10n.amAppsChoose),
            subtitle: Text(
              selectedLabels.isEmpty
                  ? l10n.amAppsNone
                  : selectedLabels.join(', '),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/auto-movements/apps'),
          ),

          ListTile(
            leading: const Icon(Icons.inbox_outlined),
            title: Text(l10n.amNotices),
            subtitle: Text(l10n.amNoticesCount(notices.length)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/auto-movements/notices'),
          ),
        ],
      ),
    );
  }

  Future<void> _openAccess(bool granted) async {
    final service = ref.read(captureServiceProvider);
    if (!granted) {
      final l10n = context.l10n;
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.amAccessDialogTitle),
          content: Text(l10n.amAccessDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.continueLabel),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    await service.openAccessSettings();
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimens.screenPaddingH, 20, 0, 4),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.screenPaddingH,
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.palette.inkMuted),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
