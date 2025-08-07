import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';

/// Premium animated tab component for bottom navigation
/// Features morphing icons, ripple effects, and smooth state transitions
class FTBottomNavTab extends StatefulWidget {
  /// Whether this tab is currently selected
  final bool isSelected;
  
  /// Icon to display when inactive
  final IconData icon;
  
  /// Icon to display when active
  final IconData activeIcon;
  
  /// Tab label text
  final String label;
  
  /// Callback when tab is tapped
  final VoidCallback? onTap;
  
  /// Custom scale factor for the tab
  final double scaleFactor;
  
  /// Custom color override
  final Color? customColor;
  
  /// Whether to show badge indicator
  final bool showBadge;
  
  /// Badge count (if applicable)
  final int badgeCount;

  const FTBottomNavTab({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.onTap,
    this.scaleFactor = 1.0,
    this.customColor,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  @override
  State<FTBottomNavTab> createState() => _FTBottomNavTabState();
}

class _FTBottomNavTabState extends State<FTBottomNavTab>
    with TickerProviderStateMixin {
  
  late AnimationController _scaleController;
  late AnimationController _colorController;
  late AnimationController _rippleController;
  late AnimationController _bounceController;
  late AnimationController _morphController;
  
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _morphAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Scale animation for press feedback
    _scaleController = AnimationController(
      duration: AppDurations.buttonPress,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));

    // Color transition animation
    _colorController = AnimationController(
      duration: AppDurations.buttonTap,
      vsync: this,
    );
    
    _colorAnimation = ColorTween(
      begin: AppColors.softCharcoalLight,
      end: widget.customColor ?? AppColors.sageGreen,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeOutCubic,
    ));

    // Ripple effect animation
    _rippleController = AnimationController(
      duration: AppDurations.ripple,
      vsync: this,
    );
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    // Bounce animation for active state
    _bounceController = AnimationController(
      duration: AppDurations.buttonTap,
      vsync: this,
    );
    
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    // Icon morphing animation
    _morphController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    
    _morphAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.easeOutBack,
    ));

    // Set initial state
    if (widget.isSelected) {
      _colorController.forward();
      _morphController.forward();
      _bounceController.forward();
    }
  }

  @override
  void didUpdateWidget(FTBottomNavTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.isSelected != widget.isSelected) {
      _animateStateChange();
    }
  }

  void _animateStateChange() {
    if (widget.isSelected) {
      // Animate to selected state
      _colorController.forward();
      _morphController.forward();
      _bounceController.forward();
    } else {
      // Animate to unselected state
      _colorController.reverse();
      _morphController.reverse();
      _bounceController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _scaleController.forward();
    _rippleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
    
    // Call the callback
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _colorAnimation,
        _rippleAnimation,
        _bounceAnimation,
        _morphAnimation,
      ]),
      builder: (context, child) {
        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Transform.scale(
            scale: _scaleAnimation.value * widget.scaleFactor,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingS,
                vertical: AppDimensions.spacingM,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon container with ripple and bounce effects
                  _buildIconContainer(),
                  
                  const SizedBox(height: AppDimensions.spacingXS),
                  
                  // Label with smooth transitions
                  _buildLabel(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconContainer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ripple effect background
        if (_isPressed) _buildRippleEffect(),
        
        // Icon background with animated color
        Transform.scale(
          scale: _bounceAnimation.value,
          child: AnimatedContainer(
            duration: AppDurations.buttonTap,
            curve: Curves.easeOutCubic,
            width: AppDimensions.minTouchTarget,
            height: AppDimensions.minTouchTarget * 0.75,
            decoration: BoxDecoration(
              color: widget.isSelected 
                ? (_colorAnimation.value ?? AppColors.sageGreen).withOpacity(0.15)
                : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: widget.isSelected ? Border.all(
                color: (_colorAnimation.value ?? AppColors.sageGreen).withOpacity(0.3),
                width: 1,
              ) : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Morphing icon transition
                _buildMorphingIcon(),
                
                // Badge indicator
                if (widget.showBadge) _buildBadge(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRippleEffect() {
    return AnimatedBuilder(
      animation: _rippleAnimation,
      builder: (context, child) {
        return Container(
          width: AppDimensions.minTouchTarget * (1 + _rippleAnimation.value),
          height: AppDimensions.minTouchTarget * (1 + _rippleAnimation.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (_colorAnimation.value ?? AppColors.sageGreen)
                .withOpacity(0.2 * (1 - _rippleAnimation.value)),
          ),
        );
      },
    );
  }

  Widget _buildMorphingIcon() {
    return AnimatedSwitcher(
      duration: AppDurations.morphController,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: Icon(
        widget.isSelected ? widget.activeIcon : widget.icon,
        key: ValueKey(widget.isSelected),
        size: AppDimensions.iconM + (2 * _morphAnimation.value),
        color: _colorAnimation.value ?? AppColors.softCharcoalLight,
      ),
    );
  }

  Widget _buildBadge() {
    if (!widget.showBadge) return const SizedBox.shrink();
    
    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.dustyRose,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(
            color: AppColors.pearlWhite,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.dustyRose.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: widget.badgeCount > 0
          ? Text(
              widget.badgeCount > 99 ? '99+' : widget.badgeCount.toString(),
              style: const TextStyle(
                color: AppColors.pearlWhite,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
              textAlign: TextAlign.center,
            )
          : null,
      ),
    );
  }

  Widget _buildLabel() {
    return AnimatedDefaultTextStyle(
      duration: AppDurations.buttonTap,
      curve: Curves.easeOut,
      style: TextStyle(
        fontSize: 11,
        fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
        color: _colorAnimation.value ?? AppColors.softCharcoalLight,
        letterSpacing: 0.3,
        height: 1.2,
      ),
      child: Text(
        widget.label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _colorController.dispose();
    _rippleController.dispose();
    _bounceController.dispose();
    _morphController.dispose();
    super.dispose();
  }
}

/// Extension to add morphing animation duration to AppDurations
extension MorphDuration on AppDurations {
  static const Duration morphController = Duration(milliseconds: 250);
}