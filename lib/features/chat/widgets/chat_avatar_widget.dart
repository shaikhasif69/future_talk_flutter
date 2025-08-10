import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/chat_conversation.dart';
import 'social_battery_indicator.dart';

/// Individual chat avatar with gradient background and social battery indicator
class ChatAvatarWidget extends StatelessWidget {
  const ChatAvatarWidget({
    super.key,
    required this.participant,
    this.size = 52.0,
    this.showSocialBattery = true,
    this.onTap,
  });

  final ChatParticipant participant;
  final double size;
  final bool showSocialBattery;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: [
            // Avatar circle with gradient
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    participant.avatarColor,
                    participant.avatarColor.withValues(alpha:  0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: participant.avatarColor.withValues(alpha:  0.2),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  participant.initials,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.pearlWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: size * 0.35, // Responsive font size
                  ),
                ),
              ),
            ),
            
            // Social battery indicator
            if (showSocialBattery && participant.socialBattery != null)
              Positioned(
                bottom: -2,
                right: -2,
                child: SocialBatteryIndicator(
                  status: participant.socialBattery!,
                  size: size * 0.28, // Proportional to avatar size
                  showPulse: true,
                  borderWidth: 2.0,
                  borderColor: AppColors.pearlWhite,
                ),
              ),
            
            // Online indicator (small green dot)
            if (participant.isOnline && (participant.socialBattery == null || !showSocialBattery))
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.25,
                  decoration: BoxDecoration(
                    color: AppColors.sageGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.pearlWhite,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Group chat avatar with emoji and group indicator
class GroupAvatarWidget extends StatelessWidget {
  const GroupAvatarWidget({
    super.key,
    required this.conversation,
    this.size = 52.0,
    this.onTap,
  });

  final ChatConversation conversation;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: [
            // Avatar circle with gradient
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: conversation.avatarGradient,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: conversation.avatarGradient.first.withValues(alpha:  0.2),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  conversation.avatarEmoji ?? '👥',
                  style: TextStyle(
                    fontSize: size * 0.4, // Responsive emoji size
                  ),
                ),
              ),
            ),
            
            // Group indicator badge
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  color: AppColors.sageGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.pearlWhite,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    '👥',
                    style: TextStyle(
                      fontSize: size * 0.18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated avatar that scales on interaction
class AnimatedChatAvatar extends StatefulWidget {
  const AnimatedChatAvatar({
    super.key,
    required this.conversation,
    this.size = 52.0,
    this.onTap,
  });

  final ChatConversation conversation;
  final double size;
  final VoidCallback? onTap;

  @override
  State<AnimatedChatAvatar> createState() => _AnimatedChatAvatarState();
}

class _AnimatedChatAvatarState extends State<AnimatedChatAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDurations.buttonPress,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.conversation.participants.length == 1
                ? ChatAvatarWidget(
                    participant: widget.conversation.otherParticipant!,
                    size: widget.size,
                  )
                : GroupAvatarWidget(
                    conversation: widget.conversation,
                    size: widget.size,
                  ),
          );
        },
      ),
    );
  }
}

/// Avatar with status overlay for detailed view
class ChatAvatarWithStatus extends StatelessWidget {
  const ChatAvatarWithStatus({
    super.key,
    required this.conversation,
    this.size = 72.0,
    this.showOnlineStatus = true,
    this.showLastSeen = true,
    this.onTap,
  });

  final ChatConversation conversation;
  final double size;
  final bool showOnlineStatus;
  final bool showLastSeen;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        if (conversation.participants.length == 1)
          ChatAvatarWidget(
            participant: conversation.otherParticipant!,
            size: size,
            onTap: onTap,
          )
        else
          GroupAvatarWidget(
            conversation: conversation,
            size: size,
            onTap: onTap,
          ),
        
        const SizedBox(height: AppDimensions.spacingS),
        
        // Status information
        if (conversation.participants.length == 1 && showOnlineStatus) ...[
          Text(
            conversation.otherParticipant!.isOnline ? 'Online' : 'Offline',
            style: AppTextStyles.labelSmall.copyWith(
              color: conversation.otherParticipant!.isOnline
                  ? AppColors.sageGreen
                  : AppColors.softCharcoalLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          if (showLastSeen && 
              !conversation.otherParticipant!.isOnline && 
              conversation.otherParticipant!.lastSeen != null)
            Text(
              conversation.otherParticipant!.onlineStatusText,
              style: AppTextStyles.labelSmall,
            ),
        ],
        
        if (conversation.isGroup) ...[
          Text(
            conversation.memberCountText,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
          Text(
            '${conversation.participants.where((p) => p.isOnline).length} online',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.sageGreen,
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact avatar for lists and small spaces
class CompactChatAvatar extends StatelessWidget {
  const CompactChatAvatar({
    super.key,
    required this.conversation,
    this.size = 32.0,
    this.onTap,
  });

  final ChatConversation conversation;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: conversation.avatarGradient,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: conversation.participants.length == 1
              ? Text(
                  conversation.otherParticipant?.initials ?? '?',
                  style: TextStyle(
                    color: AppColors.pearlWhite,
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  conversation.avatarEmoji ?? '👥',
                  style: TextStyle(
                    fontSize: size * 0.4,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Avatar grid for showing multiple participants
class ParticipantAvatarGrid extends StatelessWidget {
  const ParticipantAvatarGrid({
    super.key,
    required this.participants,
    this.maxAvatars = 4,
    this.avatarSize = 28.0,
    this.spacing = 4.0,
  });

  final List<ChatParticipant> participants;
  final int maxAvatars;
  final double avatarSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final displayParticipants = participants.take(maxAvatars).toList();
    final hasMore = participants.length > maxAvatars;
    
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        ...displayParticipants.map((participant) {
          return Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  participant.avatarColor,
                  participant.avatarColor.withValues(alpha:  0.7),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.pearlWhite,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                participant.initials,
                style: TextStyle(
                  color: AppColors.pearlWhite,
                  fontSize: avatarSize * 0.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
        
        // "More" indicator
        if (hasMore)
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: AppColors.softCharcoalLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.pearlWhite,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                '+${participants.length - maxAvatars}',
                style: TextStyle(
                  color: AppColors.pearlWhite,
                  fontSize: avatarSize * 0.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}