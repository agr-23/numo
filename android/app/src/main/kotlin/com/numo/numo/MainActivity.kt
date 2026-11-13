package com.numo.numo

import com.numo.numo.capture.CaptureChannel
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

// FlutterFragmentActivity es requerido por local_auth para mostrar el
// diálogo de biometría.
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        CaptureChannel(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
    }
}
