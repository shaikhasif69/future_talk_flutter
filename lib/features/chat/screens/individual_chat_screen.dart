import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
// import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart' as msg;
import '../providers/realtime_chat_provider.dart';
import '../widgets/connection_status_indicator.dart';
import '../services/websocket_service.dart';

/// Premium individual chat screen with sanctuary-like communication experience
/// Features smooth animations, social battery awareness, and introvert-friendly interactions
class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen({
    super.key,
    required this.conversation,
  });

  final ChatConversation conversation;

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen>
    with TickerProviderStateMixin {
  late RealtimeChatProvider _chatProvider;
  late ScrollController _scrollController;
  late AnimationController _fadeInController;
  late AnimationController _slideInController;
  late TextEditingController _messageController;
  
  bool _isInitialized = false;
  List<msg.ChatMessage> _currentMessages = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeChatProvider();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _messageController = TextEditingController();
    
    // Add scroll listener for infinite scrolling
    _scrollController.addListener(_onScroll);
    
    _fadeInController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideInController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  void _initializeChatProvider() {
    debugPrint('🚀 [IndividualChatScreen] Initializing chat provider for conversation: ${widget.conversation.id}');
    
    // Use the global RealtimeChatProvider instance
    _chatProvider = realtimeChatProvider;

    // Listen to provider changes
    _chatProvider.addListener(_onChatProviderChanged);

    // Initialize provider asynchronously
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Ensure provider is initialized first
      if (!_chatProvider.isInitialized) {
        await _chatProvider.initialize();
      }
      
      // Ensure the conversation is selected
      await _chatProvider.selectConversation(widget.conversation.id);
      
      // Load current messages
      _loadCurrentMessages();
      
      if (mounted) {
        _fadeInController.forward();
        _slideInController.forward();
        _scrollToBottom(animated: false);
        
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  void _onChatProviderChanged() {
    if (!mounted) return;
    
    debugPrint('🔄 [IndividualChatScreen] Provider changed for conversation: ${widget.conversation.id}');
    debugPrint('🔄 [IndividualChatScreen] Current user ID: ${_chatProvider.currentUserId}');
    
    // Update current messages from provider
    _loadCurrentMessages();
    
    // Auto-scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentMessages.isNotEmpty) {
        _scrollToBottom();
      }
    });
  }
  
  /// Load current messages for this conversation from the provider
  void _loadCurrentMessages() {
    final conversationMessages = _chatProvider.getMessages(widget.conversation.id);
    
    // debugPrint('📝 [IndividualChatScreen] Loading ${conversationMessages.length} messages for conversation ${widget.conversation.id}');
    // debugPrint('📝 [IndividualChatScreen] Current user ID: ${_chatProvider.currentUserId}');
    
    // Only update if messages have actually changed to avoid unnecessary rebuilds
    if (conversationMessages.length != _currentMessages.length ||
        (conversationMessages.isNotEmpty && _currentMessages.isNotEmpty &&
         conversationMessages.last.id != _currentMessages.last.id)) {
      
      // debugPrint('🔄 [IndividualChatScreen] Messages changed, updating UI messages');
      
      // Convert ChatMessage from API to UI ChatMessage if needed
      final newMessages = conversationMessages.map((apiMessage) {
        // CRITICAL FIX: Use the isFromMe property that's already calculated in the API message
        final isFromMe = apiMessage.isFromMe;
        
        // debugPrint('🔄 [IndividualChatScreen] Converting message:');
        // debugPrint('   - Content: ${apiMessage.content.length > 30 ? '${apiMessage.content.substring(0, 30)}...' : apiMessage.content}');
        // debugPrint('   - Sender ID: ${apiMessage.senderId}');
        // debugPrint('   - Current User ID: ${_chatProvider.currentUserId}');
        // debugPrint('   - Is From Me: $isFromMe');
        // debugPrint('   - Alignment: ${isFromMe ? "RIGHT (sent)" : "LEFT (received)"}');
        
        return msg.ChatMessage(
          id: apiMessage.id,
          senderId: apiMessage.senderId,
          senderUsername: apiMessage.senderUsername,
          conversationId: apiMessage.conversationId,
          messageType: _mapMessageType(apiMessage.messageType.toString()),
          createdAt: apiMessage.createdAt,
          status: _mapMessageStatus(apiMessage.status.toString()),
          content: apiMessage.content,
          isFromMe: isFromMe, // USE THE PROPERLY CALCULATED VALUE
          readBy: apiMessage.readBy,
          reactions: apiMessage.reactions.map((r) => msg.Reaction(
            userId: r.userId,
            emoji: r.emoji,
            createdAt: r.createdAt,
          )).toList(),
        );
      }).toList();
      
      _currentMessages = newMessages;
      // debugPrint('✅ [IndividualChatScreen] Updated _currentMessages with ${_currentMessages.length} messages');

      
      // Schedule a setState to trigger rebuild and auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
          // Auto-scroll to bottom for new messages
          _scrollToBottom();
        }
      });
    } else {
      debugPrint('💡 [IndividualChatScreen] Messages unchanged, no UI update needed');
    }
  }
  
  /// Map API message type to UI message type
  msg.MessageType _mapMessageType(String? type) {
    switch (type?.toLowerCase()) {
      case 'text':
        return msg.MessageType.text;
      case 'voice':
        return msg.MessageType.voice;
      case 'image':
        return msg.MessageType.image;
      default:
        return msg.MessageType.text;
    }
  }
  
  /// Map API message status to UI message status
  msg.MessageStatus _mapMessageStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'sending':
        return msg.MessageStatus.sending;
      case 'sent':
        return msg.MessageStatus.sent;
      case 'delivered':
        return msg.MessageStatus.delivered;
      case 'read':
        return msg.MessageStatus.read;
      default:
        return msg.MessageStatus.sent;
    }
  }
  
  /// Check if other user is typing
  bool _isOtherUserTyping() {
    final conversationId = widget.conversation.id;
    final typingUsers = _chatProvider.getTypingUsers(conversationId);
    final isTyping = typingUsers.isNotEmpty;
    
    if (isTyping) {
      debugPrint('⌨️ [IndividualChatScreen] Other user is typing in $conversationId: ${typingUsers.toList()}');
    }
    
    return isTyping;
  }
  
  /// Get connection status text for header
  String _getConnectionStatusText() {
    switch (_chatProvider.connectionState) {
      case WebSocketConnectionState.connected:
        return 'Online';
      case WebSocketConnectionState.connecting:
        return 'Connecting...';
      case WebSocketConnectionState.reconnecting:
        return 'Reconnecting...';
      case WebSocketConnectionState.disconnected:
        return 'Offline';
      case WebSocketConnectionState.error:
        return 'Connection Error';
    }
  }
  
  /// Get connection status color for header
  Color _getConnectionStatusColor() {
    switch (_chatProvider.connectionState) {
      case WebSocketConnectionState.connected:
        return AppColors.sageGreen;
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return AppColors.warmPeach;
      case WebSocketConnectionState.disconnected:
        return AppColors.softCharcoalLight;
      case WebSocketConnectionState.error:
        return AppColors.dustyRose;
    }
  }

  /// Handle scroll events for infinite scrolling
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    const double threshold = 200.0; // Threshold from top to trigger load more
    final conversationId = widget.conversation.id;
    
    // Check if we're scrolling near the top and need to load more messages
    if (_scrollController.position.pixels <= threshold &&
        !_chatProvider.isLoadingMessages(conversationId) &&
        _chatProvider.hasMoreMessages(conversationId)) {
      
      debugPrint('🔄 [InfiniteScroll] Loading more messages for conversation: $conversationId');
      _loadOlderMessages();
    }
  }

  /// Load older messages for infinite scrolling
  Future<void> _loadOlderMessages() async {
    final conversationId = widget.conversation.id;
    
    // Store current scroll position to maintain position after loading
    final currentScrollPosition = _scrollController.position.pixels;
    final currentMaxScroll = _scrollController.position.maxScrollExtent;
    
    debugPrint('📜 [InfiniteScroll] Current scroll position: $currentScrollPosition');
    debugPrint('📜 [InfiniteScroll] Current max scroll: $currentMaxScroll');
    
    // Load more messages
    await _chatProvider.loadMessages(conversationId, loadMore: true);
    
    // Wait for the widget tree to rebuild with new messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Calculate new scroll position to maintain user's view
        final newMaxScroll = _scrollController.position.maxScrollExtent;
        final scrollOffset = newMaxScroll - currentMaxScroll;
        final targetPosition = currentScrollPosition + scrollOffset;
        
        debugPrint('📜 [InfiniteScroll] New max scroll: $newMaxScroll');
        debugPrint('📜 [InfiniteScroll] Scroll offset: $scrollOffset');
        debugPrint('📜 [InfiniteScroll] Target position: $targetPosition');
        
        // Jump to maintain current view position
        _scrollController.jumpTo(targetPosition.clamp(0.0, newMaxScroll));
      }
    });
  }
  
  /// Get chat title - show other user's name for individual chats
  String _getChatTitle() {
    final currentUserId = _chatProvider.currentUserId;
    // debugPrint('🏷️ [IndividualChatScreen] Getting chat title, current user: $currentUserId');
    // debugPrint('🏷️ [IndividualChatScreen] Conversation name: ${widget.conversation.name}');
    
    // For individual chats, find the other participant's name
    if (widget.conversation.type == msg.ConversationType.direct) {
      // Find the participant who is not the current user
      final otherParticipant = widget.conversation.participants
          .where((p) => p.id != currentUserId)
          .firstOrNull;
      
      if (otherParticipant != null) {
        debugPrint('🏷️ [IndividualChatScreen] Found other participant: ${otherParticipant.name}');
        return otherParticipant.name;
      }
    }
    
    // Fallback to conversation name
    debugPrint('🏷️ [IndividualChatScreen] Using fallback conversation name: ${widget.conversation.name}');
    return widget.conversation.name;
  }
  

  @override
  void dispose() {
    _messageController.dispose();
    _chatProvider.removeListener(_onChatProviderChanged);
    _scrollController.dispose();
    _fadeInController.dispose();
    _slideInController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;
    
    if (animated) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _onQuickReactionTap(String emoji) {
    // Send quick reaction to last received message
    final lastReceivedMessage = _currentMessages
        .where((m) => !m.isFromMe)
        .lastOrNull;
    
    if (lastReceivedMessage != null) {
      // TODO: Implement reaction API call
      debugPrint('🎭 [IndividualChatScreen] Adding reaction $emoji to message ${lastReceivedMessage.id}');
    }
    
    // Quick reaction sent
  }




  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: AppColors.warmCream,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.warmCream,
              AppColors.pearlWhite,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeInController,
            child: Column(
              children: [
              // Chat Header  
              _buildChatHeader(),
              
              // Connection Status Banner (when not connected)
              ConnectionStatusBanner(
                connectionState: _chatProvider.connectionState,
                lastError: _chatProvider.lastError,
                onRetry: () => _chatProvider.initialize(),
              ),
              
              // Messages Area
              Expanded(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideInController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: Stack(
                    children: [
                      // Enhanced background with subtle texture
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.warmCream,
                              AppColors.pearlWhite,
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            // Add subtle grain texture overlay
                            color: AppColors.pearlWhite.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      
                      // Messages List
                      _buildMessagesList(),
                      
                    ],
                  ),
                ),
              ),
              
                // Message Input Area
                _buildMessageInputArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListenableBuilder(
      listenable: _chatProvider,
      builder: (context, _) {
        // Refresh messages from provider whenever it changes
        _loadCurrentMessages();
        
        // Show loading indicator while messages are loading
        final conversationId = widget.conversation.id;
        final isLoadingMessages = _chatProvider.isLoadingMessages(conversationId);
        
        debugPrint('🏗️ [IndividualChatScreen] Building messages list: ${_currentMessages.length} messages');
        
        if (isLoadingMessages && _currentMessages.isEmpty) {
          debugPrint('🔄 [IndividualChatScreen] Showing loading indicator');
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
            ),
          );
        }

        if (_chatProvider.lastError != null && _currentMessages.isEmpty) {
          debugPrint('❌ [IndividualChatScreen] Showing error state');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingXXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64.0,
                    color: AppColors.dustyRose,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Text(
                    'Failed to load chat',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.softCharcoal,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    _chatProvider.lastError!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.softCharcoalLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  ElevatedButton(
                    onPressed: () => _chatProvider.initialize(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (_currentMessages.isEmpty) {
          debugPrint('📭 [IndividualChatScreen] Showing empty state');
          return _buildEmptyState();
        }

        debugPrint('📱 [IndividualChatScreen] Building messages list view with ${_currentMessages.length} messages');
        
        // Add a simple ListView.builder as fallback for debugging
        return _buildSimpleMessagesList();
      },
    );
  }

  /// Simple ListView.builder for debugging message display issues
  Widget _buildSimpleMessagesList() {
    debugPrint('🔍 [IndividualChatScreen] Building SIMPLE messages list with ${_currentMessages.length} messages');
    debugPrint('🔍 [IndividualChatScreen] Current user ID: ${_chatProvider.currentUserId}');
    
    final conversationId = widget.conversation.id;
    final isLoadingMore = _chatProvider.isLoadingMessages(conversationId);
    final hasMoreMessages = _chatProvider.hasMoreMessages(conversationId);
    
    // Calculate total item count: loading indicator + messages
    final totalItems = _currentMessages.length + (isLoadingMore && hasMoreMessages ? 1 : 0);
    
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        // Show loading indicator at the top when loading more messages
        if (index == 0 && isLoadingMore && hasMoreMessages) {
          return _buildLoadingIndicator();
        }
        
        // Adjust index for messages (account for loading indicator)
        final messageIndex = isLoadingMore && hasMoreMessages ? index - 1 : index;
        if (messageIndex < 0 || messageIndex >= _currentMessages.length) {
          return const SizedBox.shrink();
        }
        
        final message = _currentMessages[messageIndex];
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          child: Align(
            alignment: message.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                left: message.isFromMe ? 80.0 : AppDimensions.paddingM,
                right: message.isFromMe ? AppDimensions.paddingM : 80.0,
              ),
              constraints: const BoxConstraints(maxWidth: 280.0),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 400),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, animation, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - animation)),
                    child: Opacity(
                      opacity: animation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: message.isFromMe 
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.sageGreen, Color(0xFF7A9761)],
                              )
                            : null,
                          color: message.isFromMe ? null : AppColors.pearlWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(message.isFromMe ? 20 : 8),
                            bottomRight: Radius.circular(message.isFromMe ? 8 : 20),
                          ),
                          border: message.isFromMe ? null : Border.all(
                            color: AppColors.sageGreenWithOpacity(0.1),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.content,
                              style: AppTextStyles.personalContent.copyWith(
                                color: message.isFromMe ? AppColors.pearlWhite : AppColors.softCharcoal,
                                fontSize: 15,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  message.formattedTime,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: message.isFromMe 
                                        ? AppColors.pearlWhite.withValues(alpha: 0.7)
                                        : AppColors.softCharcoalLight,
                                    fontSize: 11.0,
                                  ),
                                ),
                                if (message.isFromMe) ...[
                                  const SizedBox(width: AppDimensions.spacingXS),
                                  _buildWhatsAppStatusIcon(message),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build loading indicator for infinite scrolling
  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Text(
              'Loading older messages...',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.softCharcoalLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
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
              'Start your conversation',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Send your first message to ${widget.conversation.name}',
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



  /// Build chat header with back button and participant info
  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.sageGreenWithOpacity(0.08),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Enhanced Back button
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.sageGreenWithOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.sageGreen,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // Enhanced friend info with avatar
          Expanded(
            child: Row(
              children: [
                // Friend avatar with social battery indicator
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.sageGreen, AppColors.lavenderMist],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.sageGreen.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getChatTitle().isNotEmpty ? _getChatTitle()[0].toUpperCase() : 'U',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.pearlWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    // Social battery indicator
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.warmPeach,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.pearlWhite,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 12),
                
                // Friend details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getChatTitle(),
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          // Online status
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.sageGreenWithOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getConnectionStatusText(),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: _getConnectionStatusColor(),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Typing indicator
                          Builder(
                            builder: (context) {
                              final isTyping = _isOtherUserTyping();
                              
                              if (isTyping) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.sageGreenWithOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'typing',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.sageGreen,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Row(
                                        children: [
                                          _buildTypingDot(0),
                                          const SizedBox(width: 2),
                                          _buildTypingDot(1),
                                          const SizedBox(width: 2),
                                          _buildTypingDot(2),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Enhanced Header actions
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.sageGreenWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Navigate to connection stones
                  },
                  icon: const Text('🪨', style: TextStyle(fontSize: 16)),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingS),
              
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.sageGreenWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Show chat settings
                  },
                  icon: const Text('⚙️', style: TextStyle(fontSize: 16)),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Build animated typing dot
  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.sageGreen.withValues(
              alpha: 0.3 + (0.7 * ((value + index * 0.33) % 1.0)),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  /// Build message input area with send functionality
  Widget _buildMessageInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: AppColors.sageGreenWithOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Slow mode indicator
              _buildSlowModeIndicator(),
              
              // Quick reactions
              _buildQuickReactionsRow(),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              // Enhanced message input
              _buildEnhancedMessageInputContainer(),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build slow mode indicator for thoughtful conversation
  Widget _buildSlowModeIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.warmPeach.withValues(alpha: 0.1),
            AppColors.sageGreenWithOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: AppColors.warmPeach.withValues(alpha: 0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.warmPeach.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🐌', style: TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text(
              'Slow mode active - Thoughtful conversation pace',
              style: AppTextStyles.personalContent.copyWith(
                color: AppColors.softCharcoalLight,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.sageGreenWithOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Show slow mode settings
              },
              icon: const Text('⚙️', style: TextStyle(fontSize: 12)),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced quick reactions row
  Widget _buildQuickReactionsRow() {
    const quickReactions = ['❤️', '😊', '👍', '🤗', '💛', '✨', '🙏'];
    
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: quickReactions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacingS),
        itemBuilder: (context, index) {
          final emoji = quickReactions[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 50)),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, animation, child) {
              return Transform.scale(
                scale: animation,
                child: GestureDetector(
                  onTap: () => _onQuickReactionTap(emoji),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.sageGreenWithOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.sageGreenWithOpacity(0.15),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Build enhanced message input container with text field and send button
  Widget _buildEnhancedMessageInputContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.15),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Enhanced add button
          Container(
            margin: const EdgeInsets.all(8),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.sageGreenWithOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  // TODO: Show attachment options
                },
                icon: const Icon(
                  Icons.add,
                  color: AppColors.sageGreen,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          
          // Enhanced text input
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 36,
                maxHeight: 100,
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: AppTextStyles.personalContent.copyWith(
                  fontSize: 15,
                  color: AppColors.softCharcoal,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  hintText: 'Share your thoughts mindfully...',
                  hintStyle: AppTextStyles.personalContent.copyWith(
                    fontSize: 15,
                    color: AppColors.softCharcoalLight,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: 10,
                  ),
                ),
                onChanged: (text) {
                  setState(() {});
                  _handleTyping(text);
                },
              ),
            ),
          ),
          
          // Enhanced send button with animation
          Container(
            margin: const EdgeInsets.all(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: GestureDetector(
                onTap: _messageController.text.trim().isNotEmpty ? _sendMessage : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: _messageController.text.trim().isNotEmpty
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.sageGreen, Color(0xFF7A9761)],
                          )
                        : null,
                    color: _messageController.text.trim().isNotEmpty
                        ? null
                        : AppColors.sageGreenWithOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: _messageController.text.trim().isNotEmpty ? [
                      BoxShadow(
                        color: AppColors.sageGreen.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: AppColors.pearlWhite,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  


  /// Handle typing indicators
  void _handleTyping(String text) {
    final conversationId = widget.conversation.id;
    
    if (text.trim().isNotEmpty) {
      _chatProvider.startTyping(conversationId);
    } else {
      _chatProvider.stopTyping(conversationId);
    }
  }

  /// Build WhatsApp-style status icon based on message status and readBy array
  Widget _buildWhatsAppStatusIcon(msg.ChatMessage message) {
    // Get current user ID from provider
    final currentUserId = _chatProvider.currentUserId ?? '';
    
    // Determine smart status based on readBy array (import the static method)
    final smartStatus = _determineMessageStatus(message, currentUserId);
    
    // Use WhatsApp-style icons (we need to import the MessageStatusIcons class)
    return _getStatusIcon(smartStatus);
  }

  /// Determine smart message status based on readBy array and current user (copy from ChatMessage model)
  msg.MessageStatus _determineMessageStatus(msg.ChatMessage message, String currentUserId) {
    // Only show status for my own messages
    if (message.senderId != currentUserId) {
      return msg.MessageStatus.read; // Not relevant for received messages
    }
    
    // FOCUSED DEBUG LOGGING
    final shortContent = message.content.length > 15 ? '${message.content.substring(0, 15)}...' : message.content;
    debugPrint('🔍 [STATUS DEBUG] Message: "$shortContent"');
    debugPrint('🔍 [STATUS DEBUG] - Message ID: ${message.id}');
    debugPrint('🔍 [STATUS DEBUG] - Sender: ${message.senderId}');
    debugPrint('🔍 [STATUS DEBUG] - Current User: $currentUserId');
    debugPrint('🔍 [STATUS DEBUG] - ReadBy Array: ${message.readBy}');
    
    // Check if message was read by others (exclude current user from readBy)
    final readByOthers = message.readBy.where((id) => id != currentUserId).toList();
    debugPrint('🔍 [STATUS DEBUG] - ReadBy Others: $readByOthers');
    
    if (readByOthers.isNotEmpty) {
      debugPrint('🔍 [STATUS DEBUG] → RESULT: BLUE DOUBLE TICK (read by others)');
      return msg.MessageStatus.read;      // 🔵🔵 Blue double tick - message was read
    }
    
    // For now, we'll use a time-based heuristic for delivery status
    final now = DateTime.now();
    final messageAge = now.difference(message.createdAt).inSeconds;
    debugPrint('🔍 [STATUS DEBUG] - Message age: ${messageAge}s');
    debugPrint('🔍 [STATUS DEBUG] - Has ID: ${message.id.isNotEmpty}');
    
    // Simulate delivery progression: sent -> delivered (after 1 second)
    if (message.id.isNotEmpty && messageAge >= 1) {
      debugPrint('🔍 [STATUS DEBUG] → RESULT: GRAY DOUBLE TICK (delivered)');
      return msg.MessageStatus.delivered; // ✅✅ Gray double tick - message delivered to device
    }
    
    // Message sent to server but not yet delivered (or very recent)
    if (message.id.isNotEmpty) {
      debugPrint('🔍 [STATUS DEBUG] → RESULT: SINGLE TICK (sent)');
      return msg.MessageStatus.sent;      // ✅ Gray single tick - message sent to server
    }
    
    // Message is still being sent
    debugPrint('🔍 [STATUS DEBUG] → RESULT: CLOCK (sending)');
    return msg.MessageStatus.sending;     // ⏳ Clock icon - message being sent
  }

  /// Get WhatsApp-style status icon widget (copy from MessageStatusIcons)
  Widget _getStatusIcon(msg.MessageStatus status) {
    // Exact WhatsApp colors
    const Color grayTick = Color(0xFF8E8E93);    // iOS gray
    const Color blueTick = Color(0xFF007AFF);    // WhatsApp blue  
    const Color redError = Color(0xFFFF3B30);    // Error red
    const Color sendingGray = Color(0xFFBEBEBE); // Sending state

    switch (status) {
      case msg.MessageStatus.sending:
        return const Icon(
          Icons.schedule,
          size: 14,
          color: sendingGray,
        );
        
      case msg.MessageStatus.sent:
        return const Icon(
          Icons.done,           // ✓ Single tick
          size: 14,
          color: grayTick,
        );
        
      case msg.MessageStatus.delivered:
        return const Icon(
          Icons.done_all,       // ✓✓ Double tick  
          size: 14,
          color: grayTick,
        );
        
      case msg.MessageStatus.read:
        return const Icon(
          Icons.done_all,       // ✓✓ Blue double tick
          size: 14,
          color: blueTick,      // 🔵 BLUE!
        );
        
      case msg.MessageStatus.failed:
        return const Icon(
          Icons.error,
          size: 14,
          color: redError,
        );
        
      case msg.MessageStatus.received:
        return const SizedBox.shrink(); // No icon for received messages
    }
  }

  /// Send message
  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    debugPrint('📤 [IndividualChatScreen] Sending message: $content');

    final conversationId = widget.conversation.id;
    
    // Clear input immediately
    _messageController.clear();
    setState(() {});

    // Send via provider
    await _chatProvider.sendMessage(conversationId, content);

    // Give haptic feedback
    HapticFeedback.lightImpact();
    
    // Scroll to bottom
    _scrollToBottom();
  }
}
