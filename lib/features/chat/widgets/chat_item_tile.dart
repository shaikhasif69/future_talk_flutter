import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/chat_conversation.dart';
import 'chat_avatar_widget.dart';

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

  @override
  Widget build(BuildContext context) {
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
              ? AppColors.sageGreen.withOpacity( 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: _isPressed ? Border.all(
            color: AppColors.sageGreen.withOpacity( 0.1),
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
    if (widget.conversation.isIndividual) {
      return ChatAvatarWidget(
        participant: widget.conversation.otherParticipant!,
        size: 52.0,
        showSocialBattery: true,
      );
    } else {
      return GroupAvatarWidget(
        conversation: widget.conversation,
        size: 52.0,
      );
    }
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and timestamp row
        Row(
          children: [
            // Name with group indicator
            Expanded(
              child: Row(
                children: [
                  // Pinned indicator
                  if (widget.conversation.isPinned) ...[
                    Icon(
                      Icons.push_pin,
                      size: 12.0,
                      color: AppColors.sageGreen.withOpacity( 0.7),
                    ),
                    const SizedBox(width: 4.0),
                  ],
                  
                  // Name
                  Flexible(
                    child: Text(
                      widget.conversation.displayName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: widget.conversation.hasUnreadMessages 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        color: widget.conversation.isMuted 
                            ? AppColors.softCharcoalLight
                            : AppColors.softCharcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Group member count
                  if (widget.conversation.isGroup) ...[
                    const SizedBox(width: AppDimensions.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lavenderMist.withOpacity( 0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        widget.conversation.memberCountText,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.softCharcoalLight,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Timestamp
            Text(
              widget.conversation.lastMessage.formattedTime,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.softCharcoalLight,
                fontWeight: widget.conversation.hasUnreadMessages 
                    ? FontWeight.w500 
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 4.0),
        
        // Last message and indicators row
        Row(
          children: [
            // Last message
            Expanded(
              child: _buildLastMessage(),
            ),
            
            // Message status and count
            _buildMessageIndicators(),
          ],
        ),
      ],
    );
  }

  Widget _buildLastMessage() {
    final lastMessage = widget.conversation.lastMessage;
    
    // Show sender name for group chats
    String displayText = lastMessage.previewText;
    if (widget.conversation.isGroup && !lastMessage.isFromMe) {
      displayText = '${lastMessage.senderName}: ${lastMessage.previewText}';
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
        if (lastMessage.isFromMe) ...[
          Icon(
            _getStatusIcon(lastMessage.status),
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
            ? AppColors.sageGreen.withOpacity( 0.2)
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
        // Muted indicator
        if (widget.conversation.isMuted)
          Icon(
            Icons.volume_off,
            size: 16.0,
            color: AppColors.softCharcoalLight.withOpacity( 0.7),
          ),
        
        // Social battery quick indicator (for individual chats)
        if (widget.conversation.isIndividual && 
            widget.conversation.socialBattery != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: widget.conversation.socialBattery!.color,
                shape: BoxShape.circle,
              ),
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
                  child: conversation.isIndividual
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
                      conversation.lastMessage.previewText,
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