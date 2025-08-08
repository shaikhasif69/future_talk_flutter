import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_durations.dart';

/// Navigation state management for Future Talk app
/// Handles bottom navigation state, route management, and smooth transitions
@immutable
class NavigationState {
  /// Currently selected tab index
  final int selectedIndex;
  
  /// Previous tab index for transition animations
  final int previousIndex;
  
  /// Whether navigation is currently animating
  final bool isAnimating;
  
  /// Last navigation timestamp for preventing rapid taps
  final DateTime lastNavigationTime;
  
  /// Navigation history for advanced back navigation
  final List<int> navigationHistory;
  
  /// Whether the navigation bar should be visible
  final bool isVisible;
  
  /// Custom navigation state data
  final Map<String, dynamic> customData;

  const NavigationState({
    this.selectedIndex = 0,
    this.previousIndex = 0,
    this.isAnimating = false,
    required this.lastNavigationTime,
    this.navigationHistory = const [0],
    this.isVisible = true,
    this.customData = const {},
  });

  NavigationState copyWith({
    int? selectedIndex,
    int? previousIndex,
    bool? isAnimating,
    DateTime? lastNavigationTime,
    List<int>? navigationHistory,
    bool? isVisible,
    Map<String, dynamic>? customData,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      previousIndex: previousIndex ?? this.previousIndex,
      isAnimating: isAnimating ?? this.isAnimating,
      lastNavigationTime: lastNavigationTime ?? this.lastNavigationTime,
      navigationHistory: navigationHistory ?? this.navigationHistory,
      isVisible: isVisible ?? this.isVisible,
      customData: customData ?? this.customData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationState &&
        other.selectedIndex == selectedIndex &&
        other.previousIndex == previousIndex &&
        other.isAnimating == isAnimating &&
        other.isVisible == isVisible;
  }

  @override
  int get hashCode {
    return selectedIndex.hashCode ^
        previousIndex.hashCode ^
        isAnimating.hashCode ^
        isVisible.hashCode;
  }
}

/// Navigation item configuration
class NavigationItemConfig {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool requiresAuth;
  final Map<String, dynamic>? routeParams;

  const NavigationItemConfig({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.requiresAuth = true,
    this.routeParams,
  });
}

/// Navigation configuration for Future Talk
class NavigationConfig {
  static const List<NavigationItemConfig> mainNavigation = [
    NavigationItemConfig(
      route: '/dashboard',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    NavigationItemConfig(
      route: '/chat-tab',
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Chat',
    ),
    NavigationItemConfig(
      route: '/capsule-tab',
      icon: Icons.access_time_outlined,
      activeIcon: Icons.access_time_filled,
      label: 'Capsule',
    ),
    NavigationItemConfig(
      route: '/read-tab',
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
      label: 'Read',
    ),
  ];

  /// Get navigation item by index
  static NavigationItemConfig? getItemByIndex(int index) {
    if (index >= 0 && index < mainNavigation.length) {
      return mainNavigation[index];
    }
    return null;
  }

  /// Get navigation index by route
  static int getIndexByRoute(String route) {
    for (int i = 0; i < mainNavigation.length; i++) {
      if (mainNavigation[i].route == route) {
        return i;
      }
    }
    return 0; // Default to first tab
  }
}

/// Navigation provider class
class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState(
    lastNavigationTime: DateTime.now(),
  ));

  /// Minimum time between navigation calls to prevent rapid tapping
  static const Duration minNavigationInterval = Duration(milliseconds: 300);

  /// Navigate to specific tab index
  void navigateToTab(int index, {BuildContext? context}) {
    // Prevent rapid navigation
    if (_isNavigationTooRapid()) return;
    
    // Validate index
    if (index < 0 || index >= NavigationConfig.mainNavigation.length) return;
    
    // Don't navigate if already on the same tab
    if (state.selectedIndex == index && !state.isAnimating) return;

    final item = NavigationConfig.getItemByIndex(index);
    if (item == null) return;

    // Update state with animation flag
    state = state.copyWith(
      previousIndex: state.selectedIndex,
      selectedIndex: index,
      isAnimating: true,
      lastNavigationTime: DateTime.now(),
      navigationHistory: [...state.navigationHistory, index].take(10).toList(),
    );

    // Navigate using GoRouter if context provided
    if (context != null) {
      context.go(item.route, extra: item.routeParams);
    }

    // Clear animation flag after animation duration
    Future.delayed(AppDurations.tabChange, () {
      if (mounted) {
        state = state.copyWith(isAnimating: false);
      }
    });
  }

  /// Navigate to specific route
  void navigateToRoute(String route, {BuildContext? context}) {
    final index = NavigationConfig.getIndexByRoute(route);
    navigateToTab(index, context: context);
  }

  /// Go back to previous tab in history
  void navigateBack({BuildContext? context}) {
    if (state.navigationHistory.length > 1) {
      final history = [...state.navigationHistory];
      history.removeLast(); // Remove current
      final previousIndex = history.last;
      
      state = state.copyWith(
        navigationHistory: history,
      );
      
      navigateToTab(previousIndex, context: context);
    }
  }

  /// Set navigation visibility
  void setNavigationVisibility(bool isVisible) {
    state = state.copyWith(isVisible: isVisible);
  }

  /// Update custom navigation data
  void updateCustomData(String key, dynamic value) {
    final newCustomData = {...state.customData};
    newCustomData[key] = value;
    
    state = state.copyWith(customData: newCustomData);
  }

  /// Clear custom navigation data
  void clearCustomData([String? key]) {
    if (key != null) {
      final newCustomData = {...state.customData};
      newCustomData.remove(key);
      state = state.copyWith(customData: newCustomData);
    } else {
      state = state.copyWith(customData: {});
    }
  }

  /// Reset navigation state
  void resetNavigation() {
    state = NavigationState(
      selectedIndex: 0,
      lastNavigationTime: DateTime.now(),
      navigationHistory: [0],
    );
  }

  /// Check if navigation is happening too rapidly
  bool _isNavigationTooRapid() {
    final now = DateTime.now();
    final timeSinceLastNav = now.difference(state.lastNavigationTime);
    return timeSinceLastNav < minNavigationInterval;
  }

  /// Get current route
  String get currentRoute {
    final item = NavigationConfig.getItemByIndex(state.selectedIndex);
    return item?.route ?? '/';
  }

  /// Get current navigation item
  NavigationItemConfig? get currentItem {
    return NavigationConfig.getItemByIndex(state.selectedIndex);
  }

  /// Check if tab is selected
  bool isTabSelected(int index) {
    return state.selectedIndex == index;
  }

  /// Get navigation history as routes
  List<String> get routeHistory {
    return state.navigationHistory
        .map((index) => NavigationConfig.getItemByIndex(index)?.route)
        .where((route) => route != null)
        .cast<String>()
        .toList();
  }
}

/// Navigation state provider
final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);

/// Current selected index provider (for easy access)
final selectedIndexProvider = Provider<int>((ref) {
  return ref.watch(navigationProvider).selectedIndex;
});

/// Previous selected index provider (for animations)
final previousIndexProvider = Provider<int>((ref) {
  return ref.watch(navigationProvider).previousIndex;
});

/// Navigation visibility provider
final navigationVisibilityProvider = Provider<bool>((ref) {
  return ref.watch(navigationProvider).isVisible;
});

/// Navigation animation state provider
final navigationAnimatingProvider = Provider<bool>((ref) {
  return ref.watch(navigationProvider).isAnimating;
});

/// Current route provider
final currentRouteProvider = Provider<String>((ref) {
  final navigationNotifier = ref.read(navigationProvider.notifier);
  return navigationNotifier.currentRoute;
});

/// Navigation helper functions
class NavigationHelpers {
  /// Navigate with haptic feedback
  static void navigateWithFeedback(
    WidgetRef ref, 
    int index, {
    BuildContext? context,
  }) {
    // Add haptic feedback here when integrated
    ref.read(navigationProvider.notifier).navigateToTab(index, context: context);
  }

  /// Smart navigation that handles special cases
  static void smartNavigate(
    WidgetRef ref,
    int index, {
    BuildContext? context,
    Map<String, dynamic>? customData,
  }) {
    final notifier = ref.read(navigationProvider.notifier);
    
    // Add custom data if provided
    if (customData != null) {
      customData.forEach((key, value) {
        notifier.updateCustomData(key, value);
      });
    }
    
    // Handle special navigation logic
    final item = NavigationConfig.getItemByIndex(index);
    if (item != null) {
      // Add any special handling for specific routes here
      switch (item.route) {
        case '/profile':
          // Could add profile-specific logic
          break;
        case '/chat':
          // Could add chat-specific logic
          break;
      }
    }
    
    navigateWithFeedback(ref, index, context: context);
  }

  /// Get navigation item icon based on state
  static IconData getNavigationIcon(int index, bool isSelected) {
    final item = NavigationConfig.getItemByIndex(index);
    if (item == null) return Icons.help_outline;
    
    return isSelected ? item.activeIcon : item.icon;
  }

  /// Get navigation item label
  static String getNavigationLabel(int index) {
    final item = NavigationConfig.getItemByIndex(index);
    return item?.label ?? '';
  }
}

/// Navigation middleware for handling route changes
class NavigationMiddleware {
  /// Handle route change with navigation state update
  static void handleRouteChange(WidgetRef ref, String newRoute) {
    final index = NavigationConfig.getIndexByRoute(newRoute);
    final currentIndex = ref.read(navigationProvider).selectedIndex;
    
    // Update navigation state if route changed externally
    if (index != currentIndex) {
      ref.read(navigationProvider.notifier).navigateToTab(index);
    }
  }

  /// Handle navigation guard checks
  static bool canNavigateToIndex(WidgetRef ref, int index) {
    final item = NavigationConfig.getItemByIndex(index);
    if (item == null) return false;
    
    // Add any authentication or permission checks here
    if (item.requiresAuth) {
      // Check auth state
      // return ref.read(authProvider).isAuthenticated;
    }
    
    return true;
  }
}