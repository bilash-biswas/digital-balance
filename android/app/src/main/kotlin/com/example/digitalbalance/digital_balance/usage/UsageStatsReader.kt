package com.example.digitalbalance.digital_balance.usage

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build

class UsageStatsReader(private val context: Context) {

    private val usageStatsManager =
        context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
    private val packageManager: PackageManager = context.packageManager

    fun getInstalledApplications(): List<Map<String, Any>> {
        val launcherIntent = Intent(Intent.ACTION_MAIN, null).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }
        val resolveInfos = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.queryIntentActivities(
                launcherIntent,
                PackageManager.ResolveInfoFlags.of(0)
            )
        } else {
            @Suppress("DEPRECATION")
            packageManager.queryIntentActivities(launcherIntent, 0)
        }

        val seenPackages = mutableSetOf<String>()
        val resultList = mutableListOf<Map<String, Any>>()

        for (resolveInfo in resolveInfos) {
            val pkgName = resolveInfo.activityInfo.packageName
            if (pkgName in seenPackages) continue
            seenPackages.add(pkgName)

            val appName = resolveInfo.loadLabel(packageManager).toString()
            val isSystem = (resolveInfo.activityInfo.applicationInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0

            val categoryInt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                resolveInfo.activityInfo.applicationInfo.category
            } else {
                ApplicationInfo.CATEGORY_UNDEFINED
            }

            val categoryName = when (categoryInt) {
                ApplicationInfo.CATEGORY_GAME -> "Games"
                ApplicationInfo.CATEGORY_AUDIO,
                ApplicationInfo.CATEGORY_VIDEO -> "Entertainment"
                ApplicationInfo.CATEGORY_IMAGE,
                ApplicationInfo.CATEGORY_SOCIAL -> "Social"
                ApplicationInfo.CATEGORY_NEWS -> "Education"
                ApplicationInfo.CATEGORY_PRODUCTIVITY -> "Productivity"
                ApplicationInfo.CATEGORY_MAPS -> "Utilities"
                else -> "uncategorized"
            }

            resultList.add(
                mapOf(
                    "packageName" to pkgName,
                    "appName" to appName,
                    "isSystemApp" to isSystem,
                    "category" to categoryName
                )
            )
        }

        return resultList.sortedBy { (it["appName"] as? String)?.lowercase() ?: "" }
    }

    fun getAppIconBytes(packageName: String): ByteArray? {
        return try {
            val drawable = packageManager.getApplicationIcon(packageName)
            val bitmap = if (drawable is android.graphics.drawable.BitmapDrawable && drawable.bitmap != null) {
                drawable.bitmap
            } else {
                val w = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 128
                val h = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 128
                val bmp = android.graphics.Bitmap.createBitmap(w, h, android.graphics.Bitmap.Config.ARGB_8888)
                val canvas = android.graphics.Canvas(bmp)
                drawable.setBounds(0, 0, canvas.width, canvas.height)
                drawable.draw(canvas)
                bmp
            }
            val stream = java.io.ByteArrayOutputStream()
            bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, stream)
            stream.toByteArray()
        } catch (_: Exception) {
            null
        }
    }

    private fun getDefaultLauncherPackage(): String? {
        val intent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
        val resolveInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.resolveActivity(intent, PackageManager.ResolveInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            packageManager.resolveActivity(intent, 0)
        }
        return resolveInfo?.activityInfo?.packageName
    }

    fun queryUsage(startTime: Long, endTime: Long): Map<String, Any> {
        if (usageStatsManager == null) {
            return mapOf(
                "success" to false,
                "error" to "UsageStatsManager unavailable",
                "apps" to emptyList<Map<String, Any>>(),
                "deviceUnlocks" to 0
            )
        }

        // Cache launcher application human-readable names ("Facebook", "eFootball", etc.)
        val installedApps = getInstalledApplications()
        val launcherAppNames = installedApps.associate {
            (it["packageName"] as String) to (it["appName"] as String)
        }
        val launcherPackageSet = launcherAppNames.keys

        // Find all Home launcher packages to exclude them from user screen time
        val homeIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
        val homeResolveInfos = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.queryIntentActivities(homeIntent, PackageManager.ResolveInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            packageManager.queryIntentActivities(homeIntent, 0)
        }
        val launcherPackages = homeResolveInfos.mapNotNull { it.activityInfo?.packageName }.toSet()

        val excludedPackages = mutableSetOf<String>().apply {
            addAll(launcherPackages)
            add("com.android.systemui")
            add("android")
            getDefaultLauncherPackage()?.let { add(it) }
        }

        val foregroundTimeMap = mutableMapOf<String, Long>()
        val lastUsedMap = mutableMapOf<String, Long>()
        val launchCountMap = mutableMapOf<String, Int>()
        val hourlyForegroundTime = LongArray(24) { 0L }
        val hourlyUnlocks = IntArray(24) { 0 }
        val calendar = java.util.Calendar.getInstance()
        var deviceUnlocks = 0
        var notificationCount = 0

        fun isExcluded(pkg: String): Boolean {
            if (pkg in excludedPackages) return true
            // If it's a system app with no launcher entry, exclude it from screen time
            if (pkg !in launcherPackageSet) {
                try {
                    val appInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        packageManager.getApplicationInfo(pkg, PackageManager.ApplicationInfoFlags.of(0))
                    } else {
                        @Suppress("DEPRECATION")
                        packageManager.getApplicationInfo(pkg, 0)
                    }
                    if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) {
                        return true
                    }
                } catch (_: Exception) {
                    return true
                }
            }
            return false
        }

        fun addSessionToHourly(startMs: Long, endMs: Long) {
            val clampedStart = maxOf(startMs, startTime)
            val clampedEnd = minOf(endMs, endTime)
            if (clampedEnd <= clampedStart) return

            var cur = clampedStart
            while (cur < clampedEnd) {
                calendar.timeInMillis = cur
                val hour = calendar.get(java.util.Calendar.HOUR_OF_DAY)
                calendar.set(java.util.Calendar.MINUTE, 0)
                calendar.set(java.util.Calendar.SECOND, 0)
                calendar.set(java.util.Calendar.MILLISECOND, 0)
                calendar.add(java.util.Calendar.HOUR_OF_DAY, 1)
                val nextHourBoundary = calendar.timeInMillis
                val chunkEnd = minOf(clampedEnd, nextHourBoundary)
                val chunkDuration = chunkEnd - cur
                if (hour in 0..23 && chunkDuration > 0L) {
                    hourlyForegroundTime[hour] = minOf(3600000L, hourlyForegroundTime[hour] + chunkDuration)
                }
                cur = chunkEnd
            }
        }

        // Active foreground session tracker
        var currentForegroundPkg: String? = null
        var currentForegroundStart = 0L

        fun closeCurrentSession(endTimestamp: Long) {
            val pkg = currentForegroundPkg ?: return
            val start = currentForegroundStart
            currentForegroundPkg = null
            currentForegroundStart = 0L

            if (endTimestamp <= start) return
            if (isExcluded(pkg)) return

            val effectiveStart = maxOf(start, startTime)
            val effectiveEnd = minOf(endTimestamp, endTime)

            if (effectiveEnd > effectiveStart) {
                val duration = effectiveEnd - effectiveStart
                // Continuous foreground session without screen off cannot exceed query interval
                if (duration in 1..86400000L) {
                    foregroundTimeMap[pkg] = (foregroundTimeMap[pkg] ?: 0L) + duration
                    addSessionToHourly(effectiveStart, effectiveEnd)
                }
            }
        }

        // Query events from up to 3 hours before startTime to catch sessions crossing midnight
        val queryStart = maxOf(0L, startTime - 3 * 3600 * 1000L)

        try {
            val events = usageStatsManager.queryEvents(queryStart, endTime)
            val event = UsageEvents.Event()

            while (events.hasNextEvent()) {
                events.getNextEvent(event)
                val pkg = event.packageName ?: continue
                val timestamp = event.timeStamp

                when (event.eventType) {
                    UsageEvents.Event.ACTIVITY_RESUMED,
                    UsageEvents.Event.MOVE_TO_FOREGROUND -> {
                        if (currentForegroundPkg != null && currentForegroundPkg != pkg) {
                            closeCurrentSession(timestamp)
                        }
                        if (currentForegroundPkg != pkg) {
                            currentForegroundPkg = pkg
                            currentForegroundStart = timestamp
                            if (timestamp >= startTime && !isExcluded(pkg)) {
                                launchCountMap[pkg] = (launchCountMap[pkg] ?: 0) + 1
                            }
                        }
                        if (timestamp > (lastUsedMap[pkg] ?: 0L)) {
                            lastUsedMap[pkg] = timestamp
                        }
                    }
                    UsageEvents.Event.ACTIVITY_PAUSED,
                    UsageEvents.Event.MOVE_TO_BACKGROUND -> {
                        if (currentForegroundPkg == pkg) {
                            closeCurrentSession(timestamp)
                        }
                        if (timestamp > (lastUsedMap[pkg] ?: 0L)) {
                            lastUsedMap[pkg] = timestamp
                        }
                    }
                    UsageEvents.Event.SCREEN_NON_INTERACTIVE,
                    UsageEvents.Event.KEYGUARD_SHOWN -> {
                        closeCurrentSession(timestamp)
                    }
                    UsageEvents.Event.KEYGUARD_HIDDEN -> {
                        if (timestamp >= startTime) {
                            deviceUnlocks++
                            calendar.timeInMillis = timestamp
                            val hour = calendar.get(java.util.Calendar.HOUR_OF_DAY)
                            if (hour in 0..23) {
                                hourlyUnlocks[hour]++
                            }
                        }
                    }
                    12 -> { // UsageEvents.Event.NOTIFICATION_INTERRUPTION
                        if (timestamp >= startTime) {
                            notificationCount++
                        }
                    }
                }
            }

            // Close trailing session if active at query endTime
            if (currentForegroundPkg != null) {
                closeCurrentSession(minOf(endTime, currentForegroundStart + 3600000L))
            }
        } catch (_: Exception) {}

        // Fallback: If queryEvents produced no data, use aggregated stats
        if (foregroundTimeMap.isEmpty()) {
            val aggregated = usageStatsManager.queryAndAggregateUsageStats(startTime, endTime)
            for ((pkg, stats) in aggregated) {
                if (stats.totalTimeInForeground > 0L && !isExcluded(pkg)) {
                    foregroundTimeMap[pkg] = stats.totalTimeInForeground
                    if (stats.lastTimeUsed > (lastUsedMap[pkg] ?: 0L)) {
                        lastUsedMap[pkg] = stats.lastTimeUsed
                    }
                }
            }
        }

        // Assemble app metrics list, filtering home launcher and system framework to match Digital Wellbeing standards
        val maxAllowedMs = maxOf(0L, endTime - startTime)
        val appResults = mutableListOf<Map<String, Any>>()
        for ((pkg, foregroundMs) in foregroundTimeMap) {
            if (foregroundMs <= 0L) continue
            if (isExcluded(pkg)) continue

            val effectiveMs = minOf(foregroundMs, maxAllowedMs)
            val appName = launcherAppNames[pkg] ?: try {
                val appInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    packageManager.getApplicationInfo(pkg, PackageManager.ApplicationInfoFlags.of(0))
                } else {
                    @Suppress("DEPRECATION")
                    packageManager.getApplicationInfo(pkg, 0)
                }
                packageManager.getApplicationLabel(appInfo).toString()
            } catch (_: Exception) {
                pkg.split('.').last().replaceFirstChar { it.uppercase() }
            }

            appResults.add(
                mapOf(
                    "packageName" to pkg,
                    "appName" to appName,
                    "foregroundTimeMs" to effectiveMs,
                    "lastTimeUsedMs" to (lastUsedMap[pkg] ?: 0L),
                    "launchCount" to (launchCountMap[pkg] ?: 0)
                )
            )
        }

        return mapOf(
            "success" to true,
            "apps" to appResults.sortedByDescending { it["foregroundTimeMs"] as Long },
            "deviceUnlocks" to deviceUnlocks,
            "notificationCount" to notificationCount,
            "hourlyForegroundTimeMs" to hourlyForegroundTime.toList(),
            "hourlyUnlocks" to hourlyUnlocks.toList()
        )
    }
}
