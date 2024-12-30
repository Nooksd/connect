import 'dart:convert';

import 'package:connect/app/modules/auth/data/source/auth_api_service.dart';
import 'package:connect/app/modules/auth/data/source/auth_storage_service.dart';
import 'package:connect/app/modules/auth/domain/entities/app_user.dart';
import 'package:connect/app/modules/auth/domain/repos/auth_repo.dart';

class MongoAuthRepo implements AuthRepo {
  final AuthApiService authApiService;
  final AuthStorageService authStorageService;

  MongoAuthRepo(
      {required this.authApiService, required this.authStorageService});

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      final response = await authApiService.login(email, password);

      if (response['status'] == 200) {
        final data = response['data'];

        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];
        final userData = data['user'];

        await authStorageService.saveAuthData(
            newAccessToken, newRefreshToken, userData);

        return AppUser.fromMap({
          'name': userData['name'],
          'email': userData['email'],
          'id': userData['id'],
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<AppUser?> isLoggedIn() async {
    try {
      final user = await authStorageService.getUser();
      final token = await authStorageService.getAccessToken();

      final userData = user is String ? jsonDecode(user) : null;

      if (user != null && token != null) {
        return AppUser.fromMap({
          'name': userData['name'],
          'email': userData['email'],
          'id': userData['id'],
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch current user: $e');
    }
  }

  @override
  Future<void> logout() async {
    await authStorageService.clearAuthData();
  }
}
