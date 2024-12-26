import 'package:connect/app/core/custom/splash_screen.dart';
import 'package:connect/app/core/services/database/shared_preferences_client.dart';
import 'package:connect/app/core/services/http/dio_client.dart';
import 'package:connect/app/modules/auth/auth_module.dart';
import 'package:connect/app/modules/auth/data/repos/mongo_auth_repo.dart';
import 'package:connect/app/modules/auth/data/source/auth_api_service.dart';
import 'package:connect/app/modules/auth/data/source/auth_storage_service.dart';
import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/navigation/navigation_module.dart';
import 'package:connect/app/modules/settings/settings_module.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => DioClient(localStorage: i())),
    Bind.singleton((i) => SharedPreferencesClient()),
    Bind.singleton((i) => AuthApiService(httpClient: i())),
    Bind.singleton((i) => AuthStorageService(localStorage: i())),
    Bind.singleton(
        (i) => MongoAuthRepo(authApiService: i(), authStorageService: i())),
    Bind.singleton((i) => AuthCubit(authRepo: i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => BlocProvider.value(
        value: Modular.get<AuthCubit>()..checkAuth(),
        child: const SplashScreen(),
      ),
    ),
    ModuleRoute('/auth', module: AuthModule()),
    ModuleRoute('/navigator', module: NavigationModule()),
    ModuleRoute('/settings', module: SettingsModule()),
  ];
}
