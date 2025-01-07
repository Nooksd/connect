import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdaysBanner extends StatelessWidget {
  final List<dynamic> birthdays;
  final VoidCallback? onTap;

  const BirthdaysBanner({
    super.key,
    required this.birthdays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateFormat("dd-MM").format(DateTime.now());
    final todaysBirthdays = birthdays.where((birthday) {
      final birthdayFormatted = DateFormat("dd-MM").format(birthday.birthday);
      return birthdayFormatted == today;
    }).toList();

    if (todaysBirthdays.isEmpty || todaysBirthdays.length > 3) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 45),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 65),
                    ListView.builder(
                      itemCount: todaysBirthdays.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            todaysBirthdays[index].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            todaysBirthdays[index].role,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          if (index != todaysBirthdays.length - 1)
                            const SizedBox(height: 10),
                          if (index != todaysBirthdays.length - 1)
                            const Text(
                              "e",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -60,
              left: MediaQuery.of(context).size.width / 2 -
                  (55 * todaysBirthdays.length) -
                  (5 * todaysBirthdays.length),
              child: Stack(
                children: [
                  Container(
                    width: (120 * todaysBirthdays.length).toDouble(),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Row(
                      children: List.generate(todaysBirthdays.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                todaysBirthdays[index]?.profilePictureUrl ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -28,
              right: 37,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -25,
              right: 40,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text("👏", style: TextStyle(fontSize: 40)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
