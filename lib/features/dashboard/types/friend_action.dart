import 'package:flutter/material.dart';

/// Actions that can be performed on a found friend
enum FriendAction {
  addFriend,
  sendMessage,
  sendTimeCapsule,
}

/// Extension to get display text for friend actions
extension FriendActionExtension on FriendAction {
  String get displayText {
    switch (this) {
      case FriendAction.addFriend:
        return 'Add Friend';
      case FriendAction.sendMessage:
        return 'Send Message';
      case FriendAction.sendTimeCapsule:
        return 'Send Time Capsule';
    }
  }
  
  IconData get icon {
    switch (this) {
      case FriendAction.addFriend:
        return Icons.person_add_outlined;
      case FriendAction.sendMessage:
        return Icons.chat_bubble_outline;
      case FriendAction.sendTimeCapsule:
        return Icons.schedule_outlined;
    }
  }
}