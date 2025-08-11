// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentImpl _$$AttachmentImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentImpl(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileType: json['fileType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
    );

Map<String, dynamic> _$$AttachmentImplToJson(_$AttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'fileType': instance.fileType,
      'fileSize': instance.fileSize,
    };

_$ReactionImpl _$$ReactionImplFromJson(Map<String, dynamic> json) =>
    _$ReactionImpl(
      userId: json['userId'] as String,
      emoji: json['emoji'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ReactionImplToJson(_$ReactionImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'emoji': instance.emoji,
      'createdAt': instance.createdAt.toIso8601String(),
    };

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
        Map<String, dynamic> json) =>
    _$ConnectionStoneMessageImpl(
      stoneType: json['stoneType'] as String,
      emotion: json['emotion'] as String,
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ConnectionStoneMessageImplToJson(
        _$ConnectionStoneMessageImpl instance) =>
    <String, dynamic>{
      'stoneType': instance.stoneType,
      'emotion': instance.emotion,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

_$MessageReactionImpl _$$MessageReactionImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageReactionImpl(
      id: json['id'] as String,
      emoji: json['emoji'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFromMe: json['isFromMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageReactionImplToJson(
        _$MessageReactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'emoji': instance.emoji,
      'userId': instance.userId,
      'userName': instance.userName,
      'timestamp': instance.timestamp.toIso8601String(),
      'isFromMe': instance.isFromMe,
    };

_$SelfDestructMessageImpl _$$SelfDestructMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$SelfDestructMessageImpl(
      countdown: Duration(microseconds: (json['countdown'] as num).toInt()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isExpired: json['isExpired'] as bool? ?? false,
    );

Map<String, dynamic> _$$SelfDestructMessageImplToJson(
        _$SelfDestructMessageImpl instance) =>
    <String, dynamic>{
      'countdown': instance.countdown.inMicroseconds,
      'createdAt': instance.createdAt.toIso8601String(),
      'isExpired': instance.isExpired,
    };

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderUsername: json['senderUsername'] as String,
      content: json['content'] as String,
      messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      isEdited: json['isEdited'] as bool? ?? false,
      isDestroyed: json['isDestroyed'] as bool? ?? false,
      replyToMessageId: json['replyToMessageId'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      readBy: (json['readBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deliveredTo: (json['deliveredTo'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      selfDestructAt: json['selfDestructAt'] == null
          ? null
          : DateTime.parse(json['selfDestructAt'] as String),
      encrypted: json['encrypted'] as bool? ?? true,
      encryptionType: json['encryptionType'] as String?,
      securityLevel: json['securityLevel'] as String?,
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      isFromMe: json['isFromMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'senderUsername': instance.senderUsername,
      'content': instance.content,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'editedAt': instance.editedAt?.toIso8601String(),
      'isEdited': instance.isEdited,
      'isDestroyed': instance.isDestroyed,
      'replyToMessageId': instance.replyToMessageId,
      'attachments': instance.attachments,
      'reactions': instance.reactions,
      'readBy': instance.readBy,
      'deliveredTo': instance.deliveredTo,
      'selfDestructAt': instance.selfDestructAt?.toIso8601String(),
      'encrypted': instance.encrypted,
      'encryptionType': instance.encryptionType,
      'securityLevel': instance.securityLevel,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'isFromMe': instance.isFromMe,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.voice: 'voice',
  MessageType.video: 'video',
  MessageType.image: 'image',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
  MessageStatus.received: 'received',
};

_$MessageDraftImpl _$$MessageDraftImplFromJson(Map<String, dynamic> json) =>
    _$MessageDraftImpl(
      content: json['content'] as String? ?? '',
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
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
              microseconds: (json['selfDestructDuration'] as num).toInt()),
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
        Map<String, dynamic> json) =>
    _$TypingIndicatorImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$TypingIndicatorImplToJson(
        _$TypingIndicatorImpl instance) =>
    <String, dynamic>{
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
