import 'package:connect/features/birthdates/presentation/pages/birthdays_page.dart';
import 'package:connect/features/contacts/presentation/pages/contacts_page.dart';
import 'package:connect/features/events/presentation/pages/events_page.dart';
import 'package:connect/features/settings/presentation/pages/notifications_settings_page.dart';
import 'package:connect/features/notifications/presentation/pages/notifications_page.dart';
import 'package:connect/features/settings/presentation/pages/profile_settings_page.dart';
import 'package:connect/features/settings/presentation/pages/theme_settings_page.dart';
import 'package:connect/features/settings/presentation/pages/settings_page.dart';
import 'package:connect/features/store/presentation/pages/market_page.dart';
import 'package:connect/custom/splash_screen.dart';
import 'package:flutter/material.dart';

PageRouteBuilder generateRoute(RouteSettings settings) {
  WidgetBuilder builder;
  switch (settings.name) {
    case '/settings':
      builder = (BuildContext context) => const SettingsPage();
      break;
    case '/settings/theme':
      builder = (BuildContext context) => const ThemeSettingsPage();
      break;
    case '/settings/profile':
      builder = (BuildContext context) => ProfileSettingsPage();
      break;
    case '/settings/suport':
      builder = (BuildContext context) => const NotificationsSettingsPage();
      break;

    case '/explorer/events':
      builder = (BuildContext context) => const EventsPage();
      break;
    case '/explorer/contacts':
      builder = (BuildContext context) => const ContactsPage();
      break;
    case '/explorer/birthdays':
      builder = (BuildContext context) => const BirthdaysPage();
      break;

    case '/notifications':
      builder = (BuildContext context) => const NotificationsPage();
      break;

    case '/market':
      builder = (BuildContext context) => const MarketPage();
      break;

    default:
      builder = (BuildContext context) => const SplashScreen();
  }

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    settings: settings,
  );
}
