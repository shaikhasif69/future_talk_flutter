import 'package:flutter/material.dart';

/// Placeholder Onboarding Screen
/// This will be fully implemented later with interactive slides
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories,
              size: 80,
              color: Color(0xFF87A96B), // Sage Green
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to Future Talk',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A), // Soft Charcoal
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Onboarding slides coming soon...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B6B6B), // Soft Charcoal Light
              ),
            ),
          ],
        ),
      ),
    );
  }
}