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

  Map<String, SpaceAvailability?> selectedTimes = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };
  List<SpaceAvailability> spaceAvailabilityList = [];


  void addOrUpdateAvailability(String day) {
    spaceAvailabilityList.removeWhere((av) => av.dayOfWeek == day);

    if (daysOpen[day]! && selectedTimes[day] != null) {
      spaceAvailabilityList.add(selectedTimes[day]!);
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(day),
                        Row(
                          children: [
                            Text(daysOpen[day]! ? "Ouvert" : "Fermer"),
                            Switch(
                              value: daysOpen[day]!,
                              onChanged: (value) {
                                setState(() {
                                  daysOpen[day] = value;
                                  //addOrUpdateAvailability(day);
                                });
                              },
                              activeColor: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (daysOpen[day]!)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("De: "),
                          TimePickerSpinner(
                            onTimeChange: (time) {
                              setState(() {
                                if (selectedTimes[day] == null) {
                                  selectedTimes[day] = SpaceAvailability(
                                    dayOfWeek: day,
                                    startTime: TimeOfDay.fromDateTime(time),
                                    endTime: TimeOfDay(hour: 0, minute: 0),
                                  );
                                } else {
                                  selectedTimes[day]!.startTime = TimeOfDay.fromDateTime(time);
                                }
                                addOrUpdateAvailability(day);
                              });
                            },
                          ),
                          SizedBox(width: 10),
                          Text("À: "),
                          TimePickerSpinner(
                            onTimeChange: (time) {
                              setState(() {
                                if (selectedTimes[day] == null) {
                                  selectedTimes[day] = SpaceAvailability(
                                    dayOfWeek: day,
                                    startTime: TimeOfDay(hour: 0, minute: 0),
                                    endTime: TimeOfDay.fromDateTime(time),
                                  );
                                } else {
                                  selectedTimes[day]!.endTime = TimeOfDay.fromDateTime(time);
                                }
                                addOrUpdateAvailability(day);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }).toList(),
            ElevatedButton(
              onPressed: () {
                print(spaceAvailabilityList);
              },
              child: Text("Print List"),
            ),
          ],
        ),
      ),
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
