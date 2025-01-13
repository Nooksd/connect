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

  @override
  Future<bool> verifyCompletion(String missionId) async {
    try {
      final response = await http.get('/mission/verify-completion/$missionId');

      if (response["status"] == 200) {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> sendValidation(String missionId, String url) async {
    try {
      final data = {
        "missionId": missionId,
        "url": url,
      };
      final response = await http.post('/validation/create', data: data);


      if (response["status"] == 200) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
