import 'package:connect/features/profile/domain/repos/profile_repo.dart';
import 'package:connect/features/profile/presentation/cubits/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("Usuário não encontrado"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? newProfilePictureUrl,
    String? newFacebookUrl,
    String? newInstagramUrl,
    String? newLinkedinUrl,
  }) async {
    emit(ProfileLoading());

    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError('Falha ao atualizar perfil'));
        return;
      }

      final updatedProfile = currentUser.updateData(
        newFacebookUrl: newFacebookUrl ?? currentUser.facebookUrl,
        newInstagramUrl: newInstagramUrl ?? currentUser.instagramUrl,
        newLinkedinUrl: newLinkedinUrl ?? currentUser.linkedinUrl,
      );

      await profileRepo.updateUserProfile(updatedProfile);

      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
