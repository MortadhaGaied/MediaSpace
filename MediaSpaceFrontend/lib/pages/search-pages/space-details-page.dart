import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/backend/space-service.dart';
import '../../services/backend/auth-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/image-slider.dart';
import '../../widgets/map.dart';
import '../reservation/make_reservation.dart';
class SpaceDetailsPage extends StatefulWidget {
  final int spaceId;


  SpaceDetailsPage({required this.spaceId});

  @override
  _SpaceDetailsPageState createState() => _SpaceDetailsPageState();
}

class _SpaceDetailsPageState extends State<SpaceDetailsPage> {
  int currentPage = 0; // Track the current image displayed
  bool isFavorited = false; // Track whether the item is favorited
  final PageController pageController = PageController(initialPage: 0);
  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }
  Map<String, dynamic> space = {};
  Map<String, dynamic> owner = {};
  bool isLoading = true;
  SpaceService spaceService = SpaceService();
  AuthenticationService authenticationService = AuthenticationService();
  @override
  void initState() {
    super.initState();
    fetchSpaceDetails();
  }

  void fetchSpaceDetails() async {
    try {

      http.Response response = await spaceService.retrieveSpace(widget.spaceId);

      if (response.statusCode == 200) {
        setState(() {
          space = json.decode(response.body);
        });

        try {
          Map<String, dynamic> ownerResponse = await authenticationService.getUserById(space['ownerId']);
          setState(() {
            owner = ownerResponse;
            print("*5658***********655645-**********6551*/54848");
            print(owner);
            isLoading = false;
          });
        } catch (e) {
          print("Error fetching owner details: $e");
        }

      } else {
        print("Failed to load space details");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
  Widget buildExpandablePanel(String header, Widget expandedContent, {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 2),

          bottom: isLast ? BorderSide(color: Colors.black, width: 2) : BorderSide.none,
        ),
      ),
      child: ExpandableNotifier(
        child: Column(
          children: [
            ExpandablePanel(
              header: Container(
                alignment: Alignment.center,
                height: 50,  // You can adjust the height as needed
                child: Text(
                  header,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              collapsed: Container(),
              expanded: Padding(
                padding: const EdgeInsets.all(8.0),
                child: expandedContent,
              ),
            ),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Space Details')),
      body: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
        child: Column(
          children: [
            // Image Slider
            Container(
              height: 350,
              child: MyImageSlider(images: space['images']), // This should be fine now.
            ),


            SizedBox(height: 10),
            // Price, Guest, Reserve Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("\$${space['price']}/hr"
                ,style: TextStyle(fontSize: 35),),
                Text(
                  "${space['maxGuest']} guests",
                  style: TextStyle(
                    // Add your text style
                  ),
                ),

              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservationRequestWidget()),
                  );},
                  child: Text(
                    'Reservez',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30// Text color
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFA51E), // Background color
                    minimumSize: Size(295, 62),  // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35), // Corner radius
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Owner Info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(
                width: 70,
                height: 70,
                child: FutureBuilder<String>(
                  future: authenticationService.getUrlFile(owner['profile_picture']), // your future function here
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error);  // You can return an Icon or some other widget
                    } else {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!),
                      );
                    }
                  },
                ),
              ),



              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${owner['firstname']} ${owner['lastname']}"),
              ],
            ),
            SizedBox(height: 10),
            // Address
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on),
                Text("${space['address']['city']} ${space['address']['state']}"),

              ],
            ),
            SizedBox(height: 10),
            buildExpandablePanel(
              'Map',
              CustomMap(
                positions: [
                  LatLng(36.806389, 10.181667), // Add more LatLng instances if needed
                ],
              ),
            ),
            buildExpandablePanel(
              'À propos de l’espace',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• Description: ${space['description']}"),
                  Text("• Max guest: ${space['maxGuest']}"),
                  Text("• Number of rooms: ${space['roomNumber']}"),
                  Text("• Number of bathroom: ${space['bathroomNumber']}"),
                  Text("• Restricted age between ${space['restrictedMinAge']} and ${space['restrictedMaxAge']}"),
                  Text("• Space type: ${space['spaceType']}"),
                ],
              ),
            ),

            buildExpandablePanel(
              'Equipement',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...space['equipments'].map((e) => Text("• $e")).toList(),
                  if (space['equipments'].isEmpty) Text("No equipment in this space."),
                  ...space['amenities'].map((a) => Text("• $a")).toList(),
                ],
              ),
            ),

            buildExpandablePanel("Règle d'espace", Text("${space['spaceRule']}")),
            buildExpandablePanel(
              'Accessibilité',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...space['accessibility'].map((a) => Text("• $a")).toList(),
                ],
              ),
            ),

            buildExpandablePanel('Avis d’espace', Text("${space['spaceRule']}"), isLast: true),




          ],
        ),
      ),
    );
  }
}
