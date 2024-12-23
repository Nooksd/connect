import 'package:connect/app/core/services/database/my_local_storage.dart';

class AuthStorageService {
  final MyLocalStorage localStorage;

  AuthStorageService({required this.localStorage});

  Future<void> saveAuthData(String accessToken, String refreshToken, Map<String, dynamic> user) async {
    await localStorage.set('access_token', accessToken);
    await localStorage.set('refresh_token', refreshToken);
    await localStorage.set('user', user);
  }

  Future<String?> getAccessToken() async {
    return await localStorage.get('access_token');
  }

  Future<String?> getRefreshToken() async {
    return await localStorage.get('refresh_token');
  }

  Future<Map<String, dynamic>?> getUser() async {
    return await localStorage.get('user');
  }

  Future<void> clearAuthData() async {
    await localStorage.remove('access_token');
    await localStorage.remove('refresh_token');
    await localStorage.remove('user');
  }
}
