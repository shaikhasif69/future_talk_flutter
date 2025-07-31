import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_text_styles.dart';

/// Reusable loading indicator widget
/// Provides consistent loading states across the app
class FTLoadingIndicator extends StatelessWidget {
  const FTLoadingIndicator({
    super.key,
    this.text,
    this.showText = true,
    this.progress,  // For determinate progress
    this.width = 200.0,
    this.height,
    this.gradient,
    this.backgroundColor,
  });

  final String? text;
  final bool showText;
  final double? progress; // 0.0 to 1.0 for determinate progress
  final double width;
  final double? height;
  final Gradient? gradient;
  final Color? backgroundColor;

  double get _height => height ?? AppDimensions.progressBarHeight;
  Gradient get _gradient => gradient ?? AppColors.loadingGradient;
  Color get _backgroundColor => backgroundColor ?? AppColors.whisperGray;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showText && text != null) ...[
          Text(
            text!,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.sageGreen,
              fontWeight: FontWeight.w500,
            ),
          )
          .animate()
          .fadeIn(
            duration: AppDurations.medium,
          )
          .slideY(
            begin: 0.2,
            end: 0.0,
            duration: AppDurations.medium,
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
        ],
        
        // Progress bar
        Container(
          width: width,
          height: _height,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(AppDimensions.progressBarRadius),
          ),
          child: progress != null 
              ? _buildDeterminateProgress()
              : _buildIndeterminateProgress(),
        )
        .animate()
        .fadeIn(
          duration: AppDurations.medium,
          delay: showText && text != null 
              ? Duration(milliseconds: 200) 
              : Duration.zero,
        )
        .slideY(
          begin: 0.2,
          end: 0.0,
          duration: AppDurations.medium,
          delay: showText && text != null 
              ? Duration(milliseconds: 200) 
              : Duration.zero,
        ),
      ],
    );
  }

  Widget _buildDeterminateProgress() {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: progress,
      child: Container(
        decoration: BoxDecoration(
          gradient: _gradient,
          borderRadius: BorderRadius.circular(AppDimensions.progressBarRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.sageGreen.withValues(alpha: 0.4),
              blurRadius: 4.0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndeterminateProgress() {
    return Container(
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.circular(AppDimensions.progressBarRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreen.withValues(alpha: 0.4),
            blurRadius: 4.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(
      duration: Duration(milliseconds: 1500),
      color: AppColors.pearlWhite.withValues(alpha: 0.3),
    );
  }
}