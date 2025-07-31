import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'chat_list_screen.dart';

/// Example integration showing how to use the ChatListScreen
/// This demonstrates the proper way to integrate the chat list into your app
class ChatListIntegrationExample extends StatelessWidget {
  const ChatListIntegrationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatListScreen();
  }
}

/// Example of how to integrate the chat list into a bottom navigation structure
class MainAppWithChatList extends StatefulWidget {
  const MainAppWithChatList({super.key});

  @override
  State<MainAppWithChatList> createState() => _MainAppWithChatListState();
}

class _MainAppWithChatListState extends State<MainAppWithChatList> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    // Replace these with your actual screens
    const _PlaceholderScreen(title: 'Home', icon: Icons.home),
    const _PlaceholderScreen(title: 'Time Capsules', icon: Icons.schedule),
    const ChatListScreen(), // Our premium chat list
    const _PlaceholderScreen(title: 'Profile', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppColors.pearlWhite,
        selectedItemColor: AppColors.sageGreen,
        unselectedItemColor: AppColors.softCharcoalLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_outlined),
            activeIcon: Icon(Icons.schedule),
            label: 'Capsules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Placeholder screen for demonstration
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.0,
              color: AppColors.softCharcoalLight,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'This screen will be implemented soon!',
              style: const TextStyle(
                fontSize: 16.0,
                color: AppColors.softCharcoalLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of how to navigate to the chat list from other screens
class NavigationToChatsExample extends StatelessWidget {
  const NavigationToChatsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate to Chats Example'),
        backgroundColor: AppColors.sageGreen,
        foregroundColor: AppColors.pearlWhite,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Chat Navigation Examples',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Navigate to chat list
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatListScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Open Chat List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sageGreen,
                foregroundColor: AppColors.pearlWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingXL,
                  vertical: AppDimensions.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            // Replace current screen with chat list
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatListScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Replace with Chat List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lavenderMist,
                foregroundColor: AppColors.softCharcoal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingXL,
                  vertical: AppDimensions.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example showing how to pass data to the chat list (if needed in the future)
class ChatListWithDataExample extends StatelessWidget {
  const ChatListWithDataExample({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, the ChatListScreen manages its own data via the provider
    // In the future, you might want to pass external data or configuration
    return const ChatListScreen();
  }
}

/// Example of how to handle chat navigation from the chat list
class ChatNavigationHandler {
  static void navigateToIndividualChat(
    BuildContext context,
    String conversationId,
  ) {
    // TODO: Navigate to individual chat screen
    debugPrint('Navigate to individual chat: $conversationId');
    
    // Example navigation (replace with your actual chat screen):
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => IndividualChatScreen(
    //       conversationId: conversationId,
    //     ),
    //   ),
    // );
  }

  static void navigateToGroupChat(
    BuildContext context,
    String conversationId,
  ) {
    // TODO: Navigate to group chat screen
    debugPrint('Navigate to group chat: $conversationId');
    
    // Example navigation (replace with your actual group chat screen):
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => GroupChatScreen(
    //       conversationId: conversationId,
    //     ),
    //   ),
    // );
  }

  static void showNewChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.pearlWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        title: const Text(
          'Start New Conversation',
          style: TextStyle(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Choose how you\'d like to start a new conversation:',
          style: TextStyle(
            color: AppColors.softCharcoalLight,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to new individual chat
              debugPrint('Start new individual chat');
            },
            icon: const Icon(Icons.person_add_outlined),
            label: const Text('Individual Chat'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.sageGreen,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to new group chat
              debugPrint('Start new group chat');
            },
            icon: const Icon(Icons.group_add_outlined),
            label: const Text('Group Chat'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.sageGreen,
            ),
          ),
        ],
      ),
    );
  }
}