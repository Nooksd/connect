import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/missions/domain/entities/mission.dart';
import 'package:connect/app/modules/missions/presentation/cubits/mission_cubit.dart';
import 'package:connect/app/modules/missions/presentation/cubits/mission_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  final MissionCubit cubit = Modular.get<MissionCubit>();
  final String? userId = Modular.get<AuthCubit>().currentUser?.uid;

  @override
  void initState() {
    super.initState();

    cubit.getMissions();
  }

  void verifyCompletion(String missionId) {
    print(missionId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Função ainda não implementada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissionCubit, MissionState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is MissionLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is MissionsLoaded) {
          final List<Mission> missions = state.missions;

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await cubit.getMissions();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Text(
                          "Missoes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(child: Divider()),
                        const SizedBox(width: 20),
                        Text(
                          missions.length.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ListView.builder(
                      itemCount: missions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final mission = missions[index];
                        final isCompleted = mission.completed.contains(userId);
                        String timeLeft = "";

                        final now = DateTime.now();
                        final endDate = mission.endDate;
                        final duration = endDate.difference(now);

                        final days = duration.inDays;
                        final hours = duration.inHours % 24;
                        final minutes = duration.inMinutes % 60;
                        final seconds = duration.inSeconds % 60;

                        if (days > 0) {
                          timeLeft = "${days}d";
                        }
                        if (hours > 0) {
                          timeLeft = "$timeLeft ${hours}h";
                        }
                        if (minutes > 0 && days == 0) {
                          timeLeft = "$timeLeft ${minutes}m";
                        }
                        if (seconds > 0 && days == 0 && hours == 0) {
                          timeLeft = "$timeLeft ${seconds}s";
                        }

                        if (isCompleted) {
                          return const SizedBox();
                        }

                        return GestureDetector(
                          onTap: () => verifyCompletion(mission.id),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 65,
                                  child: Column(
                                    children: [
                                      const Spacer(),
                                      const Icon(Icons.timelapse),
                                      Text(timeLeft),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    mission.text,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 65,
                                  child: Row(
                                    children: [
                                      Text(
                                        "+${mission.value}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      SvgPicture.asset('assets/coin.svg'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text("Nenhuma missão disponível"),
          ),
        );
      },
    );
  }
}
