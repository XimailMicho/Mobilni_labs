import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permission granted');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('User tapped notification: ${details.payload}');
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'daily_recipe_channel',
      'Daily Recipe Notifications',
      description: 'Notifications for daily random recipes',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    String? token = await _messaging.getToken();
    print('FCM Token: $token');
  }

  Future<void> scheduleDailyNotification() async {
    try {
      final androidImpl = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl != null) {
        final canScheduleExactAlarms = await androidImpl.canScheduleExactNotifications() ?? false;

        if (!canScheduleExactAlarms) {
          print('Requesting exact alarm permission...');
          await androidImpl.requestExactAlarmsPermission();
        } else {
          print('Exact alarm permission already granted');
        }
      }

      final scheduledTime = _nextInstanceOfTime(11, 0);

      print('Current time: ${tz.TZDateTime.now(tz.local)}');
      print('Next notification scheduled for: $scheduledTime');

      await _localNotifications.zonedSchedule(
        0,
        'Daily Recipe Reminder',
        'Check out today\'s random recipe!',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_recipe_channel',
            'Daily Recipe Notifications',
            channelDescription: 'Notifications for daily random recipes',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('Notification scheduled successfully');
      await _logPendingNotifications();
    } catch (e) {
      print('Failed to schedule notification: $e');
      await showImmediateNotification();
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> showImmediateNotification() async {
    await _localNotifications.show(
      1,
      'Daily Recipe Reminder',
      'Check out today\'s random recipe!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe_channel',
          'Daily Recipe Notifications',
          channelDescription: 'Notifications for daily random recipes',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> _logPendingNotifications() async {
    final pending = await _localNotifications.pendingNotificationRequests();
    print('Total pending notifications: ${pending.length}');
    for (var notification in pending) {
      print('ID: ${notification.id}, Title: ${notification.title}');
    }
  }
}