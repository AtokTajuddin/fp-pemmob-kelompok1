import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../data/transaction_repository.dart';
import '../domain/transaction_model.dart';
import 'browser_geolocation.dart';

typedef PlacemarkResolver =
    Future<List<Placemark>> Function(double latitude, double longitude);

/// Lightweight snapshot describing a detected device location for transactions.
@immutable
class TransactionLocationSnapshot {
  const TransactionLocationSnapshot({
    required this.latitude,
    required this.longitude,
    this.description,
  });

  final double latitude;
  final double longitude;
  final String? description;
}

/// Coordinates photo capture, geotagging, and persistence for transactions.
class TransactionService {
  TransactionService({
    required TransactionRepository repository,
    ImagePicker? imagePicker,
    GeolocatorPlatform? geolocator,
    PlacemarkResolver? placemarkResolver,
    Uuid? uuid,
  }) : _repository = repository,
       _imagePicker = imagePicker ?? ImagePicker(),
       _geolocator = geolocator ?? GeolocatorPlatform.instance,
       _placemarkResolver = placemarkResolver ?? placemarkFromCoordinates,
       _uuid = uuid ?? const Uuid();

  final TransactionRepository _repository;
  final ImagePicker _imagePicker;
  final GeolocatorPlatform _geolocator;
  final PlacemarkResolver _placemarkResolver;
  final Uuid _uuid;

  Future<XFile?> captureReceiptImage({
    ImageSource source = ImageSource.camera,
  }) async => _imagePicker.pickImage(source: source);

  Future<TransactionModel> submitTransaction({
    required double amount,
    required String category,
    required DateTime date,
    required String note,
    XFile? imageFile,
    double? latitude,
    double? longitude,
    String? locationName,
  }) async {
    var lat = latitude;
    var lng = longitude;
    var resolvedName = locationName;

    final shouldResolveLocation =
        lat == null || lng == null || resolvedName == null;
    if (shouldResolveLocation) {
      try {
        final snapshot = await detectCurrentLocation();
        if (snapshot != null) {
          lat ??= snapshot.latitude;
          lng ??= snapshot.longitude;
          resolvedName ??= snapshot.description;
        }
      } catch (error, stackTrace) {
        debugPrint('⚠️ Auto location detect failed: $error');
        debugPrint('$stackTrace');
      }
    }

    final transaction = TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      date: date,
      note: note,
      latitude: lat,
      longitude: lng,
      locationName: resolvedName,
    );

    return _repository.addTransaction(transaction, imageFile: imageFile);
  }

  /// Attempts to capture the device location plus a friendly description.
  /// Returns `null` when permissions are denied or services disabled.
  Future<TransactionLocationSnapshot?> detectCurrentLocation() async {
    try {
      final position = await _tryAcquirePosition();
      if (position == null) {
        return null;
      }
      final description = await _tryResolveLocationName(
        position.latitude,
        position.longitude,
      );
      return TransactionLocationSnapshot(
        latitude: position.latitude,
        longitude: position.longitude,
        description: description,
      );
    } catch (error, stackTrace) {
      debugPrint('⚠️ detectCurrentLocation failed: $error');
      debugPrint('$stackTrace');
      return null;
    }
  }

  Future<List<TransactionModel>> getRecentTransactions({int limit = 20}) {
    return _repository.getRecentTransactions(limit: limit);
  }

  Stream<List<TransactionModel>> watchRecentTransactions({int limit = 20}) {
    return _repository.watchRecentTransactions(limit: limit);
  }

  Future<void> deleteTransaction(String transactionId) {
    return _repository.deleteTransaction(transactionId);
  }

  Future<Position?> _tryAcquirePosition() async {
    bool serviceEnabled = true;
    try {
      final enabledResult = await _geolocator.isLocationServiceEnabled();
      serviceEnabled = enabledResult == true;
    } catch (error, stackTrace) {
      debugPrint('⚠️ isLocationServiceEnabled failed: $error');
      debugPrint('$stackTrace');
      serviceEnabled = true; // Assume enabled when API unsupported (web)
    }

    if (!serviceEnabled) {
      if (kIsWeb) {
        debugPrint(
          '⚠️ Location service reported disabled on web; continuing anyway.',
        );
      } else {
        debugPrint('⚠️ Location service disabled on device.');
        return null;
      }
    }

    if (kIsWeb) {
      final browserPosition = await getBrowserPosition();
      if (browserPosition != null) {
        return browserPosition;
      }
      debugPrint('⚠️ Browser geolocation fallback failed; trying plugin API.');

      try {
        return _geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
      } on Exception catch (error, stackTrace) {
        debugPrint('⚠️ getCurrentPosition (web) failed: $error');
        debugPrint('$stackTrace');
        return null;
      }
    }

    LocationPermission permission;
    try {
      permission = await _geolocator.checkPermission();
    } catch (error, stackTrace) {
      debugPrint('⚠️ checkPermission failed: $error');
      debugPrint('$stackTrace');
      permission = LocationPermission.denied;
    }

    if (permission == LocationPermission.denied) {
      try {
        permission = await _geolocator.requestPermission();
      } catch (error, stackTrace) {
        debugPrint('⚠️ requestPermission failed: $error');
        debugPrint('$stackTrace');
        return null;
      }
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint('⚠️ Location permission not granted: $permission');
      return null;
    }

    try {
      return _geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('⚠️ getCurrentPosition failed: $error');
      debugPrint('$stackTrace');
      return null;
    }
  }

  Future<String?> _tryResolveLocationName(
    double latitude,
    double longitude,
  ) async {
    // geocoding package does not support web; skip reverse geocoding there.
    if (kIsWeb) {
      return null;
    }

    try {
      final placemarks = await _placemarkResolver(latitude, longitude);
      if (placemarks.isEmpty) {
        return null;
      }
      final place = placemarks.first;
      final parts = [
        if (place.name != null && place.name!.isNotEmpty) place.name,
        if (place.locality != null && place.locality!.isNotEmpty)
          place.locality,
      ].whereType<String>();
      final description = parts.join(', ');
      return description.isNotEmpty ? description : place.street;
    } catch (error, stackTrace) {
      debugPrint('⚠️ Reverse geocoding failed: $error');
      debugPrint('$stackTrace');
      return null;
    }
  }
}
