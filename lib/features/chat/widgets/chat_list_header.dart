import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/animations/ft_fade_in.dart';
import '../providers/realtime_chat_list_provider.dart';
import 'chat_search_bar.dart';
import 'chat_filter_tabs.dart';

/// Premium chat list header with search and filtering
/// Features smooth animations and introvert-friendly interactions
class ChatListHeader extends StatelessWidget {
  const ChatListHeader({
    super.key,
    required this.provider,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  final RealtimeChatListProvider provider;
  final Function(String) onSearchChanged;
  final Function(ChatFilter) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withOpacity( 0.95),
        boxShadow: [
          BoxShadow(
            color: AppColors.softCharcoal.withOpacity( 0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header top section with title and actions
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingM,
              AppDimensions.spacingM,
              AppDimensions.paddingM,
              AppDimensions.spacingS,
            ),
            child: FTFadeIn(
              child: _buildHeaderTop(context),
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.spacingS,
            ),
            child: ChatSearchBar(
              searchQuery: provider.searchQuery,
              onSearchChanged: onSearchChanged,
              onClearSearch: provider.clearSearch,
            ),
          ),
          
          // Filter tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingM,
              AppDimensions.spacingS,
              AppDimensions.paddingM,
              AppDimensions.spacingM,
            ),
            child: ChatFilterTabs(
              activeFilter: provider.activeFilter,
              filterCounts: provider.filterCounts,
              onFilterChanged: onFilterChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTop(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title with unread count
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Conversations',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.softCharcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (provider.totalUnreadCount > 0) ...[
                    const SizedBox(width: AppDimensions.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingS,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sageGreen,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '${provider.totalUnreadCount}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.pearlWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (provider.isQuietHours)
                const SizedBox(height: 2.0),
              if (provider.isQuietHours)
                Row(
                  children: [
                    const Icon(
                      Icons.nightlight_round,
                      size: 12.0,
                      color: AppColors.softCharcoalLight,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'Quiet hours active',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        
        // Header actions
        Row(
          children: [
            _buildHeaderAction(
              icon: Icons.search,
              tooltip: 'Search conversations',
              onTap: () => _focusSearch(context),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            _buildHeaderAction(
              icon: Icons.group_add_outlined,
              tooltip: 'Create group',
              onTap: () => _showCreateGroupDialog(context),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            _buildHeaderAction(
              icon: Icons.more_vert,
              tooltip: 'More options',
              onTap: () => _showMoreOptions(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          onTap: onTap,
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: AppColors.sageGreen.withOpacity( 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(
              icon,
              size: 20.0,
              color: AppColors.sageGreen,
            ),
          ),
        ),
      ),
    );
  }

  void _focusSearch(BuildContext context) {
    // Find the search bar and focus it
    // This will be handled by the ChatSearchBar widget
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.pearlWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        title: Text(
          'Create Group',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Group creation feature coming soon! This will let you create book clubs, game nights, and other interest-based groups.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: AppTextStyles.button.copyWith(
                color: AppColors.sageGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pearlWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40.0,
                height: 4.0,
                margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.whisperGray,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              
              // Options
              ListTile(
                leading: Icon(
                  provider.isQuietHours 
                      ? Icons.nightlight_round 
                      : Icons.wb_sunny_outlined,
                  color: AppColors.sageGreen,
                ),
                title: Text(
                  provider.isQuietHours 
                      ? 'Disable quiet hours' 
                      : 'Enable quiet hours',
                  style: AppTextStyles.bodyMedium,
                ),
                subtitle: Text(
                  provider.isQuietHours
                      ? 'Allow all notifications'
                      : 'Gentle notifications only',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
                onTap: () {
                  provider.toggleQuietHours();
                  Navigator.pop(context);
                },
              ),
              
              ListTile(
                leading: const Icon(
                  Icons.archive_outlined,
                  color: AppColors.softCharcoal,
                ),
                title: Text(
                  'Archived chats',
                  style: AppTextStyles.bodyMedium,
                ),
                subtitle: Text(
                  'View archived conversations',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
              ),
              
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.softCharcoal,
                ),
                title: Text(
                  'Chat settings',
                  style: AppTextStyles.bodyMedium,
                ),
                subtitle: Text(
                  'Manage notifications and preferences',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}