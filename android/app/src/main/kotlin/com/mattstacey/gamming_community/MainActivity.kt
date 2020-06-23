package com.mattstacey.gamming_community

import android.content.Intent
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlin.system.exitProcess

import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;

class MainActivity: FlutterActivity() {
    private val RESTART_APP = "restartApp";
    private val IMAGE_GALERY = "image_galery";
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor,RESTART_APP).setMethodCallHandler { call, result ->
            if(call.method == "restartApp"){
                restartApp();
            }
            else{
                result.notImplemented()
            }
        }
       /* MethodChannel(flutterEngine.dartExecutor,IMAGE_GALERY).setMethodCallHandler { call, result ->
            if(call.method == "image_galery"){
                image_galery();
            }
            else{
                result.notImplemented()
            }
        }*/
    }
    private fun restartApp(){
        var packageManager = activity.packageManager;
        var packageName :String = context.applicationInfo.packageName;
        val launchIntent: Intent = packageManager.getLaunchIntentForPackage(packageName);
        activity.finishAffinity(); // Finishes all activities.
        activity.startActivity(launchIntent);    // Start the launch activity
        exitProcess(0);

    }
    /*private fun image_galery(){
        val uri: Uri
        val cursor: Cursor
        val column_index_data: Int
        val column_index_folder_name: Int
        val listOfAllImages: kotlin.collections.ArrayList<String> = ArrayList()
        var absolutePathOfImage: String? = null
        uri = android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI

        val projection = arrayOf<String>(MediaStore.MediaColumns.DATA,
                MediaStore.Images.Media.BUCKET_DISPLAY_NAME)

        cursor = activity.getContentResolver().query(uri, projection, null,
                null, null)

        column_index_data = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DATA)
        column_index_folder_name = cursor
                .getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_DISPLAY_NAME)
        while (cursor.moveToNext()) {
            absolutePathOfImage = cursor.getString(column_index_data)
            listOfAllImages.add(absolutePathOfImage)
        }
        return listOfAllImages
    }*/
   /* private fun image_galery1(){
        val allImageInfoList = java.util.HashMap<String, List<Any>>();
        val allImageList = arrayListOf<String>();
        val displayNameList= arrayListOf<String>();
        val dateAddedList= arrayListOf<String>();
        val titleList= arrayListOf<String>();

        val uri: android.net.Uri = android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf<String>(android.provider.MediaStore.Images.ImageColumns.DATA,
                android.provider.MediaStore.Images.ImageColumns.DISPLAY_NAME,
                android.provider.MediaStore.Images.ImageColumns.DATE_ADDED,
                android.provider.MediaStore.Images.ImageColumns.TITLE)
        val c: android.database.Cursor = activity.getContentResolver().query(uri, projection, null, null, null)
        if (c != null) {
            while (c.moveToNext()) {
                android.util.Log.e("", "getAllImageList: " + c.getString(0))
                android.util.Log.e("", "getAllImageList: " + c.getString(1))
                android.util.Log.e("", "getAllImageList: " + c.getString(2))
                android.util.Log.e("", "getAllImageList: " + c.getString(3))
                titleList.add(c.getString(3))
                displayNameList.add(c.getString(1))
                dateAddedList.add(c.getString(2))
                allImageList.add(c.getString(0))
            }
            c.close()
            allImageInfoList.put("URIList", allImageList)
            allImageInfoList.put("DISPLAY_NAME", displayNameList)
            allImageInfoList.put("DATE_ADDED", dateAddedList)
            allImageInfoList.put("TITLE", titleList)
        }
        return allImageInfoList

    }*/

}
