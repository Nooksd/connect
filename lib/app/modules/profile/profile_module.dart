import 'package:connect/app/modules/profile/data/repos/mongo_profile_repo.dart';
import 'package:connect/app/modules/profile/data/source/profile_storage_service.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/app/modules/profile/presentation/pages/profile_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => ProfileStorageService(localStorage: i())),
    Bind.singleton(
        (i) => MongoProfileRepo(authApiService: i(), authStorageService: i())),
    Bind.singleton((i) => ProfileCubit(profileRepo: i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const ProfilePage(),
    )
  ];
}
