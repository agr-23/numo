import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../constants/currencies.dart';

/// Reglas de escritura de montos para una moneda: separador de miles,
/// separador decimal y cantidad de decimales. Ej. COP → "1.250.000",
/// USD → "1,250.50".
class AmountInput {
  final int decimals;
  final String groupSep;
  final String decimalSep;

  const AmountInput._(this.decimals, this.groupSep, this.decimalSep);

  /// Máximo de dígitos enteros (evita desbordes y pérdida de precisión).
  static const int _maxIntDigits = 13;

  factory AmountInput.of(String currencyCode) {
    final option = currencyByCode(currencyCode);
    final symbols = NumberFormat.decimalPattern(option.locale).symbols;
    return AmountInput._(
      option.decimals,
      symbols.GROUP_SEP,
      symbols.DECIMAL_SEP,
    );
  }

  /// Formatter para [TextField] que agrega separadores mientras se escribe.
  TextInputFormatter get formatter => _AmountFormatter(this);

  /// Convierte el texto mostrado a número. Texto vacío o inválido → 0.
  double parse(String text) {
    final normalized = text
        .replaceAll(groupSep, '')
        .replaceAll(decimalSep, '.')
        .replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  /// Formatea un valor para precargarlo en un campo (sin símbolo).
  /// 0 → '' para que se vea el hint.
  String format(double value) {
    if (value == 0) return '';
    final fixed = value.abs().toStringAsFixed(decimals);
    final parts = fixed.split('.');
    var dec = parts.length > 1 ? parts[1] : '';
    dec = dec.replaceFirst(RegExp(r'0+$'), '');
    return _compose(parts[0], dec.isEmpty ? null : dec);
  }

  /// Une parte entera (solo dígitos) y decimal con los separadores.
  String _compose(String intDigits, String? decDigits) {
    final buf = StringBuffer();
    for (var i = 0; i < intDigits.length; i++) {
      if (i > 0 && (intDigits.length - i) % 3 == 0) buf.write(groupSep);
      buf.write(intDigits[i]);
    }
    if (decDigits != null) buf.write('$decimalSep$decDigits');
    return buf.toString();
  }

  /// Agrupa los dígitos de un monto en formato crudo "1250.5" (punto
  /// decimal), como el que arma el teclado de AddTransactionScreen.
  String groupRaw(String raw) {
    if (raw.isEmpty) return '0';
    final parts = raw.split('.');
    final intDigits = parts[0].isEmpty ? '0' : parts[0];
    return _compose(intDigits, parts.length > 1 ? parts[1] : null);
  }
}

class _AmountFormatter extends TextInputFormatter {
  final AmountInput rules;
  _AmountFormatter(this.rules);

  static const _decimalMark = '\u0000';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    var cursor = newValue.selection.end.clamp(0, text.length);
    final allowDecimals = rules.decimals > 0;

    // Borrar un separador de miles no tendría efecto (se vuelve a poner);
    // en ese caso se borra también el dígito anterior.
    if (text.length == oldValue.text.length - 1 &&
        cursor > 0 &&
        cursor < oldValue.text.length &&
        oldValue.text[cursor] == rules.groupSep &&
        oldValue.text.replaceRange(cursor, cursor + 1, '') == text) {
      text = text.replaceRange(cursor - 1, cursor, '');
      cursor--;
    }

    // El teclado puede ofrecer solo '.' o solo ','. Si el usuario acaba de
    // teclear cualquiera de los dos y aún no hay decimales, es el decimal.
    if (allowDecimals &&
        cursor > 0 &&
        text.length == oldValue.text.length + 1 &&
        !oldValue.text.contains(rules.decimalSep)) {
      final typed = text[cursor - 1];
      if (typed == '.' || typed == ',') {
        text = text.replaceRange(cursor - 1, cursor, _decimalMark);
      }
    }

    // Posición del decimal: el recién tecleado o el que ya existía.
    var decAt = text.indexOf(_decimalMark);
    if (decAt < 0 && allowDecimals) decAt = text.indexOf(rules.decimalSep);

    // Cuántos caracteres significativos (dígitos/decimal) hay antes del
    // cursor, para reubicarlo tras reformatear.
    var significantBefore = 0;
    for (var i = 0; i < cursor && i < text.length; i++) {
      if (_isDigit(text[i]) || i == decAt) significantBefore++;
    }

    final intBuf = StringBuffer();
    final decBuf = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (!_isDigit(text[i])) continue;
      if (decAt >= 0 && i > decAt) {
        decBuf.write(text[i]);
      } else {
        intBuf.write(text[i]);
      }
    }

    var intDigits = intBuf.toString().replaceFirst(RegExp(r'^0+(?=\d)'), '');
    if (intDigits.length > AmountInput._maxIntDigits) {
      return oldValue;
    }
    var decDigits = decBuf.toString();
    if (decDigits.length > rules.decimals) {
      decDigits = decDigits.substring(0, rules.decimals);
    }
    final hasDecimal = decAt >= 0;
    if (hasDecimal && intDigits.isEmpty) intDigits = '0';

    if (intDigits.isEmpty && !hasDecimal) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final formatted = rules._compose(intDigits, hasDecimal ? decDigits : null);

    // Reubica el cursor tras el mismo número de caracteres significativos.
    var offset = 0;
    var seen = 0;
    while (offset < formatted.length && seen < significantBefore) {
      final ch = formatted[offset];
      if (_isDigit(ch) || ch == rules.decimalSep) seen++;
      offset++;
    }
    if (significantBefore >= _countSignificant(formatted)) {
      offset = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  int _countSignificant(String s) {
    var n = 0;
    for (var i = 0; i < s.length; i++) {
      if (_isDigit(s[i]) || s[i] == rules.decimalSep) n++;
    }
    return n;
  }

  static bool _isDigit(String ch) {
    final c = ch.codeUnitAt(0);
    return c >= 48 && c <= 57;
  }
}
