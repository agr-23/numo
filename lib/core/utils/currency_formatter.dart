import 'package:intl/intl.dart';

import '../../data/models/app_settings.dart';

/// Formatea montos respetando la moneda configurada en [AppSettings].
class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, AppSettings settings) {
    final formatter = NumberFormat.currency(
      locale: _localeFor(settings.currency),
      symbol: settings.currencySymbol,
      decimalDigits: settings.currencyDecimals,
    );
    final formatted = formatter.format(amount.abs());
    // NumberFormat.currency siempre antepone el símbolo; si la moneda lo
    // quiere después (ej. EUR), lo reubicamos.
    final withSymbol = settings.currencySymbolBefore
        ? formatted
        : _moveSymbolToEnd(formatted, settings.currencySymbol);
    return amount < 0 ? '-$withSymbol' : withSymbol;
  }

  /// Igual que [format] pero con signo explícito (+/−) para movimientos.
  static String signed(double amount, AppSettings settings,
      {required bool isIncome}) {
    final base = format(amount.abs(), settings);
    return isIncome ? '+$base' : '-$base';
  }

  static String _moveSymbolToEnd(String formatted, String symbol) {
    if (formatted.startsWith(symbol)) {
      return '${formatted.substring(symbol.length).trim()} $symbol';
    }
    return formatted;
  }

  static String _localeFor(String currencyCode) {
    switch (currencyCode) {
      case 'COP':
        return 'es_CO';
      case 'EUR':
        return 'es_ES';
      case 'MXN':
        return 'es_MX';
      case 'ARS':
        return 'es_AR';
      case 'CLP':
        return 'es_CL';
      case 'PEN':
        return 'es_PE';
      case 'BRL':
        return 'pt_BR';
      case 'GBP':
        return 'en_GB';
      case 'CAD':
        return 'en_CA';
      default:
        return 'en_US';
    }
  }
}
