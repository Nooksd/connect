class Post {
  final String id;
  final String ownerId;
  final String name;
  final String avatarUrl;
  final String role;
  final String text;
  final List<String> hashtags;
  final String imageUrl;
  final List<String> likes;
  final List<Comment> comments;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.avatarUrl,
    required this.role,
    required this.text,
    required this.hashtags,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      role: json['role'] as String,
      text: json['text'] as String,
      hashtags: List<String>.from(json['hashtags'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'hashtags': hashtags,
      'imageUrl': imageUrl,
    };
  }

  Post updateImage({String? newImageUrl}) {
    return Post(
      id: id,
      ownerId: ownerId,
      name: name,
      avatarUrl: avatarUrl,
      role: role,
      text: text,
      hashtags: hashtags,
      imageUrl: newImageUrl ?? imageUrl,
      likes: likes,
      comments: comments,
      createdAt: createdAt,
    );
  }
}

class Comment {
  final String name;
  final String id;
  final String ownerId;
  final String avatarUrl;
  final String text;

  Comment({
    required this.name,
    required this.id,
    required this.ownerId,
    required this.avatarUrl,
    required this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      name: json['name'] as String,
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      avatarUrl: json['avatarUrl'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'ownerId': ownerId,
      'avatarUrl': avatarUrl,
      'text': text,
    };
  }
}
