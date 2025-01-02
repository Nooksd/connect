import 'dart:convert';
import 'dart:io';

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
  Future<void> updateUserProfile(ProfileUser updatedProfileUser, File? avatar) async {
    try {
      final response = await profileApiService.updateUser(updatedProfileUser, avatar);
      final userData = response["data"]["user"];

      if (userData == null) {
        return;
      }
      await profileStorageService.setuser(userData);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ProfileUser?> getSelfProfile() async {
    try {
      final user = await profileStorageService.getUser();
      final userData = jsonDecode(user ?? "");

      if (user == null) {
        return null;
      }

      return ProfileUser.fromMap(userData);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ProfileUser?> getUpdatedSelfProfile() async {
    try {
      final response = await profileApiService.getCurrentUser();

      if (response['status'] == 200) {
        final data = response['data'];

        final userData = data['user'];

        await profileStorageService.setuser(userData);

        return ProfileUser.fromMap(userData);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
