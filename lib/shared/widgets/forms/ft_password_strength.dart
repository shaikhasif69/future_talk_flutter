import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

/// Reusable password strength indicator widget
/// Shows visual strength indicator with color-coded feedback
class FTPasswordStrength extends StatelessWidget {
  const FTPasswordStrength({
    super.key,
    required this.password,
    this.showStrengthText = true,
    this.height = 4.0,
    this.borderRadius = 2.0,
  });

  final String password;
  final bool showStrengthText;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength(password);
    final strengthData = _getStrengthData(strength);

    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: AppColors.whisperGray,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: strength / 5.0,
              child: Container(
                decoration: BoxDecoration(
                  color: strengthData.color,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
        ),
        if (showStrengthText) ...[
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            strengthData.text,
            style: AppTextStyles.labelSmall.copyWith(
              color: strengthData.color,
            ),
          ),
        ],
      ],
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    
    return strength;
  }

  _PasswordStrengthData _getStrengthData(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return _PasswordStrengthData(
          text: 'Very Weak',
          color: AppColors.dustyRose,
        );
      case 2:
        return _PasswordStrengthData(
          text: 'Weak',
          color: AppColors.dustyRose,
        );
      case 3:
        return _PasswordStrengthData(
          text: 'Fair',
          color: AppColors.warmPeach,
        );
      case 4:
        return _PasswordStrengthData(
          text: 'Good',
          color: AppColors.cloudBlue,
        );
      case 5:
        return _PasswordStrengthData(
          text: 'Strong',
          color: AppColors.sageGreen,
        );
      default:
        return _PasswordStrengthData(
          text: 'Very Weak',
          color: AppColors.dustyRose,
        );
    }
  }
}

/// Helper class for password strength data
class _PasswordStrengthData {
  const _PasswordStrengthData({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;
}