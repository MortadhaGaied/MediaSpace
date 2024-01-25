import 'package:MediaSpaceFrontend/services/models/reservation.dart';
import 'package:flutter/material.dart';

import '../pages/reservation/reservation-details-page.dart';
import '../pages/search-pages/space-details-page.dart';
import 'dart:math' as math;

import '../services/models/reservationStatus.dart';
class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final Map space;

  ReservationCard({required this.reservation, required this.space});

  @override
  Widget build(BuildContext context) {
    var statusColor = getStatusColor(reservation.reservationStatus);
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationDetailsPage(reservation: reservation,space: space,),  // Pass the space id
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust this value to your liking
        child: Card(

          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        child: SingleChildScrollView( // This makes the column scrollable
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 150.0,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: space['images'].length,
                      itemBuilder: (ctx, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                          child: Image.network(
                            space['images'][index],  // Assuming these are URLs. Adjust if not.
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.white), // Use favorite for filled heart
                      onPressed: () {
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(space['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${space['address']['street']}, ${space['address']['city']}, ${space['address']['state']}"),
                    Text("Total Price: \$${reservation.totalPrice.toStringAsFixed(2)}"),
                    Text("Participants: ${reservation.nbParticipant.toString()}"),
                    Text("Date: ${formatDate(reservation.date)}"),
                    Text("Time: ${formatTime(reservation.startTime)} - ${formatTime(reservation.endTime)}"),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        reservation.reservationStatus.name.toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        ),
      ),
    );
  }
  Color getStatusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.PENDING:
        return Colors.orange;
      case ReservationStatus.ACCEPTED:
        return Colors.green;
      case ReservationStatus.REJECTED:
        return Colors.red;
      default:
        return Colors.grey; // Default color for unknown status
    }
  }

  String formatDate(DateTime date) {
    // Format the date as needed
    return date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
  }

  String formatTime(DateTime time) {
    // Format the time as needed
    return time.hour.toString(); // Replace with actual formatting
  }
}
