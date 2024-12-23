import 'package:connect/app/core/services/http/my_http_client.dart';

class AuthApiService {
  final MyHttpClient httpClient;

  AuthApiService({required this.httpClient});

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await httpClient.get('/users/login');
      return response as Map<String, dynamic>;
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
