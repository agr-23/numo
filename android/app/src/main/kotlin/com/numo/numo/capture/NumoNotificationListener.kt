package com.numo.numo.capture

import android.app.Notification
import android.content.pm.PackageManager
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification

/**
 * Recibe las notificaciones del teléfono cuando el usuario da el acceso en
 * los ajustes de Android.
 *
 * Solo procesa las apps que el usuario eligió en Numo. Todas las demás se
 * ignoran sin leer su contenido ni guardar nada. Los avisos con códigos de
 * verificación o claves se descartan. No se escribe nada en el log.
 */
class NumoNotificationListener : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val pkg = sbn.packageName
        if (pkg == packageName) return
        if (pkg !in CaptureStore.selectedApps(this)) return

        val n = sbn.notification
        if (sbn.isOngoing || n.flags and Notification.FLAG_GROUP_SUMMARY != 0) return

        val extras = n.extras
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString().orEmpty()
        val lines = extras.getCharSequenceArray(Notification.EXTRA_TEXT_LINES)
        val text = (
            extras.getCharSequence(Notification.EXTRA_BIG_TEXT)
                ?: lines?.joinToString("\n")
                ?: extras.getCharSequence(Notification.EXTRA_TEXT)
            )?.toString().orEmpty()

        if (title.isBlank() && text.isBlank()) return
        if (SensitiveFilter.isSensitive("$title\n$text")) return

        CaptureStore.add(this, pkg, labelOf(pkg), title.trim(), text.trim(), sbn.postTime)
    }

    private fun labelOf(pkg: String): String = try {
        packageManager.getApplicationLabel(packageManager.getApplicationInfo(pkg, 0)).toString()
    } catch (_: PackageManager.NameNotFoundException) {
        pkg
    }
}
