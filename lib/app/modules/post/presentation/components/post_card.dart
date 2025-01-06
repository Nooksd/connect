import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final dynamic post;
  final bool isLiked;
  final bool isOwner;
  final Function(String postId) onDelete;
  final Function(String postId, bool isLiked) onLike;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.isOwner,
    required this.onDelete,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Header(post: post, isOwner: isOwner, onDelete: onDelete),
            const SizedBox(height: 10),
            PostContent(post: post),
            const SizedBox(height: 10),
            Footer(
              post: post,
              isLiked: isLiked,
              onLike: onLike,
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final dynamic post;
  final bool isOwner;
  final Function(String postId) onDelete;

  const Header({
    super.key,
    required this.post,
    required this.isOwner,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar(url: post.avatarUrl),
        const SizedBox(width: 10),
        UserInfo(name: post.name, role: post.role),
        if (isOwner) const Spacer(),
        if (isOwner)
          IconButton(
            onPressed: () => onDelete(post.id),
            icon: const Icon(Icons.delete, size: 20),
          ),
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final String url;

  const Avatar({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
      ),
      child: ClipOval(
        child: Image.network(
          url,
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
    );
  }
}

class UserInfo extends StatelessWidget {
  final String name;
  final String role;

  const UserInfo({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          role,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class PostContent extends StatelessWidget {
  final dynamic post;

  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                post.text,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            Positioned(
              child: Transform.rotate(
                angle: 3.14,
                child: const Icon(
                  CustomIcons.quotes,
                  size: 15,
                ),
              ),
            ),
            const Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                CustomIcons.quotes,
                size: 15,
              ),
            ),
          ],
        ),
        if (post.imageUrl.isNotEmpty) const SizedBox(height: 10),
        if (post.imageUrl.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 300,
                ),
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
        Hashtags(hashtags: post.hashtags),
      ],
    );
  }
}

class Hashtags extends StatelessWidget {
  final List<String> hashtags;

  const Hashtags({super.key, required this.hashtags});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: hashtags
          .map((tag) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "#$tag",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class Footer extends StatelessWidget {
  final dynamic post;
  final bool isLiked;
  final Function(String postId, bool isLiked) onLike;

  const Footer({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          timeAgo(post.createdAt),
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => onLike(post.id, isLiked),
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
          ),
        ),
        Text(
          post.likes.length.toString(),
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 30),
        const Icon(CustomIcons.talk, size: 22),
        const SizedBox(width: 15),
        Text(
          post.comments.length.toString(),
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  String timeAgo(DateTime createdAt) {
    final Duration diff = DateTime.now().difference(createdAt);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return '${(diff.inDays / 7).floor()}w';
    }
  }
}
