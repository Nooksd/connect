import 'package:connect/app/modules/notifications/domain/repos/notification_repo.dart';
import 'package:connect/app/modules/notifications/presentation/cubits/notification_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo notificationRepo;

  NotificationCubit({required this.notificationRepo})
      : super(NotificationInitial());

  Future<void> getNotifications() async {
    emit(NotificationLoading());

    try {
      final notifications = await notificationRepo.getNotifications();

      if (notifications.isNotEmpty) {
        emit(NotificationsLoaded(notifications));
      } else {
        emit(NotificationError("Nehuma notificação encontrada"));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> readNotification(String notificationId) async {
    await notificationRepo.readNotification(notificationId);
  }

  Future<void> registerDeviceToken(String deviceToken) async {
    await notificationRepo.registerDeviceToken(deviceToken);
  }
}
