package com.anany.azkar

import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.anany.azkar/audio",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "androidRawExists" -> {
                    val name = call.argument<String>("name")
                    if (name.isNullOrBlank()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    val id = resources.getIdentifier(name, "raw", packageName)
                    result.success(id != 0)
                }
                "prepareAudioSession" -> result.success(null)
                else -> result.notImplemented()
            }
        }
    }
}
