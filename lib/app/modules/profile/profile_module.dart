import 'package:connect/app/modules/profile/presentation/pages/profile_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/:uid',
      child: (_, args) => ProfilePage(uid: args.params['uid']),
    ),
  ];
}
