import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Future Talk's typography system
/// Designed for comfortable reading with warm, welcoming feel
class AppTextStyles {
  AppTextStyles._();

  // ==================== FONT FAMILIES ====================
  static const String primaryFont = 'Inter';
  static const String secondaryFont = 'Nunito Sans';

  // ==================== DISPLAY STYLES ====================
  
  /// Large display text - App titles, major headings
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.softCharcoal,
  );
  
  /// Medium display text - Section titles
  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.3,
    color: AppColors.softCharcoal,
  );
  
  /// Small display text - Subsection titles
  static const TextStyle displaySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.softCharcoal,
  );

  // ==================== HEADLINE STYLES ====================
  
  /// Large headlines - Screen titles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );
  
  /// Medium headlines - Card titles
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );
  
  /// Small headlines - Component titles
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );

  // ==================== TITLE STYLES ====================
  
  /// Large titles - Important labels
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.softCharcoal,
  );
  
  /// Medium titles - Form labels, button text
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.1,
    color: AppColors.softCharcoal,
  );
  
  /// Small titles - Small labels
  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.4,
    color: AppColors.softCharcoal,
  );

  // ==================== BODY STYLES ====================
  
  /// Large body text - Main content
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );
  
  /// Medium body text - Default text
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.1,
    color: AppColors.softCharcoal,
  );
  
  /// Small body text - Secondary content
  static const TextStyle bodySmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.2,
    color: AppColors.softCharcoalLight,
  );

  // ==================== LABEL STYLES ====================
  
  /// Large labels - Input hints, important notes
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0.1,
    color: AppColors.softCharcoalLight,
  );
  
  /// Medium labels - Form hints
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
    color: AppColors.softCharcoalLight,
  );
  
  /// Small labels - Tiny text, timestamps
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.5,
    color: AppColors.softCharcoalLight,
  );

  // ==================== SPECIAL STYLES ====================
  
  /// Button text style
  static const TextStyle button = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.1,
    color: AppColors.pearlWhite,
  );
  
  /// Link text style
  static const TextStyle link = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.1,
    color: AppColors.sageGreen,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.sageGreen,
  );
  
  /// Caption text style - Used for subtle text
  static const TextStyle caption = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.3,
    color: AppColors.softCharcoalLight,
  );
  
  /// Error text style
  static const TextStyle error = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.2,
    color: AppColors.dustyRose,
  );
  
  /// Success text style
  static const TextStyle success = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.2,
    color: AppColors.warmPeach,
  );

  // ==================== BRANDED STYLES ====================
  
  /// App logo text style
  static const TextStyle logoText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.softCharcoal,
  );
  
  /// App tagline style
  static const TextStyle tagline = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.0,
    color: AppColors.softCharcoalLight,
  );
  
  /// Welcome message style
  static const TextStyle welcomeMessage = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );

  // ==================== RESPONSIVE HELPERS ====================
  
  /// Scale text size based on screen width
  static double getResponsiveFontSize(double baseFontSize, double screenWidth) {
    if (screenWidth < 375) {
      return baseFontSize * 0.9; // Smaller devices
    } else if (screenWidth > 414) {
      return baseFontSize * 1.05; // Larger devices
    }
    return baseFontSize; // Standard devices
  }
  
  /// Get scaled text style for responsive design
  static TextStyle getResponsiveStyle(TextStyle baseStyle, double screenWidth) {
    return baseStyle.copyWith(
      fontSize: getResponsiveFontSize(baseStyle.fontSize ?? 14.0, screenWidth),
    );
  }

  // ==================== COLOR VARIANTS ====================
  
  /// Get any text style with custom color
  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }
  
  /// Common color variants
  static TextStyle get bodyMediumLight => bodyMedium.copyWith(
    color: AppColors.softCharcoalLight,
  );
  
  static TextStyle get titleMediumPrimary => titleMedium.copyWith(
    color: AppColors.sageGreen,
  );
  
  static TextStyle get labelMediumError => labelMedium.copyWith(
    color: AppColors.dustyRose,
  );
}