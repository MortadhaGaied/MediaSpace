import 'dart:convert';
import 'package:http/http.dart' as http;

class SpaceService {
  final String baseApiUrl = "http://192.168.192.1:8082/space";

  Future<http.Response> addSpace(Map<String, dynamic> space) async {
    final response = await http.post(
      Uri.parse(baseApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(space),
    );
    return response;
  }

  Future<http.Response> updateSpace(int id, Map<String, dynamic> space) async {
    final response = await http.put(
      Uri.parse('$baseApiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(space),
    );
    return response;
  }

  Future<http.Response> deleteSpace(int id) async {
    final response = await http.delete(
      Uri.parse('$baseApiUrl/$id'),
    );
    return response;
  }

  Future<http.Response> retrieveSpace(int id) async {
    final response = await http.get(
      Uri.parse('$baseApiUrl/$id'),
    );
    return response;
  }

  Future<http.Response> retrieveAllSpaces() async {
    final response = await http.get(
      Uri.parse(baseApiUrl),
    );
    return response;
  }

  Future<http.Response> addEquipmentAndAssignToSpace(
      int spaceId, Map<String, dynamic> equipment) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl/$spaceId/equipment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(equipment),
    );
    return response;
  }
}
