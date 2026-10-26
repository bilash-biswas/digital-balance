# Digital Balance 🧘‍♂️📱

A production-grade, local-first Android digital wellbeing, screen-time management, focus productivity, and habit development application built with Flutter, Material 3, Drift SQLite, and Kotlin.

[![Flutter](https://img.shields.io/badge/Flutter-3.32.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.0-0175C2?logo=dart)](https://dart.dev)
[![Kotlin](https://img.shields.io/badge/Kotlin-Android%20Native-7F52FF?logo=kotlin)](https://kotlinlang.org)
[![Drift](https://img.shields.io/badge/Database-Drift%20SQLite-00599C?logo=sqlite)](https://drift.simonbinder.eu)
[![License](https://img.shields.io/badge/Privacy-100%25%20Local--First-2E7D32)](#privacy-policy--data-sovereignty)

---

## 🌟 Highlights & Philosophy

- **100% Local-First & Zero-Cloud**: No accounts, no sign-ins, no tracking SDKs, no cloud backends. All usage data, restriction configurations, and habit histories remain exclusively on your physical device.
- **Real Platform Telemetry**: Built on Android's `UsageStatsManager` and `UsageEvents` for high-precision screen-time and app launch calculations.
- **Active App Restrictions**: Enforced in real time via an Android `AccessibilityService` window monitor paired with a native `BlockerActivity` intervention.
- **Deep-Work Focus Timer**: Customizable Pomodoro focus sessions with temporary app shielding and ambient alerts.
- **Habit & Routine Development**: Daily bedtime and morning routines with consecutive completion streak calculation.
- **Data Sovereignty**: Full offline JSON backup & restore with SHA-256 cryptographic checksum verification, CSV export, and zero-trace data wipe.
- **Modern Material 3 UI**: Dynamic theme system supporting Light, Dark, and System modes with responsive charts and animations.

---

## 🏗 Architecture & Tech Stack

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUTTER PRESENTATION                     │
│  (Material 3, GoRouter Shell Navigation, Riverpod Providers)│
└──────────────────────────────┬──────────────────────────────┘
                               │ Watches / Dispatches
┌──────────────────────────────▼──────────────────────────────┐
│                    DOMAIN & APPLICATION                     │
│    (Habit Streaks, Schedule Evaluator, Insight Generator)   │
└──────────────────────────────┬──────────────────────────────┘
                               │ Reads / Writes
┌──────────────────────────────▼──────────────────────────────┐
│                    LOCAL DATA REPOSITORIES                  │
│       (Drift / SQLite Database - 18 Normalized Tables)       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Invokes / Receives
┌──────────────────────────────▼──────────────────────────────┐
│                   PLATFORM BRIDGE LAYER                     │
│    MethodChannels: 'usageChannel' & 'enforcementChannel'    │
└──────────────────────────────┬──────────────────────────────┘
                               │ Native IPC
┌──────────────────────────────▼──────────────────────────────┐
│                    NATIVE KOTLIN (ANDROID)                  │
│  - UsageStatsManager & UsageEvents (Telemetry Engine)       │
│  - DigitalBalanceAccessibilityService (Window Monitor)      │
│  - BlockerActivity (Intervention UI Overlay)                │
│  - WorkManager (DailySyncWorker & Periodic Sync)            │
│  - BroadcastReceivers (BootCompleted, TimeZoneChange)       │
└─────────────────────────────────────────────────────────────┘
```

### Flutter & Dart
- **Framework**: Flutter stable channel (v3.32.0+), Dart (v3.8.0+).
- **Design System**: Material 3 with adaptive light and dark palettes.
- **State Management**: `flutter_riverpod` (v2.6+).
- **Navigation**: `go_router` (v14.8+) with `StatefulShellRoute.indexedStack`.
- **Database**: `drift` & `drift_flutter` with SQLite.
- **Visualizations**: `fl_chart` for screen-time and hourly trend graphs.
- **Local Notifications**: `flutter_local_notifications` with timezone awareness.

### Android Native Layer
- **Language**: Kotlin.
- **Telemetry**: `UsageStatsManager` and `UsageEvents`.
- **Window Monitoring**: `DigitalBalanceAccessibilityService`.
- **Intervention UI**: Native `BlockerActivity`.
- **Background Jobs**: `WorkManager` `CoroutineWorker`.
- **Power & Time Recovery**: `BootReceiver` and `TimeChangeReceiver`.

---

## 📂 Repository Directory Structure

```
digital_balance/
├── android/
│   ├── app/src/main/
│   │   ├── AndroidManifest.xml          # Permissions, queries, service configs
│   │   ├── kotlin/.../digital_balance/
│   │   │   ├── bridge/                  # MethodChannel implementations
│   │   │   ├── permissions/             # AppOps & Intent launchers
│   │   │   ├── usage/                   # UsageStatsManager & event mapper
│   │   │   ├── enforcement/             # Window monitor, policies, BlockerActivity
│   │   │   └── scheduling/              # WorkManager sync & BroadcastReceivers
│   │   └── res/xml/
│   │       └── accessibility_service_config.xml
│   └── build.gradle.kts                 # Desugaring, NDK, SDK 35 config
├── lib/
│   ├── app/                             # Entry point, router, Riverpod providers, theme
│   ├── core/                            # Constants, formatters, permissions, widgets
│   ├── data/
│   │   ├── database/                    # Drift SQLite tables & generated schemas
│   │   ├── repositories/                # Clean Architecture repository implementations
│   │   └── backup/                      # SHA-256 JSON backup & CSV export
│   └── features/
│       ├── onboarding/                  # Multi-step welcome & permission guide
│       ├── dashboard/                   # Daily overview, donuts, quick focus
│       ├── analytics/                   # Weekly/monthly charts & category breakdown
│       ├── focus/                       # Pomodoro focus session & active HUD
│       ├── app_restrictions/            # Rule editor, daily limits, blackout windows
│       ├── app_catalog/                 # Installed app discovery & categorization
│       ├── habits/                      # Habit checklists & streak counters
│       ├── routines/                    # Morning & bedtime routine workflows
│       ├── insights/                    # Local deterministic behavioral tips
│       └── settings/                    # Hub, preferences, wipe, privacy policy
├── test/
│   ├── unit/                            # Pure unit tests (formatters, streaks, backup)
│   ├── repositories/                    # In-memory SQLite tests
│   └── widgets/                         # Presentation screen & widget tests
└── docs/                                # Full engineering & compliance documentation
    ├── PRD.md                           # Product Requirements Document
    ├── ARCHITECTURE.md                  # Detailed Technical Architecture
    ├── ANDROID_PERMISSIONS.md           # Permissions & Justifications
    ├── ENFORCEMENT_DESIGN.md            # Accessibility & BlockerActivity Engine
    ├── DATABASE_SCHEMA.md               # 18-Table SQLite Specification
    ├── PRIVACY_POLICY.md                # Privacy Policy & Data Sovereignty
    ├── TESTING.md                       # Test Strategy & Quality Assurance
    └── RELEASE_CHECKLIST.md             # Production Release & Google Play Guide
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.32.0`
- Android SDK 35 (compileSdk 35, minSdk 26)
- Android NDK `27.0.12077973`
- Java JDK 17

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/example/digital_balance.git
   cd digital_balance
   ```
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Generate Drift database code:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Run the debug app on an Android device or emulator:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Verification

The project includes a comprehensive automated test suite covering unit logic, database transactions, and presentation rendering.

### Run All Automated Tests
```bash
flutter test
```

### Static Analysis
Ensure zero lint issues, warnings, or formatting anomalies:
```bash
flutter analyze
dart format --output=none --set-exit-if-changed .
```

---

## 🛡 Privacy Policy & Data Sovereignty
Digital Balance is strictly **local-first**:
- No network requests are made.
- No third-party analytics SDKs are incorporated.
- Android's `AccessibilityService` is utilized strictly for foreground package detection—never for screen-scraping or keystroke recording.
- You can export a verified offline backup or execute a zero-trace data purge at any time.

See the complete [Privacy Policy](docs/PRIVACY_POLICY.md) for full legal and technical disclosures.

---

## 📚 Documentation Index
- [Product Requirements Document (PRD)](docs/PRD.md)
- [Technical Architecture](docs/ARCHITECTURE.md)
- [Android Permissions & Compliance](docs/ANDROID_PERMISSIONS.md)
- [Enforcement Engine Design](docs/ENFORCEMENT_DESIGN.md)
- [Database Schema (18 Tables)](docs/DATABASE_SCHEMA.md)
- [Privacy Policy & Manifesto](docs/PRIVACY_POLICY.md)
- [Testing Strategy & Test Plan](docs/TESTING.md)
- [Release Checklist & Store Submission](docs/RELEASE_CHECKLIST.md)
