/// Patrón de avisos con códigos de verificación o claves.
///
/// Debe ser idéntico a `SensitiveFilter.PATTERN` en
/// android/app/src/main/kotlin/com/numo/numo/capture/SensitiveFilter.kt,
/// que descarta esos avisos antes de guardarlos. Una prueba lo verifica.
const String kSensitivePattern =
    r'\b(codigo|clave|otp|contrasena|password|passcode|token|pin|verification code|security code)\b';

final RegExp _sensitive = RegExp(kSensitivePattern);

const Map<String, String> _plain = {
  'á': 'a',
  'é': 'e',
  'í': 'i',
  'ó': 'o',
  'ú': 'u',
  'ü': 'u',
  'ñ': 'n',
};

/// Segunda barrera en Dart: si un aviso sensible llegara a guardarse, Numo
/// lo borra al leerlo en vez de mostrarlo.
abstract final class SensitiveFilter {
  static String normalize(String text) {
    final lower = text.toLowerCase();
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final c = String.fromCharCode(rune);
      buffer.write(_plain[c] ?? c);
    }
    return buffer.toString();
  }

  static bool isSensitive(String text) => _sensitive.hasMatch(normalize(text));
}
