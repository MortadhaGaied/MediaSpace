import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
class CustomMap2 extends StatefulWidget {
  final ValueNotifier<LatLng?> pickedPosition;
  final Function(LatLng) onConfirm;
  CustomMap2({required this.pickedPosition, required this.onConfirm});

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap2> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    widget.pickedPosition.addListener(() {
      _mapController.move(widget.pickedPosition.value!, _mapController.zoom);
    });
  }

  @override
  void dispose() {
    widget.pickedPosition.removeListener(() {});
    super.dispose();
  }

  void _zoomIn() {
    final newZoom = _mapController.zoom + 1;
    _mapController.move(_mapController.center, newZoom);
  }

  void _zoomOut() {
    final newZoom = _mapController.zoom - 1;
    _mapController.move(_mapController.center, newZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: widget.pickedPosition.value ?? LatLng(0, 0),
              zoom: 15.0,
              onTap: (tapPosition, point) {
                widget.pickedPosition.value = point;
                setState(() {});
              },
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              if (widget.pickedPosition.value != null)
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: widget.pickedPosition.value!,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomIn,
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 5),
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                if (widget.pickedPosition.value != null) {
                  widget.onConfirm(widget.pickedPosition.value!);
                }
              },
              child: Text('Confirm Position'),
            ),
          ),

        ],

      ),
    );
  }
}
