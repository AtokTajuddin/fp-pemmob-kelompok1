import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/config/app_env.dart';
import 'core/utils/google_maps_script_loader.dart';
import 'features/auth/data/local_auth_store.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _bootstrapGoogleMaps();

  await Hive.initFlutter();
  await LocalAuthStore.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase initialization error: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _bootstrapGoogleMaps() async {
  AppEnv.ensureGoogleMapsKey();

  if (!kIsWeb || !AppEnv.hasGoogleMapsKey) {
    return;
  }

  try {
    await ensureGoogleMapsScriptLoaded(AppEnv.googleMapsApiKey);
    debugPrint('✅ Google Maps JS loaded for web');
  } catch (error, stackTrace) {
    debugPrint('⚠️ Google Maps JS load failed: $error');
    debugPrint('$stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundo Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
        ),
      ),
      // AuthWrapper automatically handles routing based on auth state
      // Shows LoginScreen if not authenticated, HomeScreen if authenticated
      home: const AuthWrapper(),
      routes: {'/register': (context) => const RegisterScreen()},
    );
  }
}
