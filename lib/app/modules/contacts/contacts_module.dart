import 'package:connect/app/modules/contacts/presentation/pages/contacts_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContactsModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const ContactsPage(),
    ),
  ];
}