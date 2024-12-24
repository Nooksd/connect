import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/settings/presentation/components/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void goToSuportChat() {}

  @override
  Widget build(BuildContext context) {
    void navigateToTheme() => Navigator.pushNamed(context, '/settings/theme');

    void navigateToProfile() {
      final user = context.read<AuthCubit>().currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não encontrado!')),
        );
        return;
      }

      Navigator.pushNamed(
        context,
        '/settings/profile',
        arguments: user,
      );
    }

    void navigateToNotifications() =>
        Navigator.pushNamed(context, '/settings/theme');

    void logout() => context.read<AuthCubit>().logout();

    return Scaffold(
      appBar: const CustomAppBar(selectedIndex: 5, title: "Configurações"),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 60),
                SettingTile(
                  icon: const Icon(
                    CustomIcons.theme,
                    size: 25,
                  ),
                  title: "Tema",
                  onTap: navigateToTheme,
                ),
                SettingTile(
                  icon: const Icon(
                    CustomIcons.profile,
                    size: 25,
                  ),
                  title: "Perfil",
                  onTap: navigateToProfile,
                ),
                SettingTile(
                  icon: const Icon(
                    CustomIcons.notifications,
                    size: 25,
                  ),
                  title: "Notificações",
                  onTap: navigateToNotifications,
                ),
                SettingTile(
                  icon: const Icon(
                    CustomIcons.suport,
                    size: 25,
                  ),
                  title: "Suporte",
                  onTap: goToSuportChat,
                ),
                SettingTile(
                  icon: Icon(CustomIcons.logout,
                      color: Theme.of(context).colorScheme.onError),
                  title: "Sair",
                  danger: true,
                  onTap: logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
