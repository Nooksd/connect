import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/post/presentation/components/post_card.dart';
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

    if (cubit.state is! PostsLoaded) {
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
    _showDeleteConfirmationDialog(
      context,
      postId,
      () async {
        final postIndex =
            cubit.state.posts.indexWhere((post) => post.id == postId);

        if (postIndex == -1) return;

        setState(() {
          cubit.state.posts.removeAt(postIndex);
        });

        await cubit.deletePost(postId);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post apagado com sucesso!')),
        );
      },
    );
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

  void openPost(String postId) {
    Modular.to.pushNamed('/view-post/$postId');
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String postId, VoidCallback onConfirm) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Tem certeza de que deseja apagar este post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Apagar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      bloc: cubit,
      builder: (context, state) {
        if ((state is PostLoading && pageIndex == 1) || state is PostLoaded) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is PostsLoaded) {
          final allPosts = state.posts;

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                pageIndex = 1;

                cubit.saveScrollPosition(0.0);

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

                  return GestureDetector(
                    onTap: () => openPost(post.id),
                    child: PostCard(
                      post: post,
                      isLiked: isLiked,
                      isOwner: isOwner,
                      onDelete: deletePost,
                      onLike: likePost,
                    ),
                  );
                },
              ),
            ),
          );
        }

        if (state is PostsLoaded && state.posts.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text("Sem posts no feed"),
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
