// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoiceMessageImpl _$$VoiceMessageImplFromJson(Map<String, dynamic> json) =>
    _$VoiceMessageImpl(
      audioUrl: json['audioUrl'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      isPlaying: json['isPlaying'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      waveformData: json['waveformData'] as String?,
    );

Map<String, dynamic> _$$VoiceMessageImplToJson(_$VoiceMessageImpl instance) =>
    <String, dynamic>{
      'audioUrl': instance.audioUrl,
      'duration': instance.duration.inMicroseconds,
      'isPlaying': instance.isPlaying,
      'progress': instance.progress,
      'waveformData': instance.waveformData,
    };

_$ImageMessageImpl _$$ImageMessageImplFromJson(Map<String, dynamic> json) =>
    _$ImageMessageImpl(
      imageUrl: json['imageUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ImageMessageImplToJson(_$ImageMessageImpl instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'caption': instance.caption,
      'width': instance.width,
      'height': instance.height,
    };

_$ConnectionStoneMessageImpl _$$ConnectionStoneMessageImplFromJson(
  Map<String, dynamic> json,
) => _$ConnectionStoneMessageImpl(
  stoneType: json['stoneType'] as String,
  emotion: json['emotion'] as String,
  message: json['message'] as String? ?? '',
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$$ConnectionStoneMessageImplToJson(
  _$ConnectionStoneMessageImpl instance,
) => <String, dynamic>{
  'stoneType': instance.stoneType,
  'emotion': instance.emotion,
  'message': instance.message,
  'timestamp': instance.timestamp?.toIso8601String(),
};

_$MessageReactionImpl _$$MessageReactionImplFromJson(
  Map<String, dynamic> json,
) => _$MessageReactionImpl(
  id: json['id'] as String,
  emoji: json['emoji'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  isFromMe: json['isFromMe'] as bool? ?? false,
);

Map<String, dynamic> _$$MessageReactionImplToJson(
  _$MessageReactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'emoji': instance.emoji,
  'userId': instance.userId,
  'userName': instance.userName,
  'timestamp': instance.timestamp.toIso8601String(),
  'isFromMe': instance.isFromMe,
};

_$SelfDestructMessageImpl _$$SelfDestructMessageImplFromJson(
  Map<String, dynamic> json,
) => _$SelfDestructMessageImpl(
  countdown: Duration(microseconds: (json['countdown'] as num).toInt()),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isExpired: json['isExpired'] as bool? ?? false,
);

Map<String, dynamic> _$$SelfDestructMessageImplToJson(
  _$SelfDestructMessageImpl instance,
) => <String, dynamic>{
  'countdown': instance.countdown.inMicroseconds,
  'createdAt': instance.createdAt.toIso8601String(),
  'isExpired': instance.isExpired,
};

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      conversationId: json['conversationId'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: $enumDecode(_$MessageStatusEnumMap, json['status']),
      content: json['content'] as String? ?? '',
      reactions:
          (json['reactions'] as List<dynamic>?)
              ?.map((e) => MessageReaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isFromMe: json['isFromMe'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      replyToMessageId: json['replyToMessageId'] as String?,
      voiceMessage: json['voiceMessage'] == null
          ? null
          : VoiceMessage.fromJson(json['voiceMessage'] as Map<String, dynamic>),
      imageMessage: json['imageMessage'] == null
          ? null
          : ImageMessage.fromJson(json['imageMessage'] as Map<String, dynamic>),
      connectionStone: json['connectionStone'] == null
          ? null
          : ConnectionStoneMessage.fromJson(
              json['connectionStone'] as Map<String, dynamic>,
            ),
      selfDestruct: json['selfDestruct'] == null
          ? null
          : SelfDestructMessage.fromJson(
              json['selfDestruct'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'conversationId': instance.conversationId,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': _$MessageStatusEnumMap[instance.status]!,
      'content': instance.content,
      'reactions': instance.reactions,
      'isFromMe': instance.isFromMe,
      'isEdited': instance.isEdited,
      'editedAt': instance.editedAt?.toIso8601String(),
      'replyToMessageId': instance.replyToMessageId,
      'voiceMessage': instance.voiceMessage,
      'imageMessage': instance.imageMessage,
      'connectionStone': instance.connectionStone,
      'selfDestruct': instance.selfDestruct,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.voice: 'voice',
  MessageType.image: 'image',
  MessageType.file: 'file',
  MessageType.connectionStone: 'connectionStone',
  MessageType.selfDestruct: 'selfDestruct',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};

_$MessageDraftImpl _$$MessageDraftImplFromJson(Map<String, dynamic> json) =>
    _$MessageDraftImpl(
      content: json['content'] as String? ?? '',
      type:
          $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.text,
      replyToMessageId: json['replyToMessageId'] as String?,
      voiceMessage: json['voiceMessage'] == null
          ? null
          : VoiceMessage.fromJson(json['voiceMessage'] as Map<String, dynamic>),
      imageMessage: json['imageMessage'] == null
          ? null
          : ImageMessage.fromJson(json['imageMessage'] as Map<String, dynamic>),
      isSelfDestruct: json['isSelfDestruct'] as bool? ?? false,
      selfDestructDuration: json['selfDestructDuration'] == null
          ? null
          : Duration(
              microseconds: (json['selfDestructDuration'] as num).toInt(),
            ),
    );

Map<String, dynamic> _$$MessageDraftImplToJson(_$MessageDraftImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'replyToMessageId': instance.replyToMessageId,
      'voiceMessage': instance.voiceMessage,
      'imageMessage': instance.imageMessage,
      'isSelfDestruct': instance.isSelfDestruct,
      'selfDestructDuration': instance.selfDestructDuration?.inMicroseconds,
    };

_$TypingIndicatorImpl _$$TypingIndicatorImplFromJson(
  Map<String, dynamic> json,
) => _$TypingIndicatorImpl(
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  isActive: json['isActive'] as bool? ?? false,
);

Map<String, dynamic> _$$TypingIndicatorImplToJson(
  _$TypingIndicatorImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'startedAt': instance.startedAt.toIso8601String(),
  'isActive': instance.isActive,
};

_$ReadReceiptImpl _$$ReadReceiptImplFromJson(Map<String, dynamic> json) =>
    _$ReadReceiptImpl(
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      readAt: DateTime.parse(json['readAt'] as String),
    );

Map<String, dynamic> _$$ReadReceiptImplToJson(_$ReadReceiptImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'userId': instance.userId,
      'userName': instance.userName,
      'readAt': instance.readAt.toIso8601String(),
    };
