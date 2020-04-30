package com.mattstacey.gamming_community

import android.content.Intent
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlin.system.exitProcess

class MainActivity: FlutterActivity() {
    private val CHANNEL = "restartApp";
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor,CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == "restartApp"){
                restartApp();
            }
            else{
                result.notImplemented()
            }
        }
    }
    private fun restartApp(){
        var packageManager = activity.packageManager;
        var packageName :String = context.applicationInfo.packageName;
        val launchIntent: Intent = packageManager.getLaunchIntentForPackage(packageName);
        activity.finishAffinity(); // Finishes all activities.
        activity.startActivity(launchIntent);    // Start the launch activity
        exitProcess(0);

    }

}
