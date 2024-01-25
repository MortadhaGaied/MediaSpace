
import 'dart:async';
import 'dart:convert';

import 'package:MediaSpaceFrontend/services/backend/auth-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../services/backend/messaging-service.dart';
import '../../services/models/message.dart';


class ChatDetailPage extends StatefulWidget {
  final int chatId;
  final int otherParticipantId;

  ChatDetailPage({required this.chatId, required this.otherParticipantId});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<Message> messages = []; // Replace with your Message model
  String? otherParticipantName;
  String? otherParticipantImage;
  final AuthenticationService authService=AuthenticationService();
  final MessagingService messagingService = MessagingService();
  final TextEditingController _messageController = TextEditingController();

  WebSocketChannel? channel;
  StreamSubscription? _webSocketSubscription;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://172.28.160.1:8083/ws');
    _webSocketSubscription = channel!.stream.listen(
          (message) {
        final Map<String, dynamic> messageData = jsonDecode(message);
        setState(() {
          messages.add(Message.fromJson(messageData));
        });
      },
      onError: (error) {
        print("WebSocket Error: $error");
        // Handle the error or attempt to reconnect
      },
    );
    fetchMessages();
    fetchOtherParticipantDetails();
  }




  fetchMessages() async {
    try {
      List<Map<String, dynamic>> fetchedMessages = await messagingService.getAllMessagesByChatId(widget.chatId);
      messages = fetchedMessages.map((messageMap) => Message.fromJson(messageMap)).toList();

      setState(() {}); // Update the UI
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle the error appropriately
    }
  }


  fetchOtherParticipantDetails() async {
    try {
      Map<String, dynamic> user = await authService.getUserById(widget.otherParticipantId);
      otherParticipantName = "${user['firstname']} ${user['lastname']}";
      otherParticipantImage = user['profile_picture'];

      setState(() {}); // Update the UI
    } catch (e) {
      print("Error fetching other participant details: $e");
      // Handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            FutureBuilder<String>(
              future: authService.getUrlFile(otherParticipantImage ?? ''),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!),
                  );
                }
              },
            ),
            SizedBox(width: 10),
            Text(otherParticipantName ?? ''),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Option 1"),
              ),
              PopupMenuItem(
                child: Text("Option 2"),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // This will start the list from the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isOwnMessage = message.senderId != widget.otherParticipantId; // Changed the condition to correctly identify own messages
                return Align(
                  alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isOwnMessage ? Colors.blue : Colors.orange,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isOwnMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    final content = _messageController.text;
                    if (content.isNotEmpty) {
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      final message = Message(
                        id: 0,
                        chatId: widget.chatId,
                        senderId: 10, // Replace with the current user's ID
                        recipientId: widget.otherParticipantId,
                        content: content,
                        timestamp: timestamp,
                        read: false,
                      );

                      // Save the message to the database
                      final savedMessage = await messagingService.sendAndSaveMessage(message);

                      // Send the message through WebSocket

                      channel!.sink.add(jsonEncode(savedMessage.toJson()));



                      // Add the message to your local messages list
                      setState(() {
                        messages.insert(0, savedMessage);
                      });

                      _messageController.clear();
                    }
                  },
                )




              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    channel!.sink.close();
    _webSocketSubscription?.cancel();
    super.dispose();
  }
}
