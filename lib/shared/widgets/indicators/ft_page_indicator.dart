import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_durations.dart';

/// Reusable page indicator widget
/// Used for showing current page in onboarding and other paginated views
class FTPageIndicator extends StatelessWidget {
  const FTPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor = AppColors.sageGreen,
    this.inactiveColor = AppColors.whisperGray,
    this.activeWidth = 24.0,
    this.inactiveWidth = 8.0,
    this.height = 8.0,
    this.spacing = 4.0,
    this.borderRadius = 4.0,
  });

  final int currentPage;
  final int totalPages;
  final Color activeColor;
  final Color inactiveColor;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final double spacing;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = currentPage == index;
        
        return AnimatedContainer(
          duration: AppDurations.medium,
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? activeWidth : inactiveWidth,
          height: height,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      }),
    );
  }
}