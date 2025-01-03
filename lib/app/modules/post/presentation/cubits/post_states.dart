import 'package:connect/app/modules/post/domain/entities/post.dart';

abstract class PostState {
  get posts => null;
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostUploading extends PostState {}

class PostLoaded extends PostState {
  @override
  final List<Post> posts;

  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}
