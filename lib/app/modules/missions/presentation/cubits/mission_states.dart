import 'package:connect/app/modules/missions/domain/entities/mission.dart';

abstract class MissionState {
  get missions => null;
}

class MissionInitial extends MissionState {}

class MissionLoading extends MissionState {}

class MissionsLoaded extends MissionState {
  @override
  final List<Mission> missions;

  MissionsLoaded(this.missions);
}

class MissionError extends MissionState {
  final String message;

  MissionError(this.message);
}
