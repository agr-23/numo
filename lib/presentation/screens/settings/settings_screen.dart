import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/currencies.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/pin_hasher.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/services/export_service.dart';
import '../../../data/services/isar_service.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/pin_pad.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _header(theme, 'Seguridad'),
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline),
            title: const Text('PIN de acceso'),
            value: settings.pinEnabled,
            activeThumbColor: AppColors.accent,
            onChanged: (v) => _togglePin(context, ref, settings, v),
          ),
          if (settings.pinEnabled)
            ListTile(
              leading: const Icon(Icons.pin_outlined),
              title: const Text('Cambiar PIN'),
              onTap: () => _changePin(context, ref),
            ),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Huella dactilar'),
            subtitle: settings.pinEnabled
                ? null
                : const Text('Requiere un PIN activo'),
            value: settings.biometricEnabled,
            activeThumbColor: AppColors.accent,
            onChanged: settings.pinEnabled
                ? (v) => notifier.setBiometric(v)
                : null,
          ),

          _header(theme, 'Apariencia'),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.screenPaddingH, vertical: 8),
            child: SegmentedButton<AppTheme>(
              segments: const [
                ButtonSegment(value: AppTheme.light, label: Text('Claro')),
                ButtonSegment(value: AppTheme.dark, label: Text('Oscuro')),
                ButtonSegment(value: AppTheme.system, label: Text('Auto')),
              ],
              selected: {settings.theme},
              onSelectionChanged: (s) => notifier.setTheme(s.first),
            ),
          ),

          _header(theme, 'Finanzas'),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Moneda'),
            subtitle: Text(
                '${settings.currency} (${settings.currencySymbol})'),
            onTap: () => _pickCurrency(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Primer día del mes'),
            subtitle: Text('Día ${settings.budgetStartDay}'),
            onTap: () => _pickStartDay(context, ref, settings.budgetStartDay),
          ),

          _header(theme, 'Categorías'),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Administrar categorías'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/categories'),
          ),

          _header(theme, 'Datos'),
          ListTile(
            leading: const Icon(Icons.ios_share),
            title: const Text('Exportar mis datos'),
            subtitle: const Text('Genera un CSV con todos tus movimientos'),
            onTap: () => _export(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.expense),
            title: const Text('Borrar todos los datos',
                style: TextStyle(color: AppColors.expense)),
            onTap: () => _deleteAll(context),
          ),

          _header(theme, 'Acerca de'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Numo — Finanzas personales simples'),
            subtitle: Text('Versión 1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _header(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimens.screenPaddingH, 16, 0, 4),
      child: Text(title,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
    );
  }

  Future<void> _togglePin(BuildContext context, WidgetRef ref,
      AppSettings settings, bool enable) async {
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
          title: 'Confirma tu PIN actual',
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
              title: Text('${c.code} — ${c.name}'),
              onTap: () {
                ref.read(settingsProvider.notifier).setCurrency(c);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }

  Future<void> _pickStartDay(
      BuildContext context, WidgetRef ref, int current) async {
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
                  backgroundColor:
                      d == current ? AppColors.accent : Colors.transparent,
                  child: Text('$d',
                      style: TextStyle(
                          color: d == current ? Colors.white : null)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ExportService.exportTransactions();
    } catch (e) {
      messenger
          .showSnackBar(SnackBar(content: Text('No se pudo exportar: $e')));
    }
  }

  Future<void> _deleteAll(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final step1 = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Borrar todos los datos'),
        content: const Text(
            'Esto eliminará todas tus cuentas, movimientos, presupuestos y metas. Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.expense),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continuar')),
        ],
      ),
    );
    if (step1 != true) return;
    if (!context.mounted) return;

    final controller = TextEditingController();
    final step2 = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmación final'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Escribe BORRAR para confirmar:'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'BORRAR'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.expense),
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim() == 'BORRAR'),
              child: const Text('Borrar todo')),
        ],
      ),
    );
    controller.dispose();
    if (step2 == true) {
      await IsarService.instance.clearAll();
      messenger.showSnackBar(
          const SnackBar(content: Text('Todos los datos fueron borrados')));
    }
  }
}
