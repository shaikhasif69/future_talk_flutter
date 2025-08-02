import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';

/// Provider for managing notification state and interactions
class NotificationProvider with ChangeNotifier {
  List<FTNotification> _notifications = [];
  NotificationType? _selectedFilter;
  bool _isLoading = false;

  /// All notifications
  List<FTNotification> get notifications => List.unmodifiable(_notifications);

  /// Currently selected filter
  NotificationType? get selectedFilter => _selectedFilter;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Filtered notifications based on current filter
  List<FTNotification> get filteredNotifications {
    if (_selectedFilter == null) {
      return List.unmodifiable(_notifications);
    }
    return _notifications
        .where((notification) => notification.type == _selectedFilter)
        .toList();
  }

  /// Count of unread notifications
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Notification counts by type
  Map<NotificationType?, int> get notificationCounts {
    final counts = <NotificationType?, int>{};
    for (final notification in _notifications) {
      counts[notification.type] = (counts[notification.type] ?? 0) + 1;
    }
    return counts;
  }

  /// Initialize provider with mock data
  void initialize() {
    _isLoading = true;
    notifyListeners();

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _notifications = NotificationMockData.getMockNotifications();
      _isLoading = false;
      notifyListeners();
    });
  }

  /// Set notification filter
  void setFilter(NotificationType? filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      // Create new notification with updated read status
      final notification = _notifications[index];
      final updatedNotification = FTNotification(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        timestamp: notification.timestamp,
        isRead: true, // Mark as read
        priority: notification.priority,
        icon: notification.icon,
        avatarUrl: notification.avatarUrl,
        previewText: notification.previewText,
        fromUserId: notification.fromUserId,
        fromUserName: notification.fromUserName,
        metadata: notification.metadata,
        actions: notification.actions,
      );
      
      _notifications[index] = updatedNotification;
      notifyListeners();
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    _notifications = _notifications.map((notification) {
      if (notification.isRead) return notification;
      
      return FTNotification(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        timestamp: notification.timestamp,
        isRead: true,
        priority: notification.priority,
        icon: notification.icon,
        avatarUrl: notification.avatarUrl,
        previewText: notification.previewText,
        fromUserId: notification.fromUserId,
        fromUserName: notification.fromUserName,
        metadata: notification.metadata,
        actions: notification.actions,
      );
    }).toList();
    notifyListeners();
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  /// Add a new notification (for testing or real-time updates)
  void addNotification(FTNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  /// Remove a notification
  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  /// Handle notification action
  void handleAction(String notificationId, NotificationAction action) {
    // Mark notification as read when action is taken
    markAsRead(notificationId);
    
    // Here you would handle the specific action
    // For now, we'll just debug print
    debugPrint('Action ${action.label} performed on notification $notificationId');
  }
}