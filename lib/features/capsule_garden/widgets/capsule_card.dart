import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/time_capsule.dart';
import 'animated_garden_background.dart';

/// Premium capsule card with growth animations and haptic feedback
class CapsuleCard extends StatefulWidget {
  final TimeCapsule capsule;
  final VoidCallback? onTap;
  final bool showAnimation;

  const CapsuleCard({
    super.key,
    required this.capsule,
    this.onTap,
    this.showAnimation = true,
  });

  @override
  State<CapsuleCard> createState() => _CapsuleCardState();
}

class _CapsuleCardState extends State<CapsuleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isHovered = true);
    _hoverController.forward();
    
    // Haptic feedback for premium experience
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapCancel();
  }

  void _handleTapCancel() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  void _handleTap() {
    // Strong haptic feedback for interaction
    HapticFeedback.mediumImpact();
    widget.onTap?.call();
  }

  Color _getCardBackgroundColor() {
    if (widget.capsule.isReady) {
      return AppColors.warmPeachLight;
    }
    return AppColors.pearlWhite;
  }

  Color _getCardBorderColor() {
    if (widget.capsule.isReady) {
      return AppColors.warmPeach;
    }
    return Colors.transparent;
  }

  Widget _buildProgressBar() {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.whisperGray,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widget.capsule.progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.sageGreen, AppColors.sageGreenLight],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isReady = widget.capsule.isReady;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isReady
            ? AppColors.warmPeach.withAlpha(51)
            : AppColors.sageGreen.withAlpha(26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isReady ? 'READY' : 'GROWING',
        style: AppTextStyles.labelSmall.copyWith(
          color: isReady ? AppColors.warmPeach : AppColors.sageGreen,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildRecipientInitial() {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.lavenderMist, AppColors.dustyRose],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.capsule.recipientInitial,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.pearlWhite,
            fontWeight: FontWeight.w600,
            fontSize: 8,
          ),
        ),
      ),
    );
  }

  String _formatTimeRemaining() {
    final now = DateTime.now();
    final delivery = widget.capsule.deliveryAt;
    
    if (delivery.isBefore(now)) {
      return 'Ready now!';
    }
    
    final difference = delivery.difference(now);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} remaining';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} remaining';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} remaining';
    } else {
      return 'Almost ready!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            child: Container(
              decoration: BoxDecoration(
                color: _getCardBackgroundColor(),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getCardBorderColor(),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value * 0.5),
                  ),
                  if (widget.capsule.isReady)
                    BoxShadow(
                      color: AppColors.warmPeach.withAlpha(77),
                      blurRadius: _elevationAnimation.value * 0.5,
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Capsule asset with growth animation
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: OrganicGrowthAnimation(
                          shouldAnimate: widget.showAnimation,
                          duration: Duration(
                            seconds: 3 + (widget.capsule.growthStage.index % 3).toInt(),
                          ),
                          child: Text(
                            widget.capsule.growthStage.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingS),
                    
                    // Title
                    Text(
                      widget.capsule.title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.softCharcoal,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Time remaining
                    Text(
                      _formatTimeRemaining(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingS),
                    
                    // Progress bar
                    _buildProgressBar(),
                    
                    const SizedBox(height: AppDimensions.spacingS),
                    
                    // Status and recipient
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusBadge(),
                        _buildRecipientInitial(),
                      ],
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

/// Quick action button with premium animations
class QuickActionButton extends StatefulWidget {
  final String label;
  final String emoji;
  final VoidCallback onTap;
  final bool isPrimary;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.emoji,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapCancel();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: _handleTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingL,
                  horizontal: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  gradient: widget.isPrimary
                      ? const LinearGradient(
                          colors: [AppColors.sageGreen, AppColors.sageGreenLight],
                        )
                      : const LinearGradient(
                          colors: [AppColors.warmCream, AppColors.pearlWhite],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: widget.isPrimary
                      ? null
                      : Border.all(color: AppColors.whisperGray, width: 2),
                  boxShadow: [
                    if (widget.isPrimary)
                      BoxShadow(
                        color: AppColors.sageGreen.withAlpha(77),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    if (!widget.isPrimary)
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    // Animated emoji
                    OrganicGrowthAnimation(
                      duration: const Duration(seconds: 2),
                      child: Text(
                        widget.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingS),
                    
                    // Label
                    Text(
                      widget.label,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: widget.isPrimary
                            ? AppColors.pearlWhite
                            : AppColors.softCharcoal,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}