import 'package:flutter/material.dart';

/// Future Talk's complete color palette
/// Designed for introverts with calming, warm tones
class AppColors {
  AppColors._();

  // ==================== PRIMARY COLORS ====================
  
  /// Sage Green - Main brand color for buttons, active states, progress bars
  static const Color sageGreen = Color(0xFF87A96B);
  
  /// Sage Green hover state
  static const Color sageGreenHover = Color(0xFF7A9761);
  
  /// Sage Green light variant
  static const Color sageGreenLight = Color(0xFFA4B88A);
  
  /// Warm Cream - Main backgrounds, cards, inputs
  static const Color warmCream = Color(0xFFF7F5F3);
  
  /// Warm Cream alternative shade
  static const Color warmCreamAlt = Color(0xFFFAF8F6);
  
  /// Soft Charcoal - Primary text, headers
  static const Color softCharcoal = Color(0xFF4A4A4A);
  
  /// Soft Charcoal light variant for secondary text
  static const Color softCharcoalLight = Color(0xFF6B6B6B);

  // ==================== SECONDARY/ACCENT COLORS ====================
  
  /// Dusty Rose - Delete, urgent, love features
  static const Color dustyRose = Color(0xFFD4A5A5);
  
  /// Dusty Rose hover state
  static const Color dustyRoseHover = Color(0xFFC79999);
  
  /// Dusty Rose light background
  static const Color dustyRoseLight = Color(0xFFF2E6E6);
  
  /// Lavender Mist - Premium badges, magic elements
  static const Color lavenderMist = Color(0xFFC8B5D1);
  
  /// Lavender Mist hover state
  static const Color lavenderMistHover = Color(0xFFBCA8C7);
  
  /// Lavender Mist light background
  static const Color lavenderMistLight = Color(0xFFE8DFF0);
  
  /// Warm Peach - Success, achievements, positive states
  static const Color warmPeach = Color(0xFFF4C2A1);
  
  /// Warm Peach hover state
  static const Color warmPeachHover = Color(0xFFF0B894);
  
  /// Warm Peach light background
  static const Color warmPeachLight = Color(0xFFFBE8DC);
  
  /// Cloud Blue - Info, communication, trust
  static const Color cloudBlue = Color(0xFFB8D4E3);
  
  /// Cloud Blue hover state
  static const Color cloudBlueHover = Color(0xFFA8C8D9);
  
  /// Cloud Blue light background
  static const Color cloudBlueLight = Color(0xFFE4F1F7);

  // ==================== NEUTRALS ====================
  
  /// Pearl White - Modals, clean areas
  static const Color pearlWhite = Color(0xFFFEFEFE);
  
  /// Whisper Gray - Dividers, borders
  static const Color whisperGray = Color(0xFFF0F0F0);
  
  /// Stone Gray - Disabled states
  static const Color stoneGray = Color(0xFFD1D1D1);

  // ==================== SEMANTIC COLORS ====================
  
  /// Success color (using warm peach)
  static const Color success = warmPeach;
  static const Color successHover = warmPeachHover;
  static const Color successLight = warmPeachLight;
  
  /// Warning color (using sage green light)
  static const Color warning = sageGreenLight;
  
  /// Error color (using dusty rose)
  static const Color error = dustyRose;
  static const Color errorHover = dustyRoseHover;
  static const Color errorLight = dustyRoseLight;
  
  /// Info color (using cloud blue)
  static const Color info = cloudBlue;
  static const Color infoHover = cloudBlueHover;
  static const Color infoLight = cloudBlueLight;

  // ==================== GRADIENTS ====================
  
  /// Primary gradient (Sage to Lavender)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sageGreen, lavenderMist],
  );
  
  /// Background gradient (Warm Cream to Sage)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [warmCream, sageGreenLight],
    stops: [0.0, 1.0],
  );
  
  /// Card gradient (subtle)
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warmCream, warmCreamAlt],
  );
  
  /// Loading gradient
  static const LinearGradient loadingGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [sageGreen, lavenderMist],
  );

  // ==================== OPACITY VARIANTS ====================
  
  /// Sage Green with opacity variations
  static Color sageGreenWithOpacity(double opacity) => 
      sageGreen.withOpacity( opacity);
  
  /// Soft Charcoal with opacity variations
  static Color softCharcoalWithOpacity(double opacity) => 
      softCharcoal.withOpacity( opacity);
  
  /// Common opacity values
  static const double opacityHigh = 0.87;
  static const double opacityMedium = 0.60;
  static const double opacityLow = 0.38;
  static const double opacityDisabled = 0.12;

  // ==================== SHADOW COLORS ====================
  
  /// Subtle shadow for cards
  static Color get cardShadow => softCharcoal.withOpacity( 0.08);
  
  /// Button shadow
  static Color get buttonShadow => sageGreen.withOpacity( 0.25);
  
  /// Modal shadow
  static Color get modalShadow => softCharcoal.withOpacity( 0.15);
}