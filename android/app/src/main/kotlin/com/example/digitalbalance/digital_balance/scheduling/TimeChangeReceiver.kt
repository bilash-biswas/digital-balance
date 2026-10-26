package com.example.digitalbalance.digital_balance.scheduling

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.example.digitalbalance.digital_balance.enforcement.EnforcementCoordinator

class TimeChangeReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_TIME_CHANGED || intent.action == Intent.ACTION_TIMEZONE_CHANGED) {
            Log.d("TimeChangeReceiver", "Time or timezone change detected. Reconciling policies.")
            EnforcementCoordinator.getInstance(context)
        }
    }
}
