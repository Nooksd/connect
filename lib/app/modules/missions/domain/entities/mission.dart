class Mission {
  final String id;
  final String ownerId;
  final String text;
  final int duration;
  final DateTime endDate; 
  final int value;
  final List<String> completed;
  final DateTime createdAt;



  Mission({
    required this.id,
    required this.ownerId,
    required this.text,
    required this.duration,
    required this.endDate,
    required this.value,
    required this.completed,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'text': text,
      'duration': duration,
      'endDate': endDate,
      'value': value,
      'completed': completed,
      'createdAt': createdAt
    };
  }

  factory Mission.fromJson(Map<String, dynamic> map) {
    return Mission(
      id: map['id'],
      ownerId: map['ownerId'],
      text: map['text'],
      duration: map['duration'],
      endDate: DateTime.parse(map['endDate'] as String),
      value: map['value'],
      completed: List<String>.from(map['completed'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] as String)
    );
  }
}
