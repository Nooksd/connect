import 'package:connect/app/modules/post/domain/entities/post.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CommentTile extends StatelessWidget {
  final PostCubit cubit = Modular.get<PostCubit>();
  final Comment comment;
  final bool isAuthor;
  final VoidCallback onDelete;

  CommentTile(
      {super.key,
      required this.comment,
      required this.isAuthor,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipOval(
                    child: Image.network(
                      comment.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).colorScheme.onSecondary,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  comment.name,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                if (isAuthor)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 18),
                  )
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(comment.text, style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
