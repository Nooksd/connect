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
  final List<String> appMissions = ["FEEDPOST", "FEEDHASHTAG", "FEEDIMAGE"];

  @override
  void initState() {
    super.initState();

    cubit.getMissions();
  }

  void showValidationModal(String missionId) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Validar Missão'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Por favor, insira a URL para enviar a missão para validação:'),
              const SizedBox(height: 10),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  hintText: 'URL para validação',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                sendValidation(urlController.text, missionId);
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void verifyCompletion(String missionId, String missionType) async {
    if (appMissions.contains(missionType)) {
      final bool status = await cubit.verifyCompletion(missionId);

      if (!mounted) return;

      if (status) {
        final missionIndex = cubit.state.missions
            .indexWhere((mission) => mission.id == missionId);

        if (missionIndex == -1) return;

        setState(() {
          cubit.state.missions.removeAt(missionIndex);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missão completa com sucesso')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missão não completa')),
        );
      }
    } else {
      showValidationModal(missionId);
    }
  }

  void sendValidation(String url, String missionId) async {

    if (url.isNotEmpty) {
      final bool status = await cubit.sendValidation(missionId, url);

      if (!mounted) return;

      if (status) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missão enviada para ser verificada')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Falha ao enviar pedido de verificação')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira uma URL válida')),
      );
    }
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
                          onTap: () =>
                              verifyCompletion(mission.id, mission.missionType),
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
