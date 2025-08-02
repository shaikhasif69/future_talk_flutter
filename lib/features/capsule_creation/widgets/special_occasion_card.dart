import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/time_capsule_creation_data.dart';
import '../providers/time_capsule_creation_provider.dart';

/// Premium special occasion card with selection animations
/// Matches the HTML design for the occasions grid
class SpecialOccasionCard extends ConsumerStatefulWidget {
  final SpecialOccasion occasion;
  final VoidCallback? onTap;

  const SpecialOccasionCard({
    super.key,
    required this.occasion,
    this.onTap,
  });

  @override
  ConsumerState<SpecialOccasionCard> createState() => _SpecialOccasionCardState();
}

class _SpecialOccasionCardState extends ConsumerState<SpecialOccasionCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _selectionController;
  
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _celebrationScaleAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 4.0,
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
    
    _celebrationScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    
    // Celebration animation
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
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedOccasion = ref.watch(selectedSpecialOccasionProvider);
    final isSelected = selectedOccasion == widget.occasion;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _hoverController,
        _selectionController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _celebrationScaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _handleHover(true),
            onExit: (_) => _handleHover(false),
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingS,
                  vertical: AppDimensions.spacingM,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.sageGreenWithOpacity(0.05)
                      : AppColors.pearlWhite,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.sageGreen
                        : _borderColorAnimation.value ?? AppColors.whisperGray,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected 
                          ? AppColors.sageGreenWithOpacity(0.15)
                          : AppColors.cardShadow,
                      blurRadius: _elevationAnimation.value * 3,
                      offset: Offset(0, _elevationAnimation.value),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Emoji icon
                    Text(
                      widget.occasion.emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingXS),
                    
                    // Occasion text
                    Text(
                      widget.occasion.shortDisplay,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isSelected 
                            ? AppColors.sageGreen
                            : AppColors.softCharcoalLight,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

/// Special occasions section with grid layout
class SpecialOccasionsSection extends ConsumerWidget {
  final Function(SpecialOccasion) onOccasionSelected;

  const SpecialOccasionsSection({
    super.key,
    required this.onOccasionSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          // Section title
          Text(
            'Special Moments',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.softCharcoal,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Occasions grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppDimensions.spacingS,
              mainAxisSpacing: AppDimensions.spacingS,
              childAspectRatio: 0.9,
            ),
            itemCount: SpecialOccasion.values.length,
            itemBuilder: (context, index) {
              final occasion = SpecialOccasion.values[index];
              
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 200 + (index * 30)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: SpecialOccasionCard(
                        occasion: occasion,
                        onTap: () => onOccasionSelected(occasion),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}