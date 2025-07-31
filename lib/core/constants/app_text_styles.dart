import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Future Talk's Premium Typography System
/// Based on carefully selected Google Fonts for introvert-friendly communication
/// 
/// Font Usage:
/// - Source Serif Pro: Primary UI, Navigation, Settings
/// - Crimson Pro: Personal messages, Time capsules, Reading content
/// - Playfair Display: Elegant headings, Connection Stones, Special moments
/// - Lora: Book reading, Long content, Parallel reading
class AppTextStyles {
  AppTextStyles._();

  // ==================== FONT FAMILIES ====================
  /// Primary UI font - Source Serif 4 (warm professional)
  static String get primaryFont => GoogleFonts.sourceSerif4().fontFamily!;
  
  /// Personal content font - Crimson Pro (intimate messages)
  static String get personalFont => GoogleFonts.crimsonPro().fontFamily!;
  
  /// Elegant headings font - Playfair Display (special moments)
  static String get headingFont => GoogleFonts.playfairDisplay().fontFamily!;
  
  /// Reading content font - Lora (books & long content)
  static String get readingFont => GoogleFonts.lora().fontFamily!;

  // ==================== DISPLAY STYLES ====================
  
  /// Large display text - App titles, major headings (Playfair Display)
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.softCharcoal,
  );
  
  /// Medium display text - Section titles (Playfair Display)
  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.3,
    color: AppColors.softCharcoal,
  );
  
  /// Small display text - Subsection titles (Playfair Display)
  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.softCharcoal,
  );

  // ==================== HEADLINE STYLES ====================
  
  /// Large headlines - Screen titles (Playfair Display)
  static TextStyle get headlineLarge => GoogleFonts.playfairDisplay(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );
  
  /// Medium headlines - Card titles (Source Serif Pro)
  static TextStyle get headlineMedium => GoogleFonts.sourceSerif4(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );
  
  /// Small headlines - Component titles (Source Serif Pro)
  static TextStyle get headlineSmall => GoogleFonts.sourceSerif4(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );

  // ==================== TITLE STYLES ====================
  
  /// Large titles - Important labels (Source Serif Pro)
  static TextStyle get titleLarge => GoogleFonts.sourceSerif4(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.softCharcoal,
  );
  
  /// Medium titles - Form labels, button text (Source Serif Pro)
  static TextStyle get titleMedium => GoogleFonts.sourceSerif4(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.1,
    color: AppColors.softCharcoal,
  );
  
  /// Small titles - Small labels (Source Serif Pro)
  static TextStyle get titleSmall => GoogleFonts.sourceSerif4(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.4,
    color: AppColors.softCharcoal,
  );

  // ==================== BODY STYLES ====================
  
  /// Large body text - Main content (Source Serif Pro)
  static TextStyle get bodyLarge => GoogleFonts.sourceSerif4(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );
  
  /// Medium body text - Default UI text (Source Serif Pro)
  static TextStyle get bodyMedium => GoogleFonts.sourceSerif4(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.1,
    color: AppColors.softCharcoal,
  );
  
  /// Small body text - Secondary content (Source Serif Pro)
  static TextStyle get bodySmall => GoogleFonts.sourceSerif4(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.2,
    color: AppColors.softCharcoalLight,
  );

  // ==================== LABEL STYLES ====================
  
  /// Large labels - Input hints, important notes (Source Serif Pro)
  static TextStyle get labelLarge => GoogleFonts.sourceSerif4(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0.1,
    color: AppColors.softCharcoalLight,
  );
  
  /// Medium labels - Form hints (Source Serif Pro)
  static TextStyle get labelMedium => GoogleFonts.sourceSerif4(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
    color: AppColors.softCharcoalLight,
  );
  
  /// Small labels - Tiny text, timestamps (Source Serif Pro)
  static TextStyle get labelSmall => GoogleFonts.sourceSerif4(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.5,
    color: AppColors.softCharcoalLight,
  );

  // ==================== SPECIAL STYLES ====================
  
  /// Button text style (Source Serif Pro)
  static TextStyle get button => GoogleFonts.sourceSerif4(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.1,
    color: AppColors.pearlWhite,
  );
  
  /// Link text style (Source Serif Pro)
  static TextStyle get link => GoogleFonts.sourceSerif4(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.1,
    color: AppColors.sageGreen,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.sageGreen,
  );
  
  /// Caption text style - Used for subtle text (Source Serif Pro)
  static TextStyle get caption => GoogleFonts.sourceSerif4(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.3,
    color: AppColors.softCharcoalLight,
  );
  
  /// Error text style (Source Serif Pro)
  static TextStyle get error => GoogleFonts.sourceSerif4(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.2,
    color: AppColors.dustyRose,
  );
  
  /// Success text style (Source Serif Pro)
  static TextStyle get success => GoogleFonts.sourceSerif4(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.2,
    color: AppColors.warmPeach,
  );

  // ==================== BRANDED STYLES ====================
  
  /// App logo text style (Playfair Display)
  static TextStyle get logoText => GoogleFonts.playfairDisplay(
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.softCharcoal,
  );
  
  /// App tagline style (Crimson Pro)
  static TextStyle get tagline => GoogleFonts.crimsonPro(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.0,
    fontStyle: FontStyle.italic,
    color: AppColors.softCharcoalLight,
  );
  
  /// Welcome message style (Source Serif Pro)
  static TextStyle get welcomeMessage => GoogleFonts.sourceSerif4(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );

  // ==================== CONTENT-SPECIFIC STYLES ====================
  
  /// Personal message content - Time Capsules, Personal messages (Crimson Pro)
  static TextStyle get personalContent => GoogleFonts.crimsonPro(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.0,
    fontStyle: FontStyle.italic,
    color: AppColors.softCharcoal,
  );
  
  /// Reading content - Books, articles, long text (Lora)
  static TextStyle get readingContent => GoogleFonts.lora(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );
  
  /// Connection Stones titles (Playfair Display)
  static TextStyle get connectionStoneTitle => GoogleFonts.playfairDisplay(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.0,
    color: AppColors.sageGreen,
  );
  
  /// Feature headings - Premium features (Playfair Display)
  static TextStyle get featureHeading => GoogleFonts.playfairDisplay(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.0,
    color: AppColors.softCharcoal,
  );
  
  /// Navigation items (Source Serif Pro)
  static TextStyle get navigationItem => GoogleFonts.sourceSerif4(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.softCharcoal,
  );
  
  /// Settings labels (Source Serif Pro)
  static TextStyle get settingsLabel => GoogleFonts.sourceSerif4(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.1,
    color: AppColors.softCharcoal,
  );
  
  /// Time capsule preview text (Crimson Pro)
  static TextStyle get timeCapsulePreview => GoogleFonts.crimsonPro(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.0,
    fontStyle: FontStyle.italic,
    color: AppColors.softCharcoalLight,
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
  
  /// Personal content in sage green
  static TextStyle get personalContentAccent => personalContent.copyWith(
    color: AppColors.sageGreen,
  );
  
  /// Connection stone title in warm peach
  static TextStyle get connectionStoneTitleWarm => connectionStoneTitle.copyWith(
    color: AppColors.warmPeach,
  );
  
  /// Reading content in lavender mist
  static TextStyle get readingContentAccent => readingContent.copyWith(
    color: AppColors.lavenderMist,
  );
}