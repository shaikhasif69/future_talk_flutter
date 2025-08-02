import 'package:flutter/services.dart';
import '../models/touch_interaction_model.dart';
import '../models/stone_type.dart';

/// Service for managing haptic feedback patterns for connection stones
/// Provides rich tactile experiences that enhance emotional connection
class HapticFeedbackService {
  HapticFeedbackService._();
  
  /// Singleton instance
  static final HapticFeedbackService _instance = HapticFeedbackService._();
  static HapticFeedbackService get instance => _instance;

  /// Play haptic feedback for stone touch
  Future<void> playStoneTouch(StoneType stoneType, TouchType touchType) async {
    try {
      // Get the custom pattern for this stone type
      final pattern = stoneType.hapticPattern;
      
      // Adjust pattern based on touch type
      final adjustedPattern = _adjustPatternForTouchType(pattern, touchType);
      
      // Play the pattern
      await HapticFeedback.vibrate();
      
      // For Android devices, use custom pattern if available
      if (adjustedPattern.isNotEmpty) {
        await _playCustomPattern(adjustedPattern);
      }
    } catch (e) {
      // Fallback to simple vibration if custom patterns fail
      await HapticFeedback.lightImpact();
    }
  }

  /// Play haptic feedback for receiving comfort
  Future<void> playReceiveComfort(StoneType stoneType) async {
    try {
      // Gentle, welcoming pattern for receiving comfort
      const pattern = [200, 100, 200, 100, 200];
      await _playCustomPattern(pattern);
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Play haptic feedback for quick touch
  Future<void> playQuickTouch() async {
    try {
      await HapticFeedback.lightImpact();
      // Add a slight delay and second pulse for richness
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.lightImpact();
    } catch (e) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Play haptic feedback for long press
  Future<void> playLongPress(StoneType stoneType) async {
    try {
      // Start with medium impact
      await HapticFeedback.mediumImpact();
      
      // Follow with the stone's custom pattern
      final pattern = stoneType.hapticPattern;
      await _playCustomPattern(pattern);
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Play haptic feedback for creating a new stone
  Future<void> playStoneCreation() async {
    try {
      // Magical creation pattern
      const pattern = [100, 50, 150, 50, 200, 50, 250];
      await _playCustomPattern(pattern);
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Play haptic feedback for stone connection established
  Future<void> playConnectionEstablished() async {
    try {
      // Heart-like rhythm pattern
      const pattern = [150, 100, 150, 200, 250, 100, 250];
      await _playCustomPattern(pattern);
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Play haptic feedback for navigation or UI interactions
  Future<void> playUIFeedback() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Silent fail for UI feedback
    }
  }

  /// Play error haptic feedback
  Future<void> playError() async {
    try {
      // Sharp, attention-getting pattern
      const pattern = [50, 50, 50, 50, 50];
      await _playCustomPattern(pattern);
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Play success haptic feedback
  Future<void> playSuccess() async {
    try {
      // Celebratory pattern
      const pattern = [100, 50, 150, 50, 200, 100, 300];
      await _playCustomPattern(pattern);
    } catch (e) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Adjust haptic pattern based on touch type
  List<int> _adjustPatternForTouchType(List<int> basePattern, TouchType touchType) {
    switch (touchType) {
      case TouchType.quickTouch:
        // Make pattern shorter and lighter
        return basePattern.map((duration) => (duration * 0.7).round()).take(3).toList();
      
      case TouchType.longPress:
        // Keep full pattern with emphasis
        return basePattern.map((duration) => (duration * 1.2).round()).toList();
      
      case TouchType.doubleTap:
        // Double the pattern with a gap
        return [...basePattern, 200, ...basePattern];
      
      case TouchType.heartTouch:
        // Heart rhythm pattern
        return [150, 100, 150, 300, 200, 100, 200];
    }
  }

  /// Play a custom vibration pattern
  Future<void> _playCustomPattern(List<int> pattern) async {
    for (int i = 0; i < pattern.length; i++) {
      if (i % 2 == 0) {
        // Even indices are vibration durations
        await HapticFeedback.lightImpact();
        await Future.delayed(Duration(milliseconds: pattern[i]));
      } else {
        // Odd indices are pause durations
        await Future.delayed(Duration(milliseconds: pattern[i]));
      }
    }
  }

  /// Check if device supports haptic feedback
  bool get isHapticAvailable {
    // This is a simplified check - in a real app you might want more sophisticated detection
    return true;
  }

  /// Get haptic intensity based on stone connection strength
  HapticIntensity getIntensityForConnection(double connectionStrength) {
    if (connectionStrength >= 0.8) {
      return HapticIntensity.strong;
    } else if (connectionStrength >= 0.5) {
      return HapticIntensity.medium;
    } else {
      return HapticIntensity.light;
    }
  }
}

/// Haptic feedback intensity levels
enum HapticIntensity {
  light,
  medium,
  strong,
}

/// Extension for haptic intensity to get corresponding Flutter feedback
extension HapticIntensityExtension on HapticIntensity {
  Future<void> play() async {
    switch (this) {
      case HapticIntensity.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticIntensity.medium:
        await HapticFeedback.mediumImpact();
        break;
      case HapticIntensity.strong:
        await HapticFeedback.heavyImpact();
        break;
    }
  }
}