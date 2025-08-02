import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

/// Data model for friends in the friend selection flow
/// Represents a user's friend with their social status and activity
@freezed
class Friend with _$Friend {
  const factory Friend({
    /// Unique identifier for the friend
    required String id,
    
    /// Friend's display name
    required String name,
    
    /// Friend's avatar URL or identifier
    required String avatar,
    
    /// Friend's current social battery status
    required SocialBatteryLevel socialBattery,
    
    /// When the friend was last active
    required DateTime lastActive,
    
    /// Optional username for search
    String? username,
    
    /// Whether this friend is currently online
    @Default(false) bool isOnline,
    
    /// Friend's preferred communication method
    @Default(FriendCommunicationPreference.app) FriendCommunicationPreference communicationPreference,
    
    /// Whether this friend has enabled capsule notifications
    @Default(true) bool allowsCapsuleNotifications,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) =>
      _$FriendFromJson(json);
}

/// Social battery levels for friends
enum SocialBatteryLevel {
  @JsonValue('green')
  green,
  
  @JsonValue('yellow')
  yellow,
  
  @JsonValue('red')
  red,
}

/// Extension for social battery properties
extension SocialBatteryLevelExtension on SocialBatteryLevel {
  /// Display text for the battery level
  String get displayText {
    switch (this) {
      case SocialBatteryLevel.green:
        return 'Green';
      case SocialBatteryLevel.yellow:
        return 'Yellow';
      case SocialBatteryLevel.red:
        return 'Red';
    }
  }
  
  /// Full description of the battery level
  String get description {
    switch (this) {
      case SocialBatteryLevel.green:
        return 'Social battery: Green';
      case SocialBatteryLevel.yellow:
        return 'Social battery: Yellow';
      case SocialBatteryLevel.red:
        return 'Social battery: Red';
    }
  }
  
  /// Color representation for UI
  String get colorHex {
    switch (this) {
      case SocialBatteryLevel.green:
        return '#4CAF50';
      case SocialBatteryLevel.yellow:
        return '#FFC107';
      case SocialBatteryLevel.red:
        return '#F44336';
    }
  }
  
  /// CSS class name from HTML design
  String get cssClass {
    switch (this) {
      case SocialBatteryLevel.green:
        return 'battery-green';
      case SocialBatteryLevel.yellow:
        return 'battery-yellow';
      case SocialBatteryLevel.red:
        return 'battery-red';
    }
  }
  
  /// Whether this battery level suggests the friend is available
  bool get isAvailable {
    switch (this) {
      case SocialBatteryLevel.green:
        return true;
      case SocialBatteryLevel.yellow:
        return true;
      case SocialBatteryLevel.red:
        return false;
    }
  }
}

/// Friend's preferred communication methods
enum FriendCommunicationPreference {
  @JsonValue('app')
  app,
  
  @JsonValue('email')
  email,
  
  @JsonValue('both')
  both,
}

/// Extension for communication preference properties
extension FriendCommunicationPreferenceExtension on FriendCommunicationPreference {
  /// Display text for the preference
  String get displayText {
    switch (this) {
      case FriendCommunicationPreference.app:
        return 'App Only';
      case FriendCommunicationPreference.email:
        return 'Email Only';
      case FriendCommunicationPreference.both:
        return 'App + Email';
    }
  }
  
  /// Icon for the preference
  String get icon {
    switch (this) {
      case FriendCommunicationPreference.app:
        return '📱';
      case FriendCommunicationPreference.email:
        return '📧';
      case FriendCommunicationPreference.both:
        return '📱📧';
    }
  }
}

/// Extension for Friend model with additional utility methods
extension FriendExtension on Friend {
  /// Get the display text for last active time
  String get lastActiveDisplay {
    final now = DateTime.now();
    final difference = now.difference(lastActive);
    
    if (isOnline) {
      return 'online now';
    }
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days day${days == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    }
  }
  
  /// Get avatar initials for display
  String get avatarInitials {
    if (name.isEmpty) return '?';
    
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    } else {
      return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
    }
  }
  
  /// Generate gradient colors for avatar based on name
  List<String> get avatarGradientColors {
    final hash = name.hashCode;
    final colorSets = [
      ['#D4A5A5', '#F4C2A1'], // Pink to peach
      ['#87A96B', '#A4B88A'], // Green gradient
      ['#C8B5D1', '#B8D4E3'], // Purple to blue
      ['#F4C2A1', '#D4A5A5'], // Peach to pink
      ['#B8D4E3', '#C8B5D1'], // Blue to purple
      ['#A4B88A', '#87A96B'], // Light green to green
    ];
    
    final index = hash.abs() % colorSets.length;
    return colorSets[index];
  }
  
  /// Check if friend matches search query
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final lowercaseQuery = query.toLowerCase();
    final lowercaseName = name.toLowerCase();
    final lowercaseUsername = username?.toLowerCase() ?? '';
    
    return lowercaseName.contains(lowercaseQuery) || 
           lowercaseUsername.contains(lowercaseQuery);
  }
  
  /// Check if this friend is suitable for time capsule delivery
  bool get isSuitableForTimeCapsule {
    return allowsCapsuleNotifications && socialBattery.isAvailable;
  }
  
  /// Get recommendation message for this friend
  String get recommendationMessage {
    if (!allowsCapsuleNotifications) {
      return 'This friend has disabled capsule notifications';
    }
    
    switch (socialBattery) {
      case SocialBatteryLevel.green:
        return 'Perfect timing! They\'re feeling social';
      case SocialBatteryLevel.yellow:
        return 'They might appreciate a thoughtful message';
      case SocialBatteryLevel.red:
        return 'Consider waiting for a better moment';
    }
  }
}

/// Demo data for friend selection
class FriendDemoData {
  static List<Friend> get demoFriends => [
    Friend(
      id: 'sarah_miller',
      name: 'Sarah Miller',
      avatar: 'sarah_avatar',
      socialBattery: SocialBatteryLevel.green,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      username: 'sarah.m',
      isOnline: false,
      communicationPreference: FriendCommunicationPreference.both,
      allowsCapsuleNotifications: true,
    ),
    Friend(
      id: 'alex_johnson',
      name: 'Alex Johnson',
      avatar: 'alex_avatar',
      socialBattery: SocialBatteryLevel.yellow,
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
      username: 'alex.j',
      isOnline: false,
      communicationPreference: FriendCommunicationPreference.app,
      allowsCapsuleNotifications: true,
    ),
    Friend(
      id: 'maya_chen',
      name: 'Maya Chen',
      avatar: 'maya_avatar',
      socialBattery: SocialBatteryLevel.green,
      lastActive: DateTime.now(),
      username: 'maya.c',
      isOnline: true,
      communicationPreference: FriendCommunicationPreference.both,
      allowsCapsuleNotifications: true,
    ),
    Friend(
      id: 'riley_park',
      name: 'Riley Park',
      avatar: 'riley_avatar',
      socialBattery: SocialBatteryLevel.red,
      lastActive: DateTime.now().subtract(const Duration(hours: 3)),
      username: 'riley.p',
      isOnline: false,
      communicationPreference: FriendCommunicationPreference.email,
      allowsCapsuleNotifications: true,
    ),
    Friend(
      id: 'jamie_rodriguez',
      name: 'Jamie Rodriguez',
      avatar: 'jamie_avatar',
      socialBattery: SocialBatteryLevel.green,
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
      username: 'jamie.r',
      isOnline: false,
      communicationPreference: FriendCommunicationPreference.both,
      allowsCapsuleNotifications: true,
    ),
  ];
  
  /// Get a specific friend by ID
  static Friend? getFriendById(String id) {
    try {
      return demoFriends.firstWhere((friend) => friend.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Search friends by query
  static List<Friend> searchFriends(String query) {
    return demoFriends.where((friend) => friend.matchesSearch(query)).toList();
  }
}