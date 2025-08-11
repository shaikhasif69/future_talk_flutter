import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_button.dart';
import '../../friends/models/friend_search_models.dart';
import 'find_friends_modal_helper.dart';
import '../types/friend_action.dart';

/// Example usage of the FindFriendsModal
/// This demonstrates how to integrate the modal into your app
class FindFriendsModalExample extends StatefulWidget {
  const FindFriendsModalExample({super.key});

  @override
  State<FindFriendsModalExample> createState() => _FindFriendsModalExampleState();
}

class _FindFriendsModalExampleState extends State<FindFriendsModalExample> {
  String _lastActionMessage = 'No actions yet';

  void _showFindFriendsModal() {
    FindFriendsModalHelper.show(
      context,
      onUserAction: (UserLookupResult friend, FriendAction action) {
        Navigator.of(context).pop(); // Close the modal
        
        setState(() {
          _lastActionMessage = 'Action: ${action.name} for ${friend.displayName}';
        });
        
        // Handle the action based on type
        switch (action) {
          case FriendAction.addFriend:
            _handleAddFriend(friend);
            break;
          case FriendAction.sendMessage:
            _handleSendMessage(friend);
            break;
          case FriendAction.sendTimeCapsule:
            _handleSendTimeCapsule(friend);
            break;
        }
      },
    );
  }

  void _handleAddFriend(UserLookupResult friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend request sent to ${friend.displayName}! 🌟'),
        backgroundColor: AppColors.warmPeach,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
    );
  }

  void _handleSendMessage(UserLookupResult friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${friend.displayName}... 💬'),
        backgroundColor: AppColors.cloudBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
    );
    
    // Here you would typically navigate to the chat screen
    // Navigator.of(context).pushNamed('/chat', arguments: friend.id);
  }

  void _handleSendTimeCapsule(UserLookupResult friend) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating time capsule for ${friend.displayName}... ⏰'),
        backgroundColor: AppColors.lavenderMist,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
    );
    
    // Here you would typically navigate to capsule creation
    // Navigator.of(context).pushNamed('/create-capsule', arguments: friend.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: Text(
          'Find Friends Modal Demo',
          style: AppTextStyles.headlineSmall,
        ),
        backgroundColor: AppColors.pearlWhite,
        elevation: 0,
        foregroundColor: AppColors.softCharcoal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Demo Instructions
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
                children: [
                  Text(
                    'FindFriendsModal Demo',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.sageGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    'Try searching for these demo users:',
                    style: AppTextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• "asif" or "asif_quiet_reader"', style: AppTextStyles.bodyMedium),
                      Text('• "sarah" or "sarah.m"', style: AppTextStyles.bodyMedium),
                      Text('• "maya" or "maya.c"', style: AppTextStyles.bodyMedium),
                      Text('• Try "unknown" to see not found state', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Text(
                    _lastActionMessage,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.sageGreen,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingXXL),
            
            // Show Modal Button
            FTButton.primary(
              text: 'Find Friends',
              icon: Icons.person_search,
              onPressed: _showFindFriendsModal,
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            // Additional buttons to demonstrate different entry points
            FTButton.secondary(
              text: 'Add Friend to Chat',
              icon: Icons.chat_bubble_outline,
              onPressed: _showFindFriendsModal,
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            FTButton.outlined(
              text: 'Find Friend for Time Capsule',
              icon: Icons.schedule_outlined,
              onPressed: _showFindFriendsModal,
            ),
          ],
        ),
      ),
    );
  }
}