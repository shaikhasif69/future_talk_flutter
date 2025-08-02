// Additional constants for Connection Stones to maintain consistency
// This file bridges any naming gaps in the existing codebase

import '../../../core/constants/app_dimensions.dart';

class StoneConstants {
  StoneConstants._();

  // Padding aliases for consistency
  static const double paddingSmall = AppDimensions.spacingS; // 8px
  static const double paddingMedium = AppDimensions.spacingM; // 12px
  static const double paddingLarge = AppDimensions.spacingL; // 16px
  static const double paddingXLarge = AppDimensions.spacingXL; // 20px
  
  // Stone-specific dimensions
  static const double stoneCardWidth = 160.0;
  static const double stoneCardHeight = 200.0;
  static const double stoneVisualSize = 80.0;
  static const double quickStoneSize = 50.0;
  static const double largeStoneSize = 120.0;
  
  // Animation durations
  static const Duration breathingDuration = Duration(seconds: 4);
  static const Duration receivingDuration = Duration(seconds: 2);
  static const Duration sendingDuration = Duration(milliseconds: 1500);
  static const Duration touchFeedbackDuration = Duration(seconds: 3);
  
  // Touch detection
  static const Duration longPressDuration = Duration(milliseconds: 800);
  static const Duration doubleTapThreshold = Duration(milliseconds: 300);
  
  // Particle animation
  static const Duration particleAnimationDuration = Duration(seconds: 12);
  static const int defaultParticleCount = 8;
  static const double minParticleSize = 2.0;
  static const double maxParticleSize = 6.0;
}