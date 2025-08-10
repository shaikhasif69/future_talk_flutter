import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../providers/realtime_chat_provider.dart';
import '../services/websocket_service.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
import '../models/social_battery_status.dart';
import '../widgets/chat_item_tile.dart';
import '../widgets/quiet_hours_banner.dart';
import '../widgets/chat_section_divider.dart';
import '../widgets/chat_floating_action_button.dart';
import '../widgets/connection_status_indicator.dart';
import '../screens/individual_chat_screen.dart';
import '../services/pinned_conversations_service.dart';

/// Premium chat list screen with introvert-friendly design
/// Features staggered animations, social battery awareness, and gentle interactions
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  RealtimeChatProvider? _chatProvider;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  // UI State
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchFocused = false;
  
  // Filter options
  final List<String> _filterOptions = ['All', 'Friends', 'Groups', 'Unread'];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }
  
  Future<void> _initializeServices() async {
    // Initialize Hive for local storage
    await PinnedConversationsService.initialize();
    
    // Initialize quiet hours service
    QuietHoursService.initialize();
    
    // Use the singleton chat provider
    _chatProvider = realtimeChatProvider;
    
    // Initialize provider only if not already initialized
    if (!_chatProvider!.isInitialized) {
      await _chatProvider!.initialize();
    }
    
    // Add scroll listener
    _scrollController.addListener(_onScroll);
    
    // Add search listener
    _searchController.addListener(_onSearchChanged);
    
    // Update UI
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    // Don't dispose the singleton provider - it should persist across the app
    super.dispose();
  }

  void _onScroll() {
    // Hide keyboard when scrolling
    if (_isSearchFocused) {
      FocusScope.of(context).unfocus();
    }
  }
  
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }
  
  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  Future<void> _onRefresh() async {
    await _chatProvider?.loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back action
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Navigate to dashboard instead of exiting the app
          context.go('/dashboard');
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filters (matching HTML app-header)
            _buildChatListHeader(),
            
            // Quiet hours banner (matching HTML quiet-hours)
            QuietHoursBanner(
              isVisible: QuietHoursService.isQuietHours,
              endTime: QuietHoursService.endTime,
              onDismiss: () => setState(() {}),
            ),
            
            // Chat list content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                backgroundColor: AppColors.pearlWhite,
                color: AppColors.sageGreen,
                strokeWidth: 2.0,
                child: _chatProvider == null
                    ? _buildLoadingState()
                    : ListenableBuilder(
                        listenable: _chatProvider!,
                        builder: (context, _) {
                          if (!_chatProvider!.isInitialized) {
                            return _buildLoadingState();
                          }

                          if (_chatProvider!.conversations.isEmpty) {
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
      ),
    );
  }

  Widget _buildChatList() {
    final conversations = _getFilteredConversations();
    debugPrint('📋 [ChatListScreen] Building chat list with ${conversations.length} conversations');
    
    if (conversations.isEmpty && _searchQuery.isNotEmpty) {
      return _buildSearchEmptyState();
    }
    
    // Group conversations properly (Pinned, Recent, Earlier)
    final groupedConversations = _groupConversations(conversations);
    
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // TODO: Implement quiet hours functionality
        
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
                    debugPrint('🎨 [ChatListScreen] Building chat item for: ${conversation.displayName} (index: $index)');
                    
                    final uiConversation = _convertToUiModel(conversation);
                    final globalIndex = _getGlobalAnimationIndex(
                      sectionTitle, 
                      index,
                      groupedConversations,
                    );
                    
                    // Add animation delay based on section and index
                    final animationDelay = globalIndex * 50;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                      ),
                      child: FTStaggerAnimation(
                        delay: Duration(milliseconds: animationDelay),
                        slideDirection: FTStaggerSlideDirection.fromBottom,
                        child: ChatItemTile(
                          conversation: uiConversation,
                          onTap: () => _navigateToChat(conversation.id),
                          onLongPress: () => _showChatOptions(uiConversation),
                        ),
                      ),
                    );
                  },
                  childCount: conversations.length,
                ),
              ),
            ],
          );
        }),
        
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
              'Start a conversation to connect with friends',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
            // Always show the start conversation button
            ...[
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

  /// Filter conversations based on search and filter criteria
  List<Conversation> _getFilteredConversations() {
    if (_chatProvider == null) return [];
    List<Conversation> conversations = List.from(_chatProvider!.conversations);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      conversations = conversations.where((conversation) {
        final displayName = conversation.displayName.toLowerCase();
        final lastMessageContent = (conversation.lastMessage?.content ?? '').toLowerCase();
        return displayName.contains(_searchQuery) || 
               lastMessageContent.contains(_searchQuery);
      }).toList();
    }
    
    // Apply category filter
    switch (_selectedFilter) {
      case 'Friends':
        conversations = conversations.where((c) => c.isDirect).toList();
        break;
      case 'Groups':
        conversations = conversations.where((c) => c.isGroup).toList();
        break;
      case 'Unread':
        conversations = conversations.where((c) => c.hasUnreadMessages).toList();
        break;
      case 'All':
      default:
        // No additional filtering
        break;
    }
    
    // Sort conversations: pinned first, then by last message time
    conversations.sort((a, b) {
      final aPinned = PinnedConversationsService.isConversationPinned(a.id);
      final bPinned = PinnedConversationsService.isConversationPinned(b.id);
      
      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;
      
      return b.lastMessageAt.compareTo(a.lastMessageAt);
    });
    
    return conversations;
  }
  
  /// Group conversations by sections (Pinned, Recent, Earlier)
  Map<String, List<Conversation>> _groupConversations(List<Conversation> conversations) {
    final Map<String, List<Conversation>> grouped = {};
    
    final pinnedConversations = <Conversation>[];
    final recentConversations = <Conversation>[];
    final earlierConversations = <Conversation>[];
    
    final now = DateTime.now();
    
    for (final conversation in conversations) {
      final isPinned = PinnedConversationsService.isConversationPinned(conversation.id);
      
      if (isPinned) {
        pinnedConversations.add(conversation);
      } else {
        final daysDifference = now.difference(conversation.lastMessageAt).inDays;
        
        if (daysDifference < 7) {
          recentConversations.add(conversation);
        } else {
          earlierConversations.add(conversation);
        }
      }
    }
    
    if (pinnedConversations.isNotEmpty) {
      grouped['Pinned'] = pinnedConversations;
    }
    if (recentConversations.isNotEmpty) {
      grouped['Recent'] = recentConversations;
    }
    if (earlierConversations.isNotEmpty) {
      grouped['Earlier'] = earlierConversations;
    }
    
    return grouped;
  }
  
  /// Build empty state for search results
  Widget _buildSearchEmptyState() {
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
                color: AppColors.sageGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 40.0,
                color: AppColors.sageGreen,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Text(
              'No conversations found',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Try adjusting your search or filters',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  /// Convert Conversation model to ChatConversation for UI compatibility
  ChatConversation _convertToUiModel(Conversation conversation) {
    debugPrint('🔄 [ChatListScreen] Converting conversation to UI model: ${conversation.id}');
    debugPrint('🔄 [ChatListScreen] - Display name: ${conversation.displayName}');
    debugPrint('🔄 [ChatListScreen] - Last message: ${conversation.lastMessage?.content}');
    debugPrint('🔄 [ChatListScreen] - Last message time: ${conversation.lastMessage?.createdAt}');
    debugPrint('🔄 [ChatListScreen] - Unread count: ${conversation.unreadCount}');
    debugPrint('🔄 [ChatListScreen] - Participants count: ${conversation.participants.length}');
    
    // Convert API Participants to ChatParticipants for UI
    // For direct chats, filter out current user to show only the other participant
    final relevantParticipants = conversation.participants.where((participant) {
      // For direct chats, exclude current user; for groups, include all
      if (conversation.conversationType == ConversationType.direct) {
        final isCurrentUser = participant.userId == (_chatProvider?.currentUserId ?? '');
        debugPrint('🔄 [ChatListScreen] - Checking participant ${participant.username}: isCurrentUser=$isCurrentUser');
        return !isCurrentUser;
      }
      return true;
    }).toList();
    
    final chatParticipants = relevantParticipants.map((participant) {
      debugPrint('🔄 [ChatListScreen] - Converting participant: ${participant.username} (${participant.userId})');
      return ChatParticipant(
        id: participant.userId,
        name: participant.username,
        avatarColor: _getAvatarColorFromId(participant.userId),
        socialBattery: _getSocialBatteryForUser(participant.userId), // Add social battery
        isOnline: false, // TODO: Integrate with presence system
        lastSeen: null, // TODO: Integrate with presence system
      );
    }).toList();
    
    debugPrint('🔄 [ChatListScreen] - Final participants count: ${chatParticipants.length}');
    if (chatParticipants.isNotEmpty) {
      debugPrint('🔄 [ChatListScreen] - First participant: ${chatParticipants.first.name}');
    }

    // Apply local UI preferences from Hive storage
    final isPinned = PinnedConversationsService.isConversationPinned(conversation.id);
    final isMuted = PinnedConversationsService.isConversationMuted(conversation.id);
    
    final uiConversation = ChatConversation.fromConversation(
      conversation,
      chatParticipants: chatParticipants,
    ).copyWith(
      isPinned: isPinned,
      isMuted: isMuted,
      isQuietHours: QuietHoursService.isQuietHours,
    );
    
    debugPrint('✅ [ChatListScreen] UI model created successfully');
    return uiConversation;
  }

  /// Generate consistent avatar color from user ID
  Color _getAvatarColorFromId(String userId) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
    ];
    final index = userId.hashCode % colors.length;
    return colors[index.abs()];
  }
  
  /// Get social battery status for a user (mock implementation)
  /// TODO: Replace with real social battery data from API
  SocialBatteryStatus? _getSocialBatteryForUser(String userId) {
    // Generate consistent battery status based on user ID hash
    final statusIndex = userId.hashCode % 4;
    switch (statusIndex.abs()) {
      case 0:
        return SocialBatteryPresets.energized();
      case 1:
        return SocialBatteryPresets.selective();
      case 2:
        return SocialBatteryPresets.recharging();
      default:
        return null; // No battery status
    }
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
    debugPrint('🚀 [ChatListScreen] Navigating to chat: $conversationId');
    
    if (_chatProvider == null) return;
    
    // Find the conversation
    final conversation = _chatProvider!.conversations.firstWhere(
      (c) => c.id == conversationId,
      orElse: () => throw Exception('Conversation not found: $conversationId'),
    );
    
    // Select the conversation in the provider
    _chatProvider!.selectConversation(conversationId);
    
    // Convert to UI model for navigation
    final chatConversation = _convertToUiModel(conversation);
    
    // Navigate to individual chat screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IndividualChatScreen(
          conversation: chatConversation,
        ),
      ),
    );
    
    debugPrint('✅ [ChatListScreen] Navigation initiated successfully');
  }

  void _showChatOptions(ChatConversation conversation) {
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

  Widget _buildChatOptionsSheet(ChatConversation conversation) {
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
              onTap: () async {
                Navigator.pop(context); // Pop first to avoid async context usage
                final success = await PinnedConversationsService.togglePinConversation(conversation.id);
                if (success && mounted) {
                  setState(() {}); // Refresh UI
                }
              },
            ),
            
            ListTile(
              leading: Icon(
                conversation.isMuted ? Icons.volume_up : Icons.volume_off_outlined,
                color: AppColors.softCharcoal,
              ),
              title: Text(
                conversation.isMuted ? 'Unmute' : 'Mute',
                style: AppTextStyles.bodyMedium,
              ),
              onTap: () async {
                Navigator.pop(context); // Pop first to avoid async context usage
                final success = await PinnedConversationsService.toggleMuteConversation(conversation.id);
                if (success && mounted) {
                  setState(() {}); // Refresh UI
                }
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
                  // TODO: Implement mark as read
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Build chat list header matching HTML reference design
  Widget _buildChatListHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.paddingL,
        AppDimensions.paddingM,
        AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.sageGreen.withValues(alpha: 0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header top row (title and actions)
          Row(
            children: [
              // Title (matching HTML header-title)
              Text(
                'Conversations',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.softCharcoal,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                ),
              ),
              
              const Spacer(),
              
              // Header actions (matching HTML header-actions)
              Row(
                children: [
                  // Search button
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: AppColors.sageGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 16.0,
                      color: AppColors.sageGreen,
                    ),
                  ),
                  
                  const SizedBox(width: 12.0),
                  
                  // New group button
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: AppColors.sageGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(
                      Icons.group,
                      size: 16.0,
                      color: AppColors.sageGreen,
                    ),
                  ),
                  
                  const SizedBox(width: 12.0),
                  
                  // Settings button with connection status
                  Stack(
                    children: [
                      Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: AppColors.sageGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.settings,
                          size: 16.0,
                          color: AppColors.sageGreen,
                        ),
                      ),
                      
                      // Connection status indicator (top right)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: ConnectionStatusIndicator(
                          connectionState: _chatProvider?.connectionState ?? WebSocketConnectionState.disconnected,
                          showLabel: false,
                          size: 8.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16.0),
          
          // Search input (matching HTML search-container)
          Container(
            decoration: BoxDecoration(
              color: AppColors.sageGreen.withValues(alpha: 0.05),
              border: Border.all(
                color: AppColors.sageGreen.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextField(
              controller: _searchController,
              onTap: () => setState(() => _isSearchFocused = true),
              onEditingComplete: () => setState(() => _isSearchFocused = false),
              decoration: InputDecoration(
                hintText: _isSearchFocused ? 'Search by name or message...' : 'Search conversations...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 16.0,
                  color: AppColors.softCharcoalLight.withValues(alpha: 0.7),
                ),
                suffixIcon: _searchQuery.isNotEmpty ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 16.0,
                    color: AppColors.softCharcoalLight.withValues(alpha: 0.7),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ) : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Filter tabs (matching HTML filter-tabs)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.map((filter) {
                final isActive = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildFilterTab(filter, isActive),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build filter tab matching HTML design
  Widget _buildFilterTab(String label, bool isActive) {
    return GestureDetector(
      onTap: () => _onFilterChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.sageGreen 
              : AppColors.sageGreen.withValues(alpha: 0.05),
          border: Border.all(
            color: isActive 
                ? AppColors.sageGreen 
                : AppColors.sageGreen.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isActive ? AppColors.pearlWhite : AppColors.softCharcoalLight,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  void _showNewChatDialog() {
    // TODO: Implement new chat dialog
    debugPrint('Show new chat dialog');
  }
}