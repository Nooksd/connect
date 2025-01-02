import 'dart:convert';
import 'dart:io';

import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/post/domain/entities/post.dart';
import 'package:connect/app/modules/post/domain/repos/post_repo.dart';

class MongoPostRepo implements PostRepo {
  MyHttpClient http;

  MongoPostRepo({required this.http});

  @override
  Future<void> createPost(Post post) {
    // TODO: implement createPost
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(String postId) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }
  
  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      final body = {
        'image': imageFile
      };
      final response = await http.multiPart('/post/image/upload', body: body);

      print(response);

      if (response["status"] == 200) {

        final imageUrl = response["data"]["url"];

        return Future.value(imageUrl);
      } else {
        throw Exception('Failed to upload image');
      }

    } catch (e) {
      throw Exception(e);
    }
  }
  

}
