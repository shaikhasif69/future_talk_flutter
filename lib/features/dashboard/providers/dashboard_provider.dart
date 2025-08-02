import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/app_router.dart';
import '../models/dashboard_data.dart';
import '../models/friend_status.dart';

/// Provider for dashboard data state
class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  BuildContext? _context;
  
  DashboardNotifier() : super(const AsyncValue.loading()) {
    _loadDashboardData();
  }

  /// Set context for navigation
  void setContext(BuildContext context) {
    _context = context;
    // Update quick actions with new context
    updateQuickActions();
  }

  Future<void> _loadDashboardData() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      final mockData = DashboardData.createMockData();
      final data = mockData.copyWith(
        quickActions: _createQuickActionsWithNavigation(),
      );
      print('Loading dashboard data with ${data.quickActions.length} quick actions');
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Create quick actions with proper navigation callbacks
  List<QuickAction> _createQuickActionsWithNavigation() {
    return [
      QuickAction(
        id: '1',
        title: 'Time Capsule',
        subtitle: 'Send to future',
        icon: '💌',
        isPremium: false,
        onTap: () {
          // TODO: Navigate to time capsule screen when created
          print('Navigate to Time Capsule');
        },
      ),
      QuickAction(
        id: '2',
        title: 'Start Chat',
        subtitle: 'Gentle conversation',
        icon: '💬',
        isPremium: false,
        onTap: () {
          print('Chat button tapped! Context: $_context');
          if (_context != null) {
            print('Navigating to /chat');
            _context!.go('/chat');
          } else {
            print('Context is null - cannot navigate');
          }
        },
      ),
      QuickAction(
        id: '3',
        title: 'Touch Stone',
        subtitle: 'Connect hearts',
        icon: '🪨',
        isPremium: true,
        onTap: () {
          // TODO: Navigate to connection stones when created
          print('Navigate to Connection Stones');
        },
      ),
      QuickAction(
        id: '4',
        title: 'User Profile',
        subtitle: 'View Sarah\'s profile',
        icon: '👤',
        isPremium: true,
        onTap: () {
          if (_context != null) {
            print('Navigating to user profile');
            _context!.goToUserProfile('user_sarah_001');
          } else {
            print('Context is null - cannot navigate');
          }
        },
      ),
    ];
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadDashboardData();
  }

  /// Update quick actions when context changes
  void updateQuickActions() {
    print('Updating quick actions with context: $_context');
    state.whenData((data) {
      final newActions = _createQuickActionsWithNavigation();
      print('Created ${newActions.length} quick actions');
      state = AsyncValue.data(
        data.copyWith(
          quickActions: newActions,
          lastUpdated: DateTime.now(),
        ),
      );
    });
  }

  /// Update user's social battery level
  void updateBatteryLevel(SocialBatteryLevel newLevel) {
    state.whenData((data) {
      state = AsyncValue.data(
        data.copyWith(
          userBatteryLevel: newLevel,
          lastUpdated: DateTime.now(),
        ),
      );
    });
  }

  /// Add new activity to the feed
  void addActivity(RecentActivity activity) {
    state.whenData((data) {
      final updatedActivities = [activity, ...data.recentActivities];
      state = AsyncValue.data(
        data.copyWith(
          recentActivities: updatedActivities.take(10).toList(), // Keep only recent 10
          lastUpdated: DateTime.now(),
        ),
      );
    });
  }

  /// Update friend's status
  void updateFriendStatus(String friendId, SocialBatteryLevel newLevel) {
    state.whenData((data) {
      final updatedFriends = data.friends.map((friend) {
        if (friend.id == friendId) {
          return friend.copyWith(
            batteryLevel: newLevel,
            lastActive: DateTime.now(),
          );
        }
        return friend;
      }).toList();

      state = AsyncValue.data(
        data.copyWith(
          friends: updatedFriends,
          lastUpdated: DateTime.now(),
        ),
      );
    });
  }

  /// Mark notifications as read
  void markNotificationsAsRead() {
    state.whenData((data) {
      state = AsyncValue.data(
        data.copyWith(
          unreadNotifications: 0,
          lastUpdated: DateTime.now(),
        ),
      );
    });
  }
}

/// Dashboard provider
final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>((ref) {
  return DashboardNotifier();
});

/// Provider for current user's social battery level
final userBatteryLevelProvider = Provider<SocialBatteryLevel>((ref) {
  final dashboardData = ref.watch(dashboardProvider);
  return dashboardData.when(
    data: (data) => data.userBatteryLevel,
    loading: () => SocialBatteryLevel.energized,
    error: (_, __) => SocialBatteryLevel.energized,
  );
});

/// Provider for friends list
final friendsProvider = Provider<List<FriendStatus>>((ref) {
  final dashboardData = ref.watch(dashboardProvider);
  return dashboardData.when(
    data: (data) => data.friends,
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for recent activities
final recentActivitiesProvider = Provider<List<RecentActivity>>((ref) {
  final dashboardData = ref.watch(dashboardProvider);
  return dashboardData.when(
    data: (data) => data.recentActivities,
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for quick actions
final quickActionsProvider = Provider<List<QuickAction>>((ref) {
  final dashboardData = ref.watch(dashboardProvider);
  return dashboardData.when(
    data: (data) => data.quickActions,
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for unread notifications count
final unreadNotificationsProvider = Provider<int>((ref) {
  final dashboardData = ref.watch(dashboardProvider);
  return dashboardData.when(
    data: (data) => data.unreadNotifications,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider for greeting information
final greetingProvider = Provider<Map<String, String>>((ref) {
  final dashboardData = ref.watch(dashboardProvider);
  return dashboardData.when(
    data: (data) => {
      'greeting': data.greeting,
      'subtitle': data.subtitle,
      'userName': data.userName,
    },
    loading: () => {
      'greeting': DashboardData.getTimeBasedGreeting(),
      'subtitle': 'Loading...',
      'userName': 'User',
    },
    error: (_, __) => {
      'greeting': DashboardData.getTimeBasedGreeting(),
      'subtitle': 'Welcome back',
      'userName': 'User',
    },
  );
});

/// Provider for dashboard loading state
final dashboardLoadingProvider = Provider<bool>((ref) {
  final dashboardData = ref.watch(dashboardProvider);
  return dashboardData.isLoading;
});

/// Provider for dashboard error state
final dashboardErrorProvider = Provider<String?>((ref) {
  final dashboardData = ref.watch(dashboardProvider);
  return dashboardData.hasError ? dashboardData.error.toString() : null;
});

/// Provider for online friends count
final onlineFriendsCountProvider = Provider<int>((ref) {
  final friends = ref.watch(friendsProvider);
  return friends.where((friend) => friend.isOnline).length;
});

/// Provider for friends grouped by battery level
final friendsByBatteryLevelProvider = Provider<Map<SocialBatteryLevel, List<FriendStatus>>>((ref) {
  final friends = ref.watch(friendsProvider);
  
  final grouped = <SocialBatteryLevel, List<FriendStatus>>{
    SocialBatteryLevel.energized: [],
    SocialBatteryLevel.selective: [],
    SocialBatteryLevel.recharging: [],
  };
  
  for (final friend in friends) {
    grouped[friend.batteryLevel]!.add(friend);
  }
  
  return grouped;
});

/// Provider for dashboard statistics
final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final friends = ref.watch(friendsProvider);
  final activities = ref.watch(recentActivitiesProvider);
  
  return DashboardStats(
    totalFriends: friends.length,
    onlineFriends: friends.where((f) => f.isOnline).length,
    energizedFriends: friends.where((f) => f.batteryLevel == SocialBatteryLevel.energized).length,
    selectiveFriends: friends.where((f) => f.batteryLevel == SocialBatteryLevel.selective).length,
    rechargingFriends: friends.where((f) => f.batteryLevel == SocialBatteryLevel.recharging).length,
    todayActivities: activities.where((a) => _isToday(a.timestamp)).length,
    thisWeekActivities: activities.where((a) => _isThisWeek(a.timestamp)).length,
  );
});

/// Dashboard statistics model
class DashboardStats {
  final int totalFriends;
  final int onlineFriends;
  final int energizedFriends;
  final int selectiveFriends;
  final int rechargingFriends;
  final int todayActivities;
  final int thisWeekActivities;

  const DashboardStats({
    required this.totalFriends,
    required this.onlineFriends,
    required this.energizedFriends,
    required this.selectiveFriends,
    required this.rechargingFriends,
    required this.todayActivities,
    required this.thisWeekActivities,
  });
}

/// Helper function to check if date is today
bool _isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year && 
         date.month == now.month && 
         date.day == now.day;
}

/// Helper function to check if date is this week
bool _isThisWeek(DateTime date) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  
  return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
}