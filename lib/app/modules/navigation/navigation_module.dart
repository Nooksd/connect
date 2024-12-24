import 'package:connect/app/modules/navigation/presentation/pages/navigator_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NavigationModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/navigator',
          child: (_, __) => const NavigatorPage(),
        ),
      ];
}
