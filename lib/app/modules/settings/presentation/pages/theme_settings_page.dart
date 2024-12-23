import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(selectedIndex: 5),
    );
  }
}
