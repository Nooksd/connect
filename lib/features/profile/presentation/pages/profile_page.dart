import 'package:connect/features/profile/presentation/components/data_tile.dart';
import 'package:connect/features/profile/presentation/components/points_tile.dart';
import 'package:connect/features/profile/presentation/components/social_tile.dart';
import 'package:connect/features/profile/presentation/cubits/profile_states.dart';
import 'package:connect/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/features/auth/domain/entities/app_user.dart';
import 'package:connect/custom/custom_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();

    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.profileUser;

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 115,
                          height: 115,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user.position,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PointsTile(
                        icon: const Icon(CustomIcons.medal, size: 25),
                        title: "Pontos ganhos",
                        number: user.pTotal.toString(),
                      ),
                      PointsTile(
                        icon: const Icon(CustomIcons.prize, size: 22),
                        title: "Pontos gastos",
                        number: user.pSpent.toString(),
                      ),
                      PointsTile(
                        icon: SvgPicture.asset('assets/coin.svg', width: 25),
                        title: "Pontos Atuais",
                        number: user.pCurrent.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Center(
                    child: Text("Dados"),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              DataTile(
                                icon: const Icon(CustomIcons.email, size: 17),
                                title: "Email",
                                number: user.email,
                              ),
                              const SizedBox(height: 30),
                              DataTile(
                                icon: const Icon(CustomIcons.role, size: 17),
                                title: "Cargo",
                                number: user.position,
                              ),
                              const SizedBox(height: 30),
                              DataTile(
                                icon: const Icon(CustomIcons.cake, size: 22),
                                title: "Data de nascimento",
                                number: DateFormat("d 'de' MMMM", 'pt-BR')
                                    .format(user.birthday.toDate()),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              DataTile(
                                icon: const Icon(CustomIcons.phone, size: 19),
                                title: "Telefone",
                                number: user.phoneNumber,
                              ),
                              const SizedBox(height: 30),
                              DataTile(
                                icon: const Icon(CustomIcons.date, size: 20),
                                title: "Data de admissão",
                                number: DateFormat('dd/MM/yyyy')
                                    .format(user.entryDate.toDate()),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Center(
                    child: Text("Redes Sociais"),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SocialTile(
                          icon: const Icon(CustomIcons.linkedin, size: 20),
                          title: "LinkedIn",
                          text: user.linkedinUrl,
                        ),
                        const SizedBox(height: 30),
                        SocialTile(
                          icon: const Icon(CustomIcons.facebook, size: 20),
                          title: "Facebook",
                          text: user.facebookUrl,
                        ),
                        const SizedBox(height: 30),
                        SocialTile(
                          icon: const Icon(CustomIcons.instagram, size: 20),
                          title: "Instagram",
                          text: user.instagramUrl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Erro ao carregar perfil"),
            ),
          );
        }
      },
    );
  }
}
