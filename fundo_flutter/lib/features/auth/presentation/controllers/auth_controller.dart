import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_state.dart';
import '../../domain/app_user.dart';
import '../../domain/auth_failure.dart';

// Auth state notifier provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(authRepository);
  },
);

// Current user provider
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.appUserChanges;
});

// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AuthState.initial()) {
    _authRepository.currentAppUser.then((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });

    _authRepository.appUserChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  /// Register with email and password
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.error('Registration failed');
      }
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Registration failed. Please try again.');
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.error('Sign in failed');
      }
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Sign in failed. Please try again.');
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.signInWithGoogle();

      if (user != null) {
        // Don't manually set authenticated state - let the auth stream handle it
        // state = AuthState.authenticated(user);
        // The authStateChanges listener will update the state automatically
      } else {
        // User canceled the sign-in
        state = const AuthState.unauthenticated();
      }
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Google sign in failed. Please try again.');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await _authRepository.signOut();
      state = const AuthState.unauthenticated();
    } on AuthFailure catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Sign out failed. Please try again.');
    }
  }

  /// Reset error state
  void resetError() {
    final isError = state.maybeWhen(error: (_) => true, orElse: () => false);
    if (isError) {
      state = const AuthState.unauthenticated();
    }
  }
}
