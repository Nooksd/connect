import 'package:connect/app/modules/post/presentation/pages/feed_page.dart';
import 'package:connect/app/modules/post/presentation/pages/post_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PostModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/feed',
      child: (_, __) => const FeedPage(),
    ),
    ChildRoute(
      '/create',
      child: (_, __) => PostPage(),
    ),
  ];
}
