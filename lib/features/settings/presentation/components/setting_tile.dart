import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final Icon icon;
  final String title;
  final bool danger;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 63,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: danger
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 63,
                        width: 63,
                        child: Center(
                          child: icon,
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          color: danger
                              ? Theme.of(context).colorScheme.onError
                              : Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  danger || title == "Suporte"
                      ? const SizedBox()
                      : const Icon(Icons.arrow_forward_ios, size: 30),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
