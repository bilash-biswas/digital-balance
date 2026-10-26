package com.example.digitalbalance.digital_balance.bridge

import android.content.Context
import com.example.digitalbalance.digital_balance.enforcement.EnforcementCoordinator
import com.example.digitalbalance.digital_balance.permissions.PermissionStatusReader
import com.example.digitalbalance.digital_balance.scheduling.WorkManagerScheduler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class EnforcementPlatformBridge(
    private val context: Context,
    messenger: BinaryMessenger
) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "com.example.digitalbalance/enforcement"
    }

    private val channel = MethodChannel(messenger, CHANNEL_NAME)
    private val coordinator = EnforcementCoordinator.getInstance(context)
    private val statusReader = PermissionStatusReader(context)

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "syncRules" -> {
                val policiesJson = call.argument<String>("policiesJson") ?: "[]"
                try {
                    coordinator.updatePolicies(policiesJson)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("SYNC_RULES_ERROR", e.message, null)
                }
            }
            "grantOverride" -> {
                val packageName = call.argument<String>("packageName")
                val ruleId = call.argument<String>("ruleId") ?: ""
                val durationMinutes = call.argument<Int>("durationMinutes") ?: 5

                if (packageName.isNullOrEmpty()) {
                    result.error("INVALID_ARGUMENTS", "packageName is required", null)
                    return
                }

                coordinator.grantOverride(packageName, ruleId, durationMinutes)
                result.success(true)
            }
            "getEnforcementStatus" -> {
                val isAccessibility = statusReader.isAccessibilityServiceEnabled()
                result.success(
                    mapOf(
                        "isAccessibilityEnabled" to isAccessibility,
                        "isEnforcing" to isAccessibility
                    )
                )
            }
            "schedulePeriodicSync" -> {
                WorkManagerScheduler.schedulePeriodicSync(context)
                result.success(true)
            }
            "cancelPeriodicSync" -> {
                WorkManagerScheduler.cancelPeriodicSync(context)
                result.success(true)
            }
            "setDailyTargetEnforcement" -> {
                val enabled = call.argument<Boolean>("enabled") ?: false
                val targetMinutes = call.argument<Int>("targetMinutes") ?: 180
                coordinator.setDailyTargetConfig(enabled, targetMinutes)
                result.success(true)
            }
            "setBiometricOverride" -> {
                val enabled = call.argument<Boolean>("enabled") ?: true
                val prefs = context.getSharedPreferences("digital_balance_enforcement_prefs", Context.MODE_PRIVATE)
                prefs.edit().putBoolean("biometric_override_enabled", enabled).commit()
                result.success(true)
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
