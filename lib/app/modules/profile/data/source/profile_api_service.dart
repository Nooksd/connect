import 'dart:io';

import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';

class ProfileApiService {
  final MyHttpClient httpClient;

  ProfileApiService({required this.httpClient});

  Future<dynamic> updateUser(ProfileUser body, File? avatar) async {
    try {
      Map<String, dynamic> data = body.toJson();
      final uid = body.uid;
      final response = await httpClient.put('/users/update/$uid', data: data);

      if (avatar != null) {
        await _uploadAvatar(uid, avatar);
      }

      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await httpClient.get('/users/get-current-user');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch current user: $e');
    }
  }

  Future<void> _uploadAvatar(String uid, File avatar) async {
    try {
      final Map<String, dynamic> body = {"avatar": avatar};
      await httpClient.multiPart("/avatar/upload/$uid", body: body);
    } catch (e) {
      throw Exception('Error uploading avatar: $e');
    }
  }
}
