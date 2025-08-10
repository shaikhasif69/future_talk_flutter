import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/animations/ft_fade_in.dart';
import '../models/chat_conversation.dart';
import '../providers/realtime_individual_chat_provider.dart';
/// Premium chat header with social battery awareness and smooth animations
class ChatHeader extends StatefulWidget {
  const ChatHeader({
    super.key,
    required this.conversation,
    required this.provider,
    required this.onBackPressed,
    this.onConnectionStonesPressed,
    this.onSettingsPressed,
  });

  final ChatConversation conversation;
  final RealtimeIndividualChatProvider provider;
  final VoidCallback onBackPressed;
  final VoidCallback? onConnectionStonesPressed;
  final VoidCallback? onSettingsPressed;

  @override
  State<ChatHeader> createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start pulsing animation for battery indicator
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    HapticFeedback.lightImpact();
    widget.onBackPressed();
  }

  void _onConnectionStonesPressed() {
    HapticFeedback.lightImpact();
    widget.onConnectionStonesPressed?.call();
  }

  void _onSettingsPressed() {
    HapticFeedback.lightImpact();
    widget.onSettingsPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.sageGreenWithOpacity(0.08),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingM,
          ),
          child: Row(
            children: [
              // Back Button
              _buildBackButton(),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // Friend Info
              Expanded(
                child: _buildFriendInfo(),
              ),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // Header Actions
              _buildHeaderActions(),
            ],
          ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: AppColors.sageGreenWithOpacity(0.1),
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: InkWell(
        onTap: _onBackPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.sageGreen,
            size: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFriendInfo() {
    final otherParticipant = widget.conversation.otherParticipant;
    if (otherParticipant == null) return const SizedBox.shrink();

    return Row(
      children: [
        // Friend Avatar with Battery Indicator
        _buildFriendAvatar(otherParticipant),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        // Friend Details
        Expanded(
          child: _buildFriendDetails(otherParticipant),
        ),
      ],
    );
  }

  Widget _buildFriendAvatar(ChatParticipant participant) {
    final socialBattery = participant.socialBattery;
    
    return Stack(
      children: [
        // Main Avatar
        Container(
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                participant.avatarColor,
                participant.avatarColor.withAlpha(179),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: participant.avatarColor.withAlpha(77),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              participant.initials,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.pearlWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        // Social Battery Indicator
        if (socialBattery != null)
          Positioned(
            bottom: -2,
            right: -2,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: socialBattery.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.pearlWhite,
                        width: 3.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: socialBattery.color.withAlpha(102),
                          blurRadius: 4.0,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFriendDetails(ChatParticipant participant) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Friend Name
            Text(
              participant.name,
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 2.0),
            
            // Status Row
            _buildStatusRow(),
          ],
        );
      },
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        // Online Indicator
        _buildOnlineIndicator(),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        // Typing Indicator
        if (widget.provider.isOtherUserTyping)
          _buildTypingIndicator(),
      ],
    );
  }

  Widget _buildOnlineIndicator() {
    final isOnline = widget.provider.isOtherUserOnline;
    final socialBattery = widget.provider.otherUserSocialBattery;
    
    return FTFadeIn(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: 2.0,
        ),
        decoration: BoxDecoration(
          color: isOnline 
              ? AppColors.success.withAlpha(26)
              : AppColors.softCharcoalWithOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.spacingS),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Dot
            Container(
              width: 6.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: isOnline 
                    ? (socialBattery?.color ?? AppColors.success)
                    : AppColors.softCharcoalLight,
                shape: BoxShape.circle,
              ),
            ),
            
            const SizedBox(width: 4.0),
            
            // Status Text
            Text(
              widget.provider.otherUserStatusText,
              style: AppTextStyles.labelSmall.copyWith(
                color: isOnline 
                    ? (socialBattery?.color ?? AppColors.success)
                    : AppColors.softCharcoalLight,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return FTFadeIn(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.sageGreenWithOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'typing',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.sageGreen,
                fontStyle: FontStyle.italic,
                fontSize: 10.0,
              ),
            ),
            
            const SizedBox(width: 4.0),
            
            // Animated Dots
            _buildTypingDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDots() {
    return SizedBox(
      width: 16.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final delay = index * 0.2;
              final animationValue = (_pulseController.value + delay) % 1.0;
              final scale = 0.5 + (0.5 * (1 - (animationValue - 0.5).abs() * 2).clamp(0.0, 1.0));
              
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 3.0,
                  height: 3.0,
                  decoration: const BoxDecoration(
                    color: AppColors.sageGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Connection Stones Button
        _buildActionButton(
          icon: '🪨',
          tooltip: 'Connection Stones',
          onPressed: _onConnectionStonesPressed,
        ),
        
        const SizedBox(width: AppDimensions.spacingS),
        
        // Settings Button
        _buildActionButton(
          icon: Icons.settings_outlined,
          tooltip: 'Chat Settings',
          onPressed: _onSettingsPressed,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    dynamic icon,
    required String tooltip,
    VoidCallback? onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.sageGreenWithOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Center(
              child: icon is String
                  ? Text(
                      icon,
                      style: const TextStyle(fontSize: 16.0),
                    )
                  : Icon(
                      icon as IconData,
                      color: AppColors.sageGreen,
                      size: 20.0,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

