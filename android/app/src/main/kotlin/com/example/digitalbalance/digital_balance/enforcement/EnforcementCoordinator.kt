package com.example.digitalbalance.digital_balance.enforcement

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Telephony
import android.telecom.TelecomManager
import com.example.digitalbalance.digital_balance.usage.UsageStatsReader
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar
import java.util.concurrent.ConcurrentHashMap

data class RestrictionResult(
    val isBlocked: Boolean,
    val ruleId: String,
    val ruleName: String,
    val reason: String
)

class EnforcementCoordinator(private val context: Context) {

    private val prefs: SharedPreferences =
        context.getSharedPreferences("digital_balance_enforcement_prefs", Context.MODE_PRIVATE)

    private val usageReader = UsageStatsReader(context)
    private val policies = ConcurrentHashMap<String, RestrictionPolicy>()
    private val overrides = ConcurrentHashMap<String, Long>() // packageName -> overrideUntilMs

    private var dailyTargetEnforcementEnabled: Boolean = false
    private var dailyTargetLimitMinutes: Int = 180

    @Volatile private var cachedTodayMinutes: Int = 0
    @Volatile private var lastTodayMinutesFetchMs: Long = 0L

    init {
        loadFromPrefs()
    }

    @Synchronized
    fun updatePolicies(policiesJsonArrayString: String) {
        policies.clear()
        try {
            val array = JSONArray(policiesJsonArrayString)
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                val policy = RestrictionPolicy.fromJson(obj)
                policies[policy.ruleId] = policy
            }
            prefs.edit().putString("policies_json", policiesJsonArrayString).apply()
        } catch (_: Exception) {}
    }

    fun setDailyTargetConfig(enabled: Boolean, targetMinutes: Int) {
        dailyTargetEnforcementEnabled = enabled
        dailyTargetLimitMinutes = targetMinutes
        prefs.edit()
            .putBoolean("daily_target_enforcement_enabled", enabled)
            .putInt("daily_target_limit_minutes", targetMinutes)
            .apply()
        lastTodayMinutesFetchMs = 0L // invalidate cache to recompute
    }

    private fun loadFromPrefs() {
        dailyTargetEnforcementEnabled = prefs.getBoolean("daily_target_enforcement_enabled", false)
        dailyTargetLimitMinutes = prefs.getInt("daily_target_limit_minutes", 180)

        val jsonStr = prefs.getString("policies_json", null) ?: return
        try {
            val array = JSONArray(jsonStr)
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                val policy = RestrictionPolicy.fromJson(obj)
                policies[policy.ruleId] = policy
            }
        } catch (_: Exception) {}
    }

    fun grantOverride(packageName: String, ruleId: String, durationMinutes: Int) {
        val overrideUntil = System.currentTimeMillis() + (durationMinutes * 60 * 1000L)
        overrides[packageName] = overrideUntil
        prefs.edit().putLong("override_$packageName", overrideUntil).apply()
    }

    fun isOverrideActive(packageName: String): Boolean {
        val overrideUntil = overrides[packageName] ?: prefs.getLong("override_$packageName", 0L)
        val now = System.currentTimeMillis()
        if (now < overrideUntil) {
            return true
        } else {
            overrides.remove(packageName)
            return false
        }
    }

    fun getTodayTotalMinutesCached(): Int {
        val now = System.currentTimeMillis()
        if (now - lastTodayMinutesFetchMs > 20_000L) {
            cachedTodayMinutes = usageReader.getTodayTotalMinutes()
            lastTodayMinutesFetchMs = now
        }
        return cachedTodayMinutes
    }

    fun isEssentialPackage(packageName: String): Boolean {
        if (packageName == context.packageName) return true
        if (packageName == "com.android.systemui") return true
        if (packageName == "com.android.settings") return true
        if (packageName == "com.android.emergency") return true
        if (packageName == "com.android.packageinstaller" || packageName == "com.google.android.packageinstaller") return true
        if (packageName == "com.google.android.gms") return true

        // Home launcher
        val homeIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
        val homeResolve = context.packageManager.resolveActivity(homeIntent, PackageManager.MATCH_DEFAULT_ONLY)
        if (homeResolve?.activityInfo?.packageName == packageName) return true

        // Default Phone dialer
        val telecom = context.getSystemService(Context.TELECOM_SERVICE) as? TelecomManager
        if (telecom?.defaultDialerPackage == packageName) return true

        // Default SMS
        val defaultSms = Telephony.Sms.getDefaultSmsPackage(context)
        if (defaultSms == packageName) return true

        // Known clock / alarms
        val clockPackages = setOf(
            "com.google.android.deskclock",
            "com.android.deskclock",
            "com.sec.android.app.clockpackage"
        )
        if (clockPackages.contains(packageName)) return true

        return false
    }

    fun evaluatePackage(packageName: String): RestrictionResult? {
        // Exclude system UI and self
        if (packageName == context.packageName || packageName == "com.android.systemui") {
            return null
        }

        // Check if under active override
        if (isOverrideActive(packageName)) {
            return null
        }

        val now = System.currentTimeMillis()
        val calendar = Calendar.getInstance()
        val currentHour = calendar.get(Calendar.HOUR_OF_DAY)
        val currentMinute = calendar.get(Calendar.MINUTE)
        val minuteOfDay = currentHour * 60 + currentMinute

        // Convert Calendar.DAY_OF_WEEK (Sun=1, Mon=2..Sat=7) to ISO-8601 (Mon=1..Sun=7)
        val dayOfWeek = when (calendar.get(Calendar.DAY_OF_WEEK)) {
            Calendar.MONDAY -> 1
            Calendar.TUESDAY -> 2
            Calendar.WEDNESDAY -> 3
            Calendar.THURSDAY -> 4
            Calendar.FRIDAY -> 5
            Calendar.SATURDAY -> 6
            Calendar.SUNDAY -> 7
            else -> 1
        }

        // 1. Evaluate explicit app timer rules first
        for (policy in policies.values) {
            if (!policy.packages.contains(packageName)) continue

            // Temporary Block
            if (policy.isTemporaryBlock && now < policy.tempBlockUntilMs) {
                return RestrictionResult(
                    isBlocked = true,
                    ruleId = policy.ruleId,
                    ruleName = policy.ruleName,
                    reason = "Focus block in progress"
                )
            }

            // Schedule Window check (day of week + time of day)
            val matchesDay = policy.daysOfWeek.isEmpty() || policy.daysOfWeek.contains(dayOfWeek)
            if (matchesDay && policy.startMinuteOfDay >= 0 && policy.endMinuteOfDay >= 0) {
                val inSchedule = if (policy.startMinuteOfDay < policy.endMinuteOfDay) {
                    minuteOfDay in policy.startMinuteOfDay until policy.endMinuteOfDay
                } else {
                    minuteOfDay >= policy.startMinuteOfDay || minuteOfDay < policy.endMinuteOfDay
                }

                if (inSchedule) {
                    return RestrictionResult(
                        isBlocked = true,
                        ruleId = policy.ruleId,
                        ruleName = policy.ruleName,
                        reason = "Restricted by schedule"
                    )
                }
            }

            // Daily Usage Limit check for specific policy
            if (policy.limitMinutesPerDay > 0) {
                val usageMinutes = getTodayUsageMinutes(packageName)
                if (usageMinutes >= policy.limitMinutesPerDay) {
                    return RestrictionResult(
                        isBlocked = true,
                        ruleId = policy.ruleId,
                        ruleName = policy.ruleName,
                        reason = "Daily limit of ${policy.limitMinutesPerDay} minutes reached"
                    )
                }
            }
        }

        // 2. Evaluate overall Daily Screen Time Target Enforcement
        if (dailyTargetEnforcementEnabled && dailyTargetLimitMinutes > 0) {
            if (!isEssentialPackage(packageName)) {
                val todayMinutes = getTodayTotalMinutesCached()
                if (todayMinutes >= dailyTargetLimitMinutes) {
                    val goalHours = dailyTargetLimitMinutes / 60
                    val goalMins = dailyTargetLimitMinutes % 60
                    val targetStr = if (goalHours > 0 && goalMins > 0) "${goalHours}h ${goalMins}m" else if (goalHours > 0) "${goalHours}h" else "${goalMins}m"
                    return RestrictionResult(
                        isBlocked = true,
                        ruleId = "__daily_target__",
                        ruleName = "Daily Screen Time Target",
                        reason = "You have reached your daily screen time target of $targetStr. Non-essential apps are paused."
                    )
                }
            }
        }

        return null
    }

    private fun getTodayUsageMinutes(packageName: String): Int {
        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager ?: return 0
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val startTime = calendar.timeInMillis
        val endTime = System.currentTimeMillis()

        val stats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startTime, endTime)
        var totalMs = 0L
        for (item in stats) {
            if (item.packageName == packageName) {
                totalMs += item.totalTimeInForeground
            }
        }
        return (totalMs / (1000 * 60)).toInt()
    }

    companion object {
        @Volatile
        private var instance: EnforcementCoordinator? = null

        fun getInstance(context: Context): EnforcementCoordinator {
            return instance ?: synchronized(this) {
                instance ?: EnforcementCoordinator(context.applicationContext).also { instance = it }
            }
        }
    }
}
