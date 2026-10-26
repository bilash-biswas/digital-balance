package com.example.digitalbalance.digital_balance

import com.example.digitalbalance.digital_balance.bridge.EnforcementPlatformBridge
import com.example.digitalbalance.digital_balance.bridge.UsagePlatformBridge
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private var usageBridge: UsagePlatformBridge? = null
    private var enforcementBridge: EnforcementPlatformBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        usageBridge = UsagePlatformBridge(this, flutterEngine.dartExecutor.binaryMessenger)
        enforcementBridge = EnforcementPlatformBridge(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        usageBridge?.teardown()
        enforcementBridge?.teardown()
        usageBridge = null
        enforcementBridge = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
