import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numo/core/theme/app_colors.dart';

void main() {
  group('AppColors hex helpers', () {
    test('fromHex / toHex round-trip', () {
      const hex = '#F0B429';
      final color = AppColors.fromHex(hex);
      expect(AppColors.toHex(color), hex);
    });

    test('fromHex accepts value without #', () {
      expect(AppColors.fromHex('1A1033'), const Color(0xFF1A1033));
    });
  });
}
