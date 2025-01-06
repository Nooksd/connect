import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_cubit.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  late final ScrollController _scrollController;
  final PostCubit cubit = Modular.get<PostCubit>();
  final String? userId = Modular.get<AuthCubit>().currentUser?.uid;

  int pageIndex = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(
      initialScrollOffset: cubit.scrollPosition,
    )..addListener(_onScroll);

    if (cubit.state is! PostLoaded) {
      cubit.getPosts(pageIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    cubit.saveScrollPosition(_scrollController.offset);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    setState(() {
      isLoadingMore = true;
    });

    pageIndex++;
    await cubit.getPosts(pageIndex);

    setState(() {
      isLoadingMore = false;
    });
  }

  Future<void> deletePost(String postId) async {
    final postIndex = cubit.state.posts.indexWhere((post) => post.id == postId);

    if (postIndex == -1) return;

    setState(() {
      cubit.state.posts.removeAt(postIndex);
    });

    await cubit.deletePost(postId);
  }

  Future<void> likePost(String postId, bool isLiked) async {
    setState(() {
      final postIndex =
          cubit.state.posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final updatedPost = cubit.state.posts[postIndex];
        if (isLiked) {
          updatedPost.likes.remove(userId);
        } else {
          updatedPost.likes.add(userId!);
        }
        cubit.state.posts[postIndex] = updatedPost;
      }
    });

    if (isLiked) {
      await cubit.dislikePost(postId);
    } else {
      await cubit.likePost(postId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is PostLoading && pageIndex == 1) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is PostLoaded) {
          final allPosts = state.posts;

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                pageIndex = 1;
                await cubit.getPosts(pageIndex);
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    isLoadingMore ? allPosts.length + 1 : allPosts.length,
                itemBuilder: (context, index) {
                  if (index >= allPosts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final post = allPosts[index];
                  final isLiked = post.likes.contains(userId);
                  final isOwner = post.ownerId == userId;

                  return PostCard(
                    post: post,
                    isLiked: isLiked,
                    isOwner: isOwner,
                    onDelete: deletePost,
                    onLike: likePost,
                  );
                },
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text("Erro ao carregar posts."),
          ),
        );
      },
    );
  }
}

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
            Footer(post: post, isLiked: isLiked, onLike: onLike),
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
        Text(
          post.text,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
        if (post.imageUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.network(post.imageUrl, fit: BoxFit.cover),
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
        const SizedBox(width: 25),
        IconButton(
          onPressed: () {
            // TODO: Implementar funcionalidade
          },
          icon: const Icon(CustomIcons.talk, size: 22),
        ),
        Text(
          post.comments.length.toString(),
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
