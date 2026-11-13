import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:numo/core/utils/sensitive_filter.dart';

void main() {
  group('SensitiveFilter', () {
    test('detecta códigos y claves, con o sin tildes', () {
      for (final text in [
        'Tu código de verificación es 123456',
        'Tu codigo es 482913',
        'Clave dinámica: 5521',
        'Your OTP is 9911',
        'Nunca compartas tu contraseña',
        'Use this verification code: 445566',
        'Tu PIN fue cambiado',
        'Token: 777888',
      ]) {
        expect(SensitiveFilter.isSensitive(text), isTrue, reason: text);
      }
    });

    test('deja pasar avisos de compras y transferencias', () {
      for (final text in [
        'Compraste \$45.000 en TIENDA EJEMPLO con tu tarjeta *1234',
        'Recibiste una transferencia de \$120.000',
        'Pagaste \$32.500 en PINTURAS DEL NORTE',
        'Transferiste \$50.000 a la cuenta *9876',
      ]) {
        expect(SensitiveFilter.isSensitive(text), isFalse, reason: text);
      }
    });

    test('el patrón es idéntico al del servicio nativo en Kotlin', () {
      final kotlin = File(
        'android/app/src/main/kotlin/com/numo/numo/capture/SensitiveFilter.kt',
      ).readAsStringSync();
      final match = RegExp(
        r'PATTERN\s*=\s*"""(.*?)"""',
        dotAll: true,
      ).firstMatch(kotlin);
      expect(match, isNotNull, reason: 'No se encontró PATTERN en Kotlin');
      expect(match!.group(1), kSensitivePattern);
    });
  });
}
