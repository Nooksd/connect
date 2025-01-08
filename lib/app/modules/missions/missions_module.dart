import 'package:connect/app/modules/missions/data/mongo_mission_repo.dart';
import 'package:connect/app/modules/missions/presentation/cubits/mission_cubit.dart';
import 'package:connect/app/modules/missions/presentation/pages/missions_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MissionsModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => MongoMissionRepo(http: i())),
        Bind.singleton((i) => MissionCubit(missionRepo: i())),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const MissionsPage(),
    ),
  ];
}
