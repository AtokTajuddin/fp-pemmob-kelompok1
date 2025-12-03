// ignore_for_file: unused_element

// Deprecated mock auth controller
// This file is intentionally disabled. The app should use the real
// `AuthController` in `auth_controller.dart` which relies on
// `AuthRepository` (Firebase). If you see imports to this file,
// update them to use the real implementations.

@Deprecated('Mock auth removed — use AuthController with AuthRepository')
void _mockAuthDeprecated() {
  throw UnsupportedError('Mock auth is removed. Use real Firebase auth.');
}
