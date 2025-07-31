import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Represents a friend's current status and social battery level
class FriendStatus {
  final String id;
  final String name;
  final String avatarInitial;
  final SocialBatteryLevel batteryLevel;
  final String statusMessage;
  final DateTime lastActive;
  final bool isOnline;
  final Color avatarGradientStart;
  final Color avatarGradientEnd;

  const FriendStatus({
    required this.id,
    required this.name,
    required this.avatarInitial,
    required this.batteryLevel,
    required this.statusMessage,
    required this.lastActive,
    this.isOnline = false,
    this.avatarGradientStart = AppColors.sageGreen,
    this.avatarGradientEnd = AppColors.lavenderMist,
  });

  /// Get the appropriate color for the battery indicator
  Color get batteryColor {
    switch (batteryLevel) {
      case SocialBatteryLevel.energized:
        return AppColors.sageGreen;
      case SocialBatteryLevel.selective:
        return AppColors.warmPeach;
      case SocialBatteryLevel.recharging:
        return AppColors.dustyRose;
    }
  }

  /// Get the status message based on battery level
  String get displayStatusMessage {
    if (statusMessage.isNotEmpty) return statusMessage;
    
    switch (batteryLevel) {
      case SocialBatteryLevel.energized:
        return 'Ready to chat';
      case SocialBatteryLevel.selective:
        return 'Selective responses';
      case SocialBatteryLevel.recharging:
        return 'Quietly recharging';
    }
  }

  /// Create a copy with updated values
  FriendStatus copyWith({
    String? id,
    String? name,
    String? avatarInitial,
    SocialBatteryLevel? batteryLevel,
    String? statusMessage,
    DateTime? lastActive,
    bool? isOnline,
    Color? avatarGradientStart,
    Color? avatarGradientEnd,
  }) {
    return FriendStatus(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarInitial: avatarInitial ?? this.avatarInitial,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      statusMessage: statusMessage ?? this.statusMessage,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
      avatarGradientStart: avatarGradientStart ?? this.avatarGradientStart,
      avatarGradientEnd: avatarGradientEnd ?? this.avatarGradientEnd,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FriendStatus && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Social battery levels that represent energy for social interaction
enum SocialBatteryLevel {
  energized,   // Green - Ready for social interaction
  selective,   // Yellow - Selective about interactions
  recharging,  // Red - Need alone time to recharge
}

/// Extension to get display properties for social battery levels
extension SocialBatteryLevelExtension on SocialBatteryLevel {
  /// Get the color associated with this battery level
  Color get color {
    switch (this) {
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
    switch (this) {
      case SocialBatteryLevel.energized:
        return 'Energized';
      case SocialBatteryLevel.selective:
        return 'Selective';
      case SocialBatteryLevel.recharging:
        return 'Recharging';
    }
  }

  /// Get the icon for this battery level
  String get icon {
    switch (this) {
      case SocialBatteryLevel.energized:
        return '🟢';
      case SocialBatteryLevel.selective:
        return '🟡';
      case SocialBatteryLevel.recharging:
        return '🔴';
    }
  }

  /// Get the status message for this battery level
  String get statusMessage {
    switch (this) {
      case SocialBatteryLevel.energized:
        return 'Ready';
      case SocialBatteryLevel.selective:
        return 'Selective';
      case SocialBatteryLevel.recharging:
        return 'Recharging';
    }
  }
}