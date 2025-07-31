import 'package:flutter/material.dart';
import 'friend_status.dart';

/// Represents the complete dashboard state and data
class DashboardData {
  final String userName;
  final String greeting;
  final String subtitle;
  final SocialBatteryLevel userBatteryLevel;
  final List<FriendStatus> friends;
  final List<RecentActivity> recentActivities;
  final List<QuickAction> quickActions;
  final int unreadNotifications;
  final DateTime lastUpdated;

  const DashboardData({
    required this.userName,
    required this.greeting,
    required this.subtitle,
    required this.userBatteryLevel,
    required this.friends,
    required this.recentActivities,
    required this.quickActions,
    this.unreadNotifications = 0,
    required this.lastUpdated,
  });

  /// Create a copy with updated values
  DashboardData copyWith({
    String? userName,
    String? greeting,
    String? subtitle,
    SocialBatteryLevel? userBatteryLevel,
    List<FriendStatus>? friends,
    List<RecentActivity>? recentActivities,
    List<QuickAction>? quickActions,
    int? unreadNotifications,
    DateTime? lastUpdated,
  }) {
    return DashboardData(
      userName: userName ?? this.userName,
      greeting: greeting ?? this.greeting,
      subtitle: subtitle ?? this.subtitle,
      userBatteryLevel: userBatteryLevel ?? this.userBatteryLevel,
      friends: friends ?? this.friends,
      recentActivities: recentActivities ?? this.recentActivities,
      quickActions: quickActions ?? this.quickActions,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Get personalized greeting based on time of day
  static String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  /// Create mock dashboard data for development/testing
  static DashboardData createMockData() {
    return DashboardData(
      userName: 'Alex',
      greeting: getTimeBasedGreeting(),
      subtitle: 'Your sanctuary awaits',
      userBatteryLevel: SocialBatteryLevel.energized,
      friends: _createMockFriends(),
      recentActivities: _createMockActivities(),
      quickActions: _createMockQuickActions(),
      unreadNotifications: 2,
      lastUpdated: DateTime.now(),
    );
  }

  static List<FriendStatus> _createMockFriends() {
    return [
      FriendStatus(
        id: '1',
        name: 'Sarah Chen',
        avatarInitial: 'S',
        batteryLevel: SocialBatteryLevel.energized,
        statusMessage: 'Ready to chat',
        lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
        isOnline: true,
        avatarGradientStart: const Color(0xFF87A96B),
        avatarGradientEnd: const Color(0xFFC8B5D1),
      ),
      FriendStatus(
        id: '2',
        name: 'Morgan Kim',
        avatarInitial: 'M',
        batteryLevel: SocialBatteryLevel.selective,
        statusMessage: 'Selective responses',
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
        isOnline: false,
        avatarGradientStart: const Color(0xFFD4A5A5),
        avatarGradientEnd: const Color(0xFFF4C2A1),
      ),
      FriendStatus(
        id: '3',
        name: 'Jamie Rivera',
        avatarInitial: 'J',
        batteryLevel: SocialBatteryLevel.recharging,
        statusMessage: 'Quietly recharging',
        lastActive: DateTime.now().subtract(const Duration(hours: 3)),
        isOnline: false,
        avatarGradientStart: const Color(0xFFB8D4E3),
        avatarGradientEnd: const Color(0xFFC8B5D1),
      ),
    ];
  }

  static List<RecentActivity> _createMockActivities() {
    return [
      RecentActivity(
        id: '1',
        type: ActivityType.timeCapsule,
        title: 'Time capsule delivered to Sarah',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        icon: '💌',
        iconBackgroundGradient: const LinearGradient(
          colors: [Color(0xFFC8B5D1), Color(0xFFB8D4E3)],
        ),
      ),
      RecentActivity(
        id: '2',
        type: ActivityType.touchStone,
        title: 'Morgan touched your comfort stone',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        icon: '🪨',
        iconBackgroundGradient: const LinearGradient(
          colors: [Color(0xFFD4A5A5), Color(0xFFF4C2A1)],
        ),
      ),
      RecentActivity(
        id: '3',
        type: ActivityType.readTogether,
        title: 'Reading session with Jamie started',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        icon: '📖',
        iconBackgroundGradient: const LinearGradient(
          colors: [Color(0xFFC8B5D1), Color(0xFFB8D4E3)],
        ),
      ),
    ];
  }

  static List<QuickAction> _createMockQuickActions() {
    return [
      QuickAction(
        id: '1',
        title: 'Time Capsule',
        subtitle: 'Send to future',
        icon: '💌',
        isPremium: false,
        onTap: () {},
      ),
      QuickAction(
        id: '2',
        title: 'Start Chat',
        subtitle: 'Gentle conversation',
        icon: '💬',
        isPremium: false,
        onTap: () {},
      ),
      QuickAction(
        id: '3',
        title: 'Touch Stone',
        subtitle: 'Connect hearts',
        icon: '🪨',
        isPremium: true,
        onTap: () {},
      ),
      QuickAction(
        id: '4',
        title: 'Read Together',
        subtitle: 'Sync reading',
        icon: '📚',
        isPremium: true,
        onTap: () {},
      ),
    ];
  }
}

/// Represents a recent activity item
class RecentActivity {
  final String id;
  final ActivityType type;
  final String title;
  final DateTime timestamp;
  final String icon;
  final LinearGradient iconBackgroundGradient;
  final String? subtitle;
  final VoidCallback? onTap;

  const RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.timestamp,
    required this.icon,
    required this.iconBackgroundGradient,
    this.subtitle,
    this.onTap,
  });

  /// Get relative time string (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${difference.inDays ~/ 7} weeks ago';
    }
  }
}

/// Types of activities that can appear in the recent activity feed
enum ActivityType {
  timeCapsule,
  touchStone,
  readTogether,
  chat,
  friendAdded,
  batteryChanged,
}

/// Represents a quick action card
class QuickAction {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final bool isPremium;
  final VoidCallback onTap;
  final Color? customColor;
  final bool isEnabled;

  const QuickAction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isPremium,
    required this.onTap,
    this.customColor,
    this.isEnabled = true,
  });

  /// Create a copy with updated values
  QuickAction copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? icon,
    bool? isPremium,
    VoidCallback? onTap,
    Color? customColor,
    bool? isEnabled,
  }) {
    return QuickAction(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      isPremium: isPremium ?? this.isPremium,
      onTap: onTap ?? this.onTap,
      customColor: customColor ?? this.customColor,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}