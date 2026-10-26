import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../logging/app_logger.dart';

class InstalledAppDto {
  final String packageName;
  final String appName;
  final bool isSystemApp;
  final String? category;

  const InstalledAppDto({
    required this.packageName,
    required this.appName,
    required this.isSystemApp,
    this.category,
  });

  factory InstalledAppDto.fromMap(Map<dynamic, dynamic> map) {
    return InstalledAppDto(
      packageName: map['packageName'] as String? ?? '',
      appName: map['appName'] as String? ?? '',
      isSystemApp: map['isSystemApp'] as bool? ?? false,
      category: map['category'] as String?,
    );
  }
}

class AppUsageDto {
  final String packageName;
  final String appName;
  final int foregroundTimeMs;
  final int lastTimeUsedMs;
  final int launchCount;

  const AppUsageDto({
    required this.packageName,
    required this.appName,
    required this.foregroundTimeMs,
    required this.lastTimeUsedMs,
    required this.launchCount,
  });

  factory AppUsageDto.fromMap(Map<dynamic, dynamic> map) {
    return AppUsageDto(
      packageName: map['packageName'] as String? ?? '',
      appName: map['appName'] as String? ?? '',
      foregroundTimeMs: (map['foregroundTimeMs'] as num?)?.toInt() ?? 0,
      lastTimeUsedMs: (map['lastTimeUsedMs'] as num?)?.toInt() ?? 0,
      launchCount: (map['launchCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class UsageResultDto {
  final bool success;
  final List<AppUsageDto> apps;
  final int deviceUnlocks;
  final int notificationCount;
  final List<int> hourlyForegroundTimeMs;
  final List<int> hourlyUnlocks;
  final String? error;

  const UsageResultDto({
    required this.success,
    required this.apps,
    required this.deviceUnlocks,
    this.notificationCount = 0,
    this.hourlyForegroundTimeMs = const [],
    this.hourlyUnlocks = const [],
    this.error,
  });

  factory UsageResultDto.fromMap(Map<dynamic, dynamic> map) {
    final rawApps = map['apps'] as List<dynamic>? ?? [];
    final apps = rawApps
        .map((e) => AppUsageDto.fromMap(e as Map<dynamic, dynamic>))
        .toList();

    final rawHourly = map['hourlyForegroundTimeMs'] as List<dynamic>? ?? [];
    final hourlyForeground = rawHourly.map((e) => (e as num).toInt()).toList();

    final rawUnlocks = map['hourlyUnlocks'] as List<dynamic>? ?? [];
    final hourlyUnlocks = rawUnlocks.map((e) => (e as num).toInt()).toList();

    return UsageResultDto(
      success: map['success'] as bool? ?? false,
      apps: apps,
      deviceUnlocks: (map['deviceUnlocks'] as num?)?.toInt() ?? 0,
      notificationCount: (map['notificationCount'] as num?)?.toInt() ?? 0,
      hourlyForegroundTimeMs: hourlyForeground,
      hourlyUnlocks: hourlyUnlocks,
      error: map['error'] as String?,
    );
  }
}

class PlatformBridge {
  static const MethodChannel _usageChannel = MethodChannel(
    AppConstants.usageChannel,
  );
  static const MethodChannel _enforcementChannel = MethodChannel(
    AppConstants.enforcementChannel,
  );

  // Permissions & Settings
  Future<Map<String, bool>> getPermissionStatuses() async {
    try {
      final res = await _usageChannel.invokeMapMethod<String, bool>(
        'getPermissionStatus',
      );
      return res ?? {};
    } catch (e, st) {
      AppLogger.error('Failed to get permission status', e, st);
      return {};
    }
  }

  Future<bool> openUsageSettings() async {
    try {
      final res = await _usageChannel.invokeMethod<bool>('openUsageSettings');
      return res ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> openAccessibilitySettings() async {
    try {
      final res = await _usageChannel.invokeMethod<bool>(
        'openAccessibilitySettings',
      );
      return res ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> openNotificationSettings([String? packageName]) async {
    try {
      final res = await _usageChannel.invokeMethod<bool>(
        'openNotificationSettings',
        packageName != null ? {'packageName': packageName} : null,
      );
      return res ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> openExactAlarmSettings() async {
    try {
      final res = await _usageChannel.invokeMethod<bool>(
        'openExactAlarmSettings',
      );
      return res ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> openAppSettings() async {
    try {
      final res = await _usageChannel.invokeMethod<bool>('openAppSettings');
      return res ?? false;
    } catch (e) {
      return false;
    }
  }

  // App Catalog & Usage
  Future<List<InstalledAppDto>> getInstalledApplications() async {
    try {
      final List<dynamic>? res = await _usageChannel.invokeListMethod<dynamic>(
        'getInstalledApplications',
      );
      if (res == null) return [];
      return res
          .map((item) => InstalledAppDto.fromMap(item as Map<dynamic, dynamic>))
          .toList();
    } catch (e, st) {
      AppLogger.error('Failed to get installed apps', e, st);
      return [];
    }
  }

  Future<Uint8List?> getAppIcon(String packageName) async {
    try {
      final res = await _usageChannel.invokeMethod<Uint8List>('getAppIcon', {
        'packageName': packageName,
      });
      return res;
    } catch (_) {
      return null;
    }
  }

  Future<UsageResultDto> queryUsage({
    required int startTimeMs,
    required int endTimeMs,
  }) async {
    try {
      final res = await _usageChannel.invokeMapMethod<dynamic, dynamic>(
        'queryUsage',
        {'startTime': startTimeMs, 'endTime': endTimeMs},
      );
      if (res == null) {
        return const UsageResultDto(
          success: false,
          apps: [],
          deviceUnlocks: 0,
          error: 'Null response from platform',
        );
      }
      return UsageResultDto.fromMap(res);
    } catch (e, st) {
      AppLogger.error('Failed to query usage stats', e, st);
      return UsageResultDto(
        success: false,
        apps: const [],
        deviceUnlocks: 0,
        error: e.toString(),
      );
    }
  }

  // Enforcement
  Future<bool> syncRules(String policiesJson) async {
    try {
      final res = await _enforcementChannel.invokeMethod<bool>('syncRules', {
        'policiesJson': policiesJson,
      });
      return res ?? false;
    } catch (e, st) {
      AppLogger.error('Failed to sync rules to native', e, st);
      return false;
    }
  }

  Future<bool> grantOverride({
    required String packageName,
    required String ruleId,
    required int durationMinutes,
  }) async {
    try {
      final res = await _enforcementChannel
          .invokeMethod<bool>('grantOverride', {
            'packageName': packageName,
            'ruleId': ruleId,
            'durationMinutes': durationMinutes,
          });
      return res ?? false;
    } catch (e, st) {
      AppLogger.error('Failed to grant override', e, st);
      return false;
    }
  }

  Future<Map<String, dynamic>> getEnforcementStatus() async {
    try {
      final res = await _enforcementChannel.invokeMapMethod<String, dynamic>(
        'getEnforcementStatus',
      );
      return res ?? {};
    } catch (e) {
      return {};
    }
  }

  Future<bool> schedulePeriodicSync() async {
    try {
      final res = await _enforcementChannel.invokeMethod<bool>(
        'schedulePeriodicSync',
      );
      return res ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> installApk(String filePath) async {
    try {
      final res = await _usageChannel.invokeMethod<bool>('installApk', {
        'filePath': filePath,
      });
      return res ?? false;
    } catch (e, st) {
      AppLogger.error('Failed to trigger APK install', e, st);
      return false;
    }
  }

  Future<bool> canRequestPackageInstalls() async {
    try {
      final res = await _usageChannel.invokeMethod<bool>(
        'canRequestPackageInstalls',
      );
      return res ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<bool> openManageUnknownAppSources() async {
    try {
      final res = await _usageChannel.invokeMethod<bool>(
        'openManageUnknownAppSources',
      );
      return res ?? false;
    } catch (_) {
      return false;
    }
  }
}
