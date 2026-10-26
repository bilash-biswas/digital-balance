package com.example.digitalbalance.digital_balance.enforcement

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class DigitalBalanceAccessibilityService : AccessibilityService() {

    private lateinit var coordinator: EnforcementCoordinator
    private var lastObservedPackage: String? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private var periodicChecker: Runnable? = null

    override fun onServiceConnected() {
        super.onServiceConnected()
        coordinator = EnforcementCoordinator.getInstance(this)
        Log.d("DigitalBalanceService", "AccessibilityService connected and active")
        startPeriodicEnforcementCheck()
    }

    private fun startPeriodicEnforcementCheck() {
        periodicChecker = object : Runnable {
            override fun run() {
                checkCurrentObservedPackage()
                mainHandler.postDelayed(this, 15_000L)
            }
        }
        mainHandler.postDelayed(periodicChecker!!, 15_000L)
    }

    private fun checkCurrentObservedPackage() {
        val target = lastObservedPackage ?: return
        if (coordinator.isEssentialPackage(target)) return

        val restriction = coordinator.evaluatePackage(target)
        if (restriction != null && restriction.isBlocked) {
            launchBlocker(target, restriction)
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            return
        }

        val packageName = event.packageName?.toString() ?: return

        // Safety: Never evaluate or restrict essential packages (system UI, launchers, self, emergency)
        if (coordinator.isEssentialPackage(packageName)) {
            return
        }

        lastObservedPackage = packageName

        val restriction = coordinator.evaluatePackage(packageName)
        if (restriction != null && restriction.isBlocked) {
            launchBlocker(packageName, restriction)
        }
    }

    private fun launchBlocker(packageName: String, restriction: RestrictionResult) {
        Log.i("DigitalBalanceService", "Restricting $packageName: ${restriction.reason}")

        val intent = Intent(this, BlockerActivity::class.java).apply {
            putExtra(BlockerActivity.EXTRA_PACKAGE_NAME, packageName)
            putExtra(BlockerActivity.EXTRA_RULE_ID, restriction.ruleId)
            putExtra(BlockerActivity.EXTRA_RULE_NAME, restriction.ruleName)
            putExtra(BlockerActivity.EXTRA_REASON, restriction.reason)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        startActivity(intent)
    }

    override fun onDestroy() {
        periodicChecker?.let { mainHandler.removeCallbacks(it) }
        super.onDestroy()
    }

    override fun onInterrupt() {
        Log.w("DigitalBalanceService", "AccessibilityService interrupted")
    }
}
