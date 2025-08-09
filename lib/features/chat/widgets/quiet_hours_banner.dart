import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_text_styles.dart';

/// Gentle quiet hours banner for introvert-friendly notification awareness
/// Features soft styling and optional toggle interaction
class QuietHoursBanner extends StatelessWidget {
  const QuietHoursBanner({
    super.key,
    required this.isActive,
    this.onToggle,
    this.endTime,
    this.showToggle = true,
  });

  final bool isActive;
  final VoidCallback? onToggle;
  final String? endTime;
  final bool showToggle;

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.spacingS,
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.dustyRose.withValues(alpha:  0.1),
            AppColors.lavenderMist.withValues(alpha:  0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.dustyRose.withValues(alpha:  0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Moon icon with gentle glow
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: AppColors.dustyRose.withValues(alpha:  0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.nightlight_round,
              size: 18.0,
              color: AppColors.dustyRose,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: const Duration(seconds: 2),
                color: AppColors.pearlWhite.withValues(alpha:  0.3),
              ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Quiet Hours Active',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.dustyRose,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (endTime != null) ...[
                      const SizedBox(width: AppDimensions.spacingS),
                      Text(
                        'until $endTime',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.softCharcoalLight,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2.0),
                Text(
                  'Gentle notifications only - messages will arrive softly',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
              ],
            ),
          ),
          
          // Toggle button (optional)
          if (showToggle && onToggle != null) ...[
            const SizedBox(width: AppDimensions.spacingM),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingS,
                  ),
                  child: Text(
                    'Disable',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.dustyRose,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(
      begin: -0.5,
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
    );
  }
}

/// Compact quiet hours indicator for headers or navigation
class CompactQuietHoursIndicator extends StatelessWidget {
  const CompactQuietHoursIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.dustyRose.withValues(alpha:  0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: AppColors.dustyRose.withValues(alpha:  0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.nightlight_round,
            size: 12.0,
            color: AppColors.dustyRose.withValues(alpha:  0.8),
          ),
          const SizedBox(width: 4.0),
          Text(
            'Quiet',
            style: TextStyle(
              color: AppColors.dustyRose.withValues(alpha:  0.8),
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scaleXY(
      begin: 0.0,
      curve: Curves.easeOutBack,
      duration: AppDurations.fast,
    );
  }
}

/// Quiet hours toggle card for settings or preferences
class QuietHoursToggleCard extends StatefulWidget {
  const QuietHoursToggleCard({
    super.key,
    required this.isActive,
    required this.onToggle,
    this.startTime = '22:00',
    this.endTime = '09:00',
  });

  final bool isActive;
  final Function(bool) onToggle;
  final String startTime;
  final String endTime;

  @override
  State<QuietHoursToggleCard> createState() => _QuietHoursToggleCardState();
}

class _QuietHoursToggleCardState extends State<QuietHoursToggleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: widget.isActive 
            ? AppColors.dustyRose.withValues(alpha:  0.05)
            : AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: widget.isActive 
              ? AppColors.dustyRose.withValues(alpha:  0.2)
              : AppColors.whisperGray,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: widget.isActive 
                      ? AppColors.dustyRose.withValues(alpha:  0.2)
                      : AppColors.softCharcoalLight.withValues(alpha:  0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.nightlight_round,
                  color: widget.isActive 
                      ? AppColors.dustyRose 
                      : AppColors.softCharcoalLight,
                  size: 20.0,
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiet Hours',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.softCharcoal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Gentle notifications during sleep hours',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Toggle switch
              Switch.adaptive(
                value: widget.isActive,
                onChanged: widget.onToggle,
                activeColor: AppColors.dustyRose,
                inactiveThumbColor: AppColors.stoneGray,
                inactiveTrackColor: AppColors.whisperGray,
              ),
            ],
          ),
          
          if (widget.isActive) ...[
            const SizedBox(height: AppDimensions.spacingM),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.dustyRose.withValues(alpha:  0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16.0,
                    color: AppColors.dustyRose.withValues(alpha:  0.8),
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text(
                    'Active from ${widget.startTime} to ${widget.endTime}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.dustyRose.withValues(alpha:  0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(
              begin: -0.3,
              duration: AppDurations.medium,
              curve: Curves.easeOutCubic,
            ),
          ],
        ],
      ),
    );
  }
}