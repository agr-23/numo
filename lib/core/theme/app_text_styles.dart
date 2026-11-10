import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Estilos tipográficos de Numo (Poppins). Los colores se resuelven
/// vía el [TextTheme] del [ThemeData]; aquí solo se fijan peso/tamaño.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get display =>
      GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 32);

  static TextStyle get titleLarge =>
      GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 22);

  static TextStyle get titleMedium =>
      GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18);

  static TextStyle get bodyLarge =>
      GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16);

  static TextStyle get bodySmall =>
      GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 13);

  static TextStyle get amountPositive => GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: AppColors.income,
      );

  static TextStyle get amountNegative => GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: AppColors.expense,
      );

  static TextStyle get keypadDigit =>
      GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 26);

  /// Construye el [TextTheme] aplicando un color base a los estilos.
  static TextTheme themeFor(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: display.copyWith(color: primary),
      titleLarge: titleLarge.copyWith(color: primary),
      titleMedium: titleMedium.copyWith(color: primary),
      bodyLarge: bodyLarge.copyWith(color: primary),
      bodyMedium: bodyLarge.copyWith(color: primary),
      bodySmall: bodySmall.copyWith(color: secondary),
      labelLarge: titleMedium.copyWith(color: primary),
    );
  }
}
