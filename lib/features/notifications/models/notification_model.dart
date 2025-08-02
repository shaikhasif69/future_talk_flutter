import 'package:flutter/material.dart';

/// Notification types that correspond to Future Talk features
enum NotificationType {
  timeCapsule,
  connectionStone,
  reading,
  social,
  system,
  friend,
}

/// Notification priority levels
enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

/// Notification action button types
enum NotificationActionType {
  primary,
  secondary,
  destructive,
}

class NotificationAction {
  final String id;
  final String label;
  final NotificationActionType type;
  final String? icon;
  final VoidCallback? onTap;

  const NotificationAction({
    required this.id,
    required this.label,
    required this.type,
    this.icon,
    this.onTap,
  });
}

class FTNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final NotificationPriority priority;
  final String? icon;
  final String? avatarUrl;
  final String? previewText;
  final String? fromUserId;
  final String? fromUserName;
  final Map<String, dynamic>? metadata;
  final List<NotificationAction> actions;

  const FTNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.priority = NotificationPriority.medium,
    this.icon,
    this.avatarUrl,
    this.previewText,
    this.fromUserId,
    this.fromUserName,
    this.metadata,
    this.actions = const [],
  });
}

/// Extension to get notification type properties
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.timeCapsule:
        return 'Time Capsules';
      case NotificationType.connectionStone:
        return 'Connection Stones';
      case NotificationType.reading:
        return 'Reading';
      case NotificationType.social:
        return 'Social';
      case NotificationType.system:
        return 'System';
      case NotificationType.friend:
        return 'Friends';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.timeCapsule:
        return '⏰';
      case NotificationType.connectionStone:
        return '🪨';
      case NotificationType.reading:
        return '📚';
      case NotificationType.social:
        return '🎉';
      case NotificationType.system:
        return '⚙️';
      case NotificationType.friend:
        return '👥';
    }
  }

  String get tabName {
    switch (this) {
      case NotificationType.timeCapsule:
        return 'Capsules';
      case NotificationType.connectionStone:
        return 'Stones';
      case NotificationType.reading:
        return 'Reading';
      case NotificationType.social:
        return 'Social';
      case NotificationType.system:
        return 'System';
      case NotificationType.friend:
        return 'Friends';
    }
  }
}

/// Helper class for notification mock data
class NotificationMockData {
  static List<FTNotification> getMockNotifications() {
    final now = DateTime.now();
    
    return [
      // Time Capsule Notifications
      FTNotification(
        id: '1',
        title: 'Time Capsule Delivered!',
        message: 'A message from your past self has arrived',
        type: NotificationType.timeCapsule,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        priority: NotificationPriority.high,
        previewText: '"I hope by now you\'ve learned to be kinder to yourself. Remember that progress isn\'t always visible..."',
        actions: [
          const NotificationAction(
            id: 'open',
            label: 'Open',
            type: NotificationActionType.primary,
          ),
        ],
      ),
      FTNotification(
        id: '2',
        title: 'Sarah sent you a time capsule',
        message: 'Scheduled to open in 3 days',
        type: NotificationType.timeCapsule,
        timestamp: now.subtract(const Duration(hours: 4)),
        isRead: false,
        fromUserId: 'sarah_123',
        fromUserName: 'Sarah',
        actions: [
          const NotificationAction(
            id: 'preview',
            label: 'Preview',
            type: NotificationActionType.secondary,
          ),
        ],
      ),
      
      // Connection Stone Notifications
      FTNotification(
        id: '3',
        title: 'Alex touched their comfort stone',
        message: 'They\'re thinking of you and could use some comfort',
        type: NotificationType.connectionStone,
        timestamp: now.subtract(const Duration(minutes: 30)),
        isRead: false,
        priority: NotificationPriority.high,
        fromUserId: 'alex_456',
        fromUserName: 'Alex',
        actions: [
          const NotificationAction(
            id: 'touch_back',
            label: 'Touch Back',
            type: NotificationActionType.primary,
          ),
          const NotificationAction(
            id: 'message',
            label: 'Message',
            type: NotificationActionType.secondary,
          ),
        ],
      ),
      FTNotification(
        id: '4',
        title: 'Sarah touched her worry stone',
        message: 'She\'s sending you gentle comfort',
        type: NotificationType.connectionStone,
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
        priority: NotificationPriority.medium,
        fromUserId: 'sarah_123',
        fromUserName: 'Sarah',
        actions: [
          const NotificationAction(
            id: 'touch_back',
            label: 'Touch Back',
            type: NotificationActionType.primary,
          ),
        ],
      ),
      
      // Reading Notifications
      FTNotification(
        id: '5',
        title: 'Maya started reading "Atomic Habits"',
        message: 'She\'s inviting you to read together',
        type: NotificationType.reading,
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
        fromUserId: 'maya_789',
        fromUserName: 'Maya',
        actions: [
          const NotificationAction(
            id: 'join',
            label: 'Join',
            type: NotificationActionType.primary,
          ),
          const NotificationAction(
            id: 'maybe_later',
            label: 'Maybe Later',
            type: NotificationActionType.secondary,
          ),
        ],
      ),
      FTNotification(
        id: '6',
        title: 'Reading session completed',
        message: 'You and Sarah finished Chapter 5 of "Pride and Prejudice"',
        type: NotificationType.reading,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
        fromUserId: 'sarah_123',
        fromUserName: 'Sarah',
      ),
      FTNotification(
        id: '7',
        title: 'Weekly reading summary',
        message: 'You read for 4.5 hours this week across 3 books',
        type: NotificationType.reading,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        actions: [
          const NotificationAction(
            id: 'view_details',
            label: 'View Details',
            type: NotificationActionType.secondary,
          ),
        ],
      ),
      
      // Social Notifications
      FTNotification(
        id: '8',
        title: 'Riley\'s social battery changed to Red',
        message: 'They\'re recharging and need some space today',
        type: NotificationType.social,
        timestamp: now.subtract(const Duration(minutes: 45)),
        isRead: false,
        fromUserId: 'riley_012',
        fromUserName: 'Riley',
      ),
      FTNotification(
        id: '9',
        title: 'New friend request',
        message: '@mindful_maya wants to connect with you',
        type: NotificationType.social,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        fromUserId: 'maya_789',
        fromUserName: 'Maya',
        actions: [
          const NotificationAction(
            id: 'accept',
            label: 'Accept',
            type: NotificationActionType.primary,
          ),
          const NotificationAction(
            id: 'decline',
            label: 'Decline',
            type: NotificationActionType.secondary,
          ),
        ],
      ),
      FTNotification(
        id: '10',
        title: 'Milestone achieved!',
        message: 'You\'ve maintained a 14-day mindful communication streak',
        type: NotificationType.social,
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
      
      // System Notifications
      FTNotification(
        id: '11',
        title: 'Time capsule sent successfully',
        message: 'Your message to future self will be delivered in 6 months',
        type: NotificationType.system,
        timestamp: now.subtract(const Duration(days: 1, hours: 14, minutes: 30)),
        isRead: true,
      ),
      FTNotification(
        id: '12',
        title: 'New comfort stone created',
        message: 'You crafted "Evening Serenity" - a lavender crystal for peaceful nights',
        type: NotificationType.system,
        timestamp: now.subtract(const Duration(days: 5)),
        isRead: true,
      ),
    ];
  }
}