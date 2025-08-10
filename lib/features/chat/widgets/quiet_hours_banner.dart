import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_text_styles.dart';

/// Quiet hours banner matching HTML reference design exactly
/// Shows during quiet hours to indicate gentle notification mode
class QuietHoursBanner extends StatefulWidget {
  const QuietHoursBanner({
    super.key,
    this.isVisible = true,
    this.endTime,
    this.onDismiss,
  });

  final bool isVisible;
  final DateTime? endTime;
  final VoidCallback? onDismiss;

  @override
  State<QuietHoursBanner> createState() => _QuietHoursBannerState();
}

class _QuietHoursBannerState extends State<QuietHoursBanner> {
  bool _isDismissed = false;

  /// Format end time (e.g., "9 AM")
  String _formatEndTime(DateTime? endTime) {
    if (endTime == null) return '9 AM';
    
    final hour = endTime.hour == 0 
        ? 12 
        : (endTime.hour > 12 ? endTime.hour - 12 : endTime.hour);
    final amPm = endTime.hour < 12 ? 'AM' : 'PM';
    
    return '$hour $amPm';
  }

  void _handleDismiss() {
    setState(() => _isDismissed = true);
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || _isDismissed) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.spacingS,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        // Matching HTML: rgba(212, 165, 165, 0.1)
        color: AppColors.dustyRose.withValues(alpha: 0.1),
        // Matching HTML: 1px solid rgba(212, 165, 165, 0.2)
        border: Border.all(
          color: AppColors.dustyRose.withValues(alpha: 0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        children: [
          // Moon icon (matching HTML 🌙)
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: AppColors.dustyRose.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.nights_stay,
              size: 14.0,
              color: AppColors.dustyRose,
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacingS),
          
          // Text content (matching HTML exactly)
          Expanded(
            child: Text(
              'Quiet hours active until ${_formatEndTime(widget.endTime)} - Gentle notifications only',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.softCharcoalLight,
                fontSize: 12.0, // Match HTML font-size
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          
          // Dismiss button
          if (widget.onDismiss != null)
            GestureDetector(
              onTap: _handleDismiss,
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: AppColors.dustyRose.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 12.0,
                  color: AppColors.dustyRose.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(
      duration: AppDurations.medium,
      curve: Curves.easeOut,
    ).slideY(
      begin: -0.2,
      duration: AppDurations.medium,
      curve: Curves.easeOut,
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

/// Service for managing quiet hours state
class QuietHoursService {
  static DateTime? _quietHoursEndTime;
  static bool _isQuietHours = false;
  
  /// Check if currently in quiet hours
  static bool get isQuietHours => _isQuietHours;
  
  /// Get quiet hours end time
  static DateTime? get endTime => _quietHoursEndTime;
  
  /// Set quiet hours (typically called at night)
  static void enableQuietHours({DateTime? endTime}) {
    _isQuietHours = true;
    _quietHoursEndTime = endTime ?? _getDefaultMorningTime();
    debugPrint('🌙 [QuietHoursService] Enabled quiet hours until $_quietHoursEndTime');
  }
  
  /// Disable quiet hours (typically called in the morning)
  static void disableQuietHours() {
    _isQuietHours = false;
    _quietHoursEndTime = null;
    debugPrint('☀️ [QuietHoursService] Disabled quiet hours');
  }
  
  /// Auto-check and update quiet hours based on current time
  static void updateQuietHoursStatus() {
    final now = DateTime.now();
    final hour = now.hour;
    
    // Quiet hours: 10 PM to 9 AM (22:00 to 09:00)
    if (hour >= 22 || hour < 9) {
      if (!_isQuietHours) {
        enableQuietHours(endTime: _getNextMorningTime());
      }
    } else {
      if (_isQuietHours) {
        disableQuietHours();
      }
    }
  }
  
  /// Get default morning time (9 AM today)
  static DateTime _getDefaultMorningTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 9, 0);
  }
  
  /// Get next morning time (9 AM tomorrow if current time is past 9 AM)
  static DateTime _getNextMorningTime() {
    final now = DateTime.now();
    if (now.hour >= 9) {
      // If it's already past 9 AM, return tomorrow's 9 AM
      return DateTime(now.year, now.month, now.day + 1, 9, 0);
    } else {
      // If it's before 9 AM, return today's 9 AM
      return DateTime(now.year, now.month, now.day, 9, 0);
    }
  }
  
  /// Initialize quiet hours service
  static void initialize() {
    updateQuietHoursStatus();
    debugPrint('🌙 [QuietHoursService] Initialized - isQuietHours: $_isQuietHours');
  }
}