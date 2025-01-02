import 'dart:io';

import 'package:connect/app/modules/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> getPosts();
  Future<void> createPost(Post post);
  Future<String> uploadImage(File imageFile);
  Future<void> deletePost(String postId);
}
