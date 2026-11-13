import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:numo/core/theme/numo_brand.dart';
import 'package:numo/core/theme/numo_palette.dart';

String _hex(int argb) =>
    '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

void main() {
  test('la tinta de la marca es la tinta de la app', () {
    expect(NumoBrand.ink, NumoPalette.light.ink);
  });

  test('el punto es el verde de ingreso del modo oscuro', () {
    expect(NumoBrand.dot, NumoPalette.dark.income);
  });

  test('los colores de Android coinciden con NumoBrand', () {
    const res = 'android/app/src/main/res';
    final colors = File('$res/values/colors.xml').readAsStringSync();
    final icon = File(
      '$res/drawable/ic_launcher_foreground.xml',
    ).readAsStringSync();

    expect(colors, contains(_hex(NumoBrand.ink.toARGB32())));
    expect(icon, contains(_hex(NumoBrand.dot.toARGB32())));
    expect(icon, contains(_hex(NumoBrand.ring.toARGB32())));
  });
}
