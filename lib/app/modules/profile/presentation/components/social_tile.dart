import 'package:flutter/material.dart';

class SocialTile extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String text;

  const SocialTile({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
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
            SizedBox(
              width: 300,
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            )
          ],
        )
      ],
    );
  }
}
