import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> getBrowserPositionImpl() async {
  try {
    final geolocation = html.window.navigator.geolocation;
    final geoposition = await geolocation.getCurrentPosition(
      enableHighAccuracy: true,
    );
    final coords = geoposition.coords;
    if (coords == null) {
      return null;
    }

    return Position(
      latitude: coords.latitude?.toDouble() ?? 0,
      longitude: coords.longitude?.toDouble() ?? 0,
      accuracy: coords.accuracy?.toDouble() ?? 0,
      altitude: coords.altitude?.toDouble() ?? 0,
      altitudeAccuracy: coords.altitudeAccuracy?.toDouble() ?? 0,
      heading: coords.heading?.toDouble() ?? 0,
      headingAccuracy: 0,
      speed: coords.speed?.toDouble() ?? 0,
      speedAccuracy: 0,
      timestamp: DateTime.now(),
      isMocked: false,
    );
  } catch (error, stackTrace) {
    debugPrint('⚠️ Browser geolocation error: $error');
    debugPrint('$stackTrace');
    return null;
  }
}
