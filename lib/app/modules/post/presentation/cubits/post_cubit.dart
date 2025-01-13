import 'dart:io';

import 'package:connect/app/modules/post/domain/entities/post.dart';
import 'package:connect/app/modules/post/domain/repos/post_repo.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  double scrollPosition = 0.0;
  int pageIndex = 1;

  PostCubit({required this.postRepo}) : super(PostInitial());

  Future<void> createPost(Post post, File? imageFile) async {
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

      await getPosts(1);
    } catch (e) {
      emit(PostError(e.toString()));
      await getPosts(1);
    }
  }

  Future<void> getPosts(int page) async {
    try {
      if (page == 1) {
        emit(PostLoading());
      }

      final newPosts = await postRepo.getPosts(page);

      if (page > 1 && state is PostsLoaded) {
        final currentPosts = (state as PostsLoaded).posts;
        emit(PostsLoaded([...currentPosts, ...newPosts]));
      } else {
        emit(PostsLoaded(newPosts));
      }
    } catch (e) {
      if (page == 1) {
        emit(PostError(e.toString()));
      }
    }
  }

  Future<void> getPost(String postId) async {
    try {
      emit(PostLoading());

      final newPost = await postRepo.getPost(postId);


      if (newPost != null) {
        emit(PostLoaded(newPost));
      } else {
        emit(PostError("Post nao encontrado"));
      }
    } catch (e) {
      emit(PostError("Erro ao carregar post"));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError(e.toString()));
      await getPosts(1);
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await postRepo.likePost(postId);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> dislikePost(String postId) async {
    try {
      await postRepo.dislikePost(postId);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> commentPost(String postId, String comment) async {
    try {
      await postRepo.commentPost(postId, comment);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
    } catch (e) {
      throw Exception(e);
    }
  }

  void saveScrollPosition(double position, int index) {
    scrollPosition = position;
    pageIndex = index;
  }
}
