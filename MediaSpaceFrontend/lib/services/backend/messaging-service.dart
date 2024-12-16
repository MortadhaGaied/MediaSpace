import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/chat.dart';
import '../models/message.dart';

class MessagingService {
  final String baseUrl = 'http://172.29.64.1:8083';

  Future<Message> sendMessage(Message message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messaging/sendMessage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<List<Message>> getChatMessages(String chatId) async {
    final response = await http.get(Uri.parse('$baseUrl/messaging/$chatId'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Message> messages = List<Message>.from(jsonResponse.map((model) => Message.fromJson(model)));
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final response = await http.delete(Uri.parse('$baseUrl/messaging/message/$messageId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }

  Future<Message> getMessage(String messageId) async {
    final response = await http.get(Uri.parse('$baseUrl/messaging/message/$messageId'));

    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message');
    }
  }

  Future<List<Message>> getUnreadMessages(String chatId) async {
    final response = await http.get(Uri.parse('$baseUrl/messaging/$chatId/unread-messages'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Message> messages = List<Message>.from(jsonResponse.map((model) => Message.fromJson(model)));
      return messages;
    } else {
      throw Exception('Failed to load unread messages');
    }
  }
  Future<List<Chat>> getAllChats(int participantId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/chat/allChats/$participantId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Chat.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }
  Future<Map<String, dynamic>?> getLastMessage(int chatId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/chat/last/$chatId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null; // Message not found
    } else {
      throw Exception('Failed to load last message');
    }
  }
  Future<List<Map<String, dynamic>>> getAllMessagesByChatId(int chatId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/chat/chat/$chatId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
  Future<Message> sendAndSaveMessage(Message message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/message/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send and save message');
    }
  }


}
