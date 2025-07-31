import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../animations/ft_stagger_animation.dart';

/// Reusable form header widget
/// Provides consistent header UI with logo, title, and description
class FTFormHeader extends StatelessWidget {
  const FTFormHeader({
    super.key,
    required this.title,
    required this.description,
    this.showLogo = true,
    this.logoSize = AppDimensions.logoMedium,
    this.logoIcon = Icons.message_rounded,
    this.logoGradient = AppColors.primaryGradient,
    this.animationDelay,
  });

  final String title;
  final String description;
  final bool showLogo;
  final double logoSize;
  final IconData logoIcon;
  final Gradient logoGradient;
  final Duration? animationDelay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showLogo) ...[
          // Logo
          Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              gradient: logoGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 12.0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              logoIcon,
              color: AppColors.pearlWhite,
              size: logoSize * 0.4, // 40% of logo size
            ),
          )
          .animate()
          .scale(
            duration: AppDurations.slow,
            curve: Curves.elasticOut,
            delay: animationDelay,
          )
          .shimmer(
            duration: Duration(milliseconds: 1500),
            color: AppColors.pearlWhite.withOpacity( 0.3),
            delay: animationDelay,
          ),
          
          const SizedBox(height: AppDimensions.spacingXL),
        ],
        
        // Title
        FTStaggerAnimation(
          delay: animationDelay != null 
              ? animationDelay! + const Duration(milliseconds: 200)
              : const Duration(milliseconds: 200),
          child: Text(
            title,
            style: AppTextStyles.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        // Description
        FTStaggerAnimation(
          delay: animationDelay != null 
              ? animationDelay! + const Duration(milliseconds: 400)
              : const Duration(milliseconds: 400),
          child: Text(
            description,
            style: AppTextStyles.bodyLarge.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}