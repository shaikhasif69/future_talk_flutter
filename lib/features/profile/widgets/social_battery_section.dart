import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../../chat/models/social_battery_status.dart';

/// Interactive social battery section with elegant animations
/// Allows users to update their social energy level with premium feel
class SocialBatterySection extends StatefulWidget {
  final SocialBatteryStatus batteryStatus;
  final Function(SocialBatteryLevel) onBatteryLevelChanged;
  final EdgeInsetsGeometry? margin;

  const SocialBatterySection({
    super.key,
    required this.batteryStatus,
    required this.onBatteryLevelChanged,
    this.margin,
  });

  @override
  State<SocialBatterySection> createState() => _SocialBatterySectionState();
}

class _SocialBatterySectionState extends State<SocialBatterySection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _selectionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _selectionScaleAnimation;
  
  SocialBatteryLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _selectionScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.elasticOut,
    ));
    
    // Start pulse animation for current battery indicator
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  void _handleBatteryLevelTap(SocialBatteryLevel level) {
    if (level == widget.batteryStatus.level) return;
    
    setState(() => _selectedLevel = level);
    
    // Haptic feedback with different intensities for different levels
    switch (level) {
      case SocialBatteryLevel.energized:
        HapticFeedback.lightImpact();
        break;
      case SocialBatteryLevel.selective:
        HapticFeedback.mediumImpact();
        break;
      case SocialBatteryLevel.recharging:
        HapticFeedback.heavyImpact();
        break;
    }
    
    // Selection animation
    _selectionController.forward().then((_) {
      _selectionController.reverse();
      widget.onBatteryLevelChanged(level);
      setState(() => _selectedLevel = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsivePadding(screenWidth),
      ).copyWith(top: AppDimensions.spacingS), // Proper spacing from header
      child: FTCard.elevated(
        child: Column(
          children: [
            _buildBatteryHeader(),
            SizedBox(height: AppDimensions.spacingM),
            _buildBatteryOptions(),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildBatteryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        Text(
          'Social Battery',
          style: AppTextStyles.headlineSmall.copyWith(
            fontFamily: AppTextStyles.headingFont,
            color: AppColors.softCharcoal,
          ),
        ),
        
        // Current status indicator
        _buildCurrentStatusIndicator(),
      ],
    );
  }

  Widget _buildCurrentStatusIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: AppDimensions.spacingXS,
            ),
            decoration: BoxDecoration(
              color: widget.batteryStatus.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: widget.batteryStatus.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing indicator dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.batteryStatus.color,
                  ),
                ),
                
                SizedBox(width: AppDimensions.spacingXS),
                
                // Status text
                Text(
                  widget.batteryStatus.displayName,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: widget.batteryStatus.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBatteryOptions() {
    return Row(
      children: SocialBatteryLevel.values.map((level) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingXS),
            child: _buildBatteryOption(level),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBatteryOption(SocialBatteryLevel level) {
    final isActive = level == widget.batteryStatus.level;
    final isSelected = level == _selectedLevel;
    final status = SocialBatteryStatus(
      level: level,
      lastUpdated: DateTime.now(),
    );
    
    return AnimatedBuilder(
      animation: _selectionScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _selectionScaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _handleBatteryLevelTap(level),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXS,
                vertical: AppDimensions.spacingS,
              ),
              decoration: BoxDecoration(
                gradient: isActive ? _getActiveGradient(level) : null,
                color: isActive ? null : AppColors.pearlWhite,
                border: Border.all(
                  color: isActive
                      ? status.color
                      : (isSelected
                          ? status.color.withOpacity(0.5)
                          : AppColors.whisperGray),
                  width: isActive ? 2.0 : 1.0,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: status.color.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Emoji
                  Text(
                    status.emoji,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.0,
                    ),
                  ),
                  
                  SizedBox(height: AppDimensions.spacingXS),
                  
                  // Level name
                  Text(
                    status.displayName,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isActive ? Colors.white : status.color,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  LinearGradient _getActiveGradient(SocialBatteryLevel level) {
    switch (level) {
      case SocialBatteryLevel.energized:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreen,
            AppColors.sageGreenLight,
          ],
        );
      case SocialBatteryLevel.selective:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warmPeach,
            AppColors.warmPeachHover,
          ],
        );
      case SocialBatteryLevel.recharging:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dustyRose,
            AppColors.dustyRoseHover,
          ],
        );
    }
  }
}

/// Compact version for use in other screens
class CompactSocialBatteryIndicator extends StatelessWidget {
  final SocialBatteryStatus batteryStatus;
  final VoidCallback? onTap;

  const CompactSocialBatteryIndicator({
    super.key,
    required this.batteryStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: AppDimensions.spacingXS,
        ),
        decoration: BoxDecoration(
          color: batteryStatus.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: batteryStatus.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              batteryStatus.emoji,
              style: const TextStyle(fontSize: 12),
            ),
            SizedBox(width: AppDimensions.spacingXS),
            Text(
              batteryStatus.displayName,
              style: AppTextStyles.labelSmall.copyWith(
                color: batteryStatus.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Battery level selection dialog for advanced settings
class BatteryLevelDialog extends StatelessWidget {
  final SocialBatteryStatus currentStatus;
  final Function(SocialBatteryLevel, String?) onStatusChanged;

  const BatteryLevelDialog({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FTCard.elevated(
        padding: const EdgeInsets.all(AppDimensions.spacingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Social Battery',
              style: AppTextStyles.headlineSmall.copyWith(
                fontFamily: AppTextStyles.headingFont,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingXL),
            
            // Battery level options
            ...SocialBatteryLevel.values.map((level) {
              final status = SocialBatteryStatus(
                level: level,
                lastUpdated: DateTime.now(),
              );
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                child: ListTile(
                  leading: Text(
                    status.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    status.displayName,
                    style: AppTextStyles.titleMedium,
                  ),
                  subtitle: Text(
                    status.description,
                    style: AppTextStyles.bodySmall,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onStatusChanged(level, null);
                  },
                  selected: level == currentStatus.level,
                  selectedTileColor: status.color.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
              );
            }),
            
            SizedBox(height: AppDimensions.spacingL),
            
            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required SocialBatteryStatus currentStatus,
    required Function(SocialBatteryLevel, String?) onStatusChanged,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => BatteryLevelDialog(
        currentStatus: currentStatus,
        onStatusChanged: onStatusChanged,
      ),
    );
  }
}