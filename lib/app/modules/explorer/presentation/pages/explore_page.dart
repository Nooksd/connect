import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/explorer/presentation/components/app_function_tile.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToEvents() => Navigator.pushNamed(context, '/explorer/events');
    void navigateToContacts() =>
        Navigator.pushNamed(context, '/explorer/contacts');
    void navigateToBirthdays() =>
        Navigator.pushNamed(context, '/explorer/birthdays');

    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                AppFunctionTile(
                  icon: const Icon(CustomIcons.events, size: 50),
                  title: "Eventos",
                  subtitle: "Acompanhe e participe de atividades",
                  onTap: navigateToEvents,
                ),
                AppFunctionTile(
                  icon: const Icon(CustomIcons.contacts, size: 50),
                  title: "Contatos",
                  subtitle: "Encontre e conecte-se com pessoas",
                  onTap: navigateToContacts,
                ),
                AppFunctionTile(
                  icon: const Icon(CustomIcons.cake, size: 50),
                  title: "Aniversariantes",
                  subtitle: "Lembre-se das datas especiais",
                  onTap: navigateToBirthdays,
                ),
              ],
            )),
      ),
    );
  }
}
