import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_navigation_destination.dart';
import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// ignore: library_private_types_in_public_api
final GlobalKey<_NavigatorPageState> navigatorPageKey = GlobalKey<_NavigatorPageState>();

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  String userName = "";
  int _selectedIndex = 0;

  void resetState({required String newUserName}) {
    setState(() {
      userName = newUserName;
      _selectedIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _navigateBottomBar(0);

    final args = Modular.args.data as Map<String, dynamic>;
    if (args['userName'] != null) {
      List<String> names = args['userName'].split(' ');

      String name = '${names[0]} ${names.length > 1 ? names[1] : ''}';

      userName = name;
    }
  }

  final List<String> _routes = [
    '/navigator/post/feed',
    '/navigator/missions',
    '/navigator/post/create',
    '/navigator/explore',
    '/navigator/profile/',
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Modular.to.navigate(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: _selectedIndex,
        userName: userName,
      ),
      body: const RouterOutlet(),
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
