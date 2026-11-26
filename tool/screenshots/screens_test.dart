// Capturas de pantalla de Numo con datos de ejemplo, sin emulador.
//
//   flutter test tool/screenshots/screens_test.dart --update-goldens
//
// Genera PNG en tool/screenshots/out/. No corre con `flutter test`
// normal (vive fuera de test/) porque las capturas dependen de las fuentes
// del sistema y no sirven como prueba automática.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:numo/core/constants/default_categories.dart';
import 'package:numo/core/l10n/l10n.dart';
import 'package:numo/core/theme/app_theme.dart';
import 'package:numo/data/models/account.dart';
import 'package:numo/data/models/app_settings.dart' hide AppTheme;
import 'package:numo/data/models/budget.dart';
import 'package:numo/data/models/category.dart';
import 'package:numo/data/models/pocket.dart';
import 'package:numo/data/models/savings_group.dart';
import 'package:numo/data/models/transaction.dart';
import 'package:numo/data/services/capture_service.dart';
import 'package:numo/presentation/screens/accounts/accounts_screen.dart';
import 'package:numo/presentation/screens/add_transaction/add_transaction_screen.dart';
import 'package:numo/presentation/screens/analytics/analytics_screen.dart';
import 'package:numo/presentation/screens/auto_movements/auto_movements_screen.dart';
import 'package:numo/presentation/screens/auto_movements/capture_apps_screen.dart';
import 'package:numo/presentation/screens/auto_movements/captured_notices_screen.dart';
import 'package:numo/presentation/screens/budgets/budgets_screen.dart';
import 'package:numo/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:numo/presentation/screens/home/home_shell.dart';
import 'package:numo/presentation/screens/savings/group_screen.dart';
import 'package:numo/presentation/screens/savings/savings_screen.dart';
import 'package:numo/presentation/screens/settings/settings_screen.dart';
import 'package:numo/presentation/screens/transactions/transactions_screen.dart';
import 'package:numo/providers/accounts_provider.dart';
import 'package:numo/providers/budgets_provider.dart';
import 'package:numo/providers/capture_provider.dart';
import 'package:numo/providers/categories_provider.dart';
import 'package:numo/providers/savings_provider.dart';
import 'package:numo/providers/settings_provider.dart';
import 'package:numo/providers/transactions_provider.dart';

/// Ajustes en memoria (sin Isar).
class _FakeSettings extends SettingsNotifier {
  _FakeSettings(this.initial);
  final AppSettings initial;
  @override
  AppSettings build() => initial;
}

Future<void> _loadFonts() async {
  final inter = FontLoader('Inter');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    inter.addFont(rootBundle.load('assets/fonts/Inter-$w.ttf'));
  }
  await inter.load();
  // Íconos de Material desde el SDK de Flutter.
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ??
      '${Platform.environment['HOME']}/flutter';
  final icons = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  final loader = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync())));
  await loader.load();
}

class _Data {
  final categories = buildDefaultCategories();
  late final List<Account> accounts;
  late final List<Transaction> transactions;
  late final List<Budget> budgets;
  late final List<SavingsGroup> groups;
  late final List<Pocket> pockets;

  Category cat(String key) => categories.firstWhere((c) => c.key == key);

  _Data() {
    for (var i = 0; i < categories.length; i++) {
      categories[i].id = i + 1;
    }
    Account acc(
      int id,
      String name,
      AccountType type,
      double balance, {
      double? limit,
      int? pay,
    }) => Account()
      ..id = id
      ..name = name
      ..type = type
      ..balance = balance
      ..creditLimit = limit
      ..paymentDueDay = pay
      ..statementDay = pay == null ? null : 30
      ..colorHex = '#000000'
      ..iconName = type == AccountType.credit
          ? 'credit_card'
          : type == AccountType.bank
          ? 'account_balance'
          : 'account_balance_wallet'
      ..createdAt = DateTime(2026)
      ..isActive = true;
    accounts = [
      acc(1, 'Bancolombia', AccountType.bank, 4240000),
      acc(2, 'Efectivo', AccountType.cash, 180000),
      acc(3, 'Visa Oro', AccountType.credit, 1284000, limit: 5000000, pay: 15),
    ];

    final now = DateTime.now();
    Transaction tx(
      String title,
      double amount,
      TransactionType type,
      String catKey,
      int accountId,
      int daysAgo,
    ) {
      final t = Transaction()
        ..id = title.hashCode
        ..title = title
        ..amount = amount
        ..type = type
        ..date = now.subtract(Duration(days: daysAgo))
        ..isRecurring = false;
      t.category.value = cat(catKey);
      t.account.value = accounts.firstWhere((a) => a.id == accountId);
      return t;
    }

    transactions = [
      tx('Almuerzo', 18500, TransactionType.expense, 'food', 1, 0),
      tx('Salario', 3100000, TransactionType.income, 'salary', 1, 1),
      tx('Mercado', 142300, TransactionType.expense, 'groceries', 3, 1),
      tx('Taxi', 12000, TransactionType.expense, 'transport', 2, 2),
      tx('Netflix', 44900, TransactionType.expense, 'subscriptions', 3, 3),
      tx('Gasolina', 120000, TransactionType.expense, 'transport', 1, 4),
      tx('Restaurante', 85000, TransactionType.expense, 'food', 1, 5),
    ];

    Budget budget(String catKey, double limit) {
      final b = Budget()
        ..id = catKey.hashCode
        ..limitAmount = limit
        ..month = now.month
        ..year = now.year;
      b.category.value = cat(catKey);
      return b;
    }

    budgets = [budget('food', 800000), budget('transport', 150000)];

    SavingsGroup group(int id, String name, String icon, String? tpl) =>
        SavingsGroup()
          ..id = id
          ..name = name
          ..iconName = icon
          ..colorHex = '#111114'
          ..sortOrder = id
          ..createdAt = DateTime(2026)
          ..templateKey = tpl;
    groups = [
      group(1, 'Carro', 'directions_car_filled', 'car'),
      group(2, 'Viaje a Cartagena', 'flight', 'trip'),
    ];
    var pid = 0;
    Pocket pocket(
      int g,
      String name,
      String icon,
      PocketKind kind,
      double target,
      double saved, [
      DateTime? due,
    ]) => Pocket()
      ..id = ++pid
      ..groupId = g
      ..name = name
      ..iconName = icon
      ..kind = kind
      ..targetAmount = target
      ..savedAmount = saved
      ..dueDate = due
      ..accountId = 1
      ..isCompleted = false
      ..sortOrder = pid
      ..createdAt = DateTime(2026);
    final y = now.year;
    pockets = [
      pocket(
        1,
        'Gasolina',
        'local_gas_station',
        PocketKind.monthly,
        400000,
        280000,
      ),
      pocket(
        1,
        'Parqueaderos',
        'local_parking',
        PocketKind.monthly,
        150000,
        90000,
      ),
      pocket(1, 'Peajes', 'toll', PocketKind.monthly, 120000, 60000),
      pocket(
        1,
        'SOAT',
        'shield',
        PocketKind.yearly,
        980000,
        420000,
        DateTime(now.month <= 3 ? y : y + 1, 3, 12),
      ),
      pocket(
        1,
        'Técnico-mecánica',
        'build',
        PocketKind.yearly,
        310000,
        150000,
        DateTime(now.month <= 4 ? y : y + 1, 4, 20),
      ),
      pocket(
        1,
        'Impuesto vehicular',
        'receipt_long',
        PocketKind.yearly,
        1940000,
        150000,
        DateTime(now.month <= 6 ? y : y + 1, 6, 30),
      ),
      pocket(2, 'Tiquetes', 'flight', PocketKind.goal, 900000, 900000),
      pocket(2, 'Hospedaje', 'hotel', PocketKind.goal, 1200000, 385000),
    ];
  }
}

Widget _app({
  required _Data data,
  required ThemeMode mode,
  required Locale locale,
  required Widget home,
  bool withShell = false,
}) {
  final settings = AppSettings.defaults()
    ..isOnboardingDone = true
    ..languageCode = locale.languageCode;

  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      if (withShell)
        StatefulShellRoute.indexedStack(
          builder: (_, __, shell) => HomeShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (_, __) => home)],
            ),
            for (final p in ['/b', '/c', '/d'])
              StatefulShellBranch(
                routes: [
                  GoRoute(path: p, builder: (_, __) => const SizedBox()),
                ],
              ),
          ],
        )
      else
        GoRoute(path: '/home', builder: (_, __) => home),
    ],
  );

  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(() => _FakeSettings(settings)),
      accountsProvider.overrideWith((ref) => Stream.value(data.accounts)),
      transactionsProvider.overrideWith(
        (ref) => Stream.value(data.transactions),
      ),
      categoriesProvider.overrideWith((ref) => Stream.value(data.categories)),
      budgetsProvider.overrideWith((ref) => Stream.value(data.budgets)),
      savingsGroupsProvider.overrideWith((ref) => Stream.value(data.groups)),
      pocketsProvider.overrideWith((ref) => Stream.value(data.pockets)),
      captureServiceProvider.overrideWithValue(_FakeCapture()),
    ],
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      locale: locale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    ),
  );
}

/// Datos inventados para las pantallas de movimientos automáticos.
class _FakeCapture extends CaptureService {
  static final _now = DateTime(2026, 11, 13, 18, 40);

  @override
  Future<bool> accessGranted() async => true;

  @override
  Future<Set<String>> selectedApps() async => {'ej.banco', 'ej.billetera'};

  @override
  Future<List<InstalledApp>> installedApps() async => const [
    InstalledApp(packageName: 'ej.banco', label: 'Banco Ejemplo'),
    InstalledApp(packageName: 'ej.billetera', label: 'Billetera Demo'),
    InstalledApp(packageName: 'ej.calendario', label: 'Calendario'),
    InstalledApp(packageName: 'ej.musica', label: 'Música'),
    InstalledApp(packageName: 'ej.notas', label: 'Notas'),
  ];

  @override
  Future<List<CapturedNotice>> notices() async => [
    CapturedNotice(
      id: '1',
      packageName: 'ej.banco',
      appLabel: 'Banco Ejemplo',
      title: 'Compra aprobada',
      text: 'Compraste \$45.000 en TIENDA EJEMPLO con tu tarjeta *1234.',
      postedAt: _now,
    ),
    CapturedNotice(
      id: '2',
      packageName: 'ej.billetera',
      appLabel: 'Billetera Demo',
      title: 'Te enviaron plata',
      text: 'Recibiste \$120.000 de ANA P.',
      postedAt: _now.subtract(const Duration(hours: 3)),
    ),
  ];
}

Future<void> _shoot(WidgetTester tester, Widget app, String name) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(app);
  // Deja correr los streams y las animaciones de entrada.
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('out/$name.png'),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await _loadFonts();
  });

  for (final (locale, mode, suffix) in [
    (const Locale('es'), ThemeMode.light, 'es_claro'),
    (const Locale('es'), ThemeMode.dark, 'es_oscuro'),
    (const Locale('en'), ThemeMode.light, 'en_claro'),
  ]) {
    testWidgets('inicio $suffix', (tester) async {
      Intl.defaultLocale = locale.languageCode;
      await _shoot(
        tester,
        _app(
          data: _Data(),
          mode: mode,
          locale: locale,
          home: const DashboardScreen(),
          withShell: true,
        ),
        'inicio_$suffix',
      );
    });

    for (final (name, screen) in [
      ('movimientos', const TransactionsScreen()),
      ('analiticas', const AnalyticsScreen()),
      ('cuentas', const AccountsScreen()),
      ('presupuestos', const BudgetsScreen()),
      ('ahorros', const SavingsScreen()),
      ('grupo', const GroupScreen(groupId: 1)),
      ('ajustes', const SettingsScreen()),
      ('auto', const AutoMovementsScreen()),
      ('auto_apps', const CaptureAppsScreen()),
      ('auto_avisos', const CapturedNoticesScreen()),
    ]) {
      testWidgets('$name $suffix', (tester) async {
        Intl.defaultLocale = locale.languageCode;
        await _shoot(
          tester,
          _app(data: _Data(), mode: mode, locale: locale, home: screen),
          '${name}_$suffix',
        );
      });
    }

    testWidgets('nuevo movimiento $suffix', (tester) async {
      Intl.defaultLocale = locale.languageCode;
      await _shoot(
        tester,
        _app(
          data: _Data(),
          mode: mode,
          locale: locale,
          home: const AddTransactionScreen(),
        ),
        'nuevo_$suffix',
      );
    });
  }
}
