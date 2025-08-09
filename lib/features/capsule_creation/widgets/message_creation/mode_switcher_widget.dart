import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/message_creation_data.dart';

/// Mode switcher widget for switching between Write and Record modes
/// Premium segmented control with smooth animations and haptic feedback
class ModeSwitcherWidget extends StatefulWidget {
  final MessageMode currentMode;
  final ValueChanged<MessageMode> onModeChanged;

  const ModeSwitcherWidget({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  State<ModeSwitcherWidget> createState() => _ModeSwitcherWidgetState();
}

class _ModeSwitcherWidgetState extends State<ModeSwitcherWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: widget.currentMode == MessageMode.write ? 0.0 : 1.0,
      end: widget.currentMode == MessageMode.write ? 0.0 : 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(ModeSwitcherWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.currentMode != widget.currentMode) {
      final targetValue = widget.currentMode == MessageMode.write ? 0.0 : 1.0;
      _animationController.animateTo(targetValue);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleModeChange(MessageMode mode) {
    if (mode != widget.currentMode) {
      widget.onModeChanged(mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.paddingM,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.pearlWhite.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(
            color: AppColors.sageGreenWithOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.softCharcoalWithOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated background slider
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Positioned(
                  left: 2 + (_slideAnimation.value * (MediaQuery.of(context).size.width - (AppDimensions.screenPadding * 2) - 4) / 2),
                  top: 2,
                  child: Container(
                    width: (MediaQuery.of(context).size.width - (AppDimensions.screenPadding * 2) - 4) / 2,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.sageGreen,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sageGreenWithOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Mode buttons
            Row(
              children: [
                Expanded(
                  child: _ModeButton(
                    mode: MessageMode.write,
                    isSelected: widget.currentMode == MessageMode.write,
                    onTap: () => _handleModeChange(MessageMode.write),
                  ),
                ),
                Expanded(
                  child: _ModeButton(
                    mode: MessageMode.record,
                    isSelected: widget.currentMode == MessageMode.record,
                    onTap: () => _handleModeChange(MessageMode.record),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual mode button widget
class _ModeButton extends StatelessWidget {
  final MessageMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mode icon
            Text(
              mode.icon,
              style: TextStyle(
                fontSize: 16,
                color: isSelected 
                    ? AppColors.pearlWhite 
                    : AppColors.softCharcoalWithOpacity(0.6),
              ),
            ),
            
            const SizedBox(width: 6),
            
            // Mode text
            Text(
              mode.displayName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected 
                    ? AppColors.pearlWhite 
                    : AppColors.softCharcoalWithOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}