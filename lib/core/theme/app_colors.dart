import 'package:flutter/material.dart';

/// Colores que NO dependen del tema: la paleta para categorías, cuentas y
/// metas, y la conversión hex ↔ [Color]. Los colores de interfaz (tinta,
/// fondos, ingresos/gastos…) están en `NumoPalette` (`context.palette`).
class AppColors {
  AppColors._();

  /// Colores que el usuario puede elegir para cuentas, metas y categorías
  /// propias (12 opciones). Se guardan como hex en Isar.
  static const List<Color> palette = [
    Color(0xFFF0B429),
    Color(0xFF1DD18F),
    Color(0xFFF6465D),
    Color(0xFF3B82F6),
    Color(0xFFA855F7),
    Color(0xFFEC4899),
    Color(0xFF4ECDC4),
    Color(0xFFFF6B35),
    Color(0xFF10B981),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFF6B7280),
  ];

  /// Convierte un hex tipo "#RRGGBB" o "RRGGBB" a [Color].
  static Color fromHex(String hex) {
    var cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    return Color(int.parse(cleaned, radix: 16));
  }

  /// Convierte un [Color] a hex "#RRGGBB".
  static String toHex(Color color) {
    final value = color.toARGB32() & 0xFFFFFF;
    return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
