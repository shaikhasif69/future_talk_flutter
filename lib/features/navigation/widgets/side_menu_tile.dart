import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/menu_item.dart';

class SideMenuTile extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onTap;
  final bool isActive;

  const SideMenuTile({
    super.key,
    required this.menuItem,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.screenPadding,
            top: 2,
            bottom: 2,
          ),
          child: Divider(
            height: 1,
            color: AppColors.pearlWhite.withValues(alpha: 0.2),
          ),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              height: 56,
              curve: Curves.fastOutSlowIn,
              left: 0,
              width: isActive ? MediaQuery.of(context).size.width / 1.35 : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.sageGreenWithOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
            ListTile(
              onTap: onTap,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
                vertical: 4,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive 
                      ? AppColors.pearlWhite.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(
                  menuItem.icon,
                  color: isActive 
                      ? AppColors.pearlWhite 
                      : AppColors.pearlWhite.withValues(alpha: 0.8),
                  size: 22,
                ),
              ),
              title: Text(
                menuItem.title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isActive 
                      ? AppColors.pearlWhite 
                      : AppColors.pearlWhite.withValues(alpha: 0.9),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}