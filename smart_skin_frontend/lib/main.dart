import 'package:flutter/material.dart';

import 'features/onboarding/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlowSense',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF8BBD0)),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}


