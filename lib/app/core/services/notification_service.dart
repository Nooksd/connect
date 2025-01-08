import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({required this.id, this.title, this.body, this.payload});
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidPlatformChannelSpecifics;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setUpNotifications();
  }

  _setUpNotifications() async {
    await _initializeNotifications();
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await localNotificationsPlugin.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null && notificationResponse.payload!.isNotEmpty) {
      Modular.to.pushNamed(notificationResponse.payload!);
    }
  }

  showNotification(CustomNotification notification) async {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'notifications_innova',
      'notifications_innova',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    await localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      payload: notification.payload,
    );
  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      final notificationResponse = details.notificationResponse;
      if (notificationResponse?.payload != null) {
        _onDidReceiveNotificationResponse(notificationResponse!);
      }
    }
  }
}
