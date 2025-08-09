import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Splash screen logo component with breathing animation
class SplashLogo extends StatelessWidget {
  const SplashLogo({
    super.key,
    required this.logoScaleAnimation,
    required this.logoOpacityAnimation,
  });

  final Animation<double> logoScaleAnimation;
  final Animation<double> logoOpacityAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([logoScaleAnimation, logoOpacityAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: logoScaleAnimation.value,
          child: Opacity(
            opacity: logoOpacityAnimation.value,
            child: Container(
              width: AppDimensions.logoLarge,
              height: AppDimensions.logoLarge,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppDimensions.logoRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withValues(alpha:  0.3),
                    blurRadius: 24.0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.message_rounded,
                size: 64.0,
                color: AppColors.pearlWhite,
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              duration: Duration(milliseconds: 2000),
              color: AppColors.pearlWhite.withValues(alpha:  0.3),
            )
            .then()
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: Duration(milliseconds: 3000),
              curve: Curves.easeInOut,
            ),
          ),
        );
      },
    );
  }
}