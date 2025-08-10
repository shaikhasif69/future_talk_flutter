import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
// import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart' as msg;
import '../providers/realtime_chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/quick_reactions.dart' as reactions;
import '../widgets/typing_indicator.dart' as typing;
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
  
  bool _showQuickReactions = false;
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
    
    debugPrint('🔄 [IndividualChatScreen] Provider changed, updating messages');
    
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
    
    debugPrint('📝 [IndividualChatScreen] Loading ${conversationMessages.length} messages for conversation ${widget.conversation.id}');
    debugPrint('📝 [IndividualChatScreen] Current user ID: ${_chatProvider.currentUserId}');
    
    // Only update if messages have actually changed to avoid unnecessary rebuilds
    if (conversationMessages.length != _currentMessages.length ||
        (conversationMessages.isNotEmpty && _currentMessages.isNotEmpty &&
         conversationMessages.last.id != _currentMessages.last.id)) {
      
      debugPrint('🔄 [IndividualChatScreen] Messages changed, updating UI messages');
      
      // Convert ChatMessage from API to UI ChatMessage if needed
      final newMessages = conversationMessages.map((apiMessage) {
        // CRITICAL FIX: Use the isFromMe property that's already calculated in the API message
        final isFromMe = apiMessage.isFromMe;
        
        debugPrint('🔄 [IndividualChatScreen] Converting message:');
        debugPrint('   - Content: ${apiMessage.content.length > 30 ? '${apiMessage.content.substring(0, 30)}...' : apiMessage.content}');
        debugPrint('   - Sender ID: ${apiMessage.senderId}');
        debugPrint('   - Current User ID: ${_chatProvider.currentUserId}');
        debugPrint('   - Is From Me: $isFromMe');
        debugPrint('   - Alignment: ${isFromMe ? "RIGHT (sent)" : "LEFT (received)"}');
        
        return msg.ChatMessage(
          id: apiMessage.id,
          senderId: apiMessage.senderId,
          senderUsername: apiMessage.senderUsername,
          conversationId: apiMessage.conversationId,
          messageType: _mapMessageType(apiMessage.messageType.toString()),
          createdAt: apiMessage.createdAt,
          status: _mapMessageStatus(apiMessage.status?.toString()),
          content: apiMessage.content,
          isFromMe: isFromMe, // USE THE PROPERLY CALCULATED VALUE
          readBy: apiMessage.readBy,
          reactions: (apiMessage.reactions ?? []).map((r) => msg.Reaction(
            userId: r.userId,
            emoji: r.emoji,
            createdAt: r.createdAt,
          )).toList(),
        );
      }).toList();
      
      _currentMessages = newMessages;
      debugPrint('✅ [IndividualChatScreen] Updated _currentMessages with ${_currentMessages.length} messages');
      
      // Debug: Show alignment for all messages
      for (int i = 0; i < _currentMessages.length; i++) {
        final msg = _currentMessages[i];
        debugPrint('   Message $i: "${msg.content.substring(0, msg.content.length > 20 ? 20 : msg.content.length)}..." - isFromMe: ${msg.isFromMe} - align: ${msg.isFromMe ? "RIGHT" : "LEFT"}');
      }
      
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
  
  /// Get chat title - show other user's name for individual chats
  String _getChatTitle() {
    final currentUserId = _chatProvider.currentUserId;
    debugPrint('🏷️ [IndividualChatScreen] Getting chat title, current user: $currentUserId');
    debugPrint('🏷️ [IndividualChatScreen] Conversation name: ${widget.conversation.name}');
    
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
  
  /// Group messages by date
  Map<String, List<msg.ChatMessage>> _groupMessagesByDate(List<msg.ChatMessage> messages) {
    final Map<String, List<msg.ChatMessage>> grouped = {};
    
    for (final message in messages) {
      final dateKey = message.formattedDate;
      grouped.putIfAbsent(dateKey, () => []).add(message);
    }
    
    return grouped;
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
    
    _hideQuickReactions();
  }

  void _openQuickReactions() {
    setState(() {
      _showQuickReactions = true;
    });
    
    // Auto-hide after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _hideQuickReactions();
      }
    });
  }

  void _hideQuickReactions() {
    setState(() {
      _showQuickReactions = false;
    });
  }


  void _onMessageLongPress(msg.ChatMessage message) {
    debugPrint('📝 [IndividualChatScreen] Long press on message: ${message.id}');
    _showMessageOptions(message);
  }

  void _showMessageOptions(msg.ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.pearlWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      builder: (context) => _buildMessageOptionsSheet(message),
    );
  }

  Widget _buildMessageOptionsSheet(msg.ChatMessage message) {
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
            
            // Reply option
            ListTile(
              leading: const Icon(
                Icons.reply,
                color: AppColors.sageGreen,
              ),
              title: Text(
                'Reply',
                style: AppTextStyles.bodyMedium,
              ),
              onTap: () {
                // TODO: Implement reply functionality with API
                debugPrint('💬 [IndividualChatScreen] Reply to message: ${message.id}');
                Navigator.pop(context);
              },
            ),
            
            // React option
            ListTile(
              leading: const Icon(
                Icons.emoji_emotions_outlined,
                color: AppColors.warmPeach,
              ),
              title: Text(
                'Add reaction',
                style: AppTextStyles.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                _openQuickReactions();
              },
            ),
            
            // Copy text (if text message)
            if (message.messageType == msg.MessageType.text)
              ListTile(
                leading: const Icon(
                  Icons.copy,
                  color: AppColors.softCharcoal,
                ),
                title: Text(
                  'Copy text',
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Text copied to clipboard',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.pearlWhite,
                        ),
                      ),
                      backgroundColor: AppColors.softCharcoal,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                  );
                },
              ),
            
            // Delete message (if own message)
            if (message.isFromMe)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.dustyRose,
                ),
                title: Text(
                  'Delete',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.dustyRose,
                  ),
                ),
                onTap: () {
                  // TODO: Implement delete message API call
                  debugPrint('🗑️ [IndividualChatScreen] Delete message: ${message.id}');
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
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
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
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
                      // Background with subtle texture
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.warmCream,
                              AppColors.pearlWhite,
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        // Temporary: Remove broken custom painter for now  
                        child: Container(),
                      ),
                      
                      // Messages List
                      _buildMessagesList(),
                      
                      // Quick Reactions Overlay
                      if (_showQuickReactions)
                        Positioned(
                          bottom: 80,
                          left: AppDimensions.paddingM,
                          right: AppDimensions.paddingM,
                          child: reactions.QuickReactions(
                            onReactionTap: _onQuickReactionTap,
                            onDismiss: _hideQuickReactions,
                          ),
                        ),
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
    
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _currentMessages.length,
      itemBuilder: (context, index) {
        final message = _currentMessages[index];
        // Debug message alignment (simplified to avoid log spam)
        if (index == 0) {
          debugPrint('🔍 [IndividualChatScreen] Sample message - IsFromMe: ${message.isFromMe}, Sender: ${message.senderId}');
        }
        
        return Align(
          alignment: message.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              left: message.isFromMe ? 80.0 : AppDimensions.paddingM,
              right: message.isFromMe ? AppDimensions.paddingM : 80.0,
              top: AppDimensions.spacingXS,
              bottom: AppDimensions.spacingXS,
            ),
            constraints: const BoxConstraints(maxWidth: 280.0),
            decoration: BoxDecoration(
              color: message.isFromMe ? AppColors.sageGreen : AppColors.pearlWhite,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL).copyWith(
                bottomRight: message.isFromMe 
                    ? const Radius.circular(AppDimensions.spacingS)
                    : null,
                bottomLeft: !message.isFromMe 
                    ? const Radius.circular(AppDimensions.spacingS)
                    : null,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
              border: message.isFromMe
                  ? null
                  : Border.all(
                      color: AppColors.sageGreenWithOpacity(0.1),
                      width: 1.0,
                    ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.spacingM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Remove sender username from individual chats
                Text(
                  message.content,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: message.isFromMe ? AppColors.pearlWhite : AppColors.softCharcoal,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.formattedTime,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: message.isFromMe 
                            ? AppColors.pearlWhite.withAlpha(180) 
                            : AppColors.softCharcoalLight,
                        fontSize: 11.0,
                      ),
                    ),
                    if (message.isFromMe) ...[
                      const SizedBox(width: AppDimensions.spacingXS),
                      Text(
                        message.statusIcon,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: message.status == msg.MessageStatus.read
                              ? AppColors.warmPeach
                              : AppColors.pearlWhite.withAlpha(153),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildMessagesListView() {
    debugPrint('📱 [IndividualChatScreen] Building messages list view with ${_currentMessages.length} messages');
    final messagesByDate = _groupMessagesByDate(_currentMessages);
    
    debugPrint('🗓️ [IndividualChatScreen] Messages grouped by ${messagesByDate.length} dates');
    for (var entry in messagesByDate.entries) {
      debugPrint('📅 [IndividualChatScreen] Date: ${entry.key} - Messages: ${entry.value.length}');
    }
    
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Messages grouped by date
        ...messagesByDate.entries.map((entry) {
          final dateText = entry.key;
          final messages = entry.value;
          
          debugPrint('🏗️ [IndividualChatScreen] Building sliver group for $dateText with ${messages.length} messages');
          
          return SliverMainAxisGroup(
            slivers: [
              // Date separator
              SliverToBoxAdapter(
                child: _buildDateSeparator(dateText),
              ),
              
              // Messages for this date
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= messages.length) {
                      debugPrint('⚠️ [IndividualChatScreen] Index $index out of bounds for ${messages.length} messages');
                      return null;
                    }
                    
                    final message = messages[index];
                    final previousMessage = index > 0 ? messages[index - 1] : null;
                    final nextMessage = index < messages.length - 1 
                        ? messages[index + 1] 
                        : null;
                    
                    debugPrint('🧱 [IndividualChatScreen] Building message $index: ${message.content.length > 20 ? '${message.content.substring(0, 20)}...' : message.content}');
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                        vertical: AppDimensions.spacingXS,
                      ),
                      child: Container(
                        // Add temporary background to debug visibility
                        color: Colors.transparent,
                        child: MessageBubble(
                          message: message,
                          previousMessage: previousMessage,
                          nextMessage: nextMessage,
                          onLongPress: () => _onMessageLongPress(message),
                          onReactionTap: (emoji) {
                            // TODO: Implement reaction API call
                            debugPrint('🎭 [IndividualChatScreen] Adding reaction $emoji to message ${message.id}');
                          },
                        ),
                      ),
                    );
                  },
                  childCount: messages.length,
                ),
              ),
            ],
          );
        }),
        
        // Typing indicator
        Builder(
          builder: (context) {
            final isTyping = _isOtherUserTyping();
            debugPrint('🏗️ [IndividualChatScreen] Building typing indicator - show: $isTyping');
            
            if (isTyping) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: AppDimensions.spacingM,
                  ),
                  child: typing.TypingIndicator(
                    userName: widget.conversation.name,
                  ),
                ),
              );
            } else {
              return const SliverToBoxAdapter(
                child: SizedBox.shrink(),
              );
            }
          },
        ),
        
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.spacingM),
        ),
      ],
    );
  }

  Widget _buildDateSeparator(String dateText) {
    final isToday = dateText == 'Today';
    final socialBattery = widget.conversation.otherParticipant?.socialBattery;
    
    String displayText = dateText;
    if (isToday && socialBattery != null) {
      displayText = '$dateText • ${socialBattery.description}';
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingM,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.sageGreenWithOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: AppColors.sageGreenWithOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Text(
            displayText,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
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
            color: AppColors.sageGreenWithOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.sageGreenWithOpacity(0.1),
              foregroundColor: AppColors.sageGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // Participant info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getChatTitle(),
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Builder(
                  builder: (context) {
                    final isTyping = _isOtherUserTyping();
                    debugPrint('🏗️ [IndividualChatScreen] Building header status - typing: $isTyping');
                    
                    if (isTyping) {
                      return Text(
                        'typing...',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.sageGreen,
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    } else {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConnectionStatusIndicator(
                            connectionState: _chatProvider.connectionState,
                            size: 6.0,
                            showLabel: false,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getConnectionStatusText(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: _getConnectionStatusColor(),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Header actions
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Navigate to connection stones
                },
                icon: const Text('🪨', style: TextStyle(fontSize: 18)),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.sageGreenWithOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingS),
              
              IconButton(
                onPressed: () {
                  // TODO: Show chat settings
                },
                icon: const Icon(Icons.settings, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.sageGreenWithOpacity(0.1),
                  foregroundColor: AppColors.sageGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
              // Quick reactions
              _buildQuickReactionsRow(),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              // Message input
              _buildMessageInputContainer(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build quick reactions row
  Widget _buildQuickReactionsRow() {
    const quickReactions = ['❤️', '😊', '👍', '🤗', '💛', '✨', '🙏'];
    
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickReactions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacingS),
        itemBuilder: (context, index) {
          final emoji = quickReactions[index];
          return GestureDetector(
            onTap: () => _onQuickReactionTap(emoji),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.sageGreenWithOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: AppColors.sageGreenWithOpacity(0.15),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build message input container with text field and send button
  Widget _buildMessageInputContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Add button
          Container(
            margin: const EdgeInsets.all(AppDimensions.spacingS),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.sageGreenWithOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.sageGreen,
                size: 20,
              ),
            ),
          ),
          
          // Text input
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
                    vertical: AppDimensions.spacingM,
                  ),
                ),
                onChanged: (text) {
                  setState(() {});
                  _handleTyping(text);
                },
              ),
            ),
          ),
          
          // Send button
          Container(
            margin: const EdgeInsets.all(AppDimensions.spacingS),
            child: GestureDetector(
              onTap: _messageController.text.trim().isNotEmpty ? _sendMessage : null,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: _messageController.text.trim().isNotEmpty
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.sageGreen, AppColors.sageGreenHover],
                        )
                      : null,
                  color: _messageController.text.trim().isNotEmpty
                      ? null
                      : AppColors.sageGreenWithOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: AppColors.pearlWhite,
                  size: 20,
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
