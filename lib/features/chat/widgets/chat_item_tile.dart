import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
// import 'chat_avatar_widget.dart'; // Not needed - using custom avatar

/// Premium chat item tile with rich interactions and introvert-friendly design
/// Features staggered animations, social battery awareness, and gentle notifications
class ChatItemTile extends StatefulWidget {
  const ChatItemTile({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onLongPress,
  });

  final ChatConversation conversation;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  State<ChatItemTile> createState() => _ChatItemTileState();
}

class _ChatItemTileState extends State<ChatItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: AppDurations.buttonPress,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.01, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    
    // Gentle haptic feedback
    HapticFeedback.selectionClick();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleLongPress() {
    // Stronger haptic feedback for long press
    HapticFeedback.mediumImpact();
    widget.onLongPress?.call();
  }

  /// Format time exactly like HTML reference (9:28 AM format)
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      // Today - show time like "9:28 AM"
      final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final amPm = dateTime.hour < 12 ? 'AM' : 'PM';
      return '$hour:$minute $amPm';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day name
      const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      return days[dateTime.weekday % 7];
    } else {
      return 'Last week';
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏗️ [ChatItemTile] Building tile for: ${widget.conversation.displayName}');
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildTileContent(),
          ),
        );
      },
    );
  }

  Widget _buildTileContent() {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: _handleLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: _isPressed 
              ? AppColors.sageGreen.withValues(alpha:  0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: _isPressed ? Border.all(
            color: AppColors.sageGreen.withValues(alpha:  0.1),
            width: 1.0,
          ) : null,
        ),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            
            const SizedBox(width: AppDimensions.spacingM),
            
            // Content
            Expanded(
              child: _buildContent(),
            ),
            
            // Trailing indicators
            _buildTrailing(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    debugPrint('🎨 [ChatItemTile] Building avatar for conversation: ${widget.conversation.id}');
    
    return Stack(
      children: [
        // Main avatar
        Container(
          width: 52.0,
          height: 52.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.conversation.avatarGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.sageGreen.withValues(alpha: 0.2),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: widget.conversation.isGroup
                ? Text(
                    widget.conversation.avatarEmoji ?? '👥',
                    style: const TextStyle(fontSize: 24.0),
                  )
                : Text(
                    widget.conversation.otherParticipant?.initials ?? '?',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.pearlWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
          ),
        ),
        
        // Social battery indicator for individual chats (matches HTML exactly)
        if (!widget.conversation.isGroup && widget.conversation.socialBattery != null)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: widget.conversation.socialBattery!.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.pearlWhite,
                  width: 2.0,
                ),
              ),
            ).animate().fadeIn().scaleXY(
              begin: 0.0,
              curve: Curves.easeOutBack,
              duration: AppDurations.fast,
            ),
          ),
        
        // Group indicator (matches HTML design)
        if (widget.conversation.isGroup)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 18.0,
              height: 18.0,
              decoration: BoxDecoration(
                color: AppColors.sageGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.pearlWhite,
                  width: 2.0,
                ),
              ),
              child: const Center(
                child: Text(
                  '👥',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    debugPrint('📋 [ChatItemTile] Building content for: ${widget.conversation.displayName}');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chat header row (name and timestamp) - exactly matching HTML structure
        Row(
          children: [
            // Name section with indicators
            Expanded(
              child: Row(
                children: [
                  // Pinned indicator (matching HTML 📌 pin)
                  if (widget.conversation.isPinned) ...[
                    Icon(
                      Icons.push_pin,
                      size: 12.0,
                      color: AppColors.sageGreen.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4.0),
                  ],
                  
                  // Conversation name (matching HTML chat-name)
                  Flexible(
                    child: Text(
                      widget.conversation.displayName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: widget.conversation.hasUnreadMessages 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        color: widget.conversation.isMuted 
                            ? AppColors.softCharcoalLight.withValues(alpha: 0.6)
                            : AppColors.softCharcoal,
                        fontSize: 16.0, // Match HTML font-size
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Group member count indicator (matching HTML group-indicator)
                  if (widget.conversation.isGroup) ...[
                    const SizedBox(width: 6.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lavenderMist.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        widget.conversation.memberCountText,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.softCharcoalLight,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Timestamp (matching HTML chat-time)
            Text(
              _formatTime(widget.conversation.lastMessage?.createdAt),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.softCharcoalLight,
                fontWeight: widget.conversation.hasUnreadMessages 
                    ? FontWeight.w500 
                    : FontWeight.w400,
                fontSize: 12.0, // Match HTML font-size
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 4.0),
        
        // Chat preview row (message and indicators) - matching HTML structure
        Row(
          children: [
            // Last message preview (matching HTML last-message)
            Expanded(
              child: _buildLastMessage(),
            ),
            
            // Message status and notification indicators
            _buildMessageIndicators(),
          ],
        ),
      ],
    );
  }

  Widget _buildLastMessage() {
    final lastMessage = widget.conversation.lastMessage;
    
    debugPrint('💬 [ChatItemTile] Building last message for conversation: ${widget.conversation.id}');
    debugPrint('💬 [ChatItemTile] Last message content: ${lastMessage?.content}');
    debugPrint('💬 [ChatItemTile] Is from me: ${lastMessage?.isFromMe}');
    debugPrint('💬 [ChatItemTile] Sender username: ${lastMessage?.senderUsername}');
    
    // Get message content - exactly like HTML reference
    String displayText = lastMessage?.content ?? 'No messages yet';
    
    // For group chats, show sender name prefix (matching HTML pattern)
    if (widget.conversation.isGroup && lastMessage != null && !(lastMessage.isFromMe)) {
      final senderName = lastMessage.senderUsername ?? 'Unknown';
      displayText = '$senderName: $displayText';
    }
    
    // Handle special message types (matching HTML examples)
    if (lastMessage != null) {
      switch (lastMessage.messageType) {
        case MessageType.voice:
          displayText = '🎵 Voice message';
          break;
        case MessageType.image:
          displayText = '📷 Photo';
          break;
        case MessageType.video:
          displayText = '🎥 Video';
          break;
        case MessageType.text:
          // Keep the text as is
          break;
      }
    }
    
    return Text(
      displayText,
      style: AppTextStyles.bodyMedium.copyWith(
        color: widget.conversation.hasUnreadMessages 
            ? AppColors.softCharcoal
            : AppColors.softCharcoalLight,
        fontWeight: widget.conversation.hasUnreadMessages 
            ? FontWeight.w500 
            : FontWeight.w400,
        fontFamily: 'Nunito Sans', // Match HTML font family
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMessageIndicators() {
    final lastMessage = widget.conversation.lastMessage;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Message status (for sent messages)
        if (lastMessage?.isFromMe == true) ...[
          Icon(
            _getStatusIcon(lastMessage!.status),
            size: 14.0,
            color: _getStatusColor(lastMessage.status),
          ),
          const SizedBox(width: 4.0),
        ],
        
        // Unread count badge
        if (widget.conversation.hasUnreadMessages)
          _buildUnreadBadge(),
      ],
    );
  }

  Widget _buildUnreadBadge() {
    final shouldShowGentle = widget.conversation.shouldShowGentleNotifications;
    
    return Container(
      constraints: const BoxConstraints(minWidth: 20.0),
      height: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: shouldShowGentle 
            ? AppColors.sageGreen.withValues(alpha:  0.2)
            : AppColors.sageGreen,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          widget.conversation.unreadCountText,
          style: AppTextStyles.labelSmall.copyWith(
            color: shouldShowGentle 
                ? AppColors.sageGreen
                : AppColors.pearlWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ).animate().fadeIn().scaleXY(
      begin: 0.0,
      curve: Curves.easeOutBack,
      duration: AppDurations.fast,
    );
  }

  Widget _buildTrailing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Muted indicator (matching HTML 🔇 muted icon)
        if (widget.conversation.isMuted)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Icon(
              Icons.volume_off,
              size: 16.0,
              color: AppColors.softCharcoalLight.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.done;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error;
      case MessageStatus.received:
        return Icons.done; // Placeholder, not usually shown
    }
  }

  Color _getStatusColor(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return AppColors.softCharcoalLight;
      case MessageStatus.sent:
        return AppColors.softCharcoalLight;
      case MessageStatus.delivered:
        return AppColors.softCharcoalLight;
      case MessageStatus.read:
        return AppColors.sageGreen;
      case MessageStatus.failed:
        return AppColors.error;
      case MessageStatus.received:
        return AppColors.softCharcoalLight; // Placeholder, not usually shown
    }
  }
}

/// Compact chat item tile for smaller layouts
class CompactChatItemTile extends StatelessWidget {
  const CompactChatItemTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final ChatConversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          child: Row(
            children: [
              // Compact avatar
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: conversation.avatarGradient,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: conversation.participants.length == 1
                      ? Text(
                          conversation.otherParticipant?.initials ?? '?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.pearlWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Text(
                          conversation.avatarEmoji ?? '👥',
                          style: AppTextStyles.bodyMedium,
                        ),
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.displayName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: conversation.hasUnreadMessages 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      conversation.lastMessage?.contentPreview ?? 'No message',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Unread indicator
              if (conversation.hasUnreadMessages)
                Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: const BoxDecoration(
                    color: AppColors.sageGreen,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}