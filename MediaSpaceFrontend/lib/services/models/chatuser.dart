class ChatUsers{
  String text;
  String secondaryText;
  String image;
  String time;
  bool read;
  int chatId;
  int otherParticipantId;
  ChatUsers({required this.text,required this.secondaryText,required this.image,required this.time,required this.read,required this.chatId,  // Add this
    required this.otherParticipantId,});
}