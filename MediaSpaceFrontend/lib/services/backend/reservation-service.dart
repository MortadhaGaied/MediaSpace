import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/reservation.dart';

class ReservationService {
  final String baseUrl = 'http://172.29.64.1:8086/reservation';

  Future<Reservation> addReservation(Reservation reservation) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Reservation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create reservation.');
    }
  }

  Future<Reservation> updateReservation(Reservation reservation) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${reservation.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update reservation.');
    }
  }

  Future<void> deleteReservation(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete reservation.');
    }
  }

  Future<Reservation> getReservation(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to retrieve reservation.');
    }
  }

  Future<List<Reservation>> getAllReservations() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<Reservation>.from(l.map((model) => Reservation.fromJson(model)));
    } else {
      throw Exception('Failed to retrieve reservations.');
    }
  }
  Future<List<Reservation>> getReservationsByUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/byuser/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> reservationsJson = jsonDecode(response.body);
      return reservationsJson.map((json) => Reservation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reservations for user ID: $userId');
    }
  }
}
