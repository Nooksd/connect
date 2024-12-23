import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        selectedIndex: 5,
        title: "Notificações",
      ),
      body: Text(""),
    );
  }
}
