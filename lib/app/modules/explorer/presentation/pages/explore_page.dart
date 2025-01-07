import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/explorer/presentation/components/app_function_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToEvents() {
      // Navigator.pushNamed(context, '/events/');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Função ainda não implementada!')),
      );
    }

    void navigateToContacts() => Modular.to.pushNamed('/contacts/');
    void navigateToBirthdays() => Modular.to.pushNamed('/birthdays/');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
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
            ),
          ),
        ),
      ),
    );
  }
}
