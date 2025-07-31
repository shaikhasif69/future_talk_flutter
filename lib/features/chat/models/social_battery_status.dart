import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Social battery levels for introvert-friendly energy awareness
/// Helps users understand each other's communication preferences
enum SocialBatteryLevel {
  /// Green - Ready and energized for conversations
  energized,
  
  /// Yellow - Limited responses, selective engagement  
  selective,
  
  /// Red - Needs space, recharging mode
  recharging,
}

/// Social battery status model with color and display information
class SocialBatteryStatus {
  const SocialBatteryStatus({
    required this.level,
    required this.lastUpdated,
    this.message,
  });

  final SocialBatteryLevel level;
  final DateTime lastUpdated;
  final String? message;

  /// Get the color for this battery level
  Color get color {
    switch (level) {
      case SocialBatteryLevel.energized:
        return AppColors.sageGreen;
      case SocialBatteryLevel.selective:
        return AppColors.warmPeach;
      case SocialBatteryLevel.recharging:
        return AppColors.dustyRose;
    }
  }

  /// Get the display name for this battery level
  String get displayName {
    switch (level) {
      case SocialBatteryLevel.energized:
        return 'Energized';
      case SocialBatteryLevel.selective:
        return 'Selective';
      case SocialBatteryLevel.recharging:
        return 'Recharging';
    }
  }

  /// Get the emoji for this battery level
  String get emoji {
    switch (level) {
      case SocialBatteryLevel.energized:
        return '💚';
      case SocialBatteryLevel.selective:
        return '💛';
      case SocialBatteryLevel.recharging:
        return '❤️';
    }
  }

  /// Get the description for this battery level
  String get description {
    switch (level) {
      case SocialBatteryLevel.energized:
        return 'Ready to chat and engage actively';
      case SocialBatteryLevel.selective:
        return 'Limited responses, selective engagement';
      case SocialBatteryLevel.recharging:
        return 'Needs space, quiet time preferred';
    }
  }

  /// Get the default message for this battery level
  String get defaultMessage {
    return message ?? description;
  }

  /// Check if the battery level indicates availability for chat
  bool get isAvailableForChat {
    return level == SocialBatteryLevel.energized;
  }

  /// Check if the battery level suggests gentle interaction
  bool get needsGentleInteraction {
    return level == SocialBatteryLevel.selective || 
           level == SocialBatteryLevel.recharging;
  }

  /// Get hours since last update
  int get hoursSinceUpdate {
    return DateTime.now().difference(lastUpdated).inHours;
  }

  /// Check if status is recent (updated within last 4 hours)
  bool get isRecent {
    return hoursSinceUpdate < 4;
  }

  /// Create a copy with updated values
  SocialBatteryStatus copyWith({
    SocialBatteryLevel? level,
    DateTime? lastUpdated,
    String? message,
  }) {
    return SocialBatteryStatus(
      level: level ?? this.level,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      message: message ?? this.message,
    );
  }

  /// Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'level': level.index,
      'lastUpdated': lastUpdated.toIso8601String(),
      'message': message,
    };
  }

  /// Create from JSON
  factory SocialBatteryStatus.fromJson(Map<String, dynamic> json) {
    return SocialBatteryStatus(
      level: SocialBatteryLevel.values[json['level'] as int],
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      message: json['message'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SocialBatteryStatus &&
        other.level == level &&
        other.lastUpdated == lastUpdated &&
        other.message == message;
  }

  @override
  int get hashCode {
    return Object.hash(level, lastUpdated, message);
  }

  @override
  String toString() {
    return 'SocialBatteryStatus('
        'level: $level, '
        'lastUpdated: $lastUpdated, '
        'message: $message'
        ')';
  }
}

/// Extension for creating common battery statuses
extension SocialBatteryPresets on SocialBatteryStatus {
  /// Create an energized status
  static SocialBatteryStatus energized({String? message}) {
    return SocialBatteryStatus(
      level: SocialBatteryLevel.energized,
      lastUpdated: DateTime.now(),
      message: message,
    );
  }

  /// Create a selective status
  static SocialBatteryStatus selective({String? message}) {
    return SocialBatteryStatus(
      level: SocialBatteryLevel.selective,
      lastUpdated: DateTime.now(),
      message: message,
    );
  }

  /// Create a recharging status
  static SocialBatteryStatus recharging({String? message}) {
    return SocialBatteryStatus(
      level: SocialBatteryLevel.recharging,
      lastUpdated: DateTime.now(),
      message: message,
    );
  }
}