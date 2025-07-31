import 'package:flutter/material.dart';

/// Placeholder Sign In Screen
/// This will be fully implemented later with authentication flow
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login,
              size: 80,
              color: Color(0xFF87A96B), // Sage Green
            ),
            SizedBox(height: 24),
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A), // Soft Charcoal
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Sign in form coming soon...',
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