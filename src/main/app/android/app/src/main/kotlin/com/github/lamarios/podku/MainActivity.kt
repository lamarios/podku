package com.github.lamarios.podku

import io.flutter.embedding.android.FlutterActivity
import com.ryanheise.audioservice.AudioServiceActivity
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : AudioServiceActivity(){

    private val CHANNEL = "com.github.lamarios.podku/file_provider"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getContentUri") {
                val path = call.argument<String>("path")!!
                val file = File(path)
                val uri = FileProvider.getUriForFile(
                    applicationContext,
                    "${applicationContext.packageName}.fileprovider",
                    file
                )
                // Grant read access to known media-browser clients (Android Auto, Automotive OS)
                val clientsToGrant = listOf(
                    "com.google.android.projection.gearhead", // Android Auto (phone)
                    "com.google.android.apps.automotive.templates.host" // Android Automotive OS
                )
                for (pkg in clientsToGrant) {
                    applicationContext.grantUriPermission(pkg, uri, android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION)
                }
                result.success(uri.toString())
            } else {
                result.notImplemented()
            }
        }
    }
}