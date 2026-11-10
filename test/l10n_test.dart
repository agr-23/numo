import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:numo/core/l10n/l10n.dart';
import 'package:numo/core/utils/date_formatter.dart';
import 'package:numo/data/models/category.dart';

/// Monta un widget con el idioma [locale] y devuelve sus textos.
Future<AppLocalizations> pumpL10n(WidgetTester tester, Locale locale) async {
  late AppLocalizations l10n;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          l10n = context.l10n;
          return const SizedBox();
        },
      ),
    ),
  );
  return l10n;
}

Category predefined(String key, String spanishName) => Category()
  ..key = key
  ..name = spanishName
  ..iconName = 'restaurant'
  ..colorHex = '#000000'
  ..type = CategoryType.expense
  ..isCustom = false
  ..sortOrder = 0;

void main() {
  setUpAll(initializeDateFormatting);

  testWidgets('textos en español e inglés', (tester) async {
    final es = await pumpL10n(tester, const Locale('es'));
    expect(es.save, 'Guardar');
    expect(es.goalDaysLeft(1), 'Queda 1 día');
    expect(es.goalDaysLeft(5), 'Quedan 5 días');

    final en = await pumpL10n(tester, const Locale('en'));
    expect(en.save, 'Save');
    expect(en.goalDaysLeft(1), '1 day left');
    expect(en.inDays(3), 'in 3 days');
  });

  testWidgets('categorías predefinidas se traducen, las propias no', (
    tester,
  ) async {
    final en = await pumpL10n(tester, const Locale('en'));
    expect(categoryLabel(predefined('food', 'Comida'), en), 'Food');
    expect(categoryLabel(predefined('salary', 'Salario'), en), 'Salary');

    final custom = Category()
      ..name = 'Mascotas'
      ..iconName = 'pets'
      ..colorHex = '#000000'
      ..type = CategoryType.expense
      ..isCustom = true
      ..sortOrder = 20;
    expect(categoryLabel(custom, en), 'Mascotas');
  });

  testWidgets('monedas y tipos de cuenta', (tester) async {
    final en = await pumpL10n(tester, const Locale('en'));
    expect(currencyName('COP', en), 'Colombian peso');
    final es = await pumpL10n(tester, const Locale('es'));
    expect(currencyName('COP', es), 'Peso colombiano');
  });

  test('fechas siguen el idioma activo', () {
    final date = DateTime(2026, 11, 9);
    Intl.defaultLocale = 'es';
    expect(DateFormatter.monthYear(date), 'Noviembre de 2026');
    Intl.defaultLocale = 'en';
    expect(DateFormatter.monthYear(date), 'November 2026');
    expect(DateFormatter.longDay(date), 'Monday, November 9');
  });
}
