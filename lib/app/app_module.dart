import 'package:connect/app/core/custom/splash_screen.dart';
import 'package:connect/app/core/services/database/shared_preferences_client.dart';
import 'package:connect/app/core/services/http/dio_client.dart';
import 'package:connect/app/modules/auth/auth_module.dart';
import 'package:connect/app/modules/auth/data/repos/mongo_auth_repo.dart';
import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/birthdates/birthdays_module.dart';
import 'package:connect/app/modules/contacts/contacts_module.dart';
import 'package:connect/app/modules/events/event_module.dart';
import 'package:connect/app/modules/navigation/navigation_module.dart';
import 'package:connect/app/modules/post/data/repos/mongo_post_repo.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_cubit.dart';
import 'package:connect/app/modules/post/presentation/pages/view_page.dart';
import 'package:connect/app/modules/profile/data/mongo_profile_repo.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/app/modules/profile/profile_module.dart';
import 'package:connect/app/modules/settings/settings_module.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => DioClient(storage: i())),
    Bind.singleton((i) => SharedPreferencesClient()),

    Bind.singleton((i) => AuthCubit(authRepo: i())),
    Bind.singleton((i) => MongoAuthRepo(http: i(), storage: i())),

    Bind.singleton((i) => PostCubit(postRepo: i())),
    Bind.singleton((i) => MongoPostRepo(http: i())),

    Bind.singleton((i) => ProfileCubit(profileRepo: i())),
    Bind.singleton((i) => MongoProfileRepo(http: i(), storage: i())),

  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      transition: TransitionType.noTransition,
      child: (_, __) => BlocProvider.value(
        value: Modular.get<AuthCubit>()..checkAuth(),
        child: const SplashScreen(),
      ),
    ),
    ModuleRoute(
      '/auth',
      transition: TransitionType.noTransition,
      module: AuthModule(),
    ),
    ModuleRoute(
      '/navigator',
      transition: TransitionType.noTransition,
      module: NavigationModule(),
    ),
    ModuleRoute(
      '/settings',
      transition: TransitionType.noTransition,
      module: SettingsModule(),
    ),
    ModuleRoute(
      '/events',
      transition: TransitionType.noTransition,
      module: EventModule(),
    ),
    ModuleRoute(
      '/contacts',
      transition: TransitionType.noTransition,
      module: ContactsModule(),
    ),
    ModuleRoute(
      '/profile',
      transition: TransitionType.noTransition,
      module: ProfileModule(),
    ),
    ModuleRoute(
      '/birthdays',
      transition: TransitionType.noTransition,
      module: BirthdaysModule(),
    ),
    ChildRoute(
      '/view-post/:postId',
      child: (_, args) => ViewPage(postId: args.params['postId']),
    ),

  ];
}
