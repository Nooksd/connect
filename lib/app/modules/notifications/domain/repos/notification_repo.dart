import 'package:connect/app/modules/notifications/domain/entities/notification.dart';

abstract class NotificationRepo {
  Future<List<Notification>> getNotifications();
  Future<void> readNotification(String notificationId);
  Future<void> registerDeviceToken(String deviceToken);
}
