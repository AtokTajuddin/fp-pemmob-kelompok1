import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Provides [FirebaseOptions] for each supported platform.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static FirebaseOptions get web {
    _FirebaseEnv.ensureWeb();
    return FirebaseOptions(
      apiKey: _FirebaseEnv.webApiKey,
      appId: _FirebaseEnv.webAppId,
      messagingSenderId: _FirebaseEnv.messagingSenderId,
      projectId: _FirebaseEnv.projectId,
      authDomain: _FirebaseEnv.authDomain,
      storageBucket: _FirebaseEnv.storageBucket,
    );
  }

  static FirebaseOptions get android {
    _FirebaseEnv.ensureAndroid();
    return FirebaseOptions(
      apiKey: _FirebaseEnv.androidApiKey,
      appId: _FirebaseEnv.androidAppId,
      messagingSenderId: _FirebaseEnv.messagingSenderId,
      projectId: _FirebaseEnv.projectId,
      authDomain: _FirebaseEnv.authDomain,
      storageBucket: _FirebaseEnv.storageBucket,
    );
  }

  static FirebaseOptions get ios {
    _FirebaseEnv.ensureIOS();
    return FirebaseOptions(
      apiKey: _FirebaseEnv.iosApiKey,
      appId: _FirebaseEnv.iosAppId,
      messagingSenderId: _FirebaseEnv.messagingSenderId,
      projectId: _FirebaseEnv.projectId,
      authDomain: _FirebaseEnv.authDomain,
      storageBucket: _FirebaseEnv.storageBucket,
      iosClientId: _FirebaseEnv.iosClientId,
      iosBundleId: _FirebaseEnv.iosBundleId,
    );
  }
}

/// Resolves compile-time environment variables supplied via --dart-define.
class _FirebaseEnv {
  static const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );

  static const webApiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
  static const webAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');

  static const androidApiKey = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
  );
  static const androidAppId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');

  static const iosApiKey = String.fromEnvironment('FIREBASE_IOS_API_KEY');
  static const iosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const iosClientId = String.fromEnvironment('FIREBASE_IOS_CLIENT_ID');
  static const iosBundleId = String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');

  static void ensureWeb() {
    _requireCommon();
    _require(webApiKey, 'FIREBASE_WEB_API_KEY');
    _require(webAppId, 'FIREBASE_WEB_APP_ID');
  }

  static void ensureAndroid() {
    _requireCommon();
    _require(androidApiKey, 'FIREBASE_ANDROID_API_KEY');
    _require(androidAppId, 'FIREBASE_ANDROID_APP_ID');
  }

  static void ensureIOS() {
    _requireCommon();
    _require(iosApiKey, 'FIREBASE_IOS_API_KEY');
    _require(iosAppId, 'FIREBASE_IOS_APP_ID');
    _require(iosClientId, 'FIREBASE_IOS_CLIENT_ID');
    _require(iosBundleId, 'FIREBASE_IOS_BUNDLE_ID');
  }

  static void _requireCommon() {
    _require(projectId, 'FIREBASE_PROJECT_ID');
    _require(messagingSenderId, 'FIREBASE_MESSAGING_SENDER_ID');
    _require(authDomain, 'FIREBASE_AUTH_DOMAIN');
    _require(storageBucket, 'FIREBASE_STORAGE_BUCKET');
  }

  static void _require(String value, String key) {
    if (value.isEmpty) {
      throw StateError('Missing Firebase env var: $key');
    }
  }
}
