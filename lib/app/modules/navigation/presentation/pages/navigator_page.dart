import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/explorer/presentation/pages/explore_page.dart';
import 'package:connect/app/modules/missions/presentation/pages/missions_page.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_navigation_destination.dart';
import 'package:connect/app/modules/profile/presentation/pages/profile_page.dart';
import 'package:connect/app/modules/post/presentation/pages/feed_page.dart';
import 'package:connect/app/modules/post/presentation/pages/post_page.dart';
import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isFirstPage = true;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List pages = [
      const FeedPage(),
      const MissionsPage(),
      const PostPage(),
      const ExplorePage(),
      ProfilePage(uid: context.read<AuthCubit>().currentUser!.uid),
    ];

    return Scaffold(
      appBar: CustomAppBar(selectedIndex: _selectedIndex),
      body: pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.white,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorColor: Colors.transparent,
            indicatorShape: const CircleBorder(),
            iconTheme: WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return IconThemeData(
                    color: Theme.of(context).colorScheme.primary,
                    size: 21,
                  );
                }
                return IconThemeData(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  size: 21,
                );
              },
            ),
          ),
          child: NavigationBar(
            onDestinationSelected: _navigateBottomBar,
            selectedIndex: _selectedIndex,
            destinations: [
              CustomNavigationDestination(
                icon: const Icon(CustomIcons.feed, size: 20),
                label: "Feed",
                isSelected: _selectedIndex == 0,
              ),
              CustomNavigationDestination(
                icon: const Icon(CustomIcons.target),
                label: "Missões",
                isSelected: _selectedIndex == 1,
              ),
              NavigationDestination(
                icon: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    CustomIcons.plus,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
                label: "Postar",
              ),
              CustomNavigationDestination(
                icon: const Icon(CustomIcons.explorer),
                label: "Explorar",
                isSelected: _selectedIndex == 3,
              ),
              CustomNavigationDestination(
                icon: const Icon(CustomIcons.profile),
                label: "Perfil",
                isSelected: _selectedIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
