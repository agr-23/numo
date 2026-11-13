package com.numo.numo.capture

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/**
 * Guarda los avisos capturados y las apps elegidas.
 *
 * Los archivos van en noBackupFilesDir: almacenamiento privado de la app que
 * Android excluye de la copia de seguridad en la nube. Los avisos se borran
 * solos a los [RETENTION_MS] y nunca hay más de [MAX_ENTRIES].
 */
object CaptureStore {
    private const val NOTICES = "capture_notices.json"
    private const val APPS = "capture_apps.json"
    private const val RETENTION_MS = 7L * 24 * 60 * 60 * 1000
    private const val MAX_ENTRIES = 200
    private const val DUPLICATE_WINDOW_MS = 5L * 60 * 1000

    private val lock = Any()

    private fun file(context: Context, name: String) = File(context.noBackupFilesDir, name)

    private fun readArray(context: Context, name: String): JSONArray {
        val f = file(context, name)
        if (!f.exists()) return JSONArray()
        return try {
            JSONArray(f.readText())
        } catch (_: Exception) {
            JSONArray()
        }
    }

    private fun writeArray(context: Context, name: String, array: JSONArray) {
        val f = file(context, name)
        val tmp = File(f.parentFile, "$name.tmp")
        tmp.writeText(array.toString())
        tmp.renameTo(f)
    }

    // --- Apps elegidas -------------------------------------------------

    fun selectedApps(context: Context): Set<String> = synchronized(lock) {
        val array = readArray(context, APPS)
        (0 until array.length()).map { array.getString(it) }.toSet()
    }

    fun setSelectedApps(context: Context, packages: Collection<String>) = synchronized(lock) {
        writeArray(context, APPS, JSONArray(packages.distinct()))
    }

    // --- Avisos ----------------------------------------------------------

    private fun pruned(array: JSONArray, now: Long): List<JSONObject> =
        (0 until array.length())
            .map { array.getJSONObject(it) }
            .filter { now - it.optLong("postedAt") < RETENTION_MS }
            .takeLast(MAX_ENTRIES)

    fun add(context: Context, pkg: String, appLabel: String, title: String, text: String, postedAt: Long) =
        synchronized(lock) {
            val now = System.currentTimeMillis()
            val entries = pruned(readArray(context, NOTICES), now).toMutableList()
            // Algunas apps actualizan la misma notificación varias veces.
            val repeated = entries.any {
                it.optString("pkg") == pkg && it.optString("title") == title &&
                    it.optString("text") == text &&
                    postedAt - it.optLong("postedAt") < DUPLICATE_WINDOW_MS
            }
            if (repeated) return@synchronized
            entries += JSONObject()
                .put("id", "$postedAt-${pkg.hashCode()}-${text.hashCode()}")
                .put("pkg", pkg)
                .put("app", appLabel)
                .put("title", title)
                .put("text", text)
                .put("postedAt", postedAt)
            writeArray(context, NOTICES, JSONArray(entries.takeLast(MAX_ENTRIES)))
        }

    fun notices(context: Context): List<Map<String, Any>> = synchronized(lock) {
        val entries = pruned(readArray(context, NOTICES), System.currentTimeMillis())
        writeArray(context, NOTICES, JSONArray(entries))
        entries.map { o ->
            mapOf(
                "id" to o.optString("id"),
                "pkg" to o.optString("pkg"),
                "app" to o.optString("app"),
                "title" to o.optString("title"),
                "text" to o.optString("text"),
                "postedAt" to o.optLong("postedAt"),
            )
        }
    }

    fun delete(context: Context, id: String) = synchronized(lock) {
        val entries = pruned(readArray(context, NOTICES), System.currentTimeMillis())
        writeArray(context, NOTICES, JSONArray(entries.filter { it.optString("id") != id }))
    }

    fun clear(context: Context) = synchronized(lock) {
        file(context, NOTICES).delete()
    }
}
