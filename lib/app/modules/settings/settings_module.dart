import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/app/modules/settings/presentation/pages/notifications_settings_page.dart';
import 'package:connect/app/modules/settings/presentation/pages/profile_settings_page.dart';
import 'package:connect/app/modules/settings/presentation/pages/settings_page.dart';
import 'package:connect/app/modules/settings/presentation/pages/theme_settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SettingsModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const SettingsPage(),
    ),
    ChildRoute(
      '/theme',
      child: (_, __) => const ThemeSettingsPage(),
    ),
    ChildRoute('/profile', child: (_, __) {
      final user = Modular.args.data;
      return BlocProvider.value(
        value: Modular.get<ProfileCubit>(),
        child: ProfileSettingsPage(user: user),
      );
    }),
    ChildRoute(
      '/notifications',
      child: (_, __) => const NotificationsSettingsPage(),
    ),
  ];
}
