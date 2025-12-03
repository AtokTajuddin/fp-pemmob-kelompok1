import 'package:flutter/foundation.dart';

/// Central place for compile-time environment values provided via --dart-define.
class AppEnv {
  const AppEnv._();

  /// Google Maps / Places API key used across platforms.
  static const googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static bool get hasGoogleMapsKey => googleMapsApiKey.isNotEmpty;

  /// Prints a helpful warning when a required env var is missing.
  static void ensureGoogleMapsKey({void Function(String message)? onMissing}) {
    if (hasGoogleMapsKey) {
      return;
    }

    final message =
        'Missing GOOGLE_MAPS_API_KEY. Pass it via --dart-define or env/maps.env.';
    if (onMissing != null) {
      onMissing(message);
    } else {
      debugPrint('⚠️ $message');
    }
  }
}
