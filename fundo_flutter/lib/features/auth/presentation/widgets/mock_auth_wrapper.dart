// Deprecated mock wrapper
// Use `AuthWrapper` which listens to the real auth state.

@Deprecated('Mock wrapper removed — use AuthWrapper with real auth state')
void mockAuthWrapperDeprecated() {
  throw UnsupportedError('Mock auth wrapper removed. Use AuthWrapper.');
}
