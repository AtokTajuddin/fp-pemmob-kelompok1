// ==============================
// FILE 3: screens/map_selection_screen.dart
// ==============================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../shared_widgets/location_picker_widget.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng _center = LatLng(-6.2, 106.8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick Location")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 15,
          onPositionChanged: (pos, _) {
            _center = pos.center!;
          },
        ),
        children: [
          TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
          MarkerLayer(markers: [
            Marker(point: _center, width: 40, height: 40, child: Icon(Icons.location_pin, color: Colors.red, size: 40)),
          ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(
            context,
            SelectedLocation(latitude: _center.latitude, longitude: _center.longitude, name: "Pinned Location"),
          );
        },
      ),
    );
  }
}

