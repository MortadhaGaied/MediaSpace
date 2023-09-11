class Chat {
  final int id;
  final int participantId1;
  final int participantId2;
  final int createdAt;

  Chat({required this.id, required this.participantId1, required this.participantId2, required this.createdAt});

  // Factory constructor to create an instance of Chat from a map
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      participantId1: json['participantId1'],
      participantId2: json['participantId2'],
      createdAt: json['createdAt'],
    );
  }

  // Method to convert an instance of Chat to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantId1': participantId1,
      'participantId2': participantId2,
      'createdAt': createdAt,
    };
  }
}
