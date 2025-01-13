import 'package:connect/app/modules/notifications/presentation/pages/notifications_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotificationModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const NotificationsPage(),
    ),
  ];
}
