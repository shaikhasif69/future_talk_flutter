import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';

/// Premium floating action button with magnetic feel and haptic feedback
/// Features smooth animations, hover effects, and customizable actions
class DashboardFAB extends StatefulWidget {
  /// Primary action callback
  final VoidCallback onPressed;
  
  /// FAB icon
  final IconData icon;
  
  /// FAB tooltip
  final String? tooltip;
  
  /// Enable magnetic hover effects
  final bool enableMagneticEffect;
  
  /// Enable haptic feedback
  final bool enableHaptics;
  
  /// Custom gradient colors
  final Gradient? gradient;
  
  /// FAB size
  final double size;
  
  /// Position from bottom
  final double bottomOffset;
  
  /// Position from right
  final double rightOffset;

  const DashboardFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    this.tooltip,
    this.enableMagneticEffect = true,
    this.enableHaptics = true,
    this.gradient,
    this.size = 56.0,
    this.bottomOffset = 100.0,
    this.rightOffset = 24.0,
  });

  @override
  State<DashboardFAB> createState() => _DashboardFABState();
}

class _DashboardFABState extends State<DashboardFAB>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late AnimationController _pulseController;
  
  late Animation<double> _hoverScale;
  late Animation<double> _pressScale;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<Offset> _magneticOffset;
  
  bool _isHovered = false;
  bool _isPressed = false;
  Offset _lastPanPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: AppDurations.cardHover,
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: AppDurations.buttonPress,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _hoverScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _pressScale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _shadowAnimation = Tween<double>(
      begin: 8.0,
      end: 16.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _magneticOffset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    // Start subtle pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _pressController.forward();
    
    if (widget.enableHaptics) {
      HapticFeedback.mediumImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse();
    
    if (widget.enableHaptics) {
      HapticFeedback.heavyImpact();
    }
    
    // Add a slight delay for the animation to complete
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onPressed();
    });
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    setState(() => _isHovered = true);
    _hoverController.forward();
    
    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
  }

  void _handleHoverExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!widget.enableMagneticEffect || !_isHovered) return;
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final center = Offset(size.width / 2, size.height / 2);
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    
    // Calculate magnetic offset (max 8px in any direction)
    final offset = (localPosition - center) * 0.15;
    final clampedOffset = Offset(
      offset.dx.clamp(-8.0, 8.0),
      offset.dy.clamp(-8.0, 8.0),
    );
    
    setState(() {
      _lastPanPosition = clampedOffset;
    });
    
    _magneticOffset = Tween<Offset>(
      begin: _magneticOffset.value,
      end: clampedOffset,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!widget.enableMagneticEffect) return;
    
    setState(() {
      _lastPanPosition = Offset.zero;
    });
    
    _magneticOffset = Tween<Offset>(
      begin: _magneticOffset.value,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.elasticOut,
    ));
    
    _hoverController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.bottomOffset,
      right: widget.rightOffset,
      child: MouseRegion(
        onEnter: _handleHoverEnter,
        onExit: _handleHoverExit,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _hoverScale,
              _pressScale,
              _pulseAnimation,
              _shadowAnimation,
              _magneticOffset,
            ]),
            builder: (context, child) {
              return Transform.translate(
                offset: widget.enableMagneticEffect ? _magneticOffset.value : Offset.zero,
                child: Transform.scale(
                  scale: _hoverScale.value * 
                         _pressScale.value * 
                         _pulseAnimation.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      gradient: widget.gradient ?? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.sageGreen,
                          AppColors.sageGreenHover,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sageGreen.withOpacity( 0.4),
                          blurRadius: _shadowAnimation.value,
                          offset: Offset(0, _shadowAnimation.value / 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(widget.size / 2),
                        onTap: null, // Handled by gesture detector
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            size: widget.size * 0.4,
                            color: AppColors.pearlWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: AppDurations.medium,
          delay: 800.ms,
          curve: Curves.elasticOut,
        );
  }
}

/// Extended FAB with additional quick actions menu
class DashboardExtendedFAB extends StatefulWidget {
  /// Primary action callback
  final VoidCallback onPressed;
  
  /// Primary action label
  final String label;
  
  /// Primary action icon
  final IconData icon;
  
  /// Quick actions list
  final List<FABQuickAction> quickActions;
  
  /// Enable haptic feedback
  final bool enableHaptics;

  const DashboardExtendedFAB({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon = Icons.add_rounded,
    this.quickActions = const [],
    this.enableHaptics = true,
  });

  @override
  State<DashboardExtendedFAB> createState() => _DashboardExtendedFABState();
}

class _DashboardExtendedFABState extends State<DashboardExtendedFAB>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
    
    if (widget.enableHaptics) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100.0,
      right: 24.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Quick actions menu
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _expandAnimation.value,
                alignment: Alignment.bottomRight,
                child: Opacity(
                  opacity: _expandAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: widget.quickActions.reversed.map((action) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
                        child: _buildQuickActionItem(action),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          
          // Main FAB
          FloatingActionButton.extended(
            onPressed: widget.quickActions.isEmpty ? widget.onPressed : _toggleExpanded,
            backgroundColor: AppColors.sageGreen,
            foregroundColor: AppColors.pearlWhite,
            elevation: 8.0,
            icon: AnimatedRotation(
              turns: _isExpanded ? 0.125 : 0.0,
              duration: AppDurations.medium,
              child: Icon(widget.icon),
            ),
            label: Text(
              widget.label,
              style: AppTextStyles.button.copyWith(
                color: AppColors.pearlWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(FABQuickAction action) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.softCharcoal,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Text(
            action.label,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.pearlWhite,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        FloatingActionButton.small(
          onPressed: () {
            _toggleExpanded();
            action.onPressed();
          },
          backgroundColor: action.backgroundColor ?? AppColors.lavenderMist,
          child: Icon(
            action.icon,
            color: AppColors.pearlWhite,
            size: 20,
          ),
        ),
      ],
    );
  }
}

/// Quick action item for extended FAB
class FABQuickAction {
  /// Action label
  final String label;
  
  /// Action icon
  final IconData icon;
  
  /// Action callback
  final VoidCallback onPressed;
  
  /// Custom background color
  final Color? backgroundColor;

  const FABQuickAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  });
}

/// Minimalist FAB for compact layouts
class CompactDashboardFAB extends StatefulWidget {
  /// Action callback
  final VoidCallback onPressed;
  
  /// FAB icon
  final IconData icon;
  
  /// FAB size
  final double size;

  const CompactDashboardFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    this.size = 48.0,
  });

  @override
  State<CompactDashboardFAB> createState() => _CompactDashboardFABState();
}

class _CompactDashboardFABState extends State<CompactDashboardFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();
    
    _tapController = AnimationController(
      duration: AppDurations.buttonPress,
      vsync: this,
    );
    
    _tapAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapController.forward().then((_) {
      _tapController.reverse();
    });
    
    HapticFeedback.lightImpact();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tapAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _tapAnimation.value,
          child: FloatingActionButton(
            onPressed: _handleTap,
            backgroundColor: AppColors.sageGreen,
            foregroundColor: AppColors.pearlWhite,
            elevation: 4.0,
            mini: widget.size < 56.0,
            child: Icon(
              widget.icon,
              size: widget.size * 0.4,
            ),
          ),
        );
      },
    );
  }
}