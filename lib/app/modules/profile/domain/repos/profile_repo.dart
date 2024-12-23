import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateUserProfile(ProfileUser updatedProfileUser);
  Future<void> updateCoins(ProfileUser updatedProfileUser);
}
