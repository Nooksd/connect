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
      final newAccessToken = response['access_token'];
      final newRefreshToken = response['refresh_token'];
      final userData = response['user'];

      await authStorageService.saveAuthData(
          newAccessToken, newRefreshToken, userData);

      return AppUser.fromMap({
        'access_token': newAccessToken,
        'refresh_token': newRefreshToken,
        'user': userData,
      });
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final accessToken = await authStorageService.getAccessToken();
      if (accessToken != null) {
        final user = await authStorageService.getUser();
        return AppUser.fromMap({
          'access_token': accessToken,
          'refresh_token': await authStorageService.getRefreshToken(),
          'user': user,
        });
      }

      final response = await authApiService.getCurrentUser();


      if (response == null) {
        final newAccessToken = response['access_token']; 
        final newRefreshToken = response['refresh_token'];
        final userData = response['user'];

        await authStorageService.saveAuthData(
            newAccessToken, newRefreshToken, userData);

        return AppUser.fromMap({
          'access_token': newAccessToken,
          'refresh_token': newRefreshToken,
          'user': userData,
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
