# Production Release Checklist & Store Compliance
## Digital Balance — Android Release Engineering & Google Play Submission

---

### 1. Release Build Configuration

#### 1.1 Android Keystore Generation
Generate a cryptographically secure upload key using Java `keytool`:
```bash
keytool -genkey -v -keystore digital_balance_upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias digital_balance_key
```

#### 1.2 `android/key.properties` (Do NOT commit to Git)
Create `android/key.properties` with appropriate permissions:
```properties
storePassword=SECURE_STORE_PASSWORD
keyPassword=SECURE_KEY_PASSWORD
keyAlias=digital_balance_key
storeFile=/path/to/digital_balance_upload.jks
```

#### 1.3 `android/app/build.gradle.kts` Signing Configuration
```kotlin
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

---

### 2. ProGuard & R8 Optimization Rules (`android/app/proguard-rules.pro`)
Ensure the following keep rules are declared:
```proguard
# Flutter Engine & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Drift SQLite native bindings
-keep class com.simonoid.** { *; }

# WorkManager Workers
-keep class * extends androidx.work.Worker { *; }
-keep class * extends androidx.work.CoroutineWorker { *; }

# Digital Balance Native Services & Receivers
-keep class com.example.digitalbalance.digital_balance.enforcement.** { *; }
-keep class com.example.digitalbalance.digital_balance.scheduling.** { *; }
```

---

### 3. Google Play Console Declarations

#### 3.1 Data Safety Section
- **Data Collection**: Select **NO** (Digital Balance collects zero data across all categories: Location, Personal Info, Financial Info, Health, Messages, Photos, Audio, Files, Calendar, Contacts, App activity, Web browsing, App info and performance, Device or other IDs).
- **Data Sharing**: Select **NO** (No data is transferred to any third party).
- **Encryption in Transit**: Select **N/A** (No data is transmitted over the internet).
- **Deletion Request URL**: Provide a link to the open-source repository or state that zero-trace deletion is built directly into the app's settings.

#### 3.2 Accessibility Service Declaration & Video Demonstration
- Google Play requires a YouTube video demonstrating the user flow for apps utilizing `AccessibilityService`.
- **Declaration Text**:
  > "Digital Balance uses Android's AccessibilityService API exclusively for the digital wellbeing feature of app restriction and focus enforcement. The service detects when user-restricted applications enter the foreground to display an intentional intervention screen. The app does not access, read, or transmit any screen contents, keystrokes, or personal data."

---

### 4. OEM Battery Optimization Guidance
Certain Android original equipment manufacturers (OEMs)—such as Xiaomi (MIUI/HyperOS), Samsung (One UI), Huawei (EMUI), and OnePlus (OxygenOS)—enforce aggressive background process killing that can terminate `AccessibilityService` or delay `WorkManager` workers.

**Recommended User Guidance**:
- Instruct users on custom Android skins to lock Digital Balance in their Recent Apps carousel.
- Direct users to set Battery Optimization to **"Unrestricted"** for Digital Balance in device settings (`Settings > Apps > Digital Balance > Battery > Unrestricted`).
