import 'package:connect/app/modules/birthdates/presentation/components/birthday_banner.dart';
import 'package:connect/app/modules/birthdates/presentation/cubits/birthday_cubit.dart';
import 'package:connect/app/modules/birthdates/presentation/cubits/birthday_states.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class BirthdaysPage extends StatefulWidget {
  const BirthdaysPage({super.key});

  @override
  State<BirthdaysPage> createState() => _BirthdaysPageState();
}

class _BirthdaysPageState extends State<BirthdaysPage> {
  final BirthdayCubit cubit = Modular.get<BirthdayCubit>();
  bool _playConfetti = false;

  @override
  void initState() {
    super.initState();
    cubit.getBirthdays();
  }

  void _onConfettiTap() {
    setState(() {
      _playConfetti = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _playConfetti = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BirthdayCubit, BirthdayState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is BirthdayLoading) {
          return const Scaffold(
            appBar: CustomAppBar(selectedIndex: 5),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is BirthdaysLoaded) {
          final birthdays = state.birthdays;

          return Scaffold(
            appBar: const CustomAppBar(selectedIndex: 5),
            body: Stack(
              children: [
                Column(
                  children: [
                    BirthdaysBanner(
                      birthdays: birthdays,
                      onTap: _onConfettiTap,
                    ),
                    const SizedBox(height: 50),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await cubit.getBirthdays();
                            },
                            child: SingleChildScrollView(
                              child: ListView.builder(
                                itemCount: birthdays.length,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        birthdays[index].profilePictureUrl),
                                  ),
                                  title: Text(
                                    birthdays[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    birthdays[index].role,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  trailing: Text(
                                    birthdays[index].birthday.isToday()
                                        ? "Hoje!"
                                        : DateFormat("dd/MM")
                                            .format(birthdays[index].birthday),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_playConfetti)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Lottie.asset('assets/confetti.json'),
                    ),
                  ),
              ],
            ),
          );
        }

        return const Scaffold(
          appBar: CustomAppBar(selectedIndex: 5),
          body: Center(
            child: Text("Nenhum aniversário encontrado"),
          ),
        );
      },
    );
  }
}

extension DateTimeExtensions on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return day == now.day && month == now.month;
  }
}
