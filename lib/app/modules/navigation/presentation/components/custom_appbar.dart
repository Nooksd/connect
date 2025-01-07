import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connect/app/core/custom/custom_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final String title;
  final String userName;

  const CustomAppBar({
    super.key,
    required this.selectedIndex,
    this.title = "",
    this.userName = "",
  });

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    final Map<int, List<Widget>> appBarActions = {
      0: [
        Text("Olá, $userName"),
        IconButton(
          onPressed: () {
            Modular.to.pushNamed('/notifications');
          },
          icon: const Icon(CustomIcons.notifications, size: 17),
        ),
      ],
      1: [
        IconButton(
          onPressed: () {
            // Modular.to.pushNamed('/market');

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Função ainda não implementada!')),
            );
          },
          icon: const Icon(CustomIcons.buy),
        ),
        SvgPicture.asset('assets/coin.svg')
      ],
      2: [],
      3: [],
      4: [
        IconButton(
          onPressed: () {
            Modular.to.pushNamed('/settings');
          },
          icon: const Icon(CustomIcons.settings),
        ),
      ],
      5: [
        GestureDetector(
          onTap: () {
            Modular.to.pop(context);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Icon(
              CustomIcons.arrow,
              size: 15,
            ),
          ),
        ),
        Text(title),
        const SizedBox(width: 40),
      ],
    };

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      flexibleSpace: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/logo.svg',
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: appBarActions[selectedIndex] ?? [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
