import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart'; // Make sure this is in pubspec.yaml
import 'app.dart';

void main() async {
  // 1. Ensure Flutter bindings are ready before doing anything else
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Try to initialize Firebase
  // We wrap this in a try-catch so you can test the UI immediately.
  try {
    // UNCOMMENT THIS when you have added google-services.json
    await Firebase.initializeApp();
    debugPrint("✅ Firebase Initialized Successfully");
  } catch (e) {
    debugPrint("⚠️ Firebase Failed (Expected if setup is incomplete): $e");
  }

  // 3. Run the App
  runApp(const ProviderScope(child: FundoApp()));
}
