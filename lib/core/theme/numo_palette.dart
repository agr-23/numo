import 'package:flutter/material.dart';

/// Colores del diseño "Nítido", con una versión clara y una oscura.
/// Se leen con `context.palette`.
///
/// Reglas del diseño:
/// - Una sola tinta ([ink]) para texto, íconos, botones y la tarjeta
///   protagonista. En modo oscuro la tinta es clara, así que la tarjeta
///   protagonista se invierte y queda clara sobre fondo oscuro.
/// - El color se reserva para significado: [income], [expense], [warning]
///   y [link] (enlaces y metas).
@immutable
class NumoPalette extends ThemeExtension<NumoPalette> {
  final Color background;
  final Color surface;

  /// Controles segmentados, teclas, chips sin seleccionar.
  final Color surfaceMuted;

  /// Círculos detrás de los íconos.
  final Color surfaceSubtle;
  final Color border;
  final Color borderStrong;

  /// Fondo de las barras de progreso.
  final Color track;

  final Color ink;

  /// Texto e íconos sobre [ink] (botones primarios, tarjeta protagonista).
  final Color onInk;
  final Color inkMuted;
  final Color inkHint;

  final Color income;
  final Color expense;
  final Color warning;
  final Color transfer;

  /// Ingresos y gastos dibujados sobre la tarjeta protagonista ([ink]).
  final Color onInkIncome;
  final Color onInkExpense;

  final Color link;
  final Color linkSoft;

  /// Botón de acción dentro de un SnackBar (que tiene fondo [ink]).
  final Color snackAction;

  const NumoPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceSubtle,
    required this.border,
    required this.borderStrong,
    required this.track,
    required this.ink,
    required this.onInk,
    required this.inkMuted,
    required this.inkHint,
    required this.income,
    required this.expense,
    required this.warning,
    required this.transfer,
    required this.onInkIncome,
    required this.onInkExpense,
    required this.link,
    required this.linkSoft,
    required this.snackAction,
  });

  static const light = NumoPalette(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF3F3F5),
    surfaceSubtle: Color(0xFFF5F5F7),
    border: Color(0xFFEDEDF0),
    borderStrong: Color(0xFFE3E3E8),
    track: Color(0xFFF1F1F4),
    ink: Color(0xFF111114),
    onInk: Color(0xFFFFFFFF),
    inkMuted: Color(0xFF6B6B76),
    inkHint: Color(0xFF8A8A94),
    income: Color(0xFF0B7A50),
    expense: Color(0xFFC8323F),
    warning: Color(0xFFB45309),
    transfer: Color(0xFF2F5FD0),
    onInkIncome: Color(0xFF5EE6B0),
    onInkExpense: Color(0xFFFF9AA5),
    link: Color(0xFF4F3CC9),
    linkSoft: Color(0xFFF2F0FC),
    snackAction: Color(0xFFB9AEFF),
  );

  static const dark = NumoPalette(
    background: Color(0xFF0E0E11),
    surface: Color(0xFF17171B),
    surfaceMuted: Color(0xFF222227),
    surfaceSubtle: Color(0xFF1F1F24),
    border: Color(0xFF26262C),
    borderStrong: Color(0xFF32323A),
    track: Color(0xFF2A2A31),
    ink: Color(0xFFF4F4F6),
    onInk: Color(0xFF111114),
    inkMuted: Color(0xFFA3A3AE),
    inkHint: Color(0xFF7C7C88),
    income: Color(0xFF3DD68C),
    expense: Color(0xFFFF6B78),
    warning: Color(0xFFF5A524),
    transfer: Color(0xFF7AA2FF),
    onInkIncome: Color(0xFF0B7A50),
    onInkExpense: Color(0xFFC8323F),
    link: Color(0xFFA99BFF),
    linkSoft: Color(0xFF26223F),
    snackAction: Color(0xFF4F3CC9),
  );

  @override
  NumoPalette copyWith() => this;

  @override
  NumoPalette lerp(ThemeExtension<NumoPalette>? other, double t) {
    if (other is! NumoPalette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return NumoPalette(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceMuted: l(surfaceMuted, other.surfaceMuted),
      surfaceSubtle: l(surfaceSubtle, other.surfaceSubtle),
      border: l(border, other.border),
      borderStrong: l(borderStrong, other.borderStrong),
      track: l(track, other.track),
      ink: l(ink, other.ink),
      onInk: l(onInk, other.onInk),
      inkMuted: l(inkMuted, other.inkMuted),
      inkHint: l(inkHint, other.inkHint),
      income: l(income, other.income),
      expense: l(expense, other.expense),
      warning: l(warning, other.warning),
      transfer: l(transfer, other.transfer),
      onInkIncome: l(onInkIncome, other.onInkIncome),
      onInkExpense: l(onInkExpense, other.onInkExpense),
      link: l(link, other.link),
      linkSoft: l(linkSoft, other.linkSoft),
      snackAction: l(snackAction, other.snackAction),
    );
  }
}

extension NumoPaletteContext on BuildContext {
  NumoPalette get palette =>
      Theme.of(this).extension<NumoPalette>() ?? NumoPalette.light;
}
