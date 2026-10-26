# Product Requirements Document (PRD)
## Digital Balance — Local-First Android Wellbeing & Intentional Screen-Time

---

### 1. Executive Summary & Product Vision
**Digital Balance** is a production-grade, local-first Android digital wellbeing and productivity application built with Flutter and Kotlin. It empowers users to understand their device habits, eliminate unconscious screen-time spirals, protect focus sessions, and maintain healthy digital routines—without surrendering privacy to cloud servers or account systems.

#### Core Value Proposition
- **100% Local-First & Zero-Cloud**: No accounts, no sign-ins, no tracking SDKs, no cloud databases. All usage data, restriction configurations, and habit histories remain exclusively on the user's physical device in an encrypted/private SQLite database.
- **Accurate Platform Telemetry**: Built upon real Android system APIs (`UsageStatsManager`, `UsageEvents`) rather than fabricated counters or superficial timers.
- **Reliable Restriction Enforcement**: Active restriction enforcement using an Android `AccessibilityService` window monitor paired with a full-screen native `BlockerActivity` intervention.
- **Nonjudgmental Tone**: Mindful, supportive design language avoiding guilt, shame-based gamification, or coercive streaks.

---

### 2. Target Audience & Personas
1. **The Deep-Work Professional**: Needs uninterrupted 25-60 minute focus blocks without social media interruptions or notification pull.
2. **The Mindful Device User**: Seeks transparent visibility into daily screen time, app launch frequencies, and hourly usage distributions to curtail late-night browsing.
3. **The Privacy-Conscious Individual**: Desires modern digital wellbeing analytics but strictly refuses to send application usage statistics or location/telemetry data to third-party cloud servers.

---

### 3. Key Feature Modules & Functional Requirements

#### 3.1 Onboarding & Transparent Permissions
- **Multi-Step Onboarding**: Welcome walkthrough, privacy guarantee explanation, daily screen-time target selection (default: 180 min), and granular permission guidance.
- **Permission Transparency**: Explains *why* Android requires Usage Access (`PACKAGE_USAGE_STATS`), Notifications (`POST_NOTIFICATIONS`), and Accessibility (`BIND_ACCESSIBILITY_SERVICE`) before launching system intent dialogs.
- **Graceful Degradation**: Clear visual status indicators when permissions are missing with direct recovery links to system settings.

#### 3.2 Dashboard & Real-Time Overview
- **Daily Screen Time Metric**: High-precision sum of foreground application durations for the current calendar day against the user's target.
- **Comparison Analytics**: Delta calculation against yesterday's screen time.
- **Unlock & Launch Counters**: Device unlock frequency and application launch counts derived from `UsageEvents`.
- **Top Applications Carousel**: Visual breakdown of the most-used apps with high-resolution iconography and exact minute tallies.
- **Category Distribution**: Visual chart displaying time spent across Social, Entertainment, Productivity, Games, Education, Communication, and Utilities.
- **Quick Actions**: One-tap access to Quick Focus (25m), App Rules, Catalog categorization, and Routine checklists.

#### 3.3 Application Catalog & Categorization
- **Installed App Discovery**: Discovers user-installed non-system applications and active system launchers using Android `PackageManager`.
- **Custom Categorization**: Users can override default heuristic categories to personalize reports.
- **Exclusion Filters**: Ability to exclude specific utility apps (e.g., GPS navigation, dialer, clock) from daily screen-time calculations.

#### 3.4 Deep-Work Focus Mode
- **Customizable Intervals**: Configurable focus sessions (15m, 25m, 45m, 60m, 90m) with dedicated Pomodoro break intervals.
- **Distraction Shielding**: Temporary strict blocking of distracting application packages during active focus sessions.
- **Active Session HUD**: Fullscreen persistent countdown timer with ambient completion chime, pause/resume capability, and reflective early exit prompts.

#### 3.5 App Restrictions & Scheduling
- **Daily Usage Limits**: Per-app or per-category daily time caps (e.g., 45 minutes on Instagram).
- **Time Windows**: Scheduled restriction windows (e.g., Block YouTube from 09:00 to 17:00).
- **Overnight Schedules**: Cross-midnight scheduling support (e.g., Block TikTok from 22:30 to 07:00).
- **Active Enforcement**: Instant overlay intervention via native `BlockerActivity` when a restricted app enters the foreground.
- **Friction-Based Overrides**: 5-minute temporary override with mandatory cooldown and optional biometric authentication (fingerprint/face).

#### 3.6 Routines & Habit Tracking
- **Daily Digital Routines**: Pre-sleep wind-down routines and morning intentionality routines with recurring weekday/weekend filters.
- **Habit Streaks**: Consecutive completion streaks calculated on local calendar dates, resilient to timezone changes.

#### 3.7 Local Deterministic Insights
- **Heuristic Engine**: Computes actionable advice locally without machine learning cloud dependencies:
  - Morning vs. Night ratio analysis.
  - Social media surge warnings (>20% increase day-over-day).
  - Goal achievement milestones and habit consistency acknowledgments.

#### 3.8 Data Sovereignty & Portability
- **JSON Backup & Restore**: Full transactional export of all 18 database tables with SHA-256 integrity checksum verification.
- **CSV Export**: Human-readable spreadsheets of daily usage aggregates.
- **Zero-Trace Wipe**: Instant cryptographic erasure of all local databases, shared preferences, and caches.

---

### 4. Non-Functional Requirements
- **Performance**: App startup time under 1.2s cold start. Database queries capped under 16ms to guarantee 60/120fps UI rendering.
- **Battery Impact**: Periodic background usage synchronization executed via `WorkManager` with battery-not-low constraints. Accessibility service event filter strictly restricted to `TYPE_WINDOW_STATE_CHANGED`.
- **Security & Privacy**: Zero network permissions declared in `AndroidManifest.xml` (no `<uses-permission android:name="android.permission.INTERNET"/>`).
- **Compatibility**: Android 8.0 (API Level 26) through Android 15 (API Level 35+).
- **Architecture**: Clean Architecture with Flutter Riverpod state management, Drift SQLite persistence, and Kotlin platform channels.
