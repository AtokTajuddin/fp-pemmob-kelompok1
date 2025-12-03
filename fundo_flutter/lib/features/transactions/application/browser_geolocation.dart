import 'package:geolocator/geolocator.dart';

import 'browser_geolocation_stub.dart'
    if (dart.library.html) 'browser_geolocation_web.dart';

/// Returns a browser-backed [Position] on web builds or `null` elsewhere.
Future<Position?> getBrowserPosition() => getBrowserPositionImpl();
