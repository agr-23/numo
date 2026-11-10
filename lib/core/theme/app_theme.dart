import 'package:flutter/material.dart';

import '../constants/dimens.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Construye los [ThemeData] claro y oscuro de Numo.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        textPrimary: AppColors.lightTextPrimary,
        textSecondary: AppColors.lightTextSecondary,
        textHint: AppColors.lightTextHint,
        border: AppColors.lightBorder,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        textPrimary: AppColors.darkTextPrimary,
        textSecondary: AppColors.darkTextSecondary,
        textHint: AppColors.darkTextHint,
        border: AppColors.darkBorder,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
    required Color textHint,
    required Color border,
  }) {
    final isDark = brightness == Brightness.dark;

    // Material usa `primary` para etiquetas de campos enfocados, TextButton,
    // cursor, selectores de fecha, etc. El morado de marca es invisible sobre
    // fondo oscuro, así que en modo oscuro `primary` pasa a ser el dorado.
    // Los bloques de marca (tarjetas, botones) usan AppColors.primary directo.
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.accent : AppColors.primary,
      onPrimary: isDark ? AppColors.primary : Colors.white,
      secondary: AppColors.accent,
      onSecondary: AppColors.primary,
      error: AppColors.expense,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: border,
      outlineVariant: border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      textTheme: AppTextStyles.themeFor(textPrimary, textSecondary),
      dividerColor: border,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          side: BorderSide(color: border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: AppTextStyles.bodyLarge.copyWith(color: textHint),
        labelStyle: AppTextStyles.bodyLarge.copyWith(color: textSecondary),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          final Color color;
          if (states.contains(WidgetState.error)) {
            color = AppColors.expense;
          } else if (states.contains(WidgetState.focused)) {
            color = isDark ? AppColors.accent : textPrimary;
          } else {
            color = textSecondary;
          }
          return AppTextStyles.bodyLarge.copyWith(color: color);
        }),
        helperStyle: AppTextStyles.bodySmall.copyWith(color: textSecondary),
        prefixStyle: AppTextStyles.bodyLarge.copyWith(color: textSecondary),
        suffixStyle: AppTextStyles.bodyLarge.copyWith(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.cardPadding,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.chipRadius),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.chipRadius),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.chipRadius),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.accent,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        contentTextStyle: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.chipRadius),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
