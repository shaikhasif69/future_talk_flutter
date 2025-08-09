import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../models/friend_status.dart';

/// Interactive social battery widget with 3-state selector
/// Features smooth color transitions and haptic feedback
class SocialBatteryWidget extends StatefulWidget {
  /// Current battery level
  final SocialBatteryLevel currentLevel;
  
  /// Callback when battery level changes
  final ValueChanged<SocialBatteryLevel> onLevelChanged;
  
  /// Custom animation duration
  final Duration? animationDuration;
  
  /// Enable haptic feedback
  final bool enableHaptics;

  const SocialBatteryWidget({
    super.key,
    required this.currentLevel,
    required this.onLevelChanged,
    this.animationDuration,
    this.enableHaptics = true,
  });

  @override
  State<SocialBatteryWidget> createState() => _SocialBatteryWidgetState();
}

class _SocialBatteryWidgetState extends State<SocialBatteryWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _colorController;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;
  
  SocialBatteryLevel? _previousLevel;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _colorController = AnimationController(
      duration: widget.animationDuration ?? AppDurations.medium,
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _updateColorAnimation();
    _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(SocialBatteryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.currentLevel != widget.currentLevel) {
      _previousLevel = oldWidget.currentLevel;
      _updateColorAnimation();
      _colorController.forward(from: 0.0);
      
      if (widget.enableHaptics) {
        HapticFeedback.selectionClick();
      }
    }
  }

  void _updateColorAnimation() {
    final startColor = _previousLevel?.color ?? widget.currentLevel.color;
    final endColor = widget.currentLevel.color;
    
    _colorAnimation = ColorTween(
      begin: startColor,
      end: endColor,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _handleLevelTap(SocialBatteryLevel level) {
    if (level != widget.currentLevel) {
      widget.onLevelChanged(level);
      
      if (widget.enableHaptics) {
        HapticFeedback.mediumImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreenWithOpacity(0.1),
            AppColors.lavenderMistLight.withValues(alpha:  0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.2),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppDimensions.spacingM),
          _buildControls(),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.medium)
        .slideY(begin: 0.2, end: 0.0, duration: AppDurations.medium);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Your Social Battery',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.softCharcoal,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_pulseAnimation, _colorAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _colorAnimation.value ?? widget.currentLevel.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: AppDimensions.spacingS),
            AnimatedBuilder(
              animation: _colorController,
              builder: (context, child) {
                return Text(
                  widget.currentLevel.displayName,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.softCharcoal,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      children: SocialBatteryLevel.values.map((level) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: level != SocialBatteryLevel.values.last 
                  ? AppDimensions.spacingS 
                  : 0,
            ),
            child: _buildControlButton(level),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildControlButton(SocialBatteryLevel level) {
    final isActive = level == widget.currentLevel;
    
    return GestureDetector(
      onTap: () => _handleLevelTap(level),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: isActive ? level.color : Colors.transparent,
          border: Border.all(
            color: isActive ? level.color : AppColors.sageGreenWithOpacity(0.3),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              level.icon,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: AppDimensions.spacingXS),
            Flexible(
              child: Text(
                level.statusMessage,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isActive 
                      ? AppColors.pearlWhite 
                      : AppColors.softCharcoal,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(target: isActive ? 1.0 : 0.0)
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.02, 1.02),
          duration: AppDurations.fast,
        );
  }
}

/// Simplified social battery indicator for read-only display
class SocialBatteryIndicator extends StatelessWidget {
  /// Battery level to display
  final SocialBatteryLevel level;
  
  /// Size of the indicator
  final double size;
  
  /// Show label next to indicator
  final bool showLabel;

  const SocialBatteryIndicator({
    super.key,
    required this.level,
    this.size = 12.0,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: level.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.pearlWhite,
              width: 2.0,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: AppDimensions.spacingXS),
          Text(
            level.displayName,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
        ],
      ],
    );
  }
}

/// Animated social battery level changer with smooth transitions
class AnimatedSocialBatteryLevel extends StatefulWidget {
  /// Current battery level
  final SocialBatteryLevel level;
  
  /// Animation duration
  final Duration duration;
  
  /// Custom size
  final double size;

  const AnimatedSocialBatteryLevel({
    super.key,
    required this.level,
    this.duration = const Duration(milliseconds: 800),
    this.size = 16.0,
  });

  @override
  State<AnimatedSocialBatteryLevel> createState() => 
      _AnimatedSocialBatteryLevelState();
}

class _AnimatedSocialBatteryLevelState extends State<AnimatedSocialBatteryLevel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  SocialBatteryLevel? _previousLevel;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(AnimatedSocialBatteryLevel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level != widget.level) {
      _previousLevel = oldWidget.level;
      _updateAnimation();
      _controller.forward(from: 0.0);
    }
  }

  void _updateAnimation() {
    _colorAnimation = ColorTween(
      begin: _previousLevel?.color ?? widget.level.color,
      end: widget.level.color,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _colorAnimation.value ?? widget.level.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.pearlWhite,
              width: 2.0,
            ),
          ),
        );
      },
    );
  }
}