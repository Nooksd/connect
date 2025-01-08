import 'package:connect/app/modules/missions/domain/repos/mission_repo.dart';
import 'package:connect/app/modules/missions/presentation/cubits/mission_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionCubit extends Cubit<MissionState> {
  final MissionRepo missionRepo;

  MissionCubit({required this.missionRepo}) : super(MissionInitial());

  Future<void> getMissions() async {
    emit(MissionLoading());

    try {
      final missions = await missionRepo.getMissions();

      if (missions.isNotEmpty) {
        emit(MissionsLoaded(missions));
      } else {
        emit(MissionError("Nehuma missão encontrada"));
      }
    } catch (e) {
      emit(MissionError(e.toString()));
    }
  }
}
