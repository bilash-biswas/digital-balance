import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../platform/platform_bridge.dart';

class PermissionState {
  final bool usageAccess;
  final bool notifications;
  final bool accessibility;
  final bool exactAlarm;
  final bool isLoading;

  const PermissionState({
    this.usageAccess = false,
    this.notifications = false,
    this.accessibility = false,
    this.exactAlarm = false,
    this.isLoading = false,
  });

  PermissionState copyWith({
    bool? usageAccess,
    bool? notifications,
    bool? accessibility,
    bool? exactAlarm,
    bool? isLoading,
  }) {
    return PermissionState(
      usageAccess: usageAccess ?? this.usageAccess,
      notifications: notifications ?? this.notifications,
      accessibility: accessibility ?? this.accessibility,
      exactAlarm: exactAlarm ?? this.exactAlarm,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PermissionNotifier extends StateNotifier<PermissionState> {
  final PlatformBridge _bridge;

  PermissionNotifier(this._bridge)
    : super(const PermissionState(isLoading: true)) {
    refreshPermissions();
  }

  Future<void> refreshPermissions() async {
    state = state.copyWith(isLoading: true);
    final statuses = await _bridge.getPermissionStatuses();
    state = PermissionState(
      usageAccess: statuses['usageAccess'] ?? false,
      notifications: statuses['notifications'] ?? false,
      accessibility: statuses['accessibility'] ?? false,
      exactAlarm: statuses['exactAlarm'] ?? false,
      isLoading: false,
    );
  }

  Future<bool> openUsageSettings() async {
    final opened = await _bridge.openUsageSettings();
    await refreshPermissions();
    return opened;
  }

  Future<bool> openAccessibilitySettings() async {
    final opened = await _bridge.openAccessibilitySettings();
    await refreshPermissions();
    return opened;
  }

  Future<bool> openNotificationSettings() async {
    final opened = await _bridge.openNotificationSettings();
    await refreshPermissions();
    return opened;
  }

  Future<bool> openExactAlarmSettings() async {
    final opened = await _bridge.openExactAlarmSettings();
    await refreshPermissions();
    return opened;
  }
}

final platformBridgeProvider = Provider<PlatformBridge>((ref) {
  return PlatformBridge();
});

final permissionsProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>((ref) {
      final bridge = ref.watch(platformBridgeProvider);
      return PermissionNotifier(bridge);
    });
