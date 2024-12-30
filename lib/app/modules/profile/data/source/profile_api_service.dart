import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';

class ProfileApiService {
  final MyHttpClient httpClient;

  ProfileApiService({required this.httpClient});

  Future<dynamic> updateUser(ProfileUser body) async {
    try {
      Map<String, dynamic> data = body.toJson();
      final uid = body.uid;
      final response = await httpClient.put('/users/update/$uid', data: data);

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
}
