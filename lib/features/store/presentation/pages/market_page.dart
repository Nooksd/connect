import 'package:connect/features/navigation/presentation/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(selectedIndex: 5),
      body: Text(""),
    );
  }
}
