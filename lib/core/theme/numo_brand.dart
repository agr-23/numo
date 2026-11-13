import 'package:flutter/painting.dart';

/// Colores de la marca (dirección "Punto"). Solo se usan en el arranque y el
/// ícono. Dentro de la app, los colores salen de `NumoPalette`.
///
/// Deben coincidir con android/app/src/main/res/values/colors.xml y
/// drawable/ic_launcher_foreground.xml.
abstract final class NumoBrand {
  /// Fondo del ícono y del arranque, igual en modo claro y oscuro.
  static const Color ink = Color(0xFF111114);

  /// El anillo: la moneda.
  static const Color ring = Color(0xFFFFFFFF);

  /// El punto: saldo al día. Es el verde de ingreso del modo oscuro.
  static const Color dot = Color(0xFF3DD68C);
}
