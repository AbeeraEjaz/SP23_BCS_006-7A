import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request permission for Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Android initialization
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> scheduleNotification(Task task) async {
    if (task.dueDate.isBefore(DateTime.now())) return;

    // Calculate notification time (30 minutes before due time)
    final notificationTime = task.dueDate.subtract(const Duration(minutes: 30));
    
    // Don't schedule if notification time is in the past
    if (notificationTime.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      channelDescription: 'Notifications for task reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      task.id!,
      'Task Reminder',
      'Task "${task.title}" is due in 30 minutes!',
      notificationTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    
    print("📅 Notification scheduled for task: ${task.title} at $notificationTime");
  }

  Future<void> cancelNotification(int taskId) async {
    await _notifications.cancel(taskId);
    print("🔕 Notification cancelled for task ID: $taskId");
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print("🔕 All notifications cancelled");
  }
}