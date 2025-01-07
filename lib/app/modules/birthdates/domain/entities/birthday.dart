class Birthday {
  final String name;
  final String role;
  final DateTime birthday;
  final String profilePictureUrl;

  Birthday({
    required this.birthday,
    required this.name,
    required this.role,
    required this.profilePictureUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'birthday': birthday.toIso8601String(),
      'name': name,
      'role': role,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory Birthday.fromJson(Map<String, dynamic> map) {
    return Birthday(
      birthday: map['birthday'] != null
          ? (map['birthday'] is int
              ? DateTime.fromMillisecondsSinceEpoch(map['birthday'] * 1000)
              : DateTime.parse(map['birthday']))
          : DateTime.fromMillisecondsSinceEpoch(0),
      name: map['name'] as String,
      role: map['role'],
      profilePictureUrl: map['profilePictureUrl'],
    );
  }
}
