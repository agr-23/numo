package com.numo.numo.capture

import java.text.Normalizer

/**
 * Detecta avisos con códigos de verificación o claves para descartarlos
 * antes de guardarlos.
 *
 * El patrón debe ser idéntico a `kSensitivePattern` en
 * lib/core/utils/sensitive_filter.dart; una prueba en Dart lo verifica.
 */
object SensitiveFilter {
    const val PATTERN =
        """\b(codigo|clave|otp|contrasena|password|passcode|token|pin|verification code|security code)\b"""

    private val regex = Regex(PATTERN)
    private val marks = Regex("\\p{Mn}+")

    fun isSensitive(text: String): Boolean {
        val plain = marks.replace(Normalizer.normalize(text, Normalizer.Form.NFD), "")
        return regex.containsMatchIn(plain.lowercase())
    }
}
