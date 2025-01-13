import 'package:connect/app/modules/notifications/domain/entities/notification.dart';

abstract class NotificationState {
  get notifications => null;
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  @override
  final List<Notification> notifications;

  NotificationsLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
