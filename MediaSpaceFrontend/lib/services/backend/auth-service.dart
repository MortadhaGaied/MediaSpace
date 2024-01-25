import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final String baseUrl = 'http://192.168.192.1:8081/auth';
  final storage = new FlutterSecureStorage();
  Future<http.Response> register(Map<String, dynamic> requestData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      await storage.write(
          key: "accessToken", value: responseBody['accessToken']);
      await storage.write(
          key: "refreshToken", value: responseBody['refreshToken']);
      await storage.write(key: "id", value: responseBody['id'].toString());
      //await storage.write(key: "isConnected", value: 'true');
    }
    return response;
  }

  Future<http.Response> authenticate(Map<String, dynamic> requestData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      await storage.write(
          key: "accessToken", value: responseBody['accessToken']);
      await storage.write(
          key: "refreshToken", value: responseBody['refreshToken']);
      await storage.write(key: "id", value: responseBody['id'].toString());
      //await storage.write(key: "isConnected", value: 'true');
    }
    return response;
  }

  Future<bool> validateToken(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/validate?token=$token'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body.toLowerCase() == 'true';
    } else {
      throw Exception('Failed to validate token');
    }
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to refresh token');
    }
  }
  Future<void> logout() async {
    await storage.delete(key: "accessToken");
    await storage.delete(key: "refreshToken");
    await storage.delete(key: "id");
  }
  Future<bool> isLoggedIn() async {
    String? accessToken = await storage.read(key: "accessToken");
    String? refreshToken = await storage.read(key: "refreshToken");
    String? id = await storage.read(key: "id");
    print(accessToken);

    return accessToken != null && refreshToken != null && id != null && accessToken.isNotEmpty && refreshToken.isNotEmpty && id.isNotEmpty;
  }
  Future<Map<String, dynamic>> getCurrentUser() async {
    if (await isLoggedIn()) {
      String? id = await storage.read(key: "id");
      final response = await http.get(Uri.parse('$baseUrl/getUserById/$id'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        return jsonDecode(response.body);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load user');
      }
    } else {
      // Handle the case where the user is not logged in.
      // This example throws an exception, but you might want to handle this case differently.
      throw Exception('User not logged in');
    }
  }
  Future<String> getUrlFile(String filename) async {
    final response = await http.get(
      Uri.parse('$baseUrl/urlProfilePicture/$filename'),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON. This assumes your service returns the URL as a raw string.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load URL');
    }
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/getUserById/$id'));

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return json.decode(response.body);
    } else {
      // If the server returns an error, throw an exception.
      throw Exception('Failed to load user');
    }
  }

}
