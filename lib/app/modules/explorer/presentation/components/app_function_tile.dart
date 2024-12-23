import 'package:flutter/material.dart';

class AppFunctionTile extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const AppFunctionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 364,
            height: 142,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Center(
                  child: Column(
                    children: [
                      icon,
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}
