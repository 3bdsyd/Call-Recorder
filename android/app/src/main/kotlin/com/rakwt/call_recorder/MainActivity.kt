package com.rakwt.call_recorder

import com.rakwt.call_recorder.bridge.CallRecorderPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private var plugin: CallRecorderPlugin? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        plugin = CallRecorderPlugin(applicationContext, flutterEngine.dartExecutor.binaryMessenger).also { it.attach() }
    }

    override fun onDestroy() {
        plugin?.detach()
        plugin = null
        super.onDestroy()
    }
}
