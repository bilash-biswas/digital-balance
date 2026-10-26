# Technical Architecture Document
## Digital Balance — Android & Flutter Engineering Architecture

---

### 1. Architecture Overview & Principles
Digital Balance adheres to **Clean Architecture** combined with a strict **Local-First Reactive Data Flow**. The system isolates platform-specific Android hardware/OS APIs from the cross-platform presentation and domain logic, communicating exclusively over strongly typed asynchronous MethodChannels.

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

---

### 2. Layer Structure & Responsibilities

#### 2.1 Presentation Layer (`lib/features/`, `lib/app/`)
- **State Management**: Built with `flutter_riverpod`. All dependencies, database handles, and repositories are injected via top-level `Provider` and `StateNotifierProvider` instances.
- **Declarative Navigation**: Managed by `go_router` via a `StatefulShellRoute.indexedStack` containing 5 primary tab branches:
  1. `/dashboard` — Today's screen time, goal gauge, quick focus action, top apps, unlock stats.
  2. `/analytics` — Weekly/monthly trends, bar charts, category breakdowns via `fl_chart`.
  3. `/focus` — Deep-work Pomodoro configuration and active session launcher.
  4. `/rules` — App restriction list, daily limits, scheduled blackout windows.
  5. `/you` — Personal hub, habits, routines, insights history, backup/restore, settings.
  Modal and detail routes are anchored directly to the root navigator (`_rootNavigatorKey`).
- **Theming**: Strict Material 3 design system (`AppTheme`, `AppColors`) supporting seamless dynamic Light, Dark, and System modes with consistent 20px card border radii and custom elevation schemes.

#### 2.2 Data Layer (`lib/data/`)
- **Persistence Engine**: `drift` (v2.24+) generating SQLite bindings via `build_runner`.
- **Database Schema**: 18 normalized tables structured with composite primary keys (`{date, packageName}` and `{date, hourOfDay}`) allowing atomic `insertOnConflictUpdate` upserts during telemetry synchronization.
- **Repositories**: Encapsulate Drift table DAOs and coordinate data synchronization:
  - `UsageRepository`: Ingests and aggregates raw app usage events into daily/hourly buckets.
  - `CatalogRepository`: Caches installed application metadata, app names, icons, and system classifications.
  - `RestrictionRepository`: Manages restriction rules, targets, and pushes active policy snapshots to the native enforcement engine.
  - `FocusRepository`: Tracks active and completed deep-work sessions.
  - `HabitRepository` & `RoutineRepository`: Maintains daily completion checklists and computes consecutive streaks.
  - `InsightRepository`: Stores deterministic local behavioral recommendations.
  - `SettingsRepository`: Stores key-value user preferences.
  - `BackupService`: Serializes the entire SQLite database into SHA-256 verified JSON structures.

#### 2.3 Platform Bridge (`lib/core/platform/`)
- **`PlatformBridge`**: Encapsulates Flutter-to-Android binary messaging.
  - Channel `com.example.digitalbalance/usage`:
    - `getPermissionStatus`: Returns boolean map (`usageAccess`, `notification`, `accessibility`, `exactAlarm`).
    - `openUsageSettings`, `openAccessibilitySettings`, `openNotificationSettings`, `openExactAlarmSettings`: Dispatches Android settings intents.
    - `getInstalledApps`: Retrieves installed applications with label and system-app flags.
    - `queryUsage`: Queries `UsageStatsManager` for foreground times, last used timestamps, and unlock counts.
  - Channel `com.example.digitalbalance/enforcement`:
    - `syncRestrictionRules`: Pushes the current list of active app package restrictions and daily limits to the native coordinator.
    - `grantTemporaryOverride`: Temporarily whitelists a package for 5 minutes.
    - `schedulePeriodicSync`: Configures Android `WorkManager` periodic background synchronization.

---

### 3. Native Android Kotlin Architecture

```
android/app/src/main/kotlin/com/example/digitalbalance/digital_balance/
├── bridge/
│   ├── UsagePlatformBridge.kt           # MethodCallHandler for usage & permissions
│   └── EnforcementPlatformBridge.kt     # MethodCallHandler for rules & overrides
├── permissions/
│   ├── PermissionStatusReader.kt        # AppOpsManager & NotificationManager checks
│   └── PermissionSettingsLauncher.kt    # Explicit system Intent dispatcher
├── usage/
│   ├── UsageStatsReader.kt              # Queries UsageStatsManager & UsageEvents
│   └── UsageEventMapper.kt              # Calculates foreground durations & unlocks
├── enforcement/
│   ├── RestrictionPolicy.kt             # Data classes for rule models & overrides
│   ├── EnforcementCoordinator.kt        # In-memory policy cache & evaluator singleton
│   ├── DigitalBalanceAccessibilityService.kt # Window transition monitor
│   └── BlockerActivity.kt               # Native fullscreen blocking dialog
└── scheduling/
    ├── DailySyncWorker.kt               # WorkManager CoroutineWorker for telemetry sync
    ├── WorkManagerScheduler.kt          # Enqueues periodic & daily background jobs
    ├── BootReceiver.kt                  # Re-arms workers on device restart
    └── TimeChangeReceiver.kt            # Re-evaluates schedules on timezone shifts
```

#### 3.1 Telemetry Engine (`UsageStatsReader.kt` & `UsageEventMapper.kt`)
- Queries `UsageStatsManager.queryEvents(startTimeMs, endTimeMs)`.
- Scans chronological system events:
  - `UsageEvents.Event.ACTIVITY_RESUMED` (TYPE 1): Starts active session timer for package.
  - `UsageEvents.Event.ACTIVITY_PAUSED` (TYPE 2): Commits elapsed time to package accumulator.
  - `UsageEvents.Event.SCREEN_INTERACTIVE` (TYPE 15) & `KEYGUARD_HIDDEN` (TYPE 18): Increments device unlock tally.
- Gracefully falls back to `UsageStatsManager.queryUsageStats(INTERVAL_BEST, startTimeMs, endTimeMs)` when system event access is restricted or throttled.

#### 3.2 Enforcement Engine (`DigitalBalanceAccessibilityService.kt`)
- Subclasses Android `AccessibilityService` configured with `accessibility_service_config.xml`.
- Event filter restricted strictly to `AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED`.
- Evaluates foreground window package against `EnforcementCoordinator`:
  1. Checks if package is the current default system launcher or Digital Balance itself (whitelisted).
  2. Evaluates active temporary overrides (grants 5-minute cooldown grace period).
  3. Evaluates scheduled restriction time windows (supports both daytime and overnight cross-midnight windows).
  4. If restricted, launches `BlockerActivity` with `FLAG_ACTIVITY_NEW_TASK | FLAG_ACTIVITY_CLEAR_TOP`.

#### 3.3 Intervention Overlay (`BlockerActivity.kt`)
- Pure native Kotlin Activity styled with `Theme.Material3.DayNight.NoActionBar`.
- Displays application name, reason for restriction, and scheduled blackout hours.
- Actions:
  - **Return to Home Screen**: Dispatches `Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)`.
  - **5-Minute Temporary Override**: Calls `EnforcementCoordinator.grantTemporaryOverride(pkg)` and finishes activity, allowing brief urgent usage.

#### 3.4 Background Worker & Recovery (`DailySyncWorker.kt`, `BootReceiver.kt`)
- `DailySyncWorker`: A `CoroutineWorker` scheduled every 6 hours via Android `WorkManager` with `NetworkType.NOT_REQUIRED` and `RequiresBatteryNotLow`.
- `BootReceiver`: Listens for `ACTION_BOOT_COMPLETED` and `ACTION_MY_PACKAGE_REPLACED` to guarantee background sync tasks persist across device power cycles.
- `TimeChangeReceiver`: Listens for `ACTION_TIMEZONE_CHANGED` and `ACTION_TIME_CHANGED` to re-align scheduled restriction windows.

---

### 4. Concurrency & Threading Model
- **Dart Main Isolate**: Handles UI rendering and reactive Riverpod updates.
- **Drift SQLite Isolates**: Database queries execute asynchronously via native SQLite bindings without blocking Flutter frame rendering.
- **Kotlin Background Dispatchers**:
  - `UsageStatsReader`: Executes queries on `Dispatchers.IO` to ensure smooth UI responsiveness across the MethodChannel bridge.
  - `AccessibilityService`: Evaluates rules synchronously in-memory (O(1) set lookup) within the window event callback to prevent race conditions before the target app displays private contents.
