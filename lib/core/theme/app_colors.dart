import 'package:flutter/material.dart';

/// Tokens de color de Numo. Ver brief "Tokens de diseño".
class AppColors {
  AppColors._();

  // Marca / compartidos entre temas
  static const Color primary = Color(0xFF1A1033);
  static const Color accent = Color(0xFFF0B429);
  static const Color income = Color(0xFF1DD18F);
  static const Color expense = Color(0xFFF6465D);
  static const Color transfer = Color(0xFF3B82F6);
  static const Color warning = Color(0xFFF59E0B);

  // Tema claro
  static const Color lightBackground = Color(0xFFF5F5F0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1033);
  static const Color lightTextSecondary = Color(0xFF6B6B80);
  static const Color lightTextHint = Color(0xFFA0A0B0);
  static const Color lightBorder = Color(0xFFEBEBEB);

  // Tema oscuro
  static const Color darkBackground = Color(0xFF0D0D1A);
  static const Color darkSurface = Color(0xFF1C1C2E);
  static const Color darkTextPrimary = Color(0xFFF0F0F0);
  static const Color darkTextSecondary = Color(0xFF8888A0);
  static const Color darkTextHint = Color(0xFF6B6B80);
  static const Color darkBorder = Color(0xFF2A2A40);

  /// Colores predefinidos para cuentas / metas (12 opciones).
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
