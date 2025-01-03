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
  final ScrollController _scrollController = ScrollController();
  final PostCubit cubit = Modular.get<PostCubit>();
  final userId = Modular.get<AuthCubit>().currentUser?.uid;

  int pageIndex = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    cubit.getPosts(pageIndex);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
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

  void deletePost(String postId) async {
    final postIndex = cubit.state.posts.indexWhere((post) => post.id == postId);

    if (postIndex == -1) return;

    setState(() {
      cubit.state.posts.removeAt(postIndex);
    });

    await cubit.deletePost(postId);
  }

  void likePost(String postId, bool isLiked) async {
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
                await cubit.getPosts(1);
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    post.avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    post.role,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              if (isOwner) const Spacer(),
                              if (isOwner)
                                IconButton(
                                  onPressed: () => deletePost(post.id),
                                  icon: const Icon(Icons.delete, size: 20),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              post.text,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          if (post.imageUrl.isNotEmpty)
                            const SizedBox(height: 20),
                          if (post.imageUrl.isNotEmpty)
                            SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 300,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Image.network(
                                      post.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(
                              post.hashtags.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "#${post.hashtags[index]}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => likePost(post.id, isLiked),
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                              ),
                              Text(
                                post.likes.length.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 25),
                              IconButton(
                                onPressed: () {
                                  // TODO: implementar funcionalidade
                                },
                                icon: const Icon(CustomIcons.talk, size: 22),
                              ),
                              Text(
                                post.comments.length.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              // const SizedBox(width: 20),
                              // IconButton(
                              //   onPressed: () {
                              // TOD0: implementar funcionalidade
                              //   },
                              //   icon: const Icon(CustomIcons.share, size: 22),
                              // ),
                              const SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ),
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
