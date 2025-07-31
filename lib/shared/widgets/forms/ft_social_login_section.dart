import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../ft_button.dart';
import '../animations/ft_stagger_animation.dart';

/// Reusable social login section widget
/// Provides consistent social login UI across auth screens
class FTSocialLoginSection extends StatelessWidget {
  const FTSocialLoginSection({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.dividerText = 'or continue with',
    this.animationDelay,
  });

  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final String dividerText;
  final Duration? animationDelay;

  @override
  Widget build(BuildContext context) {
    return FTStaggerAnimation(
      delay: animationDelay,
      slideDelay: animationDelay,
      child: Column(
        children: [
          // Divider with text
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.whisperGray)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
                child: Text(
                  dividerText,
                  style: AppTextStyles.labelMedium,
                ),
              ),
              const Expanded(child: Divider(color: AppColors.whisperGray)),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingXL),
          
          // Social login buttons
          Row(
            children: [
              Expanded(
                child: FTButton.outlined(
                  text: 'Google',
                  onPressed: onGooglePressed ?? _defaultGoogleHandler,
                  icon: Icons.g_mobiledata,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: FTButton.outlined(
                  text: 'Apple',
                  onPressed: onApplePressed ?? _defaultAppleHandler,
                  icon: Icons.apple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _defaultGoogleHandler() {
    HapticFeedback.selectionClick();
    // TODO: Implement Google login
  }

  void _defaultAppleHandler() {
    HapticFeedback.selectionClick();
    // TODO: Implement Apple login
  }
}