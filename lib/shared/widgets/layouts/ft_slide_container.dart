import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';

/// Reusable slide container widget
/// Used for onboarding slides and similar content presentations
class FTSlideContainer extends StatelessWidget {
  const FTSlideContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    this.gradient = AppColors.primaryGradient,
    this.iconSize = 56.0,
    this.containerSize = 120.0,
    this.animationController,
    this.padding,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Gradient gradient;
  final double iconSize;
  final double containerSize;
  final AnimationController? animationController;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container with gradient
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 16.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: AppColors.pearlWhite,
            ),
          )
          .animate()
          .scale(
            duration: AppDurations.slow,
            curve: Curves.elasticOut,
          )
          .shimmer(
            duration: Duration(milliseconds: 1500),
            color: AppColors.pearlWhite.withOpacity( 0.3),
          ),
          
          const SizedBox(height: AppDimensions.spacingXXXL),
          
          // Subtitle
          Text(
            subtitle,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.sageGreen,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          )
          .animate()
          .fadeIn(
            duration: AppDurations.medium,
            delay: Duration(milliseconds: 200),
          )
          .slideY(
            begin: 0.3,
            end: 0.0,
            duration: AppDurations.medium,
            delay: Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Title
          Text(
            title,
            style: AppTextStyles.displayMedium,
            textAlign: TextAlign.center,
          )
          .animate()
          .fadeIn(
            duration: AppDurations.medium,
            delay: Duration(milliseconds: 400),
          )
          .slideY(
            begin: 0.3,
            end: 0.0,
            duration: AppDurations.medium,
            delay: Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
          ),
          
          const SizedBox(height: AppDimensions.spacingXL),
          
          // Description
          Text(
            description,
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.6,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          )
          .animate()
          .fadeIn(
            duration: AppDurations.medium,
            delay: Duration(milliseconds: 600),
          )
          .slideY(
            begin: 0.3,
            end: 0.0,
            duration: AppDurations.medium,
            delay: Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          ),
        ],
      ),
    );
  }
}