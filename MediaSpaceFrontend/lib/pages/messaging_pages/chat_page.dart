
import 'dart:async';
import 'dart:convert';

import 'package:MediaSpaceFrontend/services/backend/messaging-service.dart';
import 'package:MediaSpaceFrontend/services/models/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../services/backend/auth-service.dart';
import '../../services/models/chatuser.dart';
import '../../widgets/custom_bottomNavigationBar.dart';
import 'components/chatlist.dart';

class ChatPage extends StatefulWidget{
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [];
  final AuthenticationService authService = AuthenticationService();
  final MessagingService messagingService=MessagingService();
  int? currentChatId;
  String? secondaryText;
  // Inside _ChatPageState class
  WebSocketChannel? channel;
  StreamSubscription? _webSocketSubscription;


  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://172.28.160.1:8083/ws');
    _webSocketSubscription = channel!.stream.listen(
          (message) {
        final Map<String, dynamic> messageData = jsonDecode(message);
        // Check if the message belongs to the current chat
        // Inside your WebSocket listener
        if (messageData['chatId'] == currentChatId) {
          // Find the correct ChatUsers object
          ChatUsers? firstWhereOrNull(List<ChatUsers> list, bool Function(ChatUsers) test) {
            for (ChatUsers element in list) {
              if (test(element)) {
                return element;
              }
            }
            return null;
          }

// Usage
          final ChatUsers? chatUser = firstWhereOrNull(chatUsers, (c) => c.chatId == currentChatId);

          if (chatUser != null) {
            // Update the secondaryText
            setState(() {
              chatUser.secondaryText = messageData['content'];
            });
          }
        }

          },
      onError: (error) {
        print("WebSocket Error: $error");
        // Handle the error or attempt to reconnect
      },
    );
    fetchChats();
  }



  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) return 'Now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hr ago';
    if (difference.inDays < 30) return '${difference.inDays} days ago';

    return DateFormat('yMMMd').format(dateTime);
  }
  fetchChats() async {
    try {
      Map<String, dynamic> currentUser = await authService.getCurrentUser();

      int participantId = currentUser['id']; // Use the ID from the current user

      List<Chat> chats = await messagingService.getAllChats(participantId);

      for (Chat chat in chats) {
        int otherParticipantId = (chat.participantId1 == participantId) ? chat.participantId2 : chat.participantId1;
        Map<String, dynamic> user = await authService.getUserById(otherParticipantId);
        String imageUrl = await authService.getUrlFile(user['profile_picture']);

        // Get the last message for this chat
        print("****");
        print(chat.id);
        Map<String, dynamic>? lastMessage = await messagingService.getLastMessage(chat.id);
        String secondaryText = lastMessage != null ? lastMessage['content'] : 'No messages yet';
        bool isRead = lastMessage != null ? lastMessage['read'] : false;
        DateTime? lastMessageTime;
        if (lastMessage != null) {
          lastMessageTime = DateTime.fromMillisecondsSinceEpoch(lastMessage['timestamp']);
        }

        String readableTime = lastMessageTime != null ? timeAgo(lastMessageTime) : 'Unknown';

        chatUsers.add(
          ChatUsers(
            text: "${user['firstname']} ${user['lastname']}",
            secondaryText: secondaryText,
            image: imageUrl,
            time: readableTime,
            read: isRead,
            chatId: chat.id,  // Add this
            otherParticipantId: otherParticipantId,
          ),
        );
      }

      setState(() {}); // Rebuild the widget
    } catch (e) {
      print("Error fetching chats: $e");
      // Handle the error appropriately
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Chats",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add,color: Colors.pink,size: 20,),
                          SizedBox(width: 2,),
                          Text("New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),

              itemBuilder: (context, index){
                return ChatUsersList(
                  fullname: chatUsers[index].text,
                  secondaryText: chatUsers[index].secondaryText,
                  image: chatUsers[index].image,
                  time: chatUsers[index].time,
                  isMessageRead: !chatUsers[index].read,
                  chatId: chatUsers[index].chatId,  // Add this
                  otherParticipantId: chatUsers[index].otherParticipantId,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
  @override
  void dispose() {
    channel!.sink.close();
    _webSocketSubscription?.cancel();
    super.dispose();
  }
}