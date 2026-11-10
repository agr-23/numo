import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/add_transaction/add_transaction_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/accounts/account_detail_screen.dart';
import '../../presentation/screens/accounts/accounts_screen.dart';
import '../../presentation/screens/analytics/analytics_screen.dart';
import '../../presentation/screens/budgets/add_budget_screen.dart';
import '../../presentation/screens/budgets/budgets_screen.dart';
import '../../presentation/screens/home/home_shell.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/savings/group_screen.dart';
import '../../presentation/screens/savings/savings_screen.dart';
import '../../presentation/screens/settings/categories_screen.dart';
import '../../presentation/screens/settings/create_pin_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/transactions/transactions_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Router principal de Numo.
final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/dashboard',
              builder: (_, __) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/transactions',
              builder: (_, __) => const TransactionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/analytics',
              builder: (_, __) => const AnalyticsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/accounts',
              builder: (_, __) => const AccountsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Rutas push sobre el shell
    GoRoute(
      path: '/add-transaction',
      parentNavigatorKey: _rootKey,
      builder: (_, state) => AddTransactionScreen(
        startAsIncome: state.uri.queryParameters['type'] == 'income',
      ),
    ),
    GoRoute(
      path: '/add-transfer',
      parentNavigatorKey: _rootKey,
      builder: (_, state) => AddTransactionScreen(
        startAsTransfer: true,
        initialToAccountId:
            int.tryParse(state.uri.queryParameters['to'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/edit-transaction/:id',
      parentNavigatorKey: _rootKey,
      builder: (_, state) => AddTransactionScreen(
        editId: int.tryParse(state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/budgets',
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const BudgetsScreen(),
    ),
    GoRoute(
      path: '/add-budget',
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const AddBudgetScreen(),
    ),
    GoRoute(
      path: '/savings',
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const SavingsScreen(),
    ),
    GoRoute(
      path: '/savings-group/:id',
      parentNavigatorKey: _rootKey,
      builder: (_, state) => GroupScreen(
        groupId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
      ),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/categories',
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/create-pin',
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const CreatePinScreen(),
    ),
    GoRoute(
      path: '/account-detail/:id',
      parentNavigatorKey: _rootKey,
      builder: (_, state) => AccountDetailScreen(
        accountId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
      ),
    ),
  ],
);
