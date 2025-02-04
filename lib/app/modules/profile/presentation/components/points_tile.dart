import 'package:flutter/material.dart';

class PointsTile extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String number;

  const PointsTile({
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
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
              child: Text(title),
            ),
            Text(
              number,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
              ),
            ),
          ],
        )
      ],
    );
  }
}
