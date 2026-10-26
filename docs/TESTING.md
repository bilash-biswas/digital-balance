# Automated Testing Strategy & Quality Assurance
## Digital Balance — Test Matrix, Mocking Patterns & Verification Guide

---

### 1. Test Architecture Overview

Digital Balance enforces a multi-tier test architecture to guarantee algorithmic correctness, database transactional safety, and UI resilience without relying on live device hardware during automated CI runs.

```
┌─────────────────────────────────────────────────────────────┐
│                      WIDGET TESTS                           │
│   (Screen Rendering, Component Interactions, Navigation)    │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                    REPOSITORY & DATABASE                    │
│   (In-Memory SQLite via Drift NativeDatabase.memory())      │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                      PURE UNIT TESTS                        │
│   (Habit Streaks, Schedule Evaluator, SHA-256 Checksums)    │
└─────────────────────────────────────────────────────────────┘
```

---

### 2. Test Suite Breakdown

#### 2.1 Pure Unit Tests (`test/unit/`)
1. **`formatters_test.dart`**:
   - Validates minute-to-hour duration string conversions (`formatDurationMinutes`).
   - Validates millisecond-to-human duration formatting (`formatDurationMs`).
   - Validates 12-hour/24-hour time-of-day calculations (`formatMinuteOfDay`).
   - Validates full date representations across month boundaries.
2. **`habit_streak_test.dart`**:
   - Tests streak calculator across consecutive calendar days.
   - Verifies handling of "completed today" vs "completed yesterday".
   - Verifies that missed days accurately reset the current streak to 0 while preserving the longest streak record.
3. **`restriction_schedule_test.dart`**:
   - Validates daytime restriction windows (e.g. 09:00 to 17:00).
   - Validates complex overnight restriction windows crossing midnight (e.g. 22:30 to 06:30).
   - Confirms edge values at the exact boundary minute.
4. **`backup_test.dart`**:
   - Computes SHA-256 checksums over JSON payloads.
   - Confirms that tampered payloads are detected and rejected.

#### 2.2 In-Memory Database Tests (`test/repositories/`)
- **`database_test.dart`**:
  - Instantiates `AppDatabase.forTesting(NativeDatabase.memory())`.
  - Tests `AppCatalog` insertion, lookup, and exclusion filtering.
  - Tests `UsageDaily` composite primary key (`date`, `packageName`) upsert behavior via `insertOnConflictUpdate`.
  - Tests foreign key cascading from `RestrictionRules` to `RestrictionTargets`.
  - Tests key-value retrieval in `UserSettings`.

#### 2.3 Widget & Presentation Tests (`test/widgets/`, `test/`)
- **`screens_widget_test.dart`**:
  - Tests `BalanceCard` custom theming, rounded borders, and tap callbacks with `Material` ancestry.
  - Tests `PermissionGuardCard` banner warning and interactive settings launcher.
  - Tests `PrivacyPolicyScreen` zero-cloud sections and local-first disclosure.
  - Tests `SettingsScreen` async state initialization, theme selector, and scrolling to dangerous wipe actions.
  - Tests `OnboardingScreen` PageView progression, welcome text, and button transitions.
- **`widget_test.dart`**:
  - Root application smoke test running `DigitalBalanceApp`.
  - Demonstrates mock binary messenger registration for `com.example.digitalbalance/usage` and `com.example.digitalbalance/enforcement`.
  - Demonstrates proper unmount and pump flushing for Drift's background `StreamQueryStore` debounce timers.

---

### 3. Execution Commands

#### Run Full Test Suite
```bash
flutter test
```

#### Run Specific Test Target
```bash
flutter test test/unit/habit_streak_test.dart
flutter test test/repositories/database_test.dart
flutter test test/widgets/screens_widget_test.dart
```

#### Run Static Code Analysis
```bash
flutter analyze
```

#### Run Dart Code Formatting Check
```bash
dart format --output=none --set-exit-if-changed .
```
