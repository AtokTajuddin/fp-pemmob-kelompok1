// Deprecated mock repository
// Mock implementation removed. Use `AuthRepository` (Firebase) instead.

@Deprecated('Mock auth removed — use AuthRepository with FirebaseAuth')
void _mockAuthRepoDeprecated() {
  throw UnsupportedError(
    'Mock auth repository removed. Use real AuthRepository.',
  );
}
