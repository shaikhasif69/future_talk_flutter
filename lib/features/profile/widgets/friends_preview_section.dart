import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/profile_data.dart';
import '../../chat/models/social_battery_status.dart';

/// Friends preview section showing close friends with social battery indicators
/// Features horizontal scrollable list with beautiful avatars and animations
class FriendsPreviewSection extends StatelessWidget {
  final List<ProfileFriend> friends;
  final int maxVisible;
  final VoidCallback? onViewAllPressed;
  final Function(ProfileFriend)? onFriendTapped;
  final EdgeInsetsGeometry? margin;

  const FriendsPreviewSection({
    super.key,
    required this.friends,
    this.maxVisible = 5,
    this.onViewAllPressed,
    this.onFriendTapped,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final displayFriends = friends.take(maxVisible - 1).toList();
    final remainingCount = friends.length - displayFriends.length;
    
    return Container(
      margin: margin ?? EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsivePadding(screenWidth),
      ).copyWith(bottom: AppDimensions.spacingL),
      child: FTCard.elevated(
        child: Column(
          children: [
            _buildFriendsHeader(),
            SizedBox(height: AppDimensions.spacingL),
            _buildFriendsList(displayFriends, remainingCount),
          ],
        ),
      ),
    ).animate(delay: 800.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildFriendsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              '👥',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: AppDimensions.spacingS),
            Text(
              'Close Friends',
              style: AppTextStyles.headlineSmall.copyWith(
                fontFamily: AppTextStyles.headingFont,
                color: AppColors.softCharcoal,
              ),
            ),
          ],
        ),
        
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingS,
            vertical: AppDimensions.spacingXS,
          ),
          decoration: BoxDecoration(
            color: AppColors.sageGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Text(
            '${friends.length} friends',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.sageGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsList(List<ProfileFriend> displayFriends, int remainingCount) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXS),
      child: Row(
        children: [
          // Display friends
          ...displayFriends.asMap().entries.map((entry) {
            final index = entry.key;
            final friend = entry.value;
            
            return Padding(
              padding: EdgeInsets.only(
                right: AppDimensions.spacingM,
                left: index == 0 ? 0 : 0,
              ),
              child: FriendAvatarItem(
                friend: friend,
                onTap: () => onFriendTapped?.call(friend),
                animationDelay: index * 100,
              ),
            );
          }),
          
          // More friends indicator
          if (remainingCount > 0)
            MoreFriendsIndicator(
              count: remainingCount,
              onTap: onViewAllPressed,
              animationDelay: displayFriends.length * 100,
            ),
        ],
      ),
    );
  }
}

/// Individual friend avatar with social battery indicator
class FriendAvatarItem extends StatefulWidget {
  final ProfileFriend friend;
  final VoidCallback? onTap;
  final int animationDelay;

  const FriendAvatarItem({
    super.key,
    required this.friend,
    this.onTap,
    this.animationDelay = 0,
  });

  @override
  State<FriendAvatarItem> createState() => _FriendAvatarItemState();
}

class _FriendAvatarItemState extends State<FriendAvatarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _batteryPulseAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.elasticOut,
    ));
    
    _batteryPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHoverEnter() {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  Color _getBatteryColor() {
    switch (widget.friend.batteryLevel) {
      case SocialBatteryLevel.energized:
        return AppColors.sageGreen;
      case SocialBatteryLevel.selective:
        return AppColors.warmPeach;
      case SocialBatteryLevel.recharging:
        return AppColors.dustyRose;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHoverEnter(),
      onExit: (_) => _handleHoverExit(),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      // Friend avatar
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: widget.friend.avatarGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: _isHovered ? 12 : 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.friend.avatarInitials,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      // Social battery indicator
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: AnimatedBuilder(
                          animation: _batteryPulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _batteryPulseAnimation.value,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _getBatteryColor(),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getBatteryColor().withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Online indicator
                      if (widget.friend.isOnline)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.sageGreen,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ).animate(delay: Duration(milliseconds: widget.animationDelay + 200))
                           .fadeIn(duration: 600.ms)
                           .scale(begin: const Offset(0.5, 0.5)),
                        ),
                    ],
                  ),
                  
                  SizedBox(height: AppDimensions.spacingS),
                  
                  // Friend name
                  Text(
                    widget.friend.name,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.softCharcoal,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.animationDelay))
     .fadeIn(duration: 600.ms)
     .slideY(begin: 0.3);
  }
}

/// More friends indicator showing remaining count
class MoreFriendsIndicator extends StatefulWidget {
  final int count;
  final VoidCallback? onTap;
  final int animationDelay;

  const MoreFriendsIndicator({
    super.key,
    required this.count,
    this.onTap,
    this.animationDelay = 0,
  });

  @override
  State<MoreFriendsIndicator> createState() => _MoreFriendsIndicatorState();
}

class _MoreFriendsIndicatorState extends State<MoreFriendsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHoverEnter() {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHoverEnter(),
      onExit: (_) => _handleHoverExit(),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.whisperGray,
                          AppColors.stoneGray.withValues(alpha: 0.5),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.sageGreen.withValues(alpha: 0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: _isHovered ? 12 : 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '+${widget.count}',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.sageGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: AppDimensions.spacingS),
                  
                  Text(
                    'View all',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.sageGreen,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.animationDelay))
     .fadeIn(duration: 600.ms)
     .slideY(begin: 0.3);
  }
}

/// Compact friends count widget for other contexts
class CompactFriendsCount extends StatelessWidget {
  final int friendsCount;
  final VoidCallback? onTap;

  const CompactFriendsCount({
    super.key,
    required this.friendsCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: AppDimensions.spacingXS,
        ),
        decoration: BoxDecoration(
          color: AppColors.sageGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.sageGreen.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '👥',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(width: AppDimensions.spacingXS),
            Text(
              '$friendsCount friends',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.sageGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full friends list dialog for viewing all friends
class FriendsListDialog extends StatelessWidget {
  final List<ProfileFriend> friends;
  final Function(ProfileFriend)? onFriendTapped;

  const FriendsListDialog({
    super.key,
    required this.friends,
    this.onFriendTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FTCard.elevated(
        padding: const EdgeInsets.all(AppDimensions.spacingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Close Friends',
              style: AppTextStyles.headlineSmall.copyWith(
                fontFamily: AppTextStyles.headingFont,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingL),
            
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: friends.map((friend) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: friend.avatarGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              friend.avatarInitials,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          friend.name,
                          style: AppTextStyles.titleMedium,
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getBatteryColor(friend.batteryLevel),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: AppDimensions.spacingXS),
                            Text(
                              _getBatteryLabel(friend.batteryLevel),
                              style: AppTextStyles.labelSmall,
                            ),
                            if (friend.isOnline) ...[
                              SizedBox(width: AppDimensions.spacingS),
                              Text(
                                '• Online',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.sageGreen,
                                ),
                              ),
                            ],
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          onFriendTapped?.call(friend);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingL),
            
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    ).animate()
     .fadeIn(duration: 300.ms)
     .scale(begin: const Offset(0.8, 0.8));
  }

  Color _getBatteryColor(SocialBatteryLevel level) {
    switch (level) {
      case SocialBatteryLevel.energized:
        return AppColors.sageGreen;
      case SocialBatteryLevel.selective:
        return AppColors.warmPeach;
      case SocialBatteryLevel.recharging:
        return AppColors.dustyRose;
    }
  }

  String _getBatteryLabel(SocialBatteryLevel level) {
    switch (level) {
      case SocialBatteryLevel.energized:
        return 'Energized';
      case SocialBatteryLevel.selective:
        return 'Selective';
      case SocialBatteryLevel.recharging:
        return 'Recharging';
    }
  }

  static Future<void> show(
    BuildContext context, {
    required List<ProfileFriend> friends,
    Function(ProfileFriend)? onFriendTapped,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => FriendsListDialog(
        friends: friends,
        onFriendTapped: onFriendTapped,
      ),
    );
  }
}