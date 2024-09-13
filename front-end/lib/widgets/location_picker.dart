import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_buddy_frontend/controllers/location_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends StatefulWidget {
  final LatLng myLocation;

  const LocationPicker({super.key, required this.myLocation});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _centerLocation;

  final MapController _mapController = MapController();

  void _onMapMove() {
    setState(() {
      _centerLocation = _mapController.camera.center;
    });
  }

  @override
  Widget build(BuildContext context) {
    _centerLocation ??= widget.myLocation;
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          // onTap: (tapPosition, point) {
          //   _onMapTap(point);
          // },
          onPositionChanged: (camera, hasGesture) {
            if (hasGesture) {
              _onMapMove();
            }
          },

          initialCenter: widget.myLocation,
          initialZoom: 12.5,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                  point: _centerLocation!,
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                  alignment: Alignment.topCenter),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.pin_drop),
        onPressed: () {
          // Do something with the selected location
          // For example, print the coordinates
          print('Selected location: $_centerLocation');
        },
      ),
    );
  }
}
