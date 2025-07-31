import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_durations.dart';

/// Future Talk's premium card component
/// Designed with subtle animations and premium aesthetics
class FTCard extends StatefulWidget {
  /// Card child widget
  final Widget child;
  
  /// Card tap callback (optional)
  final VoidCallback? onTap;
  
  /// Card long press callback (optional)
  final VoidCallback? onLongPress;
  
  /// Card padding (default uses cardPadding)
  final EdgeInsetsGeometry? padding;
  
  /// Card margin (default uses card theme margin)
  final EdgeInsetsGeometry? margin;
  
  /// Card height (if null, uses intrinsic height)
  final double? height;
  
  /// Card width (if null, uses intrinsic width)
  final double? width;
  
  /// Card background color (if null, uses theme color)
  final Color? backgroundColor;
  
  /// Card elevation (if null, uses theme elevation)
  final double? elevation;
  
  /// Custom border radius (if null, uses theme radius)
  final BorderRadius? borderRadius;
  
  /// Show card shadow
  final bool showShadow;
  
  /// Card style variant
  final FTCardStyle style;
  
  /// Enable hover effects (for web/desktop)
  final bool enableHoverEffects;
  
  /// Show loading state
  final bool isLoading;

  const FTCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.showShadow = true,
    this.style = FTCardStyle.elevated,
    this.enableHoverEffects = true,
    this.isLoading = false,
  });

  /// Basic elevated card
  const FTCard.elevated({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.enableHoverEffects = true,
    this.isLoading = false,
  }) : style = FTCardStyle.elevated,
       showShadow = true;

  /// Flat card without shadow
  const FTCard.flat({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.enableHoverEffects = true,
    this.isLoading = false,
  }) : style = FTCardStyle.flat,
       showShadow = false;

  /// Outlined card with border
  const FTCard.outlined({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.enableHoverEffects = true,
    this.isLoading = false,
  }) : style = FTCardStyle.outlined,
       showShadow = false;

  /// Gradient card with premium feel
  const FTCard.gradient({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.enableHoverEffects = true,
    this.isLoading = false,
  }) : style = FTCardStyle.gradient,
       showShadow = true;

  @override
  State<FTCard> createState() => _FTCardState();
}

class _FTCardState extends State<FTCard> with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: AppDurations.cardHover,
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: AppDurations.cardTap,
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
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isInteractive) return;
    
    setState(() => _isPressed = true);
    _pressController.forward();
    
    // Light haptic feedback
    HapticFeedback.selectionClick();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isInteractive) return;
    
    setState(() => _isPressed = false);
    _pressController.reverse();
    
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleLongPress() {
    if (!_isInteractive) return;
    
    // Medium haptic feedback for long press
    HapticFeedback.mediumImpact();
    widget.onLongPress?.call();
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    if (!widget.enableHoverEffects || !_isInteractive) return;
    
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit(PointerExitEvent event) {
    if (!widget.enableHoverEffects) return;
    
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  bool get _isInteractive => widget.onTap != null || widget.onLongPress != null;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingCard();
    }

    Widget cardWidget = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: _buildCardDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: widget.borderRadius ?? 
              BorderRadius.circular(AppDimensions.cardRadius),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: Container(
            padding: widget.padding ?? 
                const EdgeInsets.all(AppDimensions.cardPadding),
            child: widget.child,
          ),
        ),
      ),
    );

    if (_isInteractive && widget.enableHoverEffects) {
      cardWidget = MouseRegion(
        onEnter: _handleHoverEnter,
        onExit: _handleHoverExit,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onLongPress: _handleLongPress,
          child: AnimatedBuilder(
            animation: Listenable.merge([_hoverAnimation, _scaleAnimation]),
            child: cardWidget,
            builder: (context, child) {
              return Transform.scale(
                scale: _hoverAnimation.value * _scaleAnimation.value,
                child: child,
              );
            },
          ),
        ),
      );
    }

    return cardWidget;
  }

  Widget _buildLoadingCard() {
    return Container(
      width: widget.width,
      height: widget.height ?? AppDimensions.cardMinHeight,
      margin: widget.margin,
      decoration: _buildCardDecoration(),
      child: Container(
        padding: widget.padding ?? 
            const EdgeInsets.all(AppDimensions.cardPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                'Loading...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    switch (widget.style) {
      case FTCardStyle.elevated:
        return BoxDecoration(
          color: widget.backgroundColor ?? AppColors.warmCreamAlt,
          borderRadius: widget.borderRadius ?? 
              BorderRadius.circular(AppDimensions.cardRadius),
          boxShadow: widget.showShadow ? [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: _isPressed ? 4.0 : (_isHovered ? 12.0 : 8.0),
              offset: Offset(0, _isPressed ? 1.0 : (_isHovered ? 4.0 : 2.0)),
            ),
          ] : null,
        );
        
      case FTCardStyle.flat:
        return BoxDecoration(
          color: widget.backgroundColor ?? AppColors.warmCreamAlt,
          borderRadius: widget.borderRadius ?? 
              BorderRadius.circular(AppDimensions.cardRadius),
        );
        
      case FTCardStyle.outlined:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.transparent,
          border: Border.all(
            color: _isHovered ? AppColors.sageGreen : AppColors.whisperGray,
            width: _isHovered ? 2.0 : 1.0,
          ),
          borderRadius: widget.borderRadius ?? 
              BorderRadius.circular(AppDimensions.cardRadius),
        );
        
      case FTCardStyle.gradient:
        return BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: widget.borderRadius ?? 
              BorderRadius.circular(AppDimensions.cardRadius),
          boxShadow: widget.showShadow ? [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: _isPressed ? 4.0 : (_isHovered ? 12.0 : 8.0),
              offset: Offset(0, _isPressed ? 1.0 : (_isHovered ? 4.0 : 2.0)),
            ),
          ] : null,
        );
    }
  }
}

/// Card style variants
enum FTCardStyle {
  elevated,
  flat,
  outlined,
  gradient,
}

/// Shimmer loading card for skeleton UI
class FTCardShimmer extends StatefulWidget {
  /// Card height
  final double height;
  
  /// Card width (if null, uses full width)
  final double? width;
  
  /// Card margin
  final EdgeInsetsGeometry? margin;
  
  /// Custom border radius
  final BorderRadius? borderRadius;

  const FTCardShimmer({
    super.key,
    this.height = AppDimensions.cardMinHeight,
    this.width,
    this.margin,
    this.borderRadius,
  });

  @override
  State<FTCardShimmer> createState() => _FTCardShimmerState();
}

class _FTCardShimmerState extends State<FTCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: AppDurations.shimmer,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? 
            BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? 
                  BorderRadius.circular(AppDimensions.cardRadius),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.whisperGray,
                  AppColors.pearlWhite,
                  AppColors.whisperGray,
                ],
                stops: [
                  0.0,
                  _shimmerController.value,
                  1.0,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}