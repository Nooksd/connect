import 'dart:convert';
import 'dart:io';

import 'package:connect/app/core/services/storage/my_local_storage.dart';
import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';
import 'package:connect/app/modules/profile/domain/repos/profile_repo.dart';

class MongoProfileRepo implements ProfileRepo {
  MyHttpClient http;
  MyLocalStorage storage;

  MongoProfileRepo({required this.http, required this.storage});

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final response = await http.get('/users/$uid');

      if (response["status"] == 200) {
        final user = response['data'];

        return ProfileUser.fromMap(user);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(ProfileUser body, File? avatar) async {
    try {
      Map<String, dynamic> data = body.toJson();
      final uid = body.uid;
      final response = await http.put('/users/update/$uid', data: data);

      if (avatar != null) {
        await _uploadAvatar(uid, avatar);
      }

      final userData = response["data"]["user"];

      if (userData == null) {
        return;
      }
      await storage.set('user', jsonEncode(userData));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ProfileUser?> getSelfProfile() async {
    try {
      final user = await storage.get('user');
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
      final response = await http.get('/users/get-current-user');

      if (response['status'] == 200) {
        final data = response['data'];

        final userData = data['user'];

        await storage.set('user', jsonEncode(userData));

        return ProfileUser.fromMap(userData);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> _uploadAvatar(String uid, File avatar) async {
    try {
      final Map<String, dynamic> body = {"avatar": avatar};
      await http.multiPart("/avatar/upload/$uid", body: body);
    } catch (e) {
      throw Exception('Error uploading avatar: $e');
    }
  }
}
