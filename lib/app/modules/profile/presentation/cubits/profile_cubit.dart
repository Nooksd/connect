import 'dart:io';
import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';
import 'package:connect/app/modules/profile/domain/repos/profile_repo.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileUser? _currentUser;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  ProfileUser? get currentUser => _currentUser;

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

  Future<void> getSelfProfile() async {
    try {
      emit(ProfileLoading());

      final user = await profileRepo.getSelfProfile();

      if (user != null) {
        _currentUser = user;
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("Usuário não encontrado"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> getUpdatedSelfProfile() async {
    try {
      emit(ProfileLoading());
      final updatedUser = await profileRepo.getUpdatedSelfProfile();

      if (updatedUser != null) {
        _currentUser = updatedUser;
        emit(ProfileLoaded(updatedUser));
      } else {
        emit(ProfileError("Usuário não encontrado"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    File? newProfilePictureUrl,
    String? newFacebookUrl,
    String? newInstagramUrl,
    String? newLinkedinUrl,
  }) async {
    emit(ProfileLoading());

    try {
      final currentUser = await profileRepo.getSelfProfile();

      if (currentUser == null) {
        emit(ProfileError('Falha ao atualizar perfil'));
        return;
      }

      final updatedProfile = currentUser.updateData(
        newFacebookUrl: newFacebookUrl ?? currentUser.facebookUrl,
        newInstagramUrl: newInstagramUrl ?? currentUser.instagramUrl,
        newLinkedinUrl: newLinkedinUrl ?? currentUser.linkedinUrl,
      );

      await profileRepo.updateUserProfile(updatedProfile, newProfilePictureUrl);

      await getSelfProfile();
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void clearProfile() {
    _currentUser = null;
    emit(ProfileInitial());
  }
}
