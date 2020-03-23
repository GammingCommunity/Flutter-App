package com.mattstacey.gamming_community

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
class MainActivity: FlutterActivity() {
    private val MESSAGE_CHANNEL = "com.matts.gamming_community/messages";
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,MESSAGE_CHANNEL).setMethodCallHandler{
            call: MethodCall, result: MethodChannel.Result -> {

        }
        }
    }
    private fun getMessage() {
        var message: String;

    }
}
