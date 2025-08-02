import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// Custom status bar widget matching the HTML design exactly
/// Shows time, social battery status, and phone battery with premium styling
class StatusBarWidget extends StatelessWidget {
  /// Current time to display (default: "9:41" matching HTML)
  final String time;
  
  /// Social battery status color
  final SocialBatteryStatus batteryStatus;
  
  /// Phone battery percentage
  final int batteryPercentage;

  const StatusBarWidget({
    super.key,
    this.time = '9:41',
    this.batteryStatus = SocialBatteryStatus.green,
    this.batteryPercentage = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.warmCream, AppColors.pearlWhite],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Time display
              Text(
                time,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.softCharcoal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              // Status indicators
              Row(
                children: [
                  // Social battery status
                  _buildSocialBatteryStatus(),
                  
                  const SizedBox(width: AppDimensions.spacingS),
                  
                  // Phone battery
                  _buildPhoneBatteryStatus(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBatteryStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: batteryStatus.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: batteryStatus.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          
          const SizedBox(width: 4),
          
          Text(
            batteryStatus.displayName,
            style: AppTextStyles.labelSmall.copyWith(
              color: batteryStatus.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneBatteryStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$batteryPercentage% ',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.sageGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const Text(
          '🔋',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

/// Social battery status enum with visual properties
enum SocialBatteryStatus {
  green,
  yellow,
  red,
}

/// Extension for social battery status properties
extension SocialBatteryStatusExtension on SocialBatteryStatus {
  /// Display name for the status
  String get displayName {
    switch (this) {
      case SocialBatteryStatus.green:
        return 'Green';
      case SocialBatteryStatus.yellow:
        return 'Yellow';
      case SocialBatteryStatus.red:
        return 'Red';
    }
  }
  
  /// Background color for the status badge
  Color get backgroundColor {
    switch (this) {
      case SocialBatteryStatus.green:
        return AppColors.sageGreenWithOpacity(0.1);
      case SocialBatteryStatus.yellow:
        return AppColors.warmPeachLight;
      case SocialBatteryStatus.red:
        return AppColors.dustyRoseLight;
    }
  }
  
  /// Text color for the status badge
  Color get textColor {
    switch (this) {
      case SocialBatteryStatus.green:
        return AppColors.sageGreen;
      case SocialBatteryStatus.yellow:
        return AppColors.warmPeach;
      case SocialBatteryStatus.red:
        return AppColors.dustyRose;
    }
  }
  
  /// Dot color for the status indicator
  Color get dotColor {
    switch (this) {
      case SocialBatteryStatus.green:
        return const Color(0xFF4CAF50);
      case SocialBatteryStatus.yellow:
        return AppColors.warmPeach;
      case SocialBatteryStatus.red:
        return AppColors.dustyRose;
    }
  }
}