package com.example.digitalbalance.digital_balance.enforcement

import org.json.JSONArray
import org.json.JSONObject

data class RestrictionPolicy(
    val ruleId: String,
    val ruleName: String,
    val packages: Set<String>,
    val limitMinutesPerDay: Int, // 0 = unlimited / scheduled only
    val startMinuteOfDay: Int,   // e.g. 22 * 60 = 1320 (22:00)
    val endMinuteOfDay: Int,     // e.g. 7 * 60 = 420 (07:00)
    val daysOfWeek: Set<Int>,    // 1 = Monday ... 7 = Sunday
    val isTemporaryBlock: Boolean = false,
    val tempBlockUntilMs: Long = 0L
) {
    fun toJson(): JSONObject {
        return JSONObject().apply {
            put("ruleId", ruleId)
            put("ruleName", ruleName)
            put("packages", JSONArray(packages))
            put("limitMinutesPerDay", limitMinutesPerDay)
            put("startMinuteOfDay", startMinuteOfDay)
            put("endMinuteOfDay", endMinuteOfDay)
            put("daysOfWeek", JSONArray(daysOfWeek))
            put("isTemporaryBlock", isTemporaryBlock)
            put("tempBlockUntilMs", tempBlockUntilMs)
        }
    }

    companion object {
        fun fromJson(json: JSONObject): RestrictionPolicy {
            val pkgArray = json.optJSONArray("packages") ?: JSONArray()
            val pkgs = mutableSetOf<String>()
            for (i in 0 until pkgArray.length()) {
                pkgs.add(pkgArray.getString(i))
            }

            val daysArray = json.optJSONArray("daysOfWeek") ?: JSONArray()
            val days = mutableSetOf<Int>()
            for (i in 0 until daysArray.length()) {
                days.add(daysArray.getInt(i))
            }

            return RestrictionPolicy(
                ruleId = json.optString("ruleId", ""),
                ruleName = json.optString("ruleName", "Restriction Rule"),
                packages = pkgs,
                limitMinutesPerDay = json.optInt("limitMinutesPerDay", 0),
                startMinuteOfDay = json.optInt("startMinuteOfDay", -1),
                endMinuteOfDay = json.optInt("endMinuteOfDay", -1),
                daysOfWeek = days,
                isTemporaryBlock = json.optBoolean("isTemporaryBlock", false),
                tempBlockUntilMs = json.optLong("tempBlockUntilMs", 0L)
            )
        }
    }
}

data class ActiveOverride(
    val ruleId: String,
    val packageName: String,
    val overrideUntilMs: Long
)
