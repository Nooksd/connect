import 'dart:io';

import 'package:connect/app/modules/post/domain/entities/post.dart';
import 'package:connect/app/modules/post/domain/repos/post_repo.dart';
import 'package:connect/app/modules/post/presentation/cubits/post_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;

  PostCubit({required this.postRepo}) : super(PostInitial());

  Future<void> createPost(Post post, File? imageFile) async {
    emit(PostLoading());
    String? imageUrl;
    Post updatedPost = post;

    try {
      if (imageFile != null) {
        emit(PostUploading());
        imageUrl = await postRepo.uploadImage(imageFile);
        if (imageUrl != '') {
          updatedPost = post.updateImage(newImageUrl: imageUrl);
        }
      }

      await postRepo.createPost(updatedPost);
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> getPosts() async {
    try {
      emit(PostLoading());

      final posts = await postRepo.getPosts();

      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      emit(PostLoading());
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
