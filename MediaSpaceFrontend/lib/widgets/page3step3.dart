import 'package:flutter/material.dart';

class PageThreeStep3 extends StatefulWidget {
  @override
  _PageThreeStep3State createState() => _PageThreeStep3State();
}

class _PageThreeStep3State extends State<PageThreeStep3> {
  int price = 20;
  bool isMeeting = false;
  bool isParty = false;
  bool isProduction = false;

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
            SizedBox(height: 5),  // Added space
            Text(
              "Par heure",
              style: TextStyle(fontSize: 16),  // Increased font size
            ),
            SizedBox(height: 20),
            Text(
              "Quelle type d’événement votre espace peut accueillir",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text("Réunion"),
              subtitle: Text("• Ateliers\n• Présentations\n• Retraites\n• Plus"),
              value: isMeeting,
              onChanged: (newValue) {
                setState(() {
                  isMeeting = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: Text("Soirée"),
              subtitle: Text("• Anniversaires\n• Fête d'entreprise\n• Fête entre jeunes\n• Plus"),
              value: isParty,
              onChanged: (newValue) {
                setState(() {
                  isParty = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: Text("Production"),
              subtitle: Text("• Tournages\n• Shooting\n• Enregistrement audio\n• Plus"),
              value: isProduction,
              onChanged: (newValue) {
                setState(() {
                  isProduction = newValue!;
                });
              },
            ),
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
