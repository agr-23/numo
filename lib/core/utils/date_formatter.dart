import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

/// Helpers de fecha. Usan el idioma activo de la app (`Intl.defaultLocale`,
/// que fija `NumoApp` al resolver el idioma), así que salen en español o
/// inglés según corresponda.
class DateFormatter {
  DateFormatter._();

  static String _cap(String s) => toBeginningOfSentenceCase(s);

  /// "Lunes, 9 de noviembre" / "Monday, November 9"
  static String longDay(DateTime date) {
    return _cap(DateFormat.MMMMEEEEd().format(date));
  }

  /// Encabezado de grupo en la lista: "Hoy" / "Ayer" / "Lun, 9 nov".
  static String groupHeader(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return l10n.today;
    if (diff == 1) return l10n.yesterday;
    return _cap(DateFormat.MMMEd().format(date));
  }

  /// "Noviembre de 2026" / "November 2026"
  static String monthYear(DateTime date) {
    return _cap(DateFormat.yMMMM().format(date));
  }

  /// "10 nov" / "Nov 10": etiquetas cortas (ej. ejes de gráficos).
  static String shortDay(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  /// "nov" / "Nov": etiqueta de mes corta.
  static String shortMonth(DateTime date) {
    return DateFormat.MMM().format(date);
  }

  /// Saludo según la hora.
  static String greeting(DateTime now, AppLocalizations l10n) {
    final h = now.hour;
    if (h < 12) return l10n.greetingMorning;
    if (h < 19) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }
}
