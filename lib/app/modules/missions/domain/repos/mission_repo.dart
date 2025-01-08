import 'package:connect/app/modules/missions/domain/entities/mission.dart';

abstract class MissionRepo {
  Future<List<Mission>> getMissions();
  Future<bool> verifyCompletion(String missionId);
  Future<bool> sendValidation(String missionId, String url);
}
