import 'dart:io';
import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/post/domain/entities/post.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_cubit.dart';
import 'package:connect/app/modules/settings/presentation/components/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final cubit = Modular.get<PostCubit>();
  final user = Modular.get<AuthCubit>().currentUser;
  final TextEditingController textController = TextEditingController();

  File? selectedImage;
  int hashtagCount = 0;

  List<TextEditingController> hashtagControllers = [];

  void updateHashtagControllers() {
    setState(() {
      if (hashtagCount > hashtagControllers.length) {
        for (int i = hashtagControllers.length; i < hashtagCount; i++) {
          hashtagControllers.add(TextEditingController());
        }
      } else if (hashtagCount < hashtagControllers.length) {
        hashtagControllers.removeRange(hashtagCount, hashtagControllers.length);
      }
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void toggleHashtags() {
    setState(() {
      hashtagCount = hashtagCount + 1;

      if (hashtagCount > 3) hashtagCount = 0;
    });
    updateHashtagControllers();
  }

  Future<void> createPost() async {
    if (textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post precisa de texto!')),
      );
      return;
    }

    final post = Post(
      text: textController.text,
      hashtags:
          hashtagControllers.map((controller) => controller.text).toList(),
      id: '',
      ownerId: '',
      name: '',
      avatarUrl: '',
      role: '',
      imageUrl: '',
      likes: [],
      comments: [],
      createdAt: DateTime.now(),
    );

    await cubit.createPost(post, selectedImage);

    setState(() {
      selectedImage = null;
      textController.clear();
      hashtagCount = 0;
      updateHashtagControllers();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post Realizado com sucesso!')),
    );
  }

  void unimplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Função ainda não implementada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
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
                                    user?.name ?? 'Usuário desconhecido',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user?.role ?? 'Usuário desconhecido',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  TextField(
                                    controller: textController,
                                    minLines: 1,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      hintText: "Escreva algo...",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  if (selectedImage != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Stack(
                                        children: [
                                          Image.file(
                                            selectedImage!,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedImage = null;
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primaryFixed,
                                                ),
                                              ),
                                              icon: Icon(
                                                Icons.close,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (selectedImage != null)
                                    const SizedBox(height: 25),
                                  if (hashtagCount > 0)
                                    Column(
                                      children: [
                                        for (int i = 0; i < hashtagCount; i++)
                                          TextField(
                                            minLines: 1,
                                            maxLines: 1,
                                            maxLength: 15,
                                            controller: hashtagControllers[i],
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp(r'\s')),
                                            ],
                                            decoration: InputDecoration(
                                              hintText: "hashtag ${i + 1}",
                                              prefixIcon: SizedBox(
                                                height: 2,
                                                child: Icon(
                                                  CustomIcons.hashtag,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                      ],
                                    ),
                                  if (hashtagCount > 0)
                                    const SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: pickImage,
                                icon: const Icon(CustomIcons.fotos, size: 20),
                              ),
                              IconButton(
                                onPressed: unimplemented,
                                icon: const Icon(CustomIcons.link, size: 20),
                              ),
                              IconButton(
                                onPressed: unimplemented,
                                icon: const Icon(CustomIcons.vote, size: 20),
                              ),
                              IconButton(
                                onPressed: toggleHashtags,
                                icon: const Icon(CustomIcons.hashtag, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100),
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
                              user?.profilePictureUrl ?? '',
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
          ),
          Positioned(
            bottom: 50,
            right: 15,
            child: ActionButton(
              title: "Publicar",
              callback: createPost,
            ),
          ),
        ],
      ),
    );
  }
}
