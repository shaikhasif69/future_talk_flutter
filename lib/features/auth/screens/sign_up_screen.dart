import 'package:flutter/material.dart';

/// Placeholder Sign Up Screen
/// This will be fully implemented later with form validation
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              size: 80,
              color: Color(0xFF87A96B), // Sage Green
            ),
            SizedBox(height: 24),
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A), // Soft Charcoal
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Sign up form coming soon...',
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