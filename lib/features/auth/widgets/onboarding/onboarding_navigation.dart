import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/ft_button.dart';
import '../../../../shared/widgets/indicators/ft_page_indicator.dart';

/// Onboarding navigation component with indicators and buttons
class OnboardingNavigation extends StatelessWidget {
  const OnboardingNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNextPressed,
    required this.onSkipPressed,
    this.nextButtonText,
    this.finalButtonText = 'Get Started',
    this.finalButtonIcon = Icons.rocket_launch,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onNextPressed;
  final VoidCallback onSkipPressed;
  final String? nextButtonText;
  final String finalButtonText;
  final IconData finalButtonIcon;

  bool get isLastPage => currentPage == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        children: [
          // Page indicators
          FTPageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
          ),
          
          const SizedBox(height: AppDimensions.spacingXXL),
          
          // Next/Get Started button
          SizedBox(
            width: double.infinity,
            child: FTButton.primary(
              text: isLastPage 
                  ? finalButtonText 
                  : (nextButtonText ?? 'Next'),
              onPressed: () {
                HapticFeedback.selectionClick();
                onNextPressed();
              },
              icon: isLastPage ? finalButtonIcon : Icons.arrow_forward,
              iconPosition: FTButtonIconPosition.right,
            ),
          ),
        ],
      ),
    );
  }
}

/// Onboarding top bar with logo and skip button
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({
    super.key,
    required this.onSkipPressed,
    this.showLogo = true,
    this.skipButtonText = 'Skip',
  });

  final VoidCallback onSkipPressed;
  final bool showLogo;
  final String skipButtonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo/Brand
          if (showLogo)
            Container(
              width: AppDimensions.logoSmall,
              height: AppDimensions.logoSmall,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: const Icon(
                Icons.message_rounded,
                color: AppColors.pearlWhite,
                size: 24.0,
              ),
            )
          else
            const SizedBox.shrink(),
          
          // Skip button
          FTButton.text(
            text: skipButtonText,
            onPressed: () {
              HapticFeedback.lightImpact();
              onSkipPressed();
            },
            size: FTButtonSize.small,
          ),
        ],
      ),
    );
  }
}