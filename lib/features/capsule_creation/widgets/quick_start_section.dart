import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/time_capsule_creation_data.dart';

/// Quick start section with popular ideas grid
/// Matches HTML design exactly with interactive quick start options
class QuickStartSection extends StatefulWidget {
  /// Callback when a quick start option is selected
  final ValueChanged<QuickStartType>? onQuickStartSelected;
  
  /// Animation delay for entrance animation
  final Duration animationDelay;

  const QuickStartSection({
    super.key,
    this.onQuickStartSelected,
    this.animationDelay = const Duration(milliseconds: 300),
  });

  @override
  State<QuickStartSection> createState() => _QuickStartSectionState();
}

class _QuickStartSectionState extends State<QuickStartSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    ));
    
    // Start entrance animation after delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(top: AppDimensions.spacingXXXL),
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          decoration: BoxDecoration(
            color: AppColors.warmCream,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: Column(
            children: [
              // Section title
              Text(
                'Popular Ideas',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.softCharcoal,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              // Quick options grid
              _buildQuickOptionsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickOptionsGrid() {
    final quickStartTypes = QuickStartType.values;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
      ),
      itemCount: quickStartTypes.length,
      itemBuilder: (context, index) {
        final quickStartType = quickStartTypes[index];
        return _QuickStartOption(
          type: quickStartType,
          onTap: () => widget.onQuickStartSelected?.call(quickStartType),
        );
      },
    );
  }
}

/// Individual quick start option widget
class _QuickStartOption extends StatefulWidget {
  final QuickStartType type;
  final VoidCallback? onTap;

  const _QuickStartOption({
    required this.type,
    this.onTap,
  });

  @override
  State<_QuickStartOption> createState() => _QuickStartOptionState();
}

class _QuickStartOptionState extends State<_QuickStartOption>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.elasticOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: AppColors.pearlWhite,
      end: AppColors.sageGreen,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    
    // Trigger tap animation
    _tapController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _tapController.reverse();
        }
      });
    });
    
    widget.onTap?.call();
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _hoverController,
            _tapController,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _hoverAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _colorAnimation.value ?? AppColors.pearlWhite,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: _isHovered 
                        ? AppColors.sageGreen 
                        : AppColors.whisperGray,
                    width: 1.0,
                  ),
                  boxShadow: _isHovered ? [
                    BoxShadow(
                      color: AppColors.sageGreenWithOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Emoji icon with scale animation
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Text(
                        widget.type.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Option text
                    Text(
                      widget.type.displayText,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: _tapController.isAnimating 
                            ? AppColors.pearlWhite
                            : AppColors.softCharcoalLight,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}