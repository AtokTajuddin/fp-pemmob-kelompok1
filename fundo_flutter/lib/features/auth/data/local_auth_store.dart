import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/app_user.dart';
import '../domain/auth_failure.dart';

/// LocalAuthStore now uses Hive for a more durable, high-performance store.
class LocalAuthStore {
  static const usersBoxName = 'local_auth_users_box';
  static const sessionBoxName = 'local_auth_session_box';
  static const _currentUserKey = 'local_auth_current_user';

  static Future<void> ensureInitialized() async {
    if (!Hive.isBoxOpen(usersBoxName)) {
      await Hive.openBox<String>(usersBoxName);
    }
    if (!Hive.isBoxOpen(sessionBoxName)) {
      await Hive.openBox<String>(sessionBoxName);
    }
  }

  final StreamController<AppUser?> _authController =
      StreamController<AppUser?>.broadcast();

  LocalAuthStore() {
    // Emit the last persisted user once listeners attach.
    scheduleMicrotask(() async {
      _authController.add(await getCurrentUser());
    });
  }

  Stream<AppUser?> get authStateChanges => _authController.stream;

  Box<String> get _usersBox => Hive.box<String>(usersBoxName);
  Box<String> get _sessionBox => Hive.box<String>(sessionBoxName);

  Map<String, dynamic> _decode(String raw) =>
      jsonDecode(raw) as Map<String, dynamic>;
  String _encode(Map<String, dynamic> data) => jsonEncode(data);

  String _hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  bool _looksHashed(String value) =>
      RegExp(r'^[a-f0-9]{64}$', caseSensitive: false).hasMatch(value);

  AppUser _mapToUser(Map<String, dynamic> data) => AppUser(
    uid: data['uid'] as String,
    email: data['email'] as String,
    displayName: data['displayName'] as String?,
    photoUrl: data['photoUrl'] as String?,
  );

  Future<AppUser?> getCurrentUser() async {
    final raw = _sessionBox.get(_currentUserKey);
    if (raw == null) return null;
    return _mapToUser(_decode(raw));
  }

  Future<void> _setCurrentUser(AppUser? user) async {
    if (user == null) {
      await _sessionBox.delete(_currentUserKey);
      _authController.add(null);
      return;
    }
    await _sessionBox.put(
      _currentUserKey,
      _encode({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
      }),
    );
    _authController.add(user);
  }

  /// Register a user locally. Emails must be unique.
  Future<AppUser?> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    if (_usersBox.containsKey(email)) {
      throw const AuthFailure(
        'This account has already been created. Please sign up with another account.',
      );
    }
    final uid = DateTime.now().microsecondsSinceEpoch.toString();
    final hashedPassword = _hashPassword(password);
    final payload = {
      'uid': uid,
      'email': email,
      'password': hashedPassword,
      'displayName': displayName,
      'photoUrl': null,
    };
    await _usersBox.put(email, _encode(payload));
    final user = _mapToUser(payload);
    await _setCurrentUser(user);
    return user;
  }

  /// Sign in a stored user.
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    final raw = _usersBox.get(email);
    if (raw == null) {
      throw const AuthFailure('No user found with this email');
    }
    final record = _decode(raw);
    final incomingHash = _hashPassword(password);
    final storedPassword = record['password'] as String;
    final isHashed = _looksHashed(storedPassword);

    if (isHashed) {
      if (storedPassword != incomingHash) {
        throw const AuthFailure('Incorrect password');
      }
    } else {
      // Legacy plain text record: compare raw then upgrade to hashed for future logins.
      if (storedPassword != password) {
        throw const AuthFailure('Incorrect password');
      }
      record['password'] = incomingHash;
      await _usersBox.put(email, _encode(record));
    }
    final user = _mapToUser(record);
    await _setCurrentUser(user);
    return user;
  }

  /// Returns every registered user for administrative views.
  Future<List<AppUser>> listRegisteredUsers() async => _usersBox.values
      .map((raw) => _mapToUser(_decode(raw)))
      .toList(growable: false);

  /// Sign out current user.
  Future<void> signOut() async {
    await _setCurrentUser(null);
  }
}
