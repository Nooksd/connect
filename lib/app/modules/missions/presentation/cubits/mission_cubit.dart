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

  Future<bool> verifyCompletion(String missionId) async {
    try {
      final response = await missionRepo.verifyCompletion(missionId);

      if (response) {
        return true;
      }
      
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> sendValidation(String missionId, String url) async {
    try {
      final response = await missionRepo.sendValidation(missionId, url);

      if (response) {
        return true;
      }
      
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }
}
