import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numo/core/utils/amount_input.dart';
import 'package:numo/data/models/account.dart';

/// Simula teclear [chars] uno a uno al final del campo.
String typeChars(AmountInput rules, String chars) {
  var value = TextEditingValue.empty;
  for (final ch in chars.split('')) {
    final text = value.text + ch;
    final next = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    value = rules.formatter.formatEditUpdate(value, next);
  }
  return value.text;
}

/// Simula un backspace con el cursor al final o en [cursor].
TextEditingValue backspace(AmountInput rules, String text, {int? cursor}) {
  final at = cursor ?? text.length;
  final old = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: at),
  );
  final nextText = text.replaceRange(at - 1, at, '');
  final next = TextEditingValue(
    text: nextText,
    selection: TextSelection.collapsed(offset: at - 1),
  );
  return rules.formatter.formatEditUpdate(old, next);
}

void main() {
  group('AmountInput COP (sin decimales, miles con punto)', () {
    final cop = AmountInput.of('COP');

    test('agrupa miles mientras se escribe', () {
      expect(typeChars(cop, '1250000'), '1.250.000');
      expect(typeChars(cop, '999'), '999');
      expect(typeChars(cop, '1000'), '1.000');
    });

    test('ignora separadores y ceros a la izquierda', () {
      expect(typeChars(cop, '0012.5'), '125');
      expect(typeChars(cop, ',5'), '5');
    });

    test('parse ↔ format', () {
      expect(cop.parse('1.250.000'), 1250000);
      expect(cop.parse(''), 0);
      expect(cop.format(1250000), '1.250.000');
      expect(cop.format(0), '');
    });

    test('borrar el punto de miles borra el dígito anterior', () {
      // "1.250" con el cursor justo después del punto → "250".
      final r = backspace(cop, '1.250', cursor: 2);
      expect(r.text, '250');
    });

    test('backspace al final reagrupa', () {
      expect(backspace(cop, '1.250').text, '125');
    });
  });

  group('AmountInput USD (2 decimales, miles con coma)', () {
    final usd = AmountInput.of('USD');

    test('decimal con punto', () {
      expect(typeChars(usd, '1250.5'), '1,250.5');
      expect(usd.parse('1,250.5'), 1250.5);
    });

    test('la coma tecleada también sirve como decimal', () {
      expect(typeChars(usd, '12,5'), '12.5');
    });

    test('limita a 2 decimales', () {
      expect(typeChars(usd, '3.14159'), '3.14');
    });

    test('decimal al inicio antepone 0', () {
      expect(typeChars(usd, '.5'), '0.5');
    });

    test('ya no convierte 12.50 en 1250 (bug anterior)', () {
      expect(usd.parse(typeChars(usd, '12.50')), 12.5);
    });
  });

  group('AmountInput EUR (2 decimales, decimal con coma)', () {
    final eur = AmountInput.of('EUR');

    test('el punto tecleado se vuelve coma decimal', () {
      final text = typeChars(eur, '1500.75');
      expect(text, '1.500,75');
      expect(eur.parse(text), 1500.75);
    });
  });

  group('groupRaw (teclado de AddTransactionScreen)', () {
    test('COP y USD', () {
      expect(AmountInput.of('COP').groupRaw('1250000'), '1.250.000');
      expect(AmountInput.of('USD').groupRaw('1250.5'), '1,250.5');
      expect(AmountInput.of('EUR').groupRaw('1250.5'), '1.250,5');
      expect(AmountInput.of('COP').groupRaw(''), '0');
    });
  });

  group('nextDayOfMonth', () {
    test('día aún por venir este mes', () {
      expect(
        nextDayOfMonth(20, from: DateTime(2026, 11, 9)),
        DateTime(2026, 11, 20),
      );
    });

    test('hoy cuenta como próxima fecha', () {
      expect(
        nextDayOfMonth(9, from: DateTime(2026, 11, 9, 18)),
        DateTime(2026, 11, 9),
      );
    });

    test('día ya pasado → mes siguiente', () {
      expect(
        nextDayOfMonth(5, from: DateTime(2026, 11, 9)),
        DateTime(2026, 12, 5),
      );
    });

    test('día 31 en mes corto usa el último día', () {
      expect(
        nextDayOfMonth(31, from: DateTime(2027, 2, 10)),
        DateTime(2027, 2, 28),
      );
    });

    test('cruza de año', () {
      expect(
        nextDayOfMonth(3, from: DateTime(2026, 12, 15)),
        DateTime(2027, 1, 3),
      );
    });
  });

  group('CreditCardX', () {
    Account card({double debt = 0, double? limit}) => Account()
      ..name = 'Visa'
      ..type = AccountType.credit
      ..balance = debt
      ..colorHex = '#000000'
      ..iconName = 'credit_card'
      ..createdAt = DateTime(2026)
      ..isActive = true
      ..creditLimit = limit;

    test('disponible = cupo − deuda', () {
      final c = card(debt: 300000, limit: 1000000);
      expect(c.available, 700000);
      expect(c.debt, 300000);
      expect(c.usage, closeTo(0.3, 1e-9));
    });

    test('sin cupo configurado no hay disponible', () {
      expect(card(debt: 5).available, isNull);
    });
  });
}
