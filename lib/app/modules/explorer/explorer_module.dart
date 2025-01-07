import 'package:connect/app/modules/explorer/presentation/pages/explore_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExplorerModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const ExplorePage(),
    ),
  ];
}
