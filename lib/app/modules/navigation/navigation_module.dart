import 'package:connect/app/modules/explorer/explorer_module.dart';
import 'package:connect/app/modules/missions/missions_module.dart';
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
        ModuleRoute('/missions', module: MissionsModule()),
        ModuleRoute('/explore', module: ExplorerModule()),
        ModuleRoute('/profile', module: ProfileModule()),
      ],
    ),
  ];
}