// ==============================
// FILE 2: shared_widgets/location_picker_widget.dart
// ==============================

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SelectedLocation {
  final double latitude;
  final double longitude;
  final String name;
  SelectedLocation({required this.latitude, required this.longitude, required this.name});
}

class LocationPickerWidget extends StatefulWidget {
  final Function(SelectedLocation?) onLocationSelected;
  const LocationPickerWidget({super.key, required this.onLocationSelected});

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  SelectedLocation? _location;
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw Exception("Permission denied");
    }

    if (permission == LocationPermission.deniedForever) throw Exception("Permission denied forever");

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _fetchLocation() async {
    setState(() => _loading = true);

    try {
      final pos = await _determinePosition();
      final places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final place = places.first;
      final name = place.street ?? place.name ?? "Unknown";

      _location = SelectedLocation(latitude: pos.latitude, longitude: pos.longitude, name: name);
      _controller.text = name;
      widget.onLocationSelected(_location);
    } catch (e) {
      _controller.text = "Location unavailable";
    }

    setState(() => _loading = false);
  }

  void _openMapPicker() async {
    final result = await Navigator.pushNamed(context, "/map-select", arguments: _location);
    if (result != null && result is SelectedLocation) {
      setState(() => _location = result);
      _controller.text = result.name;
      widget.onLocationSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: _fetchLocation,
              icon: Icon(Icons.refresh),
              label: Text("Refresh"),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            _loading ? CircularProgressIndicator() : Icon(Icons.location_pin, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(border: InputBorder.none),
                onChanged: (value) {
                  if (_location != null) {
                    _location = SelectedLocation(
                      latitude: _location!.latitude,
                      longitude: _location!.longitude,
                      name: value,
                    );
                    widget.onLocationSelected(_location);
                  }
                },
              ),
            ),
            TextButton(onPressed: _openMapPicker, child: Text("Pick on Map"))
          ]),
        )
      ],
    );
  }
}

