import 'package:flutter/material.dart';

class CustomNavigationDestination extends StatelessWidget {
  final Icon icon;
  final String label;
  final bool isSelected;

  const CustomNavigationDestination({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryFixed
              : Colors.transparent,
        ),
        padding: const EdgeInsets.all(13),
        child: icon,
      ),
      label: label,
    );
  }
}
