import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

/// Premium settings toggle switch with smooth animations
class SettingsToggle extends StatefulWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isEnabled;

  const SettingsToggle({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  State<SettingsToggle> createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<SettingsToggle>
    with TickerProviderStateMixin {
  late AnimationController _toggleController;
  late AnimationController _pressController;
  late Animation<double> _knobAnimation;
  late Animation<Color?> _backgroundAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _toggleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _knobAnimation = Tween<double>(
      begin: 2.0,
      end: 24.0,
    ).animate(CurvedAnimation(
      parent: _toggleController,
      curve: Curves.easeOut,
    ));
    
    _backgroundAnimation = ColorTween(
      begin: AppColors.whisperGray,
      end: AppColors.sageGreen,
    ).animate(CurvedAnimation(
      parent: _toggleController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    ));
    
    // Set initial state
    if (widget.value) {
      _toggleController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SettingsToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _toggleController.forward();
      } else {
        _toggleController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _toggleController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isEnabled) return;
    
    setState(() => _isPressed = true);
    _pressController.forward().then((_) {
      _pressController.reverse().then((_) {
        if (mounted) setState(() => _isPressed = false);
      });
    });
    
    HapticFeedback.selectionClick();
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          onTap: _handleTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingL,
              horizontal: AppDimensions.spacingS,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.whisperGray,
                  width: AppDimensions.dividerHeight,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTextStyles.settingsLabel.copyWith(
                          color: widget.isEnabled
                              ? AppColors.softCharcoal
                              : AppColors.stoneGray,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXS),
                      Text(
                        widget.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: widget.isEnabled
                              ? AppColors.softCharcoalLight
                              : AppColors.stoneGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                _buildToggleSwitch(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _toggleController,
        _pressController,
        _backgroundAnimation,
        _knobAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 48,
            height: 26,
            decoration: BoxDecoration(
              color: widget.isEnabled
                  ? _backgroundAnimation.value
                  : AppColors.stoneGray,
              borderRadius: BorderRadius.circular(13),
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.softCharcoal.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  left: _knobAnimation.value,
                  top: 2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.pearlWhite,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.softCharcoal.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}