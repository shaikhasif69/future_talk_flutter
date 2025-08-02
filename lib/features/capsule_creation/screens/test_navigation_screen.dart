import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_button.dart';

/// Simple test screen to navigate to the time capsule creation flow
/// This is temporary for testing the new feature
class TestNavigationScreen extends StatelessWidget {
  const TestNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: Text(
          'Test Navigation',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.pearlWhite,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7F5F3),
              Color(0xFFFEFEFE),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Time Capsule Creation Test',
                  style: AppTextStyles.displayMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppDimensions.spacingL),
                
                Text(
                  'Click below to test the premium time capsule creation flow with pixel-perfect UI matching the HTML design.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppDimensions.spacingXXXL),
                
                FTButton.primary(
                  text: 'Create Time Capsule',
                  onPressed: () {
                    context.go('/capsule/create');
                  },
                  icon: Icons.access_time,
                  width: double.infinity,
                ),
                
                const SizedBox(height: AppDimensions.spacingL),
                
                FTButton.outlined(
                  text: 'Back to Dashboard',
                  onPressed: () {
                    context.go('/dashboard');
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}