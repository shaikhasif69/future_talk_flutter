import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../../../shared/widgets/ft_button.dart';
import '../providers/chat_list_provider.dart';
import '../widgets/chat_list_header.dart';
import '../widgets/chat_item_tile.dart';
import '../widgets/quiet_hours_banner.dart';
import '../widgets/chat_section_divider.dart';
import '../widgets/chat_floating_action_button.dart';

/// Premium chat list screen with introvert-friendly design
/// Features staggered animations, social battery awareness, and gentle interactions
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late ChatListProvider _chatProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatProvider = ChatListProvider();
    
    // Add scroll listener for potential pull-to-refresh
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _chatProvider.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Future: Implement scroll-based loading or header animations
  }

  Future<void> _onRefresh() async {
    await _chatProvider.refreshConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filters
            ChatListHeader(
              provider: _chatProvider,
              onSearchChanged: _chatProvider.updateSearchQuery,
              onFilterChanged: _chatProvider.setFilter,
            ),
            
            // Chat list content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                backgroundColor: AppColors.pearlWhite,
                color: AppColors.sageGreen,
                strokeWidth: 2.0,
                child: ListenableBuilder(
                  listenable: _chatProvider,
                  builder: (context, _) {
                    if (_chatProvider.isLoading) {
                      return _buildLoadingState();
                    }

                    if (!_chatProvider.hasConversations) {
                      return _buildEmptyState();
                    }

                    return _buildChatList();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Floating action button for new chats
      floatingActionButton: ChatFloatingActionButton(
        onPressed: _showNewChatDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildChatList() {
    final groupedConversations = _chatProvider.groupedConversations;
    
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Quiet hours banner
        if (_chatProvider.isQuietHours)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.spacingS,
              ),
              child: FTStaggerAnimation(
                delay: const Duration(milliseconds: 100),
                child: QuietHoursBanner(
                  isActive: _chatProvider.isQuietHours,
                  onToggle: _chatProvider.toggleQuietHours,
                ),
              ),
            ),
          ),
        
        // Grouped chat sections
        ...groupedConversations.entries.map((entry) {
          final sectionTitle = entry.key;
          final conversations = entry.value;
          
          return SliverMainAxisGroup(
            slivers: [
              // Section divider
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.paddingM,
                    AppDimensions.paddingM,
                    AppDimensions.paddingM,
                    AppDimensions.spacingS,
                  ),
                  child: ChatSectionDivider(title: sectionTitle),
                ),
              ),
              
              // Chat items in this section
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= conversations.length) return null;
                    
                    final conversation = conversations[index];
                    final globalIndex = _getGlobalAnimationIndex(
                      sectionTitle, 
                      index,
                      groupedConversations,
                    );
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                      ),
                      child: FTStaggerAnimation(
                        delay: Duration(milliseconds: globalIndex * 50),
                        slideDirection: FTStaggerSlideDirection.fromBottom,
                        child: ChatItemTile(
                          conversation: conversation,
                          onTap: () => _navigateToChat(conversation.id),
                          onLongPress: () => _showChatOptions(conversation),
                        ),
                      ),
                    );
                  },
                  childCount: conversations.length,
                ),
              ),
            ],
          );
        }).toList(),
        
        // Bottom padding for FAB
        const SliverToBoxAdapter(
          child: SizedBox(height: 80.0),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Loading conversations...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 40.0,
                color: AppColors.pearlWhite,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Text(
              'No conversations yet',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              _chatProvider.searchQuery.isNotEmpty
                  ? 'No conversations match your search'
                  : 'Start a conversation to connect with friends',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (_chatProvider.searchQuery.isEmpty) ...[
              const SizedBox(height: AppDimensions.spacingXL),
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 300),
                child: ElevatedButton.icon(
                  onPressed: _showNewChatDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Start a conversation'),
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
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get global animation index for staggered animations across all sections
  int _getGlobalAnimationIndex(
    String currentSection,
    int indexInSection,
    Map<String, List<dynamic>> groupedConversations,
  ) {
    int globalIndex = 0;
    
    for (final entry in groupedConversations.entries) {
      if (entry.key == currentSection) {
        return globalIndex + indexInSection;
      }
      globalIndex += entry.value.length;
    }
    
    return globalIndex + indexInSection;
  }

  void _navigateToChat(String conversationId) {
    // Mark conversation as read
    _chatProvider.markAsRead(conversationId);
    
    // Navigate to individual chat screen
    // TODO: Implement navigation to chat detail screen
    debugPrint('Navigate to chat: $conversationId');
  }

  void _showChatOptions(dynamic conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pearlWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      builder: (context) => _buildChatOptionsSheet(conversation),
    );
  }

  Widget _buildChatOptionsSheet(dynamic conversation) {
    return SafeArea(
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
                conversation.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: AppColors.sageGreen,
              ),
              title: Text(
                conversation.isPinned ? 'Unpin' : 'Pin',
                style: AppTextStyles.bodyMedium,
              ),
              onTap: () {
                _chatProvider.togglePin(conversation.id);
                Navigator.pop(context);
              },
            ),
            
            ListTile(
              leading: Icon(
                conversation.isMuted 
                    ? Icons.volume_up_outlined 
                    : Icons.volume_off_outlined,
                color: AppColors.softCharcoal,
              ),
              title: Text(
                conversation.isMuted ? 'Unmute' : 'Mute',
                style: AppTextStyles.bodyMedium,
              ),
              onTap: () {
                _chatProvider.toggleMute(conversation.id);
                Navigator.pop(context);
              },
            ),
            
            if (conversation.unreadCount > 0)
              ListTile(
                leading: const Icon(
                  Icons.mark_chat_read_outlined,
                  color: AppColors.sageGreen,
                ),
                title: Text(
                  'Mark as read',
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  _chatProvider.markAsRead(conversation.id);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showNewChatDialog() {
    // TODO: Implement new chat dialog
    debugPrint('Show new chat dialog');
  }
}