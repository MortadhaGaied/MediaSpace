import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../services/models/spaceavailability.dart';

class PageTwoStep3 extends StatefulWidget {
  final List<SpaceAvailability>? spaceAvailabilityList;

  PageTwoStep3({this.spaceAvailabilityList});

  @override
  _PageTwoStep3State createState() => _PageTwoStep3State();
}

class _PageTwoStep3State extends State<PageTwoStep3> {
  Map<String, bool> daysOpen = {
    'Monday   ': false,
    'Tuesday  ': false,
    'Wednesday': false,
    'Thursday ': false,
    'Friday   ': false,
    'Saturday ': false,
    'Sunday   ': false,
  };

  Map<String, TimeOfDay?> selectedTimes = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };
  List<SpaceAvailability> spaceAvailabilityList = [];
  void updateSpaceAvailability(String day) {
    if (daysOpen[day]! && selectedTimes[day] != null) {
      final availability = SpaceAvailability(
        dayOfWeek: day,
        startTime: selectedTimes[day]!,
        endTime: selectedTimes[day]!, // You can update this with the actual end time
      );
      spaceAvailabilityList.add(availability);
    } else {
      spaceAvailabilityList.removeWhere((element) => element.dayOfWeek == day);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quelles sont vos heures d’ouverture?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Les heures d’ouverture sont les jours et les heures de la semaine où votre logement est ouvert aux réservations d’hôtes (c’est-à-dire votre disponibilité générale). Les clients ne pourront pas réserver d’heures en dehors de vos heures d’ouverture",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            ...daysOpen.keys.map((day) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(day),
                      SizedBox(width: 10),
                      Switch(
                        value: daysOpen[day]!,
                        onChanged: (value) {
                          setState(() {
                            daysOpen[day] = value;
                            updateSpaceAvailability(day);  // Add this line
                          });
                        },
                        activeColor: Colors.black,
                      ),
                      Text(daysOpen[day]! ? "Ouvert" : "Fermer"),
                    ],
                  ),
                  if (daysOpen[day]!)
                    Row(
                      children: [
                        Text("From"),
                        TimePickerSpinner(
                          is24HourMode: false,
                          normalTextStyle: TextStyle(fontSize: 15, color: Colors.grey),
                          highlightedTextStyle: TextStyle(fontSize: 15, color: Colors.black),
                          spacing: 5,
                          itemHeight: 20,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {
                              selectedTimes[day] = TimeOfDay.fromDateTime(time);
                              updateSpaceAvailability(day);  // Add this line
                            });
                          },
                        ),
                        Text("To"),
                        TimePickerSpinner(
                          is24HourMode: false,
                          normalTextStyle: TextStyle(fontSize: 15, color: Colors.grey),
                          highlightedTextStyle: TextStyle(fontSize: 15, color: Colors.black),
                          spacing: 5,
                          itemHeight: 20,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {
                              selectedTimes[day] = TimeOfDay.fromDateTime(time);
                              updateSpaceAvailability(day);  // Add this line
                            });
                          },
                        ),
                      ],
                    ),
                ],
              );
            }).toList(),
            ElevatedButton(
              onPressed: () {
                for (SpaceAvailability availability in spaceAvailabilityList) {
                  print('Day of Week: ${availability.dayOfWeek}');
                  print('Start Time: ${availability.startTime.hour}:${availability.startTime.minute}');
                  print('End Time: ${availability.endTime.hour}:${availability.endTime.minute}');
                  print('---');
                }
              },
              child: Text("Print List"),
            )

          ],

        ),
      )
    );

  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: PageTwoStep3(),
    ),
  ));
}
