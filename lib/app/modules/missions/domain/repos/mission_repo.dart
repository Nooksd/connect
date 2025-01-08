import 'package:connect/app/modules/missions/domain/entities/mission.dart';

abstract class MissionRepo {
  Future<List<Mission>> getMissions();
}
