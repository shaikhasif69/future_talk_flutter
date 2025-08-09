import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart' as msg;
import '../providers/realtime_chat_provider.dart';
import '../widgets/chat_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/quick_reactions.dart' as reactions;
import '../widgets/typing_indicator.dart' as typing;

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
  
  bool _showQuickReactions = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeChatProvider();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    
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
    _chatProvider = RealtimeChatProvider();

    // Listen to provider changes
    _chatProvider.addListener(_onChatProviderChanged);

    // Initialize provider asynchronously
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _chatProvider.initialize();
      // Select this conversation
      await _chatProvider.selectConversation(widget.conversation.id);
      
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
    
    // Auto-scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messages = _chatProvider.getMessages(widget.conversation.id);
      if (messages.isNotEmpty) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _chatProvider.removeListener(_onChatProviderChanged);
    _chatProvider.dispose();
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
    _chatProvider.sendQuickReaction(emoji);
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

  void _onMessageSent() {
    HapticFeedback.lightImpact();
    _scrollToBottom();
  }

  void _onMessageLongPress(msg.ChatMessage message) {
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
                _chatProvider.setReplyToMessage(message.id);
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
            if (message.type == msg.MessageType.text)
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
                  _chatProvider.deleteMessage(message.id);
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
              ChatHeader(
                conversation: widget.conversation,
                provider: _chatProvider,
                onBackPressed: () => Navigator.of(context).pop(),
                onConnectionStonesPressed: () {
                  // TODO: Navigate to connection stones
                },
                onSettingsPressed: () {
                  // TODO: Show chat settings
                },
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
                        child: CustomPaint(
                          painter: _ChatBackgroundPainter(),
                          size: Size.infinite,
                        ),
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
              MessageInput(
                provider: _chatProvider,
                onMessageSent: _onMessageSent,
                onQuickReactionPressed: _openQuickReactions,
              ),
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
        if (_chatProvider.isInitializing || _chatProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
            ),
          );
        }

        if (_chatProvider.errorMessage != null) {
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
                    _chatProvider.errorMessage!,
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

        if (!_chatProvider.hasMessages) {
          return _buildEmptyState();
        }

        return _buildMessagesListView();
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
              'Send your first message to ${_chatProvider.otherUserName}',
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
    final messagesByDate = _chatProvider.messagesByDate;
    
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Messages grouped by date
        ...messagesByDate.entries.map((entry) {
          final dateText = entry.key;
          final messages = entry.value;
          
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
                    if (index >= messages.length) return null;
                    
                    final message = messages[index];
                    final previousMessage = index > 0 ? messages[index - 1] : null;
                    final nextMessage = index < messages.length - 1 
                        ? messages[index + 1] 
                        : null;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                        vertical: AppDimensions.spacingXS,
                      ),
                      child: FTStaggerAnimation(
                        delay: Duration(milliseconds: index * 50),
                        slideDirection: FTStaggerSlideDirection.fromBottom,
                        child: MessageBubble(
                          message: message,
                          previousMessage: previousMessage,
                          nextMessage: nextMessage,
                          onLongPress: () => _onMessageLongPress(message),
                          onReactionTap: (emoji) => _chatProvider.addReaction(message.id, emoji),
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
        if (_chatProvider.isOtherUserTyping)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.spacingM,
              ),
              child: typing.TypingIndicator(
                userName: _chatProvider.otherUserName,
              ),
            ),
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
    final socialBattery = _chatProvider.otherUserSocialBattery;
    
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
}

/// Custom painter for chat background texture
class _ChatBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.pearlWhite.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Create subtle texture dots
    for (int i = 0; i < 20; i++) {
      final x = (i * 100.0) % size.width;
      final y = (i * 80.0) % size.height;
      canvas.drawCircle(
        Offset(x, y),
        0.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}