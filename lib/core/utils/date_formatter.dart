import 'package:intl/intl.dart';

/// Helpers de fecha en español para Numo.
class DateFormatter {
  DateFormatter._();

  static const String _locale = 'es';

  /// "Miércoles 10 de junio"
  static String longDay(DateTime date) {
    return toBeginningOfSentenceCase(
          DateFormat("EEEE d 'de' MMMM", _locale).format(date),
        ) ??
        '';
  }

  /// Encabezado de grupo en la lista: "Hoy" / "Ayer" / "Lun 9 de junio".
  static String groupHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Ayer';
    return toBeginningOfSentenceCase(
          DateFormat("EEE d 'de' MMMM", _locale).format(date),
        ) ??
        '';
  }

  /// "Junio 2026"
  static String monthYear(DateTime date) {
    return toBeginningOfSentenceCase(
          DateFormat('MMMM y', _locale).format(date),
        ) ??
        '';
  }

  /// "10 jun" — etiquetas cortas (ej. ejes de gráficos).
  static String shortDay(DateTime date) {
    return DateFormat('d MMM', _locale).format(date);
  }

  /// "jun" — etiqueta de mes corta.
  static String shortMonth(DateTime date) {
    return DateFormat('MMM', _locale).format(date);
  }

  /// Saludo dinámico según la hora.
  static String greeting(DateTime now) {
    final h = now.hour;
    if (h < 12) return 'Buenos días, ☀️';
    if (h < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }
}
