
// ==============================
// FILE 4: shared_widgets/transaction_map_display.dart
// ==============================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/transaction_location.dart';

class TransactionMapDisplay extends StatelessWidget {
  final List<TransactionLocation> transactions;

  const TransactionMapDisplay({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: LatLng(-6.2, 106.8), initialZoom: 13),
      children: [
        TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
        MarkerLayer(
          markers: transactions
              .map(
                (t) => Marker(
                  point: LatLng(t.latitude, t.longitude),
                  width: 40,
                  height: 40,
                  child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

