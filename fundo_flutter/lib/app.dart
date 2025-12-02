import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

class FundoApp extends ConsumerWidget {
  const FundoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🚧 TODO: Switch to MaterialApp.router when we setup GoRouter
    return MaterialApp(
      title: 'Fundo',
      debugShowCheckedModeBanner: false,

      // 👇 THEME SETUP (Connecting what we just built)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Respects phone's Dark Mode setting
      // 🧪 TEST SCREEN: Just to check if our Colors work!
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Fundo Design Test"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Balance",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "Rp 1.500.000",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Test the Button Theme
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text("Add Transaction"),
              ),
              const SizedBox(height: 16),
              // Test the Card Theme
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Recent Transaction: Starbucks - Rp 50.000"),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.chat),
        ),
      ),
    );
  }
}
