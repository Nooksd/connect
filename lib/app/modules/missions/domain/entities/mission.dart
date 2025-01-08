class Mission {
  final String id;
  final String ownerId;
  final String text;
  final String missionType;
  final String hashtag;  
  final int duration;
  final DateTime endDate;
  final int value;
  final List<String> completed;
  final DateTime createdAt;

  Mission({
    required this.id,
    required this.ownerId,
    required this.text,
    required this.missionType,
    required this.hashtag,
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
      'missionType': missionType,
      'hashtag': hashtag,
      'duration': duration,
      'endDate': endDate.toIso8601String(),
      'value': value,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Mission.fromJson(Map<String, dynamic> map) {
    return Mission(
      id: map['id'],
      ownerId: map['ownerId'],
      text: map['text'],
      missionType: map['missionType'],
      hashtag: map['hashtag'] ?? '',
      duration: map['duration'],
      endDate: DateTime.parse(map['endDate']),
      value: map['value'],
      completed: List<String>.from(map['completed'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
