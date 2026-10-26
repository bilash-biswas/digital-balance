package com.example.digitalbalance.digital_balance.bridge

import android.content.Context
import com.example.digitalbalance.digital_balance.permissions.PermissionSettingsLauncher
import com.example.digitalbalance.digital_balance.permissions.PermissionStatusReader
import com.example.digitalbalance.digital_balance.usage.UsageStatsReader
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UsagePlatformBridge(
    private val context: Context,
    messenger: BinaryMessenger
) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "com.example.digitalbalance/usage"
    }

    private val channel = MethodChannel(messenger, CHANNEL_NAME)
    private val statusReader = PermissionStatusReader(context)
    private val settingsLauncher = PermissionSettingsLauncher(context)
    private val usageReader = UsageStatsReader(context)

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPermissionStatus" -> {
                result.success(statusReader.getAllPermissionStatuses())
            }
            "openUsageSettings" -> {
                result.success(settingsLauncher.openUsageAccessSettings())
            }
            "openAccessibilitySettings" -> {
                result.success(settingsLauncher.openAccessibilitySettings())
            }
            "openNotificationSettings" -> {
                val packageName = call.argument<String>("packageName")
                result.success(settingsLauncher.openNotificationSettings(packageName))
            }
            "openExactAlarmSettings" -> {
                result.success(settingsLauncher.openExactAlarmSettings())
            }
            "openAppSettings" -> {
                result.success(settingsLauncher.openAppSettings())
            }
            "getInstalledApplications" -> {
                try {
                    val apps = usageReader.getInstalledApplications()
                    result.success(apps)
                } catch (e: Exception) {
                    result.error("APP_DISCOVERY_ERROR", e.message, null)
                }
            }
            "getAppIcon" -> {
                val packageName = call.argument<String>("packageName")
                if (packageName == null) {
                    result.error("INVALID_ARGUMENT", "packageName is required", null)
                    return
                }
                try {
                    val bytes = usageReader.getAppIconBytes(packageName)
                    result.success(bytes)
                } catch (e: Exception) {
                    result.success(null)
                }
            }
            "queryUsage" -> {
                val startTime = call.argument<Number>("startTime")?.toLong()
                val endTime = call.argument<Number>("endTime")?.toLong()
                if (startTime == null || endTime == null) {
                    result.error("INVALID_ARGUMENTS", "startTime and endTime are required", null)
                    return
                }

                try {
                    val usageData = usageReader.queryUsage(startTime, endTime)
                    result.success(usageData)
                } catch (e: Exception) {
                    result.error("USAGE_QUERY_ERROR", e.message, null)
                }
            }
            "installApk" -> {
                val filePath = call.argument<String>("filePath")
                if (filePath.isNullOrEmpty()) {
                    result.error("INVALID_ARGUMENT", "filePath is required", null)
                    return
                }
                try {
                    val file = java.io.File(filePath)
                    if (!file.exists()) {
                        result.error("FILE_NOT_FOUND", "APK file does not exist at $filePath", null)
                        return
                    }
                    val uri = androidx.core.content.FileProvider.getUriForFile(
                        context,
                        "${context.packageName}.fileprovider",
                        file
                    )
                    val intent = android.content.Intent(android.content.Intent.ACTION_VIEW).apply {
                        setDataAndType(uri, "application/vnd.android.package-archive")
                        addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                    context.startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INSTALL_ERROR", e.message, null)
                }
            }
            "canRequestPackageInstalls" -> {
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    result.success(context.packageManager.canRequestPackageInstalls())
                } else {
                    result.success(true)
                }
            }
            "openManageUnknownAppSources" -> {
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    try {
                        val intent = android.content.Intent(android.provider.Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).apply {
                            data = android.net.Uri.parse("package:${context.packageName}")
                            addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        context.startActivity(intent)
                        result.success(true)
                    } catch (_: Exception) {
                        result.success(false)
                    }
                } else {
                    result.success(false)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    fun teardown() {
        channel.setMethodCallHandler(null)
    }
}
