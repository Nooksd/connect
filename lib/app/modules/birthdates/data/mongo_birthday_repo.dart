import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/birthdates/domain/entities/birthday.dart';
import 'package:connect/app/modules/birthdates/domain/repos/birthday_repo.dart';

class MongoBirthdayRepo implements BirthdayRepo {
  MyHttpClient http;

  MongoBirthdayRepo({required this.http});

  @override
  Future<List<Birthday>> getBirthdays() async {
    try {
      final response = await http.get('/users/birthdays');

      if (response["status"] == 200) {
        final data = response["data"]["birthdays"];

        if (data is List) {
          final List<Birthday> allBirthdays = data
              .map((birthday) =>
                  Birthday.fromJson(birthday as Map<String, dynamic>))
              .toList();
          return allBirthdays;
        } else {
          throw Exception("O formato esperado da resposta é uma lista.");
        }
      }

      return Future.value([]);
    } catch (e) {
      throw Exception(e);
    }
  }
}
