import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/time_capsule_creation_data.dart';

/// Context bar showing recipient and time selection from previous steps
/// Displays "To: Future Me • In: 6 Months" format with dynamic content
class ContextBarWidget extends StatelessWidget {
  final TimeCapsulePurpose? purpose;
  final String timeDisplay;
  final String timeMetaphor;

  const ContextBarWidget({
    super.key,
    required this.purpose,
    required this.timeDisplay,
    required this.timeMetaphor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softCharcoalWithOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recipient section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.sageGreenWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getPurposeEmoji(),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  'To: ${_getPurposeDisplayText()}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sageGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
            child: Text(
              '•',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.softCharcoalWithOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),
          
          // Time section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.warmPeach.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeMetaphor,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  'In: $timeDisplay',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warmPeach,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPurposeEmoji() {
    return purpose?.emoji ?? '📝';
  }

  String _getPurposeDisplayText() {
    return purpose?.title ?? 'Someone';
  }
}