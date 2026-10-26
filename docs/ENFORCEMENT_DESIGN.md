# App Restriction Enforcement Engine
## Digital Balance — Native Android Window Monitoring & Intervention Design

---

### 1. Architectural Strategy & Alternatives Evaluated

Enforcing application restrictions on Android presents unique platform constraints:
1. **UsageStatsManager Alone**: Polling `UsageStatsManager` provides deferred telemetry (events may be delayed by several seconds or minutes). It is fundamentally incapable of providing deterministic real-time application interception.
2. **ActivityManager.getRunningTasks()**: Deprecated since Android 5.0 (Lollipop) and returns only the calling application's task.
3. **AccessibilityService Window Transitions**: Listening to `AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED` provides real-time event delivery (<50ms latency) upon application launch, allowing immediate presentation of an intervention overlay before the user interacts with the restricted app.

**Conclusion**: Digital Balance uses an in-memory `AccessibilityService` event listener paired with `UsageStatsManager` for long-term historical analytics.

---

### 2. The Enforcement Pipeline

```
  ┌─────────────────────────┐
  │ User Opens YouTube App  │
  └────────────┬────────────┘
               │ Window State Changed Event
  ┌────────────▼────────────────────────────────────────┐
  │ DigitalBalanceAccessibilityService.kt               │
  │ event.packageName = "com.google.android.youtube"    │
  └────────────┬────────────────────────────────────────┘
               │ Evaluates In-Memory Policy
  ┌────────────▼────────────────────────────────────────┐
  │ EnforcementCoordinator.shouldBlockPackage(...)      │
  │ 1. Is Default Launcher?         ──► NO              │
  │ 2. Is Self (Digital Balance)?   ──► NO              │
  │ 3. Is Temporary Override Active?──► NO              │
  │ 4. Is Schedule Window Active?   ──► YES (22:00-06:00)│
  └────────────┬────────────────────────────────────────┘
               │ Policy Triggered: Launch Intervention
  ┌────────────▼────────────────────────────────────────┐
  │ Native BlockerActivity.kt (FLAG_ACTIVITY_NEW_TASK)  │
  │ Displays: "YouTube is Restricted"                   │
  │ Options: [Go to Home] | [5-Min Emergency Override]  │
  └─────────────────────────────────────────────────────┘
```

---

### 3. Schedule Evaluation Algorithm

A common pitfall in Android wellbeing apps is failing to handle schedules that cross midnight (e.g., 22:00 to 06:00). Digital Balance implements a dedicated schedule evaluator in both Kotlin (`EnforcementCoordinator.kt`) and Dart (`RestrictionScheduleEvaluator`):

```kotlin
fun isTimeWithinWindow(currentMinutes: Int, startMinutes: Int, endMinutes: Int): Boolean {
    return if (startMinutes <= endMinutes) {
        // Standard Daytime Window (e.g. 09:00 to 17:00 => 540 to 1020)
        currentMinutes in startMinutes..endMinutes
    } else {
        // Overnight Window Crossing Midnight (e.g. 22:00 to 06:00 => 1320 to 360)
        currentMinutes >= startMinutes || currentMinutes <= endMinutes
    }
}
```

This mathematical guarantee ensures that night-time blackout rules function accurately across all hours of sleep.

---

### 4. Intervention Overlay (`BlockerActivity.kt`)

The intervention screen is intentionally implemented as a **pure native Android Activity** rather than a Flutter route:
- **Instantaneous Launch Time**: A native activity displays in <100ms without waiting for Flutter engine initialization or route transitions.
- **Intent Flags**: Launched with `Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP`, immediately displacing the restricted application into the background.
- **User Actions**:
  - **Return Home**: Dispatches an intent to the system launcher (`Intent.CATEGORY_HOME`), returning the user to safety.
  - **5-Minute Temporary Override**: Calls `EnforcementCoordinator.grantTemporaryOverride(pkg, 5 * 60 * 1000L)`. Once granted, `BlockerActivity` finishes, and the user is granted temporary access for urgent needs.

---

### 5. Intentional Friction & Overrides
To prevent mindless repetitive overriding:
1. **Mandatory Cooldown**: Overrides cannot be stacked. Once the 5 minutes expire, the app is instantly re-blocked.
2. **Optional Biometric Confirmation**: Users can toggle biometric authentication in Settings, requiring a fingerprint or face scan before an override is approved.
3. **Reflection Prompt**: The blocker screen requires reading a short intentional reminder ("Take a breath. Is opening this app intentional right now?") before the override button is activated.

---

### 6. Edge Case Handling & System Resilience
- **Launcher Detection**: On initialization, `EnforcementCoordinator` dynamically queries `PackageManager.resolveActivity(Intent(ACTION_MAIN, CATEGORY_HOME))` to identify the device's default launcher, guaranteeing that the home screen is never accidentally blocked.
- **Emergency Dialing**: System phone dialers (`com.android.dialer`, `com.google.android.dialer`, `com.samsung.android.dialer`) and emergency components are permanently exempt from blocking.
- **Reboot Persistence**: `BootReceiver` restores in-memory restriction rules and workers immediately after a device restart.
- **Timezone Shifts**: `TimeChangeReceiver` invalidates cached daily minute offsets whenever the device changes timezone or adjusts for daylight saving time.
