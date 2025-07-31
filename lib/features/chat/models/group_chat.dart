import 'package:flutter/material.dart';
import 'chat_conversation.dart';
import 'social_battery_status.dart';

/// Group chat roles
enum GroupRole {
  admin,
  moderator,
  member,
}

/// Group chat settings
class GroupSettings {
  const GroupSettings({
    this.isPublic = false,
    this.allowInvites = true,
    this.allowMemberMessages = true,
    this.requireApprovalForJoin = false,
    this.maxMembers = 50,
    this.quietHoursEnabled = false,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  final bool isPublic;
  final bool allowInvites;
  final bool allowMemberMessages;
  final bool requireApprovalForJoin;
  final int maxMembers;
  final bool quietHoursEnabled;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;

  /// Check if currently in quiet hours
  bool get isInQuietHours {
    if (!quietHoursEnabled || quietHoursStart == null || quietHoursEnd == null) {
      return false;
    }

    final now = TimeOfDay.now();
    final start = quietHoursStart!;
    final end = quietHoursEnd!;

    // Handle overnight quiet hours (e.g., 10 PM to 8 AM)
    if (start.hour > end.hour || (start.hour == end.hour && start.minute > end.minute)) {
      return (now.hour > start.hour || 
              (now.hour == start.hour && now.minute >= start.minute)) ||
             (now.hour < end.hour || 
              (now.hour == end.hour && now.minute <= end.minute));
    }

    // Handle same-day quiet hours (e.g., 12 PM to 2 PM)
    return (now.hour > start.hour || 
            (now.hour == start.hour && now.minute >= start.minute)) &&
           (now.hour < end.hour || 
            (now.hour == end.hour && now.minute <= end.minute));
  }

  /// Get quiet hours display text
  String get quietHoursText {
    if (!quietHoursEnabled || quietHoursStart == null || quietHoursEnd == null) {
      return 'Disabled';
    }
    return '${_formatTime(quietHoursStart!)} - ${_formatTime(quietHoursEnd!)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Create a copy with updated values
  GroupSettings copyWith({
    bool? isPublic,
    bool? allowInvites,
    bool? allowMemberMessages,
    bool? requireApprovalForJoin,
    int? maxMembers,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
  }) {
    return GroupSettings(
      isPublic: isPublic ?? this.isPublic,
      allowInvites: allowInvites ?? this.allowInvites,
      allowMemberMessages: allowMemberMessages ?? this.allowMemberMessages,
      requireApprovalForJoin: requireApprovalForJoin ?? this.requireApprovalForJoin,
      maxMembers: maxMembers ?? this.maxMembers,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}

/// Group member with role and permissions
class GroupMember extends ChatParticipant {
  const GroupMember({
    required super.id,
    required super.name,
    required super.avatarColor,
    required this.role,
    required this.joinedAt,
    super.socialBattery,
    super.isOnline,
    super.lastSeen,
    this.canInvite = false,
    this.canManageMembers = false,
    this.canChangeSettings = false,
  });

  final GroupRole role;
  final DateTime joinedAt;
  final bool canInvite;
  final bool canManageMembers;
  final bool canChangeSettings;

  /// Get role display name
  String get roleDisplayName {
    switch (role) {
      case GroupRole.admin:
        return 'Admin';
      case GroupRole.moderator:
        return 'Moderator';
      case GroupRole.member:
        return 'Member';
    }
  }

  /// Get role emoji
  String get roleEmoji {
    switch (role) {
      case GroupRole.admin:
        return '👑';
      case GroupRole.moderator:
        return '⭐';
      case GroupRole.member:
        return '👤';
    }
  }

  /// Check if member is admin
  bool get isAdmin => role == GroupRole.admin;

  /// Check if member is moderator or admin
  bool get isModerator => role == GroupRole.moderator || role == GroupRole.admin;

  /// Check if member can perform administrative actions
  bool get hasAdminPrivileges => isAdmin || canManageMembers || canChangeSettings;

  /// Get join duration text
  String get joinDurationText {
    final now = DateTime.now();
    final difference = now.difference(joinedAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return 'Just joined';
    }
  }

  @override
  GroupMember copyWith({
    String? id,
    String? name,
    Color? avatarColor,
    GroupRole? role,
    DateTime? joinedAt,
    SocialBatteryStatus? socialBattery,
    bool? isOnline,
    DateTime? lastSeen,
    bool? canInvite,
    bool? canManageMembers,
    bool? canChangeSettings,
  }) {
    return GroupMember(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarColor: avatarColor ?? this.avatarColor,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      socialBattery: socialBattery ?? this.socialBattery,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      canInvite: canInvite ?? this.canInvite,
      canManageMembers: canManageMembers ?? this.canManageMembers,
      canChangeSettings: canChangeSettings ?? this.canChangeSettings,
    );
  }
}

/// Extended group chat conversation with group-specific features
class GroupChat extends ChatConversation {
  const GroupChat({
    required super.id,
    required super.name,
    required super.lastMessage,
    required super.updatedAt,
    required this.members,
    required this.createdAt,
    required this.createdBy,
    super.unreadCount = 0,
    super.isPinned = false,
    super.isMuted = false,
    super.avatarEmoji,
    super.avatarColor,
    this.description,
    this.settings = const GroupSettings(),
    this.inviteCode,
  }) : super(
          type: ChatType.group,
          participants: members,
        );

  final List<GroupMember> members;
  final DateTime createdAt;
  final String createdBy;
  final String? description;
  final GroupSettings settings;
  final String? inviteCode;

  @override
  List<GroupMember> get participants => members;

  /// Get admin members
  List<GroupMember> get admins => 
      members.where((m) => m.role == GroupRole.admin).toList();

  /// Get moderator members
  List<GroupMember> get moderators => 
      members.where((m) => m.role == GroupRole.moderator).toList();

  /// Get regular members
  List<GroupMember> get regularMembers => 
      members.where((m) => m.role == GroupRole.member).toList();

  /// Get online members count
  int get onlineCount => members.where((m) => m.isOnline).length;

  /// Get members with social battery info
  List<GroupMember> get membersWithBattery => 
      members.where((m) => m.socialBattery != null).toList();

  /// Get group creation duration text
  String get creationDurationText {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Created $years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Created $months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return 'Created ${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return 'Created today';
    }
  }

  /// Check if group is at member capacity
  bool get isAtCapacity => members.length >= settings.maxMembers;

  /// Get available member slots
  int get availableSlots => settings.maxMembers - members.length;

  /// Check if currently in quiet hours
  @override
  bool get isQuietHours => settings.isInQuietHours;

  /// Get group avatar gradient based on member colors
  @override
  List<Color> get avatarGradient {
    if (avatarColor != null) {
      return [avatarColor!, avatarColor!.withValues(alpha: 0.7)];
    }

    // Use colors from first few members
    if (members.isNotEmpty) {
      final colors = members.take(3).map((m) => m.avatarColor).toList();
      if (colors.length >= 2) {
        return [colors[0], colors[1]];
      } else if (colors.length == 1) {
        return [colors[0], colors[0].withValues(alpha: 0.7)];
      }
    }

    // Default gradient for groups
    return [Colors.purple, Colors.blue];
  }

  /// Get group statistics summary
  Map<String, dynamic> get statistics {
    return {
      'totalMembers': members.length,
      'onlineMembers': onlineCount,
      'admins': admins.length,
      'moderators': moderators.length,
      'membersWithBattery': membersWithBattery.length,
      'averageBatteryLevel': _getAverageBatteryLevel(),
      'createdDaysAgo': DateTime.now().difference(createdAt).inDays,
    };
  }

  SocialBatteryLevel? _getAverageBatteryLevel() {
    final batteriesWithLevel = membersWithBattery
        .where((m) => m.socialBattery != null)
        .toList();

    if (batteriesWithLevel.isEmpty) return null;

    final levelSum = batteriesWithLevel
        .map((m) => m.socialBattery!.level.index)
        .reduce((a, b) => a + b);

    final averageIndex = (levelSum / batteriesWithLevel.length).round();
    return SocialBatteryLevel.values[averageIndex.clamp(0, 2)];
  }

  /// Create a copy with updated values (group-specific)
  GroupChat copyWithGroup({
    String? id,
    String? name,
    List<GroupMember>? members,
    DateTime? createdAt,
    String? createdBy,
    LastMessage? lastMessage,
    DateTime? updatedAt,
    int? unreadCount,
    bool? isPinned,
    bool? isMuted,
    String? avatarEmoji,
    Color? avatarColor,
    String? description,
    GroupSettings? settings,
    String? inviteCode,
  }) {
    return GroupChat(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      avatarColor: avatarColor ?? this.avatarColor,
      description: description ?? this.description,
      settings: settings ?? this.settings,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }

  @override
  String toString() {
    return 'GroupChat('
        'id: $id, '
        'name: $name, '
        'members: ${members.length}, '
        'createdAt: $createdAt'
        ')';
  }
}