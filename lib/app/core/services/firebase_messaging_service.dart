import 'package:connect/app/core/services/notification_service.dart';
import 'package:connect/app/modules/notifications/presentation/cubits/noification_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FirebaseMessagingService {
  final NotificationService notificationService;

  FirebaseMessagingService({required this.notificationService});

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
  }

  getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    final NotificationCubit notificationCubit =
        Modular.get<NotificationCubit>();

    if (token != null) {
      await notificationCubit.registerDeviceToken(token);
    }
  }

  _onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        notificationService.showNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: message.data["route"] ?? "",
          ),
        );
      }
    });
  }

  _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((_goToPageAfterMessage));
  }

  _goToPageAfterMessage(RemoteMessage message) {
    final String route = message.data["route"] ?? "/notifications";
    if (route.isNotEmpty) {
      Modular.to.pushNamed(route);
    }
  }
}
