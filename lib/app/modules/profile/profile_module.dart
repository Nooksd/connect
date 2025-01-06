import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/app/modules/profile/presentation/pages/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [

  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>(
            create: (_) => Modular.get<ProfileCubit>(),
          ),
          BlocProvider<AuthCubit>(
            create: (_) => Modular.get<AuthCubit>(),
          ),
        ],
        child: const ProfilePage(),
      ),
    ),
  ];
}
