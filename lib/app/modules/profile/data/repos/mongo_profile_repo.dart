import 'package:connect/app/modules/profile/data/source/profile_api_service.dart';
import 'package:connect/app/modules/profile/data/source/profile_storage_service.dart';
import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';
import 'package:connect/app/modules/profile/domain/repos/profile_repo.dart';

class MongoProfileRepo implements ProfileRepo {
  final ProfileApiService authApiService;
  final ProfileStorageService authStorageService;

  MongoProfileRepo(
      {required this.authApiService, required this.authStorageService});

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

  @override
  Future<ProfileUser?> getSelfProfile() async {
    try {
      // TODO: implement
      throw UnimplementedError();
    } catch (e) {
      throw Exception(e);
    }
  }
}
