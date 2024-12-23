import 'package:flutter/material.dart';

class DataTile extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String number;

  const DataTile({
    super.key,
    required this.icon,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(number),
          ],
        )
      ],
    );
  }
}
