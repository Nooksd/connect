import 'package:connect/app/modules/explorer/presentation/pages/explore_page.dart';
import 'package:connect/app/modules/missions/presentation/pages/missions_page.dart';
import 'package:connect/app/modules/navigation/presentation/pages/navigator_page.dart';
import 'package:connect/app/modules/post/presentation/pages/feed_page.dart';
import 'package:connect/app/modules/post/presentation/pages/post_page.dart';
import 'package:connect/app/modules/profile/profile_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NavigationModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const NavigatorPage(),
      children: [
        ChildRoute(
          '/feed',
          child: (_, __) => const FeedPage(),
          transition: TransitionType.noTransition,
        ),
        ChildRoute(
          '/missions',
          child: (_, __) => const MissionsPage(),
          transition: TransitionType.noTransition,
        ),
        ChildRoute(
          '/post',
          child: (_, __) => const PostPage(),
          transition: TransitionType.noTransition,
        ),
        ChildRoute(
          '/explore',
          child: (_, __) => const ExplorePage(),
          transition: TransitionType.noTransition,
        ),
        ModuleRoute(
          '/profile',
          module: ProfileModule(),
          transition: TransitionType.noTransition,
        ),
      ],
    ),
  ];
}
