import 'package:flutter/material.dart';
import 'screens/onboarding_page.dart';

void main() {
  runApp(const FundoApp());
}

class FundoApp extends StatelessWidget {
  const FundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981), // Fundo Green
          primary: const Color(0xFF10B981),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Poppins', // If you added the font, otherwise default
      ),
      // Start flow: Onboarding -> Login -> Dashboard
      home: const OnboardingPage(),
    );
  }
}
