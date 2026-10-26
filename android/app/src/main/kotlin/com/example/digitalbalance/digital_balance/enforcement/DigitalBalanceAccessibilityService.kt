package com.example.digitalbalance.digital_balance.enforcement

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class DigitalBalanceAccessibilityService : AccessibilityService() {

    private lateinit var coordinator: EnforcementCoordinator

    override fun onServiceConnected() {
        super.onServiceConnected()
        coordinator = EnforcementCoordinator.getInstance(this)
        Log.d("DigitalBalanceService", "AccessibilityService connected and active")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            return
        }

        val packageName = event.packageName?.toString() ?: return

        val restriction = coordinator.evaluatePackage(packageName)
        if (restriction != null && restriction.isBlocked) {
            Log.i("DigitalBalanceService", "Restricting $packageName: ${restriction.reason}")

            // Launch the intervention BlockerActivity
            val intent = Intent(this, BlockerActivity::class.java).apply {
                putExtra(BlockerActivity.EXTRA_PACKAGE_NAME, packageName)
                putExtra(BlockerActivity.EXTRA_RULE_ID, restriction.ruleId)
                putExtra(BlockerActivity.EXTRA_RULE_NAME, restriction.ruleName)
                putExtra(BlockerActivity.EXTRA_REASON, restriction.reason)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            }
            startActivity(intent)
        }
    }

    override fun onInterrupt() {
        Log.w("DigitalBalanceService", "AccessibilityService interrupted")
    }
}
