import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message.dart';
import 'social_battery_status.dart';

part 'chat_conversation.freezed.dart';
part 'chat_conversation.g.dart';

/// Participant model matching API documentation
@freezed
class Participant with _$Participant {
  const factory Participant({
    required String userId, // UUID
    required String username,
    required ParticipantRole role,
    required DateTime joinedAt,
  }) = _Participant;

  /// Create from API participant data with proper null safety
  static Participant fromApiParticipant(Map<String, dynamic> json) {
    // Safe string extraction with null checks and API field mapping
    final String userId = (json['user_id'] as String?) ?? (json['userId'] as String?) ?? '';
    final String username = (json['username'] as String?) ?? (json['display_name'] as String?) ?? 'Unknown User';
    
    // Safe role parsing
    final String roleStr = (json['role'] as String?) ?? 'member';
    final ParticipantRole role = roleStr == 'admin' ? ParticipantRole.admin : ParticipantRole.member;
    
    // Safe date parsing
    final String joinedAtStr = (json['joined_at'] as String?) ?? (json['joinedAt'] as String?) ?? DateTime.now().toIso8601String();
    
    return Participant(
      userId: userId,
      username: username,
      role: role,
      joinedAt: DateTime.parse(joinedAtStr),
    );
  }

  factory Participant.fromJson(Map<String, Object?> json) =>
      _$ParticipantFromJson(json);
}

/// Extended participant for UI purposes
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

/// Main conversation model matching API documentation exactly
@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id, // UUID
    required ConversationType conversationType,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    @Default(false) bool isArchived,
    required List<Participant> participants,
    ChatMessage? lastMessage,
    @Default(0) int unreadCount,
    // Additional UI fields
    @Default(false) bool isPinned,
    @Default(false) bool isMuted,
    String? avatarEmoji,
    @JsonKey(includeFromJson: false, includeToJson: false) Color? avatarColor,
    @Default(false) bool isQuietHours,
  }) = _Conversation;

  const Conversation._();

  /// Check if this is a direct chat
  bool get isDirect => conversationType == ConversationType.direct;

  /// Check if this is a group chat
  bool get isGroup => conversationType == ConversationType.group;

  /// Get the other participant (for direct chats)
  Participant? get otherParticipant {
    if (isDirect && participants.isNotEmpty) {
      return participants.first;
    }
    return null;
  }

  /// Get member count for group chats
  int get memberCount => participants.length;

  /// Get member count text
  String get memberCountText {
    if (isDirect) return '';
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
    if (isDirect && otherParticipant != null) {
      return otherParticipant!.username;
    }
    // For group chats, create name from participants
    return participants.map((p) => p.username).take(3).join(', ');
  }

  /// Get avatar gradient colors for direct chats
  List<Color> get avatarGradient {
    if (avatarColor != null) {
      return [avatarColor!, avatarColor!.withAlpha(179)];
    }
    // Default gradient based on conversation ID
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];
    final index = id.hashCode % colors.length;
    final baseColor = colors[index.abs()];
    return [baseColor, baseColor.withAlpha(179)];
  }

  /// Check if chat should show gentle notifications
  bool get shouldShowGentleNotifications {
    return isMuted || isQuietHours;
  }

  /// Get section for grouping (Pinned, Recent, Earlier)
  String get section {
    if (isPinned) return 'Pinned';
    
    final now = DateTime.now();
    final difference = now.difference(lastMessageAt);
    
    if (difference.inDays == 0) return 'Recent';
    if (difference.inDays < 7) return 'Recent';
    return 'Earlier';
  }

  /// Create from API conversation data
  static Conversation fromApiConversation(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    // Safe string extraction with null checks
    final String id = (json['id'] as String?) ?? '';
    final String conversationTypeStr = (json['conversation_type'] as String?) ?? 'direct';
    final String createdAtStr = (json['created_at'] as String?) ?? DateTime.now().toIso8601String();
    final String lastMessageAtStr = (json['last_message_at'] as String?) ?? DateTime.now().toIso8601String();
    
    // Safe list extraction
    final List<dynamic> participantsList = (json['participants'] as List<dynamic>?) ?? [];
    
    return Conversation(
      id: id,
      conversationType: conversationTypeStr == 'direct'
          ? ConversationType.direct
          : ConversationType.group,
      createdAt: DateTime.parse(createdAtStr),
      lastMessageAt: DateTime.parse(lastMessageAtStr),
      isArchived: json['is_archived'] as bool? ?? false,
      participants: participantsList
          .map((p) => Participant.fromApiParticipant(p as Map<String, dynamic>))
          .toList(),
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromApiMessage(
              json['last_message'] as Map<String, dynamic>,
              currentUserId,
            )
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  factory Conversation.fromJson(Map<String, Object?> json) =>
      _$ConversationFromJson(json);
}

/// Extended conversation for UI purposes (maintains backward compatibility)
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
  final ConversationType type;
  final List<ChatParticipant> participants;
  final ChatMessage? lastMessage;
  final DateTime updatedAt;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final String? avatarEmoji;
  final Color? avatarColor;
  final bool isQuietHours;

  /// Check if this is a direct chat
  bool get isDirect => type == ConversationType.direct;

  /// Check if this is a group chat
  bool get isGroup => type == ConversationType.group;

  /// Get the other participant (for direct chats)
  ChatParticipant? get otherParticipant {
    if (isDirect && participants.isNotEmpty) {
      return participants.first;
    }
    return null;
  }

  /// Get member count for group chats
  int get memberCount => participants.length;

  /// Get member count text
  String get memberCountText {
    if (isDirect) return '';
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
    if (isDirect && otherParticipant != null) {
      return otherParticipant!.name;
    }
    return name;
  }

  /// Get avatar gradient colors for direct chats
  List<Color> get avatarGradient {
    if (isDirect && otherParticipant != null) {
      final baseColor = otherParticipant!.avatarColor;
      return [baseColor, baseColor.withAlpha(179)];
    }
    if (avatarColor != null) {
      return [avatarColor!, avatarColor!.withAlpha(179)];
    }
    // Default gradient
    return [Colors.grey, Colors.grey.withAlpha(179)];
  }

  /// Get social battery status for direct chats
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

  /// Create from new Conversation model
  factory ChatConversation.fromConversation(
    Conversation conversation, {
    List<ChatParticipant>? chatParticipants,
  }) {
    return ChatConversation(
      id: conversation.id,
      name: conversation.displayName,
      type: conversation.conversationType,
      participants: chatParticipants ?? [],
      lastMessage: conversation.lastMessage,
      updatedAt: conversation.lastMessageAt,
      unreadCount: conversation.unreadCount,
      isPinned: conversation.isPinned,
      isMuted: conversation.isMuted,
      avatarEmoji: conversation.avatarEmoji,
      avatarColor: conversation.avatarColor,
      isQuietHours: conversation.isQuietHours,
    );
  }

  /// Create a copy with updated values
  ChatConversation copyWith({
    String? id,
    String? name,
    ConversationType? type,
    List<ChatParticipant>? participants,
    ChatMessage? lastMessage,
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

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'participants': participants.map((p) => {
        'id': p.id,
        'name': p.name,
        'avatarColor': p.avatarColor.toARGB32(),
        'isOnline': p.isOnline,
        'lastSeen': p.lastSeen?.toIso8601String(),
      }).toList(),
      'lastMessage': lastMessage?.toJson(),
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
      type: ConversationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ConversationType.direct,
      ),
      participants: (json['participants'] as List<dynamic>?)?.map((p) => 
        ChatParticipant(
          id: p['id'] as String,
          name: p['name'] as String,
          avatarColor: Color(p['avatarColor'] as int),
          isOnline: p['isOnline'] as bool? ?? false,
          lastSeen: p['lastSeen'] != null ? DateTime.parse(p['lastSeen'] as String) : null,
        )
      ).toList() ?? [],
      lastMessage: json['lastMessage'] != null ? 
        ChatMessage.fromJson(json['lastMessage'] as Map<String, dynamic>) : null,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      avatarEmoji: json['avatarEmoji'] as String?,
      avatarColor: json['avatarColor'] != null ? Color(json['avatarColor'] as int) : null,
      isQuietHours: json['isQuietHours'] as bool? ?? false,
    );
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