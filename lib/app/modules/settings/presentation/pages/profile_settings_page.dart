import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/auth/domain/entities/app_user.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_states.dart';
import 'package:connect/app/modules/settings/presentation/components/action_button.dart';
import 'package:connect/app/modules/settings/presentation/components/profile_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsPage extends StatefulWidget {
  final AppUser user;

  const ProfileSettingsPage({super.key, required this.user});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final linkedinController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    profileCubit.updateProfile(
      uid: widget.user.uid,
      newFacebookUrl: facebookController.text,
      newLinkedinUrl: linkedinController.text,
      newInstagramUrl: instagramController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Salvando..."),
                ],
              ),
            ),
          );
        } else {
          return buildProfileConfigPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
    );
  }

  Widget buildProfileConfigPage() {
    return Scaffold(
      appBar: const CustomAppBar(selectedIndex: 5, title: 'Editar Perfil'),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 18),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 115,
                      height: 115,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: const Icon(CustomIcons.pen, size: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Center(
                child: Text("Redes Sociais"),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    ProfileTextField(
                      textEditingController: linkedinController,
                      icon: const Icon(CustomIcons.linkedin, size: 20),
                      title: "Linkedin",
                    ),
                    const SizedBox(height: 35),
                    ProfileTextField(
                      textEditingController: facebookController,
                      icon: const Icon(CustomIcons.facebook, size: 20),
                      title: "Facebook",
                    ),
                    const SizedBox(height: 35),
                    ProfileTextField(
                      textEditingController: instagramController,
                      icon: const Icon(CustomIcons.instagram, size: 20),
                      title: "Instagram",
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 100,
            right: 15,
            child: ActionButton(
              title: "Salvar",
              callback: updateProfile,
            ),
          ),
        ],
      ),
    );
  }
}
