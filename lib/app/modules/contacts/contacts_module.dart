import 'package:connect/app/modules/contacts/data/mongo_contact_repo.dart';
import 'package:connect/app/modules/contacts/presentation/cubits/contact_cubit.dart';
import 'package:connect/app/modules/contacts/presentation/pages/contacts_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContactsModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => ContactCubit(contactRepo: i())),
        Bind.singleton((i) => MongoContactRepo(http: i())),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const ContactsPage(),
    ),
  ];
}
