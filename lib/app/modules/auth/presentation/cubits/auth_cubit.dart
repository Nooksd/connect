import 'package:connect/app/modules/auth/domain/entities/app_user.dart';
import 'package:connect/app/modules/auth/domain/repos/auth_repo.dart';
import 'package:connect/app/modules/auth/presentation/cubits/auth_states.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  void checkAuth() async {
    final AppUser? user = await authRepo.isLoggedIn();

    if (user != null) {
      _currentUser = user;
      emit(AuthInitial());
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  AppUser? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());

      final user = await authRepo.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError("Email ou senha incorretos"));
      emit(Unauthenticated());
    }
  }

  Future<void> logout() async {
    await authRepo.logout();
    _currentUser = null;

    final profileCubit = Modular.get<ProfileCubit>();
    profileCubit.clearProfile();

    emit(Unauthenticated());
    Modular.to.navigate('/');
  }

}
