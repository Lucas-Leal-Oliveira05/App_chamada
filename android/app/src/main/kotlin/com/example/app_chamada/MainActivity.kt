package com.example.app_chamada

import android.os.SystemClock
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "uptime_channel")
            .setMethodCallHandler { call, result ->
                if (call.method == "getUptime") {
                    val uptime = SystemClock.elapsedRealtime()
                    result.success(uptime)
                } else {
                    result.notImplemented()
                }
            }
    }
}
