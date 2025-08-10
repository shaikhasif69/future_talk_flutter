import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/time_capsule_creation_data.dart';

/// Premium purpose selection card with smooth animations
/// Matches the HTML design exactly with interactive states and haptic feedback
class PurposeCard extends StatefulWidget {
  /// The purpose this card represents
  final TimeCapsulePurpose purpose;
  
  /// Whether this card is currently selected
  final bool isSelected;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;
  
  /// Animation delay for entrance animation
  final Duration animationDelay;

  const PurposeCard({
    super.key,
    required this.purpose,
    required this.isSelected,
    this.onTap,
    this.animationDelay = Duration.zero,
  });

  @override
  State<PurposeCard> createState() => _PurposeCardState();
}

class _PurposeCardState extends State<PurposeCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late AnimationController _enterController;
  
  late Animation<double> _hoverAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _entranceAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _enterController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    ));
    
    _entranceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOut,
    ));
    
    // Start entrance animation after delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _enterController.forward();
      }
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    _enterController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _pressController.forward();
    HapticFeedback.selectionClick();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse();
    
    // Add subtle scale animation on selection
    if (!widget.isSelected) {
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOut,
      ));
      
      _pressController.forward().then((_) {
        _pressController.reverse();
      });
    }
    
    HapticFeedback.mediumImpact();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  Color get _iconBackgroundColor {
    switch (widget.purpose) {
      case TimeCapsulePurpose.futureMe:
        return AppColors.sageGreen;
      case TimeCapsulePurpose.someoneSpecial:
        return AppColors.dustyRose;
      case TimeCapsulePurpose.anonymous:
        return AppColors.cloudBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _enterController,
        _hoverController,
        _pressController,
      ]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _entranceAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _hoverAnimation.value * _scaleAnimation.value,
              child: MouseRegion(
                onEnter: _handleHoverEnter,
                onExit: _handleHoverExit,
                child: GestureDetector(
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: AppColors.pearlWhite,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      border: Border.all(
                        color: widget.isSelected 
                            ? AppColors.sageGreen
                            : (_isHovered ? AppColors.sageGreen : AppColors.whisperGray),
                        width: widget.isSelected ? 2.0 : (_isHovered ? 1.5 : 2.0),
                      ),
                      gradient: widget.isSelected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.sageGreenWithOpacity(0.03),
                                AppColors.pearlWhite,
                              ],
                            )
                          : null,
                      boxShadow: [
                        if (_isHovered || widget.isSelected)
                          BoxShadow(
                            color: widget.isSelected 
                                ? AppColors.sageGreenWithOpacity(0.2)
                                : AppColors.sageGreenWithOpacity(0.15),
                            blurRadius: widget.isSelected ? 24.0 : 12.0,
                            offset: Offset(0, widget.isSelected ? 8.0 : 4.0),
                          ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Top accent bar for selected state
                        if (widget.isSelected)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.sageGreen, AppColors.sageGreenLight],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(AppDimensions.radiusL),
                                  topRight: Radius.circular(AppDimensions.radiusL),
                                ),
                              ),
                            ),
                          ),
                        
                        Padding(
                          padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with icon and title
                              Row(
                                children: [
                                  // Icon container
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          _iconBackgroundColor,
                                          _iconBackgroundColor.withAlpha(204),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _iconBackgroundColor.withAlpha(77),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.purpose.emoji,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: AppDimensions.spacingL),
                                  
                                  // Title and subtitle
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.purpose.title,
                                          style: AppTextStyles.featureHeading,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.purpose.subtitle,
                                          style: AppTextStyles.labelMedium.copyWith(
                                            color: AppColors.sageGreen,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: AppDimensions.spacingL),
                              
                              // Description
                              Text(
                                widget.purpose.description,
                                style: AppTextStyles.personalContent.copyWith(
                                  fontSize: 14,
                                  color: AppColors.softCharcoalLight,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              
                              const SizedBox(height: AppDimensions.spacingL),
                              
                              // Feature tags
                              Wrap(
                                spacing: AppDimensions.spacingS,
                                runSpacing: AppDimensions.spacingS,
                                children: widget.purpose.featureTags.map((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimensions.spacingM,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.isSelected
                                          ? AppColors.sageGreenWithOpacity(0.1)
                                          : AppColors.warmCream,
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                    ),
                                    child: Text(
                                      tag,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: widget.isSelected
                                            ? AppColors.sageGreen
                                            : AppColors.softCharcoalLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}