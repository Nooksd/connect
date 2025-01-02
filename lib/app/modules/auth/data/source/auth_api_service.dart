import 'package:connect/app/core/services/http/my_http_client.dart';
import 'dart:convert';

class AuthApiService {
  final MyHttpClient httpClient;

  AuthApiService({required this.httpClient});

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final body = {
        'email': email,
        'password': password,
      };
      final data = jsonEncode(body);
      final response = await httpClient.post('/auth/login', data: data);

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
