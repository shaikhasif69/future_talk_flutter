import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../models/social_battery_status.dart';

/// Social battery indicator with pulsing animation
/// Shows a friend's current energy level for introvert-friendly communication
class SocialBatteryIndicator extends StatelessWidget {
  const SocialBatteryIndicator({
    super.key,
    required this.status,
    this.size = 16.0,
    this.showPulse = true,
    this.borderWidth = 2.0,
    this.borderColor = AppColors.pearlWhite,
  });

  final SocialBatteryStatus status;
  final double size;
  final bool showPulse;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: status.color,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: status.color.withValues(alpha: 0.3),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
    ).animate(
      onPlay: (controller) => showPulse ? controller.repeat() : null,
    ).custom(
      duration: AppDurations.pulse,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        if (!showPulse) return child!;
        
        final pulseScale = 1.0 + (0.15 * (1.0 - (value - 0.5).abs() * 2));
        final pulseOpacity = 0.7 + (0.3 * (1.0 - (value - 0.5).abs() * 2));
        
        return Transform.scale(
          scale: pulseScale,
          child: Opacity(
            opacity: pulseOpacity,
            child: child,
          ),
        );
      },
    );
  }
}

/// Social battery indicator with tooltip showing status details
class SocialBatteryIndicatorWithTooltip extends StatelessWidget {
  const SocialBatteryIndicatorWithTooltip({
    super.key,
    required this.status,
    this.size = 16.0,
    this.showPulse = true,
    this.borderWidth = 2.0,
    this.borderColor = AppColors.pearlWhite,
  });

  final SocialBatteryStatus status;
  final double size;
  final bool showPulse;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _buildTooltipMessage(),
      decoration: BoxDecoration(
        color: AppColors.softCharcoal.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      textStyle: const TextStyle(
        color: AppColors.pearlWhite,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      margin: const EdgeInsets.all(AppDimensions.spacingS),
      child: SocialBatteryIndicator(
        status: status,
        size: size,
        showPulse: showPulse,
        borderWidth: borderWidth,
        borderColor: borderColor,
      ),
    );
  }

  String _buildTooltipMessage() {
    final sb = StringBuffer();
    sb.write('${status.emoji} ${status.displayName}');
    
    if (status.message != null && status.message!.isNotEmpty) {
      sb.write('\n${status.message}');
    } else {
      sb.write('\n${status.description}');
    }
    
    if (status.hoursSinceUpdate > 0) {
      sb.write('\nUpdated ${status.hoursSinceUpdate}h ago');
    } else {
      sb.write('\nJust updated');
    }
    
    return sb.toString();
  }
}

/// Large social battery status card for detailed view
class SocialBatteryStatusCard extends StatelessWidget {
  const SocialBatteryStatusCard({
    super.key,
    required this.status,
    required this.userName,
    this.onTap,
  });

  final SocialBatteryStatus status;
  final String userName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          color: status.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: status.color.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SocialBatteryIndicator(
                  status: status,
                  size: 24.0,
                  showPulse: true,
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$userName is ${status.displayName.toLowerCase()}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.softCharcoal,
                        ),
                      ),
                      Text(
                        status.defaultMessage,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: AppColors.softCharcoalLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status.hoursSinceUpdate > 0) ...[
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'Updated ${status.hoursSinceUpdate}h ago',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: AppColors.softCharcoalLight,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Social battery selector for user to set their own status
class SocialBatterySelector extends StatelessWidget {
  const SocialBatterySelector({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  final SocialBatteryStatus? currentStatus;
  final Function(SocialBatteryLevel) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling today?',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: AppColors.softCharcoal,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ...SocialBatteryLevel.values.map((level) {
          final isSelected = currentStatus?.level == level;
          final dummyStatus = SocialBatteryStatus(
            level: level,
            lastUpdated: DateTime.now(),
          );
          
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: GestureDetector(
              onTap: () => onStatusChanged(level),
              child: AnimatedContainer(
                duration: AppDurations.mediumFast,
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? dummyStatus.color.withValues(alpha: 0.1)
                      : AppColors.pearlWhite,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(
                    color: isSelected 
                        ? dummyStatus.color
                        : AppColors.whisperGray,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    SocialBatteryIndicator(
                      status: dummyStatus,
                      size: 20.0,
                      showPulse: isSelected,
                    ),
                    const SizedBox(width: AppDimensions.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${dummyStatus.emoji} ${dummyStatus.displayName}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: isSelected 
                                  ? dummyStatus.color
                                  : AppColors.softCharcoal,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingXS),
                          Text(
                            dummyStatus.description,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: AppColors.softCharcoalLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: AppDimensions.spacingM),
                      Icon(
                        Icons.check_circle,
                        color: dummyStatus.color,
                        size: 24.0,
                      ),
                    ],
                  ],
                ),
              ),
            ).animate().slideX(
              begin: 0.1,
              duration: AppDurations.medium,
              delay: Duration(milliseconds: 100 * level.index),
              curve: Curves.easeOutCubic,
            ).fadeIn(
              duration: AppDurations.medium,
              delay: Duration(milliseconds: 100 * level.index),
            ),
          );
        }).toList(),
      ],
    );
  }
}

/// Compact social battery indicator for navigation bars or small spaces
class CompactSocialBatteryIndicator extends StatelessWidget {
  const CompactSocialBatteryIndicator({
    super.key,
    required this.status,
    this.size = 12.0,
  });

  final SocialBatteryStatus status;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: status.color,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.pearlWhite,
          width: 1.0,
        ),
      ),
    ).animate()
        .scale(
          duration: AppDurations.pulse,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.1, 1.1),
          duration: AppDurations.pulse,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.1, 1.1),
          end: const Offset(1.0, 1.0),
          duration: AppDurations.pulse,
          curve: Curves.easeInOut,
        );
  }
}