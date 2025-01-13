class Notification {
  final String id;
  final String text;
  final String type;
  final List<String> visualized;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.text,
    required this.type,
    required this.visualized,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> map) {
    return Notification(
      id: map['id'],
      text: map['text'],
      type: map['type'],
      visualized: List<String>.from(map['visualized']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
