import 'package:flutter/material.dart';
import '../../chat/models/social_battery_status.dart';

/// Complete profile data model for the user
class ProfileData {
  final String id;
  final String displayName;
  final String username;
  final String bio;
  final String avatarInitials;
  final LinearGradient avatarGradient;
  final SocialBatteryStatus batteryStatus;
  final ProfileStats stats;
  final PremiumFeatures premiumFeatures;
  final List<ProfileFriend> friends;
  final ProfileSettings settings;
  final DateTime lastUpdated;

  const ProfileData({
    required this.id,
    required this.displayName,
    required this.username,
    required this.bio,
    required this.avatarInitials,
    required this.avatarGradient,
    required this.batteryStatus,
    required this.stats,
    required this.premiumFeatures,
    required this.friends,
    required this.settings,
    required this.lastUpdated,
  });

  /// Create a copy with updated values
  ProfileData copyWith({
    String? id,
    String? displayName,
    String? username,
    String? bio,
    String? avatarInitials,
    LinearGradient? avatarGradient,
    SocialBatteryStatus? batteryStatus,
    ProfileStats? stats,
    PremiumFeatures? premiumFeatures,
    List<ProfileFriend>? friends,
    ProfileSettings? settings,
    DateTime? lastUpdated,
  }) {
    return ProfileData(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      avatarGradient: avatarGradient ?? this.avatarGradient,
      batteryStatus: batteryStatus ?? this.batteryStatus,
      stats: stats ?? this.stats,
      premiumFeatures: premiumFeatures ?? this.premiumFeatures,
      friends: friends ?? this.friends,
      settings: settings ?? this.settings,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Create mock profile data for development
  static ProfileData createMockData() {
    return ProfileData(
      id: 'user123',
      displayName: 'Asif Shaikh',
      username: '@asif_thoughtful',
      bio: 'A quiet soul who finds magic in meaningful conversations and future messages ✨',
      avatarInitials: 'AS',
      avatarGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFC8B5D1), Color(0xFFD4A5A5)],
      ),
      batteryStatus: SocialBatteryStatus(
        level: SocialBatteryLevel.energized,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
        message: 'Ready for meaningful conversations',
      ),
      stats: ProfileStats.createMockStats(),
      premiumFeatures: PremiumFeatures.createMockFeatures(),
      friends: ProfileFriend.createMockFriends(),
      settings: ProfileSettings.createDefaultSettings(),
      lastUpdated: DateTime.now(),
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'username': username,
      'bio': bio,
      'avatarInitials': avatarInitials,
      'batteryStatus': batteryStatus.toJson(),
      'stats': stats.toJson(),
      'premiumFeatures': premiumFeatures.toJson(),
      'friends': friends.map((f) => f.toJson()).toList(),
      'settings': settings.toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

/// User's journey statistics
class ProfileStats {
  final int timeCapsulesSent;
  final int booksRead;
  final int dayStreak;
  final int deepChats;
  final int friendsCount;
  final DateTime periodStart;
  final DateTime periodEnd;

  const ProfileStats({
    required this.timeCapsulesSent,
    required this.booksRead,
    required this.dayStreak,
    required this.deepChats,
    required this.friendsCount,
    required this.periodStart,
    required this.periodEnd,
  });

  /// Create mock stats for development
  static ProfileStats createMockStats() {
    final now = DateTime.now();
    return ProfileStats(
      timeCapsulesSent: 18,
      booksRead: 7,
      dayStreak: 12,
      deepChats: 5,
      friendsCount: 8,
      periodStart: DateTime(now.year, now.month, 1),
      periodEnd: now,
    );
  }

  /// Get period description (e.g., "This Month")
  String get periodDescription {
    final now = DateTime.now();
    if (periodStart.year == now.year && periodStart.month == now.month) {
      return 'This Month';
    }
    return 'Last 30 Days';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'timeCapsulesSent': timeCapsulesSent,
      'booksRead': booksRead,
      'dayStreak': dayStreak,
      'deepChats': deepChats,
      'friendsCount': friendsCount,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
    };
  }
}

/// Premium features status and data
class PremiumFeatures {
  final bool isPremium;
  final ConnectionStones connectionStones;
  final ParallelReading parallelReading;
  final PremiumGames premiumGames;
  final DateTime? premiumExpiryDate;

  const PremiumFeatures({
    required this.isPremium,
    required this.connectionStones,
    required this.parallelReading,
    required this.premiumGames,
    this.premiumExpiryDate,
  });

  /// Create mock premium features
  static PremiumFeatures createMockFeatures() {
    return PremiumFeatures(
      isPremium: true,
      connectionStones: ConnectionStones(
        customStones: 3,
        comfortTouchesGiven: 47,
        totalTouchesReceived: 23,
      ),
      parallelReading: ParallelReading(
        currentlyReadingWith: 2,
        booksCompletedTogether: 5,
        readingStreakDays: 8,
      ),
      premiumGames: PremiumGames(
        gamesUnlocked: 12,
        favoriteGame: 'Mindful Word Connect',
        hoursPlayed: 15.5,
      ),
      premiumExpiryDate: DateTime.now().add(const Duration(days: 30)),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'isPremium': isPremium,
      'connectionStones': connectionStones.toJson(),
      'parallelReading': parallelReading.toJson(),
      'premiumGames': premiumGames.toJson(),
      'premiumExpiryDate': premiumExpiryDate?.toIso8601String(),
    };
  }
}

/// Connection Stones feature data
class ConnectionStones {
  final int customStones;
  final int comfortTouchesGiven;
  final int totalTouchesReceived;

  const ConnectionStones({
    required this.customStones,
    required this.comfortTouchesGiven,
    required this.totalTouchesReceived,
  });

  Map<String, dynamic> toJson() {
    return {
      'customStones': customStones,
      'comfortTouchesGiven': comfortTouchesGiven,
      'totalTouchesReceived': totalTouchesReceived,
    };
  }
}

/// Parallel Reading feature data
class ParallelReading {
  final int currentlyReadingWith;
  final int booksCompletedTogether;
  final int readingStreakDays;

  const ParallelReading({
    required this.currentlyReadingWith,
    required this.booksCompletedTogether,
    required this.readingStreakDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentlyReadingWith': currentlyReadingWith,
      'booksCompletedTogether': booksCompletedTogether,
      'readingStreakDays': readingStreakDays,
    };
  }
}

/// Premium Games feature data
class PremiumGames {
  final int gamesUnlocked;
  final String favoriteGame;
  final double hoursPlayed;

  const PremiumGames({
    required this.gamesUnlocked,
    required this.favoriteGame,
    required this.hoursPlayed,
  });

  Map<String, dynamic> toJson() {
    return {
      'gamesUnlocked': gamesUnlocked,
      'favoriteGame': favoriteGame,
      'hoursPlayed': hoursPlayed,
    };
  }
}

/// Friend data for profile preview
class ProfileFriend {
  final String id;
  final String name;
  final String avatarInitials;
  final SocialBatteryLevel batteryLevel;
  final LinearGradient avatarGradient;
  final bool isOnline;

  const ProfileFriend({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.batteryLevel,
    required this.avatarGradient,
    required this.isOnline,
  });

  /// Create mock friends list
  static List<ProfileFriend> createMockFriends() {
    return [
      ProfileFriend(
        id: '1',
        name: 'Sarah',
        avatarInitials: 'S',
        batteryLevel: SocialBatteryLevel.selective,
        avatarGradient: const LinearGradient(
          colors: [Color(0xFFB8D4E3), Color(0xFFF4C2A1)],
        ),
        isOnline: true,
      ),
      ProfileFriend(
        id: '2',
        name: 'Alex',
        avatarInitials: 'A',
        batteryLevel: SocialBatteryLevel.energized,
        avatarGradient: const LinearGradient(
          colors: [Color(0xFF87A96B), Color(0xFFC8B5D1)],
        ),
        isOnline: true,
      ),
      ProfileFriend(
        id: '3',
        name: 'Morgan',
        avatarInitials: 'M',
        batteryLevel: SocialBatteryLevel.recharging,
        avatarGradient: const LinearGradient(
          colors: [Color(0xFFD4A5A5), Color(0xFFF4C2A1)],
        ),
        isOnline: false,
      ),
      ProfileFriend(
        id: '4',
        name: 'Riley',
        avatarInitials: 'R',
        batteryLevel: SocialBatteryLevel.energized,
        avatarGradient: const LinearGradient(
          colors: [Color(0xFFC8B5D1), Color(0xFFB8D4E3)],
        ),
        isOnline: true,
      ),
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarInitials': avatarInitials,
      'batteryLevel': batteryLevel.index,
      'isOnline': isOnline,
    };
  }
}

/// Profile settings and preferences
class ProfileSettings {
  final bool showOnlineStatus;
  final bool allowTimeCapsules;
  final bool enableNotifications;
  final bool shareBatteryStatus;
  final bool premiumNotifications;

  const ProfileSettings({
    required this.showOnlineStatus,
    required this.allowTimeCapsules,
    required this.enableNotifications,
    required this.shareBatteryStatus,
    required this.premiumNotifications,
  });

  /// Create default settings
  static ProfileSettings createDefaultSettings() {
    return const ProfileSettings(
      showOnlineStatus: true,
      allowTimeCapsules: true,
      enableNotifications: true,
      shareBatteryStatus: true,
      premiumNotifications: false,
    );
  }

  ProfileSettings copyWith({
    bool? showOnlineStatus,
    bool? allowTimeCapsules,
    bool? enableNotifications,
    bool? shareBatteryStatus,
    bool? premiumNotifications,
  }) {
    return ProfileSettings(
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowTimeCapsules: allowTimeCapsules ?? this.allowTimeCapsules,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      shareBatteryStatus: shareBatteryStatus ?? this.shareBatteryStatus,
      premiumNotifications: premiumNotifications ?? this.premiumNotifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showOnlineStatus': showOnlineStatus,
      'allowTimeCapsules': allowTimeCapsules,
      'enableNotifications': enableNotifications,
      'shareBatteryStatus': shareBatteryStatus,
      'premiumNotifications': premiumNotifications,
    };
  }
}

/// Profile action items for the actions section
class ProfileAction {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;
  final bool isDestructive;
  final Color? customColor;

  const ProfileAction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
    this.customColor,
  });

  /// Create standard profile actions
  static List<ProfileAction> createStandardActions() {
    return [
      ProfileAction(
        id: 'edit_profile',
        title: 'Edit Profile',
        subtitle: 'Update your display name, bio, and preferences',
        icon: '✎',
        onTap: () {},
      ),
      ProfileAction(
        id: 'activity',
        title: 'Your Activity',
        subtitle: 'Detailed stats and reading analytics',
        icon: '📊',
        onTap: () {},
      ),
      ProfileAction(
        id: 'export_data',
        title: 'Export Data',
        subtitle: 'Download all your Future Talk content',
        icon: '💾',
        onTap: () {},
      ),
      ProfileAction(
        id: 'logout',
        title: 'Logout',
        subtitle: 'Sign out of your account',
        icon: '🚪',
        onTap: () {},
        isDestructive: true,
      ),
    ];
  }
}