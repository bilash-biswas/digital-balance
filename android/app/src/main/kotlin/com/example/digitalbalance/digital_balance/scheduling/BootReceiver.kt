package com.example.digitalbalance.digital_balance.scheduling

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.example.digitalbalance.digital_balance.enforcement.EnforcementCoordinator

class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == "android.intent.action.QUICKBOOT_POWERON") {
            Log.d("BootReceiver", "Device boot detected. Reconciling enforcement policies and background workers.")
            // Warm-up enforcement cache
            EnforcementCoordinator.getInstance(context)
            // Schedule background sync
            WorkManagerScheduler.schedulePeriodicSync(context)
        }
    }
}
