import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

/// Preference option data model
class PreferenceOption {
  final String id;
  final String icon;
  final String label;
  final String description;
  final bool isSelected;

  const PreferenceOption({
    required this.id,
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
  });
}

/// Grid of preference options with premium styling and animations
class PreferenceGrid extends StatelessWidget {
  final List<PreferenceOption> preferences;
  final ValueChanged<String> onPreferenceToggled;

  const PreferenceGrid({
    super.key,
    required this.preferences,
    required this.onPreferenceToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
        childAspectRatio: 1.2,
      ),
      itemCount: preferences.length,
      itemBuilder: (context, index) {
        return PreferenceItem(
          preference: preferences[index],
          onTap: () => onPreferenceToggled(preferences[index].id),
        );
      },
    );
  }
}

/// Individual preference item with animations
class PreferenceItem extends StatefulWidget {
  final PreferenceOption preference;
  final VoidCallback onTap;

  const PreferenceItem({
    super.key,
    required this.preference,
    required this.onTap,
  });

  @override
  State<PreferenceItem> createState() => _PreferenceItemState();
}

class _PreferenceItemState extends State<PreferenceItem>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _selectionController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    ));
    
    _borderAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeOut,
    ));
    
    _backgroundAnimation = ColorTween(
      begin: AppColors.warmCream,
      end: AppColors.sageGreen.withAlpha(26),
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeOut,
    ));
    
    // Set initial selection state
    if (widget.preference.isSelected) {
      _selectionController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PreferenceItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.preference.isSelected != oldWidget.preference.isSelected) {
      if (widget.preference.isSelected) {
        _selectionController.forward();
      } else {
        _selectionController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _pressController.forward().then((_) {
      _pressController.reverse();
    });
    
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _borderAnimation,
        _backgroundAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: _backgroundAnimation.value,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: widget.preference.isSelected
                    ? AppColors.sageGreen
                    : AppColors.whisperGray,
                width: _borderAnimation.value,
              ),
              boxShadow: widget.preference.isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.sageGreen.withAlpha(51),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: AppColors.softCharcoal.withAlpha(13),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                onTap: _handleTap,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.preference.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: AppDimensions.spacingS),
                      Text(
                        widget.preference.label,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.softCharcoal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacingXS),
                      Text(
                        widget.preference.description,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.softCharcoalLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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