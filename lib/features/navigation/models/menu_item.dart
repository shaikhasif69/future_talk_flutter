import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final String? route;

  MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.route,
  });
}

// Main menu items with navigation routes
List<MenuItem> getMainMenuItems(BuildContext context) => [
  MenuItem(
    icon: Icons.home_rounded,
    title: 'Home',
    route: '/dashboard',
    onTap: () => context.go('/dashboard'),
  ),
  MenuItem(
    icon: Icons.message_rounded,
    title: 'Messages',
    route: '/chat',
    onTap: () => context.go('/chat'),
  ),
  MenuItem(
    icon: Icons.favorite_rounded,
    title: 'Favorites',
    onTap: () => _showComingSoon(context, 'Favorites'),
  ),
  MenuItem(
    icon: Icons.touch_app_rounded,
    title: 'Connection Stones',
    route: '/connection-stones',
    onTap: () => context.go('/connection-stones'),
  ),
  MenuItem(
    icon: Icons.auto_stories_rounded,
    title: 'Reading Together',
    route: '/books',
    onTap: () => context.go('/books'),
  ),
];

// History/Activity menu items with navigation routes
List<MenuItem> getHistoryMenuItems(BuildContext context) => [
  MenuItem(
    icon: Icons.schedule_rounded,
    title: 'Time Capsules',
    route: '/capsule-garden',
    onTap: () => context.go('/capsule-garden'),
  ),
  MenuItem(
    icon: Icons.notifications_rounded,
    title: 'Notifications',
    route: '/notifications',
    onTap: () => context.go('/notifications'),
  ),
];

// Helper method for showing coming soon message
void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$feature feature coming soon!'),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// Backward compatibility - deprecated, use getMainMenuItems(context) instead
final List<MenuItem> mainMenuItems = [
  MenuItem(icon: Icons.home_rounded, title: 'Home'),
  MenuItem(icon: Icons.message_rounded, title: 'Messages'),
  MenuItem(icon: Icons.favorite_rounded, title: 'Favorites'),
  MenuItem(icon: Icons.touch_app_rounded, title: 'Connection Stones'),
  MenuItem(icon: Icons.auto_stories_rounded, title: 'Reading Together'),
];

// Backward compatibility - deprecated, use getHistoryMenuItems(context) instead
final List<MenuItem> historyMenuItems = [
  MenuItem(icon: Icons.schedule_rounded, title: 'Time Capsules'),
  MenuItem(icon: Icons.notifications_rounded, title: 'Notifications'),
];