import 'package:connect/app/modules/post/domain/entities/post.dart';

abstract class PostState {
  get posts => null;
  get post => null;
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostUploading extends PostState {}

class PostsLoaded extends PostState {
  @override
  final List<Post> posts;

  PostsLoaded(this.posts);
}
class PostLoaded extends PostState {
  @override
  final Post post;

  PostLoaded(this.post);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}
