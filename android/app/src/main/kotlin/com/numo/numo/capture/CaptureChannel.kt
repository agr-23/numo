package com.numo.numo.capture

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** Puente con Dart (lib/data/services/capture_service.dart). */
class CaptureChannel(private val context: Context, messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, NAME)
    private val main = Handler(Looper.getMainLooper())

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "accessGranted" -> result.success(accessGranted())
            "openAccessSettings" -> {
                context.startActivity(
                    Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
                )
                result.success(null)
            }
            "installedApps" -> Thread {
                val apps = installedApps()
                main.post { result.success(apps) }
            }.start()
            "selectedApps" -> result.success(CaptureStore.selectedApps(context).toList())
            "setSelectedApps" -> {
                CaptureStore.setSelectedApps(context, call.arguments<List<String>>().orEmpty())
                result.success(null)
            }
            "notices" -> result.success(CaptureStore.notices(context))
            "delete" -> {
                CaptureStore.delete(context, call.arguments<String>().orEmpty())
                result.success(null)
            }
            "clear" -> {
                CaptureStore.clear(context)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun accessGranted(): Boolean {
        val enabled = Settings.Secure.getString(
            context.contentResolver,
            "enabled_notification_listeners",
        ) ?: return false
        val me = ComponentName(context, NumoNotificationListener::class.java)
        return enabled.split(':').mapNotNull { ComponentName.unflattenFromString(it) }.contains(me)
    }

    /** Apps con ícono en el lanzador, para que el usuario elija cuáles leer. */
    @Suppress("DEPRECATION")
    private fun installedApps(): List<Map<String, String>> {
        val pm = context.packageManager
        val launcher = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        return pm.queryIntentActivities(launcher, 0)
            .map { it.activityInfo.packageName to it.loadLabel(pm).toString() }
            .filter { it.first != context.packageName }
            .distinctBy { it.first }
            .sortedBy { it.second.lowercase() }
            .map { mapOf("package" to it.first, "label" to it.second) }
    }

    companion object {
        const val NAME = "com.numo.numo/capture"
    }
}
