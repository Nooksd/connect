import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/contacts/presentation/cubits/contact_cubit.dart';
import 'package:connect/app/modules/contacts/presentation/cubits/contact_states.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ContactCubit cubit = Modular.get<ContactCubit>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    cubit.getContacts("");
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterContacts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Função ainda não implementada!')),
    );
  }

  void searchContacts(String query) {
    cubit.getContacts(query);
  }

  void openProfile(String uid) {
    Modular.to.pushNamed('/profile/$uid');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is ContactLoading) {
          return const Scaffold(
            appBar: CustomAppBar(selectedIndex: 5, title: "Contatos"),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ContactsLoaded) {
          final contacts = state.contacts;

          return Scaffold(
            appBar: const CustomAppBar(selectedIndex: 5, title: "Contatos"),
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          const Icon(CustomIcons.search, size: 18),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onSubmitted: searchContacts,
                              decoration: const InputDecoration(
                                hintText: "Procurar contatos",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: filterContacts,
                    child: Row(
                      children: [
                        const Spacer(),
                        const Icon(CustomIcons.filter, size: 15),
                        const SizedBox(width: 20),
                        Text(
                          "Filtrar contatos",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40, top: 20),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await cubit
                                .getContacts(searchController.text.toString());
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return GestureDetector(
                                onTap: () => openProfile(contact.uid),
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipOval(
                                      child: Image.network(
                                        contact.profilePictureUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    contact.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    contact.role,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          appBar: CustomAppBar(selectedIndex: 5, title: "Contatos"),
          body: Center(
            child: Text("Nenhum contato encontrado"),
          ),
        );
      },
    );
  }
}
