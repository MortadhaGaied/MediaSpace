import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMap extends StatelessWidget {
  final List<LatLng> positions;

  CustomMap({required this.positions});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Adjust the height as needed
      child: FlutterMap(
        options: MapOptions(
          center: positions.isNotEmpty ? positions.first : LatLng(0, 0),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: positions.map((position) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: position,
                builder: (ctx) => Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
