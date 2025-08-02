import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Types of messages that can be sent in a chat
enum MessageType {
  text,
  voice,
  image,
  file,
  connectionStone,
  selfDestruct,
}

/// Message delivery status
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
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

/// Main chat message model
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String senderId,
    required String senderName,
    required String conversationId,
    required MessageType type,
    required DateTime timestamp,
    required MessageStatus status,
    @Default('') String content,
    @Default([]) List<MessageReaction> reactions,
    @Default(false) bool isFromMe,
    @Default(false) bool isEdited,
    DateTime? editedAt,
    String? replyToMessageId,
    VoiceMessage? voiceMessage,
    ImageMessage? imageMessage,
    ConnectionStoneMessage? connectionStone,
    SelfDestructMessage? selfDestruct,
  }) = _ChatMessage;

  const ChatMessage._();

  /// Get formatted timestamp for display
  String get formattedTime {
    final hour = timestamp.hour;
    final minute = timestamp.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:${minute.toString().padLeft(2, '0')} $amPm';
  }

  /// Get formatted date for display
  String get formattedDate {
    final now = DateTime.now();
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
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

  /// Get my reactions from this message
  List<MessageReaction> get myReactions =>
      reactions.where((r) => r.isFromMe).toList();

  /// Get others' reactions from this message
  List<MessageReaction> get othersReactions =>
      reactions.where((r) => !r.isFromMe).toList();

  /// Get grouped reactions by emoji
  Map<String, List<MessageReaction>> get groupedReactions {
    final Map<String, List<MessageReaction>> grouped = {};
    
    for (final reaction in reactions) {
      grouped.putIfAbsent(reaction.emoji, () => []).add(reaction);
    }
    
    return grouped;
  }

  /// Check if I've reacted with specific emoji
  bool hasMyReaction(String emoji) {
    return reactions.any((r) => r.isFromMe && r.emoji == emoji);
  }

  /// Get content preview for notifications
  String get contentPreview {
    switch (type) {
      case MessageType.text:
        return content.length > 50 ? '${content.substring(0, 50)}...' : content;
      case MessageType.voice:
        return '🎵 Voice message';
      case MessageType.image:
        final caption = imageMessage?.caption;
        return caption?.isNotEmpty == true ? '📷 $caption' : '📷 Photo';
      case MessageType.file:
        return '📄 File';
      case MessageType.connectionStone:
        return '🪨 ${connectionStone?.emotion ?? 'Connection stone'}';
      case MessageType.selfDestruct:
        return '🔥 Self-destructing message';
    }
  }

  /// Check if message is expired (for self-destruct messages)
  bool get isExpired {
    if (type != MessageType.selfDestruct || selfDestruct == null) {
      return false;
    }
    return selfDestruct!.hasExpired;
  }

  /// Get display content (empty if expired)
  String get displayContent {
    if (isExpired) return 'This message has disappeared';
    return content;
  }

  /// Check if message should show timestamp
  bool shouldShowTimestamp(ChatMessage? previousMessage) {
    if (previousMessage == null) return true;
    
    final timeDiff = timestamp.difference(previousMessage.timestamp).inMinutes;
    final differentSender = senderId != previousMessage.senderId;
    
    return timeDiff > 5 || differentSender;
  }

  /// Check if message should show sender name (in group chats)
  bool shouldShowSenderName(ChatMessage? previousMessage, bool isGroupChat) {
    if (!isGroupChat || isFromMe) return false;
    if (previousMessage == null) return true;
    
    return senderId != previousMessage.senderId;
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