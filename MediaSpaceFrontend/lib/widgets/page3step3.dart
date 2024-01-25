import 'package:flutter/material.dart';

import '../services/models/space_event_price.dart';

class PageThreeStep3 extends StatefulWidget {

  final List<SpaceEventPrice>? eventPrices;

  PageThreeStep3({this.eventPrices});

  @override
  _PageThreeStep3State createState() => _PageThreeStep3State();
}

class _PageThreeStep3State extends State<PageThreeStep3> {
  int price = 25;
  bool isMeeting = false;
  bool isParty = false;
  bool isProduction = false;
  double meetingPercentage = 0.0;
  double partyPercentage = 0.0;
  double productionPercentage = 0.0;
  List<SpaceEventPrice> eventPrices=[];



  Widget customCheckbox(
      String title,
      String details,
      bool value,
      Function(bool?) onChanged,
      SpaceEventType eventType,
      double percentage,
      Function(double) onSliderChanged) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.black,
          ),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(details),
        ),
        if (value) ...[
          Slider(
            value: percentage,
            onChanged: onSliderChanged,
            min: 0.0,
            max: 1.0,
            label: "${calculatePrice(percentage)} DT",
          ),
          Text(
            "This will be the price per hour for your space when holding this type of event: ",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16), // Increased font size
          ),
          Text("${calculatePrice(percentage)} DT/hour",
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 25)
          )
        ],
      ],
    );
  }

  String calculatePrice(double percentage) {
    double calculatedValue = price + (price * percentage);
    return calculatedValue.toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Maintenant, définissez votre prix",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Vous pouvez le modifier à tout moment."),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (price > 0) price--;
                    });
                  },
                  child: Icon(Icons.remove, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
                SizedBox(width: 10),  // Added space
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text("$price DT"),
                ),
                SizedBox(width: 10),  // Added space
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      price++;
                    });
                  },
                  child: Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Quelle type d’événement votre espace peut accueillir",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            customCheckbox(
                "Réunion",
                "• Ateliers\n• Présentations\n• Retraites\n• Plus",
                isMeeting, (value) {
              setState(() {
                isMeeting = value!;
                if (!isMeeting) {
                  eventPrices.removeWhere((item) => item.eventType == SpaceEventType.MEETING);
                } else {
                  eventPrices.add(SpaceEventPrice(id: null, eventType: SpaceEventType.MEETING, price: price.toDouble() * meetingPercentage));
                }
              });
            },
                SpaceEventType.MEETING,
                meetingPercentage, (newPercentage) {
              setState(() {
                meetingPercentage = newPercentage;
                eventPrices.firstWhere((item) => item.eventType == SpaceEventType.MEETING).price = price.toDouble() * meetingPercentage;
              });
            }),
            customCheckbox(
                "Soirée",
                "• Anniversaires\n• Fête d'entreprise\n• Fête entre jeunes\n• Plus",
                isParty, (value) {
              setState(() {
                isParty = value!;
                if (!isParty) {
                  eventPrices.removeWhere((item) => item.eventType == SpaceEventType.PARTY);
                } else {
                  eventPrices.add(SpaceEventPrice(id: null, eventType: SpaceEventType.PARTY, price: price.toDouble() * partyPercentage));
                }
              });
            },
                SpaceEventType.PARTY,
                partyPercentage, (newPercentage) {
              setState(() {
                partyPercentage = newPercentage;
                eventPrices.firstWhere((item) => item.eventType == SpaceEventType.PARTY).price = price.toDouble() * partyPercentage;
              });
            }),
            customCheckbox(
                "Production",
                "• Tournages\n• Shooting\n• Enregistrement audio\n• Plus",
                isProduction, (value) {
              setState(() {
                isProduction = value!;
                if (!isProduction) {
                  eventPrices.removeWhere((item) => item.eventType == SpaceEventType.PRODUCTION);
                } else {
                  eventPrices.add(SpaceEventPrice(id: null, eventType: SpaceEventType.PRODUCTION, price: price.toDouble() * productionPercentage));
                }
              });
            },
                SpaceEventType.PRODUCTION,
                productionPercentage, (newPercentage) {
              setState(() {
                productionPercentage = newPercentage;
                eventPrices.firstWhere((item) => item.eventType == SpaceEventType.PRODUCTION).price = price.toDouble() * productionPercentage;
              });
            }),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PageThreeStep3(),
  ));
}
