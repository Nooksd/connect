import 'package:connect/app/modules/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(
      String email, String password, bool keepLoggedIn);
  Future<AppUser?> isLoggedIn();
  Future<void> logout();
}
