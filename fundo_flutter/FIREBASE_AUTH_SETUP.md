# Firebase Authentication Setup Guide

## ✅ Completed Setup

### 1. Dependencies Installed

The following packages have been added to `pubspec.yaml`:

- `firebase_core: ^3.15.2` - Firebase core functionality
- `firebase_auth: ^5.7.0` - Firebase authentication
- `google_sign_in: ^6.3.0` - Google sign-in integration
- `flutter_riverpod: ^2.6.1` - State management

### 2. Authentication Structure Created

```
lib/features/auth/
├── data/
│   └── auth_repository.dart        # Firebase auth implementation
├── domain/
│   ├── app_user.dart               # User model
│   ├── app_user.freezed.dart       # Generated freezed code
│   ├── app_user.g.dart             # Generated JSON serialization
│   ├── auth_state.dart             # Auth state management
│   └── auth_state.freezed.dart     # Generated freezed code
└── presentation/
    └── controllers/
        └── auth_controller.dart    # Riverpod auth controller
```

## 🔥 Firebase Configuration (NEXT STEPS)

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select existing project
3. Follow the setup wizard

### Step 2: Configure Android App

1. In Firebase Console, add an Android app
2. Download `google-services.json`
3. Place it in `fundo_flutter/android/app/google-services.json`

4. Update `android/build.gradle.kts`:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

5. Update `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this
}

android {
    defaultConfig {
        minSdk = 21 // Firebase requires minSdk 21
    }
}
```

### Step 3: Configure iOS App

1. In Firebase Console, add an iOS app
2. Download `GoogleService-Info.plist`
3. Place it in `fundo_flutter/ios/Runner/GoogleService-Info.plist`
4. Open `ios/Runner.xcworkspace` in Xcode and add the file to the project

### Step 4: Enable Authentication Methods

In Firebase Console:

1. Go to **Authentication** > **Sign-in method**
2. Enable:
   - **Email/Password**
   - **Google** (configure OAuth consent screen)

### Step 5: Configure Google Sign-In (Android)

1. Get your SHA-1 certificate fingerprint:

```powershell
cd android
./gradlew signingReport
```

2. Add the SHA-1 to your Android app in Firebase Console

### Step 6: Initialize Firebase in Your App

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundo Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}
```

## 📝 Usage Examples

### Register with Email/Password

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundo_flutter/features/auth/presentation/controllers/auth_controller.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier)
                  .registerWithEmailAndPassword(
                    email: 'user@example.com',
                    password: 'password123',
                    displayName: 'John Doe',
                  );
            },
            child: const Text('Register'),
          ),

          // Handle auth state
          authState.when(
            initial: () => const SizedBox(),
            loading: () => const CircularProgressIndicator(),
            authenticated: (user) => Text('Welcome ${user.displayName}!'),
            unauthenticated: () => const Text('Please sign in'),
            error: (message) => Text('Error: $message'),
          ),
        ],
      ),
    );
  }
}
```

### Sign In with Email/Password

```dart
await ref.read(authControllerProvider.notifier)
    .signInWithEmailAndPassword(
      email: 'user@example.com',
      password: 'password123',
    );
```

### Sign In with Google

```dart
await ref.read(authControllerProvider.notifier).signInWithGoogle();
```

### Sign Out

```dart
await ref.read(authControllerProvider.notifier).signOut();
```

### Check Authentication Status

```dart
final isAuthenticated = ref.watch(isAuthenticatedProvider);

if (isAuthenticated) {
  // Show home screen
} else {
  // Show login screen
}
```

### Listen to Current User

```dart
final userAsync = ref.watch(currentUserProvider);

userAsync.when(
  data: (user) {
    if (user != null) {
      return Text('Logged in as ${user.email}');
    } else {
      return const Text('Not logged in');
    }
  },
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

## 🔒 Error Handling

The `AuthRepository` handles common Firebase errors:

- ✅ **weak-password**: Password is too weak
- ✅ **email-already-in-use**: Email is already registered
- ✅ **invalid-email**: Invalid email format
- ✅ **user-not-found**: No user with this email
- ✅ **wrong-password**: Incorrect password
- ✅ **invalid-credential**: Invalid credentials
- ✅ **too-many-requests**: Too many failed attempts
- ✅ **network-request-failed**: Network connection issue

## 🎯 Providers Available

### `authControllerProvider`

Main controller for authentication actions (login, register, logout)

### `currentUserProvider`

Stream provider that emits the current user or null

### `isAuthenticatedProvider`

Boolean provider indicating if user is authenticated

### `authRepositoryProvider`

Repository instance for direct Firebase auth operations

## 🚀 Next Steps

1. Configure Firebase for Android/iOS (see steps above)
2. Create login and register UI screens
3. Implement navigation based on auth state
4. Add form validation
5. Test authentication flow

## 📱 Testing

Before testing on device:

1. Ensure Firebase is properly configured
2. Add SHA-1 fingerprint for Android
3. Configure OAuth consent screen for Google Sign-In
4. Test on physical device (Google Sign-In may not work on emulator)

## 🔗 Resources

- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
