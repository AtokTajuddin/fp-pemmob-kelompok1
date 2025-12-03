import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../transactions/presentation/screens/transaction_history_screen.dart';
import '../../../transactions/presentation/widgets/add_transaction_sheet.dart';
import '../../../support_chat/presentation/support_chat_screen.dart';
import '../../domain/app_user.dart';
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
class AuthenticatedHomeScreen extends ConsumerStatefulWidget {
  const AuthenticatedHomeScreen({super.key});

  @override
  ConsumerState<AuthenticatedHomeScreen> createState() =>
      _AuthenticatedHomeScreenState();
}

class _AuthenticatedHomeScreenState
    extends ConsumerState<AuthenticatedHomeScreen> {
  int _selectedIndex = 0;

  void _onNavSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onAddTransactionPressed() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: AddTransactionSheet(),
      ),
    ).then((saved) {
      if (!mounted || saved != true) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transaction saved.')));
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final tabs = <Widget>[
      _HomeOverview(userAsync: userAsync),
      const TransactionHistoryScreen(),
      const SupportChatScreen(),
      _ProfileTab(userAsync: userAsync),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: tabs[_selectedIndex],
      ),
      floatingActionButton: _DiamondFab(onPressed: _onAddTransactionPressed),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _selectedIndex,
        onSelected: _onNavSelected,
      ),
    );
  }
}

class _HomeOverview extends StatelessWidget {
  const _HomeOverview({required this.userAsync});

  final AsyncValue<AppUser?> userAsync;

  @override
  Widget build(BuildContext context) {
    return userAsync.when(
      data: (user) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user != null)
                Text(
                  user.displayName ?? user.email,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 80,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This is your dashboard.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Use the bottom bar to open history, chat, or profile.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({required this.userAsync});

  final AsyncValue<AppUser?> userAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: userAsync.when(
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (user != null) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: Text(user.email.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(user.displayName ?? 'Anonymous'),
                  subtitle: Text(user.email),
                ),
                const SizedBox(height: 24),
              ],
              ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onSelected});

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = [
      (Icons.home_outlined, 'Home'),
      (Icons.receipt_long_outlined, 'History'),
      (Icons.chat_bubble_outline, 'Chat'),
      (Icons.person_outline, 'Profile'),
    ];

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i == 2) const SizedBox(width: 48),
              _NavItem(
                icon: items[i].$1,
                label: items[i].$2,
                isActive: currentIndex == i,
                activeColor: colorScheme.primary,
                onTap: () => onSelected(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : Colors.grey;
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _DiamondFab extends StatelessWidget {
  const _DiamondFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Transform.rotate(
      angle: math.pi / 4,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: color,
        onPressed: onPressed,
        child: Transform.rotate(
          angle: -math.pi / 4,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
