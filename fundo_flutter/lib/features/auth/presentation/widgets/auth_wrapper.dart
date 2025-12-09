import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../screens/login_screen.dart';

/// Widget that wraps the app and handles authentication routing
/// Shows LoginScreen if not authenticated, otherwise shows home screen
class AuthWrapper extends ConsumerWidget {
  final Widget? homeScreen;

  const AuthWrapper({super.key, this.homeScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user != null) {
          // User is authenticated, show home screen
          return homeScreen ?? const AuthenticatedHomeScreen();
        } else {
          // User is not authenticated, show login screen
          return const LoginScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Retry by invalidating the provider
                  ref.invalidate(currentUserProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Default authenticated home screen
/// Replace this with your actual home screen widget
class AuthenticatedHomeScreen extends ConsumerWidget {
  const AuthenticatedHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: userAsync.when(
          data: (user) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'You are logged in!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (user != null) ...[
                Text(
                  'Welcome, ${user.displayName ?? user.email}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'UID: ${user.uid}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
