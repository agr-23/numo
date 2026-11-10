import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../core/constants/currencies.dart';
import '../data/models/app_settings.dart';
import '../data/services/isar_service.dart';

/// Expone los [AppSettings] actuales de forma síncrona y reactiva.
final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  Isar get _isar => IsarService.instance.isar;

  @override
  AppSettings build() {
    final sub = _isar.appSettings.watchObject(1).listen((s) {
      if (s != null) state = s;
    });
    ref.onDispose(sub.cancel);
    return _isar.appSettings.getSync(1) ?? AppSettings.defaults();
  }

  Future<void> _persist(AppSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(settings);
    });
    state = settings;
  }

  Future<void> setTheme(AppTheme theme) async {
    await _persist(_copy()..theme = theme);
  }

  Future<void> setCurrency(CurrencyOption option) async {
    await _persist(
      _copy()
        ..currency = option.code
        ..currencySymbol = option.symbol
        ..currencySymbolBefore = option.symbolBefore
        ..currencyDecimals = option.decimals,
    );
  }

  Future<void> setBudgetStartDay(int day) async {
    await _persist(_copy()..budgetStartDay = day);
  }

  Future<void> setPin(String? pinHash) async {
    await _persist(
      _copy()
        ..pinHash = pinHash
        ..pinEnabled = pinHash != null
        ..biometricEnabled = pinHash == null ? false : state.biometricEnabled,
    );
  }

  Future<void> setBiometric(bool enabled) async {
    await _persist(_copy()..biometricEnabled = enabled);
  }

  Future<void> completeOnboarding() async {
    await _persist(_copy()..isOnboardingDone = true);
  }

  /// Copia el estado actual (Isar reusa el id = 1).
  AppSettings _copy() {
    return AppSettings()
      ..id = 1
      ..currency = state.currency
      ..currencySymbol = state.currencySymbol
      ..currencySymbolBefore = state.currencySymbolBefore
      ..currencyDecimals = state.currencyDecimals
      ..theme = state.theme
      ..pinEnabled = state.pinEnabled
      ..pinHash = state.pinHash
      ..biometricEnabled = state.biometricEnabled
      ..isOnboardingDone = state.isOnboardingDone
      ..budgetStartDay = state.budgetStartDay;
  }
}

/// Mapea el [AppTheme] guardado al [ThemeMode] de Flutter.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final theme = ref.watch(settingsProvider).theme;
  switch (theme) {
    case AppTheme.light:
      return ThemeMode.light;
    case AppTheme.dark:
      return ThemeMode.dark;
    case AppTheme.system:
      return ThemeMode.system;
  }
});
