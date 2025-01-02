import 'dart:convert';

import 'package:connect/app/core/services/database/my_local_storage.dart';

class AuthStorageService {
  final MyLocalStorage localStorage;

  AuthStorageService({required this.localStorage});

  Future<void> saveAuthData(
    String accessToken,
    String refreshToken,
    Map<String, dynamic> user,
  ) async {
    await localStorage.set('accessToken', accessToken);
    await localStorage.set('refreshToken', refreshToken);
    await localStorage.set('user', jsonEncode(user));
  }

  Future<String?> getAccessToken() async {
    return await localStorage.get('accessToken');
  }

  Future<void> saveAccessToken(String accessToken) async {
    await localStorage.set('accessToken', accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await localStorage.get('refreshToken');
  }

  Future<String?> getUser() async {
    return await localStorage.get('user');
  }

  Future<void> clearAuthData() async {
    await localStorage.remove('accessToken');
    await localStorage.remove('refreshToken');
    await localStorage.remove('user');
  }
}
