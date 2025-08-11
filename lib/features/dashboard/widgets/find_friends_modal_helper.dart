import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../friends/models/friend_search_models.dart';
import '../types/friend_action.dart';
import 'find_friends_modal.dart';

/// Helper class to show FindFriendsModal
class FindFriendsModalHelper {
  /// Static method to show the modal
  static Future<void> show(
    BuildContext context, {
    void Function(UserLookupResult user, FriendAction action)? onUserAction,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.softCharcoal.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return FindFriendsModal(
          onUserAction: onUserAction,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}