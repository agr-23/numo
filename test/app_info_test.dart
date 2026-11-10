import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:numo/core/constants/app_info.dart';

void main() {
  test('kAppVersion coincide con pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(
      r'^version:\s*([\d.]+)\+',
      multiLine: true,
    ).firstMatch(pubspec);
    expect(match?.group(1), kAppVersion);
  });
}
