import 'dart:io';
import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:connect/app/modules/profile/domain/entities/profile_user.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect/app/modules/profile/presentation/cubits/profile_states.dart';
import 'package:connect/app/modules/settings/presentation/components/action_button.dart';
import 'package:connect/app/modules/settings/presentation/components/profile_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsPage extends StatefulWidget {
  final ProfileUser user;

  const ProfileSettingsPage({super.key, required this.user});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late TextEditingController linkedinController;
  late TextEditingController facebookController;
  late TextEditingController instagramController;
  File? selectedImage;
  late String profilePictureUrl;

  @override
  void initState() {
    super.initState();

    linkedinController = TextEditingController(text: widget.user.linkedinUrl);
    facebookController = TextEditingController(text: widget.user.facebookUrl);
    instagramController = TextEditingController(text: widget.user.instagramUrl);

    profilePictureUrl = widget.user.profilePictureUrl.toString();
  }

  @override
  void dispose() {
    linkedinController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    profileCubit.updateProfile(
      newFacebookUrl: facebookController.text,
      newLinkedinUrl: linkedinController.text,
      newInstagramUrl: instagramController.text,
      newProfilePictureUrl: selectedImage,
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
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(selectedIndex: 5, title: 'Editar Perfil'),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 18),
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: pickImage, // Permite escolher a imagem
                      child: Container(
                        width: 115,
                        height: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: Theme.of(context).colorScheme.secondary,
                          image: selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : (profilePictureUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        '$profilePictureUrl?t=${DateTime.now().millisecondsSinceEpoch}',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                        ),
                        child: profilePictureUrl.isEmpty &&
                                selectedImage == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              )
                            : null,
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
