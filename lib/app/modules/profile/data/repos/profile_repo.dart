import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';
import 'package:connect/app/modules/profile/domain/repos/profile_repo.dart';

class MongoProfileRepo implements ProfileRepo {
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // TODO: implement
      throw UnimplementedError();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(ProfileUser updatedProfileUser) async {
    try {
      //  TODO: implement
      throw UnimplementedError();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateCoins(ProfileUser updatedProfileUser) async {
    try {
      // TODO: implement
      throw UnimplementedError();
    } catch (e) {
      throw Exception(e);
    }
  }
}
