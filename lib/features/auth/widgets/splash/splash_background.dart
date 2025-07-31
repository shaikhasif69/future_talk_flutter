import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Splash screen background with gradient
class SplashBackground extends StatelessWidget {
  const SplashBackground({
    super.key,
    this.gradient = AppColors.backgroundGradient,
  });

  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
    );
  }
}