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
            else -> {
                result.notImplemented()
            }
        }
    }

    fun teardown() {
        channel.setMethodCallHandler(null)
    }
}
