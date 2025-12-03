import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/app_user.dart';
import '../domain/auth_failure.dart';
// Firebase imports are kept but guarded to avoid runtime usage when local mode is enabled
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'local_auth_store.dart';

/// Toggle to use local auth while Firebase is not yet configured.
/// Set to `true` to enable local register/login with SharedPreferences.
const bool kUseLocalAuth = false;

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localStore = LocalAuthStore();
  final repository = kUseLocalAuth
      ? AuthRepository.local(localStore)
      : AuthRepository.remote(
          FirebaseAuth.instance,
          GoogleSignIn(scopes: ['email', 'profile']),
          localStore,
        );
  ref.onDispose(repository.dispose);
  return repository;
});

class AuthRepository {
  // Remote (Firebase) fields
  final FirebaseAuth? _firebaseAuth;
  final GoogleSignIn? _googleSignIn;
  final LocalAuthStore _localStore;
  final bool _localOnly;
  final StreamController<AppUser?> _manualAuthEvents =
      StreamController<AppUser?>.broadcast();
  bool _localSessionActive = false;
  late final Stream<AppUser?> _authChanges;

  AuthRepository.remote(
    this._firebaseAuth,
    this._googleSignIn,
    this._localStore,
  ) : _localOnly = false {
    _authChanges = Stream.multi((controller) async {
      final firebaseAuth = _firebaseAuth;
      if (firebaseAuth == null) {
        controller.add(null);
        return;
      }
      controller.add(_userFromFirebase(firebaseAuth.currentUser));
      final firebaseSub = firebaseAuth.authStateChanges().listen(
        (user) => controller.add(_userFromFirebase(user)),
        onError: controller.addError,
      );
      final manualSub = _manualAuthEvents.stream.listen(controller.add);
      controller.onCancel = () async {
        await firebaseSub.cancel();
        await manualSub.cancel();
      };
    }, isBroadcast: true);
  }
  AuthRepository.local(this._localStore)
    : _firebaseAuth = null,
      _googleSignIn = null,
      _localOnly = true {
    _authChanges = Stream.multi((controller) async {
      controller.add(await _localStore.getCurrentUser());
      final sub = _localStore.authStateChanges.listen(
        controller.add,
        onError: controller.addError,
      );
      controller.onCancel = () => sub.cancel();
    }, isBroadcast: true);
  }

  /// Stream of auth changes represented as AppUser objects.
  Stream<AppUser?> get appUserChanges => _authChanges;

  /// Get current user synchronously/asynchronously based on mode.
  Future<AppUser?> get currentAppUser async {
    if (_localOnly || _localSessionActive) {
      final localUser = await _localStore.getCurrentUser();
      if (localUser != null || _localOnly) {
        return localUser;
      }
    }
    return _userFromFirebase(_firebaseAuth?.currentUser);
  }

  /// Convert Firebase User to AppUser
  AppUser? _userFromFirebase(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  /// Register with email and password
  Future<AppUser?> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    if (_localOnly) {
      return _registerLocally(
        email: email,
        password: password,
        displayName: displayName,
      );
    }
    try {
      final userCredential = await _firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);
      if (displayName != null && userCredential.user != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload();
      }
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (_shouldFallbackToLocal(e.code)) {
        return _registerLocally(
          email: email,
          password: password,
          displayName: displayName,
        );
      }
      throw AuthFailure(_handleAuthException(e));
    } catch (e) {
      throw const AuthFailure(
        'An unexpected error occurred during registration',
      );
    }
  }

  /// Sign in with email and password
  Future<AppUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (_localOnly) {
      return _signInLocally(email: email, password: password);
    }
    try {
      final userCredential = await _firebaseAuth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (_shouldFallbackToLocal(e.code)) {
        return _signInLocally(email: email, password: password);
      }
      throw AuthFailure(_handleAuthException(e));
    } catch (e) {
      throw const AuthFailure('An unexpected error occurred during sign in');
    }
  }

  /// Sign in with Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      if (_localOnly) {
        throw const AuthFailure('Google sign in is unavailable in local mode');
      }

      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..setCustomParameters({'prompt': 'select_account'});

        try {
          final userCredential = await _firebaseAuth!.signInWithPopup(provider);
          return _userFromFirebase(userCredential.user);
        } on FirebaseAuthException catch (e) {
          if (_isPopupCancelled(e)) {
            return null;
          }
          rethrow;
        }
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth!.signInWithCredential(
        credential,
      );
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (_isPopupCancelled(e)) {
        return null;
      }
      throw AuthFailure(_handleAuthException(e));
    } catch (e) {
      throw const AuthFailure(
        'An unexpected error occurred during Google sign in',
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (_localOnly) {
        await _localStore.signOut();
        _localSessionActive = false;
        _manualAuthEvents.add(null);
        return;
      }

      final firebaseAuth = _firebaseAuth;
      final googleSignIn = _googleSignIn;

      if (firebaseAuth == null) {
        throw const AuthFailure('FirebaseAuth is not available.');
      }

      if (kIsWeb) {
        await firebaseAuth.signOut();
      } else {
        await Future.wait([
          firebaseAuth.signOut(),
          if (googleSignIn != null) googleSignIn.signOut(),
        ]);
      }

      await _localStore.signOut();
      if (_localSessionActive) {
        _localSessionActive = false;
        _manualAuthEvents.add(null);
      }
    } catch (e) {
      throw const AuthFailure('Failed to sign out. Please try again.');
    }
  }

  /// Expose locally stored users so the app can show an account roster when offline.
  Future<List<AppUser>> getRegisteredUsers() async {
    if (_localOnly) {
      return _localStore.listRegisteredUsers();
    }
    throw Exception('User listing is unavailable in remote auth mode');
  }

  void dispose() {
    _manualAuthEvents.close();
  }

  /// Handle Firebase Auth exceptions
  bool _isPopupCancelled(FirebaseAuthException e) {
    return e.code == 'popup-closed-by-user' ||
        e.code == 'cancelled-popup-request' ||
        e.code == 'popup-blocked';
  }

  Future<AppUser?> _registerLocally({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final user = await _localStore.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      if (!_localOnly) {
        _localSessionActive = true;
        _manualAuthEvents.add(user);
      }
      return user;
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure('Registration failed. Please try again.');
    }
  }

  Future<AppUser?> _signInLocally({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _localStore.signIn(email: email, password: password);
      if (!_localOnly) {
        _localSessionActive = true;
        _manualAuthEvents.add(user);
      }
      return user;
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure('Sign in failed. Please try again.');
    }
  }

  bool _shouldFallbackToLocal(String code) {
    return code == 'operation-not-allowed' ||
        code == 'app-not-authorized' ||
        code == 'network-request-failed';
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak';
      case 'email-already-in-use':
        return 'This account has already been created. Please sign up with another account.';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'An authentication error occurred. Please try again later';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'invalid-credential':
        return 'Invalid credentials provided';
      case 'account-exists-with-different-credential':
        return 'This account has already been created. Please sign up with another account.';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Google sign in was cancelled';
      case 'popup-blocked':
        return 'Your browser blocked the Google sign-in popup. Allow popups and try again';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }
}
