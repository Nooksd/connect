import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(selectedIndex: 5),
    );
  }
}
