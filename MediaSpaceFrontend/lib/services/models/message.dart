class Message {
  final int id;
  final int chatId;
  final int senderId;
  final int recipientId;
  final String content;
  final int timestamp;
  final bool read;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
    required this.read,
  });

  // Factory constructor to create a Message from a map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      content: json['content'],
      timestamp: json['timestamp'],
      read: json['read'],
    );
  }

  // Method to convert a Message to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'timestamp': timestamp,
      'read': read,
    };
  }
}
