import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// Premium bottom navigation widget matching HTML design exactly
/// Features frosted glass effect and smooth transitions
class BottomNavigationWidget extends StatelessWidget {
  /// Currently active tab index
  final int activeIndex;
  
  /// Callback when tab is selected
  final ValueChanged<int>? onTabSelected;

  const BottomNavigationWidget({
    super.key,
    this.activeIndex = 3, // Capsules tab active by default for creation flow
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.95),
        border: const Border(
          top: BorderSide(
            color: AppColors.whisperGray,
            width: 1.0,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPadding,
                AppDimensions.spacingM,
                AppDimensions.screenPadding,
                AppDimensions.spacingXXXL,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: '🏠',
                    label: 'Home',
                    isActive: activeIndex == 0,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: '💬',
                    label: 'Chats',
                    isActive: activeIndex == 1,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: '📚',
                    label: 'Books',
                    isActive: activeIndex == 2,
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: '⏰',
                    label: 'Capsules',
                    isActive: activeIndex == 3,
                  ),
                  _buildNavItem(
                    index: 4,
                    icon: '👤',
                    label: 'Profile',
                    isActive: activeIndex == 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTabSelected?.call(index),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingS),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(4),
              decoration: isActive ? BoxDecoration(
                color: AppColors.sageGreenWithOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ) : null,
              child: Text(
                icon,
                style: TextStyle(
                  fontSize: isActive ? 22 : 20,
                ),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Label
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isActive 
                    ? AppColors.sageGreen 
                    : AppColors.softCharcoalLight,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

