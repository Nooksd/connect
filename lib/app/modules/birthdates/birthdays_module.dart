import 'package:connect/app/modules/birthdates/data/mongo_birthday_repo.dart';
import 'package:connect/app/modules/birthdates/presentation/cubits/birthday_cubit.dart';
import 'package:connect/app/modules/birthdates/presentation/pages/birthdays_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BirthdaysModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => BirthdayCubit(birthdayRepo: i())),
        Bind.singleton((i) => MongoBirthdayRepo(http: i())),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const BirthdaysPage(),
    ),
  ];
}
