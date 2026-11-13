import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/dimens.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/numo_palette.dart';
import '../../../providers/capture_provider.dart';

/// Elegir de qué apps leer avisos. Por defecto, ninguna.
class CaptureAppsScreen extends ConsumerStatefulWidget {
  const CaptureAppsScreen({super.key});

  @override
  ConsumerState<CaptureAppsScreen> createState() => _CaptureAppsScreenState();
}

class _CaptureAppsScreenState extends ConsumerState<CaptureAppsScreen> {
  String _query = '';
  Set<String>? _selected;

  Future<void> _toggle(String pkg, bool on) async {
    final next = {...?_selected};
    on ? next.add(pkg) : next.remove(pkg);
    setState(() => _selected = next);
    await ref.read(captureServiceProvider).setSelectedApps(next);
    ref.invalidate(selectedAppsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appsAsync = ref.watch(installedAppsProvider);
    final saved = ref.watch(selectedAppsProvider).valueOrNull;
    _selected ??= saved;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.amAppsChoose)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.screenPaddingH,
              4,
              Dimens.screenPaddingH,
              4,
            ),
            child: Text(
              l10n.amAppsHint,
              style: TextStyle(color: context.palette.inkMuted),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.screenPaddingH,
              vertical: 8,
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.amAppsSearch,
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: appsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
              data: (apps) {
                final selected = _selected ?? const <String>{};
                final visible = [
                  for (final a in apps)
                    if (_query.isEmpty ||
                        a.label.toLowerCase().contains(_query))
                      a,
                ];
                return ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (_, i) {
                    final app = visible[i];
                    return CheckboxListTile(
                      title: Text(app.label),
                      value: selected.contains(app.packageName),
                      activeColor: context.palette.ink,
                      checkColor: context.palette.onInk,
                      onChanged: _selected == null
                          ? null
                          : (v) =>
                                unawaited(_toggle(app.packageName, v ?? false)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
