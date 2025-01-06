import 'dart:io';

import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/post/domain/entities/post.dart';
import 'package:connect/app/modules/post/domain/repos/post_repo.dart';

class MongoPostRepo implements PostRepo {
  MyHttpClient http;

  MongoPostRepo({required this.http});

  @override
  Future<void> createPost(Post post) async {
    try {
      print(post.toJson());
      final response = await http.post('/post/create', data: post.toJson());

      print(response);

      if (response["status"] != 200) {
        throw Exception('Falha ao deletar post');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete('/post/delete/$postId');

      if (response["status"] != 200) {
        throw Exception('Falha ao deletar post');
      }
    } catch (e) {
      throw Exception('Falha ao deletar post');
    }
  }

  @override
  Future<List<Post>> getPosts(int page) async {
    try {
      final response = await http.get('/post/get?page=$page');

      if (response["status"] == 200) {
        final data = response["data"]["posts"];

        if (data is List) {
          final List<Post> allPosts = data
              .map((post) => Post.fromJson(post as Map<String, dynamic>))
              .toList();
          return allPosts;
        } else {
          throw Exception("O formato esperado da resposta é uma lista.");
        }
      }

      return Future.value([]);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      final body = {'image': imageFile};
      final response = await http.multiPart('/post/image/upload', body: body);

      print(response);

      if (response["status"] == 200) {
        final imageUrl = response["data"]["url"];

        return Future.value(imageUrl);
      } else {
        throw Exception('Falha ao enviar imagem');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> commentPost(String postId, String comment) async {
    try {
      final data = {"text": comment};
      final response = await http.post('/post/comment/$postId', data: data);

      if (response["status"] != 200) {
        throw Exception('Falha ao comentar post');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final response =
          await http.delete('/post/comment/delete/$postId/$commentId');

      if (response["status"] != 200) {
        throw Exception('Falha ao comentar post');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> dislikePost(String postId) async {
    try {
      final response = await http.post('/post/dislike/$postId');

      if (response["status"] != 200) {
        throw Exception('Falha ao descurtir post');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      final response = await http.post('/post/like/$postId');

      if (response["status"] != 200) {
        throw Exception('Falha ao curtir post');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Post?> getPost(String postId) async {
    try {
      final response = await http.get('/post/get/$postId');

      if (response["status"] == 200) {
        final post = response["data"]["post"];

        return Post.fromJson(post);
      }

      return null;
    } catch (e) {
      throw Exception(e);
    }
  }
}
