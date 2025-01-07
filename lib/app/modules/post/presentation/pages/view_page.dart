import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:connect/app/modules/post/domain/entities/post.dart';
import 'package:connect/app/modules/post/presentation/components/comment_tile.dart';
import 'package:connect/app/modules/post/presentation/components/post_card.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_cubit.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class ViewPage extends StatefulWidget {
  final String postId;

  const ViewPage({super.key, required this.postId});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  final cubit = Modular.get<PostCubit>();
  final user = Modular.get<AuthCubit>().currentUser;
  final TextEditingController commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    cubit.getPost(widget.postId);
  }

  @override
  void dispose() {
    super.dispose();

    cubit.getPosts(1);
  }

  Future<void> deleteComment(String commentId) async {
    _showDeleteConfirmationDialog(
      context,
      commentId,
      () async {
        final commentIndex = cubit.state.post.comments
            .indexWhere((comment) => comment.id == commentId);

        if (commentIndex == -1) return;

        setState(() {
          cubit.state.post.comments.removeAt(commentIndex);
        });

        await cubit.deleteComment(widget.postId, commentId);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentário apagado com sucesso!')),
        );
      },
    );
  }

  Future<void> onComment() async {
    _focusNode.unfocus();

    if (commentController.text.isNotEmpty) {
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerId: user?.uid ?? '',
        text: commentController.text,
        avatarUrl: user?.profilePictureUrl ?? '',
        name: user?.name ?? 'Usuário desconhecido',
      );

      setState(() {
        cubit.state.post.comments.insert(0, newComment);
      });

      try {
        await cubit.commentPost(widget.postId, commentController.text);
      } catch (error) {
        setState(() {
          cubit.state.post.comments.removeAt(0);
        });
      }

      commentController.clear();
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String postId, VoidCallback onConfirm) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Tem certeza de que deseja apagar este comentário?'),
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
        if (state is PostLoading) {
          return const Scaffold(
            appBar: CustomAppBar(selectedIndex: 5),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is PostLoaded) {
          final post = state.post;

          return Scaffold(
            appBar: const CustomAppBar(selectedIndex: 5),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  const SizedBox(height: 50),
                                  Text(
                                    post.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    post.role,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    post.text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  if (post.imageUrl.isNotEmpty)
                                    const SizedBox(height: 25),
                                  if (post.imageUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        post.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.error,
                                            size: 50,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          );
                                        },
                                      ),
                                    ),
                                  const SizedBox(height: 25),
                                  Hashtags(hashtags: post.hashtags),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy HH:mm:ss')
                                            .format(
                                          post.createdAt,
                                        ),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        user?.profilePictureUrl ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                                  Expanded(
                                    child: TextField(
                                      controller: commentController,
                                      focusNode: _focusNode,
                                      decoration: InputDecoration(
                                          hintText: 'Escreva um comentário...',
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    onPressed: onComment,
                                    icon: const Icon(Icons.send),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: post.comments.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                CommentTile(
                                  comment: post.comments[index],
                                  isAuthor:
                                      user?.uid == post.comments[index].ownerId,
                                  onDelete: () => deleteComment(
                                    post.comments[index].id,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                      Positioned(
                        top: -45,
                        left: MediaQuery.of(context).size.width / 2 - 45,
                        child: Container(
                          width: 90,
                          height: 90,
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
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          appBar: CustomAppBar(selectedIndex: 5),
          body: Center(
            child: Text("Erro ao carregar post"),
          ),
        );
      },
    );
  }
}
