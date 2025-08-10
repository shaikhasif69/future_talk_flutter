import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

class SideMenuInfoCard extends StatelessWidget {
  final String name;
  final String subtitle;

  const SideMenuInfoCard({
    super.key,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.sageGreenWithOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.pearlWhite,
              size: 28,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.pearlWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.pearlWhite.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}