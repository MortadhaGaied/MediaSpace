import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/message.dart';

class MessagingService {
  final String baseUrl = 'http://192.168.1.15:8083/messaging';

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
}
