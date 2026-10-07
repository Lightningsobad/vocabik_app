package com.snapsofts.vocabik.yt

import android.app.UiModeManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val themeChannelName = "com.snapsofts.vocabik/theme"

    override fun onCreate(savedInstanceState: Bundle?) {
        syncNightModeFromPrefs()
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, themeChannelName).setMethodCallHandler { call, result ->
            if (call.method == "setThemeMode") {
                val mode = call.arguments as? String
                applyNightMode(mode)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun syncNightModeFromPrefs() {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val mode = prefs.getString("flutter.theme_mode", null)
        applyNightMode(mode)
    }

    private fun applyNightMode(mode: String?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val uiModeManager = getSystemService(Context.UI_MODE_SERVICE) as? UiModeManager
            when (mode) {
                "dark" -> uiModeManager?.setApplicationNightMode(UiModeManager.MODE_NIGHT_YES)
                "light" -> uiModeManager?.setApplicationNightMode(UiModeManager.MODE_NIGHT_NO)
                else -> uiModeManager?.setApplicationNightMode(UiModeManager.MODE_NIGHT_CUSTOM)
            }
        }
    }
}
