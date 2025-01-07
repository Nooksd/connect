import 'package:connect/app/modules/missions/presentation/pages/missions_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MissionsModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const MissionsPage(),
    ),
  ];
}
