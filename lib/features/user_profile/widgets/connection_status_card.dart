import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/user_profile_model.dart';

/// Connection status card showing user's current mood and interaction buttons
/// Positioned below the collapsible header with smooth animations
class ConnectionStatusCard extends StatefulWidget {
  final UserProfileModel userProfile;
  final VoidCallback? onTouchStone;
  final VoidCallback? onSendMessage;

  const ConnectionStatusCard({
    super.key,
    required this.userProfile,
    this.onTouchStone,
    this.onSendMessage,
  });

  @override
  State<ConnectionStatusCard> createState() => _ConnectionStatusCardState();
}

class _ConnectionStatusCardState extends State<ConnectionStatusCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _batteryPulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _batteryPulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _batteryPulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _batteryPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _batteryPulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _slideController.forward();
    _batteryPulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _batteryPulseController.dispose();
    super.dispose();
  }

  Color get _batteryColor {
    switch (widget.userProfile.currentMoodStatus.level) {
      case BatteryLevel.green:
        return AppColors.success;
      case BatteryLevel.yellow:
        return AppColors.warning;
      case BatteryLevel.orange:
        return AppColors.warmPeach;
      case BatteryLevel.red:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideController, _batteryPulseController]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                AppDimensions.screenPadding,
                -AppDimensions.spacingL,
                AppDimensions.screenPadding,
                0,
              ),
              decoration: BoxDecoration(
                color: AppColors.pearlWhite,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusHeader(),
                    const SizedBox(height: AppDimensions.spacingL),
                    _buildStatusDescription(),
                    const SizedBox(height: AppDimensions.spacingL),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Current Mood',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.softCharcoal,
            fontFamily: 'Playfair Display',
          ),
        ),
        _buildBatteryIndicator(),
      ],
    );
  }

  Widget _buildBatteryIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingXS + 2,
      ),
      decoration: BoxDecoration(
        color: _batteryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _batteryPulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _batteryPulseAnimation.value,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _batteryColor,
                    boxShadow: [
                      BoxShadow(
                        color: _batteryColor.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            widget.userProfile.currentMoodStatus.colorName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _batteryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDescription() {
    return Text(
      widget.userProfile.currentMoodStatus.description,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.softCharcoalLight,
        height: 1.4,
        fontStyle: FontStyle.italic,
        fontFamily: 'Crimson Pro',
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildPrimaryButton(),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: _buildSecondaryButton(),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onTouchStone?.call();
          _triggerStoneAnimation();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.sageGreen, AppColors.sageGreenLight],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.sageGreen.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🪨',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: AppDimensions.spacingXS),
              Text(
                'Touch Stone',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onSendMessage?.call();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          decoration: BoxDecoration(
            color: AppColors.sageGreen.withValues(alpha: 0.1),
            border: Border.all(
              color: AppColors.sageGreen.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message_rounded,
                size: 16,
                color: AppColors.sageGreen,
              ),
              SizedBox(width: AppDimensions.spacingXS),
              Text(
                'Send Message',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.sageGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _triggerStoneAnimation() {
    // Create ripple effect for stone touch
    final overlay = Overlay.of(context);

    late OverlayEntry rippleEntry;
    rippleEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            color: AppColors.sageGreen.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sageGreen.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(rippleEntry);

    // Remove ripple after animation
    Future.delayed(const Duration(milliseconds: 600), () {
      rippleEntry.remove();
    });
  }
}

/// Connection action button with premium styling
class ConnectionActionButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final String? emoji;
  final VoidCallback? onTap;
  final bool isPrimary;
  final Color? customColor;

  const ConnectionActionButton({
    super.key,
    required this.label,
    this.icon,
    this.emoji,
    this.onTap,
    this.isPrimary = false,
    this.customColor,
  });

  @override
  State<ConnectionActionButton> createState() => _ConnectionActionButtonState();
}

class _ConnectionActionButtonState extends State<ConnectionActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              onTapDown: (_) => _pressController.forward(),
              onTapUp: (_) => _pressController.reverse(),
              onTapCancel: () => _pressController.reverse(),
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap?.call();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingL,
                  vertical: AppDimensions.spacingM,
                ),
                decoration: BoxDecoration(
                  gradient: widget.isPrimary
                      ? const LinearGradient(
                          colors: [AppColors.sageGreen, AppColors.sageGreenLight],
                        )
                      : null,
                  color: widget.isPrimary 
                      ? null 
                      : (widget.customColor ?? AppColors.sageGreen).withValues(alpha: 0.1),
                  border: widget.isPrimary 
                      ? null 
                      : Border.all(
                          color: (widget.customColor ?? AppColors.sageGreen).withValues(alpha: 0.2),
                          width: 1,
                        ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  boxShadow: widget.isPrimary 
                      ? [
                          BoxShadow(
                            color: AppColors.sageGreen.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.emoji != null) ...[
                      Text(
                        widget.emoji!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: AppDimensions.spacingXS),
                    ] else if (widget.icon != null) ...[
                      Icon(
                        widget.icon!,
                        size: 16,
                        color: widget.isPrimary 
                            ? Colors.white 
                            : (widget.customColor ?? AppColors.sageGreen),
                      ),
                      const SizedBox(width: AppDimensions.spacingXS),
                    ],
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: widget.isPrimary 
                            ? Colors.white 
                            : (widget.customColor ?? AppColors.sageGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}