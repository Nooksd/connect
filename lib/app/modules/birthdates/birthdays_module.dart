import 'package:connect/app/modules/birthdates/presentation/pages/birthdays_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BirthdaysModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const BirthdaysPage(),
    ),
  ];
}