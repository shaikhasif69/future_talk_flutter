import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Conversation types matching API documentation
enum ConversationType { direct, group }

/// Message types matching API documentation  
enum MessageType { text, voice, video, image }

/// Participant roles matching API documentation
enum ParticipantRole { admin, member }

/// Message delivery status
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

/// Attachment model matching API documentation
@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String fileName,
    required String fileUrl,
    required String fileType,
    required int fileSize,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, Object?> json) =>
      _$AttachmentFromJson(json);
}

/// Reaction model matching API documentation
@freezed
class Reaction with _$Reaction {
  const factory Reaction({
    required String userId,
    required String emoji,
    required DateTime createdAt,
  }) = _Reaction;

  factory Reaction.fromJson(Map<String, Object?> json) =>
      _$ReactionFromJson(json);
}

/// Voice message specific data
@freezed
class VoiceMessage with _$VoiceMessage {
  const factory VoiceMessage({
    required String audioUrl,
    required Duration duration,
    @Default(false) bool isPlaying,
    @Default(0.0) double progress,
    String? waveformData, // Base64 encoded waveform data
  }) = _VoiceMessage;

  factory VoiceMessage.fromJson(Map<String, Object?> json) =>
      _$VoiceMessageFromJson(json);
}

/// Image message specific data
@freezed
class ImageMessage with _$ImageMessage {
  const factory ImageMessage({
    required String imageUrl,
    String? thumbnailUrl,
    String? caption,
    double? width,
    double? height,
  }) = _ImageMessage;

  factory ImageMessage.fromJson(Map<String, Object?> json) =>
      _$ImageMessageFromJson(json);
}

/// Connection stone interaction data
@freezed
class ConnectionStoneMessage with _$ConnectionStoneMessage {
  const factory ConnectionStoneMessage({
    required String stoneType,
    required String emotion,
    @Default('') String message,
    DateTime? timestamp,
  }) = _ConnectionStoneMessage;

  factory ConnectionStoneMessage.fromJson(Map<String, Object?> json) =>
      _$ConnectionStoneMessageFromJson(json);
}

/// Message reaction data
@freezed
class MessageReaction with _$MessageReaction {
  const factory MessageReaction({
    required String id,
    required String emoji,
    required String userId,
    required String userName,
    required DateTime timestamp,
    @Default(false) bool isFromMe,
  }) = _MessageReaction;

  factory MessageReaction.fromJson(Map<String, Object?> json) =>
      _$MessageReactionFromJson(json);
}

/// Self-destruct message specific data
@freezed
class SelfDestructMessage with _$SelfDestructMessage {
  const factory SelfDestructMessage({
    required Duration countdown,
    required DateTime createdAt,
    @Default(false) bool isExpired,
  }) = _SelfDestructMessage;

  const SelfDestructMessage._();

  /// Get remaining time before self-destruction
  Duration get remainingTime {
    if (isExpired) return Duration.zero;
    
    final elapsed = DateTime.now().difference(createdAt);
    final remaining = countdown - elapsed;
    
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Check if message has expired
  bool get hasExpired {
    return remainingTime == Duration.zero;
  }

  /// Get progress percentage (0.0 to 1.0)
  double get destructionProgress {
    if (isExpired || countdown.inMilliseconds == 0) return 1.0;
    
    final elapsed = DateTime.now().difference(createdAt).inMilliseconds;
    final total = countdown.inMilliseconds;
    final progress = elapsed / total;
    
    return progress.clamp(0.0, 1.0);
  }

  factory SelfDestructMessage.fromJson(Map<String, Object?> json) =>
      _$SelfDestructMessageFromJson(json);
}

/// Main chat message model matching API documentation exactly
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id, // UUID
    required String conversationId, // UUID
    required String senderId, // UUID
    required String senderUsername,
    required String content,
    required MessageType messageType,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? editedAt, // Added missing field
    @Default(false) bool isEdited,
    @Default(false) bool isDestroyed,
    String? replyToMessageId, // UUID or null
    @Default([]) List<Attachment> attachments,
    @Default([]) List<Reaction> reactions,
    @Default([]) List<String> readBy, // List of user IDs
    DateTime? selfDestructAt, // Added missing field
    @Default(true) bool encrypted, // Added missing field
    String? encryptionType, // Added missing field
    String? securityLevel, // Added missing field
    // Additional fields for UI state
    @Default(MessageStatus.sent) MessageStatus status,
    @Default(false) bool isFromMe,
  }) = _ChatMessage;

  const ChatMessage._();

  /// Get formatted timestamp for display
  String get formattedTime {
    final hour = createdAt.hour;
    final minute = createdAt.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:${minute.toString().padLeft(2, '0')} $amPm';
  }

  /// Get formatted date for display
  String get formattedDate {
    final now = DateTime.now();
    final messageDate = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
    }
  }

  /// Get status icon for display
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
      case MessageStatus.failed:
        return '❌';
    }
  }

  /// Get status text for display
  String get statusText {
    switch (status) {
      case MessageStatus.sending:
        return 'Sending...';
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';  
      case MessageStatus.read:
        return 'Read $formattedTime';
      case MessageStatus.failed:
        return 'Failed to send';
    }
  }

  /// Check if message has reactions
  bool get hasReactions => reactions.isNotEmpty;

  /// Get grouped reactions by emoji
  Map<String, List<Reaction>> get groupedReactions {
    final Map<String, List<Reaction>> grouped = {};
    
    for (final reaction in reactions) {
      grouped.putIfAbsent(reaction.emoji, () => []).add(reaction);
    }
    
    return grouped;
  }

  /// Check if user has reacted with specific emoji
  bool hasUserReaction(String emoji, String userId) {
    return reactions.any((r) => r.userId == userId && r.emoji == emoji);
  }

  /// Get content preview for notifications
  String get contentPreview {
    switch (messageType) {
      case MessageType.text:
        return content.length > 50 ? '${content.substring(0, 50)}...' : content;
      case MessageType.voice:
        return '🎵 Voice message';
      case MessageType.video:
        return '🎥 Video message';
      case MessageType.image:
        return '📷 Photo';
    }
  }

  /// Get display content (empty if destroyed)
  String get displayContent {
    if (isDestroyed) return 'This message has been deleted';
    return content;
  }

  /// Check if message should show timestamp
  bool shouldShowTimestamp(ChatMessage? previousMessage) {
    if (previousMessage == null) return true;
    
    final timeDiff = createdAt.difference(previousMessage.createdAt).inMinutes;
    final differentSender = senderId != previousMessage.senderId;
    
    return timeDiff > 5 || differentSender;
  }

  /// Check if message should show sender name (in group chats)
  bool shouldShowSenderName(ChatMessage? previousMessage, bool isGroupChat) {
    if (!isGroupChat || isFromMe) return false;
    if (previousMessage == null) return true;
    
    return senderId != previousMessage.senderId;
  }

  /// Create from API message data (for REST API responses)
  static ChatMessage fromApiMessage(Map<String, dynamic> json, String currentUserId) {
    debugPrint('🔍 [ChatMessage] Parsing API message with keys: ${json.keys.toList()}');
    
    // Safe string extraction with null checks
    final String id = (json['id'] as String?) ?? '';
    final String conversationId = (json['conversation_id'] as String?) ?? '';
    final String senderId = (json['sender_id'] as String?) ?? '';
    
    // Handle sender field safely - it could be string, object, or array
    String senderUsername = 'Unknown';
    final senderValue = json['sender_username'] ?? json['sender'];
    if (senderValue is String) {
      senderUsername = senderValue;
    } else if (senderValue is Map<String, dynamic>) {
      senderUsername = (senderValue['username'] as String?) ?? (senderValue['name'] as String?) ?? 'Unknown';
    } else if (senderValue is List && senderValue.isNotEmpty) {
      final firstSender = senderValue.first;
      if (firstSender is String) {
        senderUsername = firstSender;
      } else if (firstSender is Map<String, dynamic>) {
        senderUsername = (firstSender['username'] as String?) ?? (firstSender['name'] as String?) ?? 'Unknown';
      }
    }
    
    final String content = (json['content'] as String?) ?? '';
    final String messageTypeStr = (json['message_type'] as String?) ?? 'text';
    final String createdAtStr = (json['created_at'] as String?) ?? DateTime.now().toIso8601String();
    
    // Handle updatedAtStr safely
    final String? updatedAtStr = json['updated_at'] is String ? json['updated_at'] as String? : null;
    
    // Handle editedAt safely
    final String? editedAtStr = json['edited_at'] is String ? json['edited_at'] as String? : null;
    
    // Handle replyToMessageId safely - it might come as array or string
    String? replyToMessageId;
    final replyToValue = json['reply_to_message_id'];
    if (replyToValue is String) {
      replyToMessageId = replyToValue;
    } else if (replyToValue is List && replyToValue.isNotEmpty && replyToValue.first is String) {
      replyToMessageId = replyToValue.first as String;
    }
    
    // CRITICAL FIX: Handle list fields safely - backend always returns these as Lists
    List<Attachment> attachments = [];
    List<Reaction> reactions = [];
    List<String> readBy = [];
    
    try {
      // Attachments handling - backend always returns [] (empty array)
      final attachmentData = json['attachments'];
      if (attachmentData is List) {
        debugPrint('🔍 [ChatMessage] Attachments data: $attachmentData');
        attachments = attachmentData
            .whereType<Map<String, dynamic>>()
            .map((a) => Attachment.fromJson(a))
            .toList();
      } else {
        debugPrint('⚠️ [ChatMessage] Attachments is not a list: ${attachmentData.runtimeType}');
      }
      
      // Reactions handling - backend always returns [] (empty array)
      final reactionData = json['reactions'];
      if (reactionData is List) {
        debugPrint('🔍 [ChatMessage] Reactions data: $reactionData');
        reactions = reactionData
            .whereType<Map<String, dynamic>>()
            .map((r) => Reaction.fromJson(r))
            .toList();
      } else {
        debugPrint('⚠️ [ChatMessage] Reactions is not a list: ${reactionData.runtimeType}');
      }
      
      // ReadBy handling - backend always returns [] (empty array)
      final readByData = json['read_by'];
      if (readByData is List) {
        debugPrint('🔍 [ChatMessage] ReadBy data: $readByData');
        readBy = readByData
            .whereType<String>()
            .toList();
      } else {
        debugPrint('⚠️ [ChatMessage] ReadBy is not a list: ${readByData.runtimeType}');
      }
    } catch (e, stackTrace) {
      // If parsing fails, use empty lists - don't crash the app
      debugPrint('❌ [ChatMessage] Failed to parse list fields: $e');
      debugPrint('❌ [ChatMessage] Stack trace: $stackTrace');
      debugPrint('❌ [ChatMessage] Raw JSON: ${jsonEncode(json)}');
    }
    
    // Handle self destruct time
    DateTime? selfDestructAt;
    final selfDestructAtStr = json['self_destruct_at'];
    if (selfDestructAtStr is String) {
      try {
        selfDestructAt = DateTime.parse(selfDestructAtStr);
      } catch (e) {
        debugPrint('⚠️ [ChatMessage] Failed to parse self_destruct_at: $e');
      }
    }
    
    return ChatMessage(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderUsername: senderUsername,
      content: content,
      messageType: MessageType.values.firstWhere(
        (e) => e.name == messageTypeStr,
        orElse: () => MessageType.text,
      ),
      createdAt: DateTime.parse(createdAtStr),
      updatedAt: updatedAtStr != null 
        ? DateTime.parse(updatedAtStr)
        : null,
      editedAt: editedAtStr != null 
        ? DateTime.parse(editedAtStr)
        : null,
      isEdited: json['is_edited'] as bool? ?? false,
      isDestroyed: json['is_destroyed'] as bool? ?? false,
      replyToMessageId: replyToMessageId,
      attachments: attachments,
      reactions: reactions,
      readBy: readBy,
      selfDestructAt: selfDestructAt,
      encrypted: json['encrypted'] as bool? ?? true,
      encryptionType: json['encryption_type'] as String?,
      securityLevel: json['security_level'] as String?,
      isFromMe: senderId == currentUserId,
    );
  }

  /// Create from WebSocket message data (for real-time WebSocket events)
  static ChatMessage fromWebSocketMessage(Map<String, dynamic> data, String currentUserId) {
    debugPrint('🔍 [ChatMessage] Parsing WebSocket message with keys: ${data.keys.toList()}');
    
    try {
      // Extract message_data according to documentation
      final messageData = data['message_data'] as Map<String, dynamic>;
      final messageInfo = messageData['message'] as Map<String, dynamic>;
      final senderInfo = messageData['sender_info'] as Map<String, dynamic>?;
      
      debugPrint('🔍 [ChatMessage] Message info keys: ${messageInfo.keys.toList()}');
      debugPrint('🔍 [ChatMessage] Sender info: $senderInfo');
      
      // Extract basic message fields
      final String id = messageInfo['id'] as String;
      final String conversationId = messageInfo['conversation_id'] as String;
      final String senderId = messageInfo['sender_id'] as String;
      final String content = messageInfo['content'] as String;
      final String messageTypeStr = messageInfo['message_type'] as String? ?? 'text';
      final String createdAtStr = messageInfo['created_at'] as String;
      
      // Handle optional datetime fields
      final String? updatedAtStr = messageInfo['updated_at'] as String?;
      final String? editedAtStr = messageInfo['edited_at'] as String?;
      
      // Get sender username from sender_info or message data
      String senderUsername = 'Unknown';
      if (senderInfo != null) {
        senderUsername = senderInfo['username'] as String? ?? 
                        senderInfo['display_name'] as String? ?? 
                        messageInfo['sender_username'] as String? ?? 
                        'Unknown';
      } else {
        senderUsername = messageInfo['sender_username'] as String? ?? 'Unknown';
      }
      
      // Handle replyToMessageId
      final String? replyToMessageId = messageInfo['reply_to_message_id'] as String?;
      
      // CRITICAL FIX: Handle WebSocket arrays correctly
      List<Attachment> attachments = [];
      List<Reaction> reactions = [];
      List<String> readBy = [];
      
      try {
        // Attachments - always empty array [] in WebSocket messages
        final attachmentData = messageInfo['attachments'];
        if (attachmentData is List) {
          attachments = attachmentData
              .whereType<Map<String, dynamic>>()
              .map((a) => Attachment.fromJson(a))
              .toList();
        }
        
        // Reactions - always empty array [] in WebSocket messages
        final reactionData = messageInfo['reactions'];
        if (reactionData is List) {
          reactions = reactionData
              .whereType<Map<String, dynamic>>()
              .map((r) => Reaction.fromJson(r))
              .toList();
        }
        
        // ReadBy - always empty array [] in WebSocket messages
        final readByData = messageInfo['read_by'];
        if (readByData is List) {
          readBy = readByData
              .whereType<String>()
              .toList();
        }
      } catch (e) {
        debugPrint('⚠️ [ChatMessage] Failed to parse WebSocket list fields: $e');
      }
      
      // Handle self destruct time
      DateTime? selfDestructAt;
      final selfDestructAtStr = messageInfo['self_destruct_at'] as String?;
      if (selfDestructAtStr != null) {
        try {
          selfDestructAt = DateTime.parse(selfDestructAtStr);
        } catch (e) {
          debugPrint('⚠️ [ChatMessage] Failed to parse WebSocket self_destruct_at: $e');
        }
      }
      
      return ChatMessage(
        id: id,
        conversationId: conversationId,
        senderId: senderId,
        senderUsername: senderUsername,
        content: content,
        messageType: MessageType.values.firstWhere(
          (e) => e.name == messageTypeStr,
          orElse: () => MessageType.text,
        ),
        createdAt: DateTime.parse(createdAtStr),
        updatedAt: updatedAtStr != null ? DateTime.parse(updatedAtStr) : null,
        editedAt: editedAtStr != null ? DateTime.parse(editedAtStr) : null,
        isEdited: messageInfo['is_edited'] as bool? ?? false,
        isDestroyed: messageInfo['is_destroyed'] as bool? ?? false,
        replyToMessageId: replyToMessageId,
        attachments: attachments,
        reactions: reactions,
        readBy: readBy,
        selfDestructAt: selfDestructAt,
        encrypted: messageInfo['encrypted'] as bool? ?? true,
        encryptionType: messageInfo['encryption_type'] as String?,
        securityLevel: messageInfo['security_level'] as String?,
        isFromMe: senderId == currentUserId,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ [ChatMessage] Failed to parse WebSocket message: $e');
      debugPrint('❌ [ChatMessage] Stack trace: $stackTrace');
      debugPrint('❌ [ChatMessage] Raw data: ${jsonEncode(data)}');
      rethrow;
    }
  }

  factory ChatMessage.fromJson(Map<String, Object?> json) =>
      _$ChatMessageFromJson(json);
}



/// Types of typing activities
enum TypingActivity {
  typing,
  recording,
  uploading,
}

/// Quick reactions data
class QuickReactions {
  static const List<String> defaultReactions = [
    '❤️', '😍', '😂', '😮', '😢', '😡', '👍', '👎'
  ];

  static const Map<String, List<String>> contextualReactions = {
    'happy': ['😊', '😄', '🥰', '😍', '👏', '🎉'],
    'sad': ['😢', '😞', '😔', '💔', '🫂', '❤️'],
    'funny': ['😂', '🤣', '😆', '😄', '👍', '💯'],
    'surprise': ['😮', '😯', '🤯', '👀', '😱', '🙌'],
    'love': ['❤️', '💕', '😍', '🥰', '💖', '😘'],
    'support': ['👍', '💪', '🙌', '👏', '❤️', '🫂'],
  };

  static List<String> getReactionsForContext(String context) {
    return contextualReactions[context] ?? defaultReactions;
  }

  static List<String> getMoodBasedReactions(String mood) {
    switch (mood.toLowerCase()) {
      case 'energized':
        return contextualReactions['happy']!;
      case 'selective':
        return contextualReactions['support']!;
      case 'recharging':
        return contextualReactions['support']!;
      default:
        return defaultReactions;
    }
  }
}

/// Message draft for composing
@freezed
class MessageDraft with _$MessageDraft {
  const factory MessageDraft({
    @Default('') String content,
    @Default(MessageType.text) MessageType type,
    String? replyToMessageId,
    VoiceMessage? voiceMessage,
    ImageMessage? imageMessage,
    @Default(false) bool isSelfDestruct,
    Duration? selfDestructDuration,
  }) = _MessageDraft;

  const MessageDraft._();

  /// Check if draft has content
  bool get hasContent => content.trim().isNotEmpty || 
      voiceMessage != null || 
      imageMessage != null;

  /// Get content length for character counting
  int get contentLength => content.length;

  /// Check if ready to send
  bool get canSend => hasContent && contentLength <= 1000; // Max message length

  factory MessageDraft.fromJson(Map<String, Object?> json) =>
      _$MessageDraftFromJson(json);
}

/// Typing indicator data
@freezed  
class TypingIndicator with _$TypingIndicator {
  const factory TypingIndicator({
    required String userId,
    required String userName,
    required DateTime startedAt,
    @Default(false) bool isActive,
  }) = _TypingIndicator;

  const TypingIndicator._();

  /// Check if typing indicator is still valid (not older than 5 seconds)
  bool get isValid {
    final now = DateTime.now();
    final elapsed = now.difference(startedAt).inSeconds;
    return elapsed <= 5 && isActive;
  }

  factory TypingIndicator.fromJson(Map<String, Object?> json) =>
      _$TypingIndicatorFromJson(json);
}

/// Message read receipt data
@freezed
class ReadReceipt with _$ReadReceipt {
  const factory ReadReceipt({
    required String messageId,
    required String userId,
    required String userName,
    required DateTime readAt,
  }) = _ReadReceipt;

  factory ReadReceipt.fromJson(Map<String, Object?> json) =>
      _$ReadReceiptFromJson(json);
}