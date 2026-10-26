# Android Platform Permissions & Compliance
## Digital Balance — Technical Documentation on Android System Privileges

---

### 1. Declared Permissions & Technical Justifications

Digital Balance adheres strictly to the principle of least privilege. The application intentionally requests **zero internet/network permissions** (`android.permission.INTERNET` is omitted from `AndroidManifest.xml`).

| Permission | Protection Level | Purpose & Technical Scope | Minimum API |
| :--- | :--- | :--- | :--- |
| `android.permission.PACKAGE_USAGE_STATS` | Special App Access | Required to query `UsageStatsManager` for foreground app durations, launch counts, and device unlock frequency. | API 21 (Android 5.0) |
| `android.permission.POST_NOTIFICATIONS` | Runtime Permission | Delivers focus session completion alerts, habit reminders, and daily goal limit warnings. | API 33 (Android 13) |
| `android.permission.BIND_ACCESSIBILITY_SERVICE` | Signature / System | Enables `DigitalBalanceAccessibilityService` to listen for foreground window transitions (`TYPE_WINDOW_STATE_CHANGED`) to enforce user-configured app restrictions. | API 26 (Android 8.0) |
| `android.permission.SCHEDULE_EXACT_ALARM` | Special Access / Normal | Schedules precise Pomodoro focus session completion chimes and morning/evening routine reminders. | API 31 (Android 12) |
| `android.permission.RECEIVE_BOOT_COMPLETED` | Normal | Re-arms WorkManager sync jobs and restriction policies immediately following device reboots. | API 26 (Android 8.0) |
| `android.permission.FOREGROUND_SERVICE` | Normal | Maintains high-priority state during active timed focus sessions to prevent OS killing. | API 28 (Android 9.0) |

---

### 2. Package Visibility (`<queries>`)
To discover installed user applications and display accurate app names and icons on Android 11+ (API 30+), `AndroidManifest.xml` declares:

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent>
</queries>
```

This scoped declaration restricts package queries solely to applications that expose a user-launchable main activity, avoiding the broad `QUERY_ALL_PACKAGES` permission and adhering strictly to Google Play Package Visibility Policies.

---

### 3. Permission Education & User Consent Flow

Never send users directly to Android Settings without prior context. Digital Balance implements a 2-step permission flow:

1. **In-App Educational Explanation**:
   - The user is presented with a clear, non-technical explanation in `PermissionGuardCard` or during the Onboarding flow.
   - Clarifies *what* data is read (app window packages and foreground time), *why* it is needed (to calculate usage and block selected apps), and *where* it is stored (100% locally on the device, never transmitted).
2. **Explicit Intent Dispatch**:
   - Upon explicit user tap, `PermissionSettingsLauncher.kt` dispatches the precise system settings intent:
     - Usage Access: `Settings.ACTION_USAGE_ACCESS_SETTINGS` (with package URI fallback).
     - Accessibility: `Settings.ACTION_ACCESSIBILITY_SETTINGS`.
     - Notifications: `Settings.ACTION_APP_NOTIFICATION_SETTINGS` with `EXTRA_APP_PACKAGE`.
     - Exact Alarms: `Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM`.

---

### 4. Google Play Policy Compliance: Accessibility Service

Google Play maintains rigorous guidelines regarding the usage of `AccessibilityService`. Digital Balance complies with these requirements via the following technical and procedural safeguards:

#### 4.1 Permitted Use Case
- Digital Balance utilizes `AccessibilityService` under the permitted category of **Digital Wellbeing & Parental Controls / Focus Management**.
- The service is solely used to identify the currently active foreground application package name to enforce user-requested restriction schedules and focus sessions.

#### 4.2 Technical Invariant Checklist
- [x] **No Screen Content Scraping**: The service inspects only `event.packageName`. It never reads `event.text`, inspects node hierarchies (`getRootInActiveWindow()`), or accesses web page contents.
- [x] **No Keystroke Monitoring**: Keylogging, text input inspection, and accessibility gesture injection are completely absent.
- [x] **No System Modification**: The service cannot disable system security settings or bypass lock screens.
- [x] **Scoped Event Types**: The `accessibility_service_config.xml` strictly declares:
  ```xml
  <accessibility-service
      android:accessibilityEventTypes="typeWindowStateChanged"
      android:accessibilityFeedbackType="feedbackGeneric"
      android:canRetrieveWindowContent="false"
      android:description="@string/accessibility_service_description" />
  ```

#### 4.3 Prominent In-App Disclosure
Before launching the Accessibility Settings screen, the app displays a modal dialog explicitly titled **"Accessibility Service Notice"**:
> "Digital Balance uses Android's Accessibility Service solely to detect when restricted applications enter the foreground so it can display the intervention blocker screen. Digital Balance does NOT read your screen text, monitor keystrokes, collect personal information, or share data with any third party."
