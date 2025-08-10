import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/animations/ft_fade_in.dart';
import '../models/chat_message.dart';
// import 'voice_message_player.dart'; // Unused for now

/// Premium message bubble with sophisticated styling and animations
class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.previousMessage,
    this.nextMessage,
    this.onLongPress,
    this.onReactionTap,
  });

  final ChatMessage message;
  final ChatMessage? previousMessage;
  final ChatMessage? nextMessage;
  final VoidCallback? onLongPress;
  final Function(String emoji)? onReactionTap;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _destructController;
  late Animation<double> _destructAnimation;
  bool _showTimestamp = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupSelfDestructTimer();
  }

  void _initializeAnimations() {
    _destructController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _destructAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _destructController,
      curve: Curves.easeInOut,
    ));
  }

  void _setupSelfDestructTimer() {
    // Self-destruct functionality removed for now
    // TODO: Implement self-destruct when supported by API
  }

  @override
  void dispose() {
    _destructController.dispose();
    super.dispose();
  }

  void _onBubbleTap() {
    setState(() {
      _showTimestamp = !_showTimestamp;
    });
    
    HapticFeedback.selectionClick();
  }

  void _onBubbleLongPress() {
    HapticFeedback.heavyImpact();
    widget.onLongPress?.call();
  }

  void _onReactionTap(String emoji) {
    HapticFeedback.lightImpact();
    widget.onReactionTap?.call(emoji);
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final isFromMe = message.isFromMe;
    final showSenderName = message.shouldShowSenderName(
      widget.previousMessage, 
      false, // Individual chat, so always false
    );
    final showTimestamp = message.shouldShowTimestamp(widget.previousMessage) || _showTimestamp;

    debugPrint('📦 [MessageBubble] Building bubble for message: ${message.content.length > 30 ? '${message.content.substring(0, 30)}...' : message.content}');

    // Simplified rendering - remove opacity animation that might be causing issues
    return _buildMessageContent(
      message,
      isFromMe,
      showSenderName,
      showTimestamp,
    );
  }

  // _buildExpiredMessage removed - self-destruct not implemented

  Widget _buildMessageContent(
    ChatMessage message,
    bool isFromMe,
    bool showSenderName,
    bool showTimestamp,
  ) {
    debugPrint('📦 [MessageBubble] Building message content for: ${message.content}');
    debugPrint('📦 [MessageBubble] isFromMe: $isFromMe, showSenderName: $showSenderName, showTimestamp: $showTimestamp');
    debugPrint('📦 [MessageBubble] senderId: ${message.senderId}, senderUsername: ${message.senderUsername}');
    
    return Column(
      crossAxisAlignment: isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Sender name (for group chats only - skip for individual chats)
        if (showSenderName && !isFromMe) // Only show for received messages in group chats
          Padding(
            padding: EdgeInsets.only(
              left: isFromMe ? 80.0 : AppDimensions.paddingM,
              right: isFromMe ? AppDimensions.paddingM : 80.0,
              bottom: AppDimensions.spacingXS,
            ),
            child: Text(
              message.senderUsername,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.softCharcoalLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Main message bubble
        Align(
          alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onTap: _onBubbleTap,
            onLongPress: _onBubbleLongPress,
            child: _buildBubbleContainer(message, isFromMe),
          ),
        ),

        // Message reactions
        if (message.hasReactions)
          _buildMessageReactions(message, isFromMe),

        // Timestamp
        if (showTimestamp)
          _buildTimestamp(message, isFromMe),
      ],
    );
  }

  Widget _buildBubbleContainer(ChatMessage message, bool isFromMe) {
    final isSelfDestruct = false; // Self-destruct not implemented yet
    debugPrint('🎆 [MessageBubble] Building bubble container for: ${message.content}');
    
    return Container(
      margin: EdgeInsets.only(
        left: isFromMe ? 80.0 : 0.0,
        right: isFromMe ? 0.0 : 80.0,
        bottom: AppDimensions.spacingS,
      ),
      child: Stack(
        children: [
          // Main bubble
          Container(
            constraints: const BoxConstraints(maxWidth: 280.0),
            padding: _getBubblePadding(message.messageType),
            decoration: _getBubbleDecoration(isFromMe, isSelfDestruct),
            child: _buildMessageTypeContent(message),
          ),


        ],
      ),
    );
  }

  EdgeInsets _getBubblePadding(MessageType messageType) {
    switch (messageType) {
      case MessageType.voice:
        return const EdgeInsets.all(AppDimensions.paddingM);
      case MessageType.image:
        return const EdgeInsets.all(AppDimensions.spacingXS);
      default:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.spacingM,
        );
    }
  }

  BoxDecoration _getBubbleDecoration(bool isFromMe, bool isSelfDestruct) {
    Color bubbleColor;
    List<Color> gradientColors;
    BorderRadius borderRadius;
    List<BoxShadow> shadows;

    if (isFromMe) {
      if (isSelfDestruct) {
        gradientColors = [
          AppColors.dustyRose.withValues(alpha: 0.15),
          AppColors.warmPeach.withValues(alpha: 0.15),
        ];
        bubbleColor = AppColors.dustyRose.withValues(alpha: 0.15);
      } else {
        gradientColors = [AppColors.sageGreen, AppColors.sageGreenHover];
        bubbleColor = AppColors.sageGreen;
      }
      borderRadius = BorderRadius.circular(AppDimensions.radiusL).copyWith(
        bottomRight: const Radius.circular(AppDimensions.spacingS),
      );
    } else {
      bubbleColor = AppColors.pearlWhite;
      gradientColors = [AppColors.pearlWhite, AppColors.warmCream];
      borderRadius = BorderRadius.circular(AppDimensions.radiusL).copyWith(
        bottomLeft: const Radius.circular(AppDimensions.spacingS),
      );
    }

    shadows = [
      BoxShadow(
        color: AppColors.cardShadow,
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ];

    if (isSelfDestruct) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.dustyRose.withAlpha(77),
          width: 1.0,
        ),
        boxShadow: shadows,
      );
    }

    return BoxDecoration(
      gradient: isFromMe
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            )
          : null,
      color: isFromMe ? null : bubbleColor,
      borderRadius: borderRadius,
      border: isFromMe
          ? null
          : Border.all(
              color: AppColors.sageGreenWithOpacity(0.1),
              width: 1.0,
            ),
      boxShadow: shadows,
    );
  }

  Widget _buildMessageTypeContent(ChatMessage message) {
    switch (message.messageType) {
      case MessageType.text:
        return _buildTextContent(message);
      case MessageType.voice:
        return _buildVoiceContent(message);
      case MessageType.image:
        return _buildImageContent(message);
      case MessageType.video:
        return _buildTextContent(message); // Placeholder
    }
  }

  Widget _buildTextContent(ChatMessage message) {
    final isFromMe = message.isFromMe;
    debugPrint('📝 [MessageBubble] Building text content: "${message.displayContent}" (isFromMe: $isFromMe)');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Message text
        Text(
          message.displayContent,
          style: AppTextStyles.personalContent.copyWith(
            color: isFromMe ? AppColors.pearlWhite : AppColors.softCharcoal,
            fontSize: 15.0,
            height: 1.5,
          ),
        ),

        // Timestamp and status
        const SizedBox(height: AppDimensions.spacingS),
        
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.formattedTime,
              style: AppTextStyles.labelSmall.copyWith(
                color: isFromMe 
                    ? AppColors.pearlWhite.withAlpha(204)
                    : AppColors.softCharcoalLight,
                fontSize: 11.0,
              ),
            ),
            
            if (isFromMe) ...[
              const SizedBox(width: AppDimensions.spacingXS),
              Text(
                message.statusIcon,
                style: TextStyle(
                  fontSize: 10.0,
                  color: message.status == MessageStatus.read
                      ? AppColors.warmPeach
                      : AppColors.pearlWhite.withAlpha(153),
                ),
              ),
              
              if (message.status == MessageStatus.read) ...[
                const SizedBox(width: AppDimensions.spacingXS),
                Text(
                  'Read',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.warmPeach,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildVoiceContent(ChatMessage message) {
    // TODO: Implement voice message display when VoiceMessage model is available
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mic_outlined,
            size: 20.0,
            color: AppColors.softCharcoalLight,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            'Voice message',
            style: AppTextStyles.personalContent.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
        ],
      ),
    );
    
  }

  Widget _buildImageContent(ChatMessage message) {
    // Placeholder for image content
    return Container(
      width: 200.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: AppColors.whisperGray,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 32.0,
          color: AppColors.softCharcoalLight,
        ),
      ),
    );
  }

  // Self-destruct timer removed - not implemented in current model
  // TODO: Add back when SelfDestructMessage is properly implemented

  Widget _buildMessageReactions(ChatMessage message, bool isFromMe) {
    final groupedReactions = message.groupedReactions;
    
    return Container(
      margin: EdgeInsets.only(
        left: isFromMe ? 40.0 : AppDimensions.paddingM,
        right: isFromMe ? AppDimensions.paddingM : 40.0,
        top: AppDimensions.spacingS,
      ),
      child: Wrap(
        spacing: AppDimensions.spacingS,
        runSpacing: AppDimensions.spacingXS,
        children: groupedReactions.entries.map((entry) {
          final emoji = entry.key;
          final reactions = entry.value;
          // Check if current user has reacted with this emoji
          final hasMyReaction = reactions.any((r) => r.userId == message.senderId); // TODO: Use actual current user ID
          
          return GestureDetector(
            onTap: () => _onReactionTap(emoji),
            child: FTFadeIn(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: hasMyReaction
                      ? AppColors.sageGreenWithOpacity(0.2)
                      : AppColors.sageGreenWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(
                    color: hasMyReaction
                        ? AppColors.sageGreen
                        : AppColors.sageGreenWithOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 12.0),
                    ),
                    
                    if (reactions.length > 1) ...[
                      const SizedBox(width: AppDimensions.spacingXS),
                      Text(
                        reactions.length.toString(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: hasMyReaction
                              ? AppColors.sageGreen
                              : AppColors.softCharcoalLight,
                          fontWeight: hasMyReaction
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ] else if (hasMyReaction) ...[
                      const SizedBox(width: AppDimensions.spacingXS),
                      Text(
                        'You',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.sageGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimestamp(ChatMessage message, bool isFromMe) {
    return Container(
      margin: EdgeInsets.only(
        left: isFromMe ? 80.0 : AppDimensions.paddingM,
        right: isFromMe ? AppDimensions.paddingM : 80.0,
        top: AppDimensions.spacingXS,
        bottom: AppDimensions.spacingS,
      ),
      child: FTFadeIn(
        child: Text(
          message.statusText,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.softCharcoalLight,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }
}