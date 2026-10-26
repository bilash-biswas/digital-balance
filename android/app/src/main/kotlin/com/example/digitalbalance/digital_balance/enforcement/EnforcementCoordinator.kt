package com.example.digitalbalance.digital_balance.enforcement

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
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

    private val policies = ConcurrentHashMap<String, RestrictionPolicy>()
    private val overrides = ConcurrentHashMap<String, Long>() // packageName -> overrideUntilMs

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

    private fun loadFromPrefs() {
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

        for (policy in policies.values) {
            if (!policy.packages.contains(packageName)) continue

            // 1. Temporary Block
            if (policy.isTemporaryBlock && now < policy.tempBlockUntilMs) {
                return RestrictionResult(
                    isBlocked = true,
                    ruleId = policy.ruleId,
                    ruleName = policy.ruleName,
                    reason = "Focus block in progress"
                )
            }

            // 2. Schedule Window check (day of week + time of day)
            val matchesDay = policy.daysOfWeek.isEmpty() || policy.daysOfWeek.contains(dayOfWeek)
            if (matchesDay && policy.startMinuteOfDay >= 0 && policy.endMinuteOfDay >= 0) {
                val inSchedule = if (policy.startMinuteOfDay < policy.endMinuteOfDay) {
                    // Daytime schedule, e.g. 09:00 (540) to 17:00 (1020)
                    minuteOfDay in policy.startMinuteOfDay until policy.endMinuteOfDay
                } else {
                    // Overnight schedule, e.g. 22:00 (1320) to 07:00 (420)
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

            // 3. Daily Usage Limit check
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
