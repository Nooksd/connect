import 'package:connect/app/modules/events/presentation/pages/events_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EventModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const EventsPage(),
    ),
  ];
}