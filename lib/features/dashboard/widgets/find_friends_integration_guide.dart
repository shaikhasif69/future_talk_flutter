import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_button.dart';
import '../../friends/models/friend_search_models.dart';
import 'find_friends_modal_helper.dart';
import '../types/friend_action.dart';

/// Integration Guide for FindFriendsModal
/// 
/// This file demonstrates how to integrate the FindFriendsModal into various
/// parts of your Future Talk application.

/// Example: Adding to Dashboard Quick Actions
class DashboardWithFindFriends extends StatelessWidget {
  const DashboardWithFindFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          children: [
            // Your existing dashboard content...
            
            // Quick Actions Section with Find Friends
            Container(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.pearlWhite,
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.softCharcoal,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  
                  // Grid of quick actions
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: AppDimensions.spacingM,
                    crossAxisSpacing: AppDimensions.spacingM,
                    childAspectRatio: 1.2,
                    children: [
                      // Find Friends Action
                      _buildQuickActionCard(
                        context,
                        title: 'Find Friends',
                        icon: Icons.person_search,
                        color: AppColors.sageGreen,
                        onTap: () => _showFindFriends(context),
                      ),
                      
                      // Other existing actions...
                      _buildQuickActionCard(
                        context,
                        title: 'Create Capsule',
                        icon: Icons.schedule_outlined,
                        color: AppColors.lavenderMist,
                        onTap: () => _navigateToCreateCapsule(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconXL,
              color: color,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showFindFriends(BuildContext context) {
    FindFriendsModalHelper.show(
      context,
      onUserAction: (UserLookupResult friend, FriendAction action) {
        Navigator.of(context).pop();
        _handleFriendAction(context, friend, action);
      },
    );
  }

  void _handleFriendAction(BuildContext context, UserLookupResult friend, FriendAction action) {
    switch (action) {
      case FriendAction.addFriend:
        // Navigate to friendship management or show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend request sent to ${friend.displayName}!')),
        );
        break;
        
      case FriendAction.sendMessage:
        // Navigate to chat screen
        // Navigator.of(context).pushNamed('/chat', arguments: friend.id);
        break;
        
      case FriendAction.sendTimeCapsule:
        // Navigate to capsule creation with pre-selected friend
        // Navigator.of(context).pushNamed('/create-capsule', arguments: friend.id);
        break;
    }
  }

  void _navigateToCreateCapsule(BuildContext context) {
    // Your existing capsule creation navigation
  }
}

/// Example: Adding to Floating Action Button
class DashboardFABWithFindFriends extends StatelessWidget {
  const DashboardFABWithFindFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your existing dashboard content...
      
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Find Friends FAB
          FloatingActionButton(
            heroTag: "find_friends",
            onPressed: () => _showFindFriends(context),
            backgroundColor: AppColors.sageGreen,
            child: const Icon(
              Icons.person_search,
              color: AppColors.pearlWhite,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          
          // Your existing primary FAB...
          FloatingActionButton.extended(
            heroTag: "primary_action",
            onPressed: () {
              // Your primary action
            },
            backgroundColor: AppColors.lavenderMist,
            icon: const Icon(Icons.add, color: AppColors.pearlWhite),
            label: Text(
              'Create',
              style: AppTextStyles.button,
            ),
          ),
        ],
      ),
    );
  }

  void _showFindFriends(BuildContext context) {
    FindFriendsModalHelper.show(context);
  }
}

/// Example: Adding to App Bar Actions
class ScreenWithFindFriendsInAppBar extends StatelessWidget {
  const ScreenWithFindFriendsInAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: AppTextStyles.headlineSmall,
        ),
        backgroundColor: AppColors.pearlWhite,
        elevation: 0,
        foregroundColor: AppColors.softCharcoal,
        actions: [
          // Find Friends Action in App Bar
          IconButton(
            onPressed: () => _showFindFriends(context),
            icon: const Icon(Icons.person_add_outlined),
            tooltip: 'Find Friends',
          ),
          
          // Other actions...
          IconButton(
            onPressed: () {
              // Other action
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      
      body: const Center(
        child: Text('Your screen content'),
      ),
    );
  }

  void _showFindFriends(BuildContext context) {
    FindFriendsModalHelper.show(
      context,
      onUserAction: (UserLookupResult friend, FriendAction action) {
        Navigator.of(context).pop();
        
        if (action == FriendAction.sendMessage) {
          // Navigate directly to chat with this friend
          // Navigator.of(context).pushNamed('/chat', arguments: friend.id);
        }
      },
    );
  }
}

/// Example: Context Menu Integration
class ChatListItemWithFindFriends extends StatelessWidget {
  const ChatListItemWithFindFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppColors.sageGreen,
        child: Icon(Icons.chat, color: AppColors.pearlWhite),
      ),
      title: Text(
        'Start New Chat',
        style: AppTextStyles.titleMedium,
      ),
      subtitle: Text(
        'Find friends to chat with',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.softCharcoalLight,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.softCharcoalLight,
      ),
      onTap: () => FindFriendsModalHelper.show(
        context,
        onUserAction: (UserLookupResult friend, FriendAction action) {
          Navigator.of(context).pop();
          
          if (action == FriendAction.sendMessage) {
            // Navigate to chat with selected friend
          }
        },
      ),
    );
  }
}

/// Integration with existing provider pattern
class FindFriendsWithProvider extends StatelessWidget {
  const FindFriendsWithProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return FTButton.primary(
      text: 'Find Friends',
      icon: Icons.person_search,
      onPressed: () => FindFriendsModalHelper.show(
        context,
        onUserAction: (UserLookupResult friend, FriendAction action) async {
          Navigator.of(context).pop();
          
          // Use your existing providers to handle the actions
          switch (action) {
            case FriendAction.addFriend:
              // await ref.read(friendsProvider.notifier).addFriend(friend.id);
              break;
            case FriendAction.sendMessage:
              // await ref.read(chatProvider.notifier).startChat(friend.id);
              break;
            case FriendAction.sendTimeCapsule:
              // await ref.read(timeCapsuleProvider.notifier).createCapsule(
              //   recipientId: friend.id,
              // );
              break;
          }
        },
      ),
    );
  }
}