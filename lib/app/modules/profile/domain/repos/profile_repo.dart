import 'dart:io';

import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<ProfileUser?> getSelfProfile();
  Future<ProfileUser?> getUpdatedSelfProfile();
  Future<void> updateUserProfile(ProfileUser updatedProfileUser, File? avatar);
}
