import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/time_capsule_creation_data.dart';
import '../providers/time_capsule_creation_provider.dart';

/// Premium time option card with hover effects and selection animations
/// Matches the HTML design exactly with beautiful interactions
class TimeOptionCard extends ConsumerStatefulWidget {
  final TimeOption timeOption;
  final VoidCallback? onTap;

  const TimeOptionCard({
    super.key,
    required this.timeOption,
    this.onTap,
  });

  @override
  ConsumerState<TimeOptionCard> createState() => _TimeOptionCardState();
}

class _TimeOptionCardState extends ConsumerState<TimeOptionCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _selectionController;
  late AnimationController _iconController;
  
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _selectionScaleAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _borderColorAnimation = ColorTween(
      begin: AppColors.whisperGray,
      end: AppColors.sageGreen,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _iconScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeOut,
    ));
    
    _selectionScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _selectionController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    
    // Selection animation
    _selectionController.forward().then((_) {
      _selectionController.reverse();
    });
    
    // Call the tap handler
    widget.onTap?.call();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _hoverController.forward();
      _iconController.forward();
    } else {
      _hoverController.reverse();
      _iconController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTimeOption = ref.watch(selectedTimeOptionProvider);
    final isSelected = selectedTimeOption == widget.timeOption;

    // Update selection animation based on state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isSelected && !_selectionController.isAnimating) {
        _selectionController.forward();
      } else if (!isSelected && _selectionController.isCompleted) {
        _selectionController.reverse();
      }
    });

    return AnimatedBuilder(
      animation: Listenable.merge([
        _hoverController,
        _selectionController,
        _iconController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _selectionScaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _handleHover(true),
            onExit: (_) => _handleHover(false),
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.sageGreenWithOpacity(0.05)
                      : AppColors.pearlWhite,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.sageGreen
                        : _borderColorAnimation.value ?? AppColors.whisperGray,
                    width: isSelected ? 2.0 : 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected 
                          ? AppColors.sageGreenWithOpacity(0.2)
                          : AppColors.cardShadow,
                      blurRadius: _elevationAnimation.value * 2,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Selection indicator bar
                    if (isSelected)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.sageGreen, AppColors.sageGreenLight],
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                          ),
                        ),
                      ),
                    
                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacingL),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated icon
                          Transform.scale(
                            scale: _iconScaleAnimation.value,
                            child: Text(
                              widget.timeOption.metaphor,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          
                          const SizedBox(height: AppDimensions.spacingS),
                          
                          // Title
                          Text(
                            widget.timeOption.display,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isSelected 
                                  ? AppColors.sageGreen
                                  : AppColors.softCharcoal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppDimensions.spacingXS),
                          
                          // Subtitle
                          Text(
                            widget.timeOption.subtitle,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.softCharcoalLight,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Hover highlight
                    if (_isHovered && !isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.sageGreenWithOpacity(0.02),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                          ),
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

/// Grid widget for displaying time options
class TimeOptionsGrid extends ConsumerWidget {
  final Function(TimeOption) onTimeOptionSelected;
  final Duration animationDelay;

  const TimeOptionsGrid({
    super.key,
    required this.onTimeOptionSelected,
    this.animationDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Section title
        Center(
          child: Text(
            'Popular Time Periods',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.softCharcoal,
            ),
          ),
        ),
        
        const SizedBox(height: AppDimensions.spacingL),
        
        // Grid of options
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppDimensions.spacingM,
            mainAxisSpacing: AppDimensions.spacingM,
            childAspectRatio: 1.1,
          ),
          itemCount: TimeOption.values.length,
          itemBuilder: (context, index) {
            final timeOption = TimeOption.values[index];
            
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: TimeOptionCard(
                      timeOption: timeOption,
                      onTap: () => onTimeOptionSelected(timeOption),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}