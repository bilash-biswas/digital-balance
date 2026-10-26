package com.example.digitalbalance.digital_balance.enforcement

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity

class BlockerActivity : AppCompatActivity() {

    companion object {
        const val EXTRA_PACKAGE_NAME = "extra_package_name"
        const val EXTRA_RULE_ID = "extra_rule_id"
        const val EXTRA_RULE_NAME = "extra_rule_name"
        const val EXTRA_REASON = "extra_reason"
    }

    private var targetPackage: String = ""
    private var ruleId: String = ""
    private var ruleName: String = ""
    private var reason: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        extractIntent(intent)
        if (shouldDismissForPackage(targetPackage)) {
            finish()
            return
        }

        // Handle back button: return to device home rather than popping to blocked app
        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                navigateToHome()
            }
        })

        buildUi()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        extractIntent(intent)
        if (shouldDismissForPackage(targetPackage)) {
            finish()
            return
        }
        buildUi()
    }

    private fun extractIntent(intent: Intent) {
        targetPackage = intent.getStringExtra(EXTRA_PACKAGE_NAME) ?: ""
        ruleId = intent.getStringExtra(EXTRA_RULE_ID) ?: ""
        ruleName = intent.getStringExtra(EXTRA_RULE_NAME) ?: "Digital Balance"
        reason = intent.getStringExtra(EXTRA_REASON) ?: "Application is currently restricted."
    }

    private fun shouldDismissForPackage(pkg: String): Boolean {
        if (pkg.isEmpty()) return true
        val coordinator = EnforcementCoordinator.getInstance(this)
        return coordinator.isEssentialPackage(pkg)
    }

    private fun buildUi() {
        val rootLayout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setBackgroundColor(Color.parseColor("#111318"))
            setPadding(64, 96, 64, 96)
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        }

        // App Icon or Shield Placeholder
        val iconView = ImageView(this).apply {
            val appIcon = try {
                packageManager.getApplicationIcon(targetPackage)
            } catch (_: Exception) {
                null
            }
            if (appIcon != null) {
                setImageDrawable(appIcon)
            } else {
                setImageResource(android.R.drawable.ic_lock_idle_lock)
            }
            layoutParams = LinearLayout.LayoutParams(160, 160).apply {
                bottomMargin = 48
            }
        }
        rootLayout.addView(iconView)

        // App Name Label
        val appName = try {
            val info = packageManager.getApplicationInfo(targetPackage, 0)
            packageManager.getApplicationLabel(info).toString()
        } catch (_: Exception) {
            targetPackage
        }

        val appNameView = TextView(this).apply {
            text = appName
            textSize = 24f
            setTextColor(Color.parseColor("#E2E2E9"))
            typeface = Typeface.DEFAULT_BOLD
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 16
            }
        }
        rootLayout.addView(appNameView)

        // Title: Take a breath
        val titleView = TextView(this).apply {
            text = "Take a breath"
            textSize = 28f
            setTextColor(Color.parseColor("#ADC6FF"))
            typeface = Typeface.DEFAULT_BOLD
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 24
            }
        }
        rootLayout.addView(titleView)

        // Description / Reason
        val descView = TextView(this).apply {
            text = "$ruleName\n$reason"
            textSize = 16f
            setTextColor(Color.parseColor("#C4C6D0"))
            gravity = Gravity.CENTER
            setLineSpacing(12f, 1f)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 80
            }
        }
        rootLayout.addView(descView)

        // Button 1: Return Home (Primary)
        val homeButton = Button(this).apply {
            text = "Return Home"
            setTextColor(Color.parseColor("#001B3F"))
            textSize = 16f
            typeface = Typeface.DEFAULT_BOLD
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#ADC6FF"))
                cornerRadius = 32f
            }
            setPadding(48, 32, 48, 32)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 24
            }
            setOnClickListener {
                navigateToHome()
            }
        }
        rootLayout.addView(homeButton)

        // Button 2: Unlock for 5 Minutes (Secondary Outline)
        val overrideButton = Button(this).apply {
            text = "Unlock for 5 Minutes"
            setTextColor(Color.parseColor("#ADC6FF"))
            textSize = 15f
            background = GradientDrawable().apply {
                setColor(Color.TRANSPARENT)
                setStroke(2, Color.parseColor("#8E9099"))
                cornerRadius = 32f
            }
            setPadding(48, 28, 48, 28)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            setOnClickListener {
                onUnlockClicked(appName)
            }
        }
        rootLayout.addView(overrideButton)

        setContentView(rootLayout)
    }

    private fun onUnlockClicked(appName: String) {
        val prefs = getSharedPreferences("digital_balance_enforcement_prefs", Context.MODE_PRIVATE)
        val biometricRequired = prefs.getBoolean("biometric_override_enabled", false)

        if (biometricRequired && androidx.biometric.BiometricManager.from(this).canAuthenticate(
                androidx.biometric.BiometricManager.Authenticators.BIOMETRIC_STRONG or
                androidx.biometric.BiometricManager.Authenticators.DEVICE_CREDENTIAL
            ) == androidx.biometric.BiometricManager.BIOMETRIC_SUCCESS
        ) {
            val executor = androidx.core.content.ContextCompat.getMainExecutor(this)
            val prompt = androidx.biometric.BiometricPrompt(
                this,
                executor,
                object : androidx.biometric.BiometricPrompt.AuthenticationCallback() {
                    override fun onAuthenticationSucceeded(result: androidx.biometric.BiometricPrompt.AuthenticationResult) {
                        super.onAuthenticationSucceeded(result)
                        unlockTemporarily()
                    }
                }
            )
            val promptInfo = androidx.biometric.BiometricPrompt.PromptInfo.Builder()
                .setTitle("Unlock App")
                .setSubtitle("Authenticate to unlock $appName for 5 minutes")
                .setAllowedAuthenticators(
                    androidx.biometric.BiometricManager.Authenticators.BIOMETRIC_STRONG or
                    androidx.biometric.BiometricManager.Authenticators.DEVICE_CREDENTIAL
                )
                .build()
            prompt.authenticate(promptInfo)
        } else {
            unlockTemporarily()
        }
    }

    private fun navigateToHome() {
        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED
        }
        startActivity(homeIntent)
        finish()
    }

    private fun unlockTemporarily() {
        if (targetPackage.isNotEmpty()) {
            EnforcementCoordinator.getInstance(this).grantOverride(targetPackage, ruleId, 5)
        }
        finish()
    }
}
