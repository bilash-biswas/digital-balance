# Privacy Policy & Data Sovereignty Manifesto
## Digital Balance — Complete Privacy and Data Protection Disclosure

*Effective Date: October 12, 2026*

---

### 1. Fundamental Privacy Commitment
Digital Balance was designed from first principles under a single, non-negotiable architectural rule: **Your digital wellbeing data belongs to you and no one else.**

- **Zero Accounts**: You will never be asked to create an account, log in with Google, or provide an email address.
- **Zero Cloud Servers**: Digital Balance maintains no remote database, cloud sync server, or telemetry backend.
- **Zero Advertising or Trackers**: There are no advertising SDKs, tracking libraries, or diagnostic telemetry tools embedded within this application.
- **Zero Internet Permission**: The application's `AndroidManifest.xml` does not request the `android.permission.INTERNET` permission. The operating system actively prevents this app from opening network sockets.

---

### 2. Operating System Permissions & Data Utilization

#### 2.1 Android Usage Access (`PACKAGE_USAGE_STATS`)
- **What is accessed**: The system's `UsageStatsManager` provides foreground application timestamps, duration aggregates, and screen interactive events.
- **Why it is needed**: To calculate your daily screen time, show hourly breakdowns, and rank your most-used applications.
- **Where it is stored**: Processed data is stored exclusively in a private SQLite database on your physical device.

#### 2.2 Android Accessibility Service (`BIND_ACCESSIBILITY_SERVICE`)
- **What is accessed**: Only the package name of the active foreground window (`AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED`).
- **What is NEVER accessed**: Digital Balance **never** reads screen text, never accesses form fields, never monitors keystrokes, and never captures passwords or messages.
- **Why it is needed**: To immediately display the intervention blocker screen when you open an application that you have scheduled to restrict.

#### 2.3 Notifications (`POST_NOTIFICATIONS`)
- **Why it is needed**: To deliver scheduled focus session completion alerts, daily habit reminders, and optional screen-time limit warnings.

---

### 3. Data Retention & User Sovereignty

#### 3.1 On-Device Storage
All application catalogs, usage history, restriction policies, focus session logs, and habit streaks are stored in your device's private app directory:
`/data/data/com.example.digitalbalance/databases/digital_balance.sqlite`

#### 3.2 Offline Backups & Export
You may generate an unencrypted or encrypted offline JSON backup file at any time. This file is stored in your device's public Downloads directory under your direct control.

#### 3.3 Zero-Trace Cryptographic Erasure
In **Settings & Preferences > Danger Zone**, you may trigger **Zero-Trace Data Deletion**. This operation instantly:
1. Executes an atomic `DROP TABLE` on all 18 database entities.
2. Clears all shared preference key-value stores.
3. Deletes temporary cache directories.
4. Resets the application state to factory defaults.

---

### 4. Children’s Privacy
Digital Balance does not collect or transmit personal information from anyone, including children under the age of 13.

---

### 5. Open-Source Verification & Auditability
Because Digital Balance is built on transparent, auditable code, security and privacy researchers may verify these commitments directly by reviewing the source code repository and reproducing release builds.
