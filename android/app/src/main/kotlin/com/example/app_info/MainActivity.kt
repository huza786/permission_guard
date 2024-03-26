package com.example.app_info

import android.content.pm.PackageManager
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.huzaifa/permission"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getPermissions") {
                val packageName = call.arguments as String
                getPermissions(packageName, result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getPermissions(packageName: String, result: MethodChannel.Result) {
        try {
            val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
            val permissions = packageInfo.requestedPermissions ?: emptyArray()
            result.success(permissions.toList())
        } catch (e: PackageManager.NameNotFoundException) {
            result.error("PACKAGE_NOT_FOUND", "Package not found", null)
        }
    }
}
