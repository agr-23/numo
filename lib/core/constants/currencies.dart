/// Una moneda soportada en el onboarding y ajustes.
class CurrencyOption {
  final String code; // ISO: 'COP', 'USD', ...
  final String name; // Nombre en español
  final String symbol; // '$', '€', 'S/'
  final bool symbolBefore; // true => $100, false => 100$
  final int decimals; // 0 para COP, 2 para USD
  final String locale; // para NumberFormat

  const CurrencyOption({
    required this.code,
    required this.name,
    required this.symbol,
    required this.symbolBefore,
    required this.decimals,
    required this.locale,
  });
}

/// Las 10 monedas comunes del onboarding. COP es la primera (por defecto).
const List<CurrencyOption> kCurrencies = [
  CurrencyOption(
    code: 'COP',
    name: 'Peso colombiano',
    symbol: r'$',
    symbolBefore: true,
    decimals: 0,
    locale: 'es_CO',
  ),
  CurrencyOption(
    code: 'USD',
    name: 'Dólar americano',
    symbol: r'$',
    symbolBefore: true,
    decimals: 2,
    locale: 'en_US',
  ),
  CurrencyOption(
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
    symbolBefore: false,
    decimals: 2,
    locale: 'es_ES',
  ),
  CurrencyOption(
    code: 'MXN',
    name: 'Peso mexicano',
    symbol: r'$',
    symbolBefore: true,
    decimals: 2,
    locale: 'es_MX',
  ),
  CurrencyOption(
    code: 'ARS',
    name: 'Peso argentino',
    symbol: r'$',
    symbolBefore: true,
    decimals: 2,
    locale: 'es_AR',
  ),
  CurrencyOption(
    code: 'CLP',
    name: 'Peso chileno',
    symbol: r'$',
    symbolBefore: true,
    decimals: 0,
    locale: 'es_CL',
  ),
  CurrencyOption(
    code: 'PEN',
    name: 'Sol peruano',
    symbol: 'S/',
    symbolBefore: true,
    decimals: 2,
    locale: 'es_PE',
  ),
  CurrencyOption(
    code: 'BRL',
    name: 'Real brasileño',
    symbol: r'R$',
    symbolBefore: true,
    decimals: 2,
    locale: 'pt_BR',
  ),
  CurrencyOption(
    code: 'GBP',
    name: 'Libra esterlina',
    symbol: '£',
    symbolBefore: true,
    decimals: 2,
    locale: 'en_GB',
  ),
  CurrencyOption(
    code: 'CAD',
    name: 'Dólar canadiense',
    symbol: r'$',
    symbolBefore: true,
    decimals: 2,
    locale: 'en_CA',
  ),
];

CurrencyOption currencyByCode(String code) {
  return kCurrencies.firstWhere(
    (c) => c.code == code,
    orElse: () => kCurrencies.first,
  );
}
