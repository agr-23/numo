import 'package:intl/intl.dart';

import '../../data/models/app_settings.dart';
import '../constants/currencies.dart';

/// Formatea montos respetando la moneda configurada en [AppSettings].
///
/// Arma el texto a mano (número agrupado + símbolo) en vez de usar
/// `NumberFormat.currency`, porque la posición del símbolo en los datos de
/// cada país cambia entre versiones de `intl` (es_CO pasó a "3.136.000 $").
/// Así el símbolo queda donde dice la moneda: "$3.136.000", "1.250,50 €".
class CurrencyFormatter {
  CurrencyFormatter._();

  static final Map<String, NumberFormat> _cache = {};

  static NumberFormat _numberFormat(String currency, int decimals) {
    return _cache.putIfAbsent('$currency/$decimals', () {
      final locale = currencyByCode(currency).locale;
      return NumberFormat.decimalPatternDigits(
          locale: locale, decimalDigits: decimals);
    });
  }

  static String format(double amount, AppSettings settings) {
    final number = _numberFormat(settings.currency, settings.currencyDecimals)
        .format(amount.abs());
    final withSymbol = settings.currencySymbolBefore
        ? '${settings.currencySymbol}$number'
        : '$number ${settings.currencySymbol}';
    return amount < 0 ? '−$withSymbol' : withSymbol;
  }

  /// Igual que [format] pero con signo explícito (+/−) para movimientos.
  static String signed(double amount, AppSettings settings,
      {required bool isIncome}) {
    final base = format(amount.abs(), settings);
    return isIncome ? '+$base' : '−$base';
  }
}
