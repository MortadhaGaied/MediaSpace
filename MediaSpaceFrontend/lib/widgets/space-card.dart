import 'package:flutter/material.dart';

import '../pages/search-pages/space-details-page.dart';

class SpaceCard extends StatelessWidget {
  final Map space;

  SpaceCard({required this.space});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpaceDetailsPage(spaceId: space['id']),  // Pass the space id
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
                        // TODO: Implement add to whitelist logic
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
                    Text("\$${space['price'].toString()}"),
                    Text("Max guests: ${space['maxGuest'].toString()}"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
