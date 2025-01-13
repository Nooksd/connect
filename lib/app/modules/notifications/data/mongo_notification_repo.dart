import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/notifications/domain/entities/notification.dart';
import 'package:connect/app/modules/notifications/domain/repos/notification_repo.dart';

class MongoNotificationRepo implements NotificationRepo {
  MyHttpClient http;

  MongoNotificationRepo({required this.http});

  @override
  Future<List<Notification>> getNotifications() async {
    try {
      final response = await http.get('/notification/get-all');

      if (response["status"] == 200) {
        final data = response["data"]["notifications"];

        if (data is List) {
          final List<Notification> allNotifications = data
              .map((notification) =>
                  Notification.fromJson(notification as Map<String, dynamic>))
              .toList();

          return allNotifications;
        } else {
          throw Exception("O formato esperado da resposta é uma lista.");
        }
      }

      return Future.value([]);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> readNotification(String notificationId) async {
    try {
      final response = await http.put('/notification/read/$notificationId');

      print(response);

      if (response["status"] != 200) {
        throw Exception('Falha ao ler notificação');
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> registerDeviceToken(String deviceToken) async {
    try {
      final data = {'deviceToken': deviceToken};
      final response =
          await http.post('/notification/register-token', data: data);

      if (response["status"] != 200) {
       throw Exception('Falha ao salvar token');
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
