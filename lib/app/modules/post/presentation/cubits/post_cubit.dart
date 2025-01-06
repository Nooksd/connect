import 'dart:io';

import 'package:connect/app/modules/post/domain/entities/post.dart';
import 'package:connect/app/modules/post/domain/repos/post_repo.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  double scrollPosition = 0.0; // Para salvar a posição de rolagem

  PostCubit({required this.postRepo}) : super(PostInitial());

  /// Cria um novo post com ou sem uma imagem associada
  Future<void> createPost(Post post, File? imageFile) async {
    emit(PostLoading());
    String? imageUrl;
    Post updatedPost = post;

    try {
      if (imageFile != null) {
        emit(PostUploading());
        imageUrl = await postRepo.uploadImage(imageFile);
        if (imageUrl.isNotEmpty) {
          updatedPost = post.updateImage(newImageUrl: imageUrl);
        }
      }

      await postRepo.createPost(updatedPost);

      // Recarrega os posts após criar um novo
      await getPosts(1);
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  /// Obtém os posts paginados
  Future<void> getPosts(int page) async {
    try {
      if (page == 1) {
        emit(PostLoading());
      }

      final newPosts = await postRepo.getPosts(page);

      if (page > 1 && state is PostLoaded) {
        final currentPosts = (state as PostLoaded).posts;
        emit(PostLoaded([...currentPosts, ...newPosts]));
      } else {
        emit(PostLoaded(newPosts));
      }
    } catch (e) {
      if (page == 1) {
        emit(PostError(e.toString()));
      }
    }
  }

  /// Exclui um post pelo ID
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  /// Adiciona um like em um post
  Future<void> likePost(String postId) async {
    try {
      await postRepo.likePost(postId);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Remove um like de um post
  Future<void> dislikePost(String postId) async {
    try {
      await postRepo.dislikePost(postId);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Adiciona um comentário a um post
  Future<void> commentPost(String postId, String comment) async {
    try {
      await postRepo.commentPost(postId, comment);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Exclui um comentário de um post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Salva a posição do scroll
  void saveScrollPosition(double position) {
    scrollPosition = position;
  }
}
