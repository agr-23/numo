import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'core/l10n/l10n.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';

/// Raíz de la app.
class NumoApp extends ConsumerWidget {
  const NumoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'Numo',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (device, supported) {
        // Idioma elegido > idioma del teléfono si lo soportamos > español.
        final wanted = locale ?? device;
        final match = supported.firstWhere(
          (l) => l.languageCode == wanted?.languageCode,
          orElse: () => kSupportedLocales.first,
        );
        // DateFormat sin locale explícito usa este valor.
        Intl.defaultLocale = match.languageCode;
        return match;
      },
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
