// import 'package:connect/app/modules/profile/data/source/profile_api_service.dart';
import 'dart:convert';

import 'package:connect/app/modules/profile/data/source/profile_api_service.dart';
import 'package:connect/app/modules/profile/data/source/profile_storage_service.dart';
import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';
import 'package:connect/app/modules/profile/domain/repos/profile_repo.dart';

class MongoProfileRepo implements ProfileRepo {
  final ProfileApiService profileApiService;
  final ProfileStorageService profileStorageService;

  MongoProfileRepo({
    required this.profileApiService,
    required this.profileStorageService,
  });

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
      await profileApiService.updateUser(updatedProfileUser);
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
      final user = await profileStorageService.getUser();

      if (user == null) {
        return null;
      }

      final data = jsonDecode(user);

      return ProfileUser.fromMap(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
