import 'dart:io';

import 'package:connect/app/modules/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> getPosts(int page);
  Future<void> createPost(Post post);
  Future<void> likePost(String postId);
  Future<void> dislikePost(String postId);
  Future<void> commentPost(String postId, String comment);
  Future<void> deleteComment(String postId, String commentId);
  Future<String> uploadImage(File imageFile);
  Future<void> deletePost(String postId);
}
