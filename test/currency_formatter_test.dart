import 'package:flutter_test/flutter_test.dart';
import 'package:numo/core/constants/currencies.dart';
import 'package:numo/core/utils/currency_formatter.dart';
import 'package:numo/data/models/app_settings.dart';

AppSettings _settingsFor(String code) {
  final c = currencyByCode(code);
  return AppSettings.defaults()
    ..currency = c.code
    ..currencySymbol = c.symbol
    ..currencySymbolBefore = c.symbolBefore
    ..currencyDecimals = c.decimals;
}

void main() {
  test('COP: símbolo antes, puntos de miles, sin decimales', () {
    final s = _settingsFor('COP');
    expect(CurrencyFormatter.format(3136000, s), r'$3.136.000');
    expect(CurrencyFormatter.format(-18500, s), r'−$18.500');
    expect(CurrencyFormatter.signed(18500, s, isIncome: false), r'−$18.500');
    expect(CurrencyFormatter.signed(18500, s, isIncome: true), r'+$18.500');
  });

  test('USD: comas de miles y dos decimales', () {
    expect(CurrencyFormatter.format(1250.5, _settingsFor('USD')), r'$1,250.50');
  });

  test('EUR: símbolo después, coma decimal', () {
    expect(CurrencyFormatter.format(1250.5, _settingsFor('EUR')), '1.250,50 €');
  });
}
