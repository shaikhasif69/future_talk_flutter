import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/time_capsule_creation_data.dart';
import '../providers/time_capsule_creation_provider.dart';

/// Context card showing the selected recipient/purpose
/// Matches the HTML selection context design
class SelectionContextCard extends ConsumerWidget {
  const SelectionContextCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPurpose = ref.watch(selectedPurposeProvider);
    
    if (selectedPurpose == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.spacingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
        vertical: AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.sageGreenWithOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: const Border(
          left: BorderSide(
            color: AppColors.sageGreen,
            width: 4.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Purpose emoji
          Text(
            selectedPurpose.emoji,
            style: const TextStyle(fontSize: 16),
          ),
          
          const SizedBox(width: AppDimensions.spacingS),
          
          // Context text
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.softCharcoal,
                ),
                children: [
                  const TextSpan(text: 'Message to: '),
                  TextSpan(
                    text: selectedPurpose.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.softCharcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}