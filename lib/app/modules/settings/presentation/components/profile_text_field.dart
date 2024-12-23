import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Icon icon;
  final String title;

  const ProfileTextField({
    super.key,
    required this.textEditingController,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 40),
            Text(title),
          ],
        ),
        Row(
          children: [
            icon,
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 3,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 3,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
