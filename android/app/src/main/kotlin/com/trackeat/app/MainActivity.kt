package com.trackeat.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.trackeat.app/accessibility"
    private lateinit var accessibilityHelper: AccessibilityHelper

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        accessibilityHelper = AccessibilityHelper(context)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openAccessibilitySettings" -> {
                    accessibilityHelper.openAccessibilitySettings()
                    result.success(null)
                }
                "isVoiceAssistantEnabled" -> {
                    result.success(accessibilityHelper.isVoiceAssistantEnabled())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
} 