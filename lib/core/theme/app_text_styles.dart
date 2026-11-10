import 'package:flutter/material.dart';

/// Tipografía del diseño Nítido: Inter (incluida en assets/fonts), con
/// números de ancho fijo para que las cifras queden alineadas en columnas.
/// Los colores salen del tema; aquí solo van tamaño, peso y espaciado.
class AppTextStyles {
  AppTextStyles._();

  static const String family = 'Inter';
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static TextStyle _s(
    double size,
    FontWeight weight, {
    double letterSpacing = 0,
    double? height,
  }) => TextStyle(
    fontFamily: family,
    fontSize: size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    height: height,
    fontFeatures: _tabular,
  );

  /// Montos protagonistas ($4.820.500).
  static TextStyle get amountHero =>
      _s(40, FontWeight.w600, letterSpacing: -1.5, height: 1.1);

  /// Monto que se está escribiendo en el teclado.
  static TextStyle get amountInput =>
      _s(44, FontWeight.w600, letterSpacing: -1.5, height: 1.1);

  static TextStyle get headline => _s(22, FontWeight.w600, letterSpacing: -0.4);

  /// Título de pantalla y de hoja inferior.
  static TextStyle get title => _s(16, FontWeight.w600);

  /// Encabezado de sección ("Presupuestos", "Movimientos").
  static TextStyle get section => _s(15, FontWeight.w600);

  static TextStyle get body => _s(15, FontWeight.w400);
  static TextStyle get bodyMedium => _s(14, FontWeight.w400);

  /// Texto de una fila de lista (título del movimiento).
  static TextStyle get rowTitle => _s(14, FontWeight.w500);

  /// Montos de una fila.
  static TextStyle get rowAmount => _s(14, FontWeight.w600);

  static TextStyle get caption => _s(12, FontWeight.w400);
  static TextStyle get captionStrong => _s(12, FontWeight.w500);
  static TextStyle get button => _s(16, FontWeight.w600);
  static TextStyle get keypadDigit => _s(22, FontWeight.w500);

  /// Etiqueta de control (botón, chip, segmento) en el tamaño dado.
  static TextStyle labelFrom(double size) => _s(size, FontWeight.w600);

  /// [TextTheme] del tema con los colores de tinta.
  static TextTheme themeFor(Color ink, Color muted) {
    return TextTheme(
      displayLarge: amountHero.copyWith(color: ink),
      headlineSmall: headline.copyWith(color: ink),
      titleLarge: headline.copyWith(color: ink),
      titleMedium: section.copyWith(color: ink),
      titleSmall: rowTitle.copyWith(color: ink),
      bodyLarge: body.copyWith(color: ink),
      bodyMedium: bodyMedium.copyWith(color: ink),
      bodySmall: caption.copyWith(color: muted),
      labelLarge: _s(14, FontWeight.w600).copyWith(color: ink),
      labelMedium: captionStrong.copyWith(color: ink),
      labelSmall: _s(11, FontWeight.w500).copyWith(color: muted),
    );
  }
}
