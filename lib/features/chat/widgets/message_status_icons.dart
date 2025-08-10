import 'package:flutter/material.dart';
import '../models/chat_message.dart';

/// WhatsApp-style message status icons with exact colors and styling
class MessageStatusIcons {
  // Exact WhatsApp colors
  static const Color grayTick = Color(0xFF8E8E93);    // iOS gray
  static const Color blueTick = Color(0xFF007AFF);    // WhatsApp blue  
  static const Color redError = Color(0xFFFF3B30);    // Error red
  static const Color sendingGray = Color(0xFFBEBEBE); // Sending state

  /// Get the appropriate status icon widget for a message
  static Widget getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icon(
          Icons.schedule,
          size: 14,
          color: sendingGray,
        );
        
      case MessageStatus.sent:
        return Icon(
          Icons.done,           // ✓ Single tick
          size: 14,
          color: grayTick,
        );
        
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,       // ✓✓ Double tick  
          size: 14,
          color: grayTick,
        );
        
      case MessageStatus.read:
        return Icon(
          Icons.done_all,       // ✓✓ Blue double tick
          size: 14,
          color: blueTick,      // 🔵 BLUE!
        );
        
      case MessageStatus.failed:
        return Icon(
          Icons.error,
          size: 14,
          color: redError,
        );
        
      case MessageStatus.received:
        return const SizedBox.shrink(); // No icon for received messages
    }
  }

  /// Get status icon with optional custom size
  static Widget getStatusIconWithSize(MessageStatus status, double size) {
    final baseIcon = getStatusIcon(status);
    
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: baseIcon,
      ),
    );
  }

  /// Get status text for accessibility or debugging
  static String getStatusText(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 'Sending message';
      case MessageStatus.sent:
        return 'Message sent';
      case MessageStatus.delivered:
        return 'Message delivered';
      case MessageStatus.read:
        return 'Message read';
      case MessageStatus.failed:
        return 'Failed to send';
      case MessageStatus.received:
        return 'Message received'; // For received messages
    }
  }
}