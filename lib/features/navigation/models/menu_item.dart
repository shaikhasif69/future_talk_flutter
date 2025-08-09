import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });
}

// Main menu items
final List<MenuItem> mainMenuItems = [
  MenuItem(
    icon: Icons.home_rounded,
    title: 'Home',
  ),
  MenuItem(
    icon: Icons.message_rounded,
    title: 'Messages',
  ),
  MenuItem(
    icon: Icons.favorite_rounded,
    title: 'Favorites',
  ),
  MenuItem(
    icon: Icons.touch_app_rounded,
    title: 'Connection Stones',
  ),
  MenuItem(
    icon: Icons.auto_stories_rounded,
    title: 'Reading Together',
  ),
];

// History/Activity menu items
final List<MenuItem> historyMenuItems = [
  MenuItem(
    icon: Icons.schedule_rounded,
    title: 'Time Capsules',
  ),
  MenuItem(
    icon: Icons.notifications_rounded,
    title: 'Notifications',
  ),
];