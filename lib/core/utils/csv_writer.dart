/// Escritura de CSV (RFC 4180) sin dependencias.
///
/// - Los campos con coma, comillas o saltos de línea van entre comillas, y
///   las comillas internas se duplican.
/// - Los textos que empiezan con `=`, `+`, `-`, `@`, tabulador o retorno
///   llevan un apóstrofo delante, para que Excel o Sheets no los ejecuten
///   como fórmulas (inyección de CSV). Los números no se tocan.
/// - Filas separadas por CRLF y BOM UTF-8 al inicio, para que Excel lea bien
///   las tildes.
abstract final class CsvWriter {
  static const String bom = '﻿';

  static String encode(List<List<Object?>> rows) {
    final buffer = StringBuffer(bom);
    for (final row in rows) {
      buffer
        ..writeAll(row.map(_field), ',')
        ..write('\r\n');
    }
    return buffer.toString();
  }

  static String _field(Object? value) {
    if (value == null) return '';
    if (value is num) return value.toString();
    var text = value.toString();
    if (text.isNotEmpty && '=+-@\t\r'.contains(text[0])) text = "'$text";
    final needsQuotes =
        text.contains(',') ||
        text.contains('"') ||
        text.contains('\n') ||
        text.contains('\r');
    return needsQuotes ? '"${text.replaceAll('"', '""')}"' : text;
  }
}
