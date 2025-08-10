import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';

class SignOutModal extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SignOutModal({
    super.key,
    required this.onConfirm,
    required onCancel,
  }) : onCancel = onCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: AppColors.pearlWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.softCharcoal.withAlpha(26),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.dustyRose.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '👋',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: AppDurations.medium,
                    curve: Curves.elasticOut,
                  ),
              
              const SizedBox(height: AppDimensions.spacingXL),
              
              // Title
              Text(
                'Sign Out?',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.softCharcoal,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: 100.ms)
                  .fadeIn(duration: AppDurations.medium)
                  .slideY(begin: 0.3, end: 0.0, duration: AppDurations.medium),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              // Description
              Text(
                'Are you sure you want to sign out of your Future Talk account?',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.softCharcoalLight,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: AppDurations.medium)
                  .slideY(begin: 0.3, end: 0.0, duration: AppDurations.medium),
              
              const SizedBox(height: AppDimensions.spacingXXL),
              
              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        onCancel();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.softCharcoal,
                        side: BorderSide(
                          color: AppColors.stoneGray.withAlpha(128),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingL,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: AppDurations.medium)
                      .slideY(begin: 0.5, end: 0.0, duration: AppDurations.medium),
                  
                  const SizedBox(width: AppDimensions.spacingM),
                  
                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dustyRose,
                        foregroundColor: AppColors.pearlWhite,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingL,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                        ),
                      ),
                      child: Text(
                        'Sign Out',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: AppDurations.medium)
                      .slideY(begin: 0.5, end: 0.0, duration: AppDurations.medium),
                ],
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: AppDurations.medium)
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: AppDurations.medium,
            curve: Curves.elasticOut,
          ),
    );
  }

  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.softCharcoal.withAlpha(128),
      builder: (BuildContext context) {
        return SignOutModal(
          onConfirm: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
    );
  }
}