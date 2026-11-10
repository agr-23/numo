import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Hashing del PIN de acceso con SHA-256.
class PinHasher {
  PinHasher._();

  static String hash(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }

  static bool verify(String pin, String? storedHash) {
    if (storedHash == null) return false;
    return hash(pin) == storedHash;
  }
}
