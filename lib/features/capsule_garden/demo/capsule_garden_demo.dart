import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routing/app_router.dart';

/// Demo screen to showcase the Capsule Garden Dashboard
/// This can be used for testing and demonstration purposes
class CapsuleGardenDemo extends StatelessWidget {
  const CapsuleGardenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: Text(
          'Capsule Garden Demo',
          style: AppTextStyles.headlineLarge,
        ),
        backgroundColor: AppColors.sageGreen,
        foregroundColor: AppColors.pearlWhite,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.eco,
                size: 120,
                color: AppColors.sageGreen,
              ),
              const SizedBox(height: 32),
              Text(
                'Capsule Garden Dashboard',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.sageGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Experience premium time capsule management with beautiful animations and serene garden aesthetics.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => context.goToCapsuleGarden(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sageGreen,
                  foregroundColor: AppColors.pearlWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Open Garden Dashboard',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.pearlWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.sageGreen,
                  side: const BorderSide(color: AppColors.sageGreen),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Back',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}