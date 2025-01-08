import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/missions/domain/entities/mission.dart';
import 'package:connect/app/modules/missions/domain/repos/mission_repo.dart';

class MongoMissionRepo implements MissionRepo {
  MyHttpClient http;

  MongoMissionRepo({required this.http});

  @override
  Future<List<Mission>> getMissions() async {
    try {
      final response = await http.get('/mission/get-current');

      if (response["status"] == 200) {
        final data = response["data"]["missions"];

        if (data is List) {
          final List<Mission> allMissions = data
              .map((mission) =>
                  Mission.fromJson(mission as Map<String, dynamic>))
              .toList();

          return allMissions;
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
