import 'package:flutter/material.dart';

/// Enum representing different types of connection stones
/// Each stone type has unique visual properties and emotional associations
enum StoneType {
  roseQuartz,
  clearQuartz,
  amethyst,
  oceanWave,
  cherryBlossom,
  sunstone,
  moonstone,
  lavenderJade,
}

/// Extension for StoneType to provide visual and emotional properties
extension StoneTypeProperties on StoneType {
  /// The display name of the stone
  String get displayName {
    switch (this) {
      case StoneType.roseQuartz:
        return 'Rose Quartz';
      case StoneType.clearQuartz:
        return 'Clear Quartz';
      case StoneType.amethyst:
        return 'Amethyst';
      case StoneType.oceanWave:
        return 'Ocean Wave';
      case StoneType.cherryBlossom:
        return 'Cherry Blossom';
      case StoneType.sunstone:
        return 'Sunstone';
      case StoneType.moonstone:
        return 'Moonstone';
      case StoneType.lavenderJade:
        return 'Lavender Jade';
    }
  }

  /// The emoji representation of the stone
  String get emoji {
    switch (this) {
      case StoneType.roseQuartz:
        return '💎';
      case StoneType.clearQuartz:
        return '🔮';
      case StoneType.amethyst:
        return '💜';
      case StoneType.oceanWave:
        return '🌊';
      case StoneType.cherryBlossom:
        return '🌸';
      case StoneType.sunstone:
        return '☀️';
      case StoneType.moonstone:
        return '🌙';
      case StoneType.lavenderJade:
        return '💚';
    }
  }

  /// The gradient colors for the stone's visual representation
  List<Color> get gradientColors {
    switch (this) {
      case StoneType.roseQuartz:
        return [const Color(0xFF87A96B), const Color(0xFFA4B88A)]; // Sage green theme
      case StoneType.clearQuartz:
        return [const Color(0xFFF7F5F3), const Color(0xFFE9ECEF)]; // Warm cream theme
      case StoneType.amethyst:
        return [const Color(0xFFC8B5D1), const Color(0xFFDCC9E2)]; // Keep lavender for variety
      case StoneType.oceanWave:
        return [const Color(0xFFB8D4E3), const Color(0xFFD4E6F1)]; // Keep blue for ocean theme
      case StoneType.cherryBlossom:
        return [const Color(0xFF87A96B), const Color(0xFFA4B88A)]; // Sage green theme
      case StoneType.sunstone:
        return [const Color(0xFFF4C2A1), const Color(0xFFFBE8DC)]; // Keep warm peach
      case StoneType.moonstone:
        return [const Color(0xFFE6E6FA), const Color(0xFFF0F8FF)]; // Keep light theme
      case StoneType.lavenderJade:
        return [const Color(0xFF7A9761), const Color(0xFF87A96B)]; // Darker sage green variant
    }
  }

  /// The primary color of the stone (first gradient color)
  Color get primaryColor => gradientColors.first;

  /// The secondary color of the stone (second gradient color)
  Color get secondaryColor => gradientColors.last;

  /// Emotional associations and meanings
  String get meaning {
    switch (this) {
      case StoneType.roseQuartz:
        return 'Love & Compassion';
      case StoneType.clearQuartz:
        return 'Clarity & Peace';
      case StoneType.amethyst:
        return 'Wisdom & Calm';
      case StoneType.oceanWave:
        return 'Flow & Serenity';
      case StoneType.cherryBlossom:
        return 'Beauty & Renewal';
      case StoneType.sunstone:
        return 'Warmth & Joy';
      case StoneType.moonstone:
        return 'Intuition & Dreams';
      case StoneType.lavenderJade:
        return 'Growth & Harmony';
    }
  }

  /// Description for the stone's emotional purpose
  String get description {
    switch (this) {
      case StoneType.roseQuartz:
        return 'Send gentle love and emotional healing to your friend';
      case StoneType.clearQuartz:
        return 'Share moments of clarity and peaceful understanding';
      case StoneType.amethyst:
        return 'Offer wisdom and calming presence during difficult times';
      case StoneType.oceanWave:
        return 'Flow with emotions and bring serenity to your connection';
      case StoneType.cherryBlossom:
        return 'Celebrate beautiful moments and fresh beginnings together';
      case StoneType.sunstone:
        return 'Brighten their day with warmth and joyful energy';
      case StoneType.moonstone:
        return 'Connect through dreams and intuitive understanding';
      case StoneType.lavenderJade:
        return 'Nurture growth and create harmonious bonds';
    }
  }

  /// Create a gradient for the stone
  Gradient get gradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradientColors,
      stops: const [0.0, 1.0],
    );
  }

  /// Get receiving glow effect color (brighter version of primary color)
  Color get glowColor {
    return primaryColor.withAlpha(204);
  }

  /// Get the touch ripple color
  Color get rippleColor {
    return primaryColor.withAlpha(153);
  }

  /// Haptic feedback pattern for this stone type
  List<int> get hapticPattern {
    switch (this) {
      case StoneType.roseQuartz:
        return [150, 100, 150, 100, 150]; // Gentle heart-like pattern
      case StoneType.clearQuartz:
        return [200, 50, 200]; // Clear, precise pulses
      case StoneType.amethyst:
        return [100, 150, 100, 150, 100]; // Wise, thoughtful pattern
      case StoneType.oceanWave:
        return [300, 100, 200, 100, 100]; // Wave-like rhythm
      case StoneType.cherryBlossom:
        return [80, 80, 80, 80, 80]; // Light, delicate touches
      case StoneType.sunstone:
        return [250, 150, 250]; // Warm, energetic pulses
      case StoneType.moonstone:
        return [150, 200, 150, 200]; // Dreamy, flowing pattern
      case StoneType.lavenderJade:
        return [120, 120, 120, 120]; // Balanced, harmonious pattern
    }
  }
}