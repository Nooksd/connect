import 'package:connect/app/modules/explorer/presentation/pages/explore_page.dart';
import 'package:connect/app/modules/missions/presentation/pages/missions_page.dart';
import 'package:connect/app/modules/navigation/presentation/pages/navigator_page.dart';
import 'package:connect/app/modules/post/post_module.dart';
import 'package:connect/app/modules/profile/profile_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NavigationModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => NavigatorPage(key: navigatorPageKey),
      children: [
        ModuleRoute('/post', module: PostModule()),
        ChildRoute('/missions', child: (_, __) => const MissionsPage()),
        ChildRoute('/explore', child: (_, __) => const ExplorePage()),
        ModuleRoute('/profile', module: ProfileModule()),
      ],
    ),
  ];
}