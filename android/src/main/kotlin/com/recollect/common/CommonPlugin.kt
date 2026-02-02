package com.recollect.willow_data

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.willow_data.MethodCall
import io.flutter.plugin.willow_data.MethodChannel
import io.flutter.plugin.willow_data.MethodChannel.MethodCallHandler
import io.flutter.plugin.willow_data.MethodChannel.Result

/** willow_dataPlugin */
class willow_dataPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "willow_data")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
