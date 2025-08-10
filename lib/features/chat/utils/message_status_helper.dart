import '../models/chat_message.dart';

/// Enhanced message status helper for WhatsApp-style tick progression
/// Handles both individual chats (1-on-1) and group chats (3+ people)
class MessageStatusHelper {
  /// Get message status for individual chats (2 people)
  /// Only shows status for messages sent by current user
  static MessageStatus getIndividualChatStatus(ChatMessage message, String currentUserId) {
    // Only show status for messages I sent
    if (message.senderId != currentUserId) {
      return MessageStatus.received; // No status for received messages
    }
    
    // Check if OTHER person read the message (exclude myself from readBy)
    final otherPersonRead = message.readBy.any((id) => id != currentUserId);
    if (otherPersonRead) {
      return MessageStatus.read;      // 🔵🔵 Blue double tick
    }
    
    // Check if OTHER person received the message (exclude myself from deliveredTo)
    final otherPersonDelivered = message.deliveredTo.any((id) => id != currentUserId);
    if (otherPersonDelivered) {
      return MessageStatus.delivered; // ✅✅ Gray double tick
    }
    
    // Message sent to server but not yet delivered
    if (message.id.isNotEmpty) {
      return MessageStatus.sent;      // ✅ Single tick
    }
    
    return MessageStatus.sending;     // ⏳ Clock
  }

  /// Get message status for group chats (3+ people)
  /// WhatsApp logic: ALL participants must reach status level for progression
  static MessageStatus getGroupChatStatus(
    ChatMessage message, 
    String currentUserId, 
    List<String> allParticipants
  ) {
    // Only show status for messages I sent
    if (message.senderId != currentUserId) {
      return MessageStatus.received;
    }
    
    // Get other participants (exclude myself)
    final otherParticipants = allParticipants.where((id) => id != currentUserId).toList();
    
    // Count how many others have read/delivered
    final readCount = otherParticipants.where((id) => message.readBy.contains(id)).length;
    final deliveredCount = otherParticipants.where((id) => message.deliveredTo.contains(id)).length;
    
    final totalOthers = otherParticipants.length;
    
    // WhatsApp logic: ALL must reach status level
    if (readCount == totalOthers) {
      return MessageStatus.read;      // 🔵🔵 All read - Blue double tick
    } else if (deliveredCount == totalOthers) {
      return MessageStatus.delivered; // ✅✅ All delivered - Gray double tick
    } else {
      return MessageStatus.sent;      // ✅ Not all delivered - Single tick
    }
  }

  /// Determine if a conversation is a group chat based on participant count
  static bool isGroupChat(List<String> participants) {
    return participants.length > 2;
  }

  /// Get appropriate status for any conversation type
  static MessageStatus getMessageStatus(
    ChatMessage message,
    String currentUserId,
    List<String> conversationParticipants,
  ) {
    if (isGroupChat(conversationParticipants)) {
      return getGroupChatStatus(message, currentUserId, conversationParticipants);
    } else {
      return getIndividualChatStatus(message, currentUserId);
    }
  }

  /// Debug helper - get detailed status information for troubleshooting
  static Map<String, dynamic> getStatusDebugInfo(
    ChatMessage message,
    String currentUserId,
    List<String> conversationParticipants,
  ) {
    final isGroup = isGroupChat(conversationParticipants);
    final otherParticipants = conversationParticipants.where((id) => id != currentUserId).toList();
    final status = getMessageStatus(message, currentUserId, conversationParticipants);
    
    return {
      'messageId': message.id.substring(0, 8),
      'content': message.content.length > 20 ? '${message.content.substring(0, 20)}...' : message.content,
      'senderId': message.senderId.substring(0, 8),
      'currentUserId': currentUserId.substring(0, 8),
      'isFromMe': message.senderId == currentUserId,
      'isGroupChat': isGroup,
      'totalParticipants': conversationParticipants.length,
      'otherParticipants': otherParticipants.length,
      'readBy': message.readBy,
      'deliveredTo': message.deliveredTo,
      'readByOthers': message.readBy.where((id) => id != currentUserId).toList(),
      'deliveredToOthers': message.deliveredTo.where((id) => id != currentUserId).toList(),
      'calculatedStatus': status.name,
      'statusIcon': _getStatusIcon(status),
    };
  }

  static String _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return '⏳';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.read:
        return '🔵🔵';
      case MessageStatus.failed:
        return '❌';
      case MessageStatus.received:
        return '';
    }
  }
}