import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import '../../../core/constants/app_constants.dart';
import '../../../core/logging/app_logger.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        AppLogger.info(
          'Notification clicked with payload: ${response.payload}',
        );
      },
    );

    // Create Notification Channels for Android 8.0+
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.notifChannelFocus,
          'Focus Sessions',
          description: 'Focus timer alerts and interval notifications',
          importance: Importance.high,
          playSound: true,
        ),
      );

      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.notifChannelLimits,
          'App Limits & Warnings',
          description: 'Alerts when approaching daily application limits',
          importance: Importance.high,
          playSound: true,
        ),
      );

      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.notifChannelReminders,
          'Daily Reminders',
          description: 'Routines and habit reminders',
          importance: Importance.defaultImportance,
        ),
      );
    }

    _isInitialized = true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? channelId,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId ?? AppConstants.notifChannelReminders,
      'Digital Balance',
      channelDescription: 'Digital wellbeing notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }

  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
