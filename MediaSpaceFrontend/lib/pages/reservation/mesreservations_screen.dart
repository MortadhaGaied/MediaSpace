import 'package:MediaSpaceFrontend/services/backend/auth-service.dart';
import 'package:MediaSpaceFrontend/services/backend/space-service.dart';
import 'package:MediaSpaceFrontend/services/models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/backend/reservation-service.dart'; // Import your ReservationService
import '../../widgets/reservation-card.dart'; // Import ReservationCard
import '../../widgets/custom_bottomNavigationBar.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<Reservation> reservationList = [];
  List<dynamic> spaceList = [];
  final AuthenticationService authenticationService = AuthenticationService(); // Create an instance

  @override
  void initState() {
    super.initState();
    fetchReservations();
    print(reservationList);
  }

  void fetchReservations() async {
    try {
      ReservationService reservationService = ReservationService();
      Map<String, dynamic> currentUser = await authenticationService
          .getCurrentUser();
      int userId = currentUser['id'];

      var reservations = await reservationService.getReservationsByUser(userId);
      List<Reservation> updatedReservations = [];

      for (var reservation in reservations) {
        var spaceData = await fetchSpaceByReservation(reservation.idSpace);
        updatedReservations.add(reservation);
        spaceList.add(spaceData);
      }

      setState(() {
        reservationList = updatedReservations;
      });
    } catch (e) {
      print("Error fetching reservations: $e");
    }
  }

  Future<dynamic> fetchSpaceByReservation(int idSpace) async {
    SpaceService spaceService = SpaceService();
    http.Response response = await spaceService.retrieveSpace(idSpace);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to retrieve space: ${response.statusCode}');
      return {}; // Return empty object or handle error appropriately
    }
  }


  @override
  Widget build(BuildContext context) {
    // Calculate the width of the screen and the desired width of each grid item
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double cardWidth = (screenWidth - 30) /
        2; // Assuming 10px padding on both sides and 10px grid spacing
    double cardHeight = cardWidth *
        1.5; // Example, can adjust based on your design
    double childAspectRatio = cardWidth / cardHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10, // Spacing between columns
            mainAxisSpacing: 30, // Spacing between rows
            childAspectRatio: childAspectRatio, // Adjust based on your content
          ),
          itemCount: reservationList.length,
          itemBuilder: (context, index) {
            return ReservationCard(
              space: spaceList[index],
              reservation: reservationList[index],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}