class AppConstants {
  static const String appName = 'Digital Balance';
  static const String appVersion = '1.0.6';
  static const int schemaVersion = 1;

  // Platform Channels
  static const String usageChannel = 'com.example.digitalbalance/usage';
  static const String enforcementChannel =
      'com.example.digitalbalance/enforcement';

  // Default Presets
  static const int defaultDailyGoalMinutes = 180; // 3 hours
  static const int defaultFocusMinutes = 25; // 25 min Pomodoro
  static const int defaultShortBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;
  static const int defaultOverrideGraceMinutes = 5;

  // Notification Channel IDs
  static const String notifChannelReminders = 'digital_balance_reminders';
  static const String notifChannelFocus = 'digital_balance_focus';
  static const String notifChannelLimits = 'digital_balance_limits';
  static const String notifChannelRoutines = 'digital_balance_routines';
}
