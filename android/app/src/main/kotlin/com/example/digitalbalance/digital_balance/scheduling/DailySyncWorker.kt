package com.example.digitalbalance.digital_balance.scheduling

import android.content.Context
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.example.digitalbalance.digital_balance.usage.UsageStatsReader

class DailySyncWorker(
    context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        return try {
            Log.d("DailySyncWorker", "Executing periodic usage sync in background")
            val reader = UsageStatsReader(applicationContext)
            val endTime = System.currentTimeMillis()
            val startTime = endTime - (24 * 60 * 60 * 1000L) // last 24 hours
            val result = reader.queryUsage(startTime, endTime)
            Log.d("DailySyncWorker", "Periodic sync finished with success: ${result["success"]}")
            Result.success()
        } catch (e: Exception) {
            Log.e("DailySyncWorker", "Periodic sync failed: ${e.message}", e)
            Result.retry()
        }
    }
}
