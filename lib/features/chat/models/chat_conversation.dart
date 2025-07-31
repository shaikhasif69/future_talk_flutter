import 'package:flutter/material.dart';
import 'social_battery_status.dart';

/// Types of chat conversations
enum ChatType {
  individual,
  group,
}

/// Message status indicators
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
}

/// Last message in a conversation
class LastMessage {
  const LastMessage({
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.senderName,
    required this.status,
    this.isFromMe = false,
  });

  final String content;
  final DateTime timestamp;
  final String senderId;
  final String senderName;
  final MessageStatus status;
  final bool isFromMe;

  /// Get formatted time string
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? 'Yesterday' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get status icon
  String get statusIcon {
    switch (status) {
      case MessageStatus.sending:
        return '⏳';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.read:
        return '✓✓';
    }
  }

  /// Get preview text for chat list
  String get previewText {
    if (content.length > 50) {
      return '${content.substring(0, 50)}...';
    }
    return content;
  }

  /// Create a copy with updated values
  LastMessage copyWith({
    String? content,
    DateTime? timestamp,
    String? senderId,
    String? senderName,
    MessageStatus? status,
    bool? isFromMe,
  }) {
    return LastMessage(
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      status: status ?? this.status,
      isFromMe: isFromMe ?? this.isFromMe,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'senderId': senderId,
      'senderName': senderName,
      'status': status.index,
      'isFromMe': isFromMe,
    };
  }

  /// Create from JSON
  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      status: MessageStatus.values[json['status'] as int],
      isFromMe: json['isFromMe'] as bool? ?? false,
    );
  }
}

/// Individual chat participant
class ChatParticipant {
  const ChatParticipant({
    required this.id,
    required this.name,
    required this.avatarColor,
    this.socialBattery,
    this.isOnline = false,
    this.lastSeen,
  });

  final String id;
  final String name;
  final Color avatarColor;
  final SocialBatteryStatus? socialBattery;
  final bool isOnline;
  final DateTime? lastSeen;

  /// Get avatar initials
  String get initials {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Get online status text
  String get onlineStatusText {
    if (isOnline) return 'Online';
    if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen!);
      if (difference.inDays > 0) {
        return 'Last seen ${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return 'Last seen ${difference.inHours}h ago';
      } else {
        return 'Last seen ${difference.inMinutes}m ago';
      }
    }
    return 'Offline';
  }

  /// Create a copy with updated values
  ChatParticipant copyWith({
    String? id,
    String? name,
    Color? avatarColor,
    SocialBatteryStatus? socialBattery,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return ChatParticipant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarColor: avatarColor ?? this.avatarColor,
      socialBattery: socialBattery ?? this.socialBattery,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}

/// Main chat conversation model
class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.name,
    required this.type,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
    this.avatarEmoji,
    this.avatarColor,
    this.isQuietHours = false,
  });

  final String id;
  final String name;
  final ChatType type;
  final List<ChatParticipant> participants;
  final LastMessage lastMessage;
  final DateTime updatedAt;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final String? avatarEmoji;
  final Color? avatarColor;
  final bool isQuietHours;

  /// Check if this is an individual chat
  bool get isIndividual => type == ChatType.individual;

  /// Check if this is a group chat
  bool get isGroup => type == ChatType.group;

  /// Get the other participant (for individual chats)
  ChatParticipant? get otherParticipant {
    if (isIndividual && participants.isNotEmpty) {
      return participants.first;
    }
    return null;
  }

  /// Get member count for group chats
  int get memberCount => participants.length;

  /// Get member count text
  String get memberCountText {
    if (isIndividual) return '';
    return '$memberCount member${memberCount == 1 ? '' : 's'}';
  }

  /// Check if conversation has unread messages
  bool get hasUnreadMessages => unreadCount > 0;

  /// Get unread count text
  String get unreadCountText {
    if (unreadCount > 99) return '99+';
    return unreadCount.toString();
  }

  /// Get display name for the conversation
  String get displayName {
    if (isIndividual && otherParticipant != null) {
      return otherParticipant!.name;
    }
    return name;
  }

  /// Get avatar gradient colors for individual chats
  List<Color> get avatarGradient {
    if (isIndividual && otherParticipant != null) {
      final baseColor = otherParticipant!.avatarColor;
      return [baseColor, baseColor.withOpacity( 0.7)];
    }
    if (avatarColor != null) {
      return [avatarColor!, avatarColor!.withOpacity( 0.7)];
    }
    // Default gradient
    return [Colors.grey, Colors.grey.withOpacity( 0.7)];
  }

  /// Get social battery status for individual chats
  SocialBatteryStatus? get socialBattery {
    return otherParticipant?.socialBattery;
  }

  /// Check if chat should show gentle notifications
  bool get shouldShowGentleNotifications {
    return isMuted || isQuietHours || 
           (socialBattery?.needsGentleInteraction ?? false);
  }

  /// Get section for grouping (Pinned, Recent, Earlier)
  String get section {
    if (isPinned) return 'Pinned';
    
    final now = DateTime.now();
    final difference = now.difference(updatedAt);
    
    if (difference.inDays == 0) return 'Recent';
    if (difference.inDays < 7) return 'Recent';
    return 'Earlier';
  }

  /// Create a copy with updated values
  ChatConversation copyWith({
    String? id,
    String? name,
    ChatType? type,
    List<ChatParticipant>? participants,
    LastMessage? lastMessage,
    DateTime? updatedAt,
    int? unreadCount,
    bool? isPinned,
    bool? isMuted,
    String? avatarEmoji,
    Color? avatarColor,
    bool? isQuietHours,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      avatarColor: avatarColor ?? this.avatarColor,
      isQuietHours: isQuietHours ?? this.isQuietHours,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'participants': participants.map((p) => {
        'id': p.id,
        'name': p.name,
        'avatarColor': p.avatarColor.toARGB32(),
        'socialBattery': p.socialBattery?.toJson(),
        'isOnline': p.isOnline,
        'lastSeen': p.lastSeen?.toIso8601String(),
      }).toList(),
      'lastMessage': lastMessage.toJson(),
      'updatedAt': updatedAt.toIso8601String(),
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'isMuted': isMuted,
      'avatarEmoji': avatarEmoji,
      'avatarColor': avatarColor?.toARGB32(),
      'isQuietHours': isQuietHours,
    };
  }

  /// Create from JSON
  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ChatType.values[json['type'] as int],
      participants: (json['participants'] as List).map((p) => ChatParticipant(
        id: p['id'] as String,
        name: p['name'] as String,
        avatarColor: Color(p['avatarColor'] as int),
        socialBattery: p['socialBattery'] != null 
            ? SocialBatteryStatus.fromJson(p['socialBattery'] as Map<String, dynamic>)
            : null,
        isOnline: p['isOnline'] as bool? ?? false,
        lastSeen: p['lastSeen'] != null 
            ? DateTime.parse(p['lastSeen'] as String)
            : null,
      )).toList(),
      lastMessage: LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      avatarEmoji: json['avatarEmoji'] as String?,
      avatarColor: json['avatarColor'] != null 
          ? Color(json['avatarColor'] as int)
          : null,
      isQuietHours: json['isQuietHours'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatConversation &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, type, updatedAt);
  }

  @override
  String toString() {
    return 'ChatConversation('
        'id: $id, '
        'name: $name, '
        'type: $type, '
        'unreadCount: $unreadCount, '
        'isPinned: $isPinned'
        ')';
  }
}