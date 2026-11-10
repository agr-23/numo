import 'package:isar/isar.dart';

part 'app_settings.g.dart';

enum AppTheme { light, dark, system }

/// Singleton de ajustes — siempre id = 1.
@collection
class AppSettings {
  Id id = 1;

  late String currency; // 'COP', 'USD', 'EUR', etc.
  late String currencySymbol; // '$', '€', etc.
  late bool currencySymbolBefore; // true = $100, false = 100$
  late int currencyDecimals; // 0 para COP, 2 para USD

  @Enumerated(EnumType.name)
  late AppTheme theme; // light, dark, system

  late bool pinEnabled;
  String? pinHash; // SHA-256 del PIN de 4 dígitos
  late bool biometricEnabled;
  late bool isOnboardingDone;
  late int budgetStartDay; // Primer día del mes para presupuestos (default: 1)

  /// Idioma elegido ('es', 'en'). Null = seguir el idioma del teléfono.
  String? languageCode;

  AppSettings();

  /// Crea los ajustes por defecto (COP, tema sistema, sin PIN).
  factory AppSettings.defaults() {
    return AppSettings()
      ..id = 1
      ..currency = 'COP'
      ..currencySymbol = r'$'
      ..currencySymbolBefore = true
      ..currencyDecimals = 0
      ..theme = AppTheme.system
      ..pinEnabled = false
      ..pinHash = null
      ..biometricEnabled = false
      ..isOnboardingDone = false
      ..budgetStartDay = 1
      ..languageCode = null;
  }
}
