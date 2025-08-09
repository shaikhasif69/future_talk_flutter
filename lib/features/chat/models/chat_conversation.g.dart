// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantImpl _$$ParticipantImplFromJson(Map<String, dynamic> json) =>
    _$ParticipantImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      role: $enumDecode(_$ParticipantRoleEnumMap, json['role']),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$$ParticipantImplToJson(_$ParticipantImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'role': _$ParticipantRoleEnumMap[instance.role]!,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

const _$ParticipantRoleEnumMap = {
  ParticipantRole.admin: 'admin',
  ParticipantRole.member: 'member',
};

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      conversationType: $enumDecode(
        _$ConversationTypeEnumMap,
        json['conversationType'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      isArchived: json['isArchived'] as bool? ?? false,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      avatarEmoji: json['avatarEmoji'] as String?,
      isQuietHours: json['isQuietHours'] as bool? ?? false,
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationType': _$ConversationTypeEnumMap[instance.conversationType]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'isArchived': instance.isArchived,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'isPinned': instance.isPinned,
      'isMuted': instance.isMuted,
      'avatarEmoji': instance.avatarEmoji,
      'isQuietHours': instance.isQuietHours,
    };

const _$ConversationTypeEnumMap = {
  ConversationType.direct: 'direct',
  ConversationType.group: 'group',
};
