class Post {
  final String text;
  final List<String> hashtags;
  final String imageUrl;

  Post({
    required this.text,
    required this.hashtags,
    required this.imageUrl,
  });

  Post updateImage({String? newImageUrl}) {
    return Post(
      text: text,
      hashtags: hashtags,
      imageUrl: newImageUrl ?? imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'hashtags': hashtags,
      'imageUrl': imageUrl,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      text: json['text'],
      hashtags: json['hashtags'],
      imageUrl: json['imageUrl'],
    );
  }
}
