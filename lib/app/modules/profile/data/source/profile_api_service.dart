import 'dart:convert';

import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';

class ProfileApiService {
  final MyHttpClient httpClient;

  ProfileApiService({required this.httpClient});

  Future<void> updateUser(ProfileUser body) async {
    try {
      Map<String, dynamic> data = body.toJson();
      final uid = body.uid;
      final response = await httpClient.post('/users/update/$uid', data: data);

      // return response as Map<String, dynamic>;

      print('/users/update/$uid: $response');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
