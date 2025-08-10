import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';

/// Settings section container with premium styling
class SettingsSection extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final List<Widget> children;
  final bool isDangerZone;

  const SettingsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.children,
    this.isDangerZone = false,
  });

  @override
  Widget build(BuildContext context) {
    return FTCard.elevated(
      child: Container(
        decoration: BoxDecoration(
          border: isDangerZone
              ? Border.all(
                  color: AppColors.dustyRose.withAlpha(77),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            _buildSectionHeader(),
            
            const SizedBox(height: AppDimensions.spacingS),
            
            // Section Description
            Text(
              description,
              style: AppTextStyles.personalContent.copyWith(
                fontSize: 12,
                color: AppColors.softCharcoalLight,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Section Content
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Text(
          title,
          style: AppTextStyles.featureHeading.copyWith(
            fontFamily: AppTextStyles.headingFont,
            color: isDangerZone ? AppColors.dustyRose : AppColors.softCharcoal,
          ),
        ),
      ],
    );
  }
}